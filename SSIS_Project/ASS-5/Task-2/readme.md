## 📌 Project Overview

This SSIS solution automates the process of copying files from a **Source** directory to a **Destination** directory. The package is designed with "Skip" logic: it will only copy files that do not already exist in the target folder, preventing unnecessary processing and avoiding errors caused by file name conflicts.

## 📂 Directory Structure

Based on the project setup, the system utilizes the following local folders:

- **Source**: `D:\...\Source` (The origin of the files to be copied)
- **Destination**: `D:\...\Destination` (The target backup location)

## ⚙️ Package Architecture

The solution is built within the **Control Flow** using a dynamic loop:

### 1. File Discovery (Foreach Loop Container)

- **Enumerator**: Set to `Foreach File Enumerator`
- **Configuration**: Points to the **Source** folder and looks for all files (`*.*`)
- **Variable Mapping**: Extracts the full path of each discovered file into a variable called `User::CurrentFilePath`

### 2. File Transfer (File System Task)

- **Operation**: Set to `Copy file`
- **Source Connection**: Uses the `CurrentFilePath` variable via an expression
- **Destination Connection**: Points to the **Destination** folder
- **Skip Logic (OverwriteDestination)**:
    - The **`OverwriteDestination`** property is set to **`False`**
    - **How it works**: When SSIS attempts to copy a file that is already there, the task will encounter a conflict. By setting the `MaximumErrorCount` or using an `OnTaskFailed` precedence constraint, you can ensure the loop continues to the next file without crashing

## 🛠️ Variables & Configuration

| **Variable Name** | **Scope** | **Data Type** | **Purpose** |
| --- | --- | --- | --- |
| `CurrentFilePath` | Package | String | Holds the full path of the current file being processed |
| `SourceFolder` | Package | String | Path to the source directory |
| `DestinationFolder` | Package | String | Path to the destination directory |

## 🚀 Execution Workflow

1. **Preparation**: Ensure files are present in the `Source` directory
2. **Initial Run**: Execute the package. All files are copied to the `Destination` folder
3. **Subsequent Runs**: Add new files to the `Source` folder and run the package again
4. **Verification**:
    - New files will be copied successfully
    - Files already present in the `Destination` will be skipped (ignored), and the package will move to the next item in the list

## ✅ Key Features

- **Automatic Skip Logic**: Prevents duplicate file copying and conflicts
- **Error Handling**: Gracefully handles file conflicts without package failure
- **Dynamic Processing**: Loops through all files in the source directory automatically
- **Configurable Paths**: Easy to modify source and destination folders via variables
