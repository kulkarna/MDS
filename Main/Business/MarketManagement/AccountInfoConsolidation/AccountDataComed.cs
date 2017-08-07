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
	public class AccountDataComed : AccountData
	{
		public AccountDataComed( string accountNumber, string utilityCode )
			: base( accountNumber, utilityCode )
		{
		}

		internal override bool GetProperties()
		{
			try
			{
				DataSet ds = TransactionsSql.GetComedAccountLatest( AccountNumber );
				if( DataSetHelper.HasRow( ds ) )
				{
					BillingCycle = GetCleanBillingValue( ds.Tables[0].Rows[0]["MeterBillGroupNumber"] );
					Icap = GetCleanCapValue( ds.Tables[0].Rows[0]["CapacityPLC1Value"] );
					Tcap = GetCleanCapValue( ds.Tables[0].Rows[0]["NetworkServicePLCValue"] );
					return true;
				}
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
