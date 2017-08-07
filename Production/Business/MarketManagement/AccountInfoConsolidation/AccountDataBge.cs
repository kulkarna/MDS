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
	public class AccountDataBge : AccountData
	{
		public AccountDataBge( string accountNumber, string utilityCode )
			: base( accountNumber, utilityCode )
		{
		}

		internal override bool GetProperties()
		{
			try
			{
				DataSet ds = TransactionsSql.GetBgeAccountLatest( AccountNumber );
				if( DataSetHelper.HasRow( ds ) )
				{
					BillingCycle = GetCleanBillingValue( ds.Tables[0].Rows[0]["BillGroup"] );
					Icap = GetCleanCapValue( ds.Tables[0].Rows[0]["CapPLC"] );
					Tcap = GetCleanCapValue( ds.Tables[0].Rows[0]["TransPLC"] );
					ServiceClass = GetStringValue( ds.Tables[0].Rows[0]["CustomerSegment"] );
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
