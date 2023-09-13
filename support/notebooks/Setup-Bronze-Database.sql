-- Highlight and run
USE MASTER
GO

CREATE DATABASE bronze COLLATE Latin1_General_100_BIN2_UTF8

-- Highlight and run
USE bronze
GO

CREATE SCHEMA bronze
GO

-- Highlight and run
CREATE OR ALTER VIEW bronze.productsales AS
SELECT *
FROM
    OPENROWSET(
        BULK 'see step 8 to find correct path,
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIELDTERMINATOR =';',
        FIRSTROW = 1,
        HEADER_ROW = TRUE
    ) AS [result]
