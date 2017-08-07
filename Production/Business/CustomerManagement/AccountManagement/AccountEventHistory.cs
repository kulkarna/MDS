using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// Object containing event data for account
	/// </summary>
	public class AccountEventHistory
	{
		/// <summary>
		/// default constructor
		/// </summary>
		public AccountEventHistory() { }

		/// <summary>
		/// Constructor which uses the parameters grossMargin, 
		/// term, and annualUsage to calculate the
		/// term gross profit and annual gross profit.
		/// </summary>
		/// <param name="grossMargin">Determined by rate</param>
		/// <param name="term">Term (in months)</param>
		/// <param name="annualUsage">Annual usage</param>
		public AccountEventHistory( decimal grossMargin, int term,
			int annualUsage, AccountEventType accountEventType )
		{
			this.GrossMargin = grossMargin;
			this.Term = term;
			this.AnnualUsage = annualUsage;
			this.AccountEventType = accountEventType;

			CalculateGrossProfit();
		}

		/// <summary>
		/// Determined by rate
		/// </summary>
		public decimal GrossMargin
		{
			get;
			set;
		}

		/// <summary>
		/// Determined by commision split
		/// </summary>
		public decimal AdditionalGrossMargin
		{
			get;
			set;
		}

		/// <summary>
		/// Term (in months)
		/// </summary>
		public int Term
		{
			get;
			set;
		}

		/// <summary>
		/// Annual usage
		/// </summary>
		public int AnnualUsage
		{
			get;
			set;
		}

		/// <summary>
		/// Enumerated account event type
		/// </summary>
		public AccountEventType AccountEventType
		{
			get;
			set;
		}

		/// <summary>
		/// Term gross profit calculated by the 
		/// gross margin times the annual usage times the (term / 12)
		/// </summary>
		public decimal TermGrossProfit
		{
			get;
			set;
		}

		/// <summary>
		/// Annual gross profit adjustment
		/// </summary>
		public decimal AnnualGrossProfitAdjustment
		{
			get;
			set;
		}

		/// <summary>
		/// Term gross profit adjustment
		/// </summary>
		public decimal TermGrossProfitAdjustment
		{
			get;
			set;
		}

		/// <summary>
		/// Annual gross profit calculated by the 
		/// gross margin times the annual usage
		/// </summary>
		public decimal AnnualGrossProfit
		{
			get;
			set;
		}

		/// <summary>
		/// Annual Revenue 
		/// </summary>
		public decimal AnnualRevenue
		{
			get;
			set;
		}

		/// <summary>
		/// Term Revenue
		/// </summary>
		public decimal TermRevenue
		{
			get;
			set;
		}

		/// <summary>
		/// Annual Revenue Adjustment
		/// </summary>
		public decimal AnnualRevenueAdjustment
		{
			get;
			set;
		}

		/// <summary>
		/// Term Revenue Adjustment
		/// </summary>
		public decimal TermRevenueAdjustment
		{
			get;
			set;
		}

		/// <summary>
		/// Record ID
		/// </summary>
		public int Id
		{
			get;
			set;
		}

		/// <summary>
		/// Identifier of contract
		/// </summary>
		public string ContractNumber
		{
			get;
			set;
		}

		/// <summary>
		/// Identifier of account
		/// </summary>
		public string AccountId
		{
			get;
			set;
		}

		/// <summary>
		/// Identifier of product
		/// </summary>
		public string ProductId
		{
			get;
			set;
		}

		/// <summary>
		/// Identifier of rate
		/// </summary>
		public int RateId
		{
			get;
			set;
		}

		/// <summary>
		/// Rate
		/// </summary>
		public decimal Rate
		{
			get;
			set;
		}

		/// <summary>
		/// Rate end date
		/// </summary>
		public DateTime RateEndDate
		{
			get;
			set;
		}

		/// <summary>
		/// Event effective date
		/// </summary>
		public DateTime EventEffectiveDate
		{
			get;
			set;
		}

		/// <summary>
		/// Contract type
		/// </summary>
		public string ContractType
		{
			get;
			set;
		}

		/// <summary>
		/// Contract date
		/// </summary>
		public DateTime ContractDate
		{
			get;
			set;
		}

		/// <summary>
		/// Contract end date
		/// </summary>
		public DateTime ContractEndDate
		{
			get;
			set;
		}

		/// <summary>
		/// Flow start date
		/// </summary>
		public DateTime DateFlowStart
		{
			get;
			set;
		}

		/// <summary>
		/// Date of deal submission
		/// </summary>
		public DateTime DateSubmit
		{
			get;
			set;
		}

		/// <summary>
		/// Date of deal
		/// </summary>
		public DateTime DateDeal
		{
			get;
			set;
		}

		/// <summary>
		/// Sales channel ID
		/// </summary>
		public string SalesChannelId
		{
			get;
			set;
		}

		/// <summary>
		/// Sales representative
		/// </summary>
		public string SalesRep
		{
			get;
			set;
		}

		/// <summary>
		/// Product type record identifier
		/// </summary>
		public int ProductTypeID
		{
			get;
			set;
		}

		internal void CalculateGrossProfit()
		{
			this.TermGrossProfit = (Convert.ToDecimal( this.AnnualUsage ) * this.GrossMargin * (Convert.ToDecimal( this.Term ) / Convert.ToDecimal( 12 ))) / Convert.ToDecimal( 1000 );
			this.AnnualGrossProfit = (Convert.ToDecimal( this.AnnualUsage ) * this.GrossMargin) / Convert.ToDecimal( 1000 );
		}
	}
}
