/*

RCR - 17105

the following changes need to be made to the Libertypower..AccountContractRate table:
 
1) add column IsCustomEnd (values 1,0; default 0) 
2) add trigger
     Trigger details:  trigger is to check IsCustomEnd column. If null or 0; then update RateEnd column based on change in RateStart column. Recalculate based on term -1 day. If IsCustomEnd column = 1 then ignore and perform no update.

*/

-- =============================================
-- Author:		José Muñoz - SWCS
-- Create date: 08/15/2013
-- Description:	RCR - 17105 (Rate End Date not sync'ing with term and Rate Start Date)
--				Add Columnd with defaul value
-- =============================================
USE [Libertypower]
GO

ALTER TABLE [dbo].[AccountContractRate]
ADD IsCustomEnd BIT NULL 
DEFAULT 0 WITH VALUES;

GO

