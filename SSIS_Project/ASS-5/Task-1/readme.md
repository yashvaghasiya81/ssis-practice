## Project Overview

This solution consists of two independent SSIS packages designed to handle retail sales data. The first package dynamically imports data from multiple `.csv` files into a SQL Server database, and the second package moves those processed files to an archive directory to maintain folder hygiene.

## 📦 Package 1: Dynamic Data Load

This package focuses on the "Extract and Load" portion of the ETL process.

- **Foreach Loop (File Enumerator):** Iterates through every `.csv` file in the source directory.
- **Variable Mapping:** Extracts the file path of each file into a variable (e.g., `User::CurrentFilePath`).
- **Data Flow Task:**
    - **Flat File Source:** Uses an **Expression** on the ConnectionString to dynamically point to the `CurrentFilePath`.
    - **OLE DB Destination:** Maps and loads the data into the SQL Server retail table.

## 📦 Package 2: Automated File Archiving

This package handles the "Cleanup" phase after the load is verified.

- **Foreach Loop (File Enumerator):** Again, loops through the source folder to find the files that were just processed.
- **File System Task:**
    - **Operation:** `Move file`.
    - **Source:** Uses the `CurrentFilePath` variable.
    - **Destination:** Points to the `\Archive` folder path.
- **Result:** The source folder is cleared, and all processed data is safely stored in the archive for history.

## 🛠️ Project Configuration

### Prerequisites

- SQL Server 2016 or later
- SQL Server Data Tools (SSDT) or Visual Studio with SSIS extension
- Appropriate permissions to read/write files and access SQL Server

### Setup Instructions

1. Create a `Data` folder in your project directory for incoming CSV files.
2. Create an `Archive` folder in your project directory for processed files.
3. Configure the SQL Server connection string in the OLE DB Connection Manager.
4. Ensure the destination table schema matches your CSV file structure.
5. Update folder paths in both packages to match your environment.

## 🚀 Workflow Summary

1. **Drop Files:** Add your CSV files to the `Data` folder.
2. **Execute Load Package:** The loop finds all files and loads them into SQL one by one.
3. **Execute Move Package:** The loop finds the same files and moves them to the `Archive` folder.

## 📁 Directory Structure

```
ProjectRoot/
├── Data/              # Source folder for incoming CSV files
├── Archive/           # Destination folder for processed files
├── Package1_Load.dtsx # SSIS package for data import
└── Package2_Move.dtsx # SSIS package for file archiving

```

