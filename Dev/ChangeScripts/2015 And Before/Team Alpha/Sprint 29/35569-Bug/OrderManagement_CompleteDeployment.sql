USE OrderManagement;
/****** Object:  Table [dbo].[docs] RAD PDF Version: 2.19+ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BEGIN TRAN

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='docs') 
	drop table docs

--    SELECT 1 AS res ELSE SELECT 0 AS res;
CREATE TABLE OrderManagement.[dbo].[docs](
	[docID] [int] IDENTITY(1,1) NOT NULL,
	[pdfID] [int] NOT NULL,
	[docDate] [datetime] NOT NULL,
	[docDateModified] [datetime] NULL,
	[docStatus] [int] NOT NULL,
	[docSettings] [int] NOT NULL,
	[docFileName] [nvarchar](200) NOT NULL,
	[docXml] [nvarchar](max) NOT NULL,
	[docOutputData] [varbinary](max) NULL,
 CONSTRAINT [PK_docs] PRIMARY KEY CLUSTERED 
(
	[docID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='pdfs') 
	drop table pdfs

CREATE TABLE OrderManagement.[dbo].[pdfs](
	[pdfID] [int] IDENTITY(1,1) NOT NULL,
	[pdfDate] [datetime] NOT NULL,
	[pdfStatus] [int] NOT NULL,
	[pdfVersion] [int] NOT NULL,
	[pdfPageLoaded] [int] NOT NULL,
	[pdfPageCount] [int] NOT NULL,
	[pdfUserRights] [int] NOT NULL,
	[pdfDpi] [int] NOT NULL,
	[pdfDpiHigh] [int] NOT NULL,
	[pdfData] [varbinary](max) NOT NULL,
	[pdfDataLength] [int] NOT NULL,
	[pdfDataHash] [binary](64) NOT NULL,
	[pdfPassHash] [binary](64) NULL,
	[pdfXml] [nvarchar](max) NOT NULL,
	[pdfText] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_pdfs] PRIMARY KEY CLUSTERED 
(
	[pdfID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]



IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='objs') 
	drop table objs

CREATE TABLE OrderManagement.[dbo].[objs](
	[objID] [int] IDENTITY(1,1) NOT NULL,
	[docID] [int] NOT NULL,
	[objType] [int] NOT NULL,
	[objSettings] [int] NOT NULL,
	[objData] [varbinary](max) NOT NULL,
	[objDataLength] [int] NOT NULL,
 CONSTRAINT [PK_objs] PRIMARY KEY CLUSTERED 
(
	[objID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]




IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='keys') 
	drop table keys

CREATE TABLE OrderManagement.[dbo].[keys](
	[keyID] [int] IDENTITY(1,1) NOT NULL,
	[docID] [int] NOT NULL,
	[keyData] [char](25) NOT NULL,
	[keyExpires] [datetime] NOT NULL,
	[keySettings] [int] NOT NULL,
 CONSTRAINT [PK_keys] PRIMARY KEY CLUSTERED 
(
	[keyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='pges') 
	drop table pges

CREATE TABLE OrderManagement.[dbo].[pges](
	[pdfID] [int] NOT NULL,
	[docID] [int] NOT NULL,
	[keyID] [int] NOT NULL,
	[pgeDate] [datetime] NOT NULL,
	[pgeStatus] [int] NOT NULL,
	[pgeNumber] [int] NOT NULL,
	[pgeImageType] [int] NOT NULL,
	[pgeImageData] [varbinary](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--ROLLBACK
COMMIT
