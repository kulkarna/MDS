----------------------------------------------------------------------
--Script for Genie Mapping
--Create new table for mapping brandTable in Genie and Libertypower Database
--NOv 8 2013
------------------------------------------------------------------------------

USE [GENIE]
GO

/****** Object:  Table [dbo].[LK_Genie_LP_Brand_Mapping]    Script Date: 11/11/2013 09:09:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LK_Genie_LP_Brand_Mapping]') AND type in (N'U'))
DROP TABLE [dbo].[LK_Genie_LP_Brand_Mapping]
GO

USE [GENIE]
GO

/****** Object:  Table [dbo].[LK_Genie_LP_Brand_Mapping]    Script Date: 11/11/2013 09:09:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[LK_Genie_LP_Brand_Mapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GenieBrandId] [int] NOT NULL,
	[LPBrandDescription] [varchar](100) NULL,
 CONSTRAINT [PK_LK_Genie_LP_Brand_Mapping] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


--------------------------------------------------------------
--Insert Mapping Data 
----------------------------------------------------------------

USE [Genie]
GO
/****** Object:  Table [dbo].[LK_Genie_LP_Brand_Mapping]    Script Date: 11/08/2013 12:53:12 ******/
SET IDENTITY_INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ON
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (1, 18, N'Independence Plan')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (2, 8, N'Independence Plan')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (3, 22, N'Independence Plan')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (4, 10, N'Independence Plan')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (5, 11, N'Independence Plan')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (6, 12, N'Independence Plan')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (7, 13, N'Independence Plan')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (8, 20, N'Super Saver')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (9, 19, N'Super Saver')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (10, 14, N'Super Saver')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (11, 27, N'Liberty Flex')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (12, 15, N'Liberty Flex')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (13, 28, N'Liberty Flex')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (14, 16, N'Liberty Flex')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (15, 2, N'Custom Fixed')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (16, 3, N'Custom Fixed')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (17, 5, N'Custom Index')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (18, 1, N'Custom Block Index')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (19, 21, N'Freedom To Save')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (20, 6, N'Freedom To Save')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (21, 7, N'Freedom To Save')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (22, 9, N'Hybrid')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (23, 4, N'Hybrid')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (24, 24, N'Fixed IL Wind')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (25, 23, N'Fixed IL Wind')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (26, 25, N'Fixed National Green E')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (27, 26, N'Fixed National Green E')
INSERT [dbo].[LK_Genie_LP_Brand_Mapping] ([ID], [GenieBrandId], [LPBrandDescription]) VALUES (28, 33, NULL)
SET IDENTITY_INSERT [dbo].[LK_Genie_LP_Brand_Mapping] OFF


---------------------------------------------------------------------------------------------------------

USE [Genie]
GO
/****** Object:  StoredProcedure [dbo].[spGenie_UpdateQualifiers]    Script Date: 11/08/2013 12:01:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Date:     10/24/2013
-- Description: Moving the records from ST_Qualifier to T_Qualifier 

--Modified the Brand Description to fetch from the mapping table
--NOv 8 2013
-- =============================================

ALTER proc [dbo].[spGenie_UpdateQualifiers] as
begin


SET NOCOUNT ON

DECLARE @DestCount INT 
DECLARE @result INT =0

Truncate Table T_Qualifier

--Since the AccountType in Libertypower is RES and in Genie Database is RESIDENTIAL
Update ST_Qualifier set AccountTypeDesc='RESIDENTIAL' where AccountTypeDesc='RES'

Insert into T_Qualifier     
Select Q.PromotionCodeID,P.PartnerID,M.MarketID,U.UtilityID,A.AccountTypeID,Q.ContractTerm,B.[GenieBrandId],Q.SignStartDate,Q.SignEndDate,
Q.ContractEffecStartPeriodStartDate,Q.ContractEffecStartPeriodLastDate,S.ServiceClassID,AutoApply
 from Genie..ST_Qualifier Q  With (NoLock)
Inner  join Genie..LK_Partner P  With (NoLock) on  Q.partnerName=P.PartnerName 
LEFT join Genie..LK_Market M  With (NoLock) on Q.MarketName=M.MarketCode
LEFT join Genie..LK_Utility U  With (NoLock) on Q.UtilityName=U.UtilityCode
LEFT Join Genie..LK_AccountType A   With (NoLock) on Q.AccountTypeDesc =A.AccountType   
LEFT Join GENIE..[LK_Genie_LP_Brand_Mapping] B  With (NoLock) on Q.BrandDescription=B.LPBrandDescription 
LEFT Join Genie..LK_ServiceClass S  With (NoLock) on S.ServiceClassCode like '%'+ Q.PriceTierDescription +'%' and S.UtilityID=U.UtilityID

	Set @DestCount=@@RowCount
	
	if (@DestCount>0)
	Set @result=1
	else
	Set @result=0

Select @result as result

SET NOCOUNT OFF
end
GO
--------------------------------------------------------------------------


GRANT SELECT ON  GENIE..[LK_Genie_LP_Brand_Mapping] TO SSISACCESS
GRANT INSERT ON  GENIE..[LK_Genie_LP_Brand_Mapping] TO SSISACCESS
GRANT DELETE ON  GENIE..[LK_Genie_LP_Brand_Mapping] TO SSISACCESS
GRANT UPDATE ON  GENIE..[LK_Genie_LP_Brand_Mapping] TO SSISACCESS



-----------------------------------------------------------------------------------
GO



