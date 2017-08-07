-------------------------------------------------
--35625: Same Month Renewal
--------------------------------------------------------------

USE [LibertyPower];
GO

/****** Object:  Table [dbo].[OrdersAPIConfiguration]    Script Date: 05/14/2014 10:39:09 ******/

IF EXISTS(SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[OrdersAPIConfiguration]')
              AND type IN(N'U'))
    BEGIN
        DROP TABLE dbo.OrdersAPIConfiguration;
    END;
GO

USE [LibertyPower];
GO

/****** Object:  Table [dbo].[OrdersAPIConfiguration]    Script Date: 05/14/2014 10:39:09 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
/*******************************************************************************
* OrdersAPIConfiguration
* Table to have the Orders API Configurations
* Added configuration for Meter read calendar to use estimation based on previous year.
*
* History
*******************************************************************************
* 5/15/2014 Sara lakshmanan
* Created.
*******************************************************************************/

CREATE TABLE dbo.OrdersAPIConfiguration(OrdersAPIConfigurationID int IDENTITY(1, 1)
                                                                     NOT NULL, 
                                        UseEstimationforMeterReadCalendar bit NULL, 
                                        CONSTRAINT PK_OrdersAPIConfiguration PRIMARY KEY CLUSTERED(OrdersAPIConfigurationID ASC)
                                            WITH(PAD_INDEX=OFF, STATISTICS_NORECOMPUTE=OFF, IGNORE_DUP_KEY=OFF, ALLOW_ROW_LOCKS=ON, ALLOW_PAGE_LOCKS=ON, DATA_COMPRESSION=PAGE)ON [PRIMARY])
ON [PRIMARY];

GO



IF NOT EXISTS(SELECT *
                FROM LibertyPower..OrdersAPIConfiguration)
    BEGIN
        INSERT INTO LibertyPower..OrdersAPIConfiguration(UseEstimationforMeterReadCalendar)
        VALUES(1);

    END;
GO
--------------------------------------------------------------------



----------------------------------------------
USE LibertyPower;
GO

USE [LibertyPower];
GO

/****** Object:  View [dbo].[vw_Meter_read_calendar]    Script Date: 05/15/2014 09:48:30 ******/

IF EXISTS(SELECT *
            FROM sys.views
            WHERE object_id = OBJECT_ID(N'[dbo].[vw_Meter_read_calendar]'))
    BEGIN
        DROP VIEW dbo.vw_Meter_read_calendar;
    END;
GO

USE [LibertyPower];
GO

/****** Object:  View [dbo].[vw_Meter_read_calendar]    Script Date: 05/15/2014 09:48:30 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

/*******************************************************************************
* vw_Meter_read_calendar
* View to hold the calendar month is date time format
*
* History
*******************************************************************************
* 5/15/2014 Sara lakshmanan
* Created.
*******************************************************************************/

--//View to have (Read_Month_Date) dateformat for the calendar Year and Calendar MOnth
CREATE VIEW dbo.vw_Meter_read_calendar
AS SELECT calendar_year, 
          calendar_month, 
          utility_id, 
          read_cycle_id, 
          read_date, 
          read_date AS Read_End_date, 
          CAST(CAST(calendar_year AS varchar) + '/' + CAST(calendar_month AS varchar) + '/' + CAST('1' AS varchar)AS datetime)AS Read_Month_Date
     FROM LP_Common..meter_read_calendar M1 WITH (noLock);
 

GO


USE [LibertyPower];
GO

/****** Object:  View [dbo].[vw_Meter_read_calendar_with_StartandEndDates]    Script Date: 05/15/2014 09:48:56 ******/

IF EXISTS(SELECT *
            FROM sys.views
            WHERE object_id = OBJECT_ID(N'[dbo].[vw_Meter_read_calendar_with_StartandEndDates]'))
    BEGIN
        DROP VIEW dbo.vw_Meter_read_calendar_with_StartandEndDates;
    END;
GO

USE [LibertyPower];
GO

/****** Object:  View [dbo].[vw_Meter_read_calendar_with_StartandEndDates]    Script Date: 05/15/2014 09:48:56 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

/*******************************************************************************
* vw_Meter_read_calendar_with_StartandEndDates
* View to hold the Start and end meter read dates
*
* History
*******************************************************************************
* 5/15/2014 Sara lakshmanan
* Created.
*******************************************************************************/

--//View to have (Read_End_Date) i.e the (read_date-1) of the next month
--Drop  VIEW vw_Meter_read_calendar_Final
CREATE VIEW dbo.vw_Meter_read_calendar_with_StartandEndDates
AS SELECT *, 
          DATEADD(month, -1, Read_Month_Date)Start_Month, 
          (SELECT TOP 1 DATEADD(Day, 1, Read_End_date)
             FROM vw_Meter_read_calendar M WITH (noLock)
             WHERE M1.Read_Month_Date = DATEADD(month, 1, m.Read_Month_Date)
               AND M1.utility_id = M.utility_id
               AND M1.read_cycle_id = M.read_cycle_id)AS Read_Start_Date
     FROM vw_Meter_read_calendar m1;
 

GO



  
-------------------------------------
USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetBillingCycleAfter]    Script Date: 05/14/2014 10:48:24 ******/

IF EXISTS(SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetBillingCycleAfter]')
              AND type IN(N'P', N'PC'))
    BEGIN
        DROP PROCEDURE dbo.usp_GetBillingCycleAfter;
    END;
GO

USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetBillingCycleAfter]    Script Date: 05/14/2014 10:48:24 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


/*******************************************************************************
* usp_GetBillingCycleAfter
* Get the billing Cycle Date After the given DAte
*
* History
*******************************************************************************
* 5/15/2014 Sara lakshmanan
* Created.
*******************************************************************************/


--exec usp_GetBillingCycleAfter 'CENHUD','02','7/14/2013', 1
CREATE PROCEDURE dbo.usp_GetBillingCycleAfter(@Utility_id varchar(10), 
                                              @read_cycle_id varchar(10), 
                                              @given_date datetime)
AS

--Script to fetch the meter read_cycle After a given Date
BEGIN

    SET NOCOUNT ON;

    DECLARE @UseEstimation bit=1;
    SET @UseEstimation=(SELECT ISNULL(UseEstimationforMeterReadCalendar, 1)
                          FROM Libertypower..OrdersAPIConfiguration WITH (NOLOCK));


    --DECLARE @Utility_id varchar(20);
    DECLARE @read_cycle_id_modified varchar(20);
    --DECLARE @given_date datetime;

    --SET @Utility_id='CENHUD';
    SET @read_cycle_id_modified=@read_cycle_id;
    --SET @given_date='7/15/2012';
    
    
    --Identifying the read_date by matching the read_cyle, utility
    --and find MeterReadDate after the given Date , so read_date> given_date
    --and (Since the data in the table is not continuous for all the years,
    -- we are doing an additional check, so that the MeterReadMonth is +/- 1 month from the given month).

    --If date exists for this year then get it
    --Else find the meter read Day for last year and Use for the current year

    IF ISNUMERIC(@read_cycle_id_modified) = 1
        BEGIN
            SET @read_cycle_id_modified=RTRIM(LTRIM(@read_cycle_id_modified));
            IF LEN(@read_cycle_id_modified) = 1
                BEGIN
                    SET @read_cycle_id_modified=RIGHT(RTRIM(STR(100 + CONVERT(int, @read_cycle_id_modified))), 2);
                END;
        END;

    SELECT TOP 1 * INTO #TEMP
      FROM vw_Meter_read_calendar_with_StartandEndDates
      WHERE Read_start_date > @given_date
        AND (read_cycle_id = @read_cycle_id
          OR read_cycle_id = @read_cycle_id_modified)
        AND utility_id = @Utility_id
        AND Read_Month_Date BETWEEN DATEADD(MOnth, -2, @given_date)AND DATEADD(MOnth, 2, @given_date)
      ORDER BY Read_start_date;
    IF @@ROWCOUNT = 0
        BEGIN
            IF @UseEstimation = 1
                BEGIN
                    INSERT INTO #TEMP
                    SELECT TOP 1 calendar_year, 
                                 calendar_month, 
                                 utility_id, 
                                 read_cycle_id, 
                                 DATEADD(Year, 1, read_date)AS read_date, 
                                 DATEADD(Year, 1, Read_End_date)AS Read_End_date, 
                                 DATEADD(Year, 1, Read_Month_Date)AS Read_Month_Date, 
                                 DATEADD(Year, 1, Start_Month)AS Start_Month, 
                                 DATEADD(Year, 1, Read_Start_Date)AS Read_Start_Date
                      FROM vw_Meter_read_calendar_with_StartandEndDates
                      WHERE Read_start_date > DATEADD(yy, -1, @given_date)
                        AND (read_cycle_id = @read_cycle_id
                          OR read_cycle_id = @read_cycle_id_modified)
                        AND utility_id = @Utility_id
                        AND Read_Month_Date BETWEEN DATEADD(MOnth, -2, DATEADD(yy, -1, @given_date))AND DATEADD(MOnth, 2, DATEADD(yy, -1, @given_date))
                      ORDER BY Read_start_date;
                END;

        END;

    IF(SELECT COUNT(1)
         FROM #TEMP) > 0
        BEGIN
            SELECT *
              FROM #TEMP;
        END;

    DROP TABLE #TEMP;




    SET NOCOUNT OFF;

END;



GO



---------------------------------------------------------------------------------------------
USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetBillingCycleContaining]    Script Date: 05/14/2014 10:48:38 ******/

IF EXISTS(SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetBillingCycleContaining]')
              AND type IN(N'P', N'PC'))
    BEGIN
        DROP PROCEDURE dbo.usp_GetBillingCycleContaining;
    END;
GO

USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetBillingCycleContaining]    Script Date: 05/14/2014 10:48:38 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO



/*******************************************************************************
* usp_GetBillingCycleContaining
* Get the billing Cycle Containing the given Date
*
* History
*******************************************************************************
* 5/15/2014 Sara lakshmanan
* Created.
*******************************************************************************/


--exec GetBillingCycleContaining 'CENHUD','02','7/14/2013', 1
CREATE PROCEDURE dbo.usp_GetBillingCycleContaining(@Utility_id varchar(10), 
                                                   @read_cycle_id varchar(10), 
                                                   @given_date datetime)
AS

--Script to fetch the meter read_cycle After a given Date
BEGIN
    SET NOCOUNT ON;
    --DECLARE @Utility_id varchar(20);
    DECLARE @read_cycle_id_modified varchar(20);
    --DECLARE @given_date datetime;

    --SET @Utility_id='CENHUD';
    SET @read_cycle_id_modified=@read_cycle_id;
    --SET @given_date='7/15/2012';

    DECLARE @UseEstimation bit=1;
    SET @UseEstimation=(SELECT ISNULL(UseEstimationforMeterReadCalendar, 1)
                          FROM Libertypower..OrdersAPIConfiguration WITH (NOLOCK));
    
    --Identifying the read_date by matching the read_cyle, utility
    --and find the meter read that has this date i.e. given Date should be between Read Start and Read EndDates
    --and (Since the data in the table is not continuous for all the years,
    -- we are doing an additional check, so that the MeterReadMonth is +/- 1 month from the given month).

    --If date exists for this year then get it
    --Else find the meter read Day for last year and Use for the current year


    IF ISNUMERIC(@read_cycle_id_modified) = 1
        BEGIN
            SET @read_cycle_id_modified=RTRIM(LTRIM(@read_cycle_id_modified));
            IF LEN(@read_cycle_id_modified) = 1
                BEGIN
                    SET @read_cycle_id_modified=RIGHT(RTRIM(STR(100 + CONVERT(int, @read_cycle_id_modified))), 2);
                END;
        END;

    SELECT TOP 1 * INTO #TEMP
      FROM vw_Meter_read_calendar_with_StartandEndDates
      WHERE @given_date >= Read_Start_Date
        AND @given_date <= Read_End_Date
        AND (read_cycle_id = @read_cycle_id
          OR read_cycle_id = @read_cycle_id_modified)
        AND utility_id = @Utility_id
        AND Read_Month_Date BETWEEN DATEADD(MOnth, -2, @given_date)AND DATEADD(MOnth, 2, @given_date)
      ORDER BY Read_start_date;

    IF @@ROWCOUNT = 0
        BEGIN
            IF @UseEstimation = 1
                BEGIN
                    INSERT INTO #TEMP
                    SELECT TOP 1 calendar_year, 
                                 calendar_month, 
                                 utility_id, 
                                 read_cycle_id, 
                                 DATEADD(Year, 1, read_date)AS read_date, 
                                 DATEADD(Year, 1, Read_End_date)AS Read_End_date, 
                                 DATEADD(Year, 1, Read_Month_Date)AS Read_Month_Date, 
                                 DATEADD(Year, 1, Start_Month)AS Start_Month, 
                                 DATEADD(Year, 1, Read_Start_Date)AS Read_Start_Date
                      FROM vw_Meter_read_calendar_with_StartandEndDates
                      WHERE DATEADD(yy, -1, @given_date) >= Read_Start_Date
                        AND DATEADD(yy, -1, @given_date) <= Read_End_Date
                        AND (read_cycle_id = @read_cycle_id
                          OR read_cycle_id = @read_cycle_id_modified)
                        AND utility_id = @Utility_id
                        AND Read_Month_Date BETWEEN DATEADD(MOnth, -2, DATEADD(yy, -1, @given_date))AND DATEADD(MOnth, 2, DATEADD(yy, -1, @given_date))
                      ORDER BY Read_start_date;
                END;

        END;

    IF(SELECT COUNT(1)
         FROM #TEMP) > 0
        BEGIN
            SELECT *
              FROM #TEMP;
        END;

    DROP TABLE #TEMP;


    SET NOCOUNT OFF;

END;

GO



----------------------------------------------------------------------------

USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetBillingCycleStartDate]    Script Date: 05/14/2014 10:49:07 ******/

IF EXISTS(SELECT *
            FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetBillingCycleStartDate]')
              AND type IN(N'P', N'PC'))
    BEGIN
        DROP PROCEDURE dbo.usp_GetBillingCycleStartDate;
    END;
GO

USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_GetBillingCycleStartDate]    Script Date: 05/14/2014 10:49:07 ******/

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

/*******************************************************************************
* usp_GetBillingCycleStartDate
* Get the billing Cycle Start Date
*
* History
*******************************************************************************
* 5/15/2014 Sara lakshmanan
* Created.
*******************************************************************************/

--exec usp_GetBillingCycleStartDate 'CENHUD','02','7/14/2013', 1
CREATE PROCEDURE dbo.usp_GetBillingCycleStartDate(@Utility_id varchar(10), 
                                                  @AccountNumber varchar(50), 
                                                  @given_date datetime)
AS

--Script to fetch the meter read_cycle Start Date for a given MOnth
BEGIN

    SET NOCOUNT ON;
    --DECLARE @Utility_id varchar(20);
    DECLARE @read_cycle_id varchar(20);
    DECLARE @read_cycle_id_modified varchar(20);

    DECLARE @UseEstimation bit=1;
    SET @UseEstimation=(SELECT ISNULL(UseEstimationforMeterReadCalendar, 1)
                          FROM Libertypower..OrdersAPIConfiguration WITH (NOLOCK));
    --DECLARE @given_date datetime;

    --SET @Utility_id='CENHUD';
    --SET @read_cycle_id='02';
    --SET @given_date='7/15/2012';
    
    
    --Identifying the read_date by matching the read_cyle, utility
    --startMonth= given date
    --and (Since the data in the table is not continuous for all the years,
    -- we are doing an additional check, so that the MeterReadMonth is +/- 1 month from the given month).

    --If date exists for this year then get it
    --Else find the meter read Day for last year and Use for the current year

    SET @read_cycle_id=(SELECT TOP 1 BillingGroup
                          FROM LibertyPower..Account A WITH (NoLOCK)
                               INNER JOIN LIbertyPower..utility U WITH (NoLock)
                               ON A.UtilityID = U.ID
                          WHERE U.UtilityCode = @Utility_id
                            AND A.AccountNumber = @AccountNumber);

    SET @read_cycle_id_modified=@read_cycle_id;

    IF ISNUMERIC(@read_cycle_id_modified) = 1
        BEGIN
            SET @read_cycle_id_modified=RTRIM(LTRIM(@read_cycle_id_modified));
            IF LEN(@read_cycle_id_modified) = 1
                BEGIN
                    SET @read_cycle_id_modified=RIGHT(RTRIM(STR(100 + CONVERT(int, @read_cycle_id_modified))), 2);
                END;
        END;

    SELECT TOP 1 * INTO #TEMP
      FROM vw_Meter_read_calendar_with_StartandEndDates
      WHERE CONVERT(varchar(10), Start_Month, 101) = CONVERT(varchar(10), @given_date, 101)
        AND (read_cycle_id = @read_cycle_id
          OR read_cycle_id = @read_cycle_id_modified)
        AND utility_id = @Utility_id
      ORDER BY Read_start_date;

    IF @@ROWCOUNT = 0
        BEGIN
            IF @UseEstimation = 1
                BEGIN
                    INSERT INTO #TEMP
                    SELECT TOP 1 calendar_year, 
                                 calendar_month, 
                                 utility_id, 
                                 read_cycle_id, 
                                 DATEADD(Year, 1, read_date)AS read_date, 
                                 DATEADD(Year, 1, Read_End_date)AS Read_End_date, 
                                 DATEADD(Year, 1, Read_Month_Date)AS Read_Month_Date, 
                                 DATEADD(Year, 1, Start_Month)AS Start_Month, 
                                 DATEADD(Year, 1, Read_Start_Date)AS Read_Start_Date
                      FROM vw_Meter_read_calendar_with_StartandEndDates
                      WHERE CONVERT(varchar(10), Start_Month, 101) = CONVERT(varchar(10), DATEADD(yy, -1, @given_date), 101)
                        AND (read_cycle_id = @read_cycle_id
                          OR read_cycle_id = @read_cycle_id_modified)
                        AND utility_id = @Utility_id
                      ORDER BY Read_start_date;
                END;

        END;

    IF(SELECT COUNT(1)
         FROM #TEMP) > 0
        BEGIN
            SELECT *
              FROM #TEMP;
        END;

    DROP TABLE #TEMP;

    SET NOCOUNT OFF;

END;


GO




----------------------------------------------------------------------------------------------------


USE [LibertyPower];
GO

/****** Object:  StoredProcedure [dbo].[usp_AccountByAccountIdSelect]    Script Date: 05/14/2014 09:12:34 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/*******************************************************************************
* usp_AccountByAccountIdSelect
* Get account data by account id
*
* History
*******************************************************************************
* 5/27/2009 - Rick Deigsler
* Created.
*******************************************************************************
* 1/22/2010 - Eric Hernandez
* Modified code so that it can find an account by the new or legacy account ID.
*******************************************************************************
* 5/17/2011 - Sofia Melo
* Added field usage_req_status to select clause
*******************************************************************************
* 1/24/2012 - Jaime Forero
* Refactored for IT79 new db schema
*******************************************************************************
*******************************************************************************
* 1/31/2012 - Rick Deigsler
* Modified to pull most recent annual usage
* SR 1-58076132 - Was not returning record if account usage date did not match contract date
*******************************************************************************
* 5/20/2013 - Agata Studzinska
* SR 1-94847241 
* Modified to pull most recent rate
*******************************************************************************
* 5/14/2014
* PBi: 35625 , Same Month renewal
* added  EnrollmentLeadDays to select list
*******************************************************************************
TEST CASES:
First we need to find some dummy Acount ids:
SELECT TOP(100) * FROM LibertyPower..Account WHERE CurrentContractId IS NOT NULL
EXEC LibertyPOwer..[usp_AccountByAccountIdSelect] '2007-0017633'
EXEC LibertyPOwer..[usp_AccountByAccountIdSelect] 077852004
*/

ALTER PROCEDURE dbo.usp_AccountByAccountIdSelect @AccountId char(12)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
/*
	Removed as part of the IT79 refactor, left here as reference -- Jaime    
    -- This next line was added so that the stored proc can accept both the legacy and newere Account IDs.
    -- Note that the legacy account_id is not numeric.
    IF ISNUMERIC(@AccountId) = 0
		SELECT @AccountId = AccountID FROM lp_account.dbo.account WHERE account_id = @AccountId

	SELECT	DISTINCT 
			a.AccountID
			, a.account_id AS LegacyAccountId
			, account_number AS AccountNumber
			, a.por_option --added for INF82
			, AccountType = CASE WHEN account_type = 'SOHO' THEN 'SOHO' ELSE UPPER(LEFT(account_type, 3)) END
			, annual_usage AS AnnualUsage
			, contract_nbr AS ContractNumber
			, contract_type AS ContractType
			, contract_eff_start_date AS ContractStartDate
			, date_end AS ContractEndDate
			, date_flow_start AS FlowStartDate, term_months AS Term, date_deenrollment AS DeenrollmentDate
			, utility_id AS UtilityCode, product_id AS ProductId, rate, rate_id AS RateId
			, a.icap AS Icap
			, a.tcap AS Tcap
			, billing_group AS BillCycleID			
			, retail_mkt_id AS RetailMarketCode
			, a.zone As ZoneCode
			, service_rate_class AS RateClass
			, a.rate_code as RateCode
			, a.load_profile as LoadProfile
			, ISNULL(AW.WaiveEtf,0) AS WaiveEtf
			, AW.WaivedEtfReasonCodeID
			, ISNULL(AW.IsOutgoingDeenrollmentRequest,0) AS IsOutgoingDeenrollmentRequest
			, [status] AS EnrollmentStatus, [sub_status] AS EnrollmentSubStatus
			, account_name.full_name As BusinessName, date_submit AS DateSubmit, date_deal AS DateDeal,
			 sales_channel_role AS SalesChannelId, sales_rep AS SalesRep 
			 ,AW.CurrentEtfID
			 ,(SELECT dbo.ufn_EtfGetZoneAndClassFromProduct (a.AccountID)) AS PricingZoneAndClass	 
			 ,a.credit_agency, a.credit_score		 
			 ,a.usage_req_status--added for ticket 21650	 
			 ,a.billing_Type as BillingType -- CKE added for Ticket 1-3507461			 
	FROM	lp_account..account a WITH (NOLOCK)
		LEFT JOIN lp_account..account_additional_info i WITH (NOLOCK) ON a.account_id = i.account_id
		LEFT OUTER JOIN LibertyPower..AccountEtfWaive AW ON a.AccountID = AW.AccountID 
		LEFT OUTER JOIN lp_account..account_name WITH (NOLOCK) 
			ON account_name.account_id = a.account_id AND account_name.name_link = a.customer_name_link	
	WHERE a.AccountID = @AccountID
	*/

    -- ***********************************************************************************
    -- IT79 Refactored Code Start
    DECLARE @INT_AccountID int; -- this is to avoid casting delays
	
    -- This next line was added so that the stored proc can accept both the legacy and newere Account IDs.
    -- Note that the legacy account_id is not numeric.
    IF ISNUMERIC(@AccountId) = 0
        BEGIN
            SELECT @INT_AccountID=AccountID
              FROM LibertyPower.dbo.Account
              WHERE AccountIdLegacy = @AccountId;
        END;
    ELSE
        BEGIN
            SET @INT_AccountID=CAST(@AccountId AS int);
        END;

    SELECT DISTINCT A.AccountID, 
                    A.AccountIdLegacy AS LegacyAccountId, 
                    A.AccountNumber AS AccountNumber, 
                    CASE
                    WHEN A.PorOption = 1 THEN 'YES'
                    WHEN A.PorOption = 0 THEN 'NO'
                        ELSE NULL
                    END AS por_option --added for INF82
                    , 
                    AT.AccountType -- AccountType = CASE WHEN account_type = 'SOHO' THEN 'SOHO' ELSE UPPER(LEFT(account_type, 3)) END
                    , 
                    ISNULL(USAGE.AnnualUsage, (SELECT TOP 1 ISNULL(AnnualUsage, 0)
                                                 FROM LibertyPower..AccountUsage WITH (NOLOCK)
                                                 WHERE AccountID = A.AccountID
                                                 ORDER BY EffectiveDate DESC))AS AnnualUsage, 
                    C.Number AS ContractNumber, 
                    LibertyPower.dbo.ufn_GetLegacyContractType(CT.Type, CTT.ContractTemplateTypeID, CDT.DealType)AS ContractType, 
                    CASE
                    WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateStart
                        ELSE AC_DefaultRate.RateStart
                    END AS ContractStartDate, 
                    CASE
                    WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateEnd
                        ELSE AC_DefaultRate.RateEnd
                    END AS ContractEndDate, 
                    LibertyPower.dbo.ufn_GetLegacyFlowStartDate(ACS.Status, ACS.SubStatus, ASERVICE.StartDate)AS FlowStartDate, 
                    CASE
                    WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Term
                        ELSE AC_DefaultRate.Term
                    END AS Term, 
                    LibertyPower.dbo.ufn_GetLegacyDateDeenrollment(ACS.Status, ACS.SubStatus, ASERVICE.EndDate)AS DeenrollmentDate, 
                    U.UtilityCode AS UtilityCode, 
                    CASE
                    WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.LegacyProductID
                        ELSE AC_DefaultRate.LegacyProductID
                    END AS ProductId, 
                    CASE
                    WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.Rate
                        ELSE AC_DefaultRate.Rate
                    END AS rate, 
                    CASE
                    WHEN AC_DefaultRate.AccountContractRateID IS NULL THEN ACR2.RateID
                        ELSE AC_DefaultRate.RateID
                    END AS RateID, 
                    A.icap AS Icap, 
                    A.tcap AS Tcap, 
                    A.BillingGroup AS BillCycleID, 
                    M.MarketCode AS RetailMarketCode, 
                    A.Zone AS ZoneCode, 
                    A.ServiceRateClass AS RateClass, 
                    ACR2.RateCode, 
                    A.LoadProfile, 
                    ISNULL(AW.WaiveEtf, 0)AS WaiveEtf, 
                    AW.WaivedEtfReasonCodeID, 
                    ISNULL(AW.IsOutgoingDeenrollmentRequest, 0)AS IsOutgoingDeenrollmentRequest, 
                    LibertyPower.dbo.ufn_GetLegacyAccountStatus(ACS.Status, ACS.SubStatus)AS EnrollmentStatus, 
                    LibertyPower.dbo.ufn_GetLegacyAccountSubStatus(ACS.Status, ACS.SubStatus)AS EnrollmentSubStatus, 
                    CUST_NAME.Name AS BusinessName, 
                    C.SubmitDate AS DateSubmit, 
                    C.SignedDate AS DateDeal, 
                    'SALES CHANNEL/' + SC.ChannelName AS SalesChannelId, 
                    C.SalesRep AS SalesRep, 
                    AW.CurrentEtfID, 
                    '' AS PricingZoneAndClass --LibertyPower.dbo.ufn_EtfGetZoneAndClassFromProduct (A.AccountID) AS PricingZoneAndClass
                    , 
                    CASE
                    WHEN CA.Name IS NULL THEN 'NONE'
                        ELSE UPPER(CA.Name)
                    END AS credit_agency, 
                    CAST(0 AS int)AS credit_score, 
                    CASE
                    WHEN UPPER(URS.Status) = 'NONE' THEN NULL
                        ELSE UPPER(URS.Status)
                    END AS usage_req_status --added for ticket 21650
                    , 
                    BILLTYPE.Type AS BillingType -- CKE added for Ticket 1-3507461
                    , 
                    A.DeliveryLocationRefID, 
                    AC.SettlementLocationRefID, 
                    A.LoadProfileRefId, 
                    A.ServiceClassRefID, 
                    U.EnrollmentLeadDays--added 5/14/2014
			
      FROM LibertyPower..Account A WITH (NOLOCK)
           JOIN LibertyPower..Customer CUST WITH (NOLOCK)
           ON A.CustomerID = CUST.CustomerID
           JOIN LibertyPower..AccountType AT WITH (NOLOCK)
           ON A.AccountTypeID = AT.ID
           JOIN LibertyPower..AccountContract AC WITH (NOLOCK)
           ON A.CurrentContractID = AC.ContractID
          AND A.AccountId = AC.AccountID -- current/lasdt contract
           JOIN LibertyPower..Contract C WITH (NOLOCK)
           ON A.CurrentContractID = C.ContractID
           JOIN LibertyPower.dbo.AccountStatus ACS WITH (NOLOCK)
           ON AC.AccountContractID = ACS.AccountContractID
           JOIN LibertyPower.dbo.ContractType CT WITH (NOLOCK)
           ON C.ContractTypeID = CT.ContractTypeID
           JOIN LibertyPower.dbo.ContractTemplateType CTT WITH (NOLOCK)
           ON C.ContractTemplateID = CTT.ContractTemplateTypeID
           JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK)
           ON AC.AccountContractID = ACR2.AccountContractID --AND ACR2.IsContractedRate = 1
           JOIN LibertyPower.dbo.Utility U WITH (NOLOCK)
           ON A.UtilityID = U.ID
           JOIN LibertyPower.dbo.Market M WITH (NOLOCK)
           ON A.RetailMktID = M.ID
           LEFT JOIN LibertyPower..AccountUsage USAGE WITH (NOLOCK)
           ON A.AccountID = USAGE.ACcountID
          AND USAGE.EffectiveDate = C.StartDate
           LEFT JOIN LibertyPower.dbo.UsageReqStatus URS WITH (NOLOCK)
           ON USAGE.UsageReqStatusID = URS.UsageReqStatusID
           LEFT JOIN LibertyPower..Name CUST_NAME WITH (NOLOCK)
           ON CUST_NAME.NameID = CUST.NameID
           LEFT JOIN LibertyPower.dbo.SalesChannel SC WITH (NOLOCK)
           ON C.SalesChannelID = SC.ChannelID --LEFT	JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK) 
    --ON		AC.AccountContractID = AC_DefaultRate.AccountContractID AND AC_DefaultRate.IsContractedRate = 0 -- temporary measure, should be changed later

    -- 1-94847241
    -- NEW DEFAULT RATE JOIN:  
           LEFT JOIN(SELECT MAX(ACRR.AccountContractRateID)AS AccountContractRateID, 
                            ACRR.AccountContractID
                       FROM LibertyPower.dbo.AccountContractRate ACRR WITH (NOLOCK)
                       WHERE ACRR.IsContractedRate = 0
                       GROUP BY ACRR.AccountContractID)ACRR2
           ON ACRR2.AccountContractID = AC.AccountContractID
           LEFT JOIN LibertyPower.dbo.AccountContractRate AC_DefaultRate WITH (NOLOCK)
           ON ACRR2.AccountContractRateID = AC_DefaultRate.AccountContractRateID -- END NEW DEFAULT RATE JOIN: 
           LEFT JOIN LibertyPower.dbo.CreditAgency CA WITH (NOLOCK)
           ON CUST.CreditAgencyID = CA.CreditAgencyID
           LEFT JOIN LibertyPower.dbo.ContractDealType CDT WITH (NOLOCK)
           ON C.ContractDealTypeID = CDT.ContractDealTypeID
           LEFT JOIN LibertyPower.dbo.BillingType BILLTYPE WITH (NOLOCK)
           ON A.BillingTypeID = BILLTYPE.BillingTypeID
           LEFT JOIN LibertyPower..AccountEtfWaive AW WITH (NOLOCK)
           ON A.AccountId = AW.AccountID
           LEFT JOIN lp_account..account_additional_info i WITH (NOLOCK)
           ON A.AccountIdLegacy = i.account_id
           LEFT JOIN LibertyPower.dbo.AccountLatestService ASERVICE WITH (NOLOCK)
           ON A.AccountID = ASERVICE.AccountID
	
/*LEFT	JOIN (
			select	account_id, StartDate, EndDate, ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY StartDate DESC, EndDate DESC) AS rownum
			from		Libertypower.dbo.AccountService (NOLOCK)
				) ASERVICE 
	ON		A.AccountIdLegacy = ASERVICE.account_id 
	AND		ASERVICE.rownum = 1
	*/
	
      --LEFT	JOIN LibertyPower.dbo.PropertyInternalRef PIR WITH (NOLOCK) 
      --ON		A.DeliveryLocationID = PIR.ID
	
      --LEFT	JOIN LibertyPower.dbo.PropertyInternalRef PIR WITH (NOLOCK) 
      --ON		A.SettlementLocationID = PIR.ID
	
      WHERE A.AccountID = @INT_AccountID;
    -- IT79 Refactored Code End
    -- ***********************************************************************************

    SET NOCOUNT OFF;
END; 
GO                                                                                                                                             
-- Copyright 2009 Liberty Power

-------------------------------------------------------------------------------------------------
