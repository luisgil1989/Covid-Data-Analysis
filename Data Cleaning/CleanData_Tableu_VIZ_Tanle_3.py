import sqlite3
import pandas as pd

conn = sqlite3.connect('project.db')
c = conn.cursor()

sqlquery = ("Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100"
            " as PercentPopulationInfected From CovidDeaths WHERE location not in ('World', 'European Union', "
            "'International', 'High income','Upper middle income','Lower middle income','Low income',  'Europe', "
            "'Oceania', 'North America', 'South America', 'Asia', 'Africa') Group by Location, Population order by"
            " PercentPopulationInfected desc")

c.execute(sqlquery)

result = c.fetchall()

# Create a DataFrame from the fetched results
df = pd.DataFrame(result, columns=[desc[0] for desc in c.description])

# Replace NULL values with 0
df.fillna(0, inplace=True)

# Export the DataFrame to an Excel file
df.to_excel('Table3.xlsx', index=False)

# Close the SQLite connection
conn.close()
