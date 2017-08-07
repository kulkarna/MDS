using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
	public class AccountDataCenhud : AccountData
	{
		public AccountDataCenhud( string accountNumber, string utilityCode )
			: base( accountNumber, utilityCode )
		{
		}

		internal override bool GetProperties()
		{
			try
			{
				DataSet ds = TransactionsSql.GetCenhudAccountLatest( AccountNumber );
				if( DataSetHelper.HasRow( ds ) )
				{
					Zone = GetStringValue( ds.Tables[0].Rows[0]["LoadZone"] );
					BillingCycle = GetCleanBillingValue( ds.Tables[0].Rows[0]["BillCycle"] );
					Profile = GetStringValue( ds.Tables[0].Rows[0]["LoadProfile"] );
					ServiceClass = GetStringValue( ds.Tables[0].Rows[0]["RateCode"] );
					return true;
				}
				Message = "Account number " + AccountNumber + " was not found.";
				return false;
			}
			catch( Exception ex )
			{
				Message = AccountNumber + @"/" + UtilityCode + ":" + MethodBase.GetCurrentMethod().Name + "-" + ex.Message;
				return false;
			}
		}
	}
}
