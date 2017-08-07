using System;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using System.Data;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class AccountInfoFactory
	{
		public static AccountInfo CreateAccountInfo( string account_id, string utility_id, string name_key,
								 string billingAccount, DateTime createdDate )
		{
			DataSet ds = AccountSql.insertAccountinfo( account_id, utility_id, name_key, billingAccount, createdDate );
			DataRow dr = ds.Tables[0].Rows[0];
			return GetAccountInfo( dr );
		}

		public static AccountInfo GetAccountInfo( DataRow dr )
		{
			string account_id = Convert.ToString( dr["account_id"] );
			string utility_id = Convert.ToString( dr["utility_id"] );
			string name_key = Convert.ToString( dr["name_key"] );
			string billingAccount = Convert.ToString( dr["billingAccount"] );
			string createdBy = Convert.ToString( dr["createdBy"] );
			return new AccountInfo( account_id, utility_id, name_key, billingAccount, createdBy );

		}

	}
}

