USE [Lp_Enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_sales_channel_by_phone]    Script Date: 02/27/2013 16:39:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sadiel Jarvis 
-- Create date: 2/15/2013
-- Description:	Return sales channel (agent) assigned to given lead's phone number

-- NOTE: Making only one query handling all NULL scenarios was too expensive and slow. 
-- So redundancy was added (3 similar queries handling each NULL scenario) to improve performance.
-- =============================================
CREATE procedure [dbo].[usp_sales_channel_by_phone] 
	@p_phone_num nvarchar(10),
	@p_AccountNumber varchar(30)
AS

IF @p_phone_num is not null and @p_AccountNumber is not null --scenario 1: both parameters not null
BEGIN
		SELECT     h.nickname AS Agent, 
							  LP.Number AS Contract_Number, LP.AccountNumber ,LP.Status, LP.ProductDescription,
							  convert(varchar,ISNULL(l.Channel_Assigned_Date, Lp_Enrollment.dbo.ufn_GetLastCalledDate(l.lead_id)),101) as AssignmentDate,
							  convert(varchar, ISNULL(l.Channel_Assigned_Date, Lp_Enrollment.dbo.ufn_GetLastCalledDate(l.lead_id)), 112) as AssignmentDateSortable
		FROM         lead AS l WITH (nolock) LEFT OUTER JOIN
							  lead_campaign_lead AS lcl WITH (nolock) ON l.lead_id = lcl.lead_id INNER JOIN
							  lead_campaign AS a WITH (nolock) ON lcl.campaign_id = a.campaign_id LEFT OUTER JOIN
							  lead_contact AS c WITH (nolock) ON l.lead_id = c.lead_id LEFT OUTER JOIN
							  lead_sales_channel AS h WITH (nolock) ON l.channel_id = h.channel_id INNER JOIN
							  vw_lead_disposition AS d WITH (nolock) ON l.disposition_id = d.disposition_id LEFT OUTER JOIN
							  lead_customer_lead AS cl WITH (nolock) ON l.lead_id = cl.lead_id LEFT OUTER JOIN
								  (SELECT     lpc.Number, lpa.AccountNumber,
								  RTRIM(ex.status_descp) + '-' + LTRIM(esx.sub_status_descp) AS Status,
								  P.product_descp as ProductDescription                     
									FROM          LibertyPower.dbo.Contract AS lpc WITH (nolock) INNER JOIN
														   LibertyPower.dbo.AccountContract AS lpac WITH (nolock) ON lpc.ContractID = lpac.ContractID INNER JOIN
														   LibertyPower.dbo.AccountContractRate AS lpar WITH (nolock) ON lpac.AccountContractID = lpar.AccountContractID AND 
														   lpar.IsContractedRate = 1 INNER JOIN
														   LibertyPower.dbo.AccountStatus AS x WITH (nolock) ON lpar.AccountContractID = x.AccountContractID LEFT JOIN
														   Lp_Account.dbo.enrollment_status AS ex WITH (nolock) ON x.status = ex.status LEFT JOIN
														   Lp_Account.dbo.enrollment_sub_status AS esx WITH (nolock) ON ex.status = esx.status INNER JOIN
															   (SELECT     MAX(Modified) AS servid, AccountContractID
																 FROM          LibertyPower.dbo.AccountStatus WITH (nolock)
																 GROUP BY AccountContractID) AS w ON x.AccountContractID = w.AccountContractID AND x.Modified = w.servid INNER JOIN
														   LibertyPower.dbo.Account AS lpa WITH (nolock) ON lpac.AccountID = lpa.AccountID INNER JOIN                                                   
														   Libertypower.dbo.vw_AccountContractRate vlpar WITH (NOLOCK) ON vlpar.AccountContractID = lpac.AccountContractID LEFT JOIN 
														   lp_common.dbo.common_product P WITH (NOLOCK) ON P.product_id = ISNULL(lpar.LegacyProductID,vlpar.LegacyProductID)                                                   ) 
														   AS LP ON LP.Number = cl.old_contract_nbr
		WHERE     (a.is_active = 1) and l.phone_num = @p_phone_num and LP.AccountNumber = @p_AccountNumber
		ORDER BY LP.Number desc, AssignmentDateSortable desc
END ELSE 
IF @p_phone_num is not null and @p_AccountNumber is null --scenario 2: we have phone number but no account number
BEGIN
		SELECT     h.nickname AS Agent, 
                      LP.Number AS Contract_Number, LP.AccountNumber ,LP.Status, LP.ProductDescription,
							  convert(varchar,ISNULL(l.Channel_Assigned_Date, Lp_Enrollment.dbo.ufn_GetLastCalledDate(l.lead_id)),101) as AssignmentDate,
							  convert(varchar, ISNULL(l.Channel_Assigned_Date, Lp_Enrollment.dbo.ufn_GetLastCalledDate(l.lead_id)), 112) as AssignmentDateSortable
		FROM         lead AS l WITH (nolock) LEFT OUTER JOIN
							  lead_campaign_lead AS lcl WITH (nolock) ON l.lead_id = lcl.lead_id INNER JOIN
							  lead_campaign AS a WITH (nolock) ON lcl.campaign_id = a.campaign_id LEFT OUTER JOIN
							  lead_contact AS c WITH (nolock) ON l.lead_id = c.lead_id LEFT OUTER JOIN
							  lead_sales_channel AS h WITH (nolock) ON l.channel_id = h.channel_id INNER JOIN
							  vw_lead_disposition AS d WITH (nolock) ON l.disposition_id = d.disposition_id LEFT OUTER JOIN
							  lead_customer_lead AS cl WITH (nolock) ON l.lead_id = cl.lead_id LEFT OUTER JOIN
								  (SELECT     lpc.Number, lpa.AccountNumber,
								  RTRIM(ex.status_descp) + '-' + LTRIM(esx.sub_status_descp) AS Status,
								  P.product_descp as ProductDescription                     
									FROM          LibertyPower.dbo.Contract AS lpc WITH (nolock) INNER JOIN
														   LibertyPower.dbo.AccountContract AS lpac WITH (nolock) ON lpc.ContractID = lpac.ContractID INNER JOIN
														   LibertyPower.dbo.AccountContractRate AS lpar WITH (nolock) ON lpac.AccountContractID = lpar.AccountContractID AND 
														   lpar.IsContractedRate = 1 INNER JOIN
														   LibertyPower.dbo.AccountStatus AS x WITH (nolock) ON lpar.AccountContractID = x.AccountContractID LEFT JOIN
														   Lp_Account.dbo.enrollment_status AS ex WITH (nolock) ON x.status = ex.status LEFT JOIN
														   Lp_Account.dbo.enrollment_sub_status AS esx WITH (nolock) ON ex.status = esx.status INNER JOIN
															   (SELECT     MAX(Modified) AS servid, AccountContractID
																 FROM          LibertyPower.dbo.AccountStatus WITH (nolock)
																 GROUP BY AccountContractID) AS w ON x.AccountContractID = w.AccountContractID AND x.Modified = w.servid INNER JOIN
														   LibertyPower.dbo.Account AS lpa WITH (nolock) ON lpac.AccountID = lpa.AccountID INNER JOIN                                                   
														   Libertypower.dbo.vw_AccountContractRate vlpar WITH (NOLOCK) ON vlpar.AccountContractID = lpac.AccountContractID LEFT JOIN 
														   lp_common.dbo.common_product P WITH (NOLOCK) ON P.product_id = ISNULL(lpar.LegacyProductID,vlpar.LegacyProductID)                                                   ) 
														   AS LP ON LP.Number = cl.old_contract_nbr
		WHERE     (a.is_active = 1) and l.phone_num = @p_phone_num
		ORDER BY LP.Number desc, AssignmentDateSortable desc
END ELSE 
IF @p_phone_num is null and @p_AccountNumber is not null --scenario 3: we have account number but no phone number
BEGIN
		SELECT     h.nickname AS Agent, 
							  LP.Number AS Contract_Number, LP.AccountNumber ,LP.Status, LP.ProductDescription,
							  convert(varchar,ISNULL(l.Channel_Assigned_Date, Lp_Enrollment.dbo.ufn_GetLastCalledDate(l.lead_id)),101) as AssignmentDate,
							  convert(varchar, ISNULL(l.Channel_Assigned_Date, Lp_Enrollment.dbo.ufn_GetLastCalledDate(l.lead_id)), 112) as AssignmentDateSortable
		FROM         lead AS l WITH (nolock) LEFT OUTER JOIN
							  lead_campaign_lead AS lcl WITH (nolock) ON l.lead_id = lcl.lead_id INNER JOIN
							  lead_campaign AS a WITH (nolock) ON lcl.campaign_id = a.campaign_id LEFT OUTER JOIN
							  lead_contact AS c WITH (nolock) ON l.lead_id = c.lead_id LEFT OUTER JOIN
							  lead_sales_channel AS h WITH (nolock) ON l.channel_id = h.channel_id INNER JOIN
							  vw_lead_disposition AS d WITH (nolock) ON l.disposition_id = d.disposition_id LEFT OUTER JOIN
							  lead_customer_lead AS cl WITH (nolock) ON l.lead_id = cl.lead_id LEFT OUTER JOIN
								  (SELECT     lpc.Number, lpa.AccountNumber,
								  RTRIM(ex.status_descp) + '-' + LTRIM(esx.sub_status_descp) AS Status,
								  P.product_descp as ProductDescription                     
									FROM          LibertyPower.dbo.Contract AS lpc WITH (nolock) INNER JOIN
														   LibertyPower.dbo.AccountContract AS lpac WITH (nolock) ON lpc.ContractID = lpac.ContractID INNER JOIN
														   LibertyPower.dbo.AccountContractRate AS lpar WITH (nolock) ON lpac.AccountContractID = lpar.AccountContractID AND 
														   lpar.IsContractedRate = 1 INNER JOIN
														   LibertyPower.dbo.AccountStatus AS x WITH (nolock) ON lpar.AccountContractID = x.AccountContractID LEFT JOIN
														   Lp_Account.dbo.enrollment_status AS ex WITH (nolock) ON x.status = ex.status LEFT JOIN
														   Lp_Account.dbo.enrollment_sub_status AS esx WITH (nolock) ON ex.status = esx.status INNER JOIN
															   (SELECT     MAX(Modified) AS servid, AccountContractID
																 FROM          LibertyPower.dbo.AccountStatus WITH (nolock)
																 GROUP BY AccountContractID) AS w ON x.AccountContractID = w.AccountContractID AND x.Modified = w.servid INNER JOIN
														   LibertyPower.dbo.Account AS lpa WITH (nolock) ON lpac.AccountID = lpa.AccountID INNER JOIN                                                   
														   Libertypower.dbo.vw_AccountContractRate vlpar WITH (NOLOCK) ON vlpar.AccountContractID = lpac.AccountContractID LEFT JOIN 
														   lp_common.dbo.common_product P WITH (NOLOCK) ON P.product_id = ISNULL(lpar.LegacyProductID,vlpar.LegacyProductID)                                                   ) 
														   AS LP ON LP.Number = cl.old_contract_nbr
		WHERE     (a.is_active = 1) and LP.AccountNumber = @p_AccountNumber
		ORDER BY LP.Number desc, AssignmentDateSortable desc
END

		
		