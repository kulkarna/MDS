using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class MultiTermEtfCalculator : EtfCalculator
	{
		#region Fields

		private CompanyAccountType companyAccountType;
		private decimal SUT;
		private decimal commercialMultiplier;
		private int remainingMonthsInContract;
		private int remainingUsage;
		private int salesChannelID;

		#endregion

		#region Properties

		#endregion

		#region Constructors

		public MultiTermEtfCalculator( CompanyAccount companyAccount, DateTime deenrollmentDate, EtfCalculationType etfCalculationType, CompanyAccountType companyAccountType )
			: base( EtfCalculatorType.MultiTermCalculator, companyAccount, deenrollmentDate, etfCalculationType )
		{
			this.companyAccountType = companyAccountType;
			this.remainingMonthsInContract = GetRemainingMonths();
			this.remainingUsage = (this.CompanyAccount.AnnualUsage / 12) * this.remainingMonthsInContract;
			this.commercialMultiplier = 0.007M;

			if( companyAccount.RetailMarketCode == "NJ" )
			{
				SUT = 0.07M;
			}
			else
			{
				SUT = 0M;
			}
		}

		#endregion

		#region Event Handlers

		#endregion

		#region Methods

		public override EtfCalculator Calculate()
		{
			if( companyAccountType == CompanyAccountType.RESIDENTIAL || companyAccountType == CompanyAccountType.RES )
			{
				this.CalculatedEtfAmount = 10 * this.remainingMonthsInContract;
			}
			else // Commercial
			{
				decimal fee1 = CommercialComputation1();

				decimal fee2 = CommercialComputation2();

				this.CalculatedEtfAmount = Math.Max( fee1, fee2 );
			}

			return this;
		}

		private decimal CommercialComputation1()
		{
			return commercialMultiplier * this.remainingUsage;
		}

		private decimal CommercialComputation2()
		{
			#region Locals

			int salesChannelID = 0;
			int salesChannelChannelGroupID = 0;
			int costRuleSetID = 0;
			DateTime signedDate;
			DateTime startDate;
			int marketID = 0;
			int utilityID = 0;
			decimal contractRate = 0;
			decimal transferRate = 0;
			decimal commission = 0;
			decimal currentMarketRate = 0; // Cost
			int annualUsage = this.CompanyAccount.AnnualUsage;
			int contractTerm = 0;
			decimal sum = 0M;

			#endregion

			using( LibertyPowerEntities context = new LibertyPowerEntities() )
			{
				#region Query to get rates

				var rates =
					(from ACR in context.AccountContractRates
					 join AC in context.AccountContracts on ACR.AccountContractID equals AC.AccountContractID
					 join A in context.Accounts on AC.AccountID equals A.AccountID
					 join C in context.Contracts on AC.ContractID equals C.ContractID
					 join MULT in context.ProductCrossPriceMultis on ACR.ProductCrossPriceMultiID equals MULT.ProductCrossPriceMultiID
					 where
						AC.AccountID == this.CompanyAccount.Identity &&
						C.Number == this.CompanyAccount.ContractNumber &&
						ACR.IsContractedRate == true
					 select new
					 {
						 C.SignedDate,
						 C.StartDate,
						 C.SalesChannelID,
						 MarketID = A.RetailMktID,
						 A.UtilityID,
						 ContractRate = ACR.Rate,
						 SubTerm = ACR.Term,
						 ACR.RateStart,
						 ACR.RateEnd,
						 TransferRate = MULT.Price
					 }).ToList();

				#endregion



				if( rates.Count == 0 )
				{
					this.ErrorMessage = "No subterms were found";
					return 0;
				}
				else
				{
					salesChannelID = rates[0].SalesChannelID;
					signedDate = rates[0].SignedDate;

					salesChannelChannelGroupID = GetSalesChannelChannelGroupID( context, salesChannelID, signedDate );
					if( salesChannelChannelGroupID == -1 )
					{
						this.ErrorMessage = "Could not locate SalesChannelChannelGroupID";
						return 0;
					}

					costRuleSetID = GetCostRuleSetID( context, signedDate );
					if( costRuleSetID == -1 )
					{
						this.ErrorMessage = "Could not locate CostRuleSetID";
						return 0;
					}

					marketID = rates[0].MarketID.Value;
					utilityID = rates[0].UtilityID.Value;
					startDate = rates[0].StartDate;

					foreach( var rate in rates )
					{
						contractTerm += rate.SubTerm.Value;
					}
				}

				foreach( var rate in rates )
				{
					contractRate = Convert.ToDecimal( rate.ContractRate.Value );
					transferRate = rate.TransferRate;
					commission = contractRate - transferRate;

					sum += (contractRate / (1 + this.SUT) - (currentMarketRate + commission)) * this.remainingMonthsInContract * (annualUsage / 12);
				}

			}
			return sum;
		}

		private int GetSalesChannelChannelGroupID( LibertyPowerEntities context, int salesChannelID, DateTime signedDate )
		{
			var salesChannelChannelGroups =
				(from
					CG in context.SalesChannelChannelGroups
				 where
					CG.ChannelID == salesChannelID &&
					CG.EffectiveDate <= signedDate &&
					(!CG.ExpirationDate.HasValue || CG.ExpirationDate.Value >= signedDate)
				 select new
				 {
					 CG.ChannelGroupID
				 }).ToList().FirstOrDefault();


			if( salesChannelChannelGroups != null )
			{
				return salesChannelChannelGroups.ChannelGroupID;
			}
			else
			{
				return -1;
			}
		}

		private int GetCostRuleSetID( LibertyPowerEntities context, DateTime signedDate )
		{
			var maxProductCostRuleSetID =
				(from
					RS in context.ProductCostRuleSets
				 where
					RS.EffectiveDate < signedDate
				 select RS.ProductCostRuleSetID).DefaultIfEmpty().Max();

			if( maxProductCostRuleSetID != null )
			{
				return maxProductCostRuleSetID;
			}
			else
			{
				return -1;
			}
		}

		private int GetRemainingMonths()
		{
			int totalContractDays = GetTotalContractDays( CompanyAccount.Term );
			DateTime contractEndDate = GetContractEndDate( CompanyAccount.ContractStartDate, totalContractDays );
			int contractDaysLeft = GetContractDaysLeft( contractEndDate, DeenrollmentDate );
			return (int) contractDaysLeft / (365 / 12);
		}



		#endregion
	}
}
