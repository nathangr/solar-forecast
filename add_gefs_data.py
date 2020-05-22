import sys

# Used to check if all necessary arguments were passed in the Makefile
if len(sys.argv) < 3:
  print('Missing argument(s)')
  print('Usage: add_gefs_data.py part2 gefs')

# Store the files that will receive and contain the GEFS data
part2_filename = sys.argv[1]
gefs_filename = sys.argv[2]

# Open the files that will receive and contain the GEFS data in read mode
part2_file = open(part2_filename, "r")
gefs_file = open(gefs_filename, "r")

# Create a list that contains the rows of the gefs data
gefs_lines = gefs_file.readlines()

# Create an empty dictionnary
gefs_dict = {}

# Create a list that contains the rows of the file with solar energy data and station detail
part2_lines = part2_file.readlines()

# Save the headers from both files into a list
part2_headers = part2_lines[0].strip().split(',')
gefs_header_row = gefs_lines[0].strip().split(',')
# Create a new combined header for the new file using the two old files
gefs_headers = gefs_header_row[1:4] + gefs_header_row[9:]
print(','.join(part2_headers + gefs_headers))


for g in gefs_lines[1:]:
  # Turn the gefs data row into a list of its element
  gefs = g.strip().split(',')
  # Remove the "-" of the date so that it has the same format of the file that will receive the data. It allows us to compare two keys to see if the date matches when we are trying to add the data at the right place
  date = gefs[6].replace('-', '')
  # Turn latitude and longitude into strings instead of integers so that they can be joined in a key
  lat = str(gefs[4])
  lon = str(gefs[5])
  # Create a unique key for each row of data using date, lat and lon. This will allow to place data at the right place when creating the new combined file
  key = '-'.join([date, lat, lon])
  data = gefs[1:4] + gefs[9:]
  gefs_dict[key] = data

for part2_line in part2_lines[1:]:
  # Turn the solar energy/station data row into a list of its element
  part2 = part2_line.strip().split(',')
  # Recreate the same key seen in the GEFS data for loop with date, lat and lon. This will allow us to match and place data
  key = '-'.join([part2[0], part2[-2], part2[-1]])
  # Store the GEFS data using the key for the solar energy set we just created. It should match to a data row from GEFS data.
  gefs_data = gefs_dict[key]
  # Combine the data into a single row/file
  output = part2 + gefs_data
  print(','.join(output))
