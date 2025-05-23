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

PRINT 'Enabling CDC for CUSTOMER_ORDER...';
GO
EXEC sys.sp_cdc_enable_table
		@source_schema = 'dbo'
  , @source_name = 'CUSTOMER_ORDER'
  , @role_name = NULL
  , @supports_net_changes = 1;
GO

PRINT 'Creating ORDER_COPY...';
GO
CREATE TABLE ORDER_COPY (
    order_num        INT               NOT NULL
  , customer_num     INT               NOT NULL
  , order_amt        NUMERIC(8,2)      NOT NULL
  , order_ccy        CHAR(3)           NOT NULL   DEFAULT ('USD')
  , created_dt       DATETIME                     DEFAULT (GETDATE())
  , last_modified_dt DATETIME                     DEFAULT (GETDATE())
  , status_ind       TINYINT           NOT NULL   DEFAULT (1)
  , CONSTRAINT PK_ORDER_COPY PRIMARY KEY CLUSTERED (order_num)
);
GO

PRINT 'Creating function UNIXTimestampToDateTime...';
GO
CREATE FUNCTION dbo.UNIXTimestampToDateTime (@timestamp BIGINT)
RETURNS DATETIME
AS BEGIN
    RETURN DATEADD(MILLISECOND, @timestamp % 1000, DATEADD(SECOND, @timestamp / 1000, '19700101 00:00:00'));
END;
GO

PRINT 'Creating procedure PutOrder...';
GO
CREATE PROCEDURE dbo.PutOrder
    @order_num        INT
  , @customer_num     INT
  , @order_amt        NUMERIC(8,2)
  , @order_ccy        CHAR(3)
  , @created_dt       BIGINT
  , @last_modified_dt BIGINT
  , @action           CHAR(1)
AS BEGIN
	  IF (@action = 'c') BEGIN
  		  INSERT INTO ORDER_COPY(order_num, customer_num, order_amt, order_ccy, created_dt, last_modified_dt) 
  	    VALUES (@order_num, @customer_num, @order_amt, @order_ccy, dbo.UNIXTimestampToDateTime(@created_dt), dbo.UNIXTimestampToDateTime(@last_modified_dt));		
	  END
    ELSE IF (@action = 'd') BEGIN
        UPDATE ORDER_COPY
           SET status_ind = 0
         WHERE order_num = @order_num;
    END
	  ELSE BEGIN
        UPDATE ORDER_COPY
           SET customer_num     = @customer_num
             , order_amt        = @order_amt
             , order_ccy        = @order_ccy 
             , last_modified_dt = dbo.UNIXTimestampToDateTime(@last_modified_dt)
         WHERE order_num = @order_num;
	  END;
END;
GO

PRINT 'Bootstrapping completed.';