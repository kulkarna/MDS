using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class CommissionFactory
	{
		public static CommissionTransactionList GetUnprocessedCommissionTransactions()
		{
			CommissionTransactionList list = new CommissionTransactionList();
			DataSet ds = CommissionSql.GetUnprocessedCommissionTransactions();

			if( ds != null && ds.Tables != null && ds.Tables.Count > 0 )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					CommissionTransaction ct = new CommissionTransaction();
					ct.AccountId = dr["AccountId"].ToString();
					ct.AccountNumber = dr["AccountNumber"].ToString();
					ct.ContractNumber = dr["ContractNumber"].ToString();
					ct.HousePct = Convert.ToDecimal( dr["HousePct"] );
					ct.Rate = Convert.ToDecimal( dr["Rate"] );
					ct.RateRequested = Convert.ToDecimal( dr["RateRequested"] );
					ct.RateSplitPoint = Convert.ToDecimal( dr["RateSplitPoint"] );
					ct.ReportDate = Convert.ToDateTime( dr["ReportDate"] );
					ct.TransactionDetailId = Convert.ToInt32( dr["TransactionDetailId"] );
					ct.UtilityCode = dr["UtilityCode"].ToString();
					ct.VendorPct = Convert.ToDecimal( dr["VendorPct"] );

					list.Add( ct );
				}
			}
			return list;
		}
	}
}
