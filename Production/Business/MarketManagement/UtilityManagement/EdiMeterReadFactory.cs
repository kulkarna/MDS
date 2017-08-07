using System;
using System.Data.SqlClient;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	// April 2010
	public static class EdiMeterReadFactory
	{

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire dataset of EDI (lp_transactions) meter reads
		/// </summary>
		/// <param name="offerID"></param>
		/// <returns></returns>
		public static UsageList GetListByOffer( string offerID, string utilityCode, DateTime fromDate, DateTime toDate )
		{
			DataSet ds1 = TransactionsSql.GetEdiMeterReadsByOffer( offerID, utilityCode, fromDate, toDate );
			return GetList( ds1 );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire dataset of EDI (lp_transactions) meter reads
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static UsageList GetList( string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate )
		{
			DataSet ds1 = TransactionsSql.GetEdiMeterReads( accountNumber, utilityCode, fromDate, toDate );
			return GetList( ds1 );
		}

        public static UsageList GetList(string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate, bool forUsageConsolidation)
        {
            DataSet ds1;
            if (forUsageConsolidation)
                ds1 = TransactionsSql.GetEdiMeterReadsMostRecent(accountNumber, utilityCode, fromDate, toDate);
            else
                ds1 = TransactionsSql.GetEdiMeterReads(accountNumber, utilityCode, fromDate, toDate);
            return GetList(ds1);
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
		private static Usage GetItem( DataRow row )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = (string) row["utilityCode"];
			DateTime from = (DateTime) row["beginDate"];
			DateTime to = (DateTime) row["endDate"];
			int kwh = Convert.ToInt32( row["quantity"] );

			UsageType usageType;
			string transactionSetPurposeCode = (string) row["TransactionSetPurposeCode"];

			switch( transactionSetPurposeCode )
			{
				case "00":
					usageType = UsageType.Billed;
					break;
				case "01":
					usageType = UsageType.Canceled;
					break;
				default:														// 52 - response to historical inquiry
					usageType = UsageType.Historical;
					break;
			}

			item = new Usage( account, utility, UsageSource.Edi, usageType, from, to, kwh );

			item.MeterNumber = row["MeterNumber"] == DBNull.Value ? "" : (string) row["MeterNumber"];
			item.IsConsolidated = false;
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;

			return item;
		}

	}
}
