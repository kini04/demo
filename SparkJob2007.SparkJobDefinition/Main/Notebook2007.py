#!/usr/bin/env python
# coding: utf-8

# ## Notebook2007
# 
# null

# In[1]:


# Welcome to your new notebook
# Type here in the cell editor to add code!
print("Hello World")


# In[2]:


print("Hello World")


# In[1]:


df = spark.read.format("csv").option("header","true").load("Files/sales.csv")
# df now is a Spark DataFrame containing CSV data from "Files/sales.csv".
display(df)


# In[3]:


from pyspark.sql.types import *

schema=StructType([
    StructField("SalesOrderNumber", StringType()),
    StructField("SalesOrderLineNumber", IntegerType()),
    StructField("OrderDate", DateType()),
    StructField("CustomerName", StringType()),
    StructField("EmailAddress", StringType()),
    StructField("Item", StringType()),
    StructField("Quantity", IntegerType()),
    StructField("UnitPrice", FloatType()),
    StructField("TaxAmount", FloatType())
])

df=spark.read.option("header","true").schema(schema).csv("Files/sales.csv")
display(df)

