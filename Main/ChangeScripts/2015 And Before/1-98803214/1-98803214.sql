use lp_documents
go

--alter document_type table to add new column called 'SendToFtp'
if not exists(select * from sys.columns where name=N'SendToFtp' and object_id=object_id(N'document_type'))
begin
	alter table lp_documents..document_type add SendToFtp bit null default 0 with values;
end 


--update 'Other document type' after confirming it's there
if exists(select top 1 * from document_type where document_type_id=54)
begin
	update lp_documents..document_type set document_type_code='OTH',sendtoftp=1
	where document_type_id=54
end

--Update FTP for Welcome Letters.(previously existing record)
update Lp_documents..document_type set sendtoftp=1 where document_type_id=2

