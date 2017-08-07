using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CustomerAcquisition.Prospects;
using LibertyPower.Business.CustomerAcquisition.ProspectManagement;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class ContractSubmission
	{
		public static void ContractSubmit( string username, ProspectContract contract )
		{
			if( contract.Market.Code == "NJ" )
			{
				foreach( ProspectAccount account in contract.Accounts )
				{
					RetailMarketSalesTax salesTax = MarketFactory.GetMarketSalesTax( account.Market, contract.DateDeal );

					if( salesTax != null )
						account.Rate = account.Rate / (decimal) (1.0 + salesTax.SalesTax);
				}
			}

			try
			{
				ContractValidation.ValidateContract( username, contract );
			}
			catch( Exception e )
			{
				throw new Exception( e.Message );
			}
			ContractFactory.Create( username, contract );
		}

	}
}
