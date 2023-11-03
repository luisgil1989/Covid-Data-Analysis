import sqlite3
import pandas as pd

conn = sqlite3.connect('project.db')
c = conn.cursor()

sqlquery = ("Select location, SUM(cast(new_deaths as int)) as TotalDeathCount From CovidDeaths Where continent is null  "
            "and location not in ('World', 'European Union', 'International') Group by location order "
            "by TotalDeathCount desc")

c.execute(sqlquery)

result = c.fetchall()

# Create a DataFrame from the fetched results
df = pd.DataFrame(result, columns=[desc[0] for desc in c.description])

# Replace NULL values with 0
df.fillna(0, inplace=True)

# Export the DataFrame to an Excel file
df.to_excel('Table2.xlsx', index=False)

# Close the SQLite connection
conn.close()
