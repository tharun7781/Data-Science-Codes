# Pandas Master Course Notes: End-to-End Guide

Pandas is the fundamental Python library for data manipulation, analysis, and cleaning. It provides high-performance data structures like `DataFrame` and `Series`, operating like an in-memory SQL database or Excel spreadsheet.

---

## 1. Core Data Structures
Pandas is built on two main data structures: Series and DataFrames.

### Series (1D Data)
A 1D labeled array capable of holding any data type.
```python
import pandas as pd
import numpy as np

# Create from a list
s = pd.Series([10, 20, 30, 40], index=['a', 'b', 'c', 'd'])
print(s['b']) # Output: 20
```

### DataFrame (2D Data)
A 2D labeled data structure with columns of potentially different types (like a SQL table or Excel sheet).
```python
data = {
    'Name': ['Alice', 'Bob', 'Charlie'],
    'Age': [25, 30, 35],
    'City': ['New York', 'Paris', 'London']
}
df = pd.DataFrame(data)
```

---

## 2. Reading and Writing Data
Pandas makes it extremely easy to load data from various sources and save it back out.

**Reading Data:**
```python
df_csv = pd.read_csv('data.csv')
df_excel = pd.read_excel('data.xlsx', sheet_name='Sheet1')
df_json = pd.read_json('data.json')
df_sql = pd.read_sql('SELECT * FROM users', con=db_connection)
```
*Tip: `pd.read_csv()` has dozens of parameters to handle broken data (e.g., `sep`, `na_values`, `parse_dates`, `encoding`).*

**Writing Data:**
```python
df.to_csv('cleaned_data.csv', index=False) # index=False prevents writing row numbers
df.to_excel('output.xlsx', index=False)
```

---

## 3. Data Inspection and Profiling
Always inspect your data immediately after loading it.

```python
df.head(5)          # View first 5 rows
df.tail(3)          # View last 3 rows
df.info()           # Data types, non-null counts, and memory usage
df.describe()       # Statistical summary of numeric columns (mean, std, min, max, quartiles)
df.shape            # Tuple of (rows, columns)
df.columns          # List of column names
df.dtypes           # Data types of each column
```

---

## 4. Selecting and Filtering Data
Pandas provides multiple ways to slice and dice your data.

### Selecting Columns
```python
names = df['Name']              # Returns a Series
subset = df[['Name', 'City']]   # Returns a DataFrame
```

### Selecting Rows by Label (`.loc`)
Used when you want to access rows by their index label or boolean conditions.
```python
# Select rows with index label 0 to 2, and columns 'Name' and 'Age'
subset = df.loc[0:2, ['Name', 'Age']] 
```

### Selecting Rows by Position (`.iloc`)
Used when you want to access rows by their integer index position.
```python
# Select first 3 rows, and first 2 columns
subset = df.iloc[0:3, 0:2] 
```

### Boolean Indexing (Filtering)
```python
# Simple filter
adults = df[df['Age'] >= 18]

# Multiple conditions (use & for AND, | for OR, wrap in parentheses)
filtered_df = df[(df['Age'] > 25) & (df['City'] == 'London')]

# isin() method
cities = ['London', 'Paris']
eu_users = df[df['City'].isin(cities)]
```

---

## 5. Data Cleaning and Handling Missing Values

### Handling Missing Data (`NaN`)
```python
df.isna().sum()                 # Count missing values per column

df_clean = df.dropna()          # Drop any row with at least one missing value
df_clean = df.dropna(subset=['Age']) # Drop rows where 'Age' is missing

# Filling missing values
df_filled = df.fillna(0)        # Fill all with 0
df_filled = df['Age'].fillna(df['Age'].mean()) # Fill with column mean
```

### Deduplication
```python
df.duplicated().sum()           # Count duplicate rows
df_unique = df.drop_duplicates()
```

### Replacing Values
```python
df['Status'] = df['Status'].replace({'Y': 'Yes', 'N': 'No'})
```

---

## 6. Data Manipulation & Feature Engineering

### Adding, Modifying, Dropping Columns
```python
# Add new column
df['Age_In_Months'] = df['Age'] * 12

# Drop column
df = df.drop('Age_In_Months', axis=1) # axis=1 means columns

# Rename column
df = df.rename(columns={'Name': 'Full Name'})
```

### Applying Functions
Use `.apply()` to execute custom logic row-by-row or column-by-column.
```python
# Apply to a column
df['Is_Senior'] = df['Age'].apply(lambda age: True if age >= 60 else False)

# Vectorized string methods
df['Upper_Name'] = df['Name'].str.upper()
df['First_Name'] = df['Name'].str.split(' ').str[0]
```

---

## 7. Grouping and Aggregation (`groupby`)
Splitting data into groups, applying a function, and combining the results. Equivalent to SQL `GROUP BY`.

```python
# Simple grouping
mean_age = df.groupby('City')['Age'].mean()

# Multiple basic aggregations
summary = df.groupby('City')['Age'].agg(['mean', 'max', 'min', 'count'])

# Complex aggregations on different columns
agg_dict = {
    'Age': 'mean',
    'Salary': ['sum', 'max']
}
complex_summary = df.groupby('City').agg(agg_dict)
```

### Pivot Tables
Creates spreadsheet-style pivot tables.
```python
pivot = pd.pivot_table(
    df, 
    values='Salary', 
    index='City', 
    columns='Department', 
    aggfunc=np.mean, 
    fill_value=0
)
```

---

## 8. Combining DataFrames
Equivalent to SQL JOINs and UNIONs.

### Concatenation (UNION)
Stacking DataFrames vertically or horizontally.
```python
# Vertically (stacking rows)
df_combined = pd.concat([df1, df2], axis=0)

# Horizontally (side-by-side)
df_side = pd.concat([df1, df2], axis=1)
```

### Merging (JOIN)
Connecting related DataFrames based on keys.
```python
# Inner Join
merged_df = pd.merge(users_df, orders_df, on='user_id', how='inner')

# Left Join
merged_left = pd.merge(users_df, orders_df, left_on='id', right_on='user_id', how='left')
```
*`how` parameter accepts: 'left', 'right', 'outer', 'inner'.*

---

## 9. Time Series Data Handling
Pandas excels at handling dates and times.

```python
# Convert strings to datetime objects
df['Date'] = pd.to_datetime(df['Date_String'])

# Extract components
df['Year'] = df['Date'].dt.year
df['Month'] = df['Date'].dt.month
df['DayOfWeek'] = df['Date'].dt.day_name()

# Setting datetime as index allows for powerful time slicing and resampling
df.set_index('Date', inplace=True)
df.loc['2023-01'] # Selects all rows in Jan 2023

# Resampling (e.g., converting daily data to monthly sum)
monthly_revenue = df['Revenue'].resample('M').sum()
```

---

## 10. High-Level / Advanced Topics

### 1. Vectorization / Performance (Crucial!)
Avoid using `for` loops or `iterrows()` with Pandas. Use vectorized operations or `np.where`.
```python
# SLOW (looping)
for i in range(len(df)):
    df.loc[i, 'Status'] = 'High' if df.loc[i, 'Score'] > 90 else 'Low'

# VERY FAST (vectorized using np.where)
df['Status'] = np.where(df['Score'] > 90, 'High', 'Low')
```

### 2. Window Functions
Calculations across a sliding window of localized rows.
```python
# 7-day rolling average
df['7D_Moving_Average'] = df['Sales'].rolling(window=7).mean()

# Cumulative sum (expanding)
df['Cumulative_Sales'] = df['Sales'].expanding().sum()
```

### 3. Categorical Data (Memory Optimization)
If you have columns with few unique string values (like "Yes"/"No", or "Low"/"Med"/"High"), convert them from `object` to `category` to drastically save RAM.
```python
df['Department'] = df['Department'].astype('category')
```

### 4. Method Chaining
Writing clean, readable code by chaining operations.
```python
final_df = (
    pd.read_csv('data.csv')
    .dropna(subset=['Age', 'Salary'])
    .assign(Net_Salary = lambda df: df['Salary'] * 0.8) # creates new column
    .query('Age > 25 and City == "London"')            # SQL-like filtering string
    .groupby('Department')[['Net_Salary', 'Age']].mean()
    .rename(columns={'Net_Salary': 'Avg_Salary'})
)
```
---
*These notes cover almost everything you would learn in a full data manipulation course with Pandas. The key to mastering Pandas is practicing vectorization and writing chainable logic.*
