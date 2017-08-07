-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Created by Lev Rosenblum 
-- Created date: <1/30/2013>
-- Add Records To ServicePriocessing Table At Reenrollment [task 4700 (PBI1004)]
-- =============================================
CREATE PROCEDURE [dbo].[usp_AddRecordsToServiceProcessingTableAtReenrollment] 
(
	@NumberDaysAfterMeterDateToIstaSubmission int
	, @UserId int
	, @AccountContractRateId int
	, @DefaultLeadTimePeriod int=5	--applied to accounts having BillingTypeID=3 and missing LeadTime in our table
	, @StandardLeadTimePeriod int=0 --applied to accounts having BillingTypeID!=3

)
AS

DECLARE @IsMultiTerm bit
SET @IsMultiTerm=1;

DECLARE @ApprovedContractStatusID int
DECLARE @ReEnrollmentAccountContractStatusNumber varchar(15)
, @ReEnrollmentAccountContractSubStatusNumber varchar(15);

SET @ApprovedContractStatusID=3 --'APPROVED'
SET @ReEnrollmentAccountContractStatusNumber='13000'--'Re-enrolled'
SET @ReEnrollmentAccountContractSubStatusNumber='80'--'Re-enrolled'

BEGIN

INSERT INTO dbo.MultiTermWinServiceData
(LeadTime, StartToSubmitDate, ToBeExpiredAccountContactRateId, MeterReadDate, NewAccountContractRateId, MultiTermWinServiceStatusId, DateCreated, CreatedBy) 

SELECT  
	(SELECT (Case WHEN a.BillingTypeID!=3 THEN @StandardLeadTimePeriod 
					WHEN a.BillingTypeID=3 and lp_urlt.LeadTime IS NULL THEN @DefaultLeadTimePeriod 
					ELSE lp_urlt.LeadTime END) as LeadTime
		FROM  LibertyPower..Utility lp_u 
			Left Outer Join LibertyPower..UtilityRateLeadTime lp_urlt
			ON lp_urlt.UtilityID=lp_u.ID
		WHERE lp_u.ID=a.UtilityID
		) as LeadTime
	, DATEADD(d, @NumberDaysAfterMeterDateToIstaSubmission, IsNull(lp_c_mrc.read_date,acr.RateEnd)) as StartToSubmitDate
	, acr.AccountContractRateID as ToBeExpiredAccountContactRateId
	
	, IsNull(lp_c_mrc.read_date,acr.RateEnd) as MeterRateEndDate
	
	, (	SELECT AccountContractRateID
		FROM LibertyPower..AccountContractRate lpACR
		WHERE lpACR.AccountContractID=ac.AccountContractID
		and lpACR.RateStart=DATEADD(d,1,acr.RateEnd)
		) as NewAccountContractRateId
	, 3 as MultiTermWinServiceStatusId
	, Convert(DateTime,Convert(char(10),GETDATE(),101)) as CurrDate
	, @UserId as UserId
	
FROM LibertyPower..Account a 
	INNER JOIN LibertyPower..Utility u with(nolock)
		on u.ID=a.UtilityID
	INNER JOIN LibertyPower..AccountContract ac with(nolock)
		on a.AccountID=ac.AccountID
	INNER JOIN LibertyPower..[Contract] c with(nolock)
		on c.ContractID=ac.ContractID
	INNER JOIN LibertyPower..AccountStatus accsts with(nolock)
		on accsts.AccountContractID=ac.AccountContractID 
	INNER JOIN LibertyPower..AccountContractRate acr with(nolock)
		on ac.AccountContractID = acr.AccountContractID
	INNER JOIN LibertyPower..Price p with(nolock)
		on p.ID=acr.PriceID
	INNER JOIN LibertyPower..ProductBrand pb with(nolock)
		ON pb.ProductBrandID=p.ProductBrandID
	INNER JOIN LibertyPower..ProductType pt with(nolock)
		ON pt.ProductTypeID=pb.ProductTypeID
	LEFT OUTER JOIN 
		(
			--Select just unique read_date per read_cycle_id, utility_id, calendar_month, calendar_year combination
			SELECT MAX(read_date) as read_date, read_cycle_id, utility_id, calendar_month, calendar_year
			FROM Lp_common.dbo.meter_read_calendar
			GROUP BY read_cycle_id, utility_id, calendar_month, calendar_year
		) lp_c_mrc
		ON lp_c_mrc.utility_id=u.UtilityCode and lp_c_mrc.read_cycle_id=a.BillingGroup and lp_c_mrc.calendar_year=YEAR(acr.RateEnd) and lp_c_mrc.calendar_month=MONTH(acr.RateEnd)
		
WHERE pb.IsMultiTerm=@IsMultiTerm
	and pt.Active=1
	and acr.RateStart<=GETDATE()
	and acr.RateEnd>GETDATE()
	and c.ContractStatusID=@ApprovedContractStatusID 
	and (accsts.[Status]=@ReEnrollmentAccountContractStatusNumber AND accsts.SubStatus=@ReEnrollmentAccountContractSubStatusNumber)
	and (SELECT AccountContractRateID 
		FROM LibertyPower..AccountContractRate lpACR
		WHERE lpACR.AccountContractID=ac.AccountContractID
		and lpACR.RateStart=DATEADD(d,1,acr.RateEnd)
		) IS NOT NULL --SELECTED Just Records which not expired but changed in accordinally with Multi-Term rules 
	and acr.AccountContractRateID	NOT IN
	(SELECT ToBeExpiredAccountContactRateId FROM LibertyPower..MultiTermWinServiceData)
	and acr.AccountContractRateID=@AccountContractRateId
END
GO
