USE [lp_documents]
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF not EXISTS ( SELECT TOP 1 1 FROM lp_documents..document_language_market where language_id=2 and market_id=4 and document_type_id=1)
	insert into lp_documents..document_language_market(language_id,market_id,document_type_id,created_date,created_by)
		values(2,4,1,GETDATE(),'LibertyPower\pkatiyar')