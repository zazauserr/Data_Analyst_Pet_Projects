#  A/B Testing Analysis: Cookie Cats Gate Placement

##  Project Overview
This project evaluates the results of an A/B test for the mobile game **Cookie Cats**. We analyze how moving the first "gate" (a progression barrier) from **level 30** to **level 40** affects player retention and engagement.

##  Key Metrics
To assess the impact, we focus on the following KPIs:
* **Retention 1D/7D:** Percentage of players returning 1 and 7 days after installation.
* **Game Rounds:** Total number of game rounds played by each user during the first 14 days.

##  Tech Stack & Methods
* **SQL:** Initial data extraction and outlier filtering.
* **Python (Pandas, Seaborn):** Exploratory Data Analysis (EDA) and visualization.
* **Statistical Analysis:** * **Bootstrapping (10,000 iterations):** To calculate the probability of superiority for retention rates.
    * **Mann-Whitney U Test:** To compare game round distributions (non-normal data).

##  Key Insights
1.  **Retention Drop:** There is a **98.2% probability** that Day-7 retention is higher when the gate is at level 30 compared to level 40.
2.  **Player Burnout:** Moving the gate later (level 40) leads to lower long-term engagement. The early gate at level 30 likely serves as a beneficial "forced break" that prevents player exhaustion.
3.  **Statistical Significance:** The bootstrap distribution of the difference in means clearly shows that the effect is not due to chance.

##  Business Recommendation
**Reject the change.** Moving the gate to level 40 negatively impacts long-term player retention. I recommend keeping the gate at **Level 30** to maximize player lifetime value (LTV).

---
##  Project Structure
* **sql/** : SQL scripts for data retrieval.
* **notebooks/** : Detailed Jupyter Notebook with Python code and visualizations.
* **data/** : Source dataset (Cookie Cats).

**Author:** Bohdan Kudelia