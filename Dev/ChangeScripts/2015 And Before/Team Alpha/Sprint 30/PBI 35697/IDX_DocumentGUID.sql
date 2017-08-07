USE [Lp_documents]
GO

/****** Object:  Index [IDX_DocumentGUID]    Script Date: 05/05/2014 13:31:58 ******/
CREATE NONCLUSTERED INDEX [IDX_DocumentGUID] ON [dbo].[document_history] 
(
	[document_guid] ASC
)
INCLUDE ( [history_id],
[document_type_id],
[document_name],
[date_created],
[document_path]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, 
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, 
DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO




