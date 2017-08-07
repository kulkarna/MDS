/********************************************************************************
* usp_UtilityInsert
* Procedure to insert rows in the Utility

* History
********************************************************************************
* 02/24/2010  - SW / IVIA
* Created.

* 04/07/2010  - Jose  Munoz
* Modify:	Ticket 14817
			Add field SSNIsRequired into utility table 	

* 05/03/2012  - Sheri Scott
* Modify:	Removed all references to Field01 through Field15

* 4/30/2013  - Gail Mangaroo
* Modify:	Added Locations and Profile Reference fields
********************************************************************************/

--DROP PROCEDURE [dbo].[usp_UtilityInsert]
--GO

CREATE procedure [dbo].[usp_UtilityInsert] ( 	
	@UtilityCode                                      varchar(50)
	,@FullName                                         varchar(100)
	,@ShortName                                        varchar(50)=''
	,@MarketID                                         Integer
	,@DunsNumber                                       varchar(30)	
	,@EntityId                                         varchar(15)
	,@EnrollmentLeadDays                               Integer
	,@BillingType                                      varchar(15)
	,@AccountLength                                    Integer
	,@AccountNumberPrefix                              varchar(10)
	,@LeadScreenProcess                                varchar(15)
	,@DealScreenProcess                                varchar(15)
	,@PorOption                                        varchar(3)='NO'
	--,@Field01Label                                     varchar(20)
	--,@Field01Type                                      varchar(30)
	--,@Field02Label                                     varchar(20)
	--,@Field02Type                                      varchar(30)
	--,@Field03Label                                     varchar(20)
	--,@Field03Type                                      varchar(30)
	--,@Field04Label                                     varchar(20)
	--,@Field04Type                                      varchar(30)
	--,@Field05Label                                     varchar(20)
	--,@Field05Type                                      varchar(30)
	--,@Field06Label                                     varchar(20)
	--,@Field06Type                                      varchar(30)
	--,@Field07Label                                     varchar(20)
	--,@Field07Type                                      varchar(30)
	--,@Field08Label                                     varchar(20)
	--,@Field08Type                                      varchar(30)
	--,@Field09Label                                     varchar(20)
	--,@Field09Type                                      varchar(30)
	--,@Field10Label                                     varchar(20)
	--,@Field10Type                                      varchar(30)
	,@DateCreated                                      DateTime = ''
	,@UserName                                         nchar(400)
	,@InactiveInd                                      char(1) = '0'
	,@ActiveDate                                       DateTime = ''
	,@ChgStamp                                         smallint = 0
	,@MeterNumberRequired                              smallint = 0
	,@MeterNumberLength                                smallint = 0
	,@AnnualUsageMin                                   Integer = 0
	,@Qualifier                                        varchar(50) = ''
	,@EdiCapable                                       smallint = 0
	,@WholeSaleMktID                                   varchar(50) = ''
	,@Phone                                            varchar(30)
	,@RateCodeRequired                                 tinyint = 0
	,@HasZones                                         tinyint = 0
	,@ZoneDefault                                      Integer = 0
	--,@Field11Label                                     varchar(20)='NONE' 
	--,@Field11Type                                      varchar(30)='NONE'
	--,@Field12Label                                     varchar(20)='NONE'
	--,@Field12Type                                      varchar(30)='NONE'
	--,@Field13Label                                     varchar(20)='NONE'
	--,@Field13Type                                      varchar(30)='NONE'
	--,@Field14Label                                     varchar(20)='NONE'
	--,@Field14Type                                      varchar(30)='NONE'
	--,@Field15Label                                     varchar(20)='NONE'
	--,@Field15Type                                      varchar(30)='NONE'
	,@RateCodeFormat                                   varchar(20) = 0
	,@RateCodeFields                                   varchar(50) = 0
	,@Error							                   char(01) = ' '
	,@MsgId											   char(08) = ' '
	,@Descp										       varchar(250) = ' '
	,@ResultInd										   char(01) = 'Y'
	,@PaperContractOnly							       int
	,@SSNIsRequired										bit = 1 -- ticket 14817
	,@DeliveryLocationRefID								int = null
	,@SettlementLocationRefID							int = null
	,@DefaultProfileRefID								int = null
	)
as

Begin
	set nocount on;

	SELECT @FullName                             = upper(@FullName)
	 
	declare @w_error                                    CHAR(01)
	declare @w_msg_id                                   CHAR(08)
	declare @w_descp                                    VARCHAR(250)
	declare @w_return                                   int
	 
	SELECT @w_error                                     = 'I'
	SELECT @w_msg_id                                    = '00000001'
	SELECT @w_descp                                     = ' '
	SELECT @w_return                                    = 0

	--SET @Field01Type = CASE WHEN @Field01Label = ' ' THEN 'NONE' ELSE @Field01Type END
	--SET @Field02Type = CASE WHEN @Field02Label = ' ' THEN 'NONE' ELSE @Field02Type END
	--SET @Field03Type = CASE WHEN @Field03Label = ' ' THEN 'NONE' ELSE @Field03Type END
	--SET @Field04Type = CASE WHEN @Field04Label = ' ' THEN 'NONE' ELSE @Field04Type END
	--SET @Field05Type = CASE WHEN @Field05Label = ' ' THEN 'NONE' ELSE @Field05Type END
	--SET @Field06Type = CASE WHEN @Field06Label = ' ' THEN 'NONE' ELSE @Field06Type END
	--SET @Field07Type = CASE WHEN @Field07Label = ' ' THEN 'NONE' ELSE @Field07Type END
	--SET @Field08Type = CASE WHEN @Field08Label = ' ' THEN 'NONE' ELSE @Field08Type END
	--SET @Field09Type = CASE WHEN @Field09Label = ' ' THEN 'NONE' ELSE @Field09Type END
	--SET @Field10Type = CASE WHEN @Field10Label = ' ' THEN 'NONE' ELSE @Field10Type END
	--SET @Field11Type = CASE WHEN @Field11Label = ' ' THEN 'NONE' ELSE @Field11Type END
	--SET @Field12Type = CASE WHEN @Field12Label = ' ' THEN 'NONE' ELSE @Field12Type END
	--SET @Field13Type = CASE WHEN @Field13Label = ' ' THEN 'NONE' ELSE @Field13Type END
	--SET @Field14Type = CASE WHEN @Field14Label = ' ' THEN 'NONE' ELSE @Field14Type END
	--SET @Field15Type = CASE WHEN @Field15Label = ' ' THEN 'NONE' ELSE @Field15Type END

	
	insert into Utility (
		UtilityCode
		,FullName
		,ShortName
		,MarketID
		,DunsNumber		
		,EntityId
		,EnrollmentLeadDays
		,BillingType
		,AccountLength
		,AccountNumberPrefix
		,LeadScreenProcess
		,DealScreenProcess
		,PorOption
		--,Field01Label
		--,Field01Type
		--,Field02Label
		--,Field02Type
		--,Field03Label
		--,Field03Type
		--,Field04Label
		--,Field04Type
		--,Field05Label
		--,Field05Type
		--,Field06Label
		--,Field06Type
		--,Field07Label
		--,Field07Type
		--,Field08Label
		--,Field08Type
		--,Field09Label
		--,Field09Type
		--,Field10Label
		--,Field10Type
		,DateCreated
		,UserName
		,InactiveInd
		,ActiveDate
		,ChgStamp
		,MeterNumberRequired
		,MeterNumberLength
		,AnnualUsageMin
		,Qualifier
		,EdiCapable
		,WholeSaleMktID
		,Phone
		,RateCodeRequired
		,HasZones
		,ZoneDefault
		--,Field11Label
		--,Field11Type
		--,Field12Label
		--,Field12Type
		--,Field13Label
		--,Field13Type
		--,Field14Label
		--,Field14Type
		--,Field15Label
		--,Field15Type
		,RateCodeFormat
		,RateCodeFields
		,LegacyName
		,SSNIsRequired --Ticket 14817
		,DeliveryLocationRefID		
		,SettlementLocationRefID	
		,DefaultProfileRefID
	
		)
	values 
		(@UtilityCode
		,@FullName
		,@ShortName
		,@MarketID
		,@DunsNumber		
		,@EntityId
		,@EnrollmentLeadDays
		,@BillingType
		,@AccountLength
		,@AccountNumberPrefix
		,@LeadScreenProcess
		,@DealScreenProcess
		,@PorOption
		--,@Field01Label
		--,@Field01Type
		--,@Field02Label
		--,@Field02Type
		--,@Field03Label
		--,@Field03Type
		--,@Field04Label
		--,@Field04Type
		--,@Field05Label
		--,@Field05Type
		--,@Field06Label
		--,@Field06Type
		--,@Field07Label
		--,@Field07Type
		--,@Field08Label
		--,@Field08Type
		--,@Field09Label
		--,@Field09Type
		--,@Field10Label
		--,@Field10Type
		,getdate()
		,@UserName
		,@InactiveInd
		,getdate()
		,@ChgStamp
		,@MeterNumberRequired
		,@MeterNumberLength
		,@AnnualUsageMin
		,@Qualifier
		,@EdiCapable
		,@WholeSaleMktID
		,@Phone
		,@RateCodeRequired
		,@HasZones
		,@ZoneDefault
		--,@Field11Label
		--,@Field11Type
		--,@Field12Label
		--,@Field12Type
		--,@Field13Label
		--,@Field13Type
		--,@Field14Label
		--,@Field14Type
		--,@Field15Label
		--,@Field15Type
		,@RateCodeFormat
		,@RateCodeFields
		,@FullName
		,@SSNIsRequired --Ticket 14817
		,@DeliveryLocationRefID
		,@SettlementLocationRefID	
		,@DefaultProfileRefID	
		)
	
	--select SCOPE_IDENTITY()
	
	IF @@error <> 0 or @@rowcount = 0
    SELECT @w_error = 'E', @w_msg_id = '00000002', @w_return = 1
 
	IF @w_error <> 'N'
	   EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp OUTPUT

	INSERT INTO	UtilityPermission
			(UtilityCode, RetailMktId, PaperContractOnly)
	VALUES	(@UtilityCode, @MarketID, @PaperContractOnly)

	 
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

-- Copywrite LibertyPower 02/24/2010
