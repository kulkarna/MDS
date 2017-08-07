CREATE TABLE [dbo].[AccountInfoField] (
    [Id]                    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [NameUserFriendly]      NVARCHAR (255)   NOT NULL,
    [NameMachineUnfriendly] NVARCHAR (255)   NOT NULL,
    [Description]           NVARCHAR (255)   NOT NULL,
    [Inactive]              BIT              NOT NULL,
    [CreatedBy]             NVARCHAR (100)   NOT NULL,
    [CreatedDate]           DATETIME         NOT NULL,
    [LastModifiedBy]        NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]      DATETIME         NOT NULL,
    CONSTRAINT [PK_AccountInfoField] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

CREATE TRIGGER [dbo].[zAuditAccountInfoFieldInsert]
	ON  [dbo].[AccountInfoField]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @ChangeTrackingCurrentVersion BIGINT
			,@ChangeTrackingCreationVersion BIGINT
			,@SysChangeColumns NVARCHAR(1000)

	SELECT @ChangeTrackingCurrentVersion = CHANGE_TRACKING_CURRENT_VERSION()

	INSERT INTO [dbo].[zAuditAccountInfoField]
	(	
       [Id]
       ,[NameUserFriendly]
       ,[NameMachineUnfriendly]
       ,[Description]
       ,[Inactive]
       ,[CreatedBy]
       ,[CreatedDate]
       ,[LastModifiedBy]
       ,[LastModifiedDate]
       ,[IdPrevious]
       ,[NameUserFriendlyPrevious]
       ,[NameMachineUnfriendlyPrevious]
       ,[DescriptionPrevious]
       ,[InactivePrevious]
       ,[CreatedByPrevious]
       ,[CreatedDatePrevious]
       ,[LastModifiedByPrevious]
       ,[LastModifiedDatePrevious]
       ,[SYS_CHANGE_VERSION]
       ,[SYS_CHANGE_CREATION_VERSION]
       ,[SYS_CHANGE_OPERATION]
       ,[SYS_CHANGE_COLUMNS]
	)
		SELECT 
			[Id],
			[NameUserFriendly],
			[NameMachineUnfriendly],
			[Description],
			[Inactive],
			[CreatedBy],
			[CreatedDate],
			[LastModifiedBy],
			[LastModifiedDate],
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			@ChangeTrackingCurrentVersion,
			@ChangeTrackingCurrentVersion,
			'I',
			'Id,NameUserFriendly,NameMachineUnfriendly,Description,Inactive,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate'
		FROM 
			inserted

		INSERT INTO [ChangeTableVersioning]
		(
			Id,
			ChangeTrackingVersion,
			CreatedDate
		)
		SELECT
			NEWID(),
			@ChangeTrackingCurrentVersion,
			GETDATE()

		SET NOCOUNT OFF;
	END