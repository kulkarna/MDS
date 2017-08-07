using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class EtfCalculatingState : IEtfState
	{

		public EtfCalculatingState()
			: base( EtfState.EtfCalculating )
		{

		}

		const int EstimatedDeenrollmentProcessingDays = 15;

		public override void Process( EtfContext context )
		{

			if ( context.CompanyAccount.Etf.EtfCalculationType == EtfCalculationType.Actual )
			{
				// For the actual ETF we are using the DeenrollmentDate that is set in the account object
				context.CompanyAccount.Etf.EtfCalculator = EtfCalculatorFactory.GetCalculatedEtf( context.CompanyAccount, context.CompanyAccount.DeenrollmentDate, context.CompanyAccount.Etf.EtfCalculationType );

				if ( !context.CompanyAccount.Etf.EtfCalculator.HasError )
				{
					context.CurrentIEtfState = new SuccessfulEtfCalculationState();
				}
				else
				{
					context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;
					context.CompanyAccount.Etf.ErrorMessage = context.CompanyAccount.Etf.EtfCalculator.ErrorMessage;
					context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.FailedEtfCalculation;
					context.CurrentIEtfState = new EtfCompletedState();
				}

			}
			else
			{
				// estimated calculation
				// Get Estimated Deenrollment date (next trip date after (DateTime.Now + 15 days))

                //MeterReadScheduleItem meterReadScheduleItem = null;
                //DateTime deenrollmentDate = DateTime.Now;
                //string error = null;
                //try
                //{
                //    meterReadScheduleItem = MeterReadScheduleFactory.GetNextMeterReadDate( DateTime.Now.AddDays( EstimatedDeenrollmentProcessingDays ), context.CompanyAccount.UtilityCode, context.CompanyAccount.ReadCycleId );

                //}
                //catch ( Exception ex )
                //{
                //    error = ex.Message;
                //}

                //bool hasError = false;
                //if ( context.CompanyAccount.Product.Category == LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductCategory.Fixed && error == null )
                //{
                //    deenrollmentDate = meterReadScheduleItem.ReadDate;
                //}
                //else if ( context.CompanyAccount.Product.Category == LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductCategory.Fixed && error != null )
                //{
                //    hasError = true;
                //}

				// *****************************
				// Refactor this code later on
				// *****************************
				// Ignore meterReadScheduleItem for Variable Products since it is not needed

                //if ( hasError )
                //{
                //    context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;
                //    context.CompanyAccount.Etf.ErrorMessage = error;
                //    context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.FailedEtfCalculation;
                //    context.CurrentIEtfState = new EtfCompletedState();
                //}
                //else
                //{
                Etf etf = context.CompanyAccount.Etf;

                try
                {
                    DateTime deenrollmentDate = DateTime.Now.AddDays(EstimatedDeenrollmentProcessingDays);
                    if (context.CompanyAccount.DeenrollmentDate >= context.CompanyAccount.FlowStartDate)//DateTime.Now)
                        deenrollmentDate = context.CompanyAccount.DeenrollmentDate;
                    EtfCalculator etfCalculator = EtfCalculatorFactory.GetCalculatedEtf(context.CompanyAccount, deenrollmentDate, context.CompanyAccount.Etf.EtfCalculationType);

                    if (etf.EtfCalculator != null && etf.EtfCalculator.EtfCalculationID.HasValue)
                    {
                        etfCalculator.EtfCalculationID = etf.EtfCalculator.EtfCalculationID;
                    }

                    etf.EtfCalculator = etfCalculator;
                    etf.EtfCalculator.DateCalculated = DateTime.Now;
                    if (context.CompanyAccount.Etf.EtfCalculator.HasError)
                    {
                        etf.ErrorMessage = etf.EtfCalculator.ErrorMessage;
                        etf.EtfEndStatus = EtfEndStatus.FailedEtfCalculation;
                        etf.EtfState = EtfState.EtfCompleted;
                        context.CurrentIEtfState = new EtfCompletedState();
                    }
                    else
                    {
                        etf.ErrorMessage = ""; //Erases the previous error message, then it won't be shown again.
                        context.CurrentIEtfState = new EtfEstimatedState();
                    }
                }
                catch (Exception ex)
                {
                    context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;
                    context.CompanyAccount.Etf.ErrorMessage = ex.Message;
                    context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.FailedEtfCalculation;
                    context.CurrentIEtfState = new EtfCompletedState();
                }

                //}

			}
		}
	}
}