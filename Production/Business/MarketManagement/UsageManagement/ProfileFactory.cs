using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Factory to select and insert profile data
	/// </summary>
	public static class ProfileFactory
	{
		/// <summary>
		/// Inserts profile header data
		/// </summary>
		/// <param name="profileHeader">ProfileHeader object</param>
		/// <returns>ID used for relationship in DailyProfileDetail</returns>
		public static Int64 InsertProfileHeader( ProfileHeader profileHeader )
		{
			return ProfileSql.InsertDailyProfileHeader( profileHeader.ISO,
				profileHeader.UtilityCode, profileHeader.LoadShapeID, profileHeader.Zone,
				profileHeader.FileName, profileHeader.CreatedBy );
		}

		/// <summary>
		/// Inserts profile detail data
		/// </summary>
		/// <param name="profileDetail">ProfileDetail object</param>
		public static void InsertProfileDetails( ProfileDetail profileDetail )
		{
			ProfileSql.InsertDailyProfileDetail( profileDetail.DailyProfileId, profileDetail.DateProfile,
				profileDetail.PeakValue, profileDetail.OffPeakValue, profileDetail.DailyValue, profileDetail.PeakRatio );
		}






		/// <summary>
		/// Select daily profiles for specified date range
		/// </summary>
		/// <param name="utilityCode">Identifier for utility</param>
		/// <param name="loadShapeId">Load Shape ID</param>
		/// <param name="zone">Zone for utility</param>
		/// <param name="range">Begin and end dates</param>
		/// <returns>PeakProfileDictionary</returns>
		public static PeakProfileDictionary SelectDailyProfiles( string utilityCode, string loadShapeId, string zone,
			DateRange range )
		{
			PeakProfileDictionary dict = new PeakProfileDictionary();

			DataSet ds = new DataSet();

			ds = ProfileSql.SelectDailyProfile( utilityCode, loadShapeId, zone, range.StartDate, range.EndDate );

			foreach( DataRow dr in ds.Tables[0].Rows )
			{
				PeakProfile peakP = new PeakProfile( Convert.ToDecimal( dr["DailyValue"] ),
					Convert.ToDateTime( dr["DateProfile"] ), Convert.ToDecimal( dr["PeakRatio"] ),
					Convert.ToDecimal( dr["PeakValue"] ), Convert.ToDecimal( dr["OffPeakValue"] ) );
				peakP.DailyProfileId = Convert.ToInt32( dr["DailyProfileId"] );

				dict.Add( Convert.ToDateTime( dr["DateProfile"] ), peakP );
			}

			return dict;
		}

		/// <summary>
		/// Returns a peak profile dictionary for specified utility and load shape id
		/// </summary>
		/// <param name="utilityCode">Unique identifier for utility</param>
		/// <param name="loadShapeId">Load shape ID</param>
		/// <param name="usages">Usage dictionary</param>
		/// <returns>PeakProfileDictionary</returns>
		public static PeakProfileDictionary GetPeakProfiles( string utilityCode, string loadShapeId, string zone, UsageDictionary usages )
		{
			DateTime beginDate;
			DateTime endDate;

			beginDate = DateTime.MaxValue;
			endDate = DateTime.MinValue;

			// Finds the minimum and maximum dates of usage
			SetDate( usages, DateReturn.Minimum, ref beginDate );
			SetDate( usages, DateReturn.Maximum, ref endDate );

			DateRange range = new DateRange( beginDate, endDate );

			// get peak profile dictionary
			return ProfileFactory.SelectDailyProfiles( utilityCode, loadShapeId, zone, range );
		}

		/// <summary>
		/// Returns a peak profile dictionary for specified utility and load shape id
		/// </summary>
		/// <param name="utilityCode">Unique identifier for utility</param>
		/// <param name="loadShapeId">Load shape ID</param>
		/// <param name="usage">Usage object</param>
		/// <returns>PeakProfileDictionary</returns>
		public static PeakProfileDictionary GetPeakProfiles( string utilityCode, string loadShapeId, string zone, Usage usage )
		{
			DateRange range = new DateRange( usage.BeginDate, usage.EndDate );

			// get peak profile dictionary
			return ProfileFactory.SelectDailyProfiles( utilityCode, loadShapeId, zone, range );
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="peakProfiles"></param>
		/// <returns></returns>
		public static NormalizedProfileDictionary GetNormalizedProfiles( PeakProfileDictionary peakProfiles )
		{
			return NormalizedProfileFactory.GetNormalizedProfileDictionary( peakProfiles );
		}

		/// <summary>
		/// Returns a normalized profile dictionary for specified utility and load shape id
		/// </summary>
		/// <param name="utilityCode">Unique identifier for utility</param>
		/// <param name="loadShapeId">Load shape ID</param>
		/// <param name="zone">Zone for utility</param>
		/// <param name="usages">Usage dictionary</param>
		/// <returns>NormalizedProfileDictionary</returns>
		public static NormalizedProfileDictionary GetNormalizedProfiles( string utilityCode, string loadShapeId, string zone, UsageDictionary usages )
		{
			return NormalizedProfileFactory.GetNormalizedProfileDictionary( GetPeakProfiles( utilityCode, loadShapeId, zone, usages ) );
		}

		/// <summary>
		/// Finds the minimum or maximum date for usage dictionary
		/// </summary>
		/// <param name="usages">Usage dictionary</param>
		/// <param name="dateReturn">Enum to direct for minimum or maximum date</param>
		/// <param name="dateToCompare">Date to set</param>
		private static void SetDate( UsageDictionary usages, DateReturn dateReturn, ref DateTime dateToCompare )
		{
			foreach( Usage usage in usages.Values )
			{
				if( dateReturn == DateReturn.Minimum )
				{
					if( usage.BeginDate < dateToCompare )
					{
						dateToCompare = usage.BeginDate;
					}
				}
				else
				{
					if( usage.EndDate > dateToCompare )
					{
						dateToCompare = usage.EndDate;
					}
				}
			}
		}
	}
}
