<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- ABOUT THE PROJECT -->
# Creating a Modern Data Lakehouse with Azure Synapse
## Azure Resource Deployment

This Data Lakehouse architecture uses Azure Synapse Analytics, Azure Data Lake Storage Gen2 (ADLS) and an Apache Spark pool. 

These Azure resources are provisioned using Infrastructure as Code (IaC) with a Azure Resource Management (ARM) template.

Click the button below to start the deployment process.

[![Deploy To Azure][azure-schield]][azure-url]

![Synapse Analytics](images/Data-Lakehouse.png)

This template deploys the following:

- An Azure Synapse Workspace
  - (OPTIONAL) Allows All connections in by default (Firewall IP Addresses)
  - Allows Azure Services to access the workspace by default  
- Apache Spark Pool
  - [Spark version 3.3](https://learn.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-33-runtime)
  - Auto-paused set to 15 minutes of idling
- Azure Data Lake Storage Gen2 account
  - Azure Synapse Workspace identity given Storage Blob Data Contributor to the Storage Account
    - A new File System inside the Storage Account to be used by Azure Synapse
- Grants the Workspace identity CONTROL to all SQL pools and SQL on-demand pool

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## What is a Data Lakehouse?

A Data Lakehouse is a data management architecture that combines the key advantages of data lakes and data warehouses into one. 

What makes the Data Lakehouse so special is that the data lake essentially acts as the data warehouse. In other words, a relational database layer is added over the data in a data lake. By storing the data in the Delta Lake format, important functionalities such as ACID compliance, schema enforcement and layout optimization, that were previously only available in data warehouses, now become available on the data lake. This allows you to query the data directly on the data lake, unlike traditional data warehouses, where the data would first need to be stored on disk, before being available for querying.

Querying the Delta Format directly on the data lake is achieved by using a serverless pool. The serverless pool essentially adds an on demand SQL layer on top of the data lake. This in turn enables the creation of lake databases and traditional SQL objects within those databases such as schemas, external tables and views.

This architecture can be created using several cloud service providers such as: Microsoft Azure, Databricks, Amazon Web Services, Google Cloud Platform and Snowflake, to name a few.

In this tutorial, we will be using Microsoft Azure.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Delta Lake to the Rescue!

Most people who work with data management systems have heard of the open-source file format called parquet.

Delta Lake, also called Delta, is an open source file protocol that uses a versioned Parquet file format. The most important features that Delta Lake offers are: **ACID transactions, time travel, and concurrency control**, as well as **optimizations** to improve query performance. 

These features enable both business intelligence (BI) and machine learning (ML) capabilties on all data.

![Challenges](images/Delta-Lake-Challenges.png)

It should also be noted that there are other parquet based open-source protocols such as Apache Hudi and Apache Iceberg. 

In the case of Azure Synapse or Microsoft in general, the out-of-the-box Data Lakehouse format is Delta Lake, however, With additional configuration, these other procotols may also be implemented. 

These steps are outside the scope of this workshop.

![ProvidersFormats](images/Providers-Formats.png)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Data Lakehouse Architecture

The architecture setup will follow the workflow of the diagram below:

![Architecture](images/Data-Lakehouse-Architecture.png)

The data stored in the data lake will be organized using the medallion structure. 

The medallion structure uses three layers that denote the quality of the data being stored. Each layer is a directory inside the Azure Data Lake Storage. The three layers are: 

- Bronze (raw)
- Silver (transformed and enriched)
- Gold (aggregated)
 
The data is moved from one layer to the next using Data Flows in Azure Synapse Pipelines.

With Synapse Notebooks the data in each layer can be queried with the provisioned Serverless Pools. 

The data available in the silver and gold layers are made available as Delta Tables in a Lake Database using notebook scripts written in SparkSQL or PySpark.

Once these Delta Tables are available, they can be imported into Power BI using the synapse serverless sql endpoint.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- FILES -->
## Documentation, Data & Support Files

The complete workshop, with all the necessary files can be found [here](Modern-Data-Lakehouse.zip). Download and unzip the file on your local computer.

The same files on the zip folder above can be found individually directly on this repository (see links below).

**Workshop Tutorial**

- [Documentation](documentation/Creating-a-Modern-Data-Lakehouse-with-Azure-Synapse.pdf)

**Data**

- [FactProductCategoryPredictions](data/FactProductCategoryPredictions.csv)
- [FactProductSales](data/FactProductSales.csv)

**Data Changes**

- [FactProductSales](data/changes/FactProductSales.csv)

**Azure Synapse Pipeline**

- [Dataflow](documentation/support/pipeline/TransformDeltaFormat.zip)

**Azure Synapse Notebooks**

- [Setup Bronze Database](documentation/support/notebooks/Setup-Bronze-Database.sql)
- [Setup Silver Database](documentation/support/notebooks/Setup-Silver-Database.sql)
- [Setup Gold Database](documentation/support/notebooks/Setup-Gold-Database.sql)


<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTACT -->
## Contact

If there are any questions, feel free to reach out!

Nicolas Rehder - nrehder@allgeier.ch

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- REFERENCES -->
## References

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Azure Architectures](https://learn.microsoft.com/en-us/azure/architecture/browse/)
* [Medallion Structure](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion)
* [Medallion Structure Best Practices](https://piethein.medium.com/medallion-architecture-best-practices-for-managing-bronze-silver-and-gold-486de7c90055)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/AllgeierSchweiz/azure-data-lakehouse.svg?style=for-the-badge
[contributors-url]: https://github.com/AllgeierSchweiz/azure-data-lakehouse/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/AllgeierSchweiz/azure-data-lakehouse.svg?style=for-the-badge
[forks-url]: https://github.com/AllgeierSchweiz/azure-data-lakehouse/network/members
[stars-shield]: https://img.shields.io/github/stars/AllgeierSchweiz/azure-data-lakehouse.svg?style=for-the-badge
[stars-url]: https://github.com/AllgeierSchweiz/azure-data-lakehouse/stargazers
[issues-shield]: https://img.shields.io/github/issues/AllgeierSchweiz/azure-data-lakehouse.svg?style=for-the-badge
[issues-url]: https://github.com/AllgeierSchweiz/azure-data-lakehouse/issues
[license-shield]: https://img.shields.io/github/license/AllgeierSchweiz/azure-data-lakehouse.svg?style=for-the-badge
[license-url]: https://github.com/AllgeierSchweiz/azure-data-lakehouse/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/nicolas-a-rehder/
[azure-schield]: https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true
[azure-url]: https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAllgeierSchweiz%2Fazure-data-lakehouse%2Fmain%2Fazuredeploy.json
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
