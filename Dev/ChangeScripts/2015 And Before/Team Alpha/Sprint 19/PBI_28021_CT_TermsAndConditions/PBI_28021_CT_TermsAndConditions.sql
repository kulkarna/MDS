USE OnlineEnrollment
go
/***************************************************************************/
--DELETE FROM LegalContent WHERE LegalContentId = 25
SET IDENTITY_INSERT LegalContent ON

INSERT LegalContent (LegalContentId, ContentType, MarketId, AccountTypeID, ProductBrandID, LanguageID, ContentOrder, Content, DisplayLabel,ScrollBoxHeight,ModifiedDate) 
select 
25 /*LegalContentId*/,
NULL /*ContentType*/,
3 /*MarketId*/, 
NULL /*AccountTypeID*/, 
NULL /*ProductBrandID for 'Fixed National Green E' */, 
NULL /*LanguageID*/, 
4 /*ContentOrder*/,
NULL /*Content*/, 
NULL /*DisplayLabel*/, 
'150px' /*ScrollBoxHeight*/, 
GETDATE() /*ModifiedDate*/
WHERE NOT EXISTS (SELECT * 
FROM LegalContent
WHERE LegalContentId = 25) 

SET IDENTITY_INSERT LegalContent OFF

UPDATE LegalContent 
SET Content = 'I have read and understand the Contract <a href="/Legal/DownloadDocument/3" target="_blank">Terms and Conditions</a>.',
DisplayLabel = Null,
ContentOrder=4,
ModifiedDate = GETDATE()
FROM LegalContent
WHERE LegalContentId = 25

--SELECT * FROM LegalContent
