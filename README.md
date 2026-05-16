# 🍔 Swiggy Sales Analysis

## 📌 Business Requirements

This project analyzes food delivery data from Swiggy to uncover business insights related to sales, customer preferences, restaurant performance, and ratings. The project includes data cleaning, dimensional modeling using a Star Schema, KPI development, and advanced business analysis.

---

# 🧹 Data Cleaning & Validation

The raw table `swiggy_data` contains food delivery records across:

- State
- City
- Order Date
- Restaurant Name
- Location
- Category
- Dish Name
- Price (INR)
- Rating
- Rating Count

The first step is to ensure data quality through the following checks:

---

## 🔍 Null Check

Identify missing values in the following columns:

- `State`
- `City`
- `Order_Date`
- `Restaurant_Name`
- `Location`
- `Category`
- `Dish_Name`
- `Price_INR`
- `Rating`
- `Rating_Count`

---

## ⬜ Blank / Empty String Check

Detect records where fields contain blank values (`''`) that may lead to inaccurate analysis.

---

## 🧾 Duplicate Detection

Identify duplicate rows by grouping on all business-critical columns.

---

## 🗑️ Duplicate Removal

Use `ROW_NUMBER()` to remove duplicate rows while retaining one clean copy for each unique record.

---

# ⭐ Dimensional Modelling (Star Schema)

Dimensional modeling organizes data into a structure that is:

- Easy to understand
- Highly scalable
- Performance optimized
- BI-tool friendly

Instead of keeping all data in one large table, descriptive information is separated into dimension tables, while numerical measures are stored in a central fact table.

---

## 📐 Star Schema Design

### 📅 Dimension Tables

#### `dim_date`
Contains time-based attributes:

- Order Date
- Year
- Month
- Quarter
- Week
- Day of Week

#### 📍 `dim_location`

- State
- City
- Location

#### 🏪 `dim_restaurant`

- Restaurant Name

#### 🍜 `dim_category`

- Cuisine / Category

#### 🍽️ `dim_dish`

- Dish Name

---

### 📊 Fact Table: `fact_swiggy_orders`

Stores measurable metrics and foreign keys to dimensions.

#### Measures

- Price_INR
- Rating
- Rating_Count

#### Foreign Keys

- Date_Key
- Location_Key
- Restaurant_Key
- Category_Key
- Dish_Key

---

## 🔄 Data Loading Process

1. Clean raw data
2. Insert distinct values into dimension tables
3. Resolve surrogate keys
4. Load fact table with keys and measures

---

## 🗂️ ERD Diagram – Star Schema

```text
                 dim_date
                    |
                    |
dim_location --- fact_swiggy_orders --- dim_restaurant
                    |
                    |
               dim_category
                    |
                    |
                 dim_dish
```
---
## 📈 KPI Development

Once the Star Schema is built, the next step is to calculate key performance indicators (KPIs) and perform detailed business analysis to uncover actionable insights.

---

## 📌 Basic KPIs

These core metrics provide a high-level overview of business performance.

### 📦 Total Orders
Total number of orders processed in the dataset.

### 💰 Total Revenue (INR Million)
Total sales generated from all orders, expressed in millions of Indian Rupees.

### 🏷️ Average Dish Price
Average price of all dishes ordered.

### ⭐ Average Rating
Average customer rating across all dishes and restaurants.

---

# 🔍 Deep-Dive Business Analysis

---

## 📅 Date-Based Analysis

Analyze how orders and revenue change over time.

### 📆 Monthly Order Trends
Track order volume month by month to identify seasonal patterns.

### 🗓️ Quarterly Order Trends
Compare performance across quarters.

### 📈 Year-Wise Growth
Measure growth in orders and revenue over multiple years.

### 📌 Day-of-Week Patterns
Determine which days generate the highest and lowest order volumes.

---

## 📍 Location-Based Analysis

Understand regional performance and market contribution.

### 🏙️ Top 10 Cities by Order Volume
Identify cities with the highest number of orders.

### 🗺️ Revenue Contribution by State
Calculate each state's share of total revenue.

---

## 🍽️ Food Performance Analysis

Evaluate restaurant, cuisine, and dish performance.

### 🏪 Top 10 Restaurants by Orders
Restaurants receiving the most orders.

### 🍜 Top Categories
Most popular cuisine categories, such as:

- Indian
- Chinese
- Italian
- Fast Food
- Desserts

### 🍛 Most Ordered Dishes
Dishes with the highest order counts.

### ⭐ Cuisine Performance
For each category, calculate:

- Total Orders
- Average Rating

---

## 💸 Customer Spending Insights

Segment orders based on the amount spent.

### 🪙 Spending Buckets

| Price Range (INR) | Bucket |
|------------------:|--------|
| Below 100         | Under 100 |
| 100 – 199         | 100–199 |
| 200 – 299         | 200–299 |
| 300 – 499         | 300–499 |
| 500 and above     | 500+ |

### 📊 Order Distribution by Spend Bucket
Analyze how many orders fall into each spending category.

---

## ⭐ Ratings Analysis

Examine customer satisfaction through rating distribution.

### 📈 Rating Distribution (1–5)
Count the number of dishes and orders receiving each rating.

### 🔍 Additional Insights
- Percentage of highly rated dishes (4.0 and above)
- Average rating by cuisine
- Average rating by restaurant

---

# 📊 Summary of Deliverables

The KPI layer should provide insights into:

- Overall business performance
- Time-based trends
- Geographic contribution
- Restaurant and cuisine popularity
- Customer spending behavior
- Rating and satisfaction patterns
