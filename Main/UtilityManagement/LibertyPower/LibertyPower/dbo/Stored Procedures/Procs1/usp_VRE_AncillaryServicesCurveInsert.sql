
CREATE procedure [dbo].[usp_VRE_AncillaryServicesCurveInsert] ( 	
	 @FileContextGuid								   UNIQUEIDENTIFIER
	,@ZoneId                                           VARCHAR(50)
	,@Month                                            INT
	,@Year                                             INT
	,@Ancillary                                        DECIMAL(18,6)
	,@OtherAncillary                               DECIMAL(18,6)
	,@CreatedBy				                           INT)
AS

BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO VREAncillaryServicesCurve (	
		 FileContextGuid	
		,ZoneId
		,[Month]
		,[Year]
		,Ancillary
		,OtherAncillary
		,CreatedBy)
	VALUES (		
		 @FileContextGuid
		,@ZoneId
		,@Month
		,@Year
		,@Ancillary
		,@OtherAncillary
		,@CreatedBy)
	
	SELECT SCOPE_IDENTITY();
	
	SET NOCOUNT OFF;
	
END

-- Copywrite LibertyPower 01/27/2010


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_AncillaryServicesCurveInsert';

