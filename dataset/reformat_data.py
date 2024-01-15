import pandas as pd
import os

current_directory = os.path.dirname(os.path.realpath(__file__))
# Read the CSV file
df = pd.read_csv(os.path.join(current_directory,'crime_data.csv'), dtype={'TIME OCC': object})

df.drop(['Crm Cd Desc'],axis=1,inplace=True)

df['Premis Cd'] = pd.to_numeric(df['Premis Cd'], errors='coerce').fillna(0).astype(int)
df['Weapon Used Cd'] = pd.to_numeric(df['Weapon Used Cd'], errors='coerce').fillna(0).astype(int)
df['Crm Cd 1'] = pd.to_numeric(df['Crm Cd 1'],  errors='coerce').fillna(0).astype(int)
df['Crm Cd 2'] = pd.to_numeric(df['Crm Cd 2'],  errors='coerce').fillna(0).astype(int)
df['Crm Cd 3'] = pd.to_numeric(df['Crm Cd 3'],  errors='coerce').fillna(0).astype(int)
df['Crm Cd 4'] = pd.to_numeric(df['Crm Cd 4'],  errors='coerce').fillna(0).astype(int)

df.to_csv(os.path.join(current_directory,'crime_data_reformated.csv'), index=False, header=True)