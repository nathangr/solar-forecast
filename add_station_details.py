import sys
# Check Figure ___ for an overview of the original station's details file
# Used to check if all necessary arguments were passed in the Makefile
if len(sys.argv) < 3:
  print('Missing argument(s)')
  print('Usage: add_stations_details.py details measurements')

# The station details and the linearized solar energy measurements are stored
details_filename = sys.argv[1]
measurements_filename = sys.argv[2]

# Both files are opened in read mode "r" so that nothing is written on the original file
details_file = open(details_filename, "r")
measurements_file = open(measurements_filename, "r")

# A list of all the rows in the station's details file is created
details = details_file.readlines()
# An empty dictionnary is created
stations = {}
# A for loop that enumerates over every row is used
for detail in details:
  # The elements on the row are splitted on a list
  station_data = detail.strip().split(',') 
  # For every station, a station id key is created that contains its latitude and longitude
  stations[station_data[1]] = station_data[2:]

# A list of all the rows in the file that contains the linearized solar energy is created
measurements = measurements_file.readlines()
# A for loop that enumerates over every row is used
for measurement in measurements:
  # The elements on the row are splitted on a list
  m = measurement.strip().split(',')
  # The station on each row is stored
  station = m[1]
  # The measurement is stored
  output = m
  # To every measurement, the corresponding station's detail is added using our earlier dictionnary with the correct key 
  output = output + stations[station]
  # A new file containing both the solar energy measurement and station information is created
  print(','.join(output))
