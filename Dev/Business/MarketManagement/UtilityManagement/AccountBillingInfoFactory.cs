using System;
using LibertyPower.DataAccess.SqlAccess.HistoricalInfoSql;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public static class AccountBillingInfoFactory
	{

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire usage history of the account
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static UsageList GetList( string accountNumber, string utilityCode )
		{
			DataSet ds1 = AccountBillingInfoSql.GetAccountBillingInfo( accountNumber, utilityCode );
			return GetList( ds1 );
		}

		// ------------------------------------------------------------------------------------
		public static UsageList GetList( string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate )
		{
			DataSet ds1 = AccountBillingInfoSql.GetAccountBillingInfo( accountNumber, utilityCode, fromDate, toDate );
			return GetList( ds1 );
		}

		// ------------------------------------------------------------------------------------
		private static UsageList GetList( DataSet ds )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetItem( dr1 ) );
				}
			}

			return list;
		}

		// ------------------------------------------------------------------------------------
		private static Usage GetItem( DataRow dr )
		{
			Usage item = null;

			if( dr != null )
			{
				string account = (string) dr["AccountNumber"];
				string utility = (string) dr["UtilityCode"];
				UsageSource source = UsageSource.AccountBilling;
				UsageType type = UsageType.Historical;							//per duggy - 02/13/2009
				DateTime from = (DateTime) dr["FromDate"];
				DateTime to = (DateTime) dr["ToDate"];
				int totKwh = (int) dr["TotalKWH"];

				item = new Usage( account, utility, source, type, from, to, totKwh );

				item.DateCreated = dr["Created"] == DBNull.Value ? null : (DateTime?) dr["Created"];
				item.CreatedBy = dr["CreatedBy"] == DBNull.Value ? null : (string) dr["CreatedBy"];
				item.DateModified = dr["Modified"] == DBNull.Value ? null : (DateTime?) dr["Modified"];
				item.ModifiedBy = dr["ModifiedBy"] == DBNull.Value ? null : (string) dr["ModifiedBy"];
				item.OnPeakKwh = dr["OnPeakKwh"] == DBNull.Value ? null : (decimal?) decimal.Parse( (string) dr["OnPeakKwh"] );
				item.OffPeakKwh = dr["OffPeakKwh"] == DBNull.Value ? null : (decimal?) decimal.Parse( (string) dr["OffPeakKwh"] );
				item.BillingDemandKw = dr["BillingDemandKw"] == DBNull.Value ? null : (decimal?) (double) dr["BillingDemandKw"];
				item.IsConsolidated = false;

				//Console.WriteLine( "AccountBillingInfoFactory= " + item.AccountNumber + ", Type:" + item.UsageType + ", Begin= " + item.BeginDate + ", End= " + item.EndDate + ", Kwh= " + item.TotalKwh + ", Source= " + item.UsageSource );
			}

			return item;
		}
	}
}
