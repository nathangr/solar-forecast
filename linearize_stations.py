import sys
# Check figure __ to get an overview of the solar energy file
# Used to check if all necessary arguments were passed in the Makefile
if len(sys.argv) < 2:
  print('Missing argument(s)')
  print('Usage: linearize_stations.py stations_file.csv')

# Store the file that needs to be linearized
infile = sys.argv[1]
# Open file in read mode "r" so that nothing is written on the original file
f = open(infile, "r")

# A list of all of the file's row is created
lines = f.readlines()
# A list containing all of the station id is created
stations = lines[0].strip().split(',')[1:]

# A for loop that enumerate over all row containing data is used
for line in lines[1:]:
  # The elements in the row is turned into a list
  data = line.strip().split(',')
  # The date for the measurements on the row is stored
  date = data[0]
  # The row measurements are stored in a list
  measurements = data[1:]
  # Then, a for loop that enumerates over every measurements on a row is used
  for index, m in enumerate(measurements):
    # The new lines are outputted starting with the date when the measurement was taken
    output = [date]
    # To the measurement, the corresponding station id is added. This is doable since every measurement shares the same index as its station id
    output.append(stations[index])
    # The measurement is added to the new line
    output.append(m)
    # We create a new file with each measurement having its own row
    print(','.join(output))
