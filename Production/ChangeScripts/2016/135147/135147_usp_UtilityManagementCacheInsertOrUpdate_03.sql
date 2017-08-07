USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UtilityManagementCacheInsertOrUpdate]') AND type in (N'P'))
    DROP PROCEDURE [dbo].[usp_UtilityManagementCacheInsertOrUpdate]
GO

/****** Object:  StoredProcedure [dbo].[usp_UtilityManagementCacheInsertOrUpdate]    Script Date: 08/09/2016 11:52:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_UtilityManagementCacheInsertOrUpdate]
	@UtilityID int,
	@UtilityCode varchar(40),
	@Iso varchar(40) = NULL,
	@Market varchar(40) = NULL,
	@PrimaryDuns varchar(40) = NULL,
	@LpEntityID varchar(40) = NULL,
	@ServiceAccountPattern varchar(510) = NULL,
	@ServiceAccountPatternDescription varchar(max) = NULL,
	@BillingAccountPattern varchar(40) = NULL,
	@BillingAccountPatternDescription varchar(max) = NULL,
	@NameKeyPattern varchar(510) = NULL,
	@NameKeyPatternDescription varchar(max) = NULL,
	@HuRequestMode varchar(40) = NULL,
	@HuRequestModeAddress varchar(max) = NULL,
	@HuRequestModeEmailTemplateName varchar(max) = NULL,
	@HuRequestModeInstruction varchar(max) = NULL,
	@HuRequestModeLetterOfAutorization bit = 0,
	@HiRequestMode varchar(40) = NULL,
	@HiRequestModeAddress varchar(max) = NULL,
	@HiRequestModeEmailTemplateName varchar(max) = NULL,
	@HiRequestModeInstruction varchar(max) = NULL,
	@HiRequestModeLetterOfAutorization bit = 0,
	@IcapRequestMode varchar(40) = NULL,
	@IcapRequestModeAddress varchar(max) = NULL,
	@IcapRequestModeEmailTemplateName varchar(max) = NULL,
	@IcapRequestModeInstruction varchar(max) = NULL,
	@IcapRequestModeLetterOfAutorization bit = 0,
	@DateExpiration datetime,
	@ModifiedBy int = NULL,
	@CreatedBy int = NULL
AS
BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	IF EXISTS (SELECT TOP 1 1 FROM LibertyPower..UtilityManagementCache (NOLOCK) WHERE UtilityID = @UtilityID)
	BEGIN
		UPDATE [LibertyPower].[dbo].[UtilityManagementCache]
		   SET UtilityCode = @UtilityCode
			  ,Iso = @Iso
			  ,Market = @Market
			  ,PrimaryDuns = @PrimaryDuns
			  ,LpEntityID = @LpEntityID
			  ,ServiceAccountPattern = @ServiceAccountPattern
			  ,ServiceAccountPatternDescription = @ServiceAccountPatternDescription
			  ,BillingAccountPattern = @BillingAccountPattern
			  ,BillingAccountPatternDescription = @BillingAccountPatternDescription
			  ,NameKeyPattern = @NameKeyPattern
			  ,NameKeyPatternDescription = @NameKeyPatternDescription
			  ,HuRequestMode = @HuRequestMode
			  ,HuRequestModeAddress = @HuRequestModeAddress
			  ,HuRequestModeEmailTemplateName = @HuRequestModeEmailTemplateName
			  ,HuRequestModeInstruction = @HuRequestModeInstruction
			  ,HuRequestModeLetterOfAutorization = @HuRequestModeLetterOfAutorization
			  ,HiRequestMode = @HiRequestMode
			  ,HiRequestModeAddress = @HiRequestModeAddress
			  ,HiRequestModeEmailTemplateName = @HiRequestModeEmailTemplateName
			  ,HiRequestModeInstruction = @HiRequestModeInstruction
			  ,HiRequestModeLetterOfAutorization = @HiRequestModeLetterOfAutorization
			  ,IcapRequestMode = @IcapRequestMode
			  ,IcapRequestModeAddress = @IcapRequestModeAddress
			  ,IcapRequestModeEmailTemplateName = @IcapRequestModeEmailTemplateName
			  ,IcapRequestModeInstruction = @IcapRequestModeInstruction
			  ,IcapRequestModeLetterOfAutorization = @IcapRequestModeLetterOfAutorization
			  ,DateExpiration = @DateExpiration
			  ,DateModified = GETDATE()
			  ,ModifiedBy = @ModifiedBy
		 WHERE UtilityID = @UtilityID
	END
	ELSE
	BEGIN

		INSERT INTO [LibertyPower].[dbo].[UtilityManagementCache]
           ( 
			 [UtilityID]
			,[UtilityCode]
			,[Iso]
			,[Market]
			,[PrimaryDuns]
			,[LpEntityID]
			,[ServiceAccountPattern]
			,[ServiceAccountPatternDescription]
			,[BillingAccountPattern]
			,[BillingAccountPatternDescription]
			,[NameKeyPattern]
			,[NameKeyPatternDescription]
			,[HuRequestMode]
			,[HuRequestModeAddress]
			,[HuRequestModeEmailTemplateName]
			,[HuRequestModeInstruction]
			,[HuRequestModeLetterOfAutorization]
			,[HiRequestMode]
			,[HiRequestModeAddress]
			,[HiRequestModeEmailTemplateName]
			,[HiRequestModeInstruction]
			,[HiRequestModeLetterOfAutorization]
			,[IcapRequestMode]
			,[IcapRequestModeAddress]
			,[IcapRequestModeEmailTemplateName]
			,[IcapRequestModeInstruction]
			,[IcapRequestModeLetterOfAutorization]
			,[DateExpiration]
			,[DateModified]
			,[ModifiedBy]
			,[DateCreated]
			,[CreatedBy]
           )
     VALUES
           (
		     @UtilityID
            ,@UtilityCode
			,@Iso
			,@Market
			,@PrimaryDuns
			,@LpEntityID
			,@ServiceAccountPattern
			,@ServiceAccountPatternDescription
			,@BillingAccountPattern
			,@BillingAccountPatternDescription
			,@NameKeyPattern
			,@NameKeyPatternDescription
			,@HuRequestMode
			,@HuRequestModeAddress
			,@HuRequestModeEmailTemplateName
			,@HuRequestModeInstruction
			,@HuRequestModeLetterOfAutorization
			,@HiRequestMode
			,@HiRequestModeAddress
			,@HiRequestModeEmailTemplateName
			,@HiRequestModeInstruction
			,@HiRequestModeLetterOfAutorization
			,@IcapRequestMode
			,@IcapRequestModeAddress
			,@IcapRequestModeEmailTemplateName
			,@IcapRequestModeInstruction
			,@IcapRequestModeLetterOfAutorization
			,@DateExpiration
			,GETDATE()
			,@ModifiedBy
			,GETDATE()
			,@CreatedBy
            );
			
	END
	
	EXEC Libertypower..usp_UtilityManagementCacheByUtilityIdSelect @UtilityID

END


GO


