"""Audit downloaded CSV/Excel files without changing source files."""
from __future__ import annotations
import json
from pathlib import Path
import sys
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "data" / "raw"
REPORT_DIR = ROOT / "reports"
REPORT_DIR.mkdir(parents=True, exist_ok=True)


def audit_frame(df: pd.DataFrame, file_path: Path, sheet_name: str | None = None) -> dict:
    total = len(df)
    missing = df.isna().sum()
    return {
        "file": str(file_path.relative_to(ROOT)),
        "sheet": sheet_name or "",
        "rows": int(df.shape[0]),
        "columns_count": int(df.shape[1]),
        "columns": list(map(str, df.columns)),
        "duplicate_rows": int(df.duplicated().sum()),
        "missing_cells": int(df.isna().sum().sum()),
        "missing_pct": round(float(df.isna().sum().sum() / max(df.size, 1) * 100), 2),
        "missing_by_column": {str(k): int(v) for k, v in missing.items()},
        "dtypes": {str(k): str(v) for k, v in df.dtypes.items()},
        "sample_rows": df.head(3).where(pd.notna(df.head(3)), None).to_dict(orient="records"),
    }


def main() -> int:
    if not RAW_DIR.exists():
        print(f"Raw-data folder not found: {RAW_DIR}")
        return 1
    results: list[dict] = []
    supported = {".csv", ".xlsx", ".xls"}
    paths = sorted(p for p in RAW_DIR.rglob("*") if p.is_file() and p.suffix.lower() in supported)
    if not paths:
        print("No CSV/Excel files found in data/raw/. Download the registered datasets first.")
        return 0

    for path in paths:
        print(f"Auditing: {path.relative_to(ROOT)}")
        try:
            if path.suffix.lower() == ".csv":
                df = None
                errors = []
                for encoding in ("utf-8-sig", "utf-8", "cp1252", "latin1"):
                    try:
                        df = pd.read_csv(path, encoding=encoding, low_memory=False)
                        break
                    except Exception as exc:  # try common encodings
                        errors.append(f"{encoding}: {exc}")
                if df is None:
                    raise RuntimeError("Could not parse CSV. " + " | ".join(errors))
                results.append(audit_frame(df, path))
            else:
                sheets = pd.read_excel(path, sheet_name=None)
                for sheet_name, df in sheets.items():
                    results.append(audit_frame(df, path, sheet_name))
        except Exception as exc:
            results.append({"file": str(path.relative_to(ROOT)), "error": str(exc)})
            print(f"  ERROR: {exc}", file=sys.stderr)

    json_path = REPORT_DIR / "data_audit.json"
    csv_path = REPORT_DIR / "data_audit_summary.csv"
    json_path.write_text(json.dumps(results, indent=2, ensure_ascii=False, default=str), encoding="utf-8")
    summary = []
    for r in results:
        summary.append({
            "file": r.get("file"), "sheet": r.get("sheet", ""), "rows": r.get("rows"),
            "columns_count": r.get("columns_count"), "duplicate_rows": r.get("duplicate_rows"),
            "missing_cells": r.get("missing_cells"), "missing_pct": r.get("missing_pct"),
            "error": r.get("error", "")
        })
    pd.DataFrame(summary).to_csv(csv_path, index=False)
    print(f"\nAudit complete. Reports written to:\n- {json_path}\n- {csv_path}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
