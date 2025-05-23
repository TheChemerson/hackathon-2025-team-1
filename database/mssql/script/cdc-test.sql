/* Test CDC */

INSERT CUSTOMER_ORDER (order_amt)
SELECT 17.13 AS order_amt;

DECLARE @from_lsn BINARY(10)
      , @to_lsn   BINARY(10);  

SET @from_lsn = [sys].[fn_cdc_get_min_lsn]('dbo_CUSTOMER_ORDER');
SET @to_lsn   = [sys].[fn_cdc_map_time_to_lsn]('largest less than or equal', GETDATE());
SELECT @from_lsn, @to_lsn
  
SELECT * FROM cdc.fn_cdc_get_net_changes_dbo_CUSTOMER_ORDER(@from_lsn, @to_lsn, 'ALL');