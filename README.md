# **UK E-Commerce Sales Forecasting**

### & Working Capital Planning

## **Overview**

This project uses historical UK e-commerce sales data to build a simple sales forecasting and working capital planning model.

The project takes raw transaction data, cleans and summarises it using SQL, then uses Excel to forecast the next 12 months of revenue. I also built a small backtesting section to check how well the forecasting approach performed on historical data.

The main aim was to practise working with data across different tools and see how a forecast could be used to support basic business planning.

---

## **What I Used**

* **MySQL** – storing, cleaning and aggregating the raw data  
* **DBeaver** – working with the MySQL database  
* **Microsoft Excel** – forecasting, model validation and dashboard

---

## **Data**

The dataset used is **Online Retail II**, originally provided through the UCI Machine Learning Repository.  
[Link](https://archive.ics.uci.edu/dataset/502/online+retail)

It contains over 1 million transaction records from a UK-based online retailer. The original data covers December 2009 to December 2011, although the final analysis uses the 24 complete months from December 2009 to November 2011\.

The original dataset contains information such as:

* Invoice number  
* Product code  
* Product description  
* Quantity  
* Invoice date  
* Price  
* Customer ID  
* Country

For this project, I focused on UK transactions.

The raw data was cleaned before being used for the forecast. This included removing cancelled invoices, non-positive quantities and prices, incomplete December 2011 data, and some non-merchandise transactions such as postage, fees and test records.

The final SQL query produced 24 monthly observations containing:

* Total revenue  
* Total orders  
* Active customers  
* Average order value

---

The original raw dataset is not included in the repository because of its size. It can be obtained from the original dataset source.

---

## **Data Pipeline**

The project follows this basic process:

Raw Online Retail Data  
        ↓  
      MySQL  
        ↓  
Cleaning \+ Monthly Aggregation  
        ↓  
24 Months of UK Sales Data  
        ↓  
      Excel  
        ↓  
12-Month Forecast  
        ↓  
Backtesting \+ Scenarios  
        ↓  
Executive Dashboard

The idea was to take a large transaction dataset and turn it into a much smaller dataset that could be used for forecasting.

---

## 

## **SQL**

The SQL stage stores the raw transaction data and then produces a monthly summary of UK revenue.

Some of the main filtering rules were:

* Remove cancelled invoices  
* Remove non-positive quantities  
* Remove non-positive prices  
* Keep UK transactions only  
* Remove incomplete December 2011 data  
* Remove selected non-merchandise transactions

Revenue was calculated using:

SUM(Quantity \* Price)

The transactions were then grouped by month.

This produced the 24-row dataset used by the Excel model.

---

## **Excel Forecasting Model**

The Excel workbook contains three main tabs.

### **1\. Executive Dashboard**

This is the main summary of the model.

It includes:

* Next 12 months projected revenue  
* Model MAPE  
* Estimated Q4 working capital requirement  
* Base Case, Optimistic and Stress Case scenarios  
* A forecast chart

The scenario options are:

| Scenario | Adjustment |
| :---- | ----- |
| Base Case | 0% |
| Optimistic | \+10% |
| Stress Case | \-10% |

The scenario selection changes the forecast and the related working capital estimate.

There is also an editable 55% COGS assumption used in the working capital calculation.

### **2\. Forecasting Engine**

This tab contains the main forecast.

I used Excel's FORECAST.ETS functions to estimate monthly revenue for the following 12 months.

The model uses the 24 months of historical data and forecasts from December 2011 to November 2012\.

The forecast also includes a 95% confidence interval to show the uncertainty around the forecast.

The model parameters and detected seasonality are also shown on this tab.

### **3\. Model Validation**

This tab was used to do a simple backtest.

The historical data was split into:

* 18 months of training data  
* 6 months of test data

The model was then used to forecast the six test months and compare the forecasts with the actual revenue.

The error for each month was calculated using Absolute Percentage Error (APE). The average of these errors gives the MAPE.

---

## 

## **Model Performance**

The model produced a **22% MAPE** on the six-month holdout period.

This means the forecasts were, on average, around 22% away from the actual revenue during the test period.

I don't consider this a particularly strong forecasting result, so the forecast should not be treated as an exact prediction.

One reason for the error is the limited amount of historical data available for the backtest. The training period contains only 18 months of data, which is only one and a half annual cycles.

The model's automatic seasonality detection also did not identify a reliable seasonal cycle during the backtest. Because of this, the backtest uses Excel's automatic setting rather than forcing a 12-month seasonality.

For the final forecast, the full 24 months of data are used and a 12-month seasonality is explicitly set.

This is one of the main limitations of the project and is something I would look to improve with a larger historical dataset.

---

## 

## 

## 

## 

## 

## 

## 

## 

## **Forecast Results**

Using the full 24 months of historical data, the model produced a base-case forecast of approximately:

**£9.22 million projected revenue over the next 12 months**

The model also estimates a Q4 peak working capital requirement of approximately:

**£323,832**

The scenario results are:

| Scenario | 12-Month Revenue | Q4 Working Capital |
| :---: | :---: | :---: |
| Base Case | £9,216,895 | £323,832 |
| Optimistic (+10%) | £10,138,584 | £356,215 |
| Stress (-10%) | £8,295,205 | £291,449 |

The working capital estimate is based on the difference between the highest forecasted month and the average forecasted month, multiplied by the assumed 55% COGS percentage.

The 55% figure is an assumption rather than something calculated from the dataset, because the transaction data contains sales prices but does not provide cost information.

---

## **Business Interpretation**

The historical data shows a noticeable increase in revenue towards the end of the year.

The forecast follows a similar pattern, with higher revenue expected towards the end of the forecast period.

A business using a model like this could potentially use the forecast to help with:

* Preparing inventory before periods of higher expected sales  
* Planning working capital requirements  
* Considering different sales outcomes  
* Supporting purchasing and cash planning

The working capital figure should be treated as an estimate rather than a precise funding requirement because it depends on the 55% COGS assumption.

---

## **Limitations**

There are several limitations to the model.

### **Limited historical data**

Only 24 complete months were used for the final forecast. This gives the model only two annual cycles to work with.

A longer history would provide more information about seasonal patterns and could make the forecast more reliable.

### **Backtest limitations**

The backtest only uses six months of test data and 18 months of training data. This means the 22% MAPE result is based on a relatively small test period.

### **Seasonality**

The backtest's automatic seasonality detection did not identify a reliable cycle from the 18-month training period.

The final forecast therefore uses a manually specified 12-month seasonal period. This is reasonable for the monthly retail data, but it is still a limitation because there are only two years of historical observations.

### **Forecast uncertainty**

The confidence interval becomes wider further into the forecast.

The lower confidence bound also becomes negative around the middle of the forecast period. This does not mean that negative revenue is actually being predicted. Instead, it shows that the model's uncertainty becomes very large further into the forecast.

### **Working capital assumption**

The 55% COGS figure is an assumption because the original transaction data does not contain cost information.

A better model would use actual cost or gross margin data.

### **Simple scenarios**

The scenarios simply increase or decrease the forecast by 10%.

They are intended as basic what-if scenarios rather than detailed financial forecasts.

---

## **What I Learned**

This project gave me practice with taking a dataset through several stages rather than analysing it in just one tool.

In particular, I practised:

* Importing and working with a large dataset in MySQL  
* Writing SQL to clean and aggregate transaction data  
* Creating a smaller dataset for analysis  
* Moving the SQL output into an Excel model  
* Using Excel forecasting functions  
* Carrying out a basic train/test backtest  
* Calculating MAPE and APE  
* Creating simple scenario calculations  
* Building an executive dashboard

The main thing I took from the project was that getting a forecast is only part of the process. Checking how the model performs and understanding its limitations is also important before using the results for business planning.

