import pandas as pd
import os
pd.set_option('mode.chained_assignment', None)

current_directory = os.path.dirname(os.path.realpath(__file__))

df = pd.read_csv(os.path.join(current_directory,'crime_data.csv'), dtype={'TIME OCC': object})

############################################
# Generate crime_code_description
############################################

df_cc = df[['Crm Cd','Crm Cd Desc']]

df_cc.rename(columns={'Crm Cd':'crime_code',
              'Crm Cd Desc':'crime_description'},
              inplace=True)
df_cc.drop_duplicates(subset=['crime_code'], inplace=True)
df_cc.to_csv(os.path.join(current_directory,'crime_code_description_reformated.csv'), index=False, header=True)

############################################
# Clean up crime_data
############################################


df.drop(['Crm Cd Desc'],axis=1,inplace=True)

df['Premis Cd'] = pd.to_numeric(df['Premis Cd'], errors='coerce').fillna(0).astype(int)
df['Weapon Used Cd'] = pd.to_numeric(df['Weapon Used Cd'], errors='coerce').fillna(0).astype(int)
df['Crm Cd 1'] = pd.to_numeric(df['Crm Cd 1'],  errors='coerce').fillna(0).astype(int)
df['Crm Cd 2'] = pd.to_numeric(df['Crm Cd 2'],  errors='coerce').fillna(0).astype(int)
df['Crm Cd 3'] = pd.to_numeric(df['Crm Cd 3'],  errors='coerce').fillna(0).astype(int)
df['Crm Cd 4'] = pd.to_numeric(df['Crm Cd 4'],  errors='coerce').fillna(0).astype(int)

df.to_csv(os.path.join(current_directory,'crime_data_reformated.csv'), index=False, header=True)

