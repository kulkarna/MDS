using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public static class CapsMarketExemptionFactory
	{
		/// <summary>
		/// Gets markets for which no icap/tcap modifcations will be performed
		/// </summary>
		/// <returns>List of CapsMarketExemptions</returns>
		public static CapsMarketExemptionDictionary GetCapsMarketExemptions()
		{
			CapsMarketExemptionDictionary list = new CapsMarketExemptionDictionary();

			DataSet ds = UtilitySql.SelectCapsMarketExemptions();

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					list.Add( dr["RetailMarketId"].ToString(), new CapsMarketExemption( dr["RetailMarketId"].ToString(),
						Convert.ToBoolean( dr["IcapException"] ), Convert.ToBoolean( dr["TcapException"] ),
						Convert.ToBoolean( dr["ZeroIcap"] ), Convert.ToBoolean( dr["ZeroTcap"] ) ) );
				}
			}

			return list;
		}
	}
}
