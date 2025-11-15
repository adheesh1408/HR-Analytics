# HR Attrition & Employee Experience Analysis

## Executive Summary
Employee attrition has been significantly higher than expected (32.15%), prompting the need to identify key drivers and opportunities for improvement. Using SQL and Tableau, I analyzed employee-level data across tenure, engagement, satisfaction, promotion history, and department to determine where turnover is concentrated and what differentiates employees who stay vs. employees who leave.

The analysis shows that attrition is heavily concentrated among mid-tenure employees (2–5 years), varies sharply across departments, and is not directly correlated with engagement scores alone. Based on these findings, I recommend directing HR and leadership teams to focus on mid-tenure intervention, departmental experience gaps (especially Marketing and Engineering), and deeper investigation into HR/Support turnover despite strong engagement.
You can view the presentation report **[here](https://docs.google.com/presentation/d/1XayJ3aEV7NgKlZuZ55NJNlKVOQW6HrwZ/edit?slide=id.p9#slide=id.p9)**.

## Business Problem
Turnover directly impacts productivity, hiring costs, team stability, and organizational knowledge retention. Leadership observed higher-than-normal attrition and inconsistent employee experience metrics across departments. The goal of this analysis was to determine:
1. Which employee segments are most at risk of leaving  
2. Which experience indicators are associated with attrition  
3. Where leadership should prioritize investigation and resource allocation to improve retention  

<img width="1491" height="722" alt="image" src="https://github.com/user-attachments/assets/75792843-e4fb-4d8c-87d9-c0a16f6110ce" />


## Methodology
- **SQL** to clean data and build views for tenure buckets, department KPIs, and engagement/satisfaction summaries.
- **Tableau** to create two dashboards:
  - *Company Overview:* High-level KPIs and department-level comparisons  
  - *Attrition Explorer:* Attrition vs. engagement, tenure bucket breakdowns, and experience segmentation  
- Segmented data by department, tenure bucket, attrition status, engagement score, satisfaction score, promotion history, and gender.

<img width="1457" height="755" alt="image" src="https://github.com/user-attachments/assets/dd28fcd4-6192-4027-8e6f-80ab7633b4cf" />


## Key Insights
### Company-Level Metrics
- **Attrition Rate:** 32.15%: nearly one-third of employees exited the company.
- **Average Tenure:** 4.47 years: most turnover occurs before long-term stability is reached.
- **Engagement Score:** 3.78: moderate overall, but varies widely by department.
- **Satisfaction Score:** 3.64: slightly lower than engagement, indicating morale challenges.
- **Promotion Rate:** 36.75%: unevenly distributed across departments.

### Segmented Findings
1. **Tenure Matters Most**
   - Employees who attrited clustered between **2.6–3.7 years** of tenure.
   - Employees who stayed were concentrated at **4–5+ years**.
   - Virtually **zero attrition** occurred in the 5+ year group.

2. **Departmental Gaps Are Significant**
   - **HR:** Highest attrition (50%) despite highest engagement (4.1): indicates structural or workload issues.
   - **Marketing:** Lowest engagement (3.52) and low satisfaction: clear risk area.
   - **Engineering:** Weak promotion opportunities (14.3%) and moderate engagement: potential stagnation.
   - **Support:** High promotion (80%) but also high attrition (40%): suggests increased pressure post-promotion.

3. **Engagement Alone Is Not Predictive**
   - High-engagement employees still left in the HR and Support departments.
   - Satisfaction differences were more aligned with department-level issues, not individual performance.
   <img width="1033" height="474" alt="image" src="https://github.com/user-attachments/assets/65832974-4cc4-4857-8780-6a02d262f1d6" />


## Results & Recommendations
The dashboards provide leadership with a clear view of the employee experience and attrition landscape. Stakeholders can now slice patterns by department, tenure, and engagement without relying on ad hoc analysis.

Based on the analysis, the strongest levers for reducing turnover are:

### Reduce Attrition
- **Prioritize mid-tenure retention efforts**, especially between years 2–5 (where most departures occur).
- **Investigate HR and Support workflows** to understand why high-engagement/high-promotion employees still choose to leave.

### Improve Employee Experience
- **Strengthen Marketing and Engineering experience**, focusing on morale, workload, and recognition.
- **Evaluate promotion pathways**, particularly for Engineering, to improve long-term engagement and reduce stagnation.
  <img width="1028" height="574" alt="image" src="https://github.com/user-attachments/assets/b71ac600-b3aa-4228-8f07-05a97df490b3" />


## Next Steps
- Incorporate compensation, workload, and performance scores for deeper modeling.
- Implement quarterly employee experience surveys to track progress.
- Build automated data refresh pipelines and transition dashboards to leadership self-service.

## Skills Demonstrated
- SQL (joins, aggregations, case logic, CTEs)
- Tableau (data modeling, dashboard design, segmentation analysis)
- Data cleaning, KPI development, trend analysis

## Tableau Dashboard
View the interactive dashboards **[here](https://public.tableau.com/app/profile/adheesh.ghotikar/viz/CompanyOverview_17631798868540/Dashboard1?publish=yes)** and **[here](https://public.tableau.com/app/profile/adheesh.ghotikar/viz/EmployeeAttritoninsights/Dashboard1?publish=yes)**


## Note
This dataset is synthetically generated and used solely for analysis and demonstration purposes.
By Adheesh Ghotikar
