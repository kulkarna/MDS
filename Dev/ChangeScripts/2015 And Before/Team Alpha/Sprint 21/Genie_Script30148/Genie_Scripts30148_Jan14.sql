-----------------------------------------------------------------------------------
--GENIE SCripts
--pls Connect to Genie Database
--30514: As a market service I should be able to return a list of Service Class items to consumers
--30148: As a Document API I need to be able to retrieve a list of documents applicable to a given
-- Market-Product so that they system facilitates standard contracting
-------------------------------------------------------------------------------------
USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentsByChannel]    Script Date: 01/17/2014 15:36:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentsByChannel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDocumentsByChannel]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentsByChannel]    Script Date: 01/17/2014 15:36:29 ******/
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


---------------------------------------------------------------------------------------
USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentMapsByChannelAndMarket]    Script Date: 01/17/2014 15:37:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentMapsByChannelAndMarket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDocumentMapsByChannelAndMarket]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentMapsByChannelAndMarket]    Script Date: 01/17/2014 15:37:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetDocumentMapsByChannelAndMarket]
	@ChannelID int = null,
	@MarketID int = null

AS
BEGIN	

SELECT
	 m.DocumentMapID
	,m.MarketID
	,m.BrandID
	,m.AccountTypeID
	,m.TemplateTypeID
	,m.DocumentID 
FROM M_DocumentMap m 
INNER JOIN 
(
SELECT DISTINCT
	 m.DocumentID
	
FROM M_DocumentMap m WITH (NOLOCK)
INNER JOIN LK_PartnerMarket k on m.MarketID = k.MarketID
INNER JOIN T_Documents d on m.DocumentID = d.DocumentID
WHERE (k.PartnerID = @ChannelID)
AND (k.MarketID = @MarketID)
) d ON m.DocumentID = d.DocumentID

END

GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentMapsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:37:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentMapsByChannelAndMarketAndProduct]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDocumentMapsByChannelAndMarketAndProduct]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentMapsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:37:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetDocumentMapsByChannelAndMarketAndProduct]
	@ChannelID int = null,
	@MarketID int = null,
	@ProductID int = null

AS
BEGIN	

SELECT
	 m.DocumentMapID
	,m.MarketID
	,m.BrandID
	,m.AccountTypeID
	,m.TemplateTypeID
	,m.DocumentID 
FROM M_DocumentMap m 
INNER JOIN 
(
SELECT DISTINCT
	 m.DocumentID
	
FROM M_DocumentMap m WITH (NOLOCK)
INNER JOIN LK_PartnerMarket k on m.MarketID = k.MarketID
INNER JOIN T_Documents d on m.DocumentID = d.DocumentID
WHERE (k.PartnerID = @ChannelID)
AND (k.MarketID = @MarketID)
AND (m.BrandID = @ProductID)
) d ON m.DocumentID = d.DocumentID

END

GO



USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentsByChannelAndMarket]    Script Date: 01/17/2014 15:41:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentsByChannelAndMarket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDocumentsByChannelAndMarket]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentsByChannelAndMarket]    Script Date: 01/17/2014 15:41:30 ******/
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


USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:42:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentsByChannelAndMarketAndProduct]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDocumentsByChannelAndMarketAndProduct]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:42:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetDocumentsByChannelAndMarketAndProduct] 
	@ChannelID int = null,
	@MarketID int = null,
	@ProductID int = null
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
	AND (k.MarketID = @MarketID)
	AND (m.BrandID = @ProductID)
	
	SET NOCOUNT OFF;
END

GO


USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannel]    Script Date: 01/17/2014 15:42:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFieldLocationsByChannel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFieldLocationsByChannel]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannel]    Script Date: 01/17/2014 15:42:40 ******/
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

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannelAndMarket]    Script Date: 01/17/2014 15:43:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFieldLocationsByChannelAndMarket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFieldLocationsByChannelAndMarket]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannelAndMarket]    Script Date: 01/17/2014 15:43:20 ******/
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

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:44:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFieldLocationsByChannelAndMarketAndProduct]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFieldLocationsByChannelAndMarketAndProduct]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldLocationsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:44:02 ******/
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

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldsByChannel]    Script Date: 01/17/2014 15:44:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFieldsByChannel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFieldsByChannel]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldsByChannel]    Script Date: 01/17/2014 15:44:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetFieldsByChannel]
	@ChannelID int = null
AS

BEGIN

SET NOCOUNT ON;
	
DECLARE @Locations TABLE
(
	DocumentID int ,
	FieldID int ,
	LocationX int,
	LocationY int,
	PRIMARY KEY CLUSTERED (DocumentID, FieldID)
);

DECLARE @Documents TABLE
(
	DocumentID int,
	DocOrientation char(1),
	DocumentTypeID int,
	DocumentVersion varchar(50),
	FileName varchar(250),
	LanguageID int,
	ModifiedDate datetime,
	PRIMARY KEY (DocumentID)
	
)

INSERT INTO @Documents
EXEC dbo.GetDocumentsByChannel @ChannelID;

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


USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldsByChannelAndMarket]    Script Date: 01/17/2014 15:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFieldsByChannelAndMarket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFieldsByChannelAndMarket]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldsByChannelAndMarket]    Script Date: 01/17/2014 15:45:45 ******/
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


USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:46:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFieldsByChannelAndMarketAndProduct]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFieldsByChannelAndMarketAndProduct]
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetFieldsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:46:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--DECLARE @ChannelID int = 554;
--DECLARE @MarketID int = 8;
--DECLARE @ProductID int = 14;


CREATE PROCEDURE [dbo].[GetFieldsByChannelAndMarketAndProduct]
	@ChannelID int = null,
	@MarketID int = null,
	@ProductID int = null
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
	PRIMARY KEY(DocumentID)
)

INSERT INTO @Documents
EXEC dbo.GetDocumentsByChannelAndMarketAndProduct @ChannelID, @MarketID, @ProductID;

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





