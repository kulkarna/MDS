
CREATE procedure [dbo].[usp_VRE_ISOZoneInsert] ( 	
	 @UtilityCode										varchar(50)
	,@Zone												varchar(50)
	,@ISOZone											varchar(50)
	,@ResultInd											char(1) = 'Y'
	,@Error												char(1) = ' '
	,@Descp												varchar(250) = ' '
	,@MsgId												char(8) = ' '	
	,@CreatedBy											int
	)
as

Begin
	set nocount on;

	declare @w_error                                    CHAR(01)
	declare @w_msg_id                                   CHAR(08)
	declare @w_descp                                    VARCHAR(250)
	declare @w_return                                   int
	 
	SELECT @w_error                                     = 'I'
	SELECT @w_msg_id                                    = '00000001'
	SELECT @w_descp                                     = ' '
	SELECT @w_return                                    = 0

	insert into VREISOZone (
		UtilityCode,
		Zone,
		ISOZone,		
		CreatedBy
		)
	values 
		(
		@UtilityCode					
		,@Zone					
		,@ISOZone		
		,@CreatedBy
		)
	
	--select SCOPE_IDENTITY()
	SELECT @@IDENTITY
	
	IF @@error <> 0 or @@rowcount = 0
    SELECT @w_error = 'E', @w_msg_id = '00000002', @w_return = 1
 
	IF @w_error <> 'N'
	   EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp OUTPUT

	 
	IF @ResultInd = 'Y'
	begin
	   SELECT flag_error = @w_error, code_error = @w_msg_id, message_error = @w_descp
	   GOTO goto_return
	END
	 
	SELECT @Error = @w_error, @MsgId = @w_msg_id, @Descp = @w_descp
	 
	goto_return:
	return @w_return
		
	set nocount off;
	
End





GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ISOZoneInsert';

