# Data Sources

## Raw Data Files (not tracked in Git — too large)

| File | Source | Rows | Description |
|---|---|---|---|
| cms_inpatient_provider_service.csv | data.cms.gov | 146,400 | Medicare inpatient by hospital and DRG procedure |
| cms_inpatient_by_provider.csv | data.cms.gov | ~3,000 | Hospital-level summary |
| cms_hospital_general_info.csv | data.cms.gov | ~5,000 | Hospital names, addresses, type, ratings |
| cms_complications_deaths.csv | data.cms.gov | ~30,000 | Surgical complication rates by hospital |

## Download Instructions
All files available free at: https://data.cms.gov
Search exact dataset names listed above.
Select CSV format and most recent year available (2023).

## Data Notes
- cms_inpatient_provider_service.csv is our PRIMARY dataset
- All files join on hospital identifier (Facility ID / Provider CCN)
