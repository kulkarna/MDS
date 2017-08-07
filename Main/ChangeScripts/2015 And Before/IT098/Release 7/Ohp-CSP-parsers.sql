use Lp_transactions 
go

insert into dbo.IdrUtilityRawParser (UtilityId, ParserType, IsAccountNumberInFile)
values (58, 'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmOhpParser', 1)

insert into dbo.IdrUtilityRawParser (UtilityId, ParserType, IsAccountNumberInFile)
values (59, 'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PjmCspParser', 1)