/*


Select distinct ContractNBR, Convert(nvarchar(20), ContractID) as sContractID from ST_GenieImport
where DealCaptureStatus=0

*/
CREATE proc [dbo].[spGenie_SaveContract](@ContractNBR varchar(20), 
@DocumentPath varchar(200)='\\LPCDMZSQLCTR1\CTR\UploadDocs\') as

--  Version 1.1  Used complete document filename for path in history
--  Version 1.2  Inser history before pushing to lp_accounts

begin
declare @err table(flag_error varchar(10), code_error varchar(20), message_error varchar(50))


Insert into lp_Documents.dbo.document_history
	(Contract_NBR, Document_Type_ID, Document_Name
		, Date_Created, created_by, inactive_ind, document_path,templateVersionId )
Select ContractNBR, AttachmentTypeID, ContractNBR+'_'+DocFileName
		,getdate(),'LibertyPower\sguddanti', 0,  @DocumentPath+ContractNBR+'_'+DocFileName, b.TemplateVersionId
from 
( Select * from ST_GenieImportAttachments Where ContractNBR=@ContractNBR)  a
left join
(
	select TemplateVersionId, VersionCode
	from lp_documents.dbo.TemplateVersions
	where IsActive = 1
	--and EtfID = 2
) b
on a.DocumentVersion=b.VersionCode


declare @DealCaptureError varchar(50)

--BEGIN TRY
	--insert into @err
	EXEC lp_deal_capture.dbo.[usp_genie_contract_submit] @p_username = 'libertypower\DMarino', @p_process = 'ONLINE'
		, @p_contract_nbr = @ContractNBR, @p_contract_type = 'PAPER'


--Select @DealCaptureError = message_error from @err
	
	
	Select @DealCaptureError = '??'
--
--END TRY
--BEGIN CATCH
--	Select @DealCaptureError = 'ERROR'
--END CATCH 

-- Change this later
update ST_GenieImport set DealCaptureStatus=1, DealCaptureErrorCode=@DealCaptureError where ContractNBR=@ContractNBR


end
