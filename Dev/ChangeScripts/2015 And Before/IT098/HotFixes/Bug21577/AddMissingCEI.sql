use lp_transactions
go

--select * from dbo.IdrUtilityRawParser where UtilityId = 62

insert into dbo.IdrUtilityRawParser (UtilityId, ParserType, IsAccountNumberInFile)
values (62, 'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.CeiHorizontalSingleParser', 1)