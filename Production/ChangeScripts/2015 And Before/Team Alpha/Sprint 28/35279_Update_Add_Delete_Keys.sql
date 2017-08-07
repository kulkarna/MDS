use LibertyPower
go


/*START SETTING FOREIGN KEY*/

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ClientApplicationType SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
if not Exists( Select * from sys.objects obj 
    where obj.name='FK_ClientSubmitApplicationKey_ClientApplicationType' and obj.type='F')
ALTER TABLE dbo.ClientSubmitApplicationKey ADD CONSTRAINT
	FK_ClientSubmitApplicationKey_ClientApplicationType FOREIGN KEY
	(
	ClientApplicationTypeId
	) REFERENCES dbo.ClientApplicationType
	(
	ClientApplicationTypeId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ClientSubmitApplicationKey SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
/*END SETTING FOREIGN KEY*/


BEGIN TRANSACTION;
BEGIN TRY

declare @clientAppTypeIdTablet int;
declare @clientAppTypeIdThirdParty int;

Update ClientApplicationType set ClientApplicationType='PartnerPortal' where ClientApplicationType='SubmitClosedDeals';
Update ClientApplicationType set [Description]='Submission through DealCapture, Batch upload and contract prepopulation.' 
						  where ClientApplicationType='PartnerPortal';
Update ClientSubmitApplicationKey set ClientApplicationTypeId=1 where ClientApplicationTypeId in(1,2,3);

Delete from ClientApplicationType where ClientApplicationType ='BatchUpload';
Delete from ClientApplicationType where ClientApplicationType ='ContractPrepopulation';

Select @clientAppTypeIdTablet = ClientApplicationTypeid from ClientApplicationType with(nolock) where ClientApplicationType='Tablet';
Select @clientAppTypeIdThirdParty = ClientApplicationTypeid from ClientApplicationType with(nolock) where ClientApplicationType='Thirdparty';
--Insert more ClientSubmitApplicationKeys for Tablet and ThirdParty.
IF NOT Exists(select * from [ClientSubmitApplicationKey] where ClientApplicationTypeId = @clientAppTypeIdTablet and [Description]='Submission Through Genie Service')
    Begin
 
    INSERT INTO [LibertyPower].[dbo].[ClientSubmitApplicationKey]
		(
			 [ApplicationKey],[ClientApplicationTypeId],[Description]
		,[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[Active])
	    VALUES
		( NEWID(),
			 @clientAppTypeIdTablet,'Submission Through Genie Service'
		,1982,GETDATE(),1982,GETDATE(),1);
	END;	
IF NOT Exists(select * from [ClientSubmitApplicationKey] where ClientApplicationTypeId = @clientAppTypeIdThirdParty)          
    INSERT INTO [LibertyPower].[dbo].[ClientSubmitApplicationKey]
		(
			 [ApplicationKey],[ClientApplicationTypeId],[Description]
		,[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[Active])
	    VALUES
		( NEWID(),
			 @clientAppTypeIdThirdParty,'Submission Through Thirdparty'
		,1982,GETDATE(),1982,GETDATE(),1);	

END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;

IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;
/*
select * from ClientApplicationType with(nolock);
select * from dbo.ClientSubmitApplicationKey with(nolock);

rollback;

select * from ClientApplicationType with(nolock);
select * from dbo.ClientSubmitApplicationKey with(nolock);
*/