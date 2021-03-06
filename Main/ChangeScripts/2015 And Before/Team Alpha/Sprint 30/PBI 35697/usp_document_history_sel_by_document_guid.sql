USE [lp_documents]
GO
/****** Object:  StoredProcedure [dbo].[usp_document_history_sel_by_acct_con]    Script Date: 05/05/2014 12:58:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================  
-- Created:Jaime Forero
-- Get document history by Guid
-- =======================================================================
-- TEST CASES
-- EXEC [usp_document_history_sel_by_document_guid] @p_document_guid = '125dcf6f-5646-4e27-85a2-3e1c7823c4b2'
	
CREATE PROC [dbo].[usp_document_history_sel_by_document_guid]   
( 
	@p_document_guid uniqueidentifier
)   
AS   

  
BEGIN  

	SET NOCOUNT ON;

	select h.history_id , h.document_name, h.document_type_id, h.document_path, h.date_created, h.document_guid
	FROM lp_documents.dbo.document_history 	h (NOLOCK)   
	WHERE h.document_guid = @p_document_guid
	;
	
	SET NOCOUNT OFF;

END
