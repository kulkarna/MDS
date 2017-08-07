BEGIN TRY
    BEGIN TRAN;

    DECLARE @market int, 
            @PARTNERMARKETID int, 
            @partnerid int;

    SET @partnerid=(SELECT PartnerID
                      FROM LK_Partner
                      WHERE PartnerName = 'YSM');
    SET @PARTNERMARKETID=(SELECT MAX(PartnerMarketID)
                            FROM LK_PartnerMarket);

    SET @market=(SELECT MarketID
                   FROM Genie.dbo.LK_Market
                   WHERE MarketCode = 'PA');
	
    --if this market PA is not present for channel YSM then insert this market for channel YSM

    IF NOT EXISTS(SELECT *
                    FROM LK_PartnerMarket
                    WHERE PartnerID = @partnerid
                      AND MarketID = @market)
        BEGIN
            INSERT INTO Genie.dbo.LK_PartnerMarket(PartnerMarketID, 
                                                   PartnerID, 
                                                   MarketID)
            VALUES(@PARTNERMARKETID + 1, 
                   @partnerid, 
                   @market)
        END;

    COMMIT TRAN; -- Transaction Success!
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRAN
        END; --RollBack in case of Error

-- you can Raise ERROR with RAISEERROR() Statement including the details of the exception
--RAISERROR(ERROR_MESSAGE(''), ERROR_SEVERITY(''), 1)
END CATCH;

     