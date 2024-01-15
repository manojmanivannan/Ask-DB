import pandas as pd
import os

current_directory = os.path.dirname(os.path.realpath(__file__))
# Read the CSV file
df = pd.read_csv(os.path.join(current_directory,'crime_data.csv'))

for col in ['Date Rptd','DATE OCC']:

    # Assuming the date column is named 'date_column', replace it with the actual column name
    df[col] = pd.to_datetime(df[col], format='%m/%d/%Y %I:%M:%S %p')

    # Convert the date column to the desired format
    df[col] = df[col].dt.strftime('%Y-%m-%d %H:%M:%S')

# Save the updated DataFrame to a new CSV file
df.to_csv(os.path.join(current_directory,'crime_data_reformated.csv'), index=False, header=False)