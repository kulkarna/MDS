using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Runtime.InteropServices;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CommonBusiness.CommonExceptions;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// Rule to determine if contract is renewable
	/// </summary>
	[Guid( "6688514C-B4CD-4a27-A6DB-C1A6AF9A89C8" )]
	public class RenewableContractRule : BusinessRule
	{
		private string contractNumber;
		private int maximumMonths;

		/// <summary>
		/// Constructor that takes a contract number and 
		/// the maximum number of months in advance that a contract can renew.
		/// </summary>
		/// <param name="maximumMonths">Maximum number of months in advance that a contract can renew</param>
		/// <param name="contractNumber">Contract number</param>
		public RenewableContractRule( string contractNumber, int maximumMonths )
			: base( "Renewable Contract Rule", BrokenRuleSeverity.Error )
		{
			this.contractNumber = contractNumber;
			this.maximumMonths = maximumMonths;
		}

		/// <summary>
		/// Validate
		/// </summary>
		/// <returns>True or false</returns>
		public override bool Validate()
		{
			DateTime maximumDate = DateTime.Today.AddMonths( maximumMonths );

			// get contract object containing account list
			Contract contract = ContractFactory.GetContractWithAccounts( this.contractNumber );

			// if there are accounts, then validate
			if( contract.Accounts.Count > 0 )
			{
				// build date list for finding earliest contract end date
				List<DateTime> dateList = new List<DateTime>();
				//foreach( CompanyAccount account in contract.Accounts )
				//{
				//    dateList.Add( account.ContractEndDate );
				//}

				// find earliest end date
				DateTime minimumEndDate = DateHelper.GetMinimumDate( dateList );

				foreach( CompanyAccount account in contract.Accounts )
				{
					//DataSet ds = ProductSql.GetProductByProductId( account.Product );

					// if product is not a fixed product, 
					// contract can be renewed at any time, 
					// so skip validation
					//if( ds != null )
					//    if( ds.Tables[0] != null )
					//        if( ds.Tables[0].Rows.Count > 0 )
					//        {
					//            if( (ds.Tables[0].Rows[0]["product_category"].ToString().Contains( "FIXED" ))
					//                && (minimumEndDate > maximumDate) )
					//            {
					//                DateTime minimumRenewalDate = minimumEndDate.AddMonths( -maximumMonths );
					//                string format = "Current contract cannot be renewed before {0}.";
					//                string reason = string.Format( format, minimumRenewalDate.ToShortDateString() );
					//                this.SetException( reason );

					//                return false; // rule has been broken, exit...
					//            }
					//        }
				}
			}

			return this.Exception == null;
		}
	}
}
