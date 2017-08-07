


CREATE PROCEDURE [dbo].[usp_AccountEtfWaivedReasonCodeSelect] 

AS
BEGIN
	SET NOCOUNT ON;

	SELECT [EtfWaivedReasonCodeID]
      ,[Reason]
	FROM [AccountEtfWaivedReasonCode] WITH (NOLOCK)
	ORDER BY 1
	
	SET NOCOUNT OFF;
	
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfWaivedReasonCodeSelect';

