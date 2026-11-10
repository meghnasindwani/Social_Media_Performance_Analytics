## Project Scope

1. In-scope activities
These are the activities this project will cover.
- Collection of publicly available social media datasets.
- Data profiling and quality assessment.
- Data cleaning and preprocessing using Python.
- Database design and storage using PostgreSQL.
- SQL-based data analysis.
- Exploratory data analysis using Python.
- Statistical analysis and hypothesis testing.
- Machine learning, provided the data supports suitable modelling.
- Development of an evidence-based recommendation engine.
- Interactive dashboard development using Power BI.
- Interactive application development using Streamlit.
- Testing, validation and documentation.

2. Out-of-scope activities
These are things the project is not deliberately promising to implement.
- Access to private social media accounts.
- Collection of private or personally identifiable user information.
- Automatic publishing or scheduling of social media posts.
- Direct management of social media accounts.
- Guaranteed increases in engagement, reach or followers.
- Real-time social media API integration in the initial version.
- Predictive modelling where the available data is insufficient.

3. Project assumptions and constraints
The conditions under which the project will be developed.

- Only publicly available datasets will be used.
- Dataset availability and quality may limit certain analyses.
- Different datasets may represent different populations and metric definitions.
- Machine learning objectives will be finalised after examining the data.
- The system is an academic prototype, not a production-grade commercial platform.
- Recommendations will be based on observed evidence, not guaranteed outcomes.

## Project Methodology

1. Data Acquisition
Actions to be performed:
1. Identify publicly available social media datasets.
2. Download relevant datasets from trusted public repositories.
3. Record the source URL, publisher, date accessed and dataset description.
4. Examine the licence and usage conditions.
5. Store original datasets in the raw data folder.
6. Assign a unique name or identifier to each dataset.
Tool: Python, Pandas (for initial inspection), web repositories.
Output: Raw datasets and dataset register.

2. Data Understanding
Actions to be performed:
1. Identify the number of records and columns in each dataset.
2. Examine column names and their meanings.
3. Identify data types.
4. Calculate missing-value counts.
5. Identify duplicate records.
6. Examine unique categories and value distributions.
7. Identify potential analytical questions that each dataset can answer.
Tools: Python, Pandas, NumPy, Jupyter Notebook.
Output: Dataset profiling report and data dictionary.

3. Data Preprocessing
Actions to be performed:
1. Standardise column names.
2. Correct inconsistent data types.
3. Investigate missing values and decide how to handle them.
4. Identify and handle duplicate records.
5. Investigate invalid or inconsistent values.
6. Standardise date and categorical fields.
7. Identify outliers and decide whether they are genuine observations or errors.
8. Save cleaned datasets separately from the original files.
9. Document every preprocessing decision.
Tools: Python, Pandas, NumPy.
Output: Cleaned datasets and data quality report.

4. Database Development
Actions to be performed:
1. Identify database requirements.
2. Design the database schema.
3. Identify appropriate tables and columns.
4. Select suitable SQL data types.
5. Define primary keys and constraints where appropriate.
6. Create the PostgreSQL database.
7. Create the required tables.
8. Import cleaned datasets.
9. Validate imported records against the cleaned source files.
Tools: PostgreSQL, SQL, pgAdmin (optional graphical interface).
Output: Functional PostgreSQL database and schema documentation.

5. Exploratory Data Analysis
Actions to be performed:
1. Calculate descriptive statistics.
2. Examine metric distributions.
3. Analyse engagement-related metrics.
4. Compare performance across content formats.
5. Analyse content categories and characteristics.
6. Examine discovery sources and audience actions.
7. Identify relationships between relevant variables.
8. Create appropriate charts and visualisations.
9. Document important observations.
Tools: Python, Pandas, NumPy, Matplotlib, Seaborn.
Output: EDA notebooks, charts and analytical findings.

6. Statistical Analysis
Actions to be performed:
1. Formulate relevant statistical hypotheses.
2. Identify suitable statistical tests.
3. Examine correlations and associations.
4. Conduct hypothesis testing where assumptions are satisfied.
5. Calculate relevant significance measures and effect sizes.
6. Interpret results.
7. Document statistical limitations.
Tools: SciPy, Statsmodels, Python.
Output: Statistical analysis report.

7. Machine Learning
Actions to be performed:
1. Identify a suitable prediction or classification problem.
2. Select a valid target variable.
3. Identify relevant input features.
4. Examine dataset size and suitability.
5. Prepare training and testing datasets.
6. Build a baseline model.
7. Train suitable machine learning algorithms.
8. Compare model performance.
9. Evaluate models using appropriate metrics.
10. Interpret model behaviour and feature importance.
11. Document limitations and possible overfitting.
Tools: Scikit-learn, XGBoost or CatBoost, SHAP (where applicable).
Output: Evaluated ML model and model performance report, if feasible.

8. Recommendation Engine
Actions to be performed:
1. Identify meaningful patterns from EDA and statistical analysis.
2. Identify content characteristics associated with relevant performance metrics.
3. Define recommendation criteria.
4. Develop recommendation rules based on analytical findings.
5. Integrate validated model outputs if appropriate.
6. Generate recommendations for content formats, categories and characteristics.
7. Display the reasoning or evidence behind each recommendation.
8. Validate recommendations against the underlying analysis.
Tools: Python, Pandas, Scikit-learn (if model-assisted).
Output: Evidence-based recommendation engine.

9. Dashboard and Application Development
Actions to be performed:
~ Power BI
1. Identify dashboard KPIs.
2. Connect to the relevant analytical data.
3. Design dashboard pages.
4. Create charts, tables and KPI cards.
5. Implement interactive filters.
6. Validate dashboard calculations.
~ Streamlit
1. Plan application layout.
2. Develop the user interface.
3. Integrate analytical results.
4. Create interactive data exploration features.
5. Integrate recommendation functionality.
6. Display model predictions only where validated models exist.
7. Test application functionality.
Tools: Power BI, Streamlit, Python.
Output: Interactive dashboard and working application.

10. Testing and Validation
Actions to be performed:
1. Verify data quality and database consistency.
2. Test SQL queries.
3. Verify analytical calculations.
4. Validate statistical interpretations.
5. Evaluate model performance, if applicable.
6. Test recommendation outputs.
7. Test Power BI interactions.
8. Test Streamlit functionality.
9. Document errors and corrective actions.
10. Prepare the final validation report.
Tools: Python, SQL, Power BI, Streamlit.
Output: Testing and validation report.

## Expected Deliverables

These are the tangible things the project should have:
___________________________________________________________________________________________________________     
| No.| Deliverable                    | Description                                                        |
____________________________________________________________________________________________________________
|---:|---                             |---                                                                 |
| 1  | Project documentation          | Problem statement, objectives, scope, WBS and methodology          |
| 2  | Dataset repository             | Original public datasets with source information                   |
| 3  | Data profiling report          | Dataset structure, data types and quality assessment               |
| 4  | Data dictionary                | Definitions and descriptions of dataset attributes                 |
| 5  | Cleaned datasets               | Preprocessed and analysis-ready datasets                           |
| 6  | Data quality report            | Missing values, duplicates, inconsistencies and cleaning decisions |
| 7  | PostgreSQL database            | Structured database containing the cleaned datasets                |
| 8  | SQL query repository           | Queries used for analytical investigation                          |
| 9  | EDA notebooks                  | Python notebooks containing exploration and visualisations         |
| 10 | Statistical analysis report    | Hypothesis tests, correlations and interpretations                 |
| 11 | ML model and evaluation report | Model, performance comparison and limitations, if feasible         |
| 12 | Recommendation engine          | Functional recommendation logic with supporting evidence           |
| 13 | Power BI dashboard             | Interactive social media analytics dashboard                       |
| 14 | Streamlit application          | Interactive application for exploring results and recommendations  |
| 15 | Testing report                 | Validation of the database, analytics, models and interfaces       |
| 16 | GitHub repository              | Organised source code and project documentation                    |
| 17 | Final project report           | Complete academic documentation of the project                     |
| 18 | Presentation and demonstration | PPT and working project demonstration                              |
____________________________________________________________________________________________________________

