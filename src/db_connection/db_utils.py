import pandas as pd
import mysql.connector

def get_connection(SERVER, PORT, DATABASE, USERNAME, PASSWORD):
    conn = mysql.connector.connect(
        host=SERVER,
        port=PORT,
        user=USERNAME,
        password=PASSWORD,
        database=DATABASE
    )
    print("Connected Successful!")
    return conn, conn.cursor()

def read_data(sqls, conn, cursor):
    try:
        print(f"Excecuting")
        cursor.execute(sqls)
        rows = cursor.fetchall()
        columns = [desc[0] for desc in cursor.description]
        df = [dict(zip(columns,row)) for row in rows]
        df = pd.DataFrame(df)
        print(f"Executed Successful")
        return df
    except Exception as e:
        print(f"!!!!!!!!!!!!!!!!!!!!!!!!! Error: {e}")
        return pd.DataFrane()

def create_table(sqls, conn, cursor):
    print(f"Start to create tables.")
    for sql in sqls.split(';'):
        sql = sql.strip()
        if sql:
            try:
                cursor.execute(sql)
            except Exception as e:
                print(f"!!!!!!!!!!!!!!!!!!!!! Error executing statement: {e}\n{sql}")
    conn.commit()
    print(f"End to create tables.")
        
def insert_df_to_db(df, table, conn, cursor, if_exists='append'): 
    """Insert to DB"""
    print(f"Start insert into {table.upper()}")
    cursor = conn.cursor()
    try:
        cols = ','.join(df.columns)
        placeholders = ','.join(['%s'] * len(df.columns))  # Đổi từ '?' sang '%s'
    except Exception as e:
        print(f"Error text joining")
    for row in df.itertuples(index=False, name=None):
        try:
            cursor.execute(f"INSERT INTO {table} ({cols}) VALUES ({placeholders})", row)
        except Exception as e:
            print(f"!!!!!!!!!!!!!!!!!!! Error executing statement: {e}")
    conn.commit()
    print(f"Inserted {len(df)} rows into {table.upper()}")