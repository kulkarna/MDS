USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannelAndMarket]    Script Date: 12/30/2013 14:10:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetFieldLocationsByChannelAndMarket]
	@ChannelID int = null,
	@MarketID int = null
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
		MarketID int,
		ChannelID int,
		PRIMARY KEY (DocumentID)
	)

	INSERT INTO @Documents
	EXEC dbo.GetDocumentsByChannelAndMarket @ChannelID, @MarketID;

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


