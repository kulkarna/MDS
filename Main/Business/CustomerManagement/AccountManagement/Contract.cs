using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// 
	/// </summary>
	public class Contract
	{
		/// <summary>
		/// Constructor taking a contract number
		/// </summary>
		/// <param name="contractNumber">Contract number</param>
		public Contract( string contractNumber )
		{
			this.contractNumber = contractNumber;
		}

		private List<CompanyAccount> accounts;
		private string contractNumber;
		/// <summary>
		/// Contract ID (unique ID of the Contract)
		/// </summary>
		public int ContractID
		{
			get;
			set;
		}

		/// <summary>
		/// 
		/// </summary>
		public string ContractNumber
		{
			get { return contractNumber; }
			set { contractNumber = value; }
		}

		private string market;

		/// <summary>
		/// 
		/// </summary>
		public string Market
		{
			get { return market; }
			set { market = value; }
		}

		private string contractTYpe;

		/// <summary>
		/// 
		/// </summary>
		public string ContractType
		{
			get { return contractTYpe; }
			set { contractTYpe = value; }
		}


		private string userName;

		/// <summary>
		/// 
		/// </summary>
		public string UserName
		{
			get { return userName; }
			set { userName = value; }
		}

		/// <summary>
		/// 
		/// </summary>
		public List<CompanyAccount> Accounts
		{
			get { return accounts; }
			set { accounts = value; }
		}

		private ContractTemplateVersion version;

		public ContractTemplateVersion Version
		{
			get { return version; }
			set { this.version = value; }
		}

		/// <summary>
		/// GetRenewalAccount for adding an account to the account list
		/// </summary>
		/// <param name="account">Account object</param>
		public void AddAccount( CompanyAccount account )
		{
			if( accounts == null )
				accounts = new List<CompanyAccount>();

			if( !accounts.Contains( account ) )
				accounts.Add( account );
		}

		/// <summary>
		/// This method will return a sum off all the annual usage values.  
		/// If the ActiveOnly flag is set, it will not count statuses 911000, 999998, and 999999.
		/// </summary>
		/// <param name="c">Contract object</param>
		/// <param name="activeOnly">ActiveOnly flag</param>
		/// <returns>sum off all the annual usage values.</returns>
		public double GetTotalUsage( Contract c, bool activeOnly )
		{
			return AccountSql.GetContractTotalUsage( c.ContractNumber, activeOnly );
		}

		/// <summary>
		/// Calculate the sum of accounts total AnnualUsage of this contract
		/// </summary>
		public int TotalUsage
		{
			get
			{
				int totalUsage = 0;
				foreach( CompanyAccount account in this.accounts )
				{
					totalUsage += account.AnnualUsage;
				}
				return totalUsage;
			}
		}

		/// <summary>
		/// Gets the smallest end date of an account of the contract
		/// </summary>
		public DateTime MinimumContractEndDate
		{
			get
			{
				if( this.Accounts.Count > 0 )
				{
					DateTime minimumEndDate = DateTime.MaxValue;
					foreach( CompanyAccount account in this.Accounts )
					{
						if( account.ContractEndDate < minimumEndDate )
							minimumEndDate = account.ContractEndDate;
					}
					return minimumEndDate.Date;
				}
				else
					return DateTime.MinValue.Date;
			}
		}

		/// <summary>
		/// Gets the smallest meter read date of an account of the contract
		/// </summary>
		public DateTime MinimumMeterReadDate
		{
			get
			{
				if( this.Accounts.Count > 0 )
				{
					DateTime minimumMeterReadDate = DateTime.MaxValue;
					foreach( CompanyAccount account in this.Accounts )
					{
						if( account.MinimumMeterReadDate < minimumMeterReadDate )
							minimumMeterReadDate = account.MinimumMeterReadDate;
					}
					return minimumMeterReadDate.Date;
				}
				else
					return DateTime.MinValue.Date;
			}
		}

		/// <summary>
		/// Verifies if a contract contains a product that is default variable
		/// </summary>
		public bool IsInDefaultVariable
		{
			get
			{
				foreach( CompanyAccount account in this.Accounts )
				{
					if( account.IsInDefaultVariable )
						return true;
				}
				return false;
			}
		}

		/// <summary>
		/// Verifies if a contract is expired: if its end date is smaller than today
		/// OR if it is in default variable
		/// </summary>
		public bool IsExpired
		{
			get
			{
				return ((this.MinimumContractEndDate < DateTime.Today.Date) || (this.IsInDefaultVariable));
			}
		}

		/// <summary>
		/// Gets the mimimum date to start a renewal of the contract
		/// </summary>
		public DateTime MinimumContractRenewalStartDate
		{
			get
			{
                if (this.Accounts != null && this.Accounts.Count > 0)
                {
                    DateTime minimumRenewalStartDate = DateTime.MaxValue;
                    foreach (CompanyAccount account in this.Accounts)
                    {
                        if (account.MinimumAccountRenewalStartDate < minimumRenewalStartDate)
                            minimumRenewalStartDate = account.MinimumAccountRenewalStartDate;
                    }
                    return minimumRenewalStartDate.Date;
                }
                else
                    return DateTime.MinValue.Date;
			}
		}

		public Tuple<DateTime,DateTime> MinimumContractPricingMonthandRenewalDate
		{
			get
			{
				if( this.Accounts != null && this.Accounts.Count > 0 )
				{
					DateTime minimumPricingStartMonth = DateTime.MaxValue;
					DateTime minimumRenStartDate = DateTime.MinValue;
					foreach( CompanyAccount account in this.Accounts )
					{
						MeterReadCalendar meterreadcalendar= new MeterReadCalendar();;
						meterreadcalendar= account.GetMinEligiblePricingMonth();

						if( meterreadcalendar.Start_Month < minimumPricingStartMonth )
						{
							minimumPricingStartMonth = meterreadcalendar.Start_Month;
							minimumRenStartDate = (meterreadcalendar.Read_Start_Date.HasValue) ? meterreadcalendar.Read_Start_Date.Value : DateTime.MinValue.Date;
						}
						
					}
					return Tuple.Create(minimumPricingStartMonth.Date,minimumRenStartDate.Date);
				}
				else
					return Tuple.Create( DateTime.MinValue.Date, DateTime.MinValue.Date );
			}
		}

	}
}
