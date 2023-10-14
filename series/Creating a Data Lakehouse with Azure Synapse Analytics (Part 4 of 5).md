# Creating a Data Lakehouse with Azure Synapse Analytics (Part 4 of 5)

![](https://cdn-images-1.medium.com/max/800/1*VHQ1XmsdtvpnaGo01JsHsg.png)

### 1. Create Azure Synapse Lake Database

The Lake Database is a new way of defining data structures on data that is hosted on Azure Data Lake Storage and processed with Azure Synapse. This Database type is synchronized between the Spark and the SQL Serverless engines in Azure Synapse and allows interoperability between the different compute engines (Spark and SQL). It is within this database type that you can create and query delta formatted data using delta tables.

----------

#### 1.1 Create a Synapse Notebook

We can now create delta tables based on the delta formatted data in the silver-container and the gold-container using the Apache Spark Pool.

----------

**1.1.1 Silver Database**

-   Select the (1) **Develop** tab to the left, select the **+ button,** and create a new (3) **Notebook**.

![](https://cdn-images-1.medium.com/max/800/1*Wpce29xY4fWG6uA1RqwoqQ.png)

-   Rename the newly created Notebook to **Setup Silver Database**.

![](https://cdn-images-1.medium.com/max/800/1*OKlJzrfZPnNm7LHCnP97Cg.png)

-   To begin using this new Notebook, attach an Apache Spark Pool by selecting the (1) **Attach to** dropdown. Select the provisioned (2) **Spark pool (Small)**.

![](https://cdn-images-1.medium.com/max/800/1*PCTtjXF38wEHnQtLLKjr4A.png)

The Spark Notebooks allow you to run code using Spark flavors of SQL, Python, R, and Scala programming languages. In this example, we will focus on SQL and Python.


**1.1.1.1 Silver Lake Database**

You will start by creating a silver database using Spark SQL.

-   Within the Notebook **Setup Silver Database** code field, add the following SQL code to create the databases:

%%sql  
  
CREATE DATABASE IF NOT EXISTS silver;

-   Select the Run button to start the Spark Pool and run the script.

**_NOTE: Starting the Apache Spark Pool may take 3–5 minutes. Please be patient!_**

![](https://cdn-images-1.medium.com/max/800/1*agMDRZQpmIo73MpBFyQGyg.png)

-   Once the code has run, select the **+ Code** button, to add a new code field to the Notebook.

![](https://cdn-images-1.medium.com/max/800/1*Dy_FnkLywdYR1-klYIHPxw.png)

**1.1.1.2 Azure Blob File System**

To create a delta table, you will need the Azure Blob File System (ABFS) driver. This has the URI structure:

abfss://**container_name**@**storage_account_name**.dfs.core.windows.net/

**_NOTE: Pay attention to the URI structure above. First the Container name, then the storage name. This is a source of errors. If the URI is wrong, you will receive an error message, since the data you’re querying will not be found._**

-   Go back to the Azure portal home screen and select the **Resource group** you provisioned.

![](https://cdn-images-1.medium.com/max/800/1*sCoh3Eo4rlYRISqTlpojDw.png)

-   Once the resource group is open, find the **Storage account** and **copy** the storage name (in the example below, this would be **dlssdspoc**).

This is the **storage_account_name** from the URI.

![](https://cdn-images-1.medium.com/max/800/1*cKAKEHokKfBnK7SfRwoEzw.png)

-   Once the storage account name is copied, **select** the **Storage account** and  open it**.**
-   Once the Storage account is open, select the **Container** tab and **copy** the **container name** (in the example below, this would be **dlssdspocfs1**).

This is the **container_name** from the URI.

![](https://cdn-images-1.medium.com/max/800/1*r6ySjdfjRHaBxIiosXG7JQ.png)

You can now populate the URI; it should look like the one below:

![](https://cdn-images-1.medium.com/max/800/1*BlSxcS-JuLWZfugM0zwLWQ.png)

-   abfss://**container_name**@**storage_account_name**.dfs.core.windows.net/

based on the example above, the URI becomes:

-   abfss://**dlssdspocfs1**@**dlssdspoc**.dfs.core.windows.net/

This URI will be used in the **LOCATION** variable in the next code script.

**_NOTE: Do NOT copy the URI abfss://dlssdspocfs1@dlssdspoc.dfs.core.windows.net/ you see above. This will NOT work for you. You must input the names of the container and storage account you provisioned as described above._**

**1.1.1.3 Silver Lake Database Delta Tables**

-   Go back to your Azure Synapse Workspace.
-   Within the Notebook **Setup Silver Database** code field, add the SQL code below to create the delta table.

%%sql  
  
CREATE TABLE IF NOT EXISTS silver.productsales  
USING DELTA  
LOCATION 'abfss://container_name@storage_account_name.dfs.core.windows.net/silver-container/ProductSales/';

**_NOTE: The %%sql command explicitly tells the notebook to use the SQL language to run the code._**

-   Change the **LOCATION** parameter in the SQL code above to your URI as described in C_hapter 1.1.2 Azure Blob File System_.

![](https://cdn-images-1.medium.com/max/800/1*3IXg1TiKNkilLVjsTk7dww.png)

-   Select the **Run** button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*f1Aa7yUTurqEhWOrlUStvA.png)

-   Once the code has run, select the **+ Code** button, to add a new code field to the Notebook.

![](https://cdn-images-1.medium.com/max/800/1*MEpyG2ZqpPvjOO1S_VV0-w.png)

-   Select **Publish** to save the new notebook.

![](https://cdn-images-1.medium.com/max/800/1*qTmtMU-bZ9i6DVFpZejvng.png)

-   A new panel should open to the right. Select the **Publish** button.

![](https://cdn-images-1.medium.com/max/800/1*4UOh38cSZavVSn0_w_Pv1g.png)

![](https://cdn-images-1.medium.com/max/800/1*lBLZ7dDYh9De3VZTWFYXww.png)

A banner will appear confirming that the content was published.

![](https://cdn-images-1.medium.com/max/800/1*V32mMjreX3SLZE3Z5vJMFA.png)

**1.1.1.4 Audit Logs**

Delta Lake format stores data in Parquet files and information regarding DML operations in the **_delta_log** metadata folder. With this metadata available you can view audit logs and time travel between different versions of a Delta table. Time traveling can be achieved by table version or by timestamp.

Now that the data has been changed, we want to be able to view different versions of this data i.e., time travel.

-   Go back to the **Setup Silver Database** tab. Once selected, you will see your Notebook.

![](https://cdn-images-1.medium.com/max/800/1*fY2SgSMgoEFx4DxLG7Ws-g.png)

-   Within the Notebook **Setup Silver Database** code field, add the following SQL code to view the audit logs of your delta table. This gives you the change history of your data.

In the audit log, you will see the operations we executed after manually changing the data in _Part 4, Chapter 2.3 Data Changes_.

%%sql  
  
DESCRIBE HISTORY 'abfss://dlssdspocfs1@dlssdspoc.dfs.core.windows.net/silver-container/ProductSales/';

-   Within the SQL code above change the **abfss URI** to your URI as described in C_hapter 1.1.2 Azure Blob File System_.

![](https://cdn-images-1.medium.com/max/800/1*cel29LU3dFn5BZbamgH0ZQ.png)

-   Select the Run button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*5uFvkHo1w3rurU9qUFSrJQ.png)

You should see the Changes, specifically the operations that took place and the versions available as an output:

![](https://cdn-images-1.medium.com/max/800/1*Y0BMwSLOuUSZ8XKiNfIJRg.png)

-   Once the code has run, select the **+ Code** button, to add a new code field to the Notebook.

![](https://cdn-images-1.medium.com/max/800/1*wek6CxytaXBU9Bp4ZJ-3nw.png)

----------

**1.1.1.5 Time Traveling**

-   Add the following SQL code to view a previous version of your product sales data i.e. **version 0** or the initial state before the manual changes. For the sake of simplicity, we will filter the data.

%%sql  
  
SELECT * FROM silver.productsales VERSION AS OF 0  
WHERE OrderDate >= '2023-05-01';

-   Select the Run button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*zB8Lqe20DlaMOVa0t2cPuw.png)

In **Version 0**, you will **not** see any values, since the previous version (version 0) did not have any new OrderDate rows after May 01, 2023.

![](https://cdn-images-1.medium.com/max/800/1*qdZatpCORJkc1SKw4ajyDA.png)

-   Change the previous SQL code from **VERSION AS OF 0** to **VERSION AS OF 1** and **run** the script again.

%%sql  
  
SELECT * FROM silver.productsales VERSION AS OF 1  
WHERE OrderDate >= '2023-05-01';

You will now see the changed data from the overwritten CSV file in _Part 4, Chapter 2.3 Data Changes_ together with the transformations we implemented in data flow **DeltaSilverProductSales.**

![](https://cdn-images-1.medium.com/max/800/1*DcBh-BsIcYza_HeiPZW1BQ.png)

Let’s save our work.

-   Select the **Publish All** button.

![](https://cdn-images-1.medium.com/max/800/1*qTmtMU-bZ9i6DVFpZejvng.png)

-   A new panel should open to the right. Select the **Publish** button.

![](https://cdn-images-1.medium.com/max/800/1*kjtUY9uK_mnIG6Mfc9RL0A.png)

![](https://cdn-images-1.medium.com/max/800/1*lBLZ7dDYh9De3VZTWFYXww.png)

A banner should appear confirming that the content was published.

![](https://cdn-images-1.medium.com/max/800/1*V32mMjreX3SLZE3Z5vJMFA.png)

You have now learned how to view different versions of your delta formatted data being used as a delta table in your Silver Lakedatabase using Spark SQL.

**1.1.1.6 Removing Historic Delta Logs**

Delta Lake maintains a history of all the changes by default. That means over a period, the historical data will grow. To optimize your storage costs, you can purge historical logs that are no longer required.

![](https://cdn-images-1.medium.com/max/800/1*eEkY0z37_5ZX2b6F3EjZQw.png)

-   Within the Notebook **Setup Silver Database** code field, add the following SQL code to clear historic delta logs.

%%sql  
  
VACUUM silver.productsales;

-   Select the **Run** button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*z5k3Kk1EJDt8dCPTEXBeAg.png)

**_NOTE: You cannot delete historical data within the last 7 days by default and that is to maintain data consistency._**

----------

**1.2.1 Gold Database**

We will now create our gold database, where the data is made ready for consumption. The steps here are similar to what we configured in C_hapter 1.1.1 Silver Database_.

-   Select the (1) **Develop** tab to the left, select the (2) **+ button,** and create a new (3) **Notebook**.

![](https://cdn-images-1.medium.com/max/800/1*AT8hB8qGSaZfHy7sYJWUHQ.png)

-   Rename the newly created Notebook to **Setup Gold Database**.

![](https://cdn-images-1.medium.com/max/800/1*Wl0QYh5jlxAPw4m73VHqyA.png)

-   To begin using this new Notebook, attach an Apache Spark Pool by selecting the (1) **Attach to** dropdown. Select the provisioned (2) S**park pool (Small)**.

![](https://cdn-images-1.medium.com/max/800/1*aah_j2UamuwlwUIT9yW3eQ.png)

**1.2.1.1 Gold Lake Database**

-   Within the Notebook **Setup Gold Database** code field, add the following SQL code to create the database:

%%sql  
  
CREATE DATABASE IF NOT EXISTS gold;

-   Select the Run button to start the Spark Pool and run the script.

**Note: Starting the Spark Pool may take 3–5 minutes. Please be patient!**

![](https://cdn-images-1.medium.com/max/800/1*EyqcjN6ADLKB16fGmI7KaQ.png)

-   Once the code has run, select the **+ Code** button, to add a new code field to the Notebook.

![](https://cdn-images-1.medium.com/max/800/1*0h94ePg9DPqeQEtp9uSx7A.png)

**1.2.1.2 Gold Lake Database Delta Tables**

-   Within the Notebook **Setup Gold Database** code field, add the following SQL code to create the delta tables in the Gold Lakedatabase.

%%sql  
  
CREATE TABLE IF NOT EXISTS gold.productsales  
USING DELTA  
LOCATION 'abfss://dlssdspocfs1@dlssdspoc.dfs.core.windows.net/gold-container/ProductSales/';

-   Change the **LOCATION** parameter within the SQL code to your URI as described in C_hapter 1.1.2 Azure Blob File System_.

![](https://cdn-images-1.medium.com/max/800/1*hb_j3rbb0tlzkk_RNlZvQg.png)

-   Select the **Run** button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*YN5S1ZDNInCmfJswfk7KlA.png)

-   Once the code has run, select the **+ Code** button, to add a new code field to the Notebook.

![](https://cdn-images-1.medium.com/max/800/1*caYiibxnOh8z9jE3yVbYcg.png)

**1.2.1.3 Audit Logs**

-   Add the following SQL code to view the change history of your product data i.e., the data that we manually changed in _Part 4, Chapter 2.3 Data Changes_.

%%sql  
  
DESCRIBE HISTORY 'abfss://dlssdspocfs1@dlssdspoc.dfs.core.windows.net/gold-container/ProductSales/';

-   Within the SQL code above change the **abfss URI** to your URI as described in C_hapter 1.1.2 Azure Blob File System_.

![](https://cdn-images-1.medium.com/max/800/1*NuXYIbsEh9v4EV9nZFSrug.png)

-   Select the **Run** button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*O5qztADD39cAevc6-fi9Lg.png)

Once the code has run you will see the change operations WRITE (the initial trigger) and MERGE (the second trigger after the data changes)

-   Select the **+ Code** button, to add a new code field to the Notebook.

![](https://cdn-images-1.medium.com/max/800/1*wek6CxytaXBU9Bp4ZJ-3nw.png)

**1.2.1.4 Optimization (Z-Ordering)**

Z-ordering will allow for greater read performance by taking advantage of data skipping. One or multiple columns can be specified for a Z-order. Ideal column choices are those that are commonly used as filters when reading data.

-   Add the following SQL code to implement Z-ordering optimization using the **OrderDate** column.

%%sql  
  
OPTIMIZE gold.productsales ZORDER BY (OrderDate);

**1.2.1.5 Time Traveling**

-   Add the following SQL code to view **version 1** of your product sales data.

%%sql  
  
SELECT * FROM gold.productsales VERSION AS OF 1  
WHERE OrderDate >= '2023-05-01';

-   Select the **Run** button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*byvOL8JLvW1bHiYRMYfuaA.png)

You will now see the same changed data we queried previously in C_hapter 1.1.1 Silver Database_, but transformed based on the transformation activities we implemented in the data flow **DeltaGoldProductSales.**

![](https://cdn-images-1.medium.com/max/800/1*CqxsdP_YwIyWtrKfuZTHkQ.png)

**1.2.1.6 Restoring**

Let’s assume, we are not happy with the changes made and would like to revert to version 0 i.e. without the data changes we implemented in _Part 4, Chapter 2.3 Data Changes_.

-   Select the **+ Code** button, to add a new code field to the Notebook.
-   Add the following SQL code to restore **version 0** as the primary  data structure.

%%sql  
  
RESTORE gold.productsales TO VERSION AS OF 0;

-   Select the **Run** button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*LU31ZHVWdF4mPT7qZbVYuQ.png)

We can now view this restoration process in our audit log. Re-run the DESCRIBE HISTORY script from C_hapter 1.2.1.3 Audit Logs_. You should now see the RESTORE command in the logs.

**_NOTE: Restoring is database-specific. If you restore a version within the gold database, you will also have to do so manually in the silver database._**

![](https://cdn-images-1.medium.com/max/800/1*Y3fdJUYsMC0AtK8Sga_saA.png)

Let’s verify that we have managed to restore version 0.

-   Select the **+ Code** button, to add a new code field to the Notebook.
-   Add the following SQL code to view the data.

%%sql  
  
SELECT * FROM gold.productsales VERSION AS OF 3  
WHERE OrderDate >= '2023-05-01';

-   Select the **Run** button to run the script.

![](https://cdn-images-1.medium.com/max/800/1*A9jUSJgPTLBYKi130cEwdQ.png)

**_NOTE: We select VERSION AS OF 3 because version 2 is the Z-Ordering optimization we implemented in Chapter 1.2.1.4 Optimization (Z-Ordering)_**

Running this script should return no data since the initial data i.e., version 0 did not have any new OrderDate rows after May 01, 2023.

We have therefore successfully reversed our data changes.

Let’s save our work.

-   Select the Publish All button.

![](https://cdn-images-1.medium.com/max/800/1*t6M6zqUD5leOcCpQ0tksMA.png)

-   A new panel should open to the right. Select the **Publish** button.

![](https://cdn-images-1.medium.com/max/800/1*GUmqjuqe5voQArj8zb12Uw.png)

![](https://cdn-images-1.medium.com/max/800/1*lBLZ7dDYh9De3VZTWFYXww.png)

A banner should appear confirming that the content was published.

![](https://cdn-images-1.medium.com/max/800/1*V32mMjreX3SLZE3Z5vJMFA.png)

----------

You have now finalized the setup of your Data Lakehouse using Azure Synapse Analytics! In Part 5 you will learn how to connect your Delta Tables in the Gold Database to Microsoft Power BI and visualize your data.
