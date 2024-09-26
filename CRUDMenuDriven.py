import pyodbc

server = 'localhost'
username = 'sa'       
password = 'nikhil123'  
connection_string = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={server};UID={username};PWD={password};TrustServerCertificate=yes;TrustedConnection=yes'
cnxn = pyodbc.connect(connection_string)
cursor = cnxn.cursor()


def create_database():
    ''' 
        Description: 
            Creates a new database.
        Parameters: 
            None
        Returns: 
            None
    '''
    try:
        database_name = input("Enter the name of the database to create: ")
        if not database_name:
            print("Error: Database name cannot be empty.")
            return
        cnxn.autocommit = True  # Set autocommit to True
        cursor.execute("CREATE DATABASE " + database_name)
        print("Database created successfully!")
        cnxn.autocommit = False  # Set autocommit back to False
    except pyodbc.Error as e:
        print(f"Error: {e}")


def create_table():
    ''' 
        Description: 
            Creates a new table in a database.
        Parameters: 
            None
        Returns: 
            None
    '''
    try:
        database_name = input("Enter the name of the database to create a table in: ")
        if not database_name:
            print("Error: Database name cannot be empty.")
            return
        table_name = input("Enter the name of the table to create: ")
        if not table_name:
            print("Error: Table name cannot be empty.")
            return
        columns = input("Enter the columns for the table (e.g. id int, name varchar(50)): ")
        if not columns:
            print("Error: Columns cannot be empty.")
            return
        cursor.execute("USE " + database_name)
        cursor.execute("CREATE TABLE " + table_name + " (" + columns + ")")
        cnxn.commit()
        print("Table created successfully!")
    except pyodbc.Error as e:
        print(f"Error: {e}")


def insert_data():
    ''' 
        Description: 
            Inserts new data into a table.
        Parameters: 
            None
        Returns: 
            None
    '''
    try:
        database_name = input("Enter the name of the database to insert data into: ")
        if not database_name:
            print("Error: Database name cannot be empty.")
            return
        table_name = input("Enter the name of the table to insert data into: ")
        if not table_name:
            print("Error: Table name cannot be empty.")
            return
        columns = input("Enter the columns to insert data into (e.g. id, name): ")
        if not columns:
            print("Error: Columns cannot be empty.")
            return
        values = input("Enter the values to insert (e.g. 1, 'John'): ")
        if not values:
            print("Error: Values cannot be empty.")
            return
        cursor.execute("USE " + database_name)
        cursor.execute("INSERT INTO " + table_name + " (" + columns + ") VALUES (" + values + ")")
        cnxn.commit()
        print("Data inserted successfully!")
    except pyodbc.Error as e:
        print(f"Error: {e}")

    
def update_data():
    ''' 
        Description: 
            Updates existing data in a table.
        Parameters: 
            None
        Returns: 
            None
    '''
    try:
        database_name = input("Enter the name of the database to update data in: ")
        if not database_name:
            print("Error: Database name cannot be empty.")
            return
        table_name = input("Enter the name of the table to update data in: ")
        if not table_name:
            print("Error: Table name cannot be empty.")
            return
        column = input("Enter the column to update: ")
        if not column:
            print("Error: Column cannot be empty.")
            return
        value = input("Enter the new value: ")
        if not value:
            print("Error: Value cannot be empty.")
            return
        condition = input("Enter the condition to update (e.g. id = 1): ")
        if not condition:
            print("Error: Condition cannot be empty.")
            return
        cursor.execute("USE " + database_name)
        cursor.execute("UPDATE " + table_name + " SET " + column + " = '" + value + "' WHERE " + condition)
        cnxn.commit()
        print("Data updated successfully!")
    except pyodbc.Error as e:
        print(f"Error: {e}")


def display_data():
    ''' 
        Description: 
            Displays existing data from a table.
        Parameters: 
            None
        Returns: 
            None
    '''
    try:
        cursor.execute("SELECT name FROM sys.databases")
        databases = [row[0] for row in cursor.fetchall()]
        print("\nAvailable databases:\n")
        for i, database in enumerate(databases, 1):
            print(f"{i}. {database}")
        database_choice = input("Enter the number of the database to display data from: ")
        if not database_choice.isdigit() or int(database_choice) < 1 or int(database_choice) > len(databases):
            print("Error: Invalid database choice.")
            return
        database_name = databases[int(database_choice) - 1]
        cursor.execute("USE " + database_name)
        cursor.execute("SELECT name FROM sys.tables")
        tables = [row[0] for row in cursor.fetchall()]
        print("\nAvailable tables:\n")
        for i, table in enumerate(tables, 1):
            print(f"{i}. {table}")
        table_choice = input("Enter the number of the table to display data from: ")
        if not table_choice.isdigit() or int(table_choice) < 1 or int(table_choice) > len(tables):
            print("Error: Invalid table choice.")
            return
        table_name = tables[int(table_choice) - 1]
        cursor.execute("SELECT * FROM " + table_name)
        rows = cursor.fetchall()
        for row in rows:
            print(row)
    except pyodbc.Error as e:
        print(f"Error: {e}")


def delete_data():
    ''' 
        Description: 
            Deletes existing data from a table or database
        Parameters: 
            None
        Returns: 
            None
    '''
    try:
        print("Delete options :")
        print("1. Delete a database")
        print("2. Delete a table")
        print("3. Delete a row")
        option = input("Enter your choice (1/2/3): ")
        if option == "1":
            database_name = input("Enter the name of the database to delete: ")
            if not database_name:
                print("Error: Database name cannot be empty.")
                return
            cnxn.autocommit = True
            cursor.execute("DROP DATABASE " + database_name)
            print("Database deleted successfully!")
            cnxn.autocommit = False
        elif option == "2":
            database_name = input("Enter the name of the database to delete a table from: ")
            if not database_name:
                print("Error: Database name cannot be empty.")
                return
            table_name = input("Enter the name of the table to delete: ")
            if not table_name:
                print("Error: Table name cannot be empty.")
                return
            cursor.execute("USE " + database_name)
            cursor.execute("DROP TABLE " + table_name)
            print("Table deleted successfully!")
        elif option == "3":
            database_name = input("Enter the name of the database to delete a row from: ")
            if not database_name:
                print("Error: Database name cannot be empty.")
                return
            table_name = input("Enter the name of the table to delete a row from: ")
            if not table_name:
                print("Error: Table name cannot be empty.")
                return
            condition = input("Enter the condition to delete (e.g. id = 1): ")
            if not condition:
                print("Error: Condition cannot be empty.")
                return
            cursor.execute("USE " + database_name)
            cursor.execute("DELETE FROM " + table_name + " WHERE " + condition)
            print("Row deleted successfully!")
        else:
            print("Error: Invalid option. Please choose a valid option.")
    except pyodbc.Error as e:
        print(f"Error: {e}")


def main():
    while True:
        print("\n********************************************************************")
        print("**********************  Database Management System  ****************")
        print("********************************************************************")
        print("1. Create a database")
        print("2. Create a table")
        print("3. Insert data")
        print("4. Update data")
        print("5. Display data")
        print("6. Delete data")
        print("7. Exit")
        print("********************************************************************")
        option = input("Enter your choice (1 to 7): ")
        print("********************************************************************")
        
        match(option):
            case '1':
                create_database()
            case '2':
                create_table()
            case '3':
                insert_data()
            case '4':
                update_data()
            case '5':
                display_data()
            case '6':
                delete_data()
            case '7':
                break
            case _:
                print("Error: Invalid option. Please choose a valid option.")
                print("********************************************************************")
                
        
if __name__ == '__main__':
    main()