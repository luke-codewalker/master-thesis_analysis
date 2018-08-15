import re

for i in range(31):
    # convert range to vp number
    vp_number = str(i+1)
    # open raw data file
    with open('experiment_data/raw_data/experiment-data_VP'+vp_number+'.csv', 'r') as csv_file:
        content = csv_file.read()
        # replace new lines after condition code (e.g. \d[a-z] = "5a")
        cleaned_content = re.sub(r'(\d[a-z])\n', r'\1', content)
        # write contents to new file
        with open('experiment_data/experiment-data_VP'+vp_number+'.csv', 'w') as new_file:
            new_file.write(cleaned_content)

print('Done')
