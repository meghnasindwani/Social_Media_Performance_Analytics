# Social Media Performance Analytics & Recommendation System

**Project owner:** Meghna  
**Programme:** MCA 1-B  
**Primary platform:** Instagram  
**Initial data scope:** Publicly available research and repository datasets only. No private client data and no Bling Bazaar data are included.

## 1. Project purpose

Build an end-to-end analytics workflow that examines how social-media content characteristics relate to observable post outcomes. The system will support descriptive analysis, content/hook analysis, statistical testing, visual reporting and (only where the data supports it) machine-learning experiments.

The project will distinguish observed source data from manually coded fields, derived metrics and synthetic demonstration data. Synthetic rows must never be presented as real observations or used to support empirical conclusions.

## 2. Data-source strategy

The datasets are **not one homogeneous sample**. They represent different populations and contain different fields. Analyse them separately where appropriate and combine only fields with defensible definitions.

| Code | Source | Records | Main use | Trust / caveat |
|---|---|---:|---|---|
| `REELS300` | Educational Instagram Reels coded dataset (Zenodo DOI 10.5281/zenodo.23301344) | 300 | Primary hook, video and creative-characteristic analysis | Research-curated public Reels; views/comments captured once at coding; one researcher coded the content; educational creators only. CC BY 4.0 is stated in the NLM catalogue record. |
| `LIBRARY1681` | Instagram posts from academic libraries (Zenodo record 11102526) | 1,681 | Caption, content category, post-type and interaction-rate analysis | Research dataset from 120 academic-library profiles. Different audience/industry; the record page does not clearly show a licence, so check rights before redistributing the file. |
| `CROSSPLATFORM3379` | Matched Facebook/Instagram academic-library posts (Zenodo record 18590865) | 3,379 pairs | Supplementary cross-platform comparison | Different research question; record states copyright 2025 and does not clearly state an open licence. Use cautiously and do not redistribute without checking rights. |
| `IGEXPORT119` | 119-post Instagram export sample on GitHub | 119 | Supplementary EDA of impressions sources, saves, shares, profile visits and follows | Repository describes it as exported Instagram post data; original account, collection method and licence are not fully documented. Treat as limited-provenance sample. |
| `HF30K_SANDBOX` | Hugging Face Instagram engagement dataset | 30,000 | Optional pipeline/Power BI testing only | Dataset card/provenance is insufficiently documented. Do not treat as verified real-world Instagram observations or use it for primary conclusions. |

### Source links

- REELS300 record: https://doi.org/10.5281/zenodo.23301344
- REELS300 catalogue description: https://datasetcatalog.nlm.nih.gov/dataset?q=0003368729
- LIBRARY1681: https://zenodo.org/records/11102526
- CROSSPLATFORM3379: https://zenodo.org/records/18590865
- IGEXPORT119 repository: https://github.com/anupratheepa/Instagram-Reach-Analysis
- HF30K_SANDBOX: https://huggingface.co/datasets/maayan890/instagram-engagement-eda

## 3. Initial download instructions

Download files from the source pages and put them in `data/raw/` using these names:

1. `REELS300` workbook and its technical-report PDF, if provided:
   - `data/raw/reels300/educational_instagram_reels_300.xlsx`
   - `data/raw/reels300/educational_instagram_reels_300_technical_report.pdf`
2. `LIBRARY1681` workbook:
   - `data/raw/library1681/instagram_academic_libraries_1681.xlsx`
3. `CROSSPLATFORM3379` workbook:
   - `data/raw/crossplatform3379/facebook_instagram_crosspost_3379.xlsx`
4. `IGEXPORT119` CSV from the repository:
   - `data/raw/igexport119/instagram_export_119.csv`
5. Optional Hugging Face CSV, kept separate:
   - `data/raw/hf30k_sandbox/instagram_engagement_30000.csv`

Do not rename source columns inside the original file. Preserve raw files unchanged. Work on copies in `data/staging/` and `data/processed/`.

## 4. Project structure

```text
social_media_analytics_project/
├── data/
│   ├── raw/          # Original downloads; never edit these
│   ├── staging/      # Imported and minimally standardized data
│   └── processed/    # Clean analytical datasets
├── notebooks/        # Exploratory analysis notebooks
├── sql/              # PostgreSQL schema and analytical views
├── src/              # Reusable Python scripts
├── reports/          # Audit summaries, charts and exports
├── README.md
├── DATA_DICTIONARY.csv
├── DATASET_REGISTER.csv
└── requirements.txt
```

## 5. First execution steps

1. Download the source files listed above.
2. Place them in their designated `data/raw/` folders.
3. Create a Python environment and install dependencies:

```bash
python -m venv .venv
# Windows PowerShell:
.venv\Scripts\Activate.ps1
# macOS/Linux:
# source .venv/bin/activate
pip install -r requirements.txt
```

4. Run the initial file audit:

```bash
python src/audit_data.py
```

The script writes a file-level and sheet-level summary to `reports/` without modifying the raw downloads.
5. Review the audit before writing source-specific transformation code.
6. Create the PostgreSQL database and execute `sql/01_schema.sql`.

## 6. Analytical questions for the first version

### REELS300
- Which coded hook types are associated with higher views?
- How do hook duration and total video duration relate to views?
- Are CTA/comment prompts associated with different comment counts?
- How do subtitles, editing pace and visual support relate to observed performance?
- Do associations remain when comparing Reels within the same account?

### LIBRARY1681
- Which thematic categories and media types have higher reported interaction rates?
- Are caption length and publication timing associated with interaction rate?
- How does performance vary across academic-library profiles?

### CROSSPLATFORM3379
- How does interaction differ for matched posts across Facebook and Instagram?
- Is posting lag associated with the platform interaction difference?

### IGEXPORT119
- How do impression sources relate to likes, saves, shares, profile visits and follows?
- What does the profile-visit-to-follow conversion look like in this sample?

## 7. Important analytical rules

- Do not compare raw views across unrelated accounts without accounting for account size and account-level differences.
- Do not interpret correlation as causation.
- `REELS300` views/comments are a one-time snapshot, not lifetime or day-30 performance unless the source documents that timing.
- Interaction rate definitions can differ by source. Preserve the reported value and document its denominator when known; do not merge rates until definitions are compatible.
- Do not invent reach, impressions, saves, watch time, retention, follower conversions or revenue for real posts.
- Manually coded annotations must include an annotation method and, ideally, a codebook.
- Synthetic demonstration data must be marked `is_synthetic = TRUE` and excluded from observed-data analysis.
- Keep each dataset's population and scope visible in charts and reports.

## 8. Planned technology

- Python, Pandas and NumPy: cleaning, validation and EDA
- PostgreSQL and SQL: relational storage and analytical views
- SciPy / Statsmodels: statistical analysis
- Scikit-learn: appropriately scoped ML experiments
- Power BI: interactive reporting
- Git/GitHub: version control

## 9. Current status

**Started:** project structure, data-source register, initial relational schema and data-audit script.  
**Pending:** source workbooks/CSV need to be downloaded and placed in `data/raw/`; after that, inspect the real sheet names, columns, data types and missingness before building import pipelines.
