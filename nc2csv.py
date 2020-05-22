# Import the needed libraries
import os
import re
import sys
import xarray as xr

# this utility converts a netCDF4 file to a csv file
# WARNING: needed to instal:
#    pip install numpy==1.16.1

# infile = file we get the data from
infile = sys.argv[1]
# outfile = name of the file we want to be created
outdir = sys.argv[2]

# Used to check if all necessary arguments were passed in the Makefile
if len(sys.argv) < 3:
  print('Missing argument(s)')
  print()
  print('Usage: nc2csv.py infile outdir')
  sys.exit()

# Set the pattern of data files we need as files that ends with .nc
pattern = '([a-zA-Z0-9_\-]*)\.nc$'
# Search for the .nc file in our directory with the pattern we set earlier
nc_filename = re.search(pattern, infile)
# Store the filename as a tuple ##
file_part = nc_filename.group(1)
# New filename is outputted
out_path = outdir + '/' + file_part + '.csv'

# Create output directory if needed
if not os.path.exists(outdir):
  os.mkdir(outdir)
# Use xarray to open the .nc file 
nc = xr.open_dataset(infile)
# Format the file to then be converted to a dataframe
trans_nc = nc.sel()
final_nc = trans_nc.to_dataframe()
# Convert the data frame into a csv file with the file name found earlier
final_nc.to_csv(out_path)
