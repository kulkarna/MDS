USE [Libertypower]
GO

Begin TRY
	Begin tran
--######################Delete Current Price and Create new prices for today Only.#####################--

Print 'Cleaning Prices...'
DECLARE @maxProductCrossPriceSet int

select @maxProductCrossPriceSet = MAX(ProductCrossPriceSetId) from ProductCrossPriceSet with(nolock)
select ChannelID into #AllowedSalesChannels from SalesChannel with(nolock) where 
 channelname in('NFG','YSM','CMG','EG1','UPI','TDM', 'NSL' )
SELECT * into #AllowedUtilities  from Utility with(nolock) where 
 ID in(14,18,38); 
SELECT * into #pricestoDelete from Price P with(nolock) where 
 p.ChannelID in (Select ChannelID from #AllowedSalesChannels with(nolock)) and
 p.ProductCrossPriceSetID=@maxProductCrossPriceSet and 
 p.UtilityID in (Select ID from #AllowedUtilities with(nolock)) and 
 p.ProductBrandID = 33
select * from #pricestoDelete with(nolock);
IF Exists (Select 1 from #pricestoDelete with(nolock))
BEGIN
    Delete From Price where ID in (select ID from #pricestoDelete with(nolock))
    Print 'Cleaning Prices...Done.'
END

Drop table #AllowedSalesChannels;
Drop table #AllowedUtilities;
Drop table #pricestoDelete;

 COMMIT tran -- Transaction Success!
	END TRY
	BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();
	
	
    IF @@TRANCOUNT > 0
    ROLLBACK TRAN --RollBack in case of Error

    -- you can Raise ERROR with RAISEERROR() Statement including the details of the exception
	RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
   
	END CATCH