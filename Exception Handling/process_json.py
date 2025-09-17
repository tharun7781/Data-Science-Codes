import os
import json
import pandas as pd
import csv

# Paths
DATA_FOLDER = r"C:\Users\THARUN\Downloads\project\data"
OUTPUT_FILE = r"C:\Users\THARUN\Downloads\project\output\batch_output.csv"

# Columns for CSV
COLUMNS = [
    "ticket_id", "priority", "category", "status", "created_date", "resolved_date",
    "assigned_to", "subject", "description", "resolution", "resolution_steps",
    "time_spent_minutes", "tags", "impact", "root_cause", "prevention_measures",
    "user.name", "user.department", "user.email", "source_file"
]

def load_json_files(folder_path):
    all_records = []

    # Get all JSON files in folder
    files = [f for f in os.listdir(folder_path) if f.endswith(".json")]
    print(f"Looking for JSON files in: {folder_path}")
    print(f"Found {len(files)} files.")

    for file in files:
        file_path = os.path.join(folder_path, file)
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)
        except Exception as e:
            print(f"❌ Failed to load {file}: {e}")
            continue

        # Build a row
        row = {
            "ticket_id": data.get("ticket_id", ""),
            "priority": data.get("priority", ""),
            "category": data.get("category", ""),
            "status": data.get("status", ""),
            "created_date": data.get("created_date", ""),
            "resolved_date": data.get("resolved_date", ""),
            "assigned_to": data.get("assigned_to", ""),
            "subject": data.get("subject", ""),
            "description": data.get("description", ""),
            "resolution": data.get("resolution", ""),
            "resolution_steps": "; ".join(data.get("resolution_steps", [])),
            "time_spent_minutes": data.get("time_spent_minutes", ""),
            "tags": "; ".join(data.get("tags", [])),
            "impact": data.get("impact", ""),
            "root_cause": data.get("root_cause", ""),
            "prevention_measures": data.get("prevention_measures", ""),
            "user.name": data.get("user", {}).get("name", ""),
            "user.department": data.get("user", {}).get("department", ""),
            "user.email": data.get("user", {}).get("email", ""),
            "source_file": file
        }

        all_records.append(row)
        print(f"📂 Processed {file}")

    # Create DataFrame
    df = pd.DataFrame(all_records, columns=COLUMNS)

    # Sort by ticket_id
    df = df.sort_values(by="ticket_id").reset_index(drop=True)

    return df

def main():
    df = load_json_files(DATA_FOLDER)
    if df.empty:
        print("⚠️ No data to save.")
        return

    print(f"✅ Final DataFrame Shape: {df.shape}")

    # Save CSV with all text fields quoted for Excel readability
    df.to_csv(
        OUTPUT_FILE,
        index=False,
        encoding="utf-8",
        quoting=csv.QUOTE_ALL
    )
    print(f"📁 CSV saved to: {OUTPUT_FILE}")
    print("💡 Open in Excel and apply 'Format as Table' for a clean table view.")

if __name__ == "__main__":
    main()
