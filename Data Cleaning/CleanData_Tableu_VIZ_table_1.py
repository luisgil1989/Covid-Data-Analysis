import sqlite3
import pandas as pd

conn = sqlite3.connect('project.db')
c = conn.cursor()

sqlquery = ("Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, "
            "SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage"
            "From CovidDeaths where continent is not null  order by 1,2")

c.execute(sqlquery)

result = c.fetchall()

# Create a DataFrame from the fetched results
df = pd.DataFrame(result, columns=[desc[0] for desc in c.description])

# Replace NULL values with 0
df.fillna(0, inplace=True)

# Export the DataFrame to an Excel file
df.to_excel('Table1.xlsx', index=False)

# Close the SQLite connection
conn.close()
