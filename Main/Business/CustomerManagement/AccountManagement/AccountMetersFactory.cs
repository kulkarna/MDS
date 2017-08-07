using System;
using System.Collections.Generic;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.AccountSql;


namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class AccountMetersFactory
	{
		public static AccountMeters GetAccountMeters( DataRow dr )
		{
			string accountId = Convert.ToString( dr["Account_ID"] );
			string meterNumber = Convert.ToString( dr["Meter_Number"] );
			return new AccountMeters( accountId, meterNumber );
		}


		public static List<AccountMeters> GetAccountMeters( string legacyAccountId )
		{
			var meters = new List<AccountMeters>();
			DataSet ds = AccountSql.SelectAccountMeters( legacyAccountId );

			if( CommonBusiness.CommonHelper.DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow row in ds.Tables[0].Rows )
				{
					meters.Add( new AccountMeters( legacyAccountId, row["meter_number"].ToString() ) );
				}
			}
			return meters;
		}


		public static AccountMeters InsertAccountMeters( string accountId, string meterNumber )
		{
			AccountSql.insertAccountMeters( accountId, meterNumber );
			return new AccountMeters( accountId, meterNumber );
		}


		public static List<AccountMeters> InsertAccountMeters( string accountId, List<string> meterNumbers )
		{
			if( meterNumbers != null && meterNumbers.Count > 0 )
			{
				foreach( var number in meterNumbers )
				{
					AccountSql.insertAccountMeters( accountId, number );
				}
			}
			return GetAccountMeters( accountId );
		}
	}

}
