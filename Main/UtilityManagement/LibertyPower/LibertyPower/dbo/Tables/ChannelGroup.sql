CREATE TABLE [dbo].[ChannelGroup] (
    [ChannelGroupID] INT              IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (50)     NULL,
    [Description]    VARCHAR (100)    NULL,
    [ChannelTypeID]  INT              NULL,
    [CommissionRate] DECIMAL (18, 10) CONSTRAINT [DF_ChannelGroup_CommissionRate] DEFAULT ((0)) NOT NULL,
    [Active]         BIT              CONSTRAINT [DF_ChannelGroup_Active] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ChannelGroup] PRIMARY KEY CLUSTERED ([ChannelGroupID] ASC) WITH (FILLFACTOR = 90)
);




GO




GO
-- =============================================
-- Author:		SWCS - Jose Muñoz
-- Create date: 04/27/2011
-- Description:	Ticket 22712 
-- Rates are not being generated when a new sales channel group is created 
-- A trigger should be fired when a sales channel group is inserted into the table, 
-- and should execut the stored procedure LibertyPower..usp_DailyPricingAddLegacyRateIdsForNewGroup .
--
-- 6/24/2011 - Rick Deigsler
-- Modified job name to be unique due to mutiple channel groups being
-- created in rapid succession. Such a scenario would only allow one job
-- with same name to run at a time, causing the others not to run at all.
-- =============================================
CREATE TRIGGER [dbo].[ChannelGroupInsert]
   ON  [Libertypower].[dbo].[ChannelGroup]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @ChannelGroup  INTEGER

	DECLARE ChannelGroupCursor INSENSITIVE CURSOR FOR
	SELECT ChannelGroupID
	FROM INSERTED
	
	declare @w_exec_sql varchar(200)
	declare @w_error char(1)
	declare @w_msg_id char(8)
	declare @p_dateexec datetime
	declare @w_return int
	DECLARE @uid uniqueidentifier
	DECLARE	@JobName varchar(300)
	
	SET @uid = NEWID()
	SET	@JobName = 'ChannelGroupProductsInsert-' + CAST(@uid AS varchar(255))
	set @p_dateexec = getdate()
	
	OPEN ChannelGroupCursor
	FETCH NEXT FROM ChannelGroupCursor INTO @ChannelGroup
	WHILE @@FETCH_STATUS = 0
	BEGIN					
	
		select @w_exec_sql  = 'exec'
						+ ' '
						+ 'usp_DailyPricingAddLegacyRateIdsForNewGroup'
						+ ' '
						+ ltrim(rtrim(@ChannelGroup))
			
		print @w_exec_sql
		
		select @w_return = 0
		
		exec @w_return = lp_common..usp_summit_job 'SYSTEM',
                                   'DEAL CAPTURE',
                                   @w_exec_sql,
                                   'LibertyPower',
                                   @@servername,
                                   @JobName,
                                   @p_dateexec,
                                   @w_error output,
                                   @w_msg_id output
                                   
        print @w_return
        print @w_error
        print @w_msg_id
		--EXEC [LibertyPower].[dbo].[usp_DailyPricingAddLegacyRateIdsForNewGroup] @ChannelGroup 
		FETCH NEXT FROM ChannelGroupCursor INTO @ChannelGroup
	END
	CLOSE ChannelGroupCursor
	DEALLOCATE ChannelGroupCursor
	
	SET NOCOUNT OFF;
END

GO

   

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ChannelGroup';


GO

CREATE TRIGGER ChannelGroup_AU_For_Commissions ON [LibertyPower].[dbo].[ChannelGroup] AFTER UPDATE
AS	  
    DECLARE @Date DATETIME = GETDATE()	
    
    UPDATE CGC 
	SET ExpirationDate = @Date 
	FROM INSERTED I
	JOIN DELETED D ON D.ChannelGroupID = I.ChannelGroupID
	JOIN [LibertyPower].[dbo].[ChannelGroupCommission] CGC ON CGC.ChannelGroupID = D.ChannelGroupID AND CGC.ExpirationDate IS NULL
	WHERE I.CommissionRate <> D.CommissionRate -- Making sure a changed occurred 
	
    INSERT INTO [LibertyPower].[dbo].[ChannelGroupCommission]
	(ChannelGroupID, CommissionRate, EffectiveDate, ExpirationDate)
	SELECT I.ChannelGroupID, I.CommissionRate, @Date, NULL
	FROM INSERTED I
	JOIN DELETED D ON D.ChannelGroupID = I.ChannelGroupID 
    WHERE I.CommissionRate <> D.CommissionRate -- Making sure a changed occurred
GO

CREATE TRIGGER ChannelGroup_AI_For_Commissions ON [LibertyPower].[dbo].[ChannelGroup] AFTER INSERT
AS	
   INSERT INTO [LibertyPower].[dbo].[ChannelGroupCommission]
   (
		ChannelGroupID,
		CommissionRate,
		EffectiveDate,
		ExpirationDate
   )
   SELECT
		ChannelGroupID,
		CommissionRate,
		GETDATE(),
		NULL
	FROM INSERTED