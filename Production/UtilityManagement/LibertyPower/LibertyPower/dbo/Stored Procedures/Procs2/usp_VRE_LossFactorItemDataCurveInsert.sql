

CREATE procedure [dbo].[usp_VRE_LossFactorItemDataCurveInsert] ( 
	@FileContextGuid									    UNIQUEIDENTIFIER
	,@LossFactorId                                      VARCHAR(50)
	,@Month												INT
	,@Year												INT
	,@LossFactor										DECIMAL(18,6)
	,@CreatedBy											INT)
as

Begin
	set nocount on;
	
	insert into VRELossFactorItemDataCurve (
		 FileContextGuid
		,LossFactorId
		,[Month]
		,[Year]
		,LossFactor
		,CreatedBy)
	values 
		(
		 @FileContextGuid
		,@LossFactorId
		,@Month
		,@Year
		,@LossFactor
		,@CreatedBy);
	
	select SCOPE_IDENTITY();
	
	set nocount off;
	
End

-- Copywrite LibertyPower 01/27/2010


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_LossFactorItemDataCurveInsert';

