USE [lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_DocumentLanguageSelect]    Script Date: 05/31/2012 09:22:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Updated 03/09/2012 to use new LibertyPower..Language table
ALTER PROCEDURE [dbo].[usp_DocumentLanguageSelect] (
	@marketCode varchar(50)
)

AS

BEGIN
    SET NOCOUNT ON;
    
	SELECT
		dl.[LanguageID]				AS return_value
		,dl.[Description]			AS option_type

	FROM [LibertyPower]..[Language]						dl WITH (NOLOCK)
	JOIN [lp_documents]..[document_language_market]		dlm WITH (NOLOCK)
		ON dl.LanguageID = dlm.language_id
	JOIN [LibertyPower]..[Market]						m WITH (NOLOCK)
		ON dlm.market_id = m.ID
	WHERE m.MarketCode = @marketCode
END



GO


