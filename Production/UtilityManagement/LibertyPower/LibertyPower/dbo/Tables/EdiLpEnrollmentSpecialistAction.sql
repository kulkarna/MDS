CREATE TABLE [dbo].[EdiLpEnrollmentSpecialistAction] (
    [EdiLpEnrollmentSpecialistActionID] NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [Description]                       NVARCHAR (500) NOT NULL,
    [DateCreated]                       DATETIME       NOT NULL,
    [UserCreated]                       NVARCHAR (100) NOT NULL,
    [DateModified]                      DATETIME       NOT NULL,
    [UserModified]                      NVARCHAR (100) NOT NULL,
    [InactiveInd]                       BIT            NOT NULL,
    CONSTRAINT [PK_EdiLpEnrollmentSpecialistActionID] PRIMARY KEY CLUSTERED ([EdiLpEnrollmentSpecialistActionID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NDX_Description]
    ON [dbo].[EdiLpEnrollmentSpecialistAction]([Description] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'EDI', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EdiLpEnrollmentSpecialistAction';

