use Lp_transactions
go

-- PECO parser
insert into dbo.IdrUtilityRawParser (UtilityId, ParserType) values (55, 'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.PecoParser') 

-- DUKE parser
insert into dbo.IdrUtilityRawParser (UtilityId, ParserType) values (60, 'IdrUsageManagement, LibertyPower.Business.MarketManagement.IdrUsageManagement.Parsers.DukeParser') 
