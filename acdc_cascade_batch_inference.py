
import argparse
import collections
import os.path
import sys

import tensorflow as tf
import tensorflow_hub as hub
from tensorflow.python.saved_model import tag_constants

from acdc_subset_retrain import add_jpeg_decoding
from acdc_subset_retrain import create_image_lists

def get_lab(result, labels):
  max = result[0]
  index_max = 0
  for i in range(len(result)):
    if result[i] > max:
      max = result[i]
      index_max = i
  return labels[index_max]

def load_graphs(subsets_list, main_dir, saved_model_dir, tfhub_module, output_labels):
  graphs = {
    'graph': [],
    'sess': [],
    'image': [],
    'prediction': [],
    'jpeg_data_tensor': [],
    'decoded_image_tensor': [],
    'labels': [],
    'is_last_step': []
  }
  for subsets in subsets_list:
    subset_name = subsets.replace(":", "_").replace(",", "-")
    model_full_path = os.path.join(main_dir, "retrain_subset_{}".format(subset_name), saved_model_dir)
    labels_full_path = os.path.join(main_dir, "retrain_subset_{}".format(subset_name), output_labels)
    with open(labels_full_path) as f:
      labels = f.readlines()
    labels = [l.strip() for l in labels]
    print("Loading model: {}".format(model_full_path))
    with tf.Graph().as_default() as graph:
      with tf.Session(graph=graph).as_default() as sess:
        tf.saved_model.loader.load(
          sess,
          [tag_constants.SERVING],
          model_full_path
        )
        # resized_input_tensor
        image = graph.get_tensor_by_name('Placeholder:0')
        prediction = graph.get_tensor_by_name('final_result:0')

        module_spec = hub.load_module_spec(tfhub_module)
        jpeg_data_tensor, decoded_image_tensor = add_jpeg_decoding(module_spec)

        graphs['graph'].append(graph)
        graphs['sess'].append(sess)
        graphs['image'].append(image)
        graphs['prediction'].append(prediction)
        graphs['jpeg_data_tensor'].append(jpeg_data_tensor)
        graphs['decoded_image_tensor'].append(decoded_image_tensor)
        graphs['labels'].append(labels)
        graphs['is_last_step'].append(False)
  graphs['is_last_step'][-1] = True
  return graphs

def cascade_inference(graphs, image_path):
  image_data = tf.gfile.GFile(image_path, 'rb').read()
  for graph, sess, image, prediction, jpeg_data_tensor, decoded_image_tensor, labels, is_last_step in zip(graphs['graph'], graphs['sess'], graphs['image'], graphs['prediction'], graphs['jpeg_data_tensor'], graphs['decoded_image_tensor'], graphs['labels'], graphs['is_last_step']):
    with graph.as_default():
      with sess.as_default():
        resized_image = sess.run(decoded_image_tensor,
                                 {jpeg_data_tensor: image_data})
        result = sess.run(prediction,
                          {image: resized_image})
        label = get_lab(result[0], labels)
        if is_last_step or label == labels[0]:
          return label

def main(_):

  subsets_list = ["RV:DCM,HCM,MINF,NOR", "DCM:HCM,MINF,NOR", "MINF:HCM,NOR", "HCM:NOR"]

  graphs = load_graphs(subsets_list, FLAGS.main_dir, FLAGS.saved_model_dir, FLAGS.tfhub_module, FLAGS.output_labels)

  image_lists = create_image_lists(FLAGS.image_dir, FLAGS.subsets,
                                   FLAGS.testing_percentage, FLAGS.validation_percentage)
  hits = 0
  total = 0
  confusion_matirx = dict()

  output_predictions_file = open(FLAGS.output_predictions, "w")
  print("image_path,set,class,predicted_class", file=output_predictions_file)

  for image_class in image_lists:
    confusion_matirx[image_class] = collections.defaultdict(int)
    for image_set in FLAGS.set:
      for image_filename in image_lists[image_class][image_set]:
        image_path = os.path.join(FLAGS.image_dir, image_filename)
        if not tf.gfile.Exists(image_path):
          tf.logging.fatal('File does not exist %s', image_path)
        predicted_class = cascade_inference(graphs, image_path)
        confusion_matirx[image_class][predicted_class] += 1
        print("{},{},{},{}".format(image_path, image_set, image_class, predicted_class), file=output_predictions_file)
        if image_class == predicted_class:
          hits = hits + 1
        total = total + 1

  output_predictions_file.close()
  print("Set: {}".format(" ".join(FLAGS.set)))
  print("Confusion Matrix")
  print("{:>15}".format(""), end="")
  for image_class in image_lists:
      print("{:>15}".format(image_class), end="")
  print()

  for image_class in image_lists:
      print("{:>15}".format(image_class), end="")
      for predicted_class in image_lists:
          print("{:>15}".format(confusion_matirx[image_class][predicted_class]), end="")
      print()
  accuracy = hits/total * 100
  print("Total Accuracy: {}% (N={})".format(accuracy, total))


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument(
      '--image_dir',
      type=str,
      default='',
      help='Path to folders of labeled images.'
  )
  parser.add_argument(
      '--output_graph',
      type=str,
      default='/tmp/output_graph.pb',
      help='Where to save the trained graph.'
  )
  parser.add_argument(
      '--intermediate_output_graphs_dir',
      type=str,
      default='/tmp/intermediate_graph/',
      help='Where to save the intermediate graphs.'
  )
  parser.add_argument(
      '--intermediate_store_frequency',
      type=int,
      default=0,
      help="""\
         How many steps to store intermediate graph. If "0" then will not
         store.\
      """
  )
  parser.add_argument(
      '--output_labels',
      type=str,
      default='/tmp/output_labels.txt',
      help='Where to save the trained graph\'s labels.'
  )
  parser.add_argument(
      '--summaries_dir',
      type=str,
      default='/tmp/retrain_logs',
      help='Where to save summary logs for TensorBoard.'
  )
  parser.add_argument(
      '--how_many_training_steps',
      type=int,
      default=4000,
      help='How many training steps to run before ending.'
  )
  parser.add_argument(
      '--learning_rate',
      type=float,
      default=0.01,
      help='How large a learning rate to use when training.'
  )
  parser.add_argument(
      '--testing_percentage',
      type=int,
      default=10,
      help='What percentage of images to use as a test set.'
  )
  parser.add_argument(
      '--validation_percentage',
      type=int,
      default=10,
      help='What percentage of images to use as a validation set.'
  )
  parser.add_argument(
      '--eval_step_interval',
      type=int,
      default=10,
      help='How often to evaluate the training results.'
  )
  parser.add_argument(
      '--train_batch_size',
      type=int,
      default=100,
      help='How many images to train on at a time.'
  )
  parser.add_argument(
      '--test_batch_size',
      type=int,
      default=-1,
      help="""\
      How many images to test on. This test set is only used once, to evaluate
      the final accuracy of the model after training completes.
      A value of -1 causes the entire test set to be used, which leads to more
      stable results across runs.\
      """
  )
  parser.add_argument(
      '--validation_batch_size',
      type=int,
      default=100,
      help="""\
      How many images to use in an evaluation batch. This validation set is
      used much more often than the test set, and is an early indicator of how
      accurate the model is during training.
      A value of -1 causes the entire validation set to be used, which leads to
      more stable results across training iterations, but may be slower on large
      training sets.\
      """
  )
  parser.add_argument(
      '--print_misclassified_test_images',
      default=False,
      help="""\
      Whether to print out a list of all misclassified test images.\
      """,
      action='store_true'
  )
  parser.add_argument(
      '--bottleneck_dir',
      type=str,
      default='/tmp/bottleneck',
      help='Path to cache bottleneck layer values as files.'
  )
  parser.add_argument(
      '--final_tensor_name',
      type=str,
      default='final_result',
      help="""\
      The name of the output classification layer in the retrained graph.\
      """
  )
  parser.add_argument(
      '--flip_left_right',
      default=False,
      help="""\
      Whether to randomly flip half of the training images horizontally.\
      """,
      action='store_true'
  )
  parser.add_argument(
      '--random_crop',
      type=int,
      default=0,
      help="""\
      A percentage determining how much of a margin to randomly crop off the
      training images.\
      """
  )
  parser.add_argument(
      '--random_scale',
      type=int,
      default=0,
      help="""\
      A percentage determining how much to randomly scale up the size of the
      training images by.\
      """
  )
  parser.add_argument(
      '--random_brightness',
      type=int,
      default=0,
      help="""\
      A percentage determining how much to randomly multiply the training image
      input pixels up or down by.\
      """
  )
  parser.add_argument(
      '--tfhub_module',
      type=str,
      default=(
          'https://tfhub.dev/google/imagenet/inception_v3/feature_vector/3'),
      help="""\
      Which TensorFlow Hub module to use. For more options,
      search https://tfhub.dev for image feature vector modules.\
      """)
  parser.add_argument(
      '--saved_model_dir',
      type=str,
      default='',
      help='Where to save the exported graph.')
  parser.add_argument(
      '--logging_verbosity',
      type=str,
      default='INFO',
      choices=['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'],
      help='How much logging output should be produced.')
  parser.add_argument(
      '--checkpoint_path',
      type=str,
      default='/tmp/_retrain_checkpoint',
      help='Where to save checkpoint files.'
  )
  parser.add_argument(
    '--subsets',
    type=str,
    default='',
    help='Group classes'
  )
  parser.add_argument(
    '--set',
    type=str,
    choices=['training', 'testing', 'validation'],
    nargs='+',
    default=['testing'],
    help='Sets to perform inference'
  )
  parser.add_argument(
    '--main_dir',
    type=str,
    default='',
    help='Main directory'
  )
  parser.add_argument(
    '--output_predictions',
    type=str,
    default='/tmp/output_predictions.csv',
    help='csv file to output predictions'
  )
  FLAGS, unparsed = parser.parse_known_args()
  tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)
