
--USE OnlineEnrollment
--go

SET IDENTITY_INSERT LegalContent ON

INSERT LegalContent (LegalContentId, ContentType, MarketId, AccountTypeID, ProductBrandID, LanguageID, ContentOrder, Content, DisplayLabel,ScrollBoxHeight,ModifiedDate) 
select 
23 /*LegalContentId*/,
NULL /*ContentType*/,
0 /*MarketId*/, 
NULL /*AccountTypeID*/, 
19 /*ProductBrandID for 'Fixed National Green E' */, 
NULL /*LanguageID*/, 
5 /*ContentOrder*/,
NULL /*Content*/, 
NULL /*DisplayLabel*/, 
150px /*ScrollBoxHeight*/, 
GETDATE() /*ModifiedDate*/
WHERE NOT EXISTS (SELECT * 
FROM LegalContent
WHERE LegalContentId = 23) 

SET IDENTITY_INSERT LegalContent OFF

UPDATE LegalContent 
SET Content = 'I have read and understand the Green E <a href="/Legal/DownloadDocument/14" target="_blank">Prospective Product Content Label</a>.', 
DisplayLabel = Null,
ContentOrder=5,
ModifiedDate = GETDATE()
FROM LegalContent
WHERE LegalContentId = 23

