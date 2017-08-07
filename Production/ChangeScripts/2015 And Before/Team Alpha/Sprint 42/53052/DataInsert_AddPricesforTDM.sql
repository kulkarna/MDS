USE Libertypower
GO
DECLARE @productBrandId int,@productCrossPriceSetId int
Select @productCrossPriceSetId=max(productcrosspricesetid) from ProductCrossPriceSet with(nolock);
Select @productBrandId = ProductBrandID from ProductBrand with(nolock) where ProductBrand.Name='FIXED GAS';

If not exists(Select * from Price with(nolock) where ProductCrossPriceSetID = @productCrossPriceSetId
and ProductBrandID = @productBrandId
and channelid =1268)
Begin
    Select * into #tempPriceTDM
    from Price with(nolock) where ProductCrossPriceSetID = @productCrossPriceSetId
    and ProductBrandID = @productBrandId
    and channelid =1263;

    Update #tempPriceTDM Set ChannelID=1268;
    Alter Table #tempPriceTDM Drop column ID;

    INSERT into Price 
    Select * from #tempPriceTDM (nolock);
    print 'inserting Prices.'
    
    Drop table #tempPriceTDM;
END
print 'Prices already exists. '

