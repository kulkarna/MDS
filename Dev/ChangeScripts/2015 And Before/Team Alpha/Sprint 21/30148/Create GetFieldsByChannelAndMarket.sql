USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldsByChannelAndMarket]    Script Date: 12/30/2013 14:11:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetFieldsByChannelAndMarket]
	@ChannelID int = null,
	@MarketID int = null
AS

BEGIN

SET NOCOUNT ON;

DECLARE @Locations TABLE
(
	DocumentID int,
	FieldID int,
	LocationX int,
	LocationY int,
	PRIMARY KEY CLUSTERED(DocumentID, FieldID)
)
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
		PRIMARY KEY(DocumentID)
	)

	INSERT INTO @Documents
	EXEC dbo.GetDocumentsByChannelAndMarket @ChannelID, @MarketID;
	
INSERT INTO @Locations
SELECT
	l.DocumentID,
	l.FieldID,
	l.LocationX,
	l.LocationY
FROM T_DocumentFieldLocation  l WITH (NOLOCK)
inner join @Documents d on l.DocumentID = d.DocumentID

SELECT
	 f.FieldID
	,FieldName
	,ColumnName
	,Prompt1
	,Prompt2
	,FieldTypeID
FROM LK_DocumentField f WITH (NOLOCK)
WHERE f.FieldID in 
(select distinct FieldID from @Locations)

SET NOCOUNT OFF;

END
GO


