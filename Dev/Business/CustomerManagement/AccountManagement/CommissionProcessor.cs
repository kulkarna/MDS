using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class CommissionProcessor
	{
		/// <summary>
		/// Insert records for Account Event History for any commissions for which there is a split.
		/// LPC's portion of the split must be added to the gross margin.
		/// </summary>
		public static void ProcessCommissionTransactions()
		{
			StringBuilder sb = new StringBuilder();
			CommissionTransactionList list = CommissionFactory.GetUnprocessedCommissionTransactions();

			foreach( CommissionTransaction ct in list )
			{
				try
				{
					AccountEventProcessor.ProcessEvent( AccountEventType.Commission, ct.AccountNumber, ct.UtilityCode, ct );
					CommissionSql.UpdateCommissionTransactionsDetailIdProcessed( ct.TransactionDetailId, ct.ReportDate );
				}
				catch( Exception ex )
				{
					ErrorFactory.LogError( ct.AccountNumber, "ProcessCommissionTransactions", ex.Message + " __ Stack Trace: " + ex.StackTrace, DateTime.Now );
				}
			}
		}
	}
}
