
/********************************************************************************
* usp_VRE_MeterReadOverlapUpdate
* Procedure to update rows in the VRECostComponents table.

* History
********************************************************************************
* 06/16/2010  - SWCS / David Maia
* Created.

********************************************************************************/

CREATE procedure [dbo].[usp_VRE_MeterReadOverlapUpdate] ( 	
	@UtilityCode										varchar(50)
	,@MeterReadOverlap									bit = 0
	,@Error												char(01) = ' '
	,@MsgId												char(08) = ' '
	,@Descp												varchar(250) = ' '
	,@ResultInd											char(01) = 'Y'		
	
	)
as

set nocount on 

 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
 
select @w_error = 'I', @w_msg_id = '00000001', @w_descp = ' ', @w_return = 0
 
declare @w_new_chgstamp smallint
 

update VRECostComponents set
	MeterReadOverlap                                 = @MeterReadOverlap
where UtilityCode                                    = @UtilityCode

if @@error <> 0 or @@rowcount = 0
begin
   if exists(select * 
             from lp_common..common_utility
             where utility_id = @UtilityCode)
      select @w_error = 'E', @w_msg_id= '00000003', @w_return = 1
   else
      select @w_error = 'E', @w_msg_id = '00000004', @w_return = 1
end

if @w_error <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id, @w_descp output
end
 
if @ResultInd = 'Y'
begin
   select flag_error = @w_error, code_error = @w_msg_id, message_error = @w_descp
   goto goto_return
end
 
select @Error = @w_error, @MsgId = @w_msg_id, @Descp = @w_descp
 
goto_return:
return @w_return


set nocount off



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_MeterReadOverlapUpdate';

