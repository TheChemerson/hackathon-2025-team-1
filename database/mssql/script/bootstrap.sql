PRINT 'Creating database DEMO...';
GO
CREATE DATABASE DEMO;
GO

USE DEMO;
GO

PRINT 'Enabling CDC for the database...';
GO
EXEC sys.sp_cdc_enable_db;
GO

PRINT 'Creating CUSTOMER...';
GO
CREATE TABLE CUSTOMER (
    customer_num     INT IDENTITY(1,1)
  , customer_name    VARCHAR(50)
  , created_dt       DATETIME DEFAULT (GETDATE())
  , last_modified_dt DATETIME DEFAULT (GETDATE())
  , CONSTRAINT PK_CUSTOMER PRIMARY KEY CLUSTERED (customer_num)
);
GO

PRINT 'Enabling CDC for CUSTOMER...';
GO
EXEC sys.sp_cdc_enable_table
		@source_schema = 'dbo'
  , @source_name = 'CUSTOMER'
  , @role_name = NULL
  , @supports_net_changes = 1;
GO

PRINT 'Creating CUSTOMER_ORDER...';
GO
CREATE TABLE CUSTOMER_ORDER (
    order_num        INT IDENTITY(1,1)
  , customer_num     INT NOT NULL
  , order_amt        NUMERIC(8,2)
  , order_ccy        CHAR(3) DEFAULT ('USD')
  , created_dt       DATETIME DEFAULT (GETDATE())
  , last_modified_dt DATETIME DEFAULT (GETDATE())
  , CONSTRAINT PK_CUSTOMER_ORDER PRIMARY KEY CLUSTERED (order_num)
);
GO

PRINT "Creating foreign key for CUSTOMER_ORDER...";
GO
ALTER TABLE CUSTOMER_ORDER
ADD CONSTRAINT FK_CUSTOMER_CUSTOMER_ORDER FOREIGN KEY (customer_num)
REFERENCES CUSTOMER (customer_num);
GO

PRINT 'Creating TRANS...';
GO
CREATE TABLE TRANS (
    trans_num   INT NOT NULL
  , account_num INT NOT NULL
  , trans_type  VARCHAR(25)
  , trans_amt   NUMERIC(8,2)
  , trans_ccy   CHAR(3) DEFAULT ('USD')
  , created_dt  DATETIME DEFAULT (GETDATE())
  , CONSTRAINT PK_TRANS PRIMARY KEY CLUSTERED (trans_num)
);
GO

PRINT 'Enabling CDC for CUSTOMER_ORDER...';
GO
EXEC sys.sp_cdc_enable_table
		@source_schema = 'dbo'
  , @source_name = 'CUSTOMER_ORDER'
  , @role_name = NULL
  , @supports_net_changes = 1;
GO

PRINT 'Creating function UNIXTimestampToDateTime...';
GO
CREATE FUNCTION dbo.UNIXTimestampToDateTime (@timestamp BIGINT)
RETURNS DATETIME
AS BEGIN
    RETURN DATEADD(MILLISECOND, @timestamp % 1000, DATEADD(SECOND, @timestamp / 1000, '19700101 00:00:00'));
END;
GO

PRINT 'Creating procedure PutTrans...';
GO
CREATE PROCEDURE dbo.PutTrans
    @trans_num   INT
  , @account_num INT
  , @trans_type  VARCHAR(25)
  , @trans_amt   NUMERIC(8,2)
  , @trans_ccy   CHAR(3)
AS BEGIN
    INSERT INTO TRANS(trans_num, account_num, trans_type, trans_amt, trans_ccy) 
    VALUES (@trans_num, @account_num, @trans_type, @trans_amt, @trans_ccy);		
END;
GO

PRINT 'Bootstrapping completed.';