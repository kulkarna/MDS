using System;
using System.Data.SqlClient;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.IstaSql;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public static class IstaMeterReadFactory
	{

		// ------------------------------------------------------------------------------------
		public static UsageList GetListByOffer( string offerID, string utilityCode, DateTime fromDate, DateTime toDate )
		{
			DataSet ds1 = IstaMeterReadSql.GetIstaMeterReadsByOffer( offerID, utilityCode, fromDate, toDate );
			return GetList( ds1 );
		}

		// ------------------------------------------------------------------------------------
		public static UsageList GetList( string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate )
		{
			DataSet ds1 = IstaMeterReadSql.GetIstaMeterReads( accountNumber, utilityCode, fromDate, toDate );
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
		private static Usage GetItem( DataRow row )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = (string) row["utilityCode"];
			DateTime from = (DateTime) row["fromDate"];
			DateTime to = (DateTime) row["toDate"];
			int kwh = (int) row["totalKWH"];
			UsageType usgType = UsageType.Billed;

			item = new Usage( account, utility, UsageSource.Ista, usgType, from, to, kwh );
			item.IsConsolidated = false;
			item.MeterNumber = "";
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;

			return item;
		}
	}
}
