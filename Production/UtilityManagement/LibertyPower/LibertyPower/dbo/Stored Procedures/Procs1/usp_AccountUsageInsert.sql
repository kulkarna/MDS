
/*
*
* PROCEDURE:	usp_AccountUsageInsert
*
* DEFINITION:  Inserts a record into AccountUsage
*
* RETURN CODE: 
*
* REVISIONS:	6/9/2011 11:58:55 AM	Jaime Forero
				8/29/2011 Jaime Forero Added modified by
*/


CREATE PROCEDURE [dbo].[usp_AccountUsageInsert]
	@AccountID INT,
	@AnnualUsage INT = NULL,
	@UsageReqStatusID INT,
	@EffectiveDate DATETIME = NULL,
	@ModifiedBy INT,
	@CreatedBy INT,
	@IsSilent BIT = 0
AS
BEGIN
-- local variables
DECLARE @AccountUsageID  INT;

-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

INSERT INTO [dbo].[AccountUsage]
(
	[AccountID],
	[AnnualUsage],
	[UsageReqStatusID],
	[EffectiveDate],
	[Modified],
	[ModifiedBy],
	[DateCreated],
	[CreatedBy]
)
VALUES
(
	@AccountID,
	@AnnualUsage,
	@UsageReqStatusID,
	@EffectiveDate,
	GETDATE(),
	@ModifiedBy,
	GETDATE(),
	@CreatedBy
)
SET @AccountUsageID = SCOPE_IDENTITY();
IF @IsSilent = 0
	EXEC Libertypower.dbo.usp_AccountUsageSelect @AccountUsageID;

RETURN @AccountUsageID;

END
