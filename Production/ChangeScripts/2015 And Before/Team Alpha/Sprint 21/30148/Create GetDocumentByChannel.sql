USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentsByChannel]    Script Date: 12/30/2013 14:09:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetDocumentsByChannel]
	@ChannelID int = null

AS
BEGIN
	SET NOCOUNT ON;
	
SELECT DISTINCT
	 m.DocumentID 
	,d.DocOrientation
	,d.DocumentTypeID
	,d.DocumentVersion
	,d.FileName
	,d.LanguageID
	,d.ModifiedDate
	
FROM M_DocumentMap m WITH (NOLOCK)
INNER JOIN LK_PartnerMarket k WITH (NOLOCK) on m.MarketID = k.MarketID
INNER JOIN T_Documents d WITH (NOLOCK) on m.DocumentID = d.DocumentID
WHERE (k.PartnerID = @ChannelID)
	
	SET NOCOUNT OFF;
END;
GO


