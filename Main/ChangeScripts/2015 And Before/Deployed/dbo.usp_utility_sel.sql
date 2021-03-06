
USE [lp_common]
GO

BEGIN TRANSACTION _STRUCTURE_
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

--exec usp_utility_sel 'SSCOTT', 'AMEREN'   

------------------------------------------------------------------------- 
-- Modified:	Sheri Scott
-- Date:		05/03/2012
-- Description:	Added marketID to the selection. - Ticket 1-11687763
-------------------------------------------------------------------------
  
DROP PROCEDURE [dbo].[usp_utility_sel]
GO  
   
CREATE PROCEDURE [dbo].[usp_utility_sel] (@p_username nchar(100) = null, @p_utility_id char(15))  
AS
SELECT a.utility_id,  
       a.utility_descp,  
       a.duns_number,
       a.retail_mkt_id,  
       a.marketID,  
       a.entity_id,  
       a.enrollment_lead_days,  
       a.billing_type,  
       a.account_length,  
       a.account_number_prefix,  
       a.lead_screen_process,  
       a.deal_screen_process,  
       a.por_option,
	   p.paper_contract_only,  
       a.field_01_label,  
       a.field_01_type,  
       a.field_02_label,  
       a.field_02_type,  
       a.field_03_label,  
       a.field_03_type,  
       a.field_04_label,  
       a.field_04_type,  
       a.field_05_label,  
       a.field_05_type,  
       a.field_06_label,  
       a.field_06_type,  
       a.field_07_label,  
       a.field_07_type,  
       a.field_08_label,  
       a.field_08_type,  
       a.field_09_label,  
       a.field_09_type,  
       a.field_10_label,  
       a.field_10_type,  
       a.field_11_label,  
       a.field_11_type,  
       a.field_12_label,  
       a.field_12_type,  
       a.field_13_label,  
       a.field_13_type,  
       a.field_14_label,  
       a.field_14_type,  
       a.field_15_label,  
       a.field_15_type,  
       a.date_created,  
       a.username,  
       inactive_ind = b.option_id,  
       a.active_date,  
       a.chgstamp,
	   a.phone,
	   c.amount as auxiliary_charge_amount,
	   c.contract_clause as auxiliary_charge_contract_clause,
	   c.inclusion as auxiliary_charge_inclusion
FROM common_utility a WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_utility_idx)
JOIN common_views b WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_views_idx) 
ON b.return_value = a.inactive_ind
JOIN utility_permission p 
ON a.utility_id = p.utility_id
LEFT JOIN auxiliary_charge c 
ON a.utility_id = c.utility_id and c.code = 'MeterCharge'
WHERE (a.utility_id = @p_utility_id and b.process_id = 'INACTIVE IND')

-- Eric Hernandez 
-- This is a workaround to a problem with the utility name "O&R" being cut off.
OR    (
@p_utility_id = 'O' and a.utility_id = 'O&R'
 and b.process_id = 'INACTIVE IND'  
 and b.return_value = a.inactive_ind  
)
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT TRANSACTION _STRUCTURE_
GO

SET NOEXEC OFF
GO
