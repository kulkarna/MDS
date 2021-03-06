--USE OnlineEnrollment
--go
/***************************************************************************/
SET IDENTITY_INSERT LegalContent ON

INSERT LegalContent (LegalContentId, ContentType, MarketId, AccountTypeID, ProductBrandID, LanguageID, ContentOrder, Content, DisplayLabel,ScrollBoxHeight,ModifiedDate) 
select 
24 /*LegalContentId*/,
NULL /*ContentType*/,
13 /*MarketId*/, 
NULL /*AccountTypeID*/, 
NULL /*ProductBrandID for 'Fixed National Green E' */, 
NULL /*LanguageID*/, 
5 /*ContentOrder*/,
NULL /*Content*/, 
NULL /*DisplayLabel*/, 
150px /*ScrollBoxHeight*/, 
GETDATE() /*ModifiedDate*/
WHERE NOT EXISTS (SELECT * 
FROM LegalContent
WHERE LegalContentId = 24) 

SET IDENTITY_INSERT LegalContent OFF

UPDATE LegalContent 
SET Content = 'I have read and understand the terms of the <a href="/Legal/DownloadDocument/19" target="_blank">IL LOA agreement</a>.',
DisplayLabel = Null,
ContentOrder=5,
ModifiedDate = GETDATE()
FROM LegalContent
WHERE LegalContentId = 24
/****************************************************************/


--SELECT TOP 1000 [LegalContentId]
--      ,[ContentType]
--      ,[MarketId]
--      ,[AccountTypeID]
--      ,[ProductBrandID]
--      ,[LanguageID]
--      ,[ContentOrder]
--      ,[Content]
--      ,[DisplayLabel]
--      ,[ScrollBoxHeight]
--      ,[ModifiedDate]
--  FROM [OnlineEnrollment].[dbo].[LegalContent]