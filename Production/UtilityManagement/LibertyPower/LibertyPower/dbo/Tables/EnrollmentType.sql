CREATE TABLE [dbo].[EnrollmentType] (
    [EnrollmentTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Type]             VARCHAR (50) NOT NULL,
    [Sequence]         INT          CONSTRAINT [DF_EnrollmentType_Sequence] DEFAULT ((9999)) NOT NULL,
    [Active]           BIT          CONSTRAINT [DF_EnrollmentType_Active] DEFAULT ((1)) NOT NULL,
    [DateCreated]      DATETIME     CONSTRAINT [DF_EnrollmentType_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EnrollmentType] PRIMARY KEY CLUSTERED ([EnrollmentTypeID] ASC)
);

