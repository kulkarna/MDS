------------------------------------------------
--Script to Update the FTPRootPrefix location
--74297: Document Manager - FORM 1 - Copy the generated letters to the proper FTP location
----------------------------------------------------

Use Lp_documents
GO


If exists ( Select * from lp_documents..document_type where document_type_id in (70,71,72)and document_type_name like'Connecticut%')	
Begin
Update lp_documents..document_type set FtpRootPrefix='CTPuraNotification'  where document_type_id in (70,71,72)and document_type_name like'Connecticut%'
End
GO