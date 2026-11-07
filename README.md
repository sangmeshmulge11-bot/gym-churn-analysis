# Gym Membership Churn Analysis

Why do gym members leave, and what could the gym do about it? I analysed 4,000 members using **SQL Server** and **Python**.

![Dashboard]

## Dataset
Public Kaggle dataset "Gym Customers Features and Churn" (4,000 members, 14 columns). It is not documented how the data was collected and it may be synthetic, so this project is practice for the method rather than a real gym's results.

## Tools
- SQL Server (SSMS): data loading, cleaning and analysis queries
- Python: pandas and matplotlib for analysis and the dashboard

## Key findings
- 26.5% of members left overall.
- 61% of members in their first month left. After 4 months, churn fell below 4%.
- 1-month contracts had 42% churn, compared with 2.4% for 12-month contracts.
- Members who attend group classes or joined through a friend offer left about half as often.
- Members whose visits dropped by more than half had 94% churn.
- 21 active members barely visit the gym, so they are the first to contact.

## Recommendations
1. Run a first-30-days plan, such as a free group class and a friend offer.
2. Encourage 1-month members to move to 6 or 12-month plans.
3. Contact members whose visits have dropped.

## Limitations
- A drop in visits is partly a result of leaving, so it is a warning sign and not a prediction.
- The dataset is public and may be synthetic.

## Files
- [SQL queries]
- [Python notebook](gym%20project.ipynb)
- `gym dashboard.png`: dashboard image
