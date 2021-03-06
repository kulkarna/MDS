--USE OnlineEnrollment
--go
UPDATE LegalContent 
SET Content = 'I have read and understand the Contract <a href="/Legal/DownloadDocument/3" target="_blank">Terms and Conditions</a>.',
ModifiedDate = GETDATE()
FROM LegalContent
WHERE LegalContentId = 21 OR LegalContentId = 22 


SELECT TOP 1000 [LegalContentId]
      ,[ContentType]
      ,[MarketId]
      ,[AccountTypeID]
      ,[ProductBrandID]
      ,[LanguageID]
      ,[ContentOrder]
      ,[Content]
      ,[DisplayLabel]
      ,[ScrollBoxHeight]
      ,[ModifiedDate]
  FROM [OnlineEnrollment].[dbo].[LegalContent]