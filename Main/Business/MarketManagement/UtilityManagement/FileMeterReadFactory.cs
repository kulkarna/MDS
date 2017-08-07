namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Data.SqlClient;
	using System.Data;

	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	public static class FileMeterReadFactory
	{
		/// <summary>
		/// Returns usage list of file meter reads
		/// </summary>
		/// <param name="offerID"></param>
		/// <param name="utilityCode"></param>
		/// <param name="fromDate"></param>
		/// <param name="toDate"></param>
		/// <returns></returns>
		public static UsageList GetListByOffer( string offerID, string utilityCode, DateTime fromDate, DateTime toDate )
		{
			DataSet ds = TransactionsSql.GetFileMeterReadsByOffer( offerID, utilityCode, fromDate, toDate );
			return GetList( ds );
		}

		/// <summary>
		/// Returns usage list of file meter reads
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="utilityCode"></param>
		/// <param name="fromDate"></param>
		/// <param name="toDate"></param>
		/// <returns></returns>
		public static UsageList GetList( string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate )
		{
			DataSet ds = TransactionsSql.GetFileMeterReads( accountNumber, utilityCode, fromDate, toDate );
			return GetList( ds );
		}

		private static UsageList GetList( DataSet ds )
		{
			UsageList list = null;

			if( DataSetHelper.HasRow(ds) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetItem( dr ) );
				}
			}
			return list;
		}

		private static Usage GetItem( DataRow dr )
		{
			Usage item = null;

			string accountNumber = dr["AccountNumber"].ToString();
			string utilityCode = dr["UtilityCode"].ToString();
			DateTime fromDate = Convert.ToDateTime( dr["FromDate"] );
			DateTime toDate = Convert.ToDateTime( dr["ToDate"] );
			int totalKwh = Convert.ToInt32( dr["TotalKwh"] );
			string ut = dr["UsageType"].ToString();
			UsageType usageType = (UsageType) Enum.Parse( typeof( UsageType ), ut );

			item = new Usage( accountNumber, utilityCode, UsageSource.User, usageType, fromDate, toDate, totalKwh );

			item.MeterNumber = dr["MeterNumber"] == DBNull.Value ? "" : (string) dr["MeterNumber"];
			item.IsConsolidated = false;
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;

			return item;
		}
	}
}
