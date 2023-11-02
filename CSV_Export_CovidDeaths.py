import sqlite3
import pandas as pd

conn = sqlite3.connect('project.db')
c = conn.cursor()

sqlquery = ("SELECT iso_code, continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths "
            "FROM CoviData ORDER BY location, date")
c.execute(sqlquery)

result = c.fetchall()

# Create a DataFrame from the fetched results
df = pd.DataFrame(result, columns=[desc[0] for desc in c.description])

# Save the DataFrame to a CSV file
df.to_csv('CovidDeaths.csv', index=False)

# Close the SQLite connection
conn.close()
