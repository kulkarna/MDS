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
	public class AccountDataRge : AccountData
	{
		private const int UtilityId = 18;

		public AccountDataRge( string accountNumber, string utilityCode )
			: base( accountNumber, utilityCode )
		{
		}

		internal override bool GetProperties()
		{
			try
			{
				DataSet ds = TransactionsSql.GetRgeAccountLatest( AccountNumber );
				if( DataSetHelper.HasRow( ds ) )
				{
					Profile = GetStringValue( ds.Tables[0].Rows[0]["Profile"] );
					Icap = GetCleanCapValue( ds.Tables[0].Rows[0]["Icap"] );
					Zone = GetStringValue( ds.Tables[0].Rows[0]["Grid"] );
					ServiceClass = GetStringValue( ds.Tables[0].Rows[0]["CurrentRateCategory"] );
                    BillingCycle = GetStringValue(ds.Tables[0].Rows[0]["BillGroup"]);
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
