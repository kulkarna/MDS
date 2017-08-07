-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	SReturns a specific complaint
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintSelect] 
	@ComplaintID int
AS

BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT	c.ComplaintID,
			c.AccountID,
			c.ComplaintAccountID,
			c.ComplaintRegulatoryAuthorityID,
			cra.RequiredDaysForResolution,
			c.ComplaintStatusID,
			c.ComplaintIssueTypeID,
			c.ComplaintantName,
			c.OpenDate,
			c.DueDate,
			c.AcknowledgeDate,
			c.ClosedDate,
			c.LastContactDate,
			c.CasePrimeID,
			c.ControlNumber,
			ct.ComplaintCategoryID,
			ct.ComplaintTypeID,
			c.IsFormal,
			c.PrimaryDescription,
			c.SecondaryDescription,
			c.InboundCalls,
			c.TeamContactedID,
			c.ContractReviewDate,
			c.SalesMgrNotified,
			c.ValidContract,
			c.DisputeOutcomeID,
			c.Waiver,
			c.Credit,
			c.ResolutionDescription,
			c.InternalFindings,
			c.Comments,
			c.CreationDate,
			c.CreatedBy,
			c.LastModifiedDate,
			c.LastModifiedBy
	FROM	Complaint c
			LEFT JOIN ComplaintRegulatoryAuthority cra ON c.ComplaintRegulatoryAuthorityID = cra.ComplaintRegulatoryAuthorityID 
			INNER JOIN ComplaintType ct ON c.ComplaintTypeID = ct.ComplaintTypeID
	WHERE	c.ComplaintID = @ComplaintID


END
