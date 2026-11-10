# Project status

## Completed in starter setup
- Defined project scope and excluded all private/Bling Bazaar data.
- Registered five candidate public datasets with provenance caveats.
- Created initial PostgreSQL schema and a derived-metrics view.
- Added a Python CSV/Excel audit script.
- Added dataset register and first data dictionary.

## Immediate next actions
1. Download REELS300 workbook + technical report from https://doi.org/10.5281/zenodo.23301344.
2. Download LIBRARY1681 workbook from https://zenodo.org/records/11102526.
3. Download IGEXPORT119 CSV from https://github.com/anupratheepa/Instagram-Reach-Analysis.
4. Optionally download CROSSPLATFORM3379; check rights before redistribution.
5. Do not use HF30K_SANDBOX for real-world claims until provenance is verified.
6. Run `python src/audit_data.py` and inspect results before importing into PostgreSQL.

## Current blocker
The starter workspace does not contain the dataset binaries yet. Download the source files into the exact paths documented in README.md, then run the audit script.
