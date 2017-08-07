﻿-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Creates a new complaint or updates an existing one
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintCreateOrUpdate] 
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

    IF (@ComplaintID > 0)
		UPDATE Complaint SET
			AccountID = @AccountID,
			ComplaintAccountID = @ComplaintAccountID,
			ComplaintRegulatoryAuthorityID = @RegulatoryAuthorityID,
			ComplaintStatusID = @StatusID,
			ComplaintIssueTypeID = @IssueTypeID,
			ComplaintantName = @ComplaintantName,
			OpenDate = @OpenDate,
			DueDate = @DueDate,
			AcknowledgeDate = @AcknowledgeDate,
			ClosedDate = @ClosedDate,
			LastContactDate = @LastContactDate,
			CasePrimeID = @CasePrimeID,
			ControlNumber = @ControlNumber,
			ComplaintTypeID = @ComplaintTypeID,
			IsFormal = @IsFormal,
			PrimaryDescription = @PrimaryDescription,
			SecondaryDescription = @SecondaryDescription,
			InboundCalls = @InboundCalls,
			TeamContactedID = @TeamContactedID,
			ContractReviewDate = @ContractReviewDate,
			SalesMgrNotified = @SalesMgrNotified,
			ValidContract = @ValidContract,
			DisputeOutcomeID = @DisputeOutcomeID,
			Waiver = @Waiver,
			Credit = @Credit,
			ResolutionDescription = @ResolutionDescription,
			InternalFindings = @InternalFindings,
			Comments = @Comments,
			LastModifiedDate = GETDATE(),
			LastModifiedBy = @LastModifiedBy
		WHERE ComplaintID = @ComplaintID
    ELSE
		BEGIN
			INSERT INTO Complaint(
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
					
			SET @ComplaintID = SCOPE_IDENTITY()
		END
		
		SELECT @ComplaintID as ComplaintID
END
