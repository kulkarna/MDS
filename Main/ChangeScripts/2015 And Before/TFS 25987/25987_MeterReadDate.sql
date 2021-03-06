USE [Lp_deal_capture]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetNextMeterReadDate]    Script Date: 11/13/2013 16:26:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Saraswathi Lakshmanan
-- Create date: 9/18/2013
-- Description:	Returns the Next MeterReadDate
--------------------------------------------------------------
-- Author:		Saraswathi Lakshmanan
-- Modified date: 11/13/2013
-- Description:	Added Top 1 and order by to the selelct query
-- =============================================
ALTER FUNCTION [dbo].[ufn_GetNextMeterReadDate](
                @p_AccountID char(12), 
                @p_AccountNumber varchar(50), 
                @p_contract_eff_start_date datetime, 
                @p_utility_id char(15))
RETURNS datetime
AS
BEGIN
    DECLARE @w_min_start_date datetime;
    DECLARE @w_account_date_start datetime, 
            @w_account_date_end datetime, 
            @w_account_date_end_account datetime -- Add ticket # 1-1430369
            , 
            @w_DateTempChar varchar(10);



    --Sept 10 2013
    --Get the meter Read Date from lp_common Meter Calendar based on the billing group and month
    --If data doesn't exist then go by the contract end Date.
    DECLARE @BillingGroup varchar(15);
    SET @BillingGroup=(SELECT A.BillingGroup
                         FROM LibertyPower..Account A WITH (nolock)
                         WHERE A.AccountIdLegacy
                             = @p_AccountID);
    DECLARE @Contract_EffectiveStartDate_Month int;
    SET @Contract_EffectiveStartDate_Month=MONTH(@p_contract_eff_start_date);
    DECLARE @Contract_EffectiveStartDate_Year int;
    SET @Contract_EffectiveStartDate_Year=YEAR(@p_contract_eff_start_date);

    IF EXISTS(SELECT top 1 m.read_date
                FROM Lp_common..meter_read_calendar m WITH (NOLock)
                WHERE m.calendar_month
                    = @Contract_EffectiveStartDate_Month
                  AND m.calendar_year
                    = @Contract_EffectiveStartDate_Year
                  AND read_cycle_id
                    = @BillingGroup
                  AND utility_id
                    = @p_utility_id order by m.read_date)
        BEGIN
            SET @w_account_date_start=DATEADD(dd, 1, (SELECT top 1 m.read_date
                                                        FROM Lp_common..meter_read_calendar m WITH (NOLock)
                                                        WHERE m.calendar_month
                                                            = @Contract_EffectiveStartDate_Month
                                                          AND m.calendar_year
                                                            = @Contract_EffectiveStartDate_Year
                                                          AND read_cycle_id
                                                            = @BillingGroup
                                                          AND utility_id
                                                            = @p_utility_id order by m.read_date));
        END;
    ELSE
        BEGIN
            IF EXISTS(SELECT top 1 m.read_date
                        FROM Lp_common..meter_read_calendar m WITH (NOLock)
                        WHERE m.calendar_month
                            = @Contract_EffectiveStartDate_Month
                          AND m.calendar_year
                            = @Contract_EffectiveStartDate_Year - 1
                          AND read_cycle_id
                            = @BillingGroup
                          AND utility_id
                            = @p_utility_id order by m.read_date)
                BEGIN
                    SET @w_account_date_start=DATEADD(yy, 1, DATEADD(dd, 1, (SELECT Top 1 m.read_date
                                                                               FROM Lp_common..meter_read_calendar m WITH (NOLock)
                                                                               WHERE m.calendar_month
                                                                                   = @Contract_EffectiveStartDate_Month
                                                                                 AND m.calendar_year
                                                                                   = @Contract_EffectiveStartDate_Year - 1
                                                                                 AND read_cycle_id
                                                                                   = @BillingGroup
                                                                                 AND utility_id
                                                                                   = @p_utility_id order by m.read_date)));
                END;
            ELSE
                BEGIN
                    SELECT @w_account_date_end_account=DATEADD(dd, 1, date_end)
                      FROM lp_account..account WITH (nolock)
                      WHERE account_id
                          = @p_AccountID;

                    IF @w_account_date_end_account IS NULL
                        BEGIN
                            SET @w_account_date_end_account='1900/01/01';
                        END;
                    
                    --if month(@w_account_date_end_account) in (3,8,11) and day(@w_account_date_end_account) = '31'
                    --	set @w_account_date_end_account = '1900/01/01'				

                    SET @w_DateTempChar=(SELECT CONVERT(varchar(10), DATEADD(dd, DAY(@w_account_date_end_account), DATEADD(dd, -(DAY(@p_contract_eff_start_date) - 1), @p_contract_eff_start_date) - 1), 101));
               
                    --SET @w_DateTempChar	= LTRIM(RTRIM(STR(YEAR(@p_contract_eff_start_date)))) 
                    --		+ Right(STR( 100 + MONTH(@p_contract_eff_start_date)),2)
                    --		+ Right(STR( 100 + DAY(@w_account_date_end_account)),2)

                    IF ISDATE(@w_DateTempChar)
                     = 1
                        BEGIN
                            SET @w_account_date_start=@w_DateTempChar;
                        END;
                    ELSE
                        BEGIN
                            SET @w_account_date_start=LTRIM(RTRIM(STR(YEAR(@p_contract_eff_start_date)))) + RIGHT(STR(100 + MONTH(@p_contract_eff_start_date)), 2) + '01';
                        END;
               
                /* Ticket # 1-1430369  End */

                END;
        END;
    SET @w_min_start_date=@w_account_date_start;
    RETURN @w_min_start_date;
END;



