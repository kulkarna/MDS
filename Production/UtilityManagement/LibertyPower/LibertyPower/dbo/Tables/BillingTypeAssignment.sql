CREATE TABLE [dbo].[BillingTypeAssignment] (
    [ID]                NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [RateCode]          VARCHAR (50)  NULL,
    [UtilityID]         INT           NOT NULL,
    [TariffDescription] VARCHAR (200) NOT NULL,
    [AccountType]       VARCHAR (35)  NOT NULL,
    [POROption]         VARCHAR (50)  NOT NULL,
    [BillingType]       INT           NULL,
    [DateAdd]           DATETIME      NOT NULL,
    [UserAdd]           VARCHAR (200) NOT NULL,
    [DateModified]      DATETIME      NOT NULL,
    [UserModified]      VARCHAR (200) NOT NULL,
    CONSTRAINT [PK_BillingTypeAssignment] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NDX_BillingTypeAssignmentRateCodeUtilityID]
    ON [dbo].[BillingTypeAssignment]([RateCode] ASC, [UtilityID] ASC);


GO
-- =============================================
-- Author:		SWCS - Jose Munoz
-- Create date: 05/20/2011
-- Description:	
-- =============================================
CREATE TRIGGER dbo.BillingTypeAssignmentUpdate
   ON  dbo.BillingTypeAssignment
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @UserModified	VARCHAR(200)
		,@DateModified		DATETIME

	SELECT @UserModified	= SUSER_SNAME()
		,@DateModified		= GETDATE()
	
    UPDATE BillingTypeAssignment
    SET UserModified		= @UserModified
		,DateModified		= @DateModified
	FROM BillingTypeAssignment B
	INNER JOIN INSERTED I
	ON B.ID			= I.ID
	WHERE B.UserModified	= '' OR B.DateModified = '19000101'
	
	SET NOCOUNT OFF;
END
