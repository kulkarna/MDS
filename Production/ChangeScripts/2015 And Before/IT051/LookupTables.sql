USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  /***************************************************************************************************************/
 /****************************************** ProfileLookup ******************************************************/
/***************************************************************************************************************/
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ProfileLookup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ListType] [varchar](3) NOT NULL,
	[UtilityID] [varchar](50) NULL,
	[ISO] [varchar](50) NULL,
	[ProfileID] [varchar](255) NOT NULL,
	[Description] [varchar](500) NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	
 CONSTRAINT [PK_ProfileLookup] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

  /************************************************************************************************************/
 /****************************************** usp_ProfileLookupByListType *************************************/
/************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		get the profiles by type														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_ProfileLookupByListType
				@ListType varchar(2)
AS

SELECT	*
FROM	dbo.ProfileLookup
WHERE	ListType = @ListType

GO

  /************************************************************************************************************/
 /****************************************** usp_ProfileLookupUpdate *****************************************/
/************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		update profiles																	*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_ProfileLookupUpdate
				@ID int,
				@ProfileID varchar(255),
				@Description varchar(500),
				@EffectiveDate datetime,
				@User varchar(50)
				
AS


UPDATE	dbo.ProfileLookup
SET		ProfileID = @ProfileID,
		[Description] = @Description,
		EffectiveDate = @EffectiveDate,
		Modified = GETDATE(),
		ModifiedBy = @User
WHERE	ID = @ID

GO


  /************************************************************************************************************/
 /****************************************** usp_ProfileLookupDelete *****************************************/
/************************************************************************************************************/

/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		delete profiles											*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_ProfileLookupDelete
				@ID int
				
AS

DELETE	dbo.ProfileLookup
WHERE	ID = @ID

GO


  /************************************************************************************************************/
 /****************************************** usp_ProfileLookupInsert *****************************************/
/************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		insert profile											*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_ProfileLookupInsert
				@ListType varchar(2),
				@UtilityID varchar(50) = NULL,
				@ISO varchar(50) = NULL,
				@ProfileID varchar(255),
				@Description varchar(500),
				@EffectiveDate datetime,
				@User varchar(50)
				
AS

INSERT	INTO	dbo.ProfileLookup 
		(	ListType,
			UtilityID,
			ISO,
			ProfileID,
			[Description],
			EffectiveDate,
			Created,
			CreatedBy
			)
VALUES	(	@ListType,
			@UtilityID,
			@ISO,
			@ProfileID,
			@Description,
			@EffectiveDate,
			GETDATE(),
			@User
			)


GO

  /************************************************************************************************************/
 /****************************************** usp_ProfileLookupExist  *****************************************/
/************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		check if a profile exist														*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_ProfileLookupExist
				@ListType varchar(2),
				@UtilityID varchar(50),
				@ISO varchar(50),
				@ProfileID varchar(255)
				
AS

SELECT	COUNT(ID) as countID
FROM	ProfileLookup
WHERE	ListType = @ListType
AND		ProfileID = @ProfileID
AND		(		
			(@UtilityID <> '' AND UtilityID = @UtilityID)
		OR	(@ISO <> '' AND ISO = @ISO)
		)


GO

  /************************************************************************************************************/
 /****************************************** usp_ProfileLookupSelect  *****************************************/
/************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select profiles											*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_ProfileLookupSelect
				@ListType varchar(2),
				@UtilityID varchar(50),
				@ISO varchar(50),
				@ProfileID varchar(255)
				
AS

SELECT	*
FROM	ProfileLookup
WHERE	ListType = @ListType
AND		ProfileID = @ProfileID
AND		(		
			(@UtilityID <> '' AND UtilityID = @UtilityID)
		OR	(@ISO <> '' AND ISO = @ISO)
		)


GO

  /************************************************************************************************************/
 /************************************** usp_ProfileLookupSelectDefault  *************************************/
/************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		select default profile															*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_ProfileLookupSelectDefault
				@UtilityID varchar(50),
				@ISO varchar(50)
				
AS

SELECT	*
FROM	ProfileLookup
WHERE	(		
			(@UtilityID <> '' AND UtilityID = @UtilityID AND ListType = 'UD')
		OR	(@ISO <> '' AND ISO = @ISO AND ListType = 'UD')
		)


GO

  /************************************************************************************************************/
 /********************************************** Update default Zones  ***************************************/
/************************************************************************************************************/
/* **********************************************************************************************
 *	Author:		Cghazal																			*
 *	Created:	10/10/2011																		*
 *	Descp:		update default zone																*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE PROCEDURE usp_ZoneDefaultUpdate
				@ZoneID int,
				@ID int
AS
				
UPDATE	Utility
SET		ZoneDefault = @ZoneID
WHERE	ID =@ID

GO

  /************************************************************************************************************/
 /****************************************** move data from RO_CALENDAR_MAPPING ******************************/
/************************************************************************************************************/
INSERT INTO LibertyPower..ProfileLookup

SELECT	'U', utility_id ,null,load_shape_id_rate_class, null, GETDATE(), GETDATE(), null, null, null
FROM	Lp_historical_info.. RO_CALENDAR_MAPPING
WHERE	determinant = 'LoadShapeID'
ORDER	BY load_shape_id_rate_class

GO

  /************************************************************************************************************/
 /*************************************** move data from historical_info_lookup ******************************/
/************************************************************************************************************/

Insert into LibertyPower..ProfileLookup

SELECT	'UD', lookup_value, null, value, null, GETDATE(), GETDATE(), null, null, null
FROM	lp_historical_info..historical_info_lookup
WHERE	[application] = 'MtM'
AND		category = 'DEFAULT PROFILE BY UTILITY'
ORDER	BY value


GO


Insert into LibertyPower..ProfileLookup Values ('ID', null, 'ERCOT','BUSMEDLF_NORTH',null, GETDATE(), GETDATE(), null, null, null)

GO

get data from List of profile by ISO excel file

