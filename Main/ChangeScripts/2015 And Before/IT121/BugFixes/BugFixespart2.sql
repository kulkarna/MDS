USE [Lp_deal_capture]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetNextMeterReadDate]    Script Date: 09/19/2013 01:13:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_GetNextMeterReadDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_GetNextMeterReadDate]
GO

USE [Lp_deal_capture]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetNextMeterReadDate]    Script Date: 09/19/2013 01:13:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Saraswathi Lakshmanan
-- Create date: 9/18/2013
-- Description:	Returns the Next MeterReadDate
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetNextMeterReadDate](
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

    IF EXISTS(SELECT m.read_date
                FROM Lp_common..meter_read_calendar m WITH (NOLock)
                WHERE m.calendar_month
                    = @Contract_EffectiveStartDate_Month
                  AND m.calendar_year
                    = @Contract_EffectiveStartDate_Year
                  AND read_cycle_id
                    = @BillingGroup
                  AND utility_id
                    = @p_utility_id)
        BEGIN
            SET @w_account_date_start=DATEADD(dd, 1, (SELECT m.read_date
                                                        FROM Lp_common..meter_read_calendar m WITH (NOLock)
                                                        WHERE m.calendar_month
                                                            = @Contract_EffectiveStartDate_Month
                                                          AND m.calendar_year
                                                            = @Contract_EffectiveStartDate_Year
                                                          AND read_cycle_id
                                                            = @BillingGroup
                                                          AND utility_id
                                                            = @p_utility_id));
        END;
    ELSE
        BEGIN
            IF EXISTS(SELECT m.read_date
                        FROM Lp_common..meter_read_calendar m WITH (NOLock)
                        WHERE m.calendar_month
                            = @Contract_EffectiveStartDate_Month
                          AND m.calendar_year
                            = @Contract_EffectiveStartDate_Year - 1
                          AND read_cycle_id
                            = @BillingGroup
                          AND utility_id
                            = @p_utility_id)
                BEGIN
                    SET @w_account_date_start=DATEADD(yy, 1, DATEADD(dd, 1, (SELECT m.read_date
                                                                               FROM Lp_common..meter_read_calendar m WITH (NOLock)
                                                                               WHERE m.calendar_month
                                                                                   = @Contract_EffectiveStartDate_Month
                                                                                 AND m.calendar_year
                                                                                   = @Contract_EffectiveStartDate_Year - 1
                                                                                 AND read_cycle_id
                                                                                   = @BillingGroup
                                                                                 AND utility_id
                                                                                   = @p_utility_id)));
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



GO


-------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetMinStartDateforanAccount]    Script Date: 09/19/2013 01:13:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_GetMinStartDateforanAccount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_GetMinStartDateforanAccount]
GO

USE [Lp_deal_capture]
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_GetMinStartDateforanAccount]    Script Date: 09/19/2013 01:13:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Sara Lakshmanan
-- Create date: 9/18/2013
-- Description:	Returns the MinStartDate for an Account
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetMinStartDateforanAccount](
               @p_AccountID char(12), 
               @p_AccountNumber varchar(50), 
               @p_contract_eff_start_date datetime, 
               @p_utility_id char(15))
RETURNS datetime
AS
BEGIN

    DECLARE @w_min_start_date datetime;
                        SET @w_min_start_date=@p_contract_eff_start_date;

    IF EXISTS(SELECT account_id
                FROM lp_account..account WITH (nolock)
                WHERE account_id
                    = @p_AccountID)
        BEGIN
            ---If the account is flowing it is a renewal deal 
            --else it is considered to be a new account
            DECLARE @EndDate datetime;
            SET @EndDate=(SELECT ALS.EndDate
                            FROM lp_account..account A WITH (noLock) INNER JOIN LibertyPower..AccountLatestService ALS WITH (noLock)ON A.AccountID_key
                                                                                                                                     = ALS.AccountID
                            WHERE account_number
                                = @p_AccountNumber);

            IF @EndDate IS NULL
            OR @EndDate
             > @p_contract_eff_start_date
                --Flowing renewal account		
                BEGIN
                    SET @w_min_start_date=(SELECT Lp_deal_capture.dbo.ufn_GetNextMeterReadDate(@p_AccountID, @p_AccountNumber, @p_contract_eff_start_date, @p_utility_id));
                END;
            ELSE --Account exists but not flowing
                BEGIN
                    --If Account exsists and not flowing then we need to see if the account is active
                    --If active and not expired then get the meter readdate+1 else today
                    IF NOT EXISTS(SELECT account_number
                                    FROM lp_account..account A WITH (noLock)
                                    WHERE account_number
                                        = @p_AccountNumber
                                      AND Status IN('999998', '999999')
                                      AND sub_status IN('10'))
                        BEGIN     
                            --If the account is active then get the next meter read date 

                            IF EXISTS(SELECT A.date_end
                                        FROM lp_account..account A WITH (noLock)
                                        WHERE account_number
                                            = @p_AccountNumber
                                          AND date_end
                                            < GETDATE())
                                BEGIN     
                                    --If the account is expired 
                                    --set the meter read date
                                   SET @w_min_start_date=(SELECT Lp_deal_capture.dbo.ufn_GetNextMeterReadDate(@p_AccountID, @p_AccountNumber, @p_contract_eff_start_date, @p_utility_id));
                     
                                END;
                            ELSE-- if not expired get the contract enddate+1
                                BEGIN
                                    SET @w_min_start_date=((SELECT A.date_end+1
                                        FROM lp_account..account A WITH (noLock)
                                        WHERE account_number
                                            = @p_AccountNumber));
                                END;
                        END;
                    ELSE

                        BEGIN
                            SET @w_min_start_date=@p_contract_eff_start_date;
                        END;


                ----  if a new acount then we can use the same effective start date and end sdate
                --UPDATE Lp_deal_capture..deal_contract_account
                --SET contract_eff_start_date=@p_contract_eff_start_date, 
                --    date_end=CASE
                --             WHEN @w_fixed_end_date
                --                = 1 THEN @w_due_date
                --                 ELSE @w_date_end
                --             END
                --  WHERE contract_nbr
                --      = @p_contract_nbr
                --    AND account_number
                --      = @p_AccountNumber;

                END;


        END;
    ELSE
        BEGIN
            SET @w_min_start_date=@p_contract_eff_start_date;
        --  if a new acount then we can use the same effective start date and end sdate
        --UPDATE Lp_deal_capture..deal_contract_account
        --SET contract_eff_start_date=@p_contract_eff_start_date, 
        --    date_end=CASE
        --             WHEN @w_fixed_end_date
        --                = 1 THEN @w_due_date
        --                 ELSE @w_date_end
        --             END
        --  WHERE contract_nbr
        --      = @p_contract_nbr
        --    AND account_number
        --      = @p_AccountNumber;

        END;

    RETURN @w_min_start_date;
END;



GO


---------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_pricing_ins]    Script Date: 09/19/2013 01:14:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_contract_pricing_ins]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_contract_pricing_ins]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_pricing_ins]    Script Date: 09/19/2013 01:14:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/9/2007
-- Description:	Insert / update pricing data
-- =============================================
-- Modified: Gail Mangaroo 1/25/2008
-- update deal_pricing_detail when rate is submitted
-- =============================================
-- Modified: Gail Mangaroo 3/28/2008
-- get COMMCAP rate from Custom Pricing if the rate is a custom rate 
-- altered update of rate_submit_ind 
-- =============================================
-- Modified: Eric Hernandez 4/30/2008
-- added customer_type to table, so parameters had to be added for this insert.
-- =============================================
-- Modified: Jose Munoz 1/14/2010
-- add HeatIndexSourceID and HeatRate for updates in the tables 
-- deal_contract, deal_contract_account and deal_pricing_detail
-- =============================================
-- Modified: Gail Mangaroo 2/18/2010
-- Added rate cap validation 
-- =============================================
-- Modified: Jose Munoz 5/11/2010
-- Add evergreen_option_id, evergreen_commission_end, residual_option_id, residual_commission_end
--     initial_pymt_option_id, sales_manager, evergreen_commission_rate Columns
-- Project IT021
-- =============================================
-- =============================================
-- Modified: Diogo Lima 10/26/2010
--  update product/rate. all account have to have the same product
-- Ticket 17697 
-- =============================================
-- Modified: Isabelle Tamanini 11/17/2010
-- Removed code that updates rate_submit_ind for custom rates:
-- this is now handled by lp_deal_capture..usp_contract_submit_ins
-- SD19106  
-- =============================================
-- =============================================
-- Modified: Jaime Forero 3/22/2011
-- TICKET # 21693
-- Terms were not consistent with UI, users selected terms and once saved the terms were different.
-- Changed SP, look in comments for changed code
-- =============================================
-- Modified: Isabelle Tamanini 12/16/2011
-- SR1-4955209
-- Date end will be terms + eff start date - 1 day
-- =============================================
-- =============================================
-- Modified: Isabelle Tamanini 3/28/2012
-- SR1-11994972
-- Modified so that it doesn't try to get the rate by the deal date
-- if the rate is custom (as in the proc that gets the rates)
-- =============================================
-- Modify : Thiago Nogueira
-- Date : 7/25/2013 
-- Ticket: 1-179692237
-- Changed PriceID to BIGINT
-- =============================================
-- Modify : Sara lakshmanan
-- Date : 8/15/2013
-- Ticket: Deal Capture refactoring- Accounts grid
-- requested Flow Start date is updated (for the renewal accounts)
-- If the requested flow start date for an account is null empty then update with the given date from contract
-- =============================================
-- Modify : Sara lakshmanan
-- Date : Sept 5 2013
-- Ticket: Deal Capture refactoring- Accounts grid
-- For Renewal Accounts, The effective Start Date for the Accounts should be based on the meterReadday.
-- =============================================
-- Modify : Sara lakshmanan
-- Date : Sept 19 2013
-- Ticket: Bug fix: Modified part of the code to a function
-- =============================================
CREATE PROCEDURE [dbo].[usp_contract_pricing_ins](
      @p_username nchar(100), 
      @p_contract_nbr char(12), 
      @p_retail_mkt_id char(02)='', 
      @p_utility_id char(15)='', 
      @p_account_type varchar(50)='', 
      @p_product_id char(20)='', 
      @p_rate_id int=0, 
      @p_rate float=0, 
      @p_contract_eff_start_date datetime='19000101', 
      @p_term_months int=0, 
      @p_account_number varchar(30)='', 
      @p_enrollment_type int=1, 
      @p_requested_flow_start_date datetime='19000101', 
      @p_contract_date datetime=NULL, 
      @p_comm_cap float=0, 
      @p_customer_code char(05)='', 
      @p_customer_group char(100)='', 
      @p_error char(01)='', 
      @p_msg_id char(08)='', 
      @p_descp varchar(250)='', 
      @p_result_ind char(01)='Y', 
      @p_HeatIndexSourceID int=0, 
      -- Project IT037
      @p_HeatRate float=0, 
      -- Project IT037
      @p_transfer_rate float=0, 
      @evergreen_option_id int=NULL    -- IT021
      , 
      @evergreen_commission_end datetime=NULL    -- IT021
      , 
      @residual_option_id int=NULL    -- IT021
      , 
      @residual_commission_end datetime=NULL    -- IT021
      , 
      @initial_pymt_option_id int=NULL    -- IT021
      , 
      @sales_manager varchar(100)=NULL    -- IT021
      , 
      @evergreen_commission_rate float=NULL    -- IT021
      , 
      @p_zone varchar(20)=NULL -- IT092
      , 
      @PriceID bigint=0 -- IT106
      , 
      @PriceTier int=0 -- IT106
      , 
      @RatesString varchar(200)=NULL)
AS
SET NOCOUNT ON;
DECLARE @w_error char(01);
DECLARE @w_msg_id char(08);
DECLARE @w_descp varchar(250);
DECLARE @w_return int;
DECLARE @w_descp_add varchar(20);

SELECT @w_error='I';
SELECT @w_msg_id='00000001';
SELECT @w_descp='';
SELECT @w_return=0;
SELECT @w_descp_add='';

DECLARE @w_application varchar(20);
SELECT @w_application='COMMON';

SELECT @p_contract_nbr=UPPER(@p_contract_nbr);

SELECT @p_retail_mkt_id=UPPER(@p_retail_mkt_id);
SELECT @p_utility_id=UPPER(@p_utility_id);
SELECT @p_product_id=UPPER(@p_product_id);

DECLARE @w_contract_type varchar(15);
DECLARE @w_retail_mkt_id char(02);
DECLARE @w_utility_id char(15);
DECLARE @w_product_id char(20);
DECLARE @w_rate_id int;
DECLARE @w_rate float;
DECLARE @w_ratesString nvarchar(200);
DECLARE @w_changeProduct char(1);
DECLARE @w_contract_eff_start_date datetime;
DECLARE @w_term_months int;
DECLARE @w_term_months2 int;
DECLARE @w_date_end datetime;
DECLARE @w_grace_period int;
DECLARE @w_due_date datetime;
DECLARE @w_fixed_end_date tinyint;
DECLARE @w_rate_cap float, 
        @Today datetime;

SET @Today=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()));

IF @p_account_number
 = 'CONTRACT'
    BEGIN
        SELECT @w_contract_type=contract_type, 
               @w_retail_mkt_id=retail_mkt_id, 
               @w_utility_id=utility_id, 
               @w_product_id=product_id, 
               @w_rate_id=rate_id, 
               @w_rate=rate, 
               @w_contract_eff_start_date=contract_eff_start_date, 
               @w_term_months2=term_months, 
               @w_grace_period=grace_period
          FROM deal_contract WITH (NOLOCK INDEX=deal_contract_idx)
          WHERE contract_nbr
              = @p_contract_nbr;
    END;
ELSE
    BEGIN
        SELECT @w_contract_type=contract_type, 
               @w_retail_mkt_id=retail_mkt_id, 
               @w_utility_id=utility_id, 
               @w_product_id=product_id, 
               @w_rate_id=rate_id, 
               @w_rate=rate, 
               @w_contract_eff_start_date=contract_eff_start_date, 
               @w_term_months2=term_months, 
               @w_grace_period=grace_period
          FROM deal_contract_account WITH (NOLOCK INDEX=deal_contract_account_idx)
          WHERE contract_nbr
              = @p_contract_nbr
            AND account_number
              = @p_account_number;
    END;


-- TICKET # 21693, Rates were not matching selected rats in Deal Capture, 
-- the selection criteria did not take into account the effective date of the contract

-- This date can me null sometimes, we need a reference date always, if not supplied then just use todays date:
DECLARE @w_temp_contract_date datetime;

PRINT 'today ' + CAST(@Today AS varchar(50));
PRINT 'contract date ' + CAST(@p_contract_date AS varchar(50));

SET @w_temp_contract_date=@p_contract_date;

IF @w_temp_contract_date IS NULL
OR @w_temp_contract_date
 = ''
    BEGIN
        SET @w_temp_contract_date=CAST(FLOOR(CAST(GETDATE()AS float))AS datetime); -- set today's date
    END;

-- IT106
-- history
IF @w_temp_contract_date
 < @Today
    BEGIN
        PRINT 'getting history term months';
        SELECT @w_term_months=h.term_months, 
               @w_due_date=r.due_date, 
               @w_fixed_end_date=r.fixed_end_date
          FROM lp_common..product_rate_history h(NOLOCK) JOIN lp_common..common_product p(NOLOCK)ON h.product_id
                                                                                                  = p.product_id JOIN lp_common..common_product_rate r(NOLOCK)ON h.rate_id
                                                                                                                                                               = r.rate_id
                                                                                                                                                             AND h.product_id
                                                                                                                                                               = r.product_id
          WHERE(p.iscustom = 1
             OR h.eff_date
              = @w_temp_contract_date) --SR1-11994972
           AND h.rate_id
             = @p_rate_id
           AND h.product_id
             = @p_product_id
           AND (p.iscustom = 1 -- For custom products, start month matching is not enforced.
             OR @p_contract_eff_start_date
              = '19000101'
             OR h.contract_eff_start_date
              = DATEADD(mm, DATEDIFF(mm, 0, @p_contract_eff_start_date), 0) -- gets first day of the month out 
               );
    END;
-- current

ELSE
    BEGIN
        PRINT 'getting current term months';
        SELECT @w_term_months=@p_term_months, 
               @w_due_date=r.due_date, 
               @w_fixed_end_date=r.fixed_end_date
          FROM lp_common..common_product p(NOLOCK) JOIN lp_common..common_product_rate r(NOLOCK)ON p.product_id
                                                                                                 = r.product_id
          WHERE r.rate_id
              = @p_rate_id
            AND r.product_id
              = @p_product_id
            AND (p.iscustom = 1 -- For custom products, start month matching is not enforced.
              OR @p_contract_eff_start_date
               = '19000101'
              OR r.contract_eff_start_date
               = DATEADD(mm, DATEDIFF(mm, 0, @p_contract_eff_start_date), 0) -- gets first day of the month out 
                );
    END;

IF @w_term_months IS NULL
    BEGIN
        SELECT @w_term_months=Term
          FROM Libertypower..Price WITH (NOLOCK)
          WHERE ID = @PriceID;
    END;
ELSE
    BEGIN
        PRINT 'term months ' + CAST(@w_term_months AS varchar(20));
    END;
--SR1-4955209
SET @w_date_end=DATEADD(mm, @w_term_months, DATEADD(dd, -1, @p_contract_eff_start_date));


-- START COMMENTED SECTION TICKET # 21693 -- REPLACED BY CODE ABOVE

--
--select @w_term_months                               = term_months,
--       @w_due_date                                  = due_date, 
--       @w_fixed_end_date                            = fixed_end_date
--from lp_common..common_product_rate with (NOLOCK)
--where product_id                                    = @p_product_id 
--and   rate_id                                       = @p_rate_id 


-- END COMMENTED SECTION TICKET # 21693

--and   inactive_ind                                  = '0'  -- Comments Ticket 19194



IF @p_utility_id
<> @w_utility_id
    BEGIN
        DELETE FROM deal_contract_account
          WHERE contract_nbr
              = @p_contract_nbr;
    END;

IF @p_product_id
<> @w_product_id
OR @p_term_months
<> @w_term_months2
    BEGIN
        SELECT @w_changeProduct='Y';
    END;
ELSE
    BEGIN
        SELECT @w_changeProduct='N';
    END;

PRINT 'before val';
EXEC @w_return=usp_contract_pricing_val @p_username, 'I', 'ALL', @p_contract_nbr, @p_account_number, @p_retail_mkt_id, @p_utility_id, @p_product_id, @p_rate_id, @p_rate, @w_term_months, @p_enrollment_type, @p_requested_flow_start_date, @p_contract_date, @p_customer_code, @p_customer_group, @w_application OUTPUT, @w_error OUTPUT, @w_msg_id OUTPUT, 'ONLINE', @PriceID;
IF @w_return <> 0
    BEGIN
        PRINT 'after val error';
        GOTO goto_select;
    END;

PRINT 'after val';

IF LEN(@p_contract_eff_start_date)
 = 0
    BEGIN
        SELECT @p_contract_eff_start_date=GETDATE();
    END;

IF @w_grace_period
 = 0
    BEGIN
        SELECT @w_grace_period=grace_period
          FROM lp_common..common_product_rate WITH (NOLOCK INDEX=common_product_rate_idx)
          WHERE product_id
              = @p_product_id
            AND rate_id
              = @p_rate_id
            AND inactive_ind
              = '0';
    END;

-- Rate Cap Validation SD# 10854 Gail Mangaroo 
-- ===============================
SET @w_rate_cap=0;
SELECT @w_rate_cap=rate_cap
  FROM lp_deal_capture..deal_rate WITH (nolock);

IF @p_transfer_rate
 = 0
    BEGIN 
        -- get transfer rate 
        SELECT @p_transfer_rate=ISNULL(dpd.ContractRate, a.rate)  -- a.rate, a.term_months, dpd.ContractRate, dpd.Commission
          FROM lp_common..common_product_rate a WITH (nolock) LEFT JOIN lp_deal_capture.dbo.deal_pricing_detail dpd WITH (nolock)ON a.product_id
                                                                                                                                  = dpd.product_id
                                                                                                                                AND a.rate_id
                                                                                                                                  = dpd.rate_id JOIN lp_common..common_product p WITH (nolock)ON p.product_id
                                                                                                                                                                                               = a.product_id
          WHERE a.product_id
              = @p_product_id
            AND a.rate_id
              = @p_rate_id
            AND CONVERT(char(08), GETDATE(), 112)
             >= a.eff_date
            AND CONVERT(char(08), GETDATE(), 112)
              < a.due_date
            AND a.term_months
              = ISNULL(@p_term_months, a.term_months)
            AND a.inactive_ind
              = '0';
    END;

IF @p_rate
 > @p_transfer_rate + @w_rate_cap
AND @w_rate_cap > 0
AND @p_transfer_rate
  > 0
    BEGIN
        SELECT @w_error='E';
        SELECT @w_msg_id='00000044';
        SELECT @w_return=1;
        SELECT @w_descp_add='';
        SELECT @w_application='DEAL';
        GOTO goto_select;
    END;

-- ============================================

IF @p_account_number
 = 'CONTRACT'
    BEGIN
        PRINT 'DEBUG: from usp_contract_pricing_ins, just before updating deal_contract';
        UPDATE deal_contract
        SET retail_mkt_id=@p_retail_mkt_id, 
            utility_id=@p_utility_id, 
            account_type=@p_account_type, 
            product_id=@p_product_id, 
            rate_id=@p_rate_id, 
            rate=@p_rate, 
            RatesString=@RatesString, 
            contract_eff_start_date=@p_contract_eff_start_date, 
            term_months=@w_term_months, 
            date_end=CASE
                     WHEN @w_fixed_end_date
                        = 1 THEN @w_due_date
                         ELSE @w_date_end
                     END, 
            grace_period=@w_grace_period, 
            enrollment_type=@p_enrollment_type, 
            requested_flow_start_date=@p_requested_flow_start_date, 
            customer_code=@p_customer_code, 
            customer_group=@p_customer_group, 
            HeatIndexSourceID=@p_HeatIndexSourceID, 
            -- Project IT037
            HeatRate=@p_HeatRate -- Project IT037
            , 
            evergreen_option_id=CASE
                                WHEN @evergreen_option_id IS NULL THEN evergreen_option_id
                                    ELSE @evergreen_option_id
                                END -- IT021
            , 
            evergreen_commission_end=CASE
                                     WHEN @evergreen_commission_end IS NULL THEN evergreen_commission_end
                                         ELSE @evergreen_commission_end
                                     END -- IT021
            , 
            residual_option_id=CASE
                               WHEN @residual_option_id IS NULL THEN residual_option_id
                                   ELSE @residual_option_id
                               END -- IT021
            , 
            residual_commission_end=CASE
                                    WHEN @residual_commission_end IS NULL THEN residual_commission_end
                                        ELSE @residual_commission_end
                                    END -- IT021
            , 
            initial_pymt_option_id=CASE
                                   WHEN @initial_pymt_option_id IS NULL THEN initial_pymt_option_id
                                       ELSE @initial_pymt_option_id
                                   END -- IT021
            , 
            sales_manager=CASE
                          WHEN @sales_manager IS NULL THEN sales_manager
                              ELSE @sales_manager
                          END -- IT021
            , 
            evergreen_commission_rate=CASE
                                      WHEN @evergreen_commission_rate IS NULL THEN evergreen_commission_rate
                                          ELSE @evergreen_commission_rate
                                      END -- IT021
            , 
            PriceID=@PriceID -- IT106
            , 
            PriceTier=@PriceTier -- IT106
          FROM deal_contract WITH (NOLOCK INDEX=deal_contract_idx)
          WHERE contract_nbr
              = @p_contract_nbr;

        IF @@error <> 0
        OR @@rowcount = 0
            BEGIN
                SELECT @w_error='E';
                SELECT @w_msg_id='00000051';
                SELECT @w_return=1;
                SELECT @w_descp_add='(Contract)';
                GOTO goto_select;
            END;

        PRINT 'DEBUG: from usp_contract_pricing_ins, just before updating deal_contract_account';
        UPDATE deal_contract_account
        SET contract_type=@w_contract_type, 
            retail_mkt_id=CASE
                          WHEN retail_mkt_id
                             = 'NN'
                            OR utility_id
                             = 'NONE'
                            OR product_id
                             = 'NONE'
                            OR rate_id = 0
                            OR rate = 0 THEN @p_retail_mkt_id
                          WHEN retail_mkt_id
                             = 'SELECT...' THEN 'NN'
                              ELSE retail_mkt_id
                          END, 
            account_type=@p_account_type, 
            utility_id=CASE
                       WHEN retail_mkt_id
                          = 'NN'
                         OR utility_id
                          = 'NONE'
                         OR product_id
                          = 'NONE'
                         OR rate_id = 0
                         OR rate = 0 THEN @p_utility_id
                       WHEN utility_id
                          = 'SELECT...' THEN 'NONE'
                           ELSE utility_id
                       END, 
            --product_id = case when retail_mkt_id = 'NN' 
            --                  or   utility_id    = 'NONE' 
            --                  or   product_id    = 'NONE' 
            --                  or   rate_id       = 0 
            --                  or   rate          = 0
            --                  then @p_product_id
            --                  when product_id    = 'SELECT...'
            --                  then 'NONE'
            --                  else @p_product_id --changed to updated all accounts of the contract
            --             end,
            --rate_id = case when retail_mkt_id = 'NN' 
            --               or   utility_id    = 'NONE' 
            --               or   product_id    = 'NONE' 
            --               or   rate_id       = 0 
            --               or   rate          = 0
            --               or   @w_changeProduct = 'Y'
            --               then @p_rate_id
            --               when product_id    = 'SELECT...'
            --               then 999999999
            --               else rate_id --changed to updated all accounts of the contract
            --          end,
            --rate = case when retail_mkt_id = 'NN' 
            --            or   utility_id    = 'NONE' 
            --            or   product_id    = 'NONE' 
            --            or   rate_id       = 0 
            --            or   rate          = 0
            --            or   @w_changeProduct = 'Y'
            --            then @p_rate
            --            else rate --changed to updated all accounts of the contract
            --       end,
            --Commented on Sept 5 2013
            --
            --      contract_eff_start_date = @p_contract_eff_start_date,
            --case when contract_eff_start_date = '19000101'
            --                               then @p_contract_eff_start_date
            --                               else contract_eff_start_date
            --                          end,
            --Add reqiested Flow Start Date
            requested_flow_start_date=CASE
                                      WHEN requested_flow_start_date
                                         = '19000101'
                                        OR requested_flow_start_date IS NULL THEN @p_requested_flow_start_date
                                          ELSE requested_flow_start_date
                                      END, 
            term_months=CASE
                        WHEN term_months = 0 THEN @w_term_months
                            ELSE @w_term_months
                        END,
            --date_end = case when @w_fixed_end_date = 1 
            --                then @w_due_date 
            --                else @w_date_end 
            --           end,
            grace_period=CASE
                         WHEN grace_period = 0 THEN grace_period
                             ELSE grace_period
                         END, 
            customer_code=CASE
                          WHEN customer_code
                             = '' THEN @p_customer_code
                              ELSE customer_code
                          END, 
            customer_group=CASE
                           WHEN customer_group
                              = '' THEN @p_customer_group
                               ELSE customer_group
                           END, 
            HeatIndexSourceID=@p_HeatIndexSourceID, 
            -- Project IT037
            HeatRate=@p_HeatRate -- Project IT037
            , 
            evergreen_option_id=CASE
                                WHEN @evergreen_option_id IS NULL THEN evergreen_option_id
                                    ELSE @evergreen_option_id
                                END -- IT021
            , 
            evergreen_commission_end=CASE
                                     WHEN @evergreen_commission_end IS NULL THEN evergreen_commission_end
                                         ELSE @evergreen_commission_end
                                     END -- IT021
            , 
            residual_option_id=CASE
                               WHEN @residual_option_id IS NULL THEN residual_option_id
                                   ELSE @residual_option_id
                               END -- IT021
            , 
            residual_commission_end=CASE
                                    WHEN @residual_commission_end IS NULL THEN residual_commission_end
                                        ELSE @residual_commission_end
                                    END -- IT021
            , 
            initial_pymt_option_id=CASE
                                   WHEN @initial_pymt_option_id IS NULL THEN initial_pymt_option_id
                                       ELSE @initial_pymt_option_id
                                   END -- IT021
            , 
            evergreen_commission_rate=CASE
                                      WHEN @evergreen_commission_rate IS NULL THEN evergreen_commission_rate
                                          ELSE @evergreen_commission_rate
                                      END -- IT021
        --,PriceID	= @PriceID -- IT106
          FROM deal_contract_account WITH (NOLOCK INDEX=deal_contract_account_idx)
          WHERE contract_nbr
              = @p_contract_nbr;
        PRINT 'DEBUG: from usp_contract_pricing_ins, just after updating deal_contract_account';

        IF @@error <> 0
            BEGIN
                SELECT @w_error='E';
                SELECT @w_msg_id='00000051';
                SELECT @w_return=1;
                SELECT @w_descp_add='(Account)';
                GOTO goto_select;
            END;
    END;
ELSE
    BEGIN
        UPDATE deal_contract_account
        SET contract_type=@w_contract_type, 
            retail_mkt_id=CASE
                          WHEN retail_mkt_id
                             = 'SELECT...' THEN 'NN'
                              ELSE @p_retail_mkt_id
                          END, 
            account_type=@p_account_type, 
            utility_id=CASE
                       WHEN utility_id
                          = 'SELECT...' THEN 'NONE'
                           ELSE @p_utility_id
                       END, 
            product_id=CASE
                       WHEN product_id
                          = 'SELECT...' THEN 'NONE'
                           ELSE @p_product_id
                       END, 
            rate_id=CASE
                    WHEN product_id
                       = 'SELECT...' THEN 999999999
                        ELSE @p_rate_id
                    END, 
            rate=@p_rate, 
            RatesString=@RatesString, 
            zone=@p_zone,
            --    contract_eff_start_date = @p_contract_eff_start_date,
            term_months=@w_term_months,
            --   date_end = case when @w_fixed_end_date = 1 then @w_due_date else @w_date_end end,
            grace_period=CASE
                         WHEN grace_period = 0 THEN @w_grace_period
                             ELSE grace_period
                         END, 
            customer_code=@p_customer_code, 
            customer_group=@p_customer_group, 
            HeatIndexSourceID=@p_HeatIndexSourceID, 
            -- Project IT037
            HeatRate=@p_HeatRate -- Project IT037
            , 
            evergreen_option_id=CASE
                                WHEN @evergreen_option_id IS NULL THEN evergreen_option_id
                                    ELSE @evergreen_option_id
                                END -- IT021
            , 
            evergreen_commission_end=CASE
                                     WHEN @evergreen_commission_end IS NULL THEN evergreen_commission_end
                                         ELSE @evergreen_commission_end
                                     END -- IT021
            , 
            residual_option_id=CASE
                               WHEN @residual_option_id IS NULL THEN residual_option_id
                                   ELSE @residual_option_id
                               END -- IT021
            , 
            residual_commission_end=CASE
                                    WHEN @residual_commission_end IS NULL THEN residual_commission_end
                                        ELSE @residual_commission_end
                                    END -- IT021
            , 
            initial_pymt_option_id=CASE
                                   WHEN @initial_pymt_option_id IS NULL THEN initial_pymt_option_id
                                       ELSE @initial_pymt_option_id
                                   END -- IT021
            , 
            evergreen_commission_rate=CASE
                                      WHEN @evergreen_commission_rate IS NULL THEN evergreen_commission_rate
                                          ELSE @evergreen_commission_rate
                                      END -- IT021
            , 
            PriceID=@PriceID -- IT106
          FROM deal_contract_account WITH (NOLOCK INDEX=deal_contract_account_idx)
          WHERE contract_nbr
              = @p_contract_nbr
            AND account_number
              = @p_account_number;

        IF @@error <> 0
        OR @@rowcount = 0
            BEGIN
                SELECT @w_error='E';
                SELECT @w_msg_id='00000051';
                SELECT @w_return=1;
                SELECT @w_descp_add='(Contract - Account)';
                GOTO goto_select;
            END;

    END;

/*
-- Mark custom rate as submitted
-- -----------------------------------------

-- IF Custom Rate no longer in use; release it 
if (select count(*) 
    from deal_pricing_detail 
	where product_id                            = @w_product_id 
    and rate_id                                     = @w_rate_id ) > 0 
begin
   declare @contr_count                             int 
   declare @acct_count                              int 

   select @contr_count                              = count(*) 
   from deal_contract 
   where product_id                                 = @w_product_id 
   and   rate_id                                    = @w_rate_id 
   and   contract_nbr                               = @p_contract_nbr

   select @acct_count                               = count(*) 
   from deal_contract_account 
   where product_id                                 = @w_product_id 
   and   rate_id                                    = @w_rate_id 
   and   contract_nbr                               = @p_contract_nbr
		
   if  @contr_count                                 = 0 
   and @acct_count                                  = 0
   begin 
	-- release the old rate 
      update deal_pricing_detail set rate_submit_ind = 0, 
                                     date_modified = getdate(), 
                                     modified_by = @p_username
      where product_id                              = @w_product_id 
      and   rate_id                                 = @w_rate_id
   end 
end

	-- mark the new rate
update deal_pricing_detail set rate_submit_ind = 1, 
                               date_modified = getdate(), 
                               modified_by = @p_username
where product_id                                    = @p_product_id 
and   rate_id                                       = @p_rate_id	

	
--end 
*/

-- per Douglas, date_deal will be the contracted date for custom pricing. 6/6/2007
------------------------------------
-- updating all records per contract
IF @p_contract_date IS NOT NULL
    BEGIN
        UPDATE deal_contract
        SET date_deal=@p_contract_date
          WHERE contract_nbr
              = @p_contract_nbr;

        UPDATE deal_contract_account
        SET date_deal=@p_contract_date
          WHERE contract_nbr
              = @p_contract_nbr;
    END;

-------------------

-----------------------------------------------------------------------------------------------------
--Sept 05 2013
--For Renewal Accounts we need to calculate the effective start date based on the meter Read Date from the current account
--Moving the logic from renewal page: lp_contract_renewal [dbo].[usp_contract_general_ins] 
--Work on this logic only for Renewals
--If the account is flowing it is considered to be a renewal
IF @p_account_number
 = 'CONTRACT'

    BEGIN


        DECLARE @AccountID char(12);
        DECLARE @AccountNumber varchar(50);
        DECLARE c_Accounts CURSOR
            FOR SELECT ca.account_id, 
                       ca.account_number
                  FROM Lp_deal_capture..deal_contract_account ca WITH (nolock)
                  WHERE ca.contract_nbr
                      = @p_contract_nbr;

        OPEN c_Accounts;

        FETCH NEXT FROM c_Accounts INTO @AccountID, @AccountNumber;

        WHILE @@FETCH_STATUS
            = 0
            BEGIN
                --if renewal get the date from meter Read and then update
                --Else If new Account then just update the same Effective Start Date and DateEnd
     
                --If account exists that could be a renewal
 DECLARE @w_account_date_start datetime;
  DECLARE @w_account_date_end datetime;
 
Set @w_account_date_start=(Select lp_deal_capture.dbo.ufn_GetMinStartDateforanAccount(@AccountID, @AccountNumber, @p_contract_eff_start_date, @p_utility_id))
                SET @w_account_date_end=DATEADD(month, @w_term_months, DATEADD(dd, -1, @w_account_date_start));

                                UPDATE Lp_deal_capture..deal_contract_account
                                SET contract_eff_start_date=@w_account_date_start, 
                                    date_end=CASE
                                             WHEN @w_fixed_end_date
                                                = 1 THEN @w_due_date
                                                 ELSE @w_account_date_end
                                             END
                                  WHERE contract_nbr
                                      = @p_contract_nbr
                                    AND account_number
                                      = @AccountNumber;

                FETCH NEXT FROM c_Accounts INTO @AccountID, @AccountNumber;
            END;
        CLOSE c_Accounts;
        DEALLOCATE c_Accounts;
    ------------------------------------------------------------------------------------------------------
    ------------------------------
    END;
ELSE
    BEGIN
        --if renewal get the date from meter Read and then update
        --Else If new Account then just update the same Effective Start Date and DateEnd
     
        --If account exists that could be a renewal

       DECLARE @w_account_date_start1 datetime;
  DECLARE @w_account_date_end1 datetime;
 
Set @w_account_date_start1=(Select lp_deal_capture.dbo.ufn_GetMinStartDateforanAccount(@AccountID, @AccountNumber, @p_contract_eff_start_date, @p_utility_id))
                        SET @w_account_date_end1=DATEADD(month, @w_term_months, DATEADD(dd, -1, @w_account_date_start1));

                        UPDATE Lp_deal_capture..deal_contract_account
                        SET contract_eff_start_date=@w_account_date_start1, 
                            date_end=CASE
                                     WHEN @w_fixed_end_date
                                        = 1 THEN @w_due_date
                                         ELSE @w_account_date_end1
                                     END
                          WHERE contract_nbr
                              = @p_contract_nbr
                            AND account_number
                              = @p_account_number;


    END;




SELECT @w_return=0;

goto_select:

IF @w_error <> 'N'
    BEGIN EXEC lp_common..usp_messages_sel @w_msg_id, @w_descp OUTPUT, @w_application;
        SELECT @w_descp=LTRIM(RTRIM(@w_descp)) + '' + @w_descp_add;
    END;

IF @p_result_ind
 = 'Y'
    BEGIN
        SELECT flag_error=@w_error, 
               code_error=@w_msg_id, 
               message_error=@w_descp;
        GOTO goto_return;
    END;

SELECT @p_error=@w_error, 
       @p_msg_id=@w_msg_id, 
       @p_descp=@w_descp;

goto_return:
RETURN @w_return;

SET NOCOUNT OFF;

GO


-------------------------------------------------------------
