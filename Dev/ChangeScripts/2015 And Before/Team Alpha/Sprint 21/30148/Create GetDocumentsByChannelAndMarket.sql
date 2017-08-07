USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentsByChannelAndMarket]    Script Date: 12/30/2013 14:09:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetDocumentsByChannelAndMarket]
	@ChannelID int = null,
	@MarketID int = null
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
		,m.MarketID
		,k.PartnerID [ChannelID]
	FROM M_DocumentMap m WITH (NOLOCK)
	INNER JOIN LK_PartnerMarket k WITH (NOLOCK) on m.MarketID = k.MarketID
	INNER JOIN T_Documents d WITH (NOLOCK) on m.DocumentID = d.DocumentID
	WHERE (k.PartnerID = @ChannelID)
	AND (k.MarketID = @MarketID)

	SET NOCOUNT OFF;
END
GO


