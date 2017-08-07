	USE LibertyPower;
	GO
	
	Begin TRY
	Begin tran

	UPDATE [Libertypower].[dbo].[SalesChannel]
   	SET [MarginLimit] =0.10
    WHERE ChannelName='UEP'
	
	--update margin Limit to 0.10 from earlier value 0 for channel uep
	
	
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