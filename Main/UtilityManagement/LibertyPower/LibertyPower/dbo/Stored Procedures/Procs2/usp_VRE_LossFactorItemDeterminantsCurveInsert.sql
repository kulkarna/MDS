

CREATE procedure [dbo].[usp_VRE_LossFactorItemDeterminantsCurveInsert] ( 
	 @FileContextGuid								 UNIQUEIDENTIFIER
	,@UtilityCode                                    VARCHAR(50)
	,@ServiceClass                                   VARCHAR(50)
	,@ZoneID                                VARCHAR(50)
	,@Voltage                                        VARCHAR(50)
	,@LossFactorId                                   VARCHAR(50)
	,@CreatedBy										 INT)
as

Begin
	set nocount on;
	
	insert into VRELossFactorItemDeterminantsCurve (
		 FileContextGuid
		,UtilityCode
		,ServiceClass
		,ZoneID
		,Voltage
		,LossFactorId
		,CreatedBy)
	values 
		(
		 @FileContextGuid
		,@UtilityCode
		,@ServiceClass
		,@ZoneID
		,@Voltage
		,@LossFactorId
		,@CreatedBy)
	
	select SCOPE_IDENTITY();
	
	set nocount off;
	
End

-- Copywrite LibertyPower 01/27/2010

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_LossFactorItemDeterminantsCurveInsert';

