USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannel]    Script Date: 12/30/2013 14:09:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetFieldLocationsByChannel]
	@ChannelID int = null
	
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
EXEC dbo.GetDocumentsByChannel @ChannelID;

SELECT
	l.DocumentID,
	l.FieldID,
	l.LocationX,
	l.LocationY
FROM T_DocumentFieldLocation  l WITH (NOLOCK)
inner join @Documents d on l.DocumentID = d.DocumentID

SET NOCOUNT OFF;

END
GO


