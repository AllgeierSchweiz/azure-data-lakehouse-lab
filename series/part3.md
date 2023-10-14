# Creating a Data Lakehouse with Azure Synapse Analytics (Part 3 of 5)

![](https://cdn-images-1.medium.com/max/800/1*VHQ1XmsdtvpnaGo01JsHsg.png)

### 1. Starting Azure Synapse Analytics

We will now open Azure Synapse Analytics and create the ETL pipelines and Notebooks necessary to finalize our build.

-   Go back to the [Azure portal](http://portal.azure.com/) home screen and select the **Resource group** you provisioned.

![](https://cdn-images-1.medium.com/max/800/1*sCoh3Eo4rlYRISqTlpojDw.png)

-   Once the resource group is open, **s**elect the resource type **Synapse workspace**.

![](https://cdn-images-1.medium.com/max/800/1*1LzT7VLwzbzocYXhj8I_Pg.png)

-   A new page will appear. Launch **Azure Synapse Studio** by selecting **Open Synapse Studio** located in the O**verview** section of the Synapse workspace.

![](https://cdn-images-1.medium.com/max/800/1*dag-bRHt7Asisso99OpeGw.png)

Once selected, a new webpage will open, launching Azure Synapse Studio. You will see the following banner:

![](https://cdn-images-1.medium.com/max/800/1*aXV-Zy1xTMV88xI94BacgQ.png)

----------

### 2. Create Azure Synapse Analytics Pipelines

You will create two Data Flows using Synapse pipelines. These Data Flows will move the data in the bronze container into the silver container and from the silver container into the gold container. Each Data Flow will transform the data before copying it into each container in the Delta Format.

----------

#### 2.1 Transform Data into Delta Format

The Delta format is an open-format storage layer that brings ACID (atomicity, consistency, isolation, and durability) transactions, time-traveling capabilities, DML operations, and many [more features](https://delta.io/) to Apache Spark. The Delta format stores the data in a parquet file format while also maintaining transaction logs and statistics to provide features and performance improvement over standard parquet.

----------

**2.1.1 Data Flows**

-   In **Synapse Studio**, on the left side, select the (1) **Integrate** tab, the (2) **plus sign (+)** at the top of the new panel, and (3) **Import from Pipeline Template** in the drop-down, to create a new pipeline.

![](https://cdn-images-1.medium.com/max/800/1*QyVZYwr4L5NLSa9YIyoTJQ.png)

-   Once **Import from Pipeline Template** is selected, a new window to browse to a ZIP file will open.
-   Browse to the Folder (1) **Support Files** > **Pipeline**.
-   Select the ZIP file (2) **TransformDeltaFormat** and click  (3) **Open**.

**_NOTE: The support files can be found in the support folder within the ZIP file you downloaded in Series Part 2, Chapter 2. Files. You can also download the support files directly from the GitHub repository as a ZIP file in this_** [**_link_**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/tree/main/support/pipeline)**_._**

![](https://cdn-images-1.medium.com/max/800/1*QaS40P-EelhFnsX9JVkz3Q.png)

A new window will open to configure the Linked Service.

-   Within the drop box under Linked Service, select the provisioned storage account.

![](https://cdn-images-1.medium.com/max/800/1*cTzGOyxd06oapMUVy7NOXA.png)

-   Once selected, click **Open Pipeline** at the bottom of the page.

![](https://cdn-images-1.medium.com/max/800/1*s7CFyybx-j4Pr_0UWFZbeg.png)

The pipeline will be imported, and you should see two data flows called **DeltaSilverProductSales** and **DeltaGoldProductSales**.

-   Select the **Publish All** button to save the work you have done so far.

![](https://cdn-images-1.medium.com/max/800/1*fVYzsQa6ctzQg5rSQudYhQ.png)

-   A new panel should open to the right. Select the **Publish** button.

![](https://cdn-images-1.medium.com/max/800/1*_OOVZMn6Xh-7RoHKSPT6UA.png)

![](https://cdn-images-1.medium.com/max/800/1*lBLZ7dDYh9De3VZTWFYXww.png)

A banner should appear confirming that the content was published.

![](https://cdn-images-1.medium.com/max/800/1*V32mMjreX3SLZE3Z5vJMFA.png)

-   In the top bar of the pipeline canvas, slide the **Data flow debug** slider on.

The debug mode allows for interactive testing of transformation logic against a live Spark cluster. Data Flow clusters take 5–7 minutes to warm up and users are recommended to turn on debug first if they plan to do Data Flow development.

![](https://cdn-images-1.medium.com/max/800/1*MThNuXTp6A6j_n0aGjcHjA.png)

-   Once toggled, a new panel will open to the right, with the debug setting. Leave the default settings and select **OK**.

![](https://cdn-images-1.medium.com/max/800/1*MFCkl3w-0jwn-A9dUTWi9A.png)

![](https://cdn-images-1.medium.com/max/800/1*d9MmrLM9hXBPHxJDfGHHsg.png)

**_Note: The debug initialization might take 3–5 minutes. Please be patient!_**

-   You will get a **green** check once the debug has initialized:

![](https://cdn-images-1.medium.com/max/800/1*QunN94CjeZAPVckXW0f-vw.png)

The **Debug time to live** is the amount of time that the integration runtime will wait after your last data preview before automatically shutting down your debug cluster. To avoid billing for the entire TTL, you can shut down the debug session when you are finished working.

----------

#### 2.1.1.1 DeltaSilverProductSales

Before the Data Flows can be triggered, we need to make sure that the data sources i.e., the CSV files being imported into the Data Flows are being found and that the sink sources are correctly mapped. This requires us to adjust parameters and change file paths.

-   Within the imported (1) **TransformDeltaFormat** pipeline, select the Data flow (2) **DeltaSilverProductSales**.
-   In the (3) **Settings** tab select the (4) **Open** button next to the Data flow **DeltaSilverProductSales**.

![](https://cdn-images-1.medium.com/max/800/1*Fsvi2sEmNytOd9mCA3Ba5A.png)

-   Within the opened Data Flow, select the **BronzeProductSales** tile.

![](https://cdn-images-1.medium.com/max/800/1*U5yD1Q2R_YgM1rb4EAzI2w.png)

-   Under the (1) **Source settings** tab, select the (2) **Open** button next to **Dataset** (DelimitedText)

![](https://cdn-images-1.medium.com/max/800/1*UThmespmd2k40LEbZ39zPQ.png)

-   Once selected a new tab called **DelimitedText** will open.
-   Under the (1) **Connection** tab, select the (2) **Edit** button next to **Integration runtime**.

![](https://cdn-images-1.medium.com/max/800/1*Xz6fjafGmdnzukxczb3XYQ.png)

-   A new panel called **Integration Runtime** will open. Go to the (1) **Virtual Network** tab and select (2) **Enable** under Interactive authoring. Select (3) **Apply**.

![](https://cdn-images-1.medium.com/max/800/1*AOQ9l3wgpWm_0aS8T_39MA.png)

![](https://cdn-images-1.medium.com/max/800/1*I_66C5lihD8fHYiYFoXPug.png)

**_NOTE: It may take 1–3 minutes for interactive authoring to be enabled. You will see the banner below:_**

![](https://cdn-images-1.medium.com/max/800/1*_-zTvdbA7agT3t1PHmFkVA.png)

Once enabled, you will be able to Browse the directory folder.

-   Under the (1) **Connection** tab, select the (2) **Browse** button next to the **File path**.

![](https://cdn-images-1.medium.com/max/800/1*WyH_Fa1qF46XvzqNkuDXgQ.png)

-   Browse to the **bronze-container** directory and select the **FactProductSales.csv** file.
-   Once the file path has been set, select **OK**.

**_NOTE: The path should be similar to the one depicted below. Keep in mind that your storage account (E.g.: dlssdspocfs1) will have a different name._**

![](https://cdn-images-1.medium.com/max/800/1*H3tfgI6VDI5l_yuCoSww4g.png)

![](https://cdn-images-1.medium.com/max/800/1*tHsamPGNVIIVzjEjwZeoUQ.png)

**_NOTE: Even though you selected the FactProductSales.csv file, your file path should retain the parameter @dataset().FileName. The only thing that should change is the storage name._**

![](https://cdn-images-1.medium.com/max/800/1*x9iLWH-6ZRWtwQYXWEoXpg.png)

-   Go back to the (1) **DataflowSilverProductSales** tab and select the (2) **BronzeproductSales** tile.

![](https://cdn-images-1.medium.com/max/800/1*TZgV86Wz-O8jvIEgwZhiTw.png)

-   Select the (1) **Data Preview** tab.
-   Once selected, there will be a yellow ribbon notifying you of parameters that require values. Select the field (2) **Click to see parameters**.

![](https://cdn-images-1.medium.com/max/800/1*n8Rv43Cz1pGNAqYeL9LHZg.png)

A new panel will open to the right. You will now populate these parameters.

-   Select the arrow next to (1) **BronzeProductSales**, add the name of the Sales CSV file (2) **FactProductSales.csv,** and select  (3) **Save.**

![](https://cdn-images-1.medium.com/max/800/1*FJ3Le-UdtfnDcpa5CwDC3g.png)

![](https://cdn-images-1.medium.com/max/800/1*XjNYth2eQM20jZmgVw5Pxw.png)

The panel will close, and you will be brought back to the Data Preview tab.

-   Under the (1) **Data Preview** tab, select the (2) **Refresh** button.

![](https://cdn-images-1.medium.com/max/800/1*0nNXxsGzUvu1UzhAzCPrEw.png)

The data will be fetched, and you should see a preview of your table.

![](https://cdn-images-1.medium.com/max/800/1*nCE_A-Sammj4eY0_ebvXPQ.png)

-   Within the **DataflowSilverProductSales** tab, select the **DeltaTransformSilver** tile.

![](https://cdn-images-1.medium.com/max/800/1*DAMGRsrE4_MpgoFQJXQQAQ.png)

-   Select the (1) **Settings** tab and click the (2) **Browse** button next to the **Folder path**.

![](https://cdn-images-1.medium.com/max/800/1*trFIIy7MJsHKii-VIUoEag.png)

-   Browse to the **silver-container** directory and select the **ProductSales** folder.
-   Once the file path has been set, select **OK**.

![](https://cdn-images-1.medium.com/max/800/1*dcpV52ZPLZ8gjn6kvgSRJw.png)

![](https://cdn-images-1.medium.com/max/800/1*tHsamPGNVIIVzjEjwZeoUQ.png)

The panel will close, and you will be brought back to the Settings tab.

-   Navigate to the (1) **Data Preview** tab and select the (2) **Refresh** button.

![](https://cdn-images-1.medium.com/max/800/1*_gM4GVmBvFwOsjJgHFIQvg.png)

The data will be fetched, and you should see a preview of your table.

![](https://cdn-images-1.medium.com/max/800/1*lecw2WjgAf0wrsoUn-tKGw.png)

The **DeltaSilverProductSales** Data Flows is ready.

We now need to configure the second Data Flow called **DeltaGoldProductSales** similarly.

-   Go back to the **TransformDeltaFormat** tab.

![](https://cdn-images-1.medium.com/max/800/1*9ysLKNIZTjI-UY9_aa-WPw.png)

-   Select the **Publish All** button to save the work you have done so far.

![](https://cdn-images-1.medium.com/max/800/1*VrdyuVsi_vHw5M3UW1QqtA.png)

-   A new panel should open to the right. Select the **Publish** button.

![](https://cdn-images-1.medium.com/max/800/1*EjsshVtGkdzOkcrbWXuGzw.png)

![](https://cdn-images-1.medium.com/max/800/1*lBLZ7dDYh9De3VZTWFYXww.png)

A banner will appear confirming that the content was published.

![](https://cdn-images-1.medium.com/max/800/1*V32mMjreX3SLZE3Z5vJMFA.png)

----------

#### 2.1.1.2 DeltaGoldProductSales

-   Go back to the (1) **TransformDeltaFormat** tab and select the Data flow (2) **DeltaGoldProductSales**.
-   In the (3) **Settings** tab select the (4) **Open** button next to the Data flow **DeltaGoldProductSales**.

![](https://cdn-images-1.medium.com/max/800/1*VE6G_gccw0j2DUCifdsXvA.png)

-   Within the opened data flow, select the **BronzeProductCategoryPredictions** tile.

![](https://cdn-images-1.medium.com/max/800/1*x-uNhr5Y_G4ZecFEIAPlIg.png)

-   Select the (1) **Data Preview** tab.
-   Once selected, there will be a yellow ribbon notifying you of parameters that require values. Select the field (2) **Click to see parameters**.

![](https://cdn-images-1.medium.com/max/800/1*-WA6M-84xZrjBuJFaV_duQ.png)

A new panel will open to the right. You will now populate these parameters.

-   Select the arrow next to (1) **BronzeProductCategoryPredictions**, add the name of the Prediction CSV file (2) **FactProductCategoryPredictions.csv,** and select  (3) **Save.**

![](https://cdn-images-1.medium.com/max/800/1*TN_MjUr2ppl7uX97i-VcCA.png)

![](https://cdn-images-1.medium.com/max/800/1*XjNYth2eQM20jZmgVw5Pxw.png)

The panel will close, and you will be brought back to the Data Preview tab.

-   Under the (1) **Data Preview** tab, select the (2) **Refresh** button.

![](https://cdn-images-1.medium.com/max/800/1*0nNXxsGzUvu1UzhAzCPrEw.png)

The data will be fetched, and you should see a preview of your table.

![](https://cdn-images-1.medium.com/max/800/1*4Pm7oJX7dVetCJ6Re6NoPg.png)

-   Within the (1) **DeltaGoldProductSales** tab, select the (2) **SilverProductSales** tile.

![](https://cdn-images-1.medium.com/max/800/1*UFKPW_6vhRuCG1ApsMYbhg.png)

-   Select the (1) **Source options** tab and click the (2) **Browse** button next to the **Folder path**.

![](https://cdn-images-1.medium.com/max/800/1*MkhCr_yfDYwNsyZzM5-Elg.png)

-   Browse to the **silver-container** directory and select the **ProductSales** folder.
-   Once the file path has been set, select **OK**.

![](https://cdn-images-1.medium.com/max/800/1*dcpV52ZPLZ8gjn6kvgSRJw.png)

![](https://cdn-images-1.medium.com/max/800/1*tHsamPGNVIIVzjEjwZeoUQ.png)

The panel will close, and you will be brought back to the Settings tab.

-   Within the (1) **DeltaGoldProductSales** tab, select the  (2) **DeltaTransformGoldProductSales** tile.

![](https://cdn-images-1.medium.com/max/800/1*l88-y3jtsCDzSD1fULXVSw.png)

-   Select the (1) **Settings** tab and click the (2) **Browse** button next to the **Folder path**.

![](https://cdn-images-1.medium.com/max/800/1*d_J0Ik282Tb-bt20EK8FoQ.png)

-   Browse to the **gold-container** directory and select the **ProductSales** folder.
-   Once the file path has been set, select **OK**.

![](https://cdn-images-1.medium.com/max/800/1*LgoaFKiI1nr3EsPNDdQlbA.png)

![](https://cdn-images-1.medium.com/max/800/1*tHsamPGNVIIVzjEjwZeoUQ.png)

The panel will close, and you will be brought back to the Settings tab.

The **DeltaGoldProductSales** Data Flow is now configured and the **TransformDeltaFormat** pipeline is ready to be triggered.

-   Go back to the **TransformDeltaFormat** tab.

![](https://cdn-images-1.medium.com/max/800/1*9ysLKNIZTjI-UY9_aa-WPw.png)

-   Select the **Publish All** button to save the work you have done so far.

![](https://cdn-images-1.medium.com/max/800/1*fu4AT4Qy6dG072r-XEEN9w.png)

-   A new panel should open to the right. Select the **Publish** button.

![](https://cdn-images-1.medium.com/max/800/1*2Ec3cSvR2X2iFSd4VFE5qw.png)

![](https://cdn-images-1.medium.com/max/800/1*lBLZ7dDYh9De3VZTWFYXww.png)

A banner should appear confirming that the content was published.

![](https://cdn-images-1.medium.com/max/800/1*V32mMjreX3SLZE3Z5vJMFA.png)

We will now manually trigger the Data Flows we configured.

----------

#### 2.2 Manually Trigger Pipelines (Before Data Changes)

Let’s trigger our synapse pipelines to extract, transform, and load the raw CSV data in our bronze-container as delta-formatted data into our silver and gold-containers.

Azure Synapse Pipelines allow for event-based triggers, that start the pipeline when new data is added to the Azure storage. But to keep this example simple, we will be manually triggering the pipelines we have created.

-   Within the Azure Synapse Workspace, select the (1) **Integrate** tab and select the pipeline (2) **TransformDeltaFormat**.

![](https://cdn-images-1.medium.com/max/800/1*1jBalqHCFOnGkXhP2LpAFg.png)

-   Once the pipeline is selected, a new tab with the Data Flow activities we configured earlier will appear.

![](https://cdn-images-1.medium.com/max/800/1*eVxAxh6M05fFkR2JeK6Zvw.png)

-   Select the **Data flow debug** toggle button, to initiate the integration runtime.

**_NOTE: If the debug is still on [green], you may skip the steps to re-activate it._**

![](https://cdn-images-1.medium.com/max/800/1*kR0b501kWU8EwyHPYqwMog.png)

-   Once toggled, a new panel will open to the right, with the debug setting. Leave the default settings and select **OK**.

![](https://cdn-images-1.medium.com/max/800/1*MFCkl3w-0jwn-A9dUTWi9A.png)

**_NOTE: The debug initialization might take 3–5 minutes. Please be patient!_**

-   Select the **Debug** button to run the **TransformDeltaFormat** pipeline we configured and verify that the data flow is working.

![](https://cdn-images-1.medium.com/max/800/1*MQO3kSLmcDBrIjzpaGKxKQ.png)

-   If prompted by the message **Use debug cluster?** Select **Use Integration Runtime.**

![](https://cdn-images-1.medium.com/max/800/1*2QOJHILNEhBj_wvURLJcNw.png)

-   Once the Debug is selected, click on the whitespace of the **TransformDeltaFormat** canvas. You should now see the pipelines run.

![](https://cdn-images-1.medium.com/max/800/1*Vmef00HBSRdMgo3j_43kfQ.png)

-   The status of both data flows should change to Succeeded after approximately **3–5 minutes**.

![](https://cdn-images-1.medium.com/max/800/1*D2WCJYg1JkKrqH89eJ4q8w.png)

----------

#### 2.3 Data Changes

In real business scenarios, the data you upload will go through changes on a periodic or even aperiodic basis. To reflect those changes, we will make manual changes to our **product sales** data.

The delta format keeps track of these changes and allows us later to view these changes through audit logs and to time travel i.e., view a different version of that same data.

For the sake of simplicity, we will create this change manually by overwriting the **FactProductSales.csv** file we uploaded in the bronze-container with a new version containing additional rows.

-   Go back to the Azure portal home screen and select the **Resource group** you provisioned.

![](https://cdn-images-1.medium.com/max/800/1*sCoh3Eo4rlYRISqTlpojDw.png)

-   Once the resource group is open, select the **Storage account**.

![](https://cdn-images-1.medium.com/max/800/1*20gMtWrwwOc35WQKO-BAMQ.png)

-   Select the (1) **Containers** tab on the left panel and select the (2) **container**.

![](https://cdn-images-1.medium.com/max/800/1*5_s6IoefjKQRo79UUQOA4Q.png)

-   Within the container, select the **bronze-container** file  directory.

![](https://cdn-images-1.medium.com/max/800/1*65xLEkOexuivozidAoCG1g.png)

-   Upload the **FactProductSales.csv** file which can be found  in the **Changes** subfolder within the **Data** Folder.

**_Note: the changed CSV files can be found in the data folder (changes subfolder) within the ZIP file you downloaded in Chapter 2. Files. You can also download the data directly from the GitHub repository located_** [**_here_**](https://github.com/AllgeierSchweiz/azure-data-lakehouse-lab/tree/main/data/changes)**_._**

![](https://cdn-images-1.medium.com/max/800/1*FoSvwp58Wmy2ez6wmwc4sQ.png)

The changed **FactProductSales.csv** file contains additional rows.

![](https://cdn-images-1.medium.com/max/800/1*LdOj3q8Q0tWLrWSZh2lbxg.png)

-   Within the bronze-container, select the **Upload** button.

![](https://cdn-images-1.medium.com/max/800/1*8XRpTtyV7JDYD26N4DyQNg.png)

-   A new panel will open to the right. (1) **Drag and Drop** the **FactProductSales.csv** file from the **Changes** folder, toggle the (2) **Overwrite if files already exist,** and select (3) **Upload**.

![](https://cdn-images-1.medium.com/max/800/1*ngFHFcFtQ3nisEU45vLEmQ.png)

You should get a successfully uploaded banner:

![](https://cdn-images-1.medium.com/max/800/1*gNqE_kTfR_ShDdLpfJR9PQ.png)

----------

#### 2.4 Manually Trigger Pipelines (After Data Changes)

We uploaded our changed data into the bronze-container. Let’s trigger our Azure Synapse pipelines to extract, transform, and load these changes into our silver and gold-containers.

-   Go back to your Azure Synapse Workspace and select the (1) **Integrate** tab and select the pipeline (2) **TransformDeltaFormat**.

![](https://cdn-images-1.medium.com/max/800/1*1jBalqHCFOnGkXhP2LpAFg.png)

-   Once the pipeline is selected, a new tab with the Data Flow activities we created earlier will appear.

![](https://cdn-images-1.medium.com/max/800/1*eVxAxh6M05fFkR2JeK6Zvw.png)

-   Select the **Data flow debug** toggle button, to initiate the integration runtime.

**_NOTE: If the debug is still on [green], you may skip the steps to re-activate it._**

![](https://cdn-images-1.medium.com/max/800/1*kR0b501kWU8EwyHPYqwMog.png)

-   Once toggled, a new panel will open to the right, with the debug setting. Leave the default settings and select **OK**.

![](https://cdn-images-1.medium.com/max/800/1*MFCkl3w-0jwn-A9dUTWi9A.png)

**_NOTE: The debug initialization might take 3–5 minutes. Please be patient!_**

-   Select the **Debug** button to run the **TransformDeltaFormat** pipeline we configured and verify that the data flow is working.

![](https://cdn-images-1.medium.com/max/800/1*MQO3kSLmcDBrIjzpaGKxKQ.png)

-   If prompted by the message **Use debug cluster?** Select **Use Integration Runtime.**

![](https://cdn-images-1.medium.com/max/800/1*2QOJHILNEhBj_wvURLJcNw.png)

-   Once the Debug is selected, click on the whitespace of the **TransformDeltaFormat** canvas. You should now see the pipelines run.

![](https://cdn-images-1.medium.com/max/800/1*Vmef00HBSRdMgo3j_43kfQ.png)

-   The status of both data flows should change to Succeeded after approximately **3–5 minutes**.

![](https://cdn-images-1.medium.com/max/800/1*D2WCJYg1JkKrqH89eJ4q8w.png)

----------

You have now finalized importing, configuring, and triggering the Data Flow pipelines in Azure Synapse Analytics. These pipelines will perform the ETL process and sink your data into your Azure Storage in the Delta Format. In Part 4 you will use this Delta formatted data to create Lake Databases and the associated Delta Tables.
