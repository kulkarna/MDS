using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CommonBusiness.CommonExceptions;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	/// <summary>
	/// Rule for determining if specified contract is convertible
	/// </summary>
	[Guid( "2FB5B1D5-6154-4e7f-820D-CF7697FD4151" )]
	public class ContractConvertibleRule : BusinessRule
	{
		private string contractNumber;

		/// <summary>
		/// Constructor taking a contract number
		/// </summary>
		/// <param name="contractNumber">Identifier for contract</param>
		public ContractConvertibleRule( string contractNumber )
			: base( "Contract Convertible Rule", BrokenRuleSeverity.Error )
		{
			this.contractNumber = contractNumber;
		}

		/// <summary>
		/// Validate
		/// </summary>
		/// <returns>True or false</returns>
		public override bool Validate()
		{
			// get accounts for contract
			Contract contract = ContractFactory.GetContractWithAccounts( this.contractNumber );

			// loop through account list validating that each product is convertible
			foreach( CompanyAccount account in contract.Accounts )
			{
				ProductConvertibleRule rule = new ProductConvertibleRule( account.ProductRate.Product.ProductId );
				if( !rule.Validate() )
				{
					string format = "Account {0} has {1}";
					BrokenRuleException brokenRule = new BrokenRuleException( rule, string.Format( format, account.AccountNumber, rule.Exception.Message ) );
					this.AddDependentException( brokenRule );
				}
			}

			return this.Exception == null;
		}
	}
}
