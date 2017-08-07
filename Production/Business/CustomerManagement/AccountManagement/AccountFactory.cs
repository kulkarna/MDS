namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	using System;
	using System.Data;
	using System.Collections.Generic;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

	/// <summary>
	/// Account related methods
	/// </summary>
	public static class AccountFactory
	{
		/// <summary>
		/// Gets list of account types
		/// </summary>
		/// <returns>Returns a list of account types.</returns>
		public static AccountTypeList GetAccountTypes()
		{
			AccountTypeList list = new AccountTypeList();

			DataSet ds = GeneralSql.GetAccountTypes();
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( CreateAccountType( dr ) );
			}

			return list;
		}

		public static AccountType GetAccountType( int accountTypeIdentity )
		{
			AccountType at = null;

			DataSet ds = GeneralSql.GetAccountType( accountTypeIdentity );
			if( DataSetHelper.HasRow( ds ) )
				at = CreateAccountType( ds.Tables[0].Rows[0] );

			return at;
		}

		/// <summary>
		/// Creates an account type entity by accountType
		/// </summary>
		/// <param name="accountType">string</param>
		/// <returns>Returns an account type entity.</returns>
		public static AccountType GetAccountType(string accountType)
		{
			AccountType at = null;

			DataSet ds = GeneralSql.GetAccountType(accountType);
			if (DataSetHelper.HasRow(ds))
				at = CreateAccountType(ds.Tables[0].Rows[0]);

			return at;
		}

		/// <summary>
		/// Creates an account type object from datarow
		/// </summary>
		/// <param name="dr">Datarow</param>
		/// <returns>Returns an account type object from datarow.</returns>
		private static AccountType CreateAccountType( DataRow dr )
		{
			AccountType at = new AccountType();
			at.Id = Convert.ToInt32( dr["ID"] );
			at.Description = dr["AccountType"].ToString();
			at.DisplayDescription = dr["Description"].ToString();

			return at;
		}
	}
}
