import csv
header = ['time','voltage']
data = ['elapse','volt']

# open the file in the write mode
f = open('negara.csv', 'w', encoding='UTF8', newline='')

# create the csv writer
writer = csv.writer(f)
# write the header
writer.writerow(header)
while True:
    # write multiple rows
    writer.writerows(data)

# close the file
f.close()
