USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountContractRateDelete]    Script Date: 08/30/2013 16:26:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractRateDelete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AccountContractRateDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AccountContractRateDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_AccountContractRateDelete
 *
 * History
 *******************************************************************************
 * 8/30/2013 - Rick Deigsler
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_AccountContractRateDelete]
	@AccountContractRateID	INT
AS
BEGIN
	SET NOCOUNT ON
	
	DELETE
	FROM  LibertyPower..AccountContractRate
	WHERE AccountContractRateID  = @AccountContractRateID
	
	SET NOCOUNT OFF		
END
' 
END
GO
