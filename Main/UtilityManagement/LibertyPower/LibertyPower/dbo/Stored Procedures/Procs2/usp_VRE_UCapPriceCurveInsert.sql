
CREATE procedure [dbo].[usp_VRE_UCapPriceCurveInsert] ( 
	@FileContextGuid							UNIQUEIDENTIFIER
	,@ZoneId                                           varchar(50)
	,@Month                                            INT
	,@Year                                             INT
	,@UCapPrice                                        DECIMAL(18,6)
	,@CreatedBy                             INT)
as

Begin
	set nocount on;
	
	insert into VREUCapPriceCurve (
		FileContextGuid
		,ZoneId
		,[Month]
		,[Year]
		,UCapPrice
		,CreatedBy)
	values 
		(
		@FileContextGuid
		,@ZoneId
		,@Month
		,@Year
		,@UCapPrice
		,@CreatedBy)
	
	SELECT @@IDENTITY
	
	set nocount off;
	
End

-- Copywrite LibertyPower 01/27/2010

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_UCapPriceCurveInsert';

