# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "838410f2-7d3a-43f1-a78a-4c244aa7447e",
# META       "default_lakehouse_name": "lh2007",
# META       "default_lakehouse_workspace_id": "8979ce71-bad5-4e61-803f-cadbb866fe13",
# META       "known_lakehouses": [
# META         {
# META           "id": "838410f2-7d3a-43f1-a78a-4c244aa7447e"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# Welcome to your new notebook
# Type here in the cell editor to add code!
from pyspark.sql.functions import *

df = spark.read.option("header", True).csv("Files/sales.csv")
df.write.format("delta").mode("overwrite").saveAsTable("sales_bronze")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
