using System;
using System.Data.SqlClient;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.HistoricalInfoSql;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public static class ProspectAccountBillingInfoFactory
	{
		// ------------------------------------------------------------------------------------
		public static UsageList GetList( string accountNumber, string utilityCode, DateTime beginDate, DateTime endDate )
		{
			DataSet ds = ProspectAccountBillingInfoSql.SelectProspectAccountBillingInfo( accountNumber, utilityCode, beginDate, endDate );
			return GetList( ds );
		}

		// EP - 12/17/2008 --------------------------------------------------------------------
		public static UsageList GetList( string accountNumber, string utilityCode )
		{
			DataSet ds = ProspectAccountBillingInfoSql.SelectProspectAccountBillingInfo( accountNumber, utilityCode );
			return GetList( ds );
		}

		// ------------------------------------------------------------------------------------
		private static UsageList GetList( DataSet dataSet )
		{
			UsageList usageList = null;

			if( dataSet != null && dataSet.Tables.Count > 0 && dataSet.Tables[0].Rows.Count > 0 )
			{
				usageList = new UsageList();

				foreach( DataRow dr in dataSet.Tables[0].Rows )
				{
					usageList.Add( GetList( dr ) );
				}
			}

			return usageList;
		}

		// ------------------------------------------------------------------------------------
		private static Usage GetList( DataRow dataRow )
		{
			Usage usage = null;

			if( dataRow != null )
			{
				string accountNumber = (string) dataRow["AccountNumber"];
				string utilityCode = (string) dataRow["UtilityCode"];
				UsageSource usageSource = UsageSource.ProspectAccountBilling;
				UsageType usageType = UsageType.Historical;
				DateTime beginDate = (DateTime) dataRow["FromDate"];
				DateTime endDate = (DateTime) dataRow["ToDate"];

				usage = new Usage( accountNumber, utilityCode, usageSource, usageType, beginDate, endDate );
				usage.TotalKwh = (int) (decimal) dataRow["TotalKwh"];
				usage.OnPeakKwh = dataRow["OnPeakKwh"] == DBNull.Value ? null : (decimal?) decimal.Parse( (string) dataRow["OnPeakKwh"] );
				usage.OffPeakKwh = dataRow["OffPeakKwh"] == DBNull.Value ? null : (decimal?) decimal.Parse( (string) dataRow["OffPeakKwh"] );
				usage.BillingDemandKw = dataRow["BillingDemandKw"] == DBNull.Value ? null : (decimal?) (double) dataRow["BillingDemandKw"];
				usage.DateCreated = dataRow["Created"] == DBNull.Value ? null : (DateTime?) dataRow["Created"];
				usage.CreatedBy = dataRow["CreatedBy"] == DBNull.Value ? null : (string) dataRow["CreatedBy"];
				usage.DateModified = dataRow["Modified"] == DBNull.Value ? null : (DateTime?) dataRow["Modified"];
				usage.ModifiedBy = dataRow["ModifiedBy"] == DBNull.Value ? null : (string) dataRow["ModifiedBy"];
				usage.IsConsolidated = false;

				//Console.WriteLine( "ProspectAccountBillingInfoFactory= " + usage.AccountNumber + ", Type:" + usage.UsageType + ", Begin= " + usage.BeginDate + ", End= " + usage.EndDate + ", Kwh= " + usage.TotalKwh + ", Source= " + usage.UsageSource );
			}

			return usage;
		}

		// ------------------------------------------------------------------------------------
		public static Usage InsertUsageIntoBillingInfo( Usage usage, string meterNumber, string userName )
		{
			Usage newUsage = null;

			// TODO: values for monthlyPeakDemand and currentCharges? (see null param values)
			DataSet ds = ProspectAccountBillingInfoSql.InsertProspectAccountBillingInfo(
				usage.AccountNumber, usage.UtilityCode, usage.BeginDate, usage.EndDate,
				usage.TotalKwh, usage.Days, meterNumber, usage.OnPeakKwh,
				usage.OffPeakKwh, usage.BillingDemandKw, null, null, userName );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				newUsage = GetList( ds.Tables[0].Rows[0] );
			}

			return newUsage;
		}

	}
}
