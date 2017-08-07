
CREATE PROCEDURE [dbo].[usp_AccountByAccountNumberUtilityListSelect]
       @AccountNumberList varchar(4000) ,
       @UtilityCodeList varchar(4000)
AS
BEGIN
      SET NOCOUNT ON ;

      DECLARE
              @pos int ,
              @pos2 int ,
              @CurAccount varchar(100) ,
              @CurUtility varchar(50) ;
	

      SET @pos = 0 ;

      DECLARE @tempAccountsTable TABLE
      (
        accountNumber varchar(100) ,
        utilityCode varchar(50) )
      WHILE CHARINDEX(',' , @AccountNumberList) > 0
            BEGIN
                  SET @pos = CHARINDEX(',' , @AccountNumberList) ;
                  SET @CurAccount = RTRIM(SUBSTRING(@AccountNumberList , 1 , @pos - 1)) ;

                  SET @pos2 = CHARINDEX(',' , @UtilityCodeList) ;
                  SET @CurUtility = RTRIM(SUBSTRING(@UtilityCodeList , 1 , @pos2 - 1)) ;


                  INSERT INTO
                      @tempAccountsTable
                      (
                        accountNumber , utilityCode )
                  VALUES
                      (
                        @CurAccount , @CurUtility ) ;
                  SET @AccountNumberList = SUBSTRING(@AccountNumberList , @pos + 1 , 4000) ;
                  SET @UtilityCodeList = SUBSTRING(@UtilityCodeList , @pos2 + 1 , 4000) ;
            END

  SELECT DISTINCT
          a.AccountID , a.account_id AS LegacyAccountId ,  
          a.por_option,  --added for INF82
          account_number AS AccountNumber , UPPER(LEFT(account_type , 3)) AS AccountType , 
          annual_usage AS AnnualUsage , contract_nbr AS ContractNumber , contract_type AS ContractType , 
          contract_eff_start_date AS ContractStartDate , 
          date_end AS ContractEndDate , date_flow_start AS FlowStartDate , 
          term_months AS Term , date_deenrollment AS DeenrollmentDate , utility_id AS UtilityCode , 
          product_id AS ProductId , rate , rate_id AS RateId , 
		  a.icap AS Icap,
	 	  a.tcap AS Tcap ,
          billing_group AS BillCycleID , retail_mkt_id AS RetailMarketCode , 
          a.zone AS ZoneCode , service_rate_class AS RateClass , ISNULL(AW.WaiveEtf , 0) AS WaiveEtf , 
          AW.WaivedEtfReasonCodeID , 
          ISNULL(AW.IsOutgoingDeenrollmentRequest , 0) AS IsOutgoingDeenrollmentRequest , 
          [status] AS EnrollmentStatus , [sub_status] AS EnrollmentSubStatus , 
          account_name.full_name AS BusinessName , date_submit AS DateSubmit , 
          date_deal AS DateDeal , sales_channel_role AS SalesChannelId , sales_rep AS SalesRep , AW .CurrentEtfID ,
         ( SELECT dbo.ufn_EtfGetZoneAndClassFromProduct(a.AccountID) ) AS PricingZoneAndClass , a.credit_agency , a.credit_score
         ,  a.billing_Type as BillingType -- CKE added for Ticket 1-3507461 
      FROM		lp_account..account a WITH ( NOLOCK )
      LEFT JOIN lp_account..account_additional_info i WITH ( NOLOCK ) ON  a.account_id = i.account_id
      LEFT JOIN LibertyPower..AccountEtfWaive AW ON  a.AccountID = AW.AccountID
      LEFT JOIN lp_account..account_name WITH ( NOLOCK ) ON  account_name.account_id = a.account_id AND account_name.name_link = a.customer_name_link
		   JOIN @tempAccountsTable T ON  a.account_number = T.accountNumber AND utility_id = T.utilityCode 
		   




      SET NOCOUNT OFF ;
END                                                                                                                                              
-- Copyright 2010 Liberty Power
