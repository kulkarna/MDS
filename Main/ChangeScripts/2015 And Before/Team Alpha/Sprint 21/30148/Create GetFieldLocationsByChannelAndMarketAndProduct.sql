USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannelAndMarketAndProduct]    Script Date: 12/30/2013 14:10:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetFieldLocationsByChannelAndMarketAndProduct]
	@ChannelID int = null,
	@MarketID int = null,
	@ProductID int = null
AS

BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @Documents TABLE
	(
		DocumentID int,
		DocOrientation char(1),
		DocumentTypeID int,
		DocumentVersion varchar(50),
		FileName varchar(250),
		LanguageID int,
		ModifiedDate datetime,
		PRIMARY KEY(DocumentID)
	)

	INSERT INTO @Documents
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
	AND (k.MarketID = @MarketID)
	AND (m.BrandID = @ProductID)
	

	SELECT
		l.DocumentID,
		l.FieldID,
		l.LocationX,
		l.LocationY
	FROM T_DocumentFieldLocation l WITH (NOLOCK)
	inner join @Documents d on l.DocumentID = d.DocumentID
	
	SET NOCOUNT OFF;
	
END
GO


