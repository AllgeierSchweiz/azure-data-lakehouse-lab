# Creating a Data Lakehouse with Azure Synapse Analytics (Part 1 of 5)

![](https://cdn-images-1.medium.com/max/800/1*VHQ1XmsdtvpnaGo01JsHsg.png)

### 1. Introduction

This is part one of a five-part series developed by the Data Analytics Team at [Allgeier Schweiz](https://www.allgeier.ch/it-services/data-analytics/). The original implementation was part of a workshop for the [Swiss Data Science Conference](https://sds2023.ch/) of 2023.

The following series showcases how to create a Data Lakehouse using Microsoft Azure resources and connect the data to Microsoft Power BI for reporting.

-   **Part 1** will provide the readers with an overview of what a Data Lakehouse is, how it works, what the challenges are, and when it makes sense to implement this architecture.
-   [**Part 2**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/blob/main/series/Creating%20a%20Data%20Lakehouse%20with%20Azure%20Synapse%20Analytics%20(Part%202%20of%205).md) will show the readers the preparations required to create the Azure resources for the Data Lakehouse.
-   [**Part 3**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/blob/main/series/Creating%20a%20Data%20Lakehouse%20with%20Azure%20Synapse%20Analytics%20(Part%203%20of%205).md)  will show the readers how to start Azure Synapse Analytics, import the Data Flow pipelines, and manually trigger these. These pipelines will transform the data, move them from each medallion layer (bronze, silver, and gold), and sink it to the Delta format.
-   [**Part 4**](https://nicolas-rehder.medium.com/creating-a-data-lakehouse-with-azure-synapse-analytics-part-4-of-5-1fd7b2e6f7c9)  will show the readers how to create Synapse Notebooks in Azure Synapse Analytics and set up the Lake Databases as well as the associated Delta Tables. The reader will also use SQL code to query the Delta Table audit logs as well as implement time traveling, version restoring, z-ordering, and vaccuming commands.
-   [**Part 5**](https://nicolas-rehder.medium.com/creating-a-data-lakehouse-with-azure-synapse-analytics-part-5-of-5-e7648d1402d2)  will show the readers how to connect the Delta Tables in the Synapse Analytics Gold Lake Database with Power BI using the Azure Synapse Serverless Endpoint.

----------

### 2. What is a Data Lakehouse?

A Data Lakehouse is a data management architecture that combines the key advantages of Data Lakes and Data Warehouses into one.

The Data Lakehouse is made up of a Data Lake, that stores the data in a direct-access optimized format, and Serverless Pools, that allow for queries made directly on the Data Lake.

What makes the Data Lakehouse so special is that the Data Lake essentially acts as a Data Warehouse. The Serverless Pools, used to query the data, add an on-demand SQL layer on top of the Data Lake allowing for large-scale data and computational functions. For comparison, in traditional Data Warehouses, the data would first need to be imported and stored on disk, before being available for querying.

By additionally storing the data in the Delta Lake format, important functionalities, that were previously only available in Data Warehouses, now also become accessible on the Data Lake. These functionalities are listed in C_hapter 4. Delta Lake to the Rescue_**_._**

The Data Lakehouse can be created using several cloud service providers such as **_Microsoft Azure, Databricks, Amazon Web Services, Google Cloud Platform, and Snowflake_**, to name a few.

In this tutorial, we will be using **_Microsoft Azure_**.

----------

### 3. Data Lakehouse Architecture

The Data Lakehouse in this tutorial will be built using **_Azure Synapse Analytics, Azure Data Lake Storage Gen2 (ADLS),_** and an **_Apache Spark Pool (Spark Version 3.3_)**.

**_Note: As of February 23, 2023, Spark Version 3.3 is the highest GA version in Azure Synapse Analytics._ _Always check the_** [**_latest supported Azure Synapse runtime releases_**](https://learn.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-version-support) **_and adjust the version accordingly, to access the latest Apache Spark features._**

![](https://cdn-images-1.medium.com/max/800/1*D_nzWFy0wgLCE_f_IS-Wog.png)

The Azure resources are provisioned using Infrastructure as Code (IaC) with an Azure Resource Management (ARM) template.

The data stored in the Azure Data Lake Storage will be organized using the medallion structure.

The medallion structure uses three layers that denote the quality of the data being stored. Each layer is a folder directory inside the Azure Data Lake Storage. The three layers are:

-   Bronze (raw data)
-   Silver (transformed and enriched data)
-   Gold (aggregated data)

The data is imported, transformed, and moved from one layer to the next using Data Flows in Azure Synapse Pipelines. Data Flows allow for the development of data transformation logic without writing code. For those of you familiar with Data Flows in Azure Data Factory, these are essentially the same objects but created directly in Azure Synapse Analytics.

**_Note: The data transformation logic can also be created outside of Data Flows, directly in Synapse Notebooks using PySpark and/or Spark SQL._**

Once the Data Flow activities have been finalized, the data in the Data Lake can be queried directly from each medallion layer using a Serverless Pool.

**_Note: There are two types of Serverless Pools: a Serverless SQL Pool, which is automatically provisioned when creating an Azure Synapse Analytics workspace, and a Serverless Spark Pool, which needs to be provisioned manually. Both Serverless Pools can query the data on the Data Lake, but only the Serverless Spark Pool can take advantage of the Delta Lake format features._**

To query the data, scripts are written in Synapse Notebooks using PySpark and/or Spark SQL. Both of these languages are Spark flavors of Python and SQL. Additionally, Lake Databases and traditional SQL database objects such as **_schemas, external tables,_** and **_views_** can be created in Azure Synapse Analytics using Synapse Notebooks.

**_Note: Synapse Notebooks are very similar to Jupyter Notebooks. These Notebooks support Python, SQL, R, Scala, and .NET._**

Finally, the transformed data, made available in the gold layer of the medallion structure, can be used to create Delta Tables in the Lake Database. These Delta Tables can be read and imported into Power BI using a Serverless SQL Endpoint.

**_Note: There currently is no Serverless Spark Endpoint to connect to the Lake Database from Power BI. For the time being, only a Serverless SQL Endpoint is available, which unfortunately limits certain Spark-based Delta features, such as time traveling. In the future, especially with the creation of Microsoft Fabric, this missing Endpoint will certainly become available._**

----------

### 4. Delta Lake to the Rescue!

To allow for Data Warehouse-like capabilities directly on the Data Lake and to overcome the typical challenges that Data Lakes have, a special type of data format named Delta Lake comes into play.

Most people who work with cloud-based data management systems have heard of the open-source file format called Apache Parquet (or simply, Parquet). This column-oriented data file format provides efficient data compression and enhanced performance.

The Delta Lake file format (or simply, Delta) is an open-source file protocol developed by Databricks that extends Parquet with a file-based transaction log for version control. This enables the Data Warehouse-like functionalities specific to the Delta Lake protocol. The most important of those are:

-   **_ACID compliance_**
-   **_Time traveling_**
-   **_Audit history_**
-   **_Schema enforcements_**
-   **_DML operations_**
-   **_Query optimizations_**

These features empower both **_business intelligence (BI)_** and **_machine learning (ML)_** capabilities directly on the data stored in the Data Lake.

![](https://cdn-images-1.medium.com/max/800/1*Zd7ufRtzBdKAea3x133O-g.png)

----------

### **5. Other Data Format Protocols**

It should be noted that there are other Parquet-based open-source protocols such as **_Apache Hudi_** and **_Apache Iceberg_**, that offer the same capabilities as Delta Lake.

In the case of Azure Synapse Analytics or Microsoft in general, the out-of-the-box Data Lakehouse format is Delta Lake. This is also the case with the new all-in-one analytics solution called [Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/get-started/microsoft-fabric-overview), which uses a Data Lakehouse at its core, namely **_OneLake_**.

With additional configurations, Apache Hudi or Apache Iceberg may also be used in Azure Synapse Analytics. However, these configuration steps are outside the scope of this workshop.

**_Note: With the introduction of Universal Format (UniForm), Delta Lake can be used not only with Delta Lake tables but also with Apache Hudi and Apache Iceberg tables, unifying data regardless of the storage format._**

![](https://cdn-images-1.medium.com/max/800/1*QrY5MUPx2NXQOYCBZZmQYA.png)

----------

### 6. Refresher on Data Warehouses and Data Lakes

As mentioned before, the Data Lakehouse offers the best of two independent technologies, namely: Data Warehouses and Data Lakes.

Below is a brief overview of what these two systems offer, their challenges, and how, when they’re brought together, can offset each other’s downsides.

----------

#### 6.1 Data Warehouses

A Data Warehouse is a central repository made up of several databases that ingest **_structured_** data from multiple sources. The data is stored in a **_predefined schema_** through an Extract, Transform, and Load (ETL) process before being made available for **_business intelligence (BI)_** analysis.

![](https://cdn-images-1.medium.com/max/800/1*vvJ-cEULtQTxNC5sfx3UsA.png)

However, this setup presents certain challenges:

-   **_No Support for Unstructured Data_**
-   **_Limited support for Machine Learning workloads_**
-   **_SQL-only_**
-   **_Scaling up and maintenance is costly_**
-   **_Vendor lock-ins_**

As you will see in C_hapter 6.2 Data Lakes_, a number of these challenges are addressed by the primary features that make up a Data Lake.

----------

#### 6.2 Data Lakes

A Data Lake is a central repository that ingests **_structured, semi-structured,_** or **_unstructured_** data from multiple sources. The data is stored **_without a predefined schema_** and is made available for **_advanced analytics_**.

![](https://cdn-images-1.medium.com/max/800/1*zTIIszD1PEpmUOc3LgT28g.png)

Nevertheless, just like the data warehouse, this setup also presents certain challenges:

-   **_Data Swamps_**
-   **_Missing ACID compliance_**
-   **_Poor query performance_**
-   **_Limited BI support_**
-   **_Arduous data exploration_**

As you may have noticed in C_hapter 6.1 Data Warehouse_, a number of these challenges are addressed by the primary features that make up a Data Warehouse.

----------

### 7. When Should a Data Lakehouse be Implemented?

In any enterprise, it should always be evaluated whether a new data management solution such as a Data Lakehouse with any legacy provider makes sense.

Smaller companies with sparse and primarily structured data cannot benefit from such a system and should therefore opt for a simpler solution, such as a traditional Data Warehouse.

**_Note: With the advent of Microsoft Fabric, even smaller businesses can now profit from the advantages of a Data Lakehouse architecture for as little as USD 350 / month._**

A Data Lakehouse makes sense and thrives in businesses with large amounts of structured, semi-structured, and unstructured data. Additionally, it should be part of the company’s strategy to use the data for both business intelligence (BI) and advanced analytics (AI / ML) with programming languages such as SQL, Python, R, or Scala.

Ideally, companies planning to set up a Data Lakehouse using Microsoft Azure already have a Microsoft ecosystem in place and can benefit from licensing overlaps, such as an [M365 E5 license](https://www.microsoft.com/en-us/microsoft-365/enterprise/e5?activetab=pivot:overviewtab), which comes with Power BI Pro.

The steps outlined in Part 2, 3, 4, and 5 of this series, serves as a launchpad for those who would like to set up a Proof-of-Concept (PoC) using this new data management technology in Azure.

----------

### 8. Questions & Feedback?

Reach out to us! We are happy to answer any questions you might have or use your feedback to optimize this series!

----------

### **9. References**

[1] [Exploratory data analysis with Azure Synapse serverless and a lakehouse — Azure Architecture Center | Microsoft Learn](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/data/synapse-exploratory-data-analytics)

[2] [What is a Data Lakehouse? (databricks.com)](https://www.databricks.com/glossary/data-lakehouse)

[3] [What is a Data Lakehouse? Definition, Benefits, and More (thoughtspot.com)](https://www.thoughtspot.com/data-trends/data-storage/what-is-a-data-lakehouse)

[4] [The Data Lakehouse, the Data Warehouse, and a Modern Data platform architecture — Microsoft Community Hub](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/the-data-lakehouse-the-data-warehouse-and-a-modern-data-platform/ba-p/2792337)

[5] [Building the Lakehouse — Implementing a Data Lake Strategy with Azure Synapse — Microsoft Community Hub](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/building-the-lakehouse-implementing-a-data-lake-strategy-with/ba-p/3612291)

[6] [What is a Lake Database in Azure Synapse Analytics? | endjin — Azure Data Analytics Consultancy UK](https://endjin.com/blog/2022/10/what-is-a-lake-database-in-azure-synapse-analytics)

[7] [What is the medallion lakehouse architecture? — Azure Databricks | Microsoft Learn](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion)

[8] [Delta lake ETL with data flows — Azure Data Factory | Microsoft Learn](https://learn.microsoft.com/en-us/azure/data-factory/tutorial-data-flow-delta-lake)

[9] [Lakehouse: A New Generation of Open Platforms that Unify Data Warehousing and Advanced Analytics (cidrdb.org)](https://www.cidrdb.org/cidr2021/papers/cidr2021_paper17.pdf)

[10] [Serverless SQL pool — Azure Synapse Analytics | Microsoft Learn](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/on-demand-workspace-overview)

[11] [Universal Format (UniForm) — Delta Lake Documentation](https://docs.delta.io/3.0.0rc1/delta-uniform.html)
