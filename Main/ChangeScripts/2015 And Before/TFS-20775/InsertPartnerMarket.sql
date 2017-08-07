USE GENIE
GO
select COUNT(*) from LK_PartnerMarket with (Nolock)

IF NOT EXISTS (select * from Genie..LK_PartnerMarket where PartnerMarketID=12 and PartnerID=558 and MarketID=13)
BEGIN
Insert into dbo.LK_PartnerMarket Values('12','558','13')
END


IF NOT EXISTS (select * from Genie..LK_PartnerMarket where PartnerMarketID=13 and PartnerID=559 and MarketID=13)
BEGIN
Insert into dbo.LK_PartnerMarket Values('13','559','13')
END


IF NOT EXISTS (select * from Genie..LK_PartnerMarket where PartnerMarketID=14 and PartnerID=560 and MarketID=13)
BEGIN
Insert into dbo.LK_PartnerMarket Values('14','560','13')
END


IF NOT EXISTS (select * from Genie..LK_PartnerMarket where PartnerMarketID=15 and PartnerID=561 and MarketID=7)
BEGIN
Insert into dbo.LK_PartnerMarket Values('15','561','7')
END


IF NOT EXISTS (select * from Genie..LK_PartnerMarket where PartnerMarketID=16 and PartnerID=561 and MarketID=8)
BEGIN
Insert into dbo.LK_PartnerMarket Values('16','561','8')
END

IF NOT EXISTS (select * from Genie..LK_PartnerMarket where PartnerMarketID=17 and PartnerID=561 and MarketID=9)
BEGIN
Insert into dbo.LK_PartnerMarket Values('17','561','9')
END

IF NOT EXISTS (select * from Genie..LK_PartnerMarket where PartnerMarketID=18 and PartnerID=561 and MarketID=13)
BEGIN
Insert into dbo.LK_PartnerMarket Values('18','561','13')
END



select  COUNT(*) from LK_PartnerMarket with (Nolock)
