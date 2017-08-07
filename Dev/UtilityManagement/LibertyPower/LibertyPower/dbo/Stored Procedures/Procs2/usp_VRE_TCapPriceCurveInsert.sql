
CREATE procedure [dbo].[usp_VRE_TCapPriceCurveInsert] ( 	
	 @FileContextGuid								   UNIQUEIDENTIFIER 
	,@ZoneId                                           VARCHAR(50)
	,@Month                                            INT
	,@Year                                             INT
	,@TCapPrice                                        DECIMAL(18,6)
	,@CreatedBy				                           INT)
AS

Begin
	SET NOCOUNT ON;
	
	insert into VRETCapPriceCurve (	
		FileContextGuid		
		,ZoneId
		,[Month]
		,[Year]
		,TCapPrice
		,CreatedBy)
	values (
		@FileContextGuid
		,@ZoneId
		,@Month
		,@Year
		,@TCapPrice
		,@CreatedBy)
	
	select SCOPE_IDENTITY();
	
	set nocount off;
	
End

-- Copywrite LibertyPower 01/27/2010


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_TCapPriceCurveInsert';

