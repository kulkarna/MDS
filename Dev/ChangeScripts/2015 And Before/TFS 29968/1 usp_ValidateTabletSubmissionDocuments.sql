USE [LibertyPower]
GO

IF  EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID(N'[dbo].[usp_ValidateTabletSubmissionDocuments]'))
	DROP PROCEDURE [dbo].[usp_ValidateTabletSubmissionDocuments]
GO

-- =============================================
-- Author:		Isabelle Tamanini
-- Create date: 03/26/2014
-- Description:	Verifies if all the documents sent from the tablet were received on Liberty Power side
-- =============================================

CREATE PROCEDURE [dbo].[usp_ValidateTabletSubmissionDocuments] 
	@ContractNumber varchar(50),
	@MissingDocuments bit = 0 output,
	@MissingDocumentsMessage varchar(250) = '' output
AS
BEGIN
	SET NOCOUNT ON
	
	SET @MissingDocuments = 0
	SET @MissingDocumentsMessage = ''

	--Logic involving @p_IsThirdGenTabletContract can be removed after the
	--Third Generation Liberty Power Pad is deployed to prod
	DECLARE @p_IsThirdGenTabletContract BIT
	
	SELECT @p_IsThirdGenTabletContract = (CASE 
										  WHEN at.ClientApplicationTypeId IS NOT NULL 
										   AND at.ClientApplicationTypeId = 5 THEN 1
										  ELSE 0 END)
	FROM LibertyPower..Contract c (NOLOCK)
	LEFT JOIN LibertyPower..ClientSubmitApplicationKey csak (NOLOCK) ON c.ClientSubmitApplicationKeyId = csak.ClientSubApplicationKeyId
																	AND csak.Active = 1
	LEFT JOIN LibertyPower..ClientApplicationType at        (NOLOCK) ON csak.ClientApplicationTypeId = at.ClientApplicationTypeId
	WHERE C.Number = @ContractNumber 
	
	IF(@p_IsThirdGenTabletContract = 1)
	BEGIN
		DECLARE @FileName VARCHAR(250)
		DECLARE @DocumentTypeID INT
		
		DECLARE tabletSubmissionDocumentsCursor CURSOR FORWARD_ONLY READ_ONLY  FOR 
		SELECT [FileName], DocumentTypeID
		FROM LibertyPower..TabletDocumentSubmission (NOLOCK)
		WHERE ContractNumber = @ContractNumber 
		
		OPEN tabletSubmissionDocumentsCursor
		FETCH NEXT FROM tabletSubmissionDocumentsCursor INTO @FileName, @DocumentTypeID

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF NOT EXISTS(SELECT 1
						  FROM lp_documents..document_history dh (NOLOCK)
						  WHERE dh.contract_nbr = @ContractNumber
							AND dh.document_name = CASE WHEN @FileName like dh.document_guid+'%' THEN @FileName
												   ELSE dh.document_guid + '_' + @FileName
												   END
							AND dh.document_type_id = @DocumentTypeID)
			BEGIN
				SET @MissingDocuments = 1
				SET @MissingDocumentsMessage = 'Missing document '+@FileName+' for contract '+@ContractNumber
			END

			
			FETCH NEXT FROM tabletSubmissionDocumentsCursor INTO @FileName, @DocumentTypeID
		END

		CLOSE tabletSubmissionDocumentsCursor
		DEALLOCATE tabletSubmissionDocumentsCursor
	
	END

	SET NOCOUNT OFF
END