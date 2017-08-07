using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Returns list of peak profiles.
	/// </summary>
	/// <remarks>This is a Factory class used to
	/// retrieve lists of peak profiles.</remarks>
	public static class PeakProfileFactory
	{
		/// <summary>
		/// Overloaded method that retrieves object based on a utility id + profile
		/// </summary>
		/// <param name="utilityId">Identifier for utility</param>
		/// <param name="loadShapeId">Load Shape ID</param>
		/// <param name="dateRange">Begin and end dates</param>
		/// <returns>PeakProfileDictionary</returns>
		public static PeakProfileDictionary GetDictionary( string utilityId, string loadShapeId, DateRange dateRange )
		{
			DataSet ds1 = UsageSql.GetPeakProfiles( utilityId, loadShapeId, dateRange.StartDate, dateRange.EndDate );
			return GetDictionary( ds1 );
		}

		/// <summary>
		/// Builds dictionary
		/// </summary>
		/// <param name="ds">DataSet</param>
		/// <returns>PeakProfileDictionary</returns>
		public static PeakProfileDictionary GetDictionary( DataSet ds )
		{
			PeakProfileDictionary dictionay = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( dictionay == null ) { dictionay = new PeakProfileDictionary(); }

					DateTime profileDay = (DateTime) dr1["ProfileDate"];
					dictionay.Add( profileDay, PeakProfileFactory.GetInstance( dr1 ) );
				}
			}
			return dictionay;
		}

		/// <summary>
		/// Builds object
		/// </summary>
		/// <param name="dr">DataRow</param>
		/// <returns>PeakProfile</returns>
		public static PeakProfile GetInstance( DataRow dr )
		{
			PeakProfile item = null;

			if( dr != null )
			{
				decimal dailyValue = Convert.ToDecimal( dr["DailyValue"] );
				decimal offPeakValue = Convert.ToDecimal( dr["OffPeakValue"] );
				decimal peakRatio = Convert.ToDecimal( dr["PeakRatio"] );
				decimal peakValue = Convert.ToDecimal( dr["PeakValue"] );
				DateTime profileDate = (DateTime) dr["ProfileDate"];

				item = new PeakProfile( dailyValue, profileDate, peakRatio, peakValue, offPeakValue );
			}

			return item;
		}
	}
}
