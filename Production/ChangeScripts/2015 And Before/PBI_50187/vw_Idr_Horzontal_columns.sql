USE [lp_transactions]
GO

/****** Object:  View [dbo].[vw_Idr_Horizontal_Columns]    Script Date: 12/16/2014 06:11:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * vw_Idr_Horizontal_Columns
 *
 * History

 *******************************************************************************
 * 10/20/2014 - Vikas Sharma
 * Created.
 *******************************************************************************
 */
CREATE VIEW [dbo].[vw_Idr_Horizontal_Columns]
AS
SELECT     COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE
FROM         INFORMATION_SCHEMA.COLUMNS
WHERE     (TABLE_NAME = 'IDRUSAGEHORIZONTAL') 
and COLUMN_NAME in 
(
  '0'
,'15'
,'30'
,'45'
,'100'
,'115'
,'130'
,'145'
,'200'
,'215'
,'230'
,'245'
,'300'
,'315'
,'330'
,'345'
,'400'
,'415'
,'430'
,'445'
,'500'
,'515'
,'530'
,'545'
,'600'
,'615'
,'630'
,'645'
,'700'
,'715'
,'730'
,'745'
,'800'
,'815'
,'830'
,'845'
,'900'
,'915'
,'930'
,'945'
,'1000'
,'1015'
,'1030'
,'1045'
,'1100'
,'1115'
,'1130'
,'1145'
,'1200'
,'1215'
,'1230'
,'1245'
,'1300'
,'1315'
,'1330'
,'1345'
,'1400'
,'1415'
,'1430'
,'1445'
,'1500'
,'1515'
,'1530'
,'1545'
,'1600'
,'1615'
,'1630'
,'1645'
,'1700'
,'1715'
,'1730'
,'1745'
,'1800'
,'1815'
,'1830'
,'1845'
,'1900'
,'1915'
,'1930'
,'1945'
,'2000'
,'2015'
,'2030'
,'2045'
,'2100'
,'2115'
,'2130'
,'2145'
,'2200'
,'2215'
,'2230'
,'2245'
,'2300'
,'2315'
,'2330'
,'2345'
,'2359'
)




GO


