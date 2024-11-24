import numpy as np
import seaborn as sns
import pandas as pd
import json

# Load the dataset
file_path = 'cleaned_diabetes_data.csv'
data = pd.read_csv(file_path)

# Compute KDE for the age column
kde = sns.kdeplot(data["age"], bw_adjust=0.5)
kde_data = {
    "x": kde.lines[0].get_xdata().tolist(),
    "y": kde.lines[0].get_ydata().tolist(),
}

# Save to a JSON file
with open("kde_age.json", "w") as f:
    json.dump(kde_data, f)
