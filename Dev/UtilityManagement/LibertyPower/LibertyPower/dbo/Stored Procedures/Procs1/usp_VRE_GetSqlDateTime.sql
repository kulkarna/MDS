

CREATE procedure [dbo].usp_VRE_GetSqlDateTime  

as
select GETDATE()





GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_GetSqlDateTime';

