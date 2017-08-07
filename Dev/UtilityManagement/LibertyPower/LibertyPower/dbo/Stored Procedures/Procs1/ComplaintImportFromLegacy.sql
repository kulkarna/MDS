-- =============================================
-- Author:		Carlos Lima
-- Create date: 2012-11-27
-- Description:	Creates a new complaint and assigns it the legacy id
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintImportFromLegacy] 
	@ComplaintID int,
	@LegacyID int = NULL,
    @AccountID int = NULL,
    @ComplaintAccountID int = NULL,
    @RegulatoryAuthorityID int,
    @StatusID int,
    @IssueTypeID int,
    @ComplaintantName varchar(200) = NULL,
    @OpenDate datetime = NULL,
    @DueDate datetime = NULL,
    @AcknowledgeDate datetime = NULL,
    @ClosedDate datetime = NULL,
    @LastContactDate datetime = NULL,
    @CasePrimeID int,
    @ControlNumber varchar(50) = NULL,
    @ComplaintTypeID int,
    @IsFormal bit = 0,
    @InboundCalls int = NULL,
    @TeamContactedID int,
    @ContractReviewDate datetime = NULL,
    @SalesMgrNotified datetime = NULL,
    @ValidContract bit = 0,
    @DisputeOutcomeID int,
    @Waiver money = NULL,
    @Credit money = NULL,
    @PrimaryDescription varchar(MAX) = NULL,
    @SecondaryDescription varchar(MAX) = NULL,
    @ResolutionDescription varchar(MAX) = NULL,
    @InternalFindings varchar(MAX) = NULL,
    @Comments varchar(MAX) = NULL,
    @CreatedBy  varchar(200) = NULL,
    @LastModifiedBy varchar(200) = NULL
AS

BEGIN
	SET NOCOUNT ON
	SET IDENTITY_INSERT [dbo].[Complaint] ON
    
	INSERT INTO Complaint(ComplaintID,
						ComplaintLegacyID,
						AccountID,
						ComplaintAccountID,
						ComplaintRegulatoryAuthorityID,
						ComplaintStatusID,
						ComplaintIssueTypeID,
						ComplaintantName,
						OpenDate,
						DueDate,
						AcknowledgeDate,
						ClosedDate,
						LastContactDate,
						CasePrimeID,
						ControlNumber,
						ComplaintTypeID,
						IsFormal,
						PrimaryDescription,
						SecondaryDescription,
						InboundCalls,
						TeamContactedID,
						ContractReviewDate,
						SalesMgrNotified,
						ValidContract,
						DisputeOutcomeID,
						Waiver,
						Credit,
						ResolutionDescription,
						InternalFindings,
						Comments,
						CreationDate,
						CreatedBy,
						LastModifiedDate,
						LastModifiedBy)
	VALUES (
						@ComplaintID,
						@LegacyID,
						@AccountID,
						@ComplaintAccountID,
						@RegulatoryAuthorityID,
						@StatusID,
						@IssueTypeID,
						@ComplaintantName,
						@OpenDate,
						@DueDate,
						@AcknowledgeDate,
						@ClosedDate,
						@LastContactDate,
						@CasePrimeID,
						@ControlNumber,
						@ComplaintTypeID,
						@IsFormal,
						@PrimaryDescription,
						@SecondaryDescription,
						@InboundCalls,
						@TeamContactedID,
						@ContractReviewDate,
						@SalesMgrNotified,
						@ValidContract,
						@DisputeOutcomeID,
						@Waiver,
						@Credit,
						@ResolutionDescription,
						@InternalFindings,
						@Comments,
						GETDATE(),
						@CreatedBy,
						GETDATE(),
						@LastModifiedBy
			)
		
		SET IDENTITY_INSERT [dbo].[Complaint] OFF
		
		SELECT @ComplaintID as ComplaintID
END
/****** Object:  StoredProcedure [dbo].[ComplaintCreateOrUpdate]    Script Date: 11/28/2012 10:08:28 ******/
SET ANSI_NULLS ON
