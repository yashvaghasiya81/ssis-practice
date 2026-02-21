

## 📌 Project Overview

This SSIS package is designed to dynamically extract data from multiple SQL Server retail tables and consolidate them into a single CSV file. The package utilizes dynamic SQL generation and looping to handle any number of tables matching a specific pattern without requiring manual updates to the workflow.

## ⚙️ Package Architecture

The workflow follows a 5-phase execution model:

### 1. Metadata Collection (Execute SQL Task)

- **Action:** Queries the database schema (e.g., `SELECT name FROM sys.tables`) to find target tables.
- **Storage:** Saves the list of table names into an Object variable called `TableList`.

### 2. Iteration Logic (Foreach Loop Container)

- **Enumerator:** Uses the `Foreach ADO Enumerator` to loop through the `TableList`.
- **Mapping:** During each iteration, the current table name is mapped to a String variable named `TableName`.

### 3. Dynamic SQL Construction

- **Variable:** `SQLQuery`
- **Expression:** `"SELECT * FROM " + @[User::TableName]`
- **Result:** Automatically updates the SQL command for every loop iteration (e.g., `Customer1`, `Customer2`).

### 4. Verification (Script Task)

- **Action:** Triggers a popup message box displaying the current `TableName`.
- **Purpose:** Acts as a debug checkpoint to verify the loop is processing the correct table.

### 5. Data Migration (Data Flow Task)

- **Source:** OLE DB Source using the dynamic `SQLQuery` variable.
- **Destination:** Flat File Destination (`AllCustomers.csv`).
- **Logic:** The "Overwrite" property is disabled to allow data to append (stack) into one single file.

## 🛠️ Variables Used

| **Variable Name** | **Data Type** | **Purpose** |
| --- | --- | --- |
| `TableList` | Object | Stores the list of table names retrieved from the database |
| `TableName` | String | Holds the current table name during each loop iteration |
| `SQLQuery` | String | Dynamically constructed SQL query for data extraction |
| `FilePath` | String | Destination path for the consolidated CSV file |

## 🚀 How to Run

1. Ensure the destination folder in the `FilePath` variable exists.
2. Update the **Connection Manager** to point to your local SQL Server instance.
3. Execute the package.
4. Verify the popups for `Customer1`, `Customer2`, and `Customer3`.
5. Check the final output at `AllCustomers.csv` (Expected total: 225-301 rows depending on schema).

## 📦 Prerequisites

- SQL Server 2016 or later
- SQL Server Data Tools (SSDT) or Visual Studio with SSIS extension
- Appropriate database permissions to read table metadata and data

## 🔧 Configuration

**Database Connection:**

- Update the OLE DB Connection Manager with your server name and database credentials
- Test the connection before running the package

**Output File Path:**

- Modify the `FilePath` variable to specify your desired output location
- Ensure write permissions are granted for the destination folder

**Table Pattern:**

- By default, the package targets tables matching the pattern `Customer%`
- Modify the SQL query in the Execute SQL Task to change the table selection criteria

## 📝 Notes

- The CSV file will be appended with data from each table, not overwritten
- If the output file exists from a previous run, delete it before executing to avoid duplicate data
- The Script Task popups are for debugging purposes and can be disabled in production
- All tables must have compatible schemas for successful consolidation

## 🐛 Troubleshooting

**Issue:** No tables found

- **Solution:** Verify the table naming pattern and ensure tables exist in the connected database

**Issue:** Schema mismatch errors

- **Solution:** Ensure all target tables have identical column structures (name, type, order)

**Issue:** File access denied

- **Solution:** Check folder permissions and ensure the path in `FilePath` variable is valid

## 👨‍💻 Author

YASH VAGHASIYA



February 21, 2026
