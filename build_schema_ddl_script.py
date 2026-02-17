from datetime import datetime
from pathlib import Path

buildDate = datetime.today().strftime('%Y%m%d')

# change the name of the script file create can be done here.
# build date YYMMDD is added to script file name by default 

scriptFile = "./system_files_" + buildDate +".sql"

print(f"Building Script file : {scriptFile}... Please hold.")

# default schema name in script created is : system_files
# default "schema name" can be changed in file that 
# does the DELETE & CREATE commands. DDL variables are not.
# changed name in file : schema_name_set_here_for_build.sql

# check for files from previous builds and delete
delete_build_file = Path(scriptFile)
delete_build_file.unlink(missing_ok=True)

delete_build_file = Path("./build/combined_functions.sql")
delete_build_file.unlink(missing_ok=True)

delete_build_file = Path("./build/combined_procedures.sql")
delete_build_file.unlink(missing_ok=True)

delete_build_file = Path("./build/combined_tables.sql")
delete_build_file.unlink(missing_ok=True)

delete_build_file = Path("./views", "./build/combined_views.sql")
delete_build_file.unlink(missing_ok=True)

def combine_folder_files(input_dir, output_file_path):
    """
    Combines text files from an input directory into a single output file.

    Args:
        input_dir (str): The path to the directory containing the text files.
        output_file_path (str): The path for the combined output text file.
    """
    input_path = Path(input_dir)
    output_path = Path(output_file_path)

    with output_path.open("a", encoding="utf-8") as outfile:
        # Loop through all files ending with .sql in the directory
        for file_path in input_path.glob("*.sql"):
            print(f"Processing folder: {input_dir} file: {file_path.name}")
            if file_path.is_file():
                try:
                    with file_path.open("r", encoding="utf-8") as infile:
                        # Write a separator for clarity (optional)
                        outfile.write(f"-- # Start of file: {file_path.name} ---\n")
                        # Read the content and append to the output file
                        outfile.write(infile.read())
                        # outfile.write(f"--- End of file: {file_path.name} ---\n\n")
                except UnicodeDecodeError:
                    print(f"Skipping {file_path.name} due to encoding issues.")


# combined common subfolder scripts into single file for final build
combine_folder_files("./functions", "./build/combined_functions.sql")
combine_folder_files("./procedures", "./build/combined_procedures.sql")
combine_folder_files("./tables", "./build/combined_tables.sql")
combine_folder_files("./views", "./build/combined_views.sql")

# begin script string reads from database component files

def combine_list_files(file_list, output_file_path):
    """
    Combines text files from an input list[] into a single output file.

    Args:
        input_dir (str): The path to the directory containing the text files.
        output_file_path (str): The path for the combined output text file.
    """
    output_path = Path(output_file_path)

    with output_path.open("a", encoding="utf-8") as outfile:
        for item in file_list:
            file_name = item["file"]
            header_text = item["header"]
            if Path(file_name).is_file():
                print(f"Processing file: {file_name} with header: {header_text}")
                try:
                    with open(file_name, encoding="utf-8") as infile:
                        # Write a separator for clarity (optional)
                        outfile.write(f"-- {header_text} ---\n")
                        # Read the content and append to the output file
                        outfile.write(infile.read())
                        # outfile.write(f"--- End of file: {file_path.name} ---\n\n")
                except UnicodeDecodeError:
                    print(f"Skipping {file_name} due to encoding issues.")


script_list = []

script_list.append({"file": "./license_header.txt", "header": "Apache 2 License Info -- # comments at start each file"})
script_list.append({"file": "./change_schema_name_here_before_build.SQL", "header": "Script generated from database object scripts"})
script_list.append({"file": "./build/combined_tables.SQL", "header": "Tables below"})
script_list.append({"file": "./build/combined_functions.SQL", "header": "Functions below"})
script_list.append({"file": "./build/combined_procedures.SQL", "header": "Procedures below"})
script_list.append({"file": "./build/combined_views.SQL", "header": "Views below"})
script_list.append({"file": "./data/insert_defaut_data_here.SQL", "header": "Inserts default data into app tables below"})
script_list.append({"file": "./constraints/add_all.SQL", "header": "Indexes, Foreign Keys and Constraints for all Tables below"})
script_list.append({"file": "./scripts/mysql_user_and_grants.SQL", "header": "user files_to_mysql rights"})

combine_list_files(script_list, scriptFile)

print(f"Script file : {scriptFile} is complete. File contains DDL to create http logs schema.")
