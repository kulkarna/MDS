USE [Lp_UtilityManagement]
GO
/****** Object:  Table [dbo].[NameKeyPattern]    Script Date: 06/24/2016 11:46:55 ******/

INSERT [dbo].[NameKeyPattern] ([Id], [UtilityCompanyId], [NameKeyPattern], [NameKeyPatternDescription], [NameKeyAddLeadingZero], [NameKeyTruncateLast], [NameKeyRequiredForEDIRequest], [Inactive], [CreatedBy], [CreatedDate], [LastModifiedBy], [LastModifiedDate]) 
VALUES (NEWID(), N'BD2A0627-0DD9-4446-BE8A-2A785AD2A6B8', N'^[a-zA-Z]{4}$', N'4 letter Name Key', NULL, NULL, 1, 0, N'vsharma',getdate(), N'vsharma', getdate())
INSERT [dbo].[NameKeyPattern] ([Id], [UtilityCompanyId], [NameKeyPattern], [NameKeyPatternDescription], [NameKeyAddLeadingZero], [NameKeyTruncateLast], [NameKeyRequiredForEDIRequest], [Inactive], [CreatedBy], [CreatedDate], [LastModifiedBy], [LastModifiedDate]) 
VALUES (NEWID(), N'7F11CC94-5A53-44B8-9C6A-81D586822677', N'^[a-zA-Z]{4}$', N'4 letter Name Key', NULL, NULL, 1, 0, N'vsharma', getdate(), N'vsharma', getdate())
INSERT [dbo].[NameKeyPattern] ([Id], [UtilityCompanyId], [NameKeyPattern], [NameKeyPatternDescription], [NameKeyAddLeadingZero], [NameKeyTruncateLast], [NameKeyRequiredForEDIRequest], [Inactive], [CreatedBy], [CreatedDate], [LastModifiedBy], [LastModifiedDate]) 
VALUES (NEWID(), N'B26EB9B3-313C-485B-B42F-F39FD2C7D5DE', N'^[a-zA-Z]{4}$', N'4 letter Name Key', NULL, NULL, 1, 0, N'vsharma', getdate(), N'vsharma', getdate())


