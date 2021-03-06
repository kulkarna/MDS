USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueInsertAll]    Script Date: 01/10/2014 14:29:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueInsertAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueInsertAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueInsertAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_FieldValueInsertAll
 * Inserts determinant history one SQL trip at a time  ;-)
 *
 * History
 *
 *******************************************************************************
 * 01/03/2014 - Eduardo Patiño
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueInsertAll]
	@UtilityID varchar(80),
	@AccountNumber varchar(50),
	@EffectiveDate datetime,
	@ZoneCode varchar(60),
	@RateClass varchar(60),
	@LoadProfile varchar(60),
	@Voltage varchar(60),
	@MeterType varchar(60),
	@FieldSource varchar(60),
	@UserIdentity varchar(200),
	@LockStatus varchar(30)
AS

	SET NOCOUNT ON

--	INSERT  INTO AccountPropertyHistory (UtilityID, AccountNumber, FieldName, FieldValue, FieldSource, CreatedBy, LockStatus, Active, EffectiveDate)
--	VALUES  (@UtilityID, @AccountNumber, ''Utility'', @UtilityID, @FieldSource, @UserIdentity, @LockStatus, 1, @EffectiveDate ) 
	exec [usp_Determinants_FieldValueInsert] @UtilityID, @AccountNumber, ''Utility'', @UtilityID, @EffectiveDate, @FieldSource, @UserIdentity, @LockStatus

	IF @ZoneCode <> ''''
		exec [usp_Determinants_FieldValueInsert] @UtilityID, @AccountNumber, ''LBMPZone'', @ZoneCode, @EffectiveDate, @FieldSource, @UserIdentity, @LockStatus

	IF @RateClass <> ''''
		exec [usp_Determinants_FieldValueInsert] @UtilityID, @AccountNumber, ''RateClass'', @RateClass, @EffectiveDate, @FieldSource, @UserIdentity, @LockStatus

	IF @LoadProfile <> ''''
		exec [usp_Determinants_FieldValueInsert] @UtilityID, @AccountNumber, ''LoadProfile'', @LoadProfile, @EffectiveDate, @FieldSource, @UserIdentity, @LockStatus

	IF @Voltage <> ''''
		exec [usp_Determinants_FieldValueInsert] @UtilityID, @AccountNumber, ''Voltage'', @Voltage, @EffectiveDate, @FieldSource, @UserIdentity, @LockStatus

	IF @MeterType <> ''''
		exec [usp_Determinants_FieldValueInsert] @UtilityID, @AccountNumber, ''MeterType'', @MeterType, @EffectiveDate, @FieldSource, @UserIdentity, @LockStatus

	SET NOCOUNT OFF
' 
END
GO
