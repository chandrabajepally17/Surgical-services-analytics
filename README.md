# Surgical-services-analytics
# Surgical Services Analytics Dashboard

## Project Overview
An end-to-end healthcare analytics pipeline built to support Surgical Services 
operational and financial decision-making. This project mirrors the analytical 
work performed by hospital Business Intelligence teams supporting surgical 
service lines.

## Business Questions Answered
- Where are we losing OR time and revenue through scheduling inefficiencies?
- How do our surgical supply costs compare to national benchmarks?
- Which service lines are most and least financially efficient?
- How can we optimize OR staffing to reduce overtime and idle time?
- What factors drive day-of surgical case cancellations?

## Tech Stack
| Layer | Tool |
|---|---|
| Ingestion | Azure Data Factory |
| Storage | Azure Data Lake Storage Gen2 |
| Transformation | Databricks (PySpark + SQL) |
| ML Models | Python (scikit-learn) |
| Visualization | Power BI |
| Version Control | Git + GitHub |

## Data Sources
- CMS Medicare Inpatient Hospitals by Provider & Service (FY2023)
- CMS Healthcare Cost Report Information System (HCRIS)
- Synthetic OR Scheduling Data (generated from published industry benchmarks)

## Project Structure
\`\`\`
surgical-services-analytics/
├── data/               ← Sample data and source documentation
├── notebooks/          ← Databricks notebooks (ingestion → transformation → ML)
├── sql/                ← Standalone SQL scripts
├── outputs/            ← Model metrics and dashboard-ready CSVs
├── powerbi/            ← Power BI dashboard file (.pbix)
└── docs/               ← Data dictionary, KPI definitions, executive summary
\`\`\`

## Dashboard Pages
1. Executive Surgical Scorecard
2. OR Utilization & Scheduling Efficiency
3. Supply Chain Cost Analysis
4. Staffing Efficiency
5. Financial Performance by Service Line

## Status
🔄 In Progress — Phase 1: Data Ingestion
