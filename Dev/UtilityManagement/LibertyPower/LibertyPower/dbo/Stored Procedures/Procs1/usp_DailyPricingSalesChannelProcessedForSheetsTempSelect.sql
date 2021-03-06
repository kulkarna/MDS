﻿/*******************************************************************************
 * usp_DailyPricingSalesChannelProcessedForSheetsTempSelect
 * Gets records for sales channels that have pricing sheets generated
 *
 * This is a temp table which gets truncated 
 * after pricing sheet generation completes.
 *
 * Used during pricing sheet generation restart to indicate 
 * which sales channels already have sheets generated.
 *
 * History
 *******************************************************************************
 * 3/29/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingSalesChannelProcessedForSheetsTempSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	ID, SalesChannelID, DateCreated, CreatedBy
    FROM	DailyPricingSalesChannelProcessedForSheetsTemp WITH (NOLOCK)
    ORDER BY SalesChannelID
    
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSalesChannelProcessedForSheetsTempSelect';

