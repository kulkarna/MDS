USE lp_mtm
GO 

ALTER TABLE dbo.MtMReportZkey
	ADD ISOId int not null default(0)
GO 

ALTER TABLE dbo.MtMReportZkey
	ADD ZainetLocationId int not null default(0)
GO 

ALTER TABLE dbo.MtMReportZkey
	ADD BookId int not null default(0)
GO 

