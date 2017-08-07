
CREATE PROCEDURE [dbo].[usp_AccountEtfSelect]
	@EtfID int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT AccountEtf.EtfID, 
		   AccountEtf.AccountID, 
		   AccountEtf.EtfProcessingStateID, 
		   AccountEtf.EtfEndStatusID, 
		   AccountEtf.ErrorMessage, 
           AccountEtf.EtfAmount, 
           AccountEtf.DeenrollmentDate, 
           AccountEtf.IsEstimated, 
           AccountEtf.IsPaid, 
           AccountEtf.CalculatedDate, 
           AccountEtf.EtfFinalAmount,
           AccountEtf.LastUpdatedBy,
           AccountEtf.EtfCalculatorType,
           
           AccountEtfCalculationFixed.EtfCalculationFixedID, 
           AccountEtfCalculationFixed.LostTermDays, 
           AccountEtfCalculationFixed.LostTermMonths, 
           AccountEtfCalculationFixed.AccountRate, 
           AccountEtfCalculationFixed.MarketRate, 
           AccountEtfCalculationFixed.AnnualUsage, 
           AccountEtfCalculationFixed.Term, 
           AccountEtfCalculationFixed.FlowStartDate, 
           AccountEtfCalculationFixed.DropMonthIndicator,
		
		   AccountEtfCalculationVariable.EtfCalculationVariableID,
		   AccountEtfCalculationVariable.AccountCount,
		   AccountEtfCalculationVariable.AverageAnnualConsumption,
		   
		   AccountEtfInvoiceQueue.EtfInvoiceID
		
		FROM AccountEtf WITH (NOLOCK) 
			LEFT OUTER JOIN AccountEtfCalculationFixed WITH (NOLOCK) ON AccountEtf.EtfID = AccountEtfCalculationFixed.EtfID 
			LEFT OUTER JOIN AccountEtfCalculationVariable WITH (NOLOCK) ON AccountEtf.EtfID = AccountEtfCalculationVariable.EtfID
			LEFT OUTER JOIN AccountEtfInvoiceQueue WITH (NOLOCK) ON AccountEtf.EtfID = AccountEtfInvoiceQueue.EtfID
		WHERE AccountEtf.EtfID = @EtfID

	SET NOCOUNT OFF;

END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfSelect';

