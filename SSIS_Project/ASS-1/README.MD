# SSIS_File_Copy_And_Zip_Automation

This project demonstrates an **SSIS automation workflow** that copies multiple files from a source folder to a destination folder and then compresses all copied files into a single ZIP archive.

The solution uses **Foreach Loop + File System Task + Execute Process Task (PowerShell)** to create a dynamic and scalable file handling pipeline.

---

## 🎯 Project Objective

Design and implement an SSIS package that:

* Reads multiple files from a source directory
* Copies all files to another folder
* Handles unknown/dynamic number of files
* Compresses copied files into one ZIP file
* Stores the ZIP file in a third folder
* Automates the entire process without manual steps

---



## 📂 Folder Structure

```
D:\SSIS_Practice\

│
├── Source\
│     ├── file1.xlsx
│     ├── file2.xlsx
│     ├── file3.xlsx
│
├── Destination\
│     (copied files)
│
└── ZipDestination\
      files_backup.zip
```

---

## 🧩 Package Architecture

The package contains two main stages:

```
Stage 1 → Copy Files
Stage 2 → Create ZIP
```

---

## 🔁 Control Flow Design

### 1️⃣ Foreach Loop Container

Purpose:
Iterates through all files in the Source folder dynamically.

Configuration:

* Enumerator → Foreach File Enumerator
* Folder → Source folder path
* Files → *.*
* Retrieve → Fully Qualified
* Variable → `User::FileName`

This variable holds the current file path during each iteration.

---

### 2️⃣ File System Task (Copy Files)

Purpose:
Copies each file from Source → Destination.

Configuration:

Operation:

```
Copy File
```

Connections:

* Source → `@[User::FileName]`
* Destination → Destination folder path

Result:
Each loop copies one file until all files are processed.



### 3️⃣ Execute Process Task (Create ZIP)

Purpose:
Compress all copied files into one ZIP file.

Executable:

```
powershell.exe
```

Arguments:

```
Compress-Archive -Path "D:\SSIS_Practice\Destination\*" -DestinationPath "D:\SSIS_Practice\ZipDestination\files_backup.zip" -Force
```

Explanation:

* Path → files to zip
* DestinationPath → zip output
* Force → overwrite existing zip

---

## 🔄 Execution Flow

Step-by-step:

1. Foreach Loop reads each file from Source
2. File System Task copies file to Destination
3. After loop completes, Execute Process Task runs
4. PowerShell compresses all files into one ZIP



Yash Vaghasiya


