
-- =============================================
-- Author:		Hector Gomez
-- Create date: 11/25/2009
-- Description:	This stored procedure will check
-- data integrity issues regarding Gross Margin
-- will notify user if:
-- a) Gross Margin is missing
-- b) Zone is missing
-- c) Annual Usage is missing
-- =============================================
CREATE PROCEDURE [dbo].[usp_GM_DailyDataCheck] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

DECLARE @prmCustomFrom  datetime
DECLARE @prmCustomTo DateTime
Set @prmCustomFrom = DATEADD("d",-1,GETDATE())
Set @prmCustomTo = GETDATE()

-- INSTRUCTION ONLY TO GET THE TABLE STRUCTURE
SELECT * 
	, 0 GM_EventID
	, CAST(0.00 as decimal(18,4)) GM_GrossMarginValue
	, CAST(0.00 as decimal(18,4)) GM_AnnualGrossProfit
	, CAST(0.00 as decimal(18,4)) GM_TermGrossProfit
	, CAST(0.00 as decimal(18,4)) GM_AddtlGM
	, CAST(0.00 as decimal(18,4)) GM_AnnualRevenue
	, CAST(0.00 as decimal(18,4)) GM_TermRevenue
	, 0 GM_AnnualUsage
	, CAST(0.00 as decimal(18,4)) GM_TermAnnualUsage	
INTO #TempAccount 
FROM lp_account.dbo.tblAccounts_vw 
WHERE 1=0


INSERT #TempAccount
EXEC lp_reports.dbo.usp_GMAccountSelection
		'Total' --@prmSaleType Custom/Daily/Total
		, 'Total' -- @prmRenewal 
		, 'CLOSED' --@prmDealAccepted 
		, 'Submit Date' --@prmDateType 
		, 'Custom' --@prmDateRange
		, @prmCustomFrom 
		, @prmCustomTo
		, 'N'



SELECT
	DISTINCT
	a.Account_Id,
	a.AccountNumber,
	a.accountname,
	a.flowstartdate,
	a.SubmitDate,
	a.contractnumber,
	CASE
		WHEN a.contracttype like ('%Renewal%') then 'Renewal' else 'New'
	END AS contracttype,
	a.retail_mkt_id,
	CAST(CASE
		WHEN COALESCE(a.GM_annualusage,0) = 0 THEN a.annualusage else a.GM_annualusage
	end as decimal(18,4))/1000 as annualusage,

	CAST(
			((CASE
			WHEN COALESCE(a.GM_annualusage,0) = 0 THEN a.annualusage else a.GM_annualusage
			end) /12) * a.contractterm AS decimal(18,4))/1000 as Termusage,
	case
		when a.GM_EventID = 1 then 'proxy' else ''
	end as proxy,
	a.utility,
	case
		when a.zone is null then z.zone
		when a.zone = '' then z.zone
		else a.zone
	end as zone,

	a.product,
	case
		when p.iscustom = 1 then 'Custom'
		when right(ltrim(rtrim(pr.rate_descp)),8) = '- CUSTOM' then 'Custom'
		WHEN dc.product_id is not null then 'Custom'
		when cp.product_id is not null then 'Custom'
		else 'Daily'
	end as DealType,
	upper(a.accounttype) as AccountType,
	a.accountstatus,

	case when rtrim(status) in ('999998', '999999') then 'REJECTED' else 'ACCEPTED' end as FlowStatus,

	case
		when a.contracttype = 'POWER MOVE' and a.saleschannelid = 'NONE' then 'PowerMove'
		else upper(replace(a.saleschannelid, 'Sales Channel/', ''))
	end as SalesChannel,

	case
		when a.contracttype = 'POWER MOVE' then 'Utility Driven'
		when replace(a.saleschannelid, 'Sales Channel/', '') = 'LPINSIDESALES' then 'Inside'
		when replace(a.saleschannelid, 'Sales Channel/', '') = 'LPABC' then 'Inside'
		when replace(a.saleschannelid, 'Sales Channel/', '') = 'LPC' then 'Inside'
		when replace(a.saleschannelid, 'Sales Channel/', '') = 'LPOUTSIDESALES' then 'Outside'
		when replace(a.saleschannelid, 'Sales Channel/', '') IN ('OUTBOUNDTELESALES','REGIONALSALES') then 'Internal'
		else channeltype.vendor_category_code
	end as SaleSChannelType,

	a.SalesRep,

	case
	when a.contracttype = 'POWER MOVE' then 'Utility Driven'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('MIKE', 'MIKE.','MH', 'Mike Hernandez') then 'Mike Hernandez'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('CW','Cristina Wilkison', 'CW7') then 'Cristina Wilkison'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('ARIEL', 'AH','Ariel Hernandez') then 'Ariel Hernandez'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('VINCE', 'Vincent DeCicco', 'VD', 'VLD') then 'Vincent DeCicco'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('JENNY', 'JS','Jenny Shantser', 'JS1') then 'Jenny Shantser'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('YM','Yamil Moya', 'YAM') then 'Yamil Moya'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('FELIC','Felice Gorordo', 'FG') then 'Felice Gorordo'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('MATT','Matthew Stasium', 'MS') then 'Matthew Stasium'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('GM','GISEL','Giselle Morgan') then 'Giselle Morgan'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('TG','Tony Gilbert', 'WAG') then 'Tony Gilbert'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('RAMON','Ramon Del Salto') then 'Ramon Del Salto'
	when replace(a.saleschannelid,'Sales Channel/', '') in ('LPINSIDESALES','LPABC','LPOUTSIDESALES') and a.SalesRep in ('Ben Capobianco','BEN') then 'Ben Capobianco'
	when replace(a.saleschannelid, 'Sales Channel/', '') = 'LPINSIDESALES' then 'Claus Kursell'
	when replace(a.saleschannelid, 'Sales Channel/', '') = 'T2R' then 'Claus Kursell'
	when replace(a.saleschannelid, 'Sales Channel/', '') = 'LPABC' then 'Jason Merrit'
	when replace(a.saleschannelid, 'Sales Channel/', '') = 'LPOUTSIDESALES' then 'Nelson Reyneri'
	--when x.Manager <> '' then x.manager
	--COMMENTED OUT BY HECTOR 8/4/09 channeltype.sales_manager
	else
	CASE
	WHEN LEN(RTRIM(COALESCE(Manager,''))) = 0 THEN channeltype.sales_manager
	ELSE Manager
	END
	end as SalesManager,

	GM_GrossMarginValue,
	GM_AnnualGrossProfit,
	GM_TermGrossProfit,
	GM_AddtlGM,
	
	a.contractterm

FROM
	#TempAccount a (nolock)
	left join lp_common..common_utility u (nolock) on a.utility = u.utility_id
	left join lp_common..zone z (nolock) on u.zone_default = z.zone_id
	left join lp_common..common_product p (nolock) on a.product = p.product_id


	left join
		(
			select
				distinct
				v.vendor_name,
				vc.vendor_category_code,
				replace(v.sales_manager, 'libertypower\', '') as sales_manager
			from
				lp_commissions..vendor v (nolock)
				JOIN lp_commissions..vendor_category vc (nolock)
				ON v.vendor_category_id = vc.vendor_category_id
		) channeltype on replace(a.saleschannelid, 'Sales Channel/', '') = channeltype.vendor_name

	LEFT JOIN
		(
		Select
		product_id,
		rate_id,
		rate_descp
		From
		LP_COMMON.dbo.COMMON_PRODUCT_RATE (nolock)
		) pr on a.product = pr.product_id and a.rate_id = pr.rate_id

	LEFT JOIN
		(
		Select
		distinct
		product_id,
		rate_id
		from
		lp_deal_capture.dbo.deal_pricing_detail (nolock)
		)dc on a.product = dc.product_id and a.rate_id = dc.rate_id

	LEFT JOIN
		(
		select
		distinct
		Product_id
		from
		LP_COMMON.dbo.COMMON_PRODUCT (nolock)
		where
		iscustom = 1
		) cp on a.product = cp.product_id

	LEFT JOIN
		(
		SELECT
		AccountID
		, AccountNumber
		, a.ContractNumber
		, a.SubmitDate
		, a.SalesChannelID
		, COALESCE(
		(
		SELECT
		COALESCE(Sales_Manager,
		(
		SELECT DISTINCT VEN.Sales_Manager from lp_commissions.dbo.vendor VEN WHERE VEN.vendor_system_name = a.SalesChannelID
		)
		) MANAGER
		FROM
		lp_commissions.dbo.zaudit_vendor ZV
		WHERE
		ZV.vendor_system_name = a.SalesChannelID
		AND ZV.Sales_Manager IS NOT NULL

		AND ZV.Date_Audit = (SELECT MAX(ZV2.Date_Audit)
		FROM lp_commissions.dbo.zaudit_vendor ZV2
		WHERE
		ZV.vendor_system_name = ZV2.vendor_system_name
		AND ZV2.Sales_Manager IS NOT NULL
		AND ZV2.Date_Audit < a.SubmitDate
		)
		),
		-- SELECT DEFAULT
		COALESCE((
		SELECT
		COALESCE(Sales_Manager,
		(
		SELECT DISTINCT VEN.Sales_Manager from lp_commissions.dbo.vendor VEN WHERE VEN.vendor_system_name = a.SalesChannelID
		)
		) MANAGER
		FROM
		lp_commissions.dbo.zaudit_vendor ZV
		WHERE
		ZV.vendor_system_name = a.SalesChannelID
		AND ZV.Sales_Manager IS NOT NULL

		AND ZV.Date_Audit = (SELECT MIN(ZV2.Date_Audit)
		FROM lp_commissions.dbo.zaudit_vendor ZV2
		WHERE
		ZV.vendor_system_name = ZV2.vendor_system_name
		AND ZV2.Sales_Manager IS NOT NULL
		AND a.SubmitDate < ZV2.Date_Audit
		)
		),'')
		) Manager

	FROM
	libertypower..AccountEventHistory AEH (nolock)
		JOIN Lp_account.dbo.tblaccounts_vw a (nolock) ON a.Account_id = AEH.AccountID and a.contractnumber = AEH.contractnumber
	where
		year(a.submitdate) = year(getdate())
	) x on a.account_id = x.accountid


WHERE 
	COALESCE((
		CAST(
				CASE
					WHEN COALESCE(a.GM_annualusage,0) = 0 THEN a.annualusage 
					else a.GM_annualusage
				end as decimal(18,4))/1000
	),0) = 0	-- ANNUAL USAGE is ZERO, need to research
	
	OR 
	
	COALESCE(GM_GrossMarginValue,0) = 0	 -- GROSS MARGIN is ZERO, need to research

	OR
	
	COALESCE(case
		when a.zone is null then z.zone
		when a.zone = '' then z.zone
		else a.zone
	end,'') = '' -- ZONE is BLANK, need to research		
	
drop table #TempAccount



END

