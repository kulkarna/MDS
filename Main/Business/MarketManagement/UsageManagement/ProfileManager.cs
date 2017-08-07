using System;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Text;
using LibertyPower.DataAccess.CsvAccess.GenericCsv;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Controller for processing profile files
	/// </summary>
	public static class ProfileManager
	{
		/// <summary>
		/// Processes a profile file
		/// </summary>
		/// <param name="retailMarketCode">Identifier for market</param>
		/// <param name="path">File path</param>
		/// <returns>Returns any warning message</returns>
		public static string ProcessProfileFile( string retailMarketCode, string path )
		{
			string warning = "";
			string utilityCode = "";
			string loadShapeId = "";
			string zone = "";
			DateTime dateProfile;
			decimal dailyValue;
			decimal peakRatio;
			string fileName = "";
			string createdBy = "";
			Int64 dailyProfileId = 0;
			bool hasHeaderRowData = false;
			bool hasSameKey = false;
			ArrayList dates = new ArrayList();

			DataSet ds = new DataSet();
			ds = GenericCsv.GetData( path );

			// if not a valid file, exception will be thrown
			ValidateFileFormat( ds.Tables[0] );

			fileName = path.Substring( path.LastIndexOf( @"\" ) + 1 );

			foreach( DataRow dr in ds.Tables[0].Rows )
			{
				if( !hasHeaderRowData )
				{
					createdBy = dr[3].ToString();
					hasHeaderRowData = true;
				}
				else
				{
					hasSameKey = utilityCode == dr[0].ToString() &&
						loadShapeId == dr[1].ToString()
						&& zone == dr[2].ToString();

					utilityCode = dr[0].ToString();
					loadShapeId = dr[1].ToString();
					zone = dr[2].ToString();
					dateProfile = Convert.ToDateTime( dr[3] );
					dailyValue = Convert.ToDecimal( dr[4] );
					peakRatio = Convert.ToDecimal( dr[5] );

					dates.Add( dateProfile );

					// insert one header record for every distinct utility, load shapeid, and zone
					if( !hasSameKey )
						dailyProfileId = ProfileFactory.InsertProfileHeader( CreateProfileHeader( retailMarketCode, utilityCode, loadShapeId,
							zone, fileName, createdBy, dailyProfileId ) );

					ProfileFactory.InsertProfileDetails( CreateProfileDetail( dateProfile, dailyProfileId, dailyValue, peakRatio ) );
				}
			}

			ProfileHas364ConsectiveDaysRule rule = new ProfileHas364ConsectiveDaysRule( fileName, dates );
			if( !rule.Validate() )
				warning = rule.Exception.Message;

			return warning;
		}

		/// <summary>
		/// Validates number of columns and that a header row is present.
		/// </summary>
		/// <param name="dt">DataTable containing the file data</param>
		private static void ValidateFileFormat( DataTable dt )
		{
			// validate number of columns
			if( dt.Columns.Count != 6 )
				throw new InvalidProfileFile( "Invalid file format. Expected number of columns: 6 Actual: " + dt.Columns.Count.ToString() );

			try
			{
				// if this conversion succeeds, then header row is missing
				int testColumn = Convert.ToInt32( dt.Rows[0][6] );
				throw new InvalidProfileFile( "Invalid file format. Missing header row." );
			}
			catch
			{
				// this should occur, verifies that first row has header data
			}
		}

		/// <summary>
		/// Creates ProfileHeader object
		/// </summary>
		/// <param name="iso">Identifier for ISO or market</param>
		/// <param name="utilityCode">Identifier for utility</param>
		/// <param name="loadShapeId">LOad Shape ID</param>
		/// <param name="zone">Zone for utility</param>
		/// <param name="fileName">Profile file name</param>
		/// <param name="createdBy">User who created file</param>
		/// <param name="dailyProfileId">ID used for relationship in DailyProfileDetail</param>
		/// <returns>ProfileHeader object</returns>
		private static ProfileHeader CreateProfileHeader( string iso, string utilityCode,
			string loadShapeId, string zone, string fileName, string createdBy, Int64 dailyProfileId )
		{
			return new ProfileHeader( iso, utilityCode, loadShapeId, zone, fileName, createdBy, dailyProfileId );
		}

		/// <summary>
		/// Creates ProfileDetail object
		/// </summary>
		/// <param name="dateProfile">Profile date</param>
		/// <param name="dailyProfileId">ID used for relationship in DailyProfileHeader</param>
		/// <param name="dailyValue">Daily profile value</param>
		/// <param name="peakRatio">Peak ratio</param>
		/// <returns></returns>
		private static ProfileDetail CreateProfileDetail( DateTime dateProfile,
			Int64 dailyProfileId, decimal dailyValue, decimal peakRatio )
		{
			ProfileDetail pd = new ProfileDetail();

			pd.DailyProfileId = dailyProfileId;
			pd.DateProfile = dateProfile;
			pd.PeakValue = dailyValue * peakRatio;
			pd.OffPeakValue = dailyValue - pd.PeakValue;
			pd.DailyValue = dailyValue;
			pd.PeakRatio = peakRatio;

			return pd;
		}
	}
}
