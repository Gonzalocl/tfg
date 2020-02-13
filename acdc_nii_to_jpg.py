import os
import pandas as pd
import nibabel as nib
import numpy as np
from PIL import Image
import tensorflow as tf

path="training"
output_dir="acdc"

def read_info(file_path):
  info = pd.read_csv(file_path, sep=":", header=None, index_col=0, skipinitialspace=True)
  result = {
    'label': info.loc['Group'][1]
  }
  return result

graph = tf.Graph()
with graph.as_default():
  frame_input = tf.placeholder(dtype=tf.float64)
  frame_min = tf.reduce_min(frame_input)
  frame_max = tf.reduce_max(frame_input)
  frame_adjust = frame_input - frame_min
  frame_max = frame_max - frame_min
  frame = frame_adjust / frame_max
  frame_scaled = frame*255

tf.gfile.MkDir(output_dir)

sub_dirs = sorted(x[0] for x in tf.gfile.Walk(path))
# The root directory comes first, so skip it.
is_root_dir = True
for sub_dir in sub_dirs:
  if is_root_dir:
    is_root_dir = False
    continue
  base_name = os.path.basename(sub_dir)
  path_info = os.path.join(sub_dir, "Info.cfg")
  info = read_info(path_info)
  label = info['label']
  path_label = os.path.join(output_dir, label)
  tf.gfile.MkDir(path_label)
  tf.gfile.Copy(path_info, os.path.join(path_label, "{}.cfg".format(base_name)))
  path = os.path.join(sub_dir, '{}_4d.nii.gz'.format(base_name))
  img = nib.load(path)
  data = img.get_fdata()
  data = np.transpose(data, (3, 2, 1, 0))
  with open(os.path.join(path_label, "{}.shape".format(base_name)), "w") as f:
    print("Frames: {}\nSlices: {}\nWidth: {}\nHeight: {}".format(data.shape[0], data.shape[1], data.shape[2], data.shape[3]), file=f)
  pixels = np.zeros((data.shape[2], data.shape[3], 3)).astype(np.uint8)
  for f in range(data.shape[0]):
    for s in range(data.shape[1]):
      with tf.Session(graph=graph) as sess:
        scaled_data = sess.run(frame_scaled, feed_dict={frame_input: data[f][s]})
      for i in range(data.shape[2]):
        for j in range(data.shape[3]):
          pixels[i][j] = scaled_data[i][j]
      file_name = os.path.join(path_label, "{}_nohash_frame{:02d}_slice{:02d}.jpg".format(base_name, f, s))
      Image.fromarray(pixels).save(file_name)
      print(file_name)


