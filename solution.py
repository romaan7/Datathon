import pandas as pd
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score


# Load the dataset
file_path = 'diabetes_data.csv'
data = pd.read_csv(file_path)

# Display basic information about the dataset
data_info = {
    'Shape': data.shape,
    'Columns': data.columns.tolist(),
    'Missing Values': data.isnull().sum().sum(),
    'Data Types': data.dtypes.to_dict(),
    'First 5 Rows': data.head().to_dict()
}

data_info


# Step 1: Handle Missing Values

# Numerical columns - impute with mean for now (adjust based on EDA)
num_cols = ['age', 'BMI', 'weight', 'sleep_duration', 'diabetes_pedigree_function', 'pregnancies']
data[num_cols] = data[num_cols].fillna(data[num_cols].mean())

# Categorical columns - fill with mode or 'Unknown'
cat_cols = ['gender', 'diet_type', 'star_sign', 'social_media_usage', 'physical_activity_level', 'stress_level', 'alcohol_consumption']
for col in cat_cols:
    data[col] = data[col].fillna(data[col].mode()[0] if data[col].mode().size > 0 else 'Unknown')

# Step 2: Address Outliers

# Capping extreme values for sleep_duration and BMI based on domain knowledge
data['sleep_duration'] = data['sleep_duration'].clip(lower=4, upper=10)  # Typical range for sleep in hours
data['BMI'] = data['BMI'].clip(lower=10, upper=50)  # Typical BMI range

# Step 3: Encode Categorical Variables

# One-hot encode categorical columns where applicable
categorical_one_hot = ['diet_type', 'social_media_usage', 'physical_activity_level', 'alcohol_consumption']
data = pd.get_dummies(data, columns=categorical_one_hot, drop_first=True)

# Label encode ordinal categorical variables
ordinal_mapping = {'Low': 1, 'Moderate': 2, 'High': 3, 'Unknown': 0}
data['stress_level'] = data['stress_level'].map(ordinal_mapping).fillna(0)  # Handle unknown values

# Step 4: Feature Engineering

# Create BMI categories
data['BMI_category'] = pd.cut(data['BMI'], bins=[0, 18.5, 24.9, 29.9, 50], labels=['Underweight', 'Normal', 'Overweight', 'Obese'])

# Combine hypertension and family diabetes history
data['combined_risk'] = data['hypertension'].fillna(0) + data['family_diabetes_history'].fillna(0)



# Step 5: Standardization/Normalization

# Standardizing numerical columns
scaler = StandardScaler()
data[num_cols] = scaler.fit_transform(data[num_cols])

# Step 6: Remove Irrelevant Columns

# Drop columns deemed irrelevant or redundant
irrelevant_cols = ['star_sign']  # Example of an irrelevant column
data = data.drop(columns=irrelevant_cols)

# Save cleaned data to CSV
data.to_csv('cleaned_diabetes_data.csv')

# Further analysis: exploring distributions, correlations, and relationships

# 1. Distribution of the target variable (diabetes)
plt.figure(figsize=(6, 4))
sns.countplot(x='diabetes', data=data)
plt.title('Distribution of Diabetes')
plt.xlabel('Diabetes (1: Yes, 0: No)')
plt.ylabel('Count')
plt.show()

# 2. Correlation heatmap for numerical features
plt.figure(figsize=(10, 8))
correlation_matrix = data[num_cols] .corr()
sns.heatmap(correlation_matrix, annot=True, fmt=".2f", cmap="coolwarm")
plt.title('Correlation Heatmap')
plt.show()

# 3. BMI distribution across diabetes categories
plt.figure(figsize=(8, 6))
sns.boxplot(x='diabetes', y='BMI', data=data)
plt.title('BMI Distribution by Diabetes')
plt.xlabel('Diabetes (1: Yes, 0: No)')
plt.ylabel('BMI')
plt.show()

# 4. Stress levels across diabetes categories
plt.figure(figsize=(8, 6))
sns.countplot(x='stress_level', hue='diabetes', data=data)
plt.title('Stress Level Distribution by Diabetes')
plt.xlabel('Stress Level')
plt.ylabel('Count')
plt.legend(title='Diabetes', loc='upper right')
plt.show()

# 5. Physical activity levels and diabetes
plt.figure(figsize=(8, 6))
sns.countplot(x='physical_activity_level_Sedentary', hue='diabetes', data=data)
plt.title('Sedentary Activity and Diabetes')
plt.xlabel('Sedentary Activity (1: Yes, 0: No)')
plt.ylabel('Count')
plt.legend(title='Diabetes', loc='upper right')
plt.show()

# Generate summaries and potential insights
summary_insights = {
    "diabetes_distribution": data['diabetes'].value_counts().to_dict(),
    "top_positive_correlations": correlation_matrix['diabetes'].sort_values(ascending=False).head(5).to_dict(),
    "top_negative_correlations": correlation_matrix['diabetes'].sort_values().head(5).to_dict(),
}

summary_insights


###############################

# Preparing data for modeling
# Separating features and target variable
X = data.drop(columns=['diabetes'])
y = data['diabetes']

# Splitting the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

# Initializing a Random Forest Classifier
model = RandomForestClassifier(random_state=42)
model.fit(X_train, y_train)

# Predictions on the test set
y_pred = model.predict(X_test)

# Evaluating the model
accuracy = accuracy_score(y_test, y_pred)
conf_matrix = confusion_matrix(y_test, y_pred)
class_report = classification_report(y_test, y_pred)

# Feature importance
feature_importances = pd.DataFrame({
    'Feature': X.columns,
    'Importance': model.feature_importances_
}).sort_values(by='Importance', ascending=False)

# Displaying the evaluation results and feature importances
import ace_tools as tools; tools.display_dataframe_to_user(name="Feature Importances from Random Forest Model", dataframe=feature_importances)

{
    "Accuracy": accuracy,
    "Confusion Matrix": conf_matrix.tolist(),
    "Classification Report": class_report
}
