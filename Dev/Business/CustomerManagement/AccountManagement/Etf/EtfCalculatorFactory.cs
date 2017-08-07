using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class EtfCalculatorFactory
	{
		const int EstimatedDeenrollmentProcessingDays = 15;

		public static EtfCalculator GetCalculatedEtf( CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType etfCalculationType )
		{
			EtfCalculator etfCalculator = null;

			Contract contract = ContractFactory.GetContract( companyAccount.ContractNumber );
			if( contract.Version != null && contract.Version.ETFFormulaId == 2 )
			{
				etfCalculator = new NewYorkEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType );
			}
			else if( contract.Version != null && contract.Version.ETFFormulaId == 3 && companyAccount.AccountType == CompanyAccountType.RESIDENTIAL )
			{
				etfCalculator = new MonthScalerEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType );
			}
			else if( contract.Version != null && contract.Version.ETFFormulaId == 4 && companyAccount.AccountType == CompanyAccountType.RESIDENTIAL )
			{
				etfCalculator = new FlatEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType );
			}
			else if( contract.Version != null && contract.Version.ETFFormulaId == 5 && companyAccount.AccountType == CompanyAccountType.RESIDENTIAL )
			{
				etfCalculator = new DoubleMonthlyEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType );
			}
			else if( contract.Version != null && contract.Version.ETFFormulaId == 6 )
			{
				etfCalculator = new MultiTermEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType, companyAccount.AccountType );
			}
			else
			{
				// estimated calculation
				// Get Estimated Deenrollment date (next trip date after (DateTime.Now + 15 days))
				//deenrollmentDate = GetDeenrollmentDate(companyAccount);

				switch( companyAccount.Product.Category )
				{
					// Fixed product
					case ProductCategory.Fixed:
						etfCalculator = new FixedEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType );
						break;
					// Variable product
					case ProductCategory.Variable:
						etfCalculator = new VariableEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType );
						break;
				}
			}

			etfCalculator.Calculate();

			return etfCalculator;
		}

		private static DateTime GetDeenrollmentDate( CompanyAccount companyAccount )
		{
			MeterReadScheduleItem meterReadScheduleItem = null;
			DateTime deenrollmentDate = DateTime.Now;
			string error = null;
			try
			{
				meterReadScheduleItem = MeterReadScheduleFactory.GetNextMeterReadDate( DateTime.Now.AddDays( EstimatedDeenrollmentProcessingDays ), companyAccount.UtilityCode, companyAccount.ReadCycleId );

			}
			catch( Exception ex )
			{
				error = ex.Message;
			}

			if( companyAccount.Product.Category == LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductCategory.Fixed && error == null )
			{
				deenrollmentDate = meterReadScheduleItem.ReadDate;
			}
			else if( companyAccount.Product.Category == LibertyPower.Business.CustomerAcquisition.ProductManagement.ProductCategory.Fixed && error != null )
			{
				throw new Exception( error );
			}

			return deenrollmentDate;

			// *****************************
			// Refactor this code later on
			// *****************************
			// Ignore meterReadScheduleItem for Variable Products since it is not needed
		}

		public static EtfCalculator CreateManualEtfCalculator( CompanyAccount companyAccount )
		{
			return new ManualEntryCalculator( companyAccount );
		}
	}
}
