
import os
import argparse
import collections
import csv

def get_class(patient):
  patient_class_max = -1
  patient_class = 'None'
  for c in patient:
    if patient[c] > patient_class_max:
      patient_class_max = patient[c]
      patient_class = c
    elif patient[c] == patient_class_max:
      patient_class = "{}_{}".format(patient_class, c)
  return patient_class


def main():

  with open(args.output_predictions) as csv_file:
    reader = csv.DictReader(csv_file)

    per_patient_predicted_class = collections.defaultdict(lambda : collections.defaultdict(int))
    per_patient_class = dict()
    classes = set()
    patient_sets = set()

    for row in reader:

      patient = os.path.basename(row['image_path']).split('_')[0]
      patient_class = row['class']
      patient_predicted_class = row['predicted_class']
      patient_set = row['set']

      classes.add(patient_class)
      classes.add(patient_predicted_class)
      patient_sets.add(patient_set)

      per_patient_predicted_class[patient][patient_predicted_class] += 1
      per_patient_class[patient] = patient_class



    hits = 0
    total = 0
    confusion_matirx = collections.defaultdict(lambda : collections.defaultdict(int))

    for p in per_patient_predicted_class.keys():
      patient_class = per_patient_class[p]
      predicted_class = get_class(per_patient_predicted_class[p])

      confusion_matirx[patient_class][predicted_class] += 1
      if patient_class == predicted_class:
        hits = hits + 1
      total = total + 1

      print("{} {} {}".format(p, patient_class, predicted_class))

    print("Set: {}".format(" ".join(patient_sets)))
    print("Confusion Matrix")
    print("{:>15}".format(""), end="")
    for patient_class in classes:
        print("{:>15}".format(patient_class), end="")
    print()

    for patient_class in classes:
        print("{:>15}".format(patient_class), end="")
        for predicted_class in classes:
            print("{:>15}".format(confusion_matirx[patient_class][predicted_class]), end="")
        print()
    accuracy = hits/total * 100
    print("Total Accuracy: {}% (N={})".format(accuracy, total))



if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument(
    '--output_predictions',
    type=str,
    default='/tmp/output_predictions.csv',
    help='csv file to read predictions'
  )
  args, _ = parser.parse_known_args()
  main()
