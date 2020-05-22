import sys

# Used to check if all necessary arguments were passed in the Makefile
if len(sys.argv) < 3:
  print('Missing argument(s)')
  print('Usage: combine.py infile1 infile2')

# Store both file that are passed as arguments in the Makefile and that we need to combine together
infile1 = sys.argv[1]
infile2 = sys.argv[2]

# Open both files in read mode "r" so that nothing is written on the original file
file1 = open(infile1, "r")
file2 = open(infile2, "r")

# Create two lists containing every line from both files. Each element on the list is a single line
lines1 = file1.readlines()
lines2 = file2.readlines()

# We use a for loop that enumerates over every word in every line from file 1
for index, line in enumerate(lines1):
  # For every line, we create a new list that contains every seperate entry on that line by splitting on the "," seperator
  output = line.strip().split(',')
  # We add the same line on file2 to file1 using [index], we then split the line into a list using the same seperator, and we use [-1] to start at the first entry. The corresponding entries from both files are added together 
  output.append(lines2[index].strip().split(',')[-1])
  # The new files with both files combined is then created
  print(','.join(output))
