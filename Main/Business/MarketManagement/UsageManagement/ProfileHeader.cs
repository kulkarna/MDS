using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Container for profile data
	/// </summary>
	public class ProfileHeader
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public ProfileHeader() { }

		/// <summary>
		/// Overloaded constructor which sets property values upon instantiation 
		/// </summary>
		/// <param name="iso">Identifier for ISO or market</param>
		/// <param name="utilityCode">Identifier for utility</param>
		/// <param name="loadShapeId">Load Shape ID</param>
		/// <param name="zone">Zone for utility</param>
		/// <param name="fileName">Filename being processed</param>
		/// <param name="createdBy">User who created file</param>
		/// <param name="dailyProfileId">ID used for relationship in DailyProfileDetail</param>
		public ProfileHeader( string iso, string utilityCode, string loadShapeId, 
			string zone, string fileName, string createdBy, Int64 dailyProfileId )
		{
			this.iso = iso;
			this.utilityCode = utilityCode;
			this.loadShapeId = loadShapeId;
			this.zone = zone;
			this.fileName = fileName;
			this.createdBy = createdBy;
			this.dailyProfileId = dailyProfileId;
		}

		private string iso;
		private string utilityCode;
		private string loadShapeId;
		private string zone;
		private string fileName;
		private string createdBy;
		private Int64 dailyProfileId;

		/// <summary>
		/// Identifier for ISO or market
		/// </summary>
		public string ISO
		{
			get { return iso; }
			set { iso = value; }
		}

		/// <summary>
		/// Identifier for utility
		/// </summary>
		public string UtilityCode
		{
			get { return utilityCode; }
			set { utilityCode = value; }
		}

		/// <summary>
		/// Load Shape ID
		/// </summary>
		public string LoadShapeID
		{
			get { return loadShapeId; }
			set { loadShapeId = value; }
		}

		/// <summary>
		/// Zone for utility
		/// </summary>
		public string Zone
		{
			get { return zone; }
			set { zone = value; }
		}

		/// <summary>
		/// Filename being processed
		/// </summary>
		public string FileName
		{
			get { return fileName; }
			set { fileName = value; }
		}

		/// <summary>
		/// User who created file
		/// </summary>
		public string CreatedBy
		{
			get { return createdBy; }
			set { createdBy = value; }
		}

		/// <summary>
		/// ID used for relationship in DailyProfileDetail
		/// </summary>
		public Int64 DailyProfileId
		{
			get { return dailyProfileId; }
			set { dailyProfileId = value; }
		}
	}
}
