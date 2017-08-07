USE [LibertyPower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Alter table LibertyPower..PromotionStatus
alter column Code nchar(100)
Go
IF not EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK)
            WHERE TABLE_NAME = 'PromotionStatus' 
           AND  COLUMN_NAME = 'OrderBy')
   Alter table LibertyPower..PromotionStatus
	add  OrderBy int

Go
if not exists( Select 1 from LibertyPower..PromotionStatus WITH (NOLOCK) where Code='Sent Reward Form')
	insert into LibertyPower..PromotionStatus(Code,[Description],CreatedBy,CreatedDate) values( 'Sent Reward Form','Sent Reward Form',1982,GETDATE())
if not exists( Select 1 from LibertyPower..PromotionStatus WITH (NOLOCK) where Code='Received 1st Reward Form')
	insert into LibertyPower..PromotionStatus(Code,[Description],CreatedBy,CreatedDate) values( 'Received 1st Reward Form','Received 1st Reward Form',1982,GETDATE())
if not exists( Select 1 from LibertyPower..PromotionStatus WITH (NOLOCK) where Code='Sent 1st Gift Card')
	insert into LibertyPower..PromotionStatus(Code,[Description],CreatedBy,CreatedDate) values( 'Sent 1st Gift Card','Sent 1st Gift Card',1982,GETDATE())
if not exists( Select 1 from LibertyPower..PromotionStatus WITH (NOLOCK) where Code='Received 2nd Reward Form')
	insert into LibertyPower..PromotionStatus(Code,[Description],CreatedBy,CreatedDate) values( 'Received 2nd Reward Form','Received 2nd Reward Form',1982,GETDATE())
if not exists( Select 1 from LibertyPower..PromotionStatus WITH (NOLOCK) where Code='Sent 2nd Gift Card')
	insert into LibertyPower..PromotionStatus(Code,[Description],CreatedBy,CreatedDate) values( 'Sent 2nd Gift Card','Sent 2nd Gift Card',1982,GETDATE())
Go

update LibertyPower..PromotionStatus set OrderBy=1 where Code='Pending'
update LibertyPower..PromotionStatus set OrderBy=2 where Code='Ineligible'
update LibertyPower..PromotionStatus set OrderBy=3 where Code='Eligible'
update LibertyPower..PromotionStatus set OrderBy=4 where Code='Sent Reward Form'
update LibertyPower..PromotionStatus set OrderBy=5 where Code='Received 1st Reward Form'
update LibertyPower..PromotionStatus set OrderBy=6 where Code='Sent 1st Gift Card'
update LibertyPower..PromotionStatus set OrderBy=7 where Code='Received 2nd Reward Form'
update LibertyPower..PromotionStatus set OrderBy=8 where Code='Sent 2nd Gift Card'
update LibertyPower..PromotionStatus set OrderBy=9 where Code='VendorSubmitted'
update LibertyPower..PromotionStatus set OrderBy=10 where Code='Shipped'
update LibertyPower..PromotionStatus set OrderBy=11 where Code='Fulfilled'
Go
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_FulfillmentStatusSelect' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_FulfillmentStatusSelect];
GO

/*******************************************************************************

 * PROCEDURE:	[usp_FulfillmentStatusSelect]
 * PURPOSE:	Selects all fulfillment Statuses
 * HISTORY:	 

  * 2/11/2014 - Sara Lakshmanan
  * 9/24/2014 - Pradeep Katiyar
  * select the results based on orderby column.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_FulfillmentStatusSelect] 
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
--SET NO_BROWSETABLE OFF
	Select   PromotionStatusId,
			 ltrim(RTRIM(Code)) as Code,
			 ltrim(RTRIM([Description])) as [Description],
			 CreatedBy,
			 CreatedDate,
			 OrderBy
			 
	from  LibertyPower..PromotionStatus C with (NOLock) order by Orderby	
Set NOCOUNT OFF;
END


