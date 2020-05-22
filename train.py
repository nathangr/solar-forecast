# This code was created using guidelines from the following article: https://towardsdatascience.com/random-forest-in-python-24d0893d51c0

from matplotlib import pyplot as plt
from scipy import stats
import pandas as pd
import seaborn as sns
import numpy as np
import os, re, sys


from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.ensemble import RandomForestRegressor

if len(sys.argv) < 3:
  print('Missing argument(s)')
  print('Usage: train.py dataset estimators')

dataset = sys.argv[1]
estimators = sys.argv[2]

print('Using dataset:', dataset, 'with', estimators, 'estimators')

pattern = '([a-zA-Z0-9_\-]*)\.csv$'
csv_filename = re.search(pattern, dataset)
file_part = csv_filename.group(1)

base_name = file_part + '_' + estimators

if not os.path.exists('results'):
  os.mkdir('results')

results_dir = 'results' + '/' + base_name

if not os.path.exists(results_dir):
  os.mkdir(results_dir)

results_dir = results_dir + '/'
base_path = results_dir + base_name + '/'

estimators = int(estimators)

features = pd.read_csv('train_data/' + dataset)

energy = np.array(features['solar_energy'])
std_dev = np.std(energy)
mean = np.mean(energy)
print('solar_energy  -  mean:', mean, 'std_dev:', std_dev)
print('features shape:', features.shape)
features = features[abs(features['solar_energy'] - mean) < 2 * std_dev]
print('features shape after filtering:', features.shape)

# Labels are the values we want to predict
labels = np.array(features['solar_energy'])


# Remove the labels from the features
# axis 1 refers to the columns
features = features.drop('solar_energy', axis = 1)

# Remove the columns that won't be used as features
features = features.drop('date', axis = 1)
features = features.drop('stid', axis = 1)
features = features.drop('lat_rounded', axis = 1)
features = features.drop('lon_rounded', axis = 1)
features = features.drop('solar_min', axis = 1)
features = features.drop('solar_max', axis = 1)

# Saving feature names for later use
feature_list = list(features.columns)

# Convert to numpy array
features = np.array(features)

# Split the data into training and testing sets
train_features, test_features, train_labels, test_labels = train_test_split(features, labels, test_size=0.25,random_state=42)

print('Training Features Shape:', train_features.shape)
print('Training Labels Shape:', train_labels.shape)
print('Testing Features Shape:', test_features.shape)
print('Testing Labels Shape:', test_labels.shape)

# The baseline predictions are the historical averages
baseline_preds = test_features[:, feature_list.index('solar_mean')]

# Baseline errors, and display average baseline error
baseline_errors = abs(baseline_preds - test_labels)
print('Mean Baseline Error: ', round(np.mean(baseline_errors), 2), '.')

msbe = np.mean(baseline_errors**2)
print('Mean Squared Baseline Error: ', round(msbe, 2), '.')
# Instantiate model 
rf = RandomForestRegressor(n_estimators=estimators, random_state=42, n_jobs=-1, verbose=3)

# Train the model on training data
rf.fit(train_features, train_labels)

# Use the forest's predict method on the test data
predictions = rf.predict(test_features)
np.savetxt('predictions.csv', [predictions], delimiter=',')

# Calculate the absolute errors
errors = abs(predictions - test_labels)
ratio = predictions/test_labels
np.set_printoptions(threshold=np.inf)

i = 0
while i < ratio.size:
  if ratio[i] > 10:
    print('large ratio:', ratio[i], 'at index', i, 'pred:', predictions[i], 'actual:', test_labels[i])
  i = i+1

# Print out the mean absolute error (mae)
print('Mean Absolute Error:', round(np.mean(errors), 2), 'J/m^2.') 
msae = np.mean(errors**2)
print('Mean Square Absolute Error:', round(msae, 2), 'J/m^2.') 
r2 = 1 - (msae/msbe)
print('R^2 Coefficient:', r2)
 
# Calculate mean absolute percentage error (MAPE)
mape = 100 * (errors / test_labels)

# Calculate and display accuracy
accuracy = 100 - np.mean(mape)
print('Accuracy:', round(accuracy, 2), '%.')

# # Import tools needed for visualization
from sklearn.tree import export_graphviz
import pydot

# Limit depth of tree to 2 levels
rf_small = RandomForestRegressor(n_estimators=10, max_depth = 3, random_state=42)
rf_small.fit(train_features, train_labels)

# Extract the small tree
tree_small = rf_small.estimators_[5]

# Save the tree as a png image
export_graphviz(tree_small, out_file = results_dir + base_name +'_small_tree.dot', feature_names = feature_list, rounded = True, precision = 1)

(graph, ) = pydot.graph_from_dot_file(results_dir + base_name + '_small_tree.dot')

graph.write_png(results_dir + base_name + '_small_tree.png')

# Get numerical feature importances
importances = list(rf.feature_importances_)

# List of tuples with variable and importance
feature_importances = [(feature, round(importance, 2)) for feature, importance in zip(feature_list, importances)]

# Sort the feature importances by most important first
feature_importances = sorted(feature_importances, key = lambda x: x[1], reverse = True)

# Print out the feature and importances 
[print('Variable: {:20} Importance: {}'.format(*pair)) for pair in feature_importances]

# list of x locations for plotting
x_values = list(range(len(importances)))

# Set the style
plt.style.use('fivethirtyeight')
fig = plt.figure(figsize = (20,8))
plt.gcf().subplots_adjust(bottom=0.15)

# Use datetime for creating date objects for plotting
import datetime

# Dates of training values
months = test_features[:, feature_list.index('month')]
days = test_features[:, feature_list.index('day')]
years = test_features[:, feature_list.index('year')]
nlat = test_features[:, feature_list.index('nlat')]
elon = test_features[:, feature_list.index('elon')]
solar_mean = test_features[:, feature_list.index('solar_mean')]

# List and then convert to datetime object
dates = [str(int(year)) + '-' + str(int(month)) + '-' + str(int(day)) for year, month, day in zip(years, months, days)]
dates = [datetime.datetime.strptime(date, '%Y-%m-%d') for date in dates]

# Dataframe with true values and dates
true_data = pd.DataFrame(data = {'date': dates, 'year': years, 'day': days, 'month': months, 'actual': test_labels, 'elon': elon, 'nlat': nlat, 'solar_mean': solar_mean})

adax_true_data_year = true_data[true_data.year.eq(2000.0) & true_data.nlat.eq(34.79851) & true_data.elon.eq(263.33091)]
adax_true_data_year.sort_values(by=['date'], ascending=True, inplace=True)
adax_true_data_all = true_data[true_data.nlat.eq(34.79851) & true_data.elon.eq(263.33091)]
adax_true_data_all.sort_values(by=['date'], ascending=True, inplace=True)

# Dates of predictions
months = test_features[:, feature_list.index('month')]
days = test_features[:, feature_list.index('day')]
years = test_features[:, feature_list.index('year')]
nlat = test_features[:, feature_list.index('nlat')]
elon = test_features[:, feature_list.index('elon')]

# Column of dates
test_dates = [str(int(year)) + '-' + str(int(month)) + '-' + str(int(day)) for year, month, day in zip(years, months, days)]

# Convert to datetime objects
test_dates = [datetime.datetime.strptime(date, '%Y-%m-%d') for date in test_dates]

# Dataframe with predictions and dates
predictions_data = pd.DataFrame(data = {'date': test_dates, 'year': years, 'day': days, 'month': months, 'elon': elon, 'nlat': nlat, 'prediction': predictions})
filtered_predictions_data_year = predictions_data[predictions_data.year.eq(2000.0) & predictions_data.nlat.eq(34.79851) & predictions_data.elon.eq(263.33091)]
filtered_predictions_data_year.sort_values(by=['date'], ascending=True, inplace=True)
filtered_predictions_data_all = predictions_data[predictions_data.nlat.eq(34.79851) & predictions_data.elon.eq(263.33091)]
filtered_predictions_data_all.sort_values(by=['date'], ascending=True, inplace=True)

# Plot the actual values over all years
plt.ion()
plt.plot(adax_true_data_all['date'], adax_true_data_all['actual'], 'b-', label = 'actual')

# Plot the historical mean values
plt.plot(adax_true_data_all['date'], adax_true_data_all['solar_mean'], 'ko', label = 'historical mean')

# Plot the predicted values
plt.plot(filtered_predictions_data_all['date'], filtered_predictions_data_all['prediction'], 'r-', label = 'prediction')

# Complete graph setup
plt.xticks(rotation = '60'); 
plt.legend()
plt.xlabel('Date'); plt.ylabel('Solar Energy (J/m^2)'); plt.title('Actual, Historical and Predicted Values')
# plt.show()
fig.savefig(results_dir + base_name + '_actual_mean_predicted_all.png', bbox_inches = "tight")
plt.ioff()

plt.clf()

# Plot the actual values over year 2000
plt.ion()
plt.plot(adax_true_data_year['date'], adax_true_data_year['actual'], 'b-', label = 'actual')

# Plot the historical mean values
plt.plot(adax_true_data_year['date'], adax_true_data_year['solar_mean'], 'ko', label = 'historical mean')

# Plot the predicted values
plt.plot(filtered_predictions_data_year['date'], filtered_predictions_data_year['prediction'], 'r-', label = 'prediction')

# Complete graph setup
plt.xticks(rotation = '60'); 
plt.legend()
plt.xlabel('Date'); plt.ylabel('Solar Energy (J/m^2)'); plt.title('Actual, Historical and Predicted Values')

# plt.show()
fig.savefig(results_dir + base_name + '_actual_mean_predicted_year.png', bbox_inches = "tight")
plt.ioff()