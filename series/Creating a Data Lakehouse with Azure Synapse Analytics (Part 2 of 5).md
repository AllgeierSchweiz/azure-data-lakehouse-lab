# Creating a Data Lakehouse with Azure Synapse Analytics (Part 2 of 5)

![](https://cdn-images-1.medium.com/max/800/1*VHQ1XmsdtvpnaGo01JsHsg.png)

### 1. Preparations

The following prerequisites must be met to successfully starting this series:

-   You must be connected to the internet.
-   You should use two monitors **(HIGHLY RECOMMENDED)**
-   You have Microsoft Edge or any other reliable browser installed.
-   You must have created a [free Azure account](https://azure.microsoft.com/en-us/free/) (see [**Creating a Free Azure Account**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/blob/main/series/Creating%20a%20Free%20Azure%20Account.md)) or have access to an Azure account.
-   You must be the **Owner** of the Azure subscription (this is relevant if you are using a company Azure Subscription).
-   You should have [Power BI Desktop](https://apps.microsoft.com/store/detail/power-bi/9NBLGGGZLXN1?hl=de-ch&gl=ch&rtc=1) installed **(OPTIONAL)**.

----------

### 2. Files

All relevant files are in a GitHub repository and can be downloaded as a ZIP file from this [link](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/raw/main/Creating-a-Modern-Data-Lakehouse-with-Azure-Synapse.zip).

----------

### 3. Provisioning Resources

We will provision the Azure resources using an Azure Resource Management (ARM) template.

The following Azure resources will be created:

-   Azure Data Lake Storage Gen2 (ADLS)  
    - Azure Storage Directories
-   Azure Synapse Analytics Workspace
-   Apache Spark Pools

![](https://cdn-images-1.medium.com/max/800/1*Os_M9MkOldTmHzeF0Ia-tw.png)

Additionally, the data being used comes from the [AdventureWorks](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms) sample datasets made available by Microsoft.

All files, including the ARM template, can be found in the GitHub repository mentioned in _Chapter 2. Files_.

**_NOTE: The images in this series may differ slightly from the text in each step. This is usually the case when it comes to the naming of Azure resources. This is due to changes over time. Orient yourself primarily to the text._**

----------

#### 3.1 Azure Account & Subscription

The Azure Account you created in the series [**Creating a Free Azure Account**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/blob/main/series/Creating%20a%20Free%20Azure%20Account.md) is yours and automatically grants you the **Owner** role to the Azure Subscription.

The automatically provisioned Azure Subscription is named **Azure Subscription 1.**

![](https://cdn-images-1.medium.com/max/800/1*jxd8zRhk0LXY0A_P9SIHIA.png)

----------

#### 3.2 Register Resource Providers

Within the Subscription **Azure subscription 1**, we need to register the resource provider **Microsoft. Synapse, Microsoft.Sql,** and **Microsoft.Network** to the subscription**.**

For additional information regarding what a resource provider is and the different types, see [Azure resource providers and types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types).

The **Microsoft.Sql and Microsoft.Synapse** resource providers  are  required to create an Azure Synapse  Analytics  workspace. **Microsoft.Network** is not explicitly necessary, but it is required if you decide to implement event-based triggers for dataflow pipelines.

-   Go to the [Azure Portal](portal.azure.com) and search for **Subscriptions** in the search bar.
-   Select **Subscriptions** in the output window.

![](https://cdn-images-1.medium.com/max/800/1*nGjxExIZrPPchOboWxCTfg.png)

-   Select your subscription **(Azure subscription 1)**

![](https://cdn-images-1.medium.com/max/800/1*6As8sz7x6Q0mmCyTk4p73g.png)

A new window showing the information about the selected subscription will appear to the right.

-   Within this new window, scroll down and select **Resource Providers**.

![](https://cdn-images-1.medium.com/max/800/1*yvmJtIBXRs3B1uBw3ylY-Q.png)

-   Search for **Microsoft.Sql** in the search bar and highlight the row with **Microsoft.Sql** from the list**.**
-   Once highlighted, select **register.**

![](https://cdn-images-1.medium.com/max/800/1*hS2Jsoh1YnjtJ8rwzDcJwg.png)

-   Once registered, the Status will change from **NotRegistered** to **Registered**.

![](https://cdn-images-1.medium.com/max/800/1*-xnEj9EX4BVTLjNhOQ6iUw.png)

-   Repeat these same steps to register **Microsoft.Synapse and Microsoft.Network.**

**_NOTE: The resource provider might already be registered, if this is the case, you may skip these steps._**

----------

#### 3.3 Create Azure Resource Group and Resources

You will now create the Azure Resources required to set up the Data Lakehouse. We will use an Azure Resource Management (ARM) template to help provision the required Azure resources more efficiently.

**_CAREFUL: Before you begin, make sure you register all the resource providers (Microsoft.Sql, Microsoft.Synapse & Microsoft.Network)_ _as shown in chapter 3.2 Register Resource Providers._**

-   Open the GitHub Repository located [here](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab) and select **Deploy to Azure**. This will call the _azure.portal.com_ website and start the ARM template provided.

![](https://cdn-images-1.medium.com/max/800/1*sTDANSrJrOoTzbeiuwGNzQ.png)

**_NOTE: To log into the Azure Portal using the username and password you created for your free Azure account in the series_**  [**_Creating a Free Azure Account_**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/blob/main/series/Creating%20a%20Free%20Azure%20Account.md) **_or your own Azure account._**

Once the template opens, there will be several entries that need to be manually input and/or changed.

-   (2) In the **Subscription** drop-down, select **Azure Subscription 1**.
-   (3) Create a new **Resource Group** by selecting the **Create New** button by the Resource Group entry.
-   (4) Add a new **Resource Group name** with the following makeup:  
    - _rg1_ **<random selection of letters and numbers of your choosing>** _datalakehouse_ **(**e.g., rg1dhlxy12datalakehouse**).**
-   (5) Select **OK**

![](https://cdn-images-1.medium.com/max/800/1*SXMf64R8BaOfJvXlReJaMw.png)

-   (6) Set the **Region** (this is based on your preference. If you’re in Europe,  input **West Europe.** A list of available regions can be found [here](https://gist.github.com/ausfestivus/04e55c7d80229069bf3bc75870630ec8)**).**
-   (7) Leave the **Location** as **[resourceGroup().location]**.
-   (8) Set the **Company Tla** to **<random selection of letters and numbers of your choosing> (**e.g., dhlxy12**).**
-   (9) Leave the **Allow All Connections** as **true**.
-   (10) Leave the **Spark Deployment** as **true**.
-   (11) Set the **Spark Node** **Size** as **Small**_._
-   (12) Leave the **Spark Version** as **3.3** (this is currently the newest version)_._
-   (13) Leave / Set the **Deployment type** as **poc**.
-   (14) Input the **Sql Administrator Login** as **sqladmin.**
-   (15) Input the **Sql Administrator Login Password** as **5Xb%3Ns+b{bH$7BC#$D**

**_NOTE: If you input your own password in step 15, make sure it’s complex enough. The deployment will fail if it isn’t. This is due to Microsoft password rules not being met._**

![](https://cdn-images-1.medium.com/max/800/1*ZOayNmsXpIteIBZ3gNJ-lg.png)

-   Select **Review + Create** to start provisioning the Azure resources.

![](https://cdn-images-1.medium.com/max/800/1*tqJ45FV_6m7sCgKaoodqmw.png)

-   You might get a **Validation Passed** if all your template inputs are correct.

![](https://cdn-images-1.medium.com/max/800/1*oOEKOktpZ3tUsQZjRP2UHw.png)

**_NOTE: Since you’re using a free Azure account, this message might not show up. You can continue to the next step._**

-   Select **Create** to start the provisioning process.

![](https://cdn-images-1.medium.com/max/800/1*ncYPzIsuvQ5xpABba-QcfQ.png)

-   Once the provisioning of the resources has started, you will be brought to a page where **deployment is in progress** can be seen.

![](https://cdn-images-1.medium.com/max/800/1*jtGBpKKRBlaPtJ46qLjdQw.png)

**_NOTE: It may take up to 10 minutes for the deployment to finalize._**

-   Once the deployment is completed, select Go to the **resource group** to go to the provisioned resources.

![](https://cdn-images-1.medium.com/max/800/1*HjGqyf2-UuvUW7hupzWZ2w.png)

You will be brought to the resource group where the resources you created using the ARM template are located. You should see three resources: a _Storage Account, Synapse Workspace, and an Apache Spark Pool._

![](https://cdn-images-1.medium.com/max/800/1*QH6AoCHw-xhBHT40kq4ExA.png)

----------

#### 3.4 Post Deployment

Before continuing with the setup of our infrastructure, we need to make sure we have given ourselves the right permissions to access the provisioned resources. Additionally, we also need to create the file directories that host our bronze, silver, and gold layers in the Azure Data Lake Storage.

The ARM template makes sure that you, the person deploying the Azure resources, have the necessary permissions to access the resources. But there is one additional role that needs to be granted manually in the Azure Storage account and that is the **Storage Blob Data Contributor** role.

----------

**3.4.1 Role Assignment**

To run queries using the Serverless pools in Azure Synapse, you first need to grant yourself access to the storage account by assigning the **Storage Blob Data Contributor** role to your user.

-   Within your newly created **Resource group,** select the resource type **Storage account**.

![](https://cdn-images-1.medium.com/max/800/1*20gMtWrwwOc35WQKO-BAMQ.png)

-   On the left panel select the (1) **Access Control (IAM),** select the (2) **+ Add** button, and add a (3) **new role assignment.**

![](https://cdn-images-1.medium.com/max/800/1*YA7XUdGjRuTTVUTE8X4XEA.png)

-   Search for (1) **Storage Blob Data Contributor,** select/highlight the (2) **Storage Blob Data Contributor** from the list  and select (3) **Next**.

![](https://cdn-images-1.medium.com/max/800/1*XKYduhoxsyJoF-yTLBsF5Q.png)

![](https://cdn-images-1.medium.com/max/800/1*HUjvlRbzIKWIyIC66csaGg.png)

-   Under **Assign Access** toggle (1) **User, group, or service principal** and then select the button (2) **+ Select members**. A new panel will open to the far right.

![](https://cdn-images-1.medium.com/max/800/1*VBQI4Wqs0w_rprB_YCLWOQ.png)

-   Within this new panel, **search** for **your** user E-Mail address
-   Select/highlight the row with your E-mail address and click **Select**.

![](https://cdn-images-1.medium.com/max/800/1*OVOGEkAZiis5naKWrrG0ew.png)

![](https://cdn-images-1.medium.com/max/800/1*HiHCIvoG-eEmbkb3B8E0aQ.png)

-   Once selected, you will **Review + assign** the role assignment.

![](https://cdn-images-1.medium.com/max/800/1*cB6Hr5I62VQHxULzHioZAQ.png)

-   You will get the following banner once successful:

![](https://cdn-images-1.medium.com/max/800/1*YNj4e-N9k_hAy4-I-CU3Wg.png)

----------

**3.4.1 Create Directories and Load Data into the Storage Account**

-   Go back to the [Azure portal](https://portal.azure.com/) home screen and select the **Resource group** you provisioned.

![](https://cdn-images-1.medium.com/max/800/1*sCoh3Eo4rlYRISqTlpojDw.png)

-   Once the resource group is open, select the **Storage account**.

![](https://cdn-images-1.medium.com/max/800/1*20gMtWrwwOc35WQKO-BAMQ.png)

-   Select the (1) **Containers** tab on the left panel and select your (2) **Container** to open it.

![](https://cdn-images-1.medium.com/max/800/1*GBJlv6N00VbYzGD4A0yLEQ.png)

-   Within the container, select **+ Add Directory** to create a new folder.

![](https://cdn-images-1.medium.com/max/800/1*GXQTYXSrz7mmUN1wgMcXXg.png)

-   A new panel will open on the right side, where you can define the name of the new Directory. You will create 3 new directories, and name them **bronze-container, silver-container,** and **gold-container**

For, the bronze container directory named **bronze-container**:

![](https://cdn-images-1.medium.com/max/800/1*xUUmE-DTsz3akaQunW7Sig.png)

Your final storage container structure should look like this:

![](https://cdn-images-1.medium.com/max/800/1*Aq4nvK1irHCh9vC69Ld9PA.png)

You will now add two CSV data files manually into the **bronze-container** directory.

**_Note: in a production environment, importing files into the bronze container would most likely occur through an automated process using a pipeline activity in Azure Data Factory. For the sake of simplicity, we will manually upload the files._**

-   Within the Data Lake, first, select the **bronze-container.**

![](https://cdn-images-1.medium.com/max/800/1*vNv9BiCpLLGWi0ZmDzZ5cg.png)

-   Within the bronze-container, select the **Upload button**.

![](https://cdn-images-1.medium.com/max/800/1*o3-FrSABaylYdabP0xER2g.png)

-   A new panel will open to the right. **Drag and Drop** the CSV files **FactProductCategoryPredictions.csv** and **FactProductSales.csv** and select **Upload**.

![](https://cdn-images-1.medium.com/max/800/1*oJTWm_zXnGy6Nig04Z3c6A.png)

**_Note: the CSV files can be found in the data folder within the ZIP file you downloaded in Chapter 2. Files. You can also download the data directly from the GitHub repository located_** [**_here_**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/tree/main/data)**_._**

Your **bronze-container** directory should look like this:

![](https://cdn-images-1.medium.com/max/800/1*4IKOkTBgl60Par3wA6_DEA.png)

You will now create two new directories for your Product Sales transformations — one in the silver-container and one in the golder-container.

Go back to the (1) **root** of the container and select the (2) **silver-container** directory.

![](https://cdn-images-1.medium.com/max/800/1*6P3tkCGkninm17xBmv64RA.png)

-   In the **silver-container**, select **+ Add Directory** to create a new folder.

![](https://cdn-images-1.medium.com/max/800/1*sjSFdhPHEV9Gmuz_TNYwNA.png)

-   A new panel will open on the right side, where you can define the name of the new Directory. You will create 1 new directory called **ProductSales**

![](https://cdn-images-1.medium.com/max/800/1*zWkZnPj0p_JOyDwwgpZGrA.png)

Your storage **silver-container** structure should look like this:

![](https://cdn-images-1.medium.com/max/800/1*KfjKb6iWG-sLhIwfRBccaA.png)

You will now create the same folder structure for the **gold-container**.

-   Go back to the (1) **root** of the container and select the (2) **gold-container** directory.

![](https://cdn-images-1.medium.com/max/800/1*RZHsVEYisZNMB-51uDfzzw.png)

-   In the **gold-container**, select **+ Add Directory** to create a new folder.

![](https://cdn-images-1.medium.com/max/800/1*t6zFt1m2QQkL-Rh85HAI_w.png)

-   A new panel will open on the right side, where you can define the name of the new Directory. You will create 1 new directory called **ProductSales**

![](https://cdn-images-1.medium.com/max/800/1*zWkZnPj0p_JOyDwwgpZGrA.png)

Your storage **gold-container** structure should look like this:

![](https://cdn-images-1.medium.com/max/800/1*P_6p3rjP7AJ8dS3zNXpPkw.png)

----------

You have now finalized the required preparations to start building your Data Lakehouse on Azure Synapse Analytics. We will continue with the setup in [**Part 3**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/blob/main/series/Creating%20a%20Data%20Lakehouse%20with%20Azure%20Synapse%20Analytics%20(Part%203%20of%205).md).
