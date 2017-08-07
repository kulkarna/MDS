using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.MarketManagement.AccountInfo;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
	public class AccountDataEdi : AccountData
	{
		public AccountDataEdi( string accountNumber, string utilityCode, AccountDataSource.ESource source )
			: base( accountNumber, utilityCode, source )
		{
		}

		internal override bool GetProperties()
		{
			try
			{
				DataSet ds = TransactionsSql.GetEdiAccountLatest( AccountNumber, UtilityCode );
				if( DataSetHelper.HasRow( ds ) )
				{
					Zone = GetStringValue( ds.Tables[0].Rows[0]["ZoneCode"] );
					BillingCycle = GetCleanBillingValue( ds.Tables[0].Rows[0]["BillGroup"] );
					Profile = GetStringValue( ds.Tables[0].Rows[0]["LoadProfile"] );
					ServiceClass = GetStringValue( ds.Tables[0].Rows[0]["RateClass"] );
					Icap = GetCleanCapValue( ds.Tables[0].Rows[0]["Icap"] );
					Tcap = GetCleanCapValue( ds.Tables[0].Rows[0]["Tcap"] );

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
		internal override void AssignProperties( string zone, string profile, string serviceClass, string billingCycle, string icap, string tcap )
		{
			try
			{
                //Getting utilities with ISO 2 - ERCOT
                UtilityList utilities = UtilityFactory.GetUtilitiesByWholesaleMarketId(2);

                string zoneValue;

                if (utilities.Count(x => x.Code == this.UtilityCode) > 0)
                {
                    zoneValue = AccountInfoFacotry.GetZoneValueBySubstation(GetStringValue(zone));
                }
                else
                {
                    zoneValue = GetStringValue(zone);
                }

                Zone = zoneValue;

				Profile = GetProfileValue( GetStringValue( profile ) );
				ServiceClass = GetStringValue( serviceClass );
				BillingCycle = GetCleanBillingValue( billingCycle );
				Icap = GetCleanCapValue( icap );
				Tcap = GetCleanCapValue( tcap );
			}
			catch( Exception ex )
			{
				Message = AccountNumber + @"/" + UtilityCode + ":" + MethodBase.GetCurrentMethod().Name + "-" + ex.Message;
			}
		}
	}
}
