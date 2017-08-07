USE [LibertyPower]
GO

/****** Object:  Table [dbo].[UtilityBillingType]    Script Date: 07/26/2011 15:23:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE BillingType
	ADD [Description] VARCHAR(50)

GO

UPDATE	BillingType
SET		[Description] = 'Dual'
WHERE	BillingTypeID = 2

UPDATE	BillingType
SET		[Description] = 'UCB Rate Ready'
WHERE	BillingTypeID = 3

UPDATE	BillingType
SET		[Description] = 'UCB Bill Ready'
WHERE	BillingTypeID = 1

UPDATE	BillingType
SET		[Description] = 'Supplier Consolidated'
WHERE	BillingTypeID = 4

/********************************* UtilityBillingType **************************************************/

CREATE TABLE [dbo].[UtilityBillingType](
	[UtilityID] [int] NOT NULL,
	[BillingTypeID] [int] NOT NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
 CONSTRAINT [PK_Utility_BillingType] PRIMARY KEY CLUSTERED 
(
	[UtilityID] ASC,
	[BillingTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UtilityBillingType] ADD  CONSTRAINT [DF_Utility_BillingType_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO

/*********************** GET DATA ******************************/

IMPORT EXCEL FILE TO UtilityBillingType

GO

/************************************* usp_UtilityBillingTypeSelect ******************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		insert billing type																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE	usp_UtilityBillingTypeSelect
		@Utility	VARCHAR(50)
AS

BEGIN
	SELECT	ub.BillingTypeID, b.Type, b.Description
	FROM	UtilityBillingType ub
	INNER	JOIN BillingType b
	ON		ub.BillingTypeID = b.BillingTypeID
	INNER	JOIN Utility u
	ON		u.ID = ub.UtilityID
	WHERE	u.UtilityCode = @Utility
	AND		b.Active = 1
	
END

