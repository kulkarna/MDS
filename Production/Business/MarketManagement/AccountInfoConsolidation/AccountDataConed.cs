using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
using MType = LibertyPower.Business.CommonBusiness.CommonEntity.MeterType;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
	public class AccountDataConed : AccountData
	{
		private const int UtilityId = 18;

		public AccountDataConed( string accountNumber, string utilityCode )
			: base( accountNumber, utilityCode )
		{
		}

		internal override bool GetProperties()
		{
			try
			{
				DataSet ds = TransactionsSql.GetConedAccountLatest( AccountNumber );
				if( DataSetHelper.HasRow( ds ) )
				{
					Zone = GetStringValue( ds.Tables[0].Rows[0]["LbmpZone"] );
					Stratum = GetStringValue( ds.Tables[0].Rows[0]["StratumVariable"] );
					ServiceClass = GetStringValue( ds.Tables[0].Rows[0]["ServiceClass"] );
					Icap = GetCleanCapValue( ds.Tables[0].Rows[0]["Icap"] );
					BillingCycle = GetCleanBillingValue( ds.Tables[0].Rows[0]["TripNumber"] );
					MeterType = (MType.EMeterType) MType.GetEnumFromDescription( GetStringValue( ds.Tables[0].Rows[0]["MeterType"] ), typeof( MType.EMeterType ) );

					//get the service class mapped id. if not found, attempt to use the account server rate class
					string serviceMappingId = UtilityFactory.GetStratumServiceClassMappingId( ServiceClass ) ?? ServiceClass;

					//get the stratum end corresponding to the stratum variable
					decimal stratumEnd = UtilityFactory.GetStratumEnd( UtilityId, decimal.Parse( Stratum ), serviceMappingId );

					Profile = serviceMappingId  + "-" + stratumEnd.ToString();
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
