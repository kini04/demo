# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "5c08ac48-62df-45e5-8567-fd9f9b8143f8",
# META       "default_lakehouse_name": "goldlh",
# META       "default_lakehouse_workspace_id": "2f106717-6eba-4aac-8538-c9a6f0dbb563",
# META       "known_lakehouses": [
# META         {
# META           "id": "5c08ac48-62df-45e5-8567-fd9f9b8143f8"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# Welcome to your new notebook
# Type here in the cell editor to add code!
# Load silver data
from pyspark.sql.functions import *

silver_df = spark.read.format("delta").load("Tables/dbo/sales_silver")

# Aggregate sales by country
gold_df = (
    silver_df.groupBy("CustomerName")
    .agg(
        count("*").alias("TotalOrders"),
        sum("UnitPrice").alias("TotalRevenue"),
        avg("UnitPrice").alias("AvgOrderValue")
    )
)

# Save to Gold Layer
gold_df.write.format("delta").mode("overwrite").saveAsTable("sales_kpi_by_customer")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

df = spark.sql("SELECT * FROM goldlh.dbo.sales_kpi_by_customer LIMIT 1000")
display(df)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
