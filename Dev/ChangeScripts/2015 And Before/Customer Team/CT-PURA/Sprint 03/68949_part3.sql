
------------------------------
--Script to update to set CTPURA=1
--When CTPURA Changes get deployed to Production
----------------------------------

Use Libertypower
GO

If exists  ( SELECT [ISCTPURA]
  FROM [LibertyPower].[dbo].[OrdersAPIConfiguration] (NOLock))
  Begin
  
  Update [LibertyPower].[dbo].[OrdersAPIConfiguration] SET ISCTPURA=1
  END
  GO
  