USE Libertypower
GO
IF EXISTS (Select * from SalesChannelSelectedProducts with(nolock)
where MarketID not in(select distinct MarketID  from MarketProducts with(nolock)))
BEGIN
    DELETE FROM SalesChannelSelectedProducts where MarketID not in
    (select distinct MarketID  from MarketProducts with(nolock))
END
