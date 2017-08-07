using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class FixedEtfCalculator : EtfCalculator
	{

		/// <summary>
		/// Rate of the fixed Dollar per kWh amount for the account
		/// </summary>
		public decimal AccountRate
		{
			get;
			set;
		}

		public int AnnualUsage
		{
			get;
			set;
		}

		public int DropMonthIndicator
		{
			get;
			set;
		}

		public DateTime ContractEffectiveDate
		{
			get;
			set;
		}

		public int LostTermDays
		{
			get;
			set;
		}

		public int LostTermMonths
		{
			get;
			set;
		}

		public decimal MarketRate
		{
			get;
			set;
		}

		public int Term
		{
			get;
			set;
		}

		public FixedEtfCalculator( CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType etfCalculationType )
			: base( EtfCalculatorType.Fixed, companyAccount, deenrollmentDate, etfCalculationType )
		{
		}

		public override EtfCalculator Calculate()
		{

			string otherParams = Environment.NewLine + Environment.NewLine + "Parameters:" + Environment.NewLine;
			// all legacy datetime fields are set to 1/1/1900 by default
			DateTime nullDate = new DateTime( 1900, 1, 1 );
			DateTime today = new DateTime( DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day );

			string errorCollector = String.Empty;
			if( this.CompanyAccount.AnnualUsage <= 0 )
			{
				errorCollector += "Annual Historical Usage is missing. ";
			}
			this.AnnualUsage = this.CompanyAccount.AnnualUsage;
			otherParams += "Annual Usage: " + this.AnnualUsage + Environment.NewLine;

			if( this.CompanyAccount.Term <= 0 )
			{
				errorCollector += "Account Term value is missing. ";
			}
			this.Term = this.CompanyAccount.Term;
			otherParams += "Term: " + this.Term + Environment.NewLine;


			if( CompanyAccount.ContractStartDate == nullDate )
			{
				errorCollector += "Contract Effective Start Date is missing. ";
			}
			this.ContractEffectiveDate = this.CompanyAccount.ContractStartDate;
			otherParams += "Contract Effective Date: " + this.CompanyAccount.ContractStartDate.ToShortDateString() + Environment.NewLine;

			if( DeenrollmentDate == nullDate )
			{
				errorCollector += "Deenrollment Date is missing. ";
			}
			otherParams += "Deenrollment Date: " + DeenrollmentDate.ToShortDateString() + Environment.NewLine;

			if( this.CompanyAccount.Rate <= 0 )
			{
				errorCollector += "Account Rate is missing. ";
			}
			this.AccountRate = this.CompanyAccount.Rate;
			otherParams += "Account Rate: " + this.AccountRate + Environment.NewLine;

			int totalContractDays = GetTotalContractDays( this.Term );
			DateTime contractEndDate = GetContractEndDate( this.ContractEffectiveDate, totalContractDays );
			otherParams += "Contract End Date: " + contractEndDate.ToShortDateString() + Environment.NewLine;


			if( errorCollector != String.Empty )
			{
				this.ErrorMessage = errorCollector + otherParams;
				return this;
			}

			if( this.CalculationType == EtfCalculationType.Estimated && today.AddDays( 60 ) < this.DeenrollmentDate )
			{
				this.ErrorMessage = "Deenrollment date is more than 60 days in the future the application might be missing meter read schedule information." + otherParams;
				return this;
			}



			this.LostTermDays = GetContractDaysLeft( contractEndDate, DeenrollmentDate );
			this.LostTermMonths = Convert.ToInt32( Math.Round( this.LostTermDays / (365.0 / 12) ) );

			if( this.LostTermMonths < 0 )
			{
				this.ErrorMessage = "Cannot calculate ETF. Deenrollment date is on or after Contract End Date. " + otherParams;
				return this;
			}

			//Get DropMonth Indicator
			// if dropMonthIndicator < 0 the deenrollment date has been in the past.
			this.DropMonthIndicator = Math.Max( ((this.DeenrollmentDate.Year * 12) + this.DeenrollmentDate.Month)
										  - ((DateTime.Now.Year * 12) + DateTime.Now.Month), 0 );

			MarketRate marketRate = null;
			if( this.DeenrollmentDate < today )
			{
				//if deenrollment date is in the past, use effective pricing date of that date
				marketRate = MarketRateFactory.GetMarketRate( this.DeenrollmentDate, this.CompanyAccount, this.LostTermMonths, this.DropMonthIndicator );
			}
			else
			{
				// use today's pricing date
				marketRate = MarketRateFactory.GetMarketRate( this.CompanyAccount, this.LostTermMonths, this.DropMonthIndicator );
			}

			if( marketRate.HasError )
			{
				this.ErrorMessage = marketRate.ErrorMessage + otherParams;
				return this;
			}
			this.MarketRate = Convert.ToDecimal( marketRate.Rate );


			if( this.ContractEffectiveDate < new DateTime( 2009, 2, 1 ) )
			{
				this.CalculatedEtfAmount = FormulaPriorToFeb1_2009( this.AnnualUsage, this.LostTermDays, this.AccountRate, this.MarketRate );
			}
			else if( this.ContractEffectiveDate >= new DateTime( 2009, 2, 1 ) && this.ContractEffectiveDate < new DateTime( 2009, 4, 1 ) )
			{
				this.CalculatedEtfAmount = FormulaFebMar2009( this.AnnualUsage, this.LostTermDays, this.AccountRate, this.MarketRate, CompanyAccount.ContractNumber );
			}
			else
			{
				this.CalculatedEtfAmount = FormulaApr2009AndLater( this.AnnualUsage, this.LostTermDays, this.AccountRate, this.MarketRate );
			}

			return this;
		}


		private int FormulaPriorToFeb1_2009( int annualUsage, int contractDaysLeft, decimal contractRate, decimal marketRate )
		{
			// Annual Usage                   
			// ------------- * MAX (  (Contract End Date - Deenrollment Date).Days, 0 ) * ( Contract Rate - Market Rate ) 
			//	   365

			decimal usagePerDay = annualUsage / 365.0M;
			contractDaysLeft = Math.Max( contractDaysLeft, 0 );

			// Calculate Difference between contract rate and market rate
			decimal rateDifference = contractRate - marketRate;

			int result = Convert.ToInt32( Math.Round( usagePerDay * contractDaysLeft * rateDifference ) );

			return result;
		}

		private int FormulaFebMar2009( int annualUsage, int contractDaysLeft, decimal contractRate, decimal marketRate, string contractNumber )
		{
			if( contractDaysLeft < 0 )
			{
				return 0;
			}

			decimal usagePerDay = annualUsage / 365.0M;

			// Calculate Difference between contract rate and market rate, minimum is 0.0002
			decimal rateDifference = Math.Max( contractRate - marketRate, 0.002m );

			decimal temp1 = usagePerDay * contractDaysLeft * rateDifference;

			int numberOfAccountsInContract = ContractFactory.GetContractWithAccounts( contractNumber ).Accounts.Count;
			decimal temp2 = 250 / numberOfAccountsInContract; // Number of accounts per contract

			int result = Convert.ToInt32( Math.Round( Math.Max( temp1, temp2 ) ) );

			return result;
		}

		private int FormulaApr2009AndLater( int annualUsage, int contractDaysLeft, decimal contractRate, decimal marketRate )
		{
			decimal usagePerDay = annualUsage / 365.0M;
			contractDaysLeft = Math.Max( contractDaysLeft, 0 );

			// Calculate Difference between contract rate and market rate
			decimal rateDifference = Math.Max( contractRate - marketRate, 0.007m );

			int result = Convert.ToInt32( Math.Round( usagePerDay * contractDaysLeft * rateDifference ) );

			return result;
		}


		new public int GetTotalContractDays( int term )
		{
			int totalContractDays = Convert.ToInt32( Math.Round( term * 365.0 / 12 ) ) - 1;
			return totalContractDays;
		}

		public new DateTime GetContractEndDate( DateTime contractEffectiveDate, int totalContractDays )
		{
			return contractEffectiveDate.AddDays( totalContractDays );
		}

		public new int GetContractDaysLeft( DateTime contractEndDate, DateTime deenrollmentDate )
		{
			int contractDaysLeft = (contractEndDate - deenrollmentDate).Days;
			return contractDaysLeft;
		}

	}
}
