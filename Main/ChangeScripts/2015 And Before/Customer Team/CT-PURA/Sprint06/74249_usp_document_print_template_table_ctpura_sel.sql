USE [lp_documents]
GO
/****** Object:  StoredProcedure [dbo].[usp_document_print_template_table_ctpura_sel]    Script Date: 06/30/2015 10:24:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author: Deepak Taliyan  
-- Create date: 6/30/2015  
-- Description: Returns data to be filled in the ctpura Form1 related Fields   
-- Use:   EXEC usp_document_print_template_table_ctpura_sel @contract_number='2970596'  
-- PBI 74249 
-- =============================================  
  
ALTER PROCEDURE [dbo].[usp_document_print_template_table_ctpura_sel]   
(  
 @contract_number  char(12)  
)   
AS  
  
BEGIN  
SET NOCOUNT ON

DECLARE @InvoiceIDforMaxInvDetID int
Select  @InvoiceIDforMaxInvDetID= InvoiceID from
(
SELECT  Row_number() over( order by IID.InvDetID desc) as 'RowNum',II.InvoiceID  
 FROM ISTA..Invoice II 
	INNER JOIN ISTA..InvoiceDetail IID WITH (NOLOCK)ON II.InvoiceID = IID.InvoiceID AND IID.CategoryID = 1 AND IID.RateDescID = 1 
	INNER JOIN ISTA..Premise IP WITH (NOLOCK) ON II.CustID = IP.CustID
	INNER JOIN Libertypower..Account A WITH (NOLOCK) on A.AccountNumber = IP.PremNo
	INNER JOIN Libertypower..AccountContract AC with (NoLock) on Ac.AccountID=A.AccountID
	INNER JOIN LIbertypower..Contract C (NoLock) on C.ContractID=AC.ContractID and C.Number=@contract_number
)IL where RowNum=1

 SELECT DISTINCT 
  C.Number AS ContractNumber
 ,A.UtilityID AS UtilID
 ,A.BillingGroup AS BillingGroup
 ,ACR.AccountContractID AS AccountContractID
 ,IID.InvDetQty AS InvoicedKWH
 ,II.InvAmt AS InvoicedAmount
 ,SR.GenerationRate AS UtilityRate
 ,SR.EffectiveStartDate AS UtilityRateStartDate
 ,SR.EffectiveEndDate AS UtilityRateEndDate
 ,IID.InvDetQty*SR.GenerationRate AS UtilityAmount
 ,ACR.RateStart AS ContractStartDate
 ,ACR.RateEnd AS ContractEndDate
 ,ACR.Rate AS ContractRate
 ,0.1 AS NextContractRate
 ,convert(DATETIME,'01/01/1900') AS NextMeterReadDate
FROM Libertypower..Account A with (nolock)
INNER JOIN Libertypower..AccountContract AC with (nolock) on A.AccountID = AC.AccountID
INNER JOIN LibertyPower..AccountContractRate ACR WITH(NOLOCK) ON  AC.AccountContractID = ACR.AccountContractID
															  AND Convert(varchar(10),GETDATE(),101) BETWEEN ACR.RateStart AND ACR.RateEnd
INNER JOIN Libertypower..Contract C with (nolock) on AC.ContractID = C.ContractID 
LEFT JOIN LibertyPower..tblStardardRate SR WITH (NOLOCK) ON SR.UtilityId = A.UtilityID
															AND Convert(varchar(10),GETDATE(),101) BETWEEN SR.EffectiveStartDate AND SR.EffectiveEndDate
LEFT JOIN ISTA..Invoice II WITH (NOLOCK) ON II.InvoiceID = @InvoiceIDforMaxInvDetID
LEFT JOIN ISTA..InvoiceDetail IID WITH (NOLOCK)ON II.InvoiceID = IID.InvoiceID AND IID.CategoryID = 1
		AND IID.RateDescID = 1
WHERE C.Number =  @contract_number    
print ('@@ROWCOUNT ' + STR(ISNULL(@@ROWCOUNT,0)))  
SET NOCOUNT OFF   
END  
  