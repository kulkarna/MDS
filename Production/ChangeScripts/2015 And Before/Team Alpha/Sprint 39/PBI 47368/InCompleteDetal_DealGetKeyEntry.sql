USE [Lp_deal_capture]
GO

---------------------------------------------------------------------------------------------------
-- Added		: Fernando ML Alves
-- PBI                  : 47368
-- Date			: 08/15/2014
-- Description	        : Inserts the Incomplete Contracts entry in the deal_get_key table if 
--                      : doesn't exists.
-- Format:		: -
---------------------------------------------------------------------------------------------------

if not  exists (Select * from Lp_deal_capture..deal_get_key D (NoLock) where process_id='INCOMPLETECONTRACTS')
begin
Insert into Lp_deal_capture..deal_get_key (Process_id,Start_date,last_number) Values ('INCOMPLETECONTRACTS','8/28/2014',0)
end
GO
