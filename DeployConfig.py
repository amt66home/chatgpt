//This script will first run nocheckconstraints.sql, then iterate through all other .sql files in the folder and run them, and finally run checkconstraints.sql last.


import os
import pyodbc

def run_sql_scripts_in_folder(connection, folder_path):
    cursor = connection.cursor()

    # Run nocheckconstraints.sql first
    script_path = os.path.join(folder_path, "nocheckconstraints.sql")
    if os.path.exists(script_path):
        with open(script_path, 'r') as script_file:
            script = script_file.read()
            cursor.execute(script)
            print(f"Executed: nocheckconstraints.sql")
    else:
        print("Script not found: nocheckconstraints.sql")

    # Run all other scripts in any order
    for filename in os.listdir(folder_path):
        if filename.endswith(".sql") and filename != "nocheckconstraints.sql" and filename != "checkconstraints.sql":
            script_path = os.path.join(folder_path, filename)
            with open(script_path, 'r') as script_file:
                script = script_file.read()
                cursor.execute(script)
                print(f"Executed: {filename}")

    # Run checkconstraints.sql last
    script_path = os.path.join(folder_path, "checkconstraints.sql")
    if os.path.exists(script_path):
        with open(script_path, 'r') as script_file:
            script = script_file.read()
            cursor.execute(script)
            print(f"Executed: checkconstraints.sql")
    else:
        print("Script not found: checkconstraints.sql")

    cursor.commit()

if __name__ == "__main__":
    server = "your_server_name"
    database = "your_database_name"
    username = "your_username"
    password = "your_password"
    scripts_folder = "sql_scripts"

    connection_string = f"DRIVER=ODBC Driver 17 for SQL Server;SERVER={server};DATABASE={database};UID={username};PWD={password}"
    connection = pyodbc.connect(connection_string)

    run_sql_scripts_in_folder(connection, scripts_folder)

    connection.close()
