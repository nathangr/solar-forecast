import sys
import pandas as pd

if len(sys.argv) < 2:
  print('Missing argument(s)')
  print('Usage: add_historical_data.py part3')

part3_filename = sys.argv[1]

part3_file = open(part3_filename, "r")

dataset = pd.read_csv(part3_file, encoding='utf-8')

# Get mean, min, and max solar energy per station-month-day
grouped = dataset.groupby(['stid', 'month', 'day']).agg({'solar_energy': ['mean', 'min', 'max']})
grouped.columns = ['solar_mean', 'solar_min', 'solar_max']
grouped = grouped.reset_index()

# Augment original dataframe with solar_energy mean, min and max
augmented = pd.merge(dataset, grouped, on=['stid', 'month', 'day'])

# Print out dataframe as CSV but discard internal index column
print(augmented.to_csv(None, index=False))
