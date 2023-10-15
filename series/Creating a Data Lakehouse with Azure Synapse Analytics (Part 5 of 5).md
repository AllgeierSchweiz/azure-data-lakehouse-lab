# Creating a Data Lakehouse with Azure Synapse Analytics (Part 5 of 5)

![](https://cdn-images-1.medium.com/max/800/1*VHQ1XmsdtvpnaGo01JsHsg.png)

### 1. Connect Gold Layer to Power BI

We have created a data lakehouse, the next step is to import and visualize the data using a BI Tool such as Power BI.

----------

#### 1.1 **Azure Synapse Analytics SQL Connector**

This native connector uses the **Serverless SQL endpoint** for Azure Synapse to query the delta tables we created in _Part 4, Chapter 1. Create Azure Synapse Lake Database_.

**_Note: Serverless SQL pools can’t provide an interactive experience in Power BI Direct Query mode if you’re using complex queries or processing a large amount of data._**

Since we are using the Serverless SQL endpoint, we cannot time travel. The delta formatted data we query using this connector will always be the most current version.

In the future, Microsoft will most likely make a Serverless Spark endpoint for Azure Synapse available, allowing us to query the delta formatted data using Spark, which enables time travel. But for now, this is not yet available.

----------

**1.1.1 Creating a Connection**

Let’s connect our delta table in the gold database located in the Azure Synapse using the Power BI Azure Synapse Analytics SQL Connector.

-   Open the **Power BI Desktop** application.
-   Once opened, select the (1) **Get data** button and select (2) **More** to view all the available connectors.

![](https://cdn-images-1.medium.com/max/800/1*q5ne1cxWa22_azHKt2r2dQ.png)

-   A new window will open, search for the (1) **Azure Synapse Analytics SQL** and select (2) it from the list**.**
-   Select the (3) **Connect** button.

![](https://cdn-images-1.medium.com/max/800/1*pvbG3i6eiAjF05X11zFtug.png)

A new window will appear requesting the SQL Server database information.

![](https://cdn-images-1.medium.com/max/800/1*lSf26Ctu7Mh7i6bjBhQdIw.png)

We require the SQL Serverless Pool endpoint for Azure Synapse.

-   Go back to the [Azure portal](http://portal.azure.com/) home screen and select the **Resource group** you provisioned.

![](https://cdn-images-1.medium.com/max/800/1*sCoh3Eo4rlYRISqTlpojDw.png)

-   Within the **Resource group, s**elect the resource type **Synapse workspace**.

![](https://cdn-images-1.medium.com/max/800/1*1LzT7VLwzbzocYXhj8I_Pg.png)

-   A new page will appear. The Serverless SQL endpoint is in the **overview** section of the Synapse workspace.

![](https://cdn-images-1.medium.com/max/800/1*LouVkVI5-97L6EES-vOPPA.png)

-   **Copy** the Serverless SQL endpoint.
-   Go back to your Power BI Desktop application and paste the Serverless SQL endpoint in the (1) **Server** field and select (2) **OK**.

**_Note: Your SQL endpoint name will be different._**

![](https://cdn-images-1.medium.com/max/800/1*imL_WW3sDWGdxtQ7vj4dqA.png)

-   A new window will open asking for the credentials. Select (1) **Microsoft account**, select (2) **Sign in,** and select the (3) **Connect** button.

![](https://cdn-images-1.medium.com/max/800/1*33ZMX7AOWZbveD6Gl4DAoQ.png)

-   A new window will open showing the databases we created in _Part 4, Chapter 1. Create Azure Synapse Lake Database_.
-   Open the (1) **gold database** and select the (2) **productsales** delta table.
-   Select **(3) Load** to import the data directly into Power BI without calling the Power Query Editor.

![](https://cdn-images-1.medium.com/max/800/1*aDQwuMPlbupb_QuK1nu-ig.png)

-   A loading screen will appear.

![](https://cdn-images-1.medium.com/max/800/1*yiNVBryGsWj2_6Ev0EiFdg.png)

-   The data is now imported and available to be used for visualizations in Power BI.

![](https://cdn-images-1.medium.com/max/800/1*wbbkMY9G7MbEg770AwR92w.png)

----------

Congratulations! You have finished creating the components of your Data Lakehouse and have imported your data into Microsoft Power BI. You now have a basic BI-Infrastructure in place for your PoC.
