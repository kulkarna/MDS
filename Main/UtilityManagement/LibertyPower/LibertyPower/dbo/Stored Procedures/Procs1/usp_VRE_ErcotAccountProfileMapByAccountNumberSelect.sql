

CREATE PROCEDURE [dbo].[usp_VRE_ErcotAccountProfileMapByAccountNumberSelect]
      @ESSID varchar(100)
AS
BEGIN
      
      SET NOCOUNT ON;

      SELECT [account_id]
      ,[UIDESIID]
      ,[ESIID]
      ,[ProfileID]
      ,[STARTTIME]
      ,[STATIONCODE]
      ,[ZoneID]
      ,[LOSSCODE]
      ,[status]
      ,[sub_status]
      ,[date_flow_start]
      ,[product_id]
      ,[rate]
  FROM [ERCOT].[dbo].[vwqryAccountsByProfile_New]
  Where
      [ESIID] = @ESSID
                  
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ErcotAccountProfileMapByAccountNumberSelect';

