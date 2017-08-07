CREATE TABLE [dbo].[deal_config] (
    [contract_grace_period]       INT           NOT NULL,
    [email_role]                  INT           NOT NULL,
    [contract_template_directory] VARCHAR (100) NOT NULL,
    [enabled_check_user]          INT           NOT NULL,
    [usage]                       FLOAT (53)    NOT NULL,
    [header_enrollment_1]         VARCHAR (8)   NOT NULL,
    [header_enrollment_2]         VARCHAR (8)   NOT NULL
);

