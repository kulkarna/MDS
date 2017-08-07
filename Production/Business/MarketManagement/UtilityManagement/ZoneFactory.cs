using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using lp = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Factory class for the Zone class
	/// </summary>
	[Serializable]
	public static class ZoneFactory
	{
		/// <summary>
		/// Gets all zones for specified utility
		/// </summary>
		/// <param name="utilityCode">Utility identifier</param>
		/// <returns>Returns a dictionary containing all zones for specified utility.</returns>
		public static ZoneList GetZonesByUtility( string utilityCode )
		{
			return GetZonesByUtility( utilityCode, true );
		}

		/// <summary>
		/// Gets all zones for specified utility
		/// </summary>
		/// <param name="utilityCode">utility code</param>
		/// <param name="includeOthers">if true, add the entry (All others with code -1) to the returned list</param>
		/// <returns>list of zones</returns>
		public static ZoneList GetZonesByUtility( string utilityCode, bool includeOthers )
		{
			ZoneList zones = new ZoneList();

			if( includeOthers )
				zones.Add( GetZoneAllOthers() );

			DataSet ds = ZoneSql.GetZonesByUtility( utilityCode );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					zones.Add( LoadZone( dr ) );
			}
			return zones;
		}

		/// <summary>
		/// Gets zone object for all others
		/// </summary>
		/// <returns>Returns a zone object for all others.</returns>
		public static Zone GetZoneAllOthers()
		{
			Zone z = new Zone();
			z.Identity = -1;
			z.ZoneCode = "All Others";

			return z;
		}

		/// <summary>
		/// Gets zones for specified utility identity.
		/// </summary>
		/// <param name="utilityIdentity">Utility record identifier</param>
		/// <returns>Returns a zone list for specified utility identity.</returns>
		public static ZoneList GetZonesByUtilityIdentity( int utilityIdentity )
		{
			ZoneList list = new ZoneList();

			Zone zone = new Zone();
			zone.Identity = 0;
			zone.ZoneCode = "All Zones";
			list.Add( zone );

			DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.ZoneSql.GetZonesByUtilityIdentity( utilityIdentity );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( LoadZone( dr ) );
			}
			else if( utilityIdentity > 0 )
				throw new ZoneNotFoundException( "No zone found for utility." );

			return list;
		}

		/// <summary>
		/// Gets the zone.
		/// </summary>
		/// <param name="zoneId">The zone id.</param>
		/// <returns></returns>
		public static Zone GetZone( int zoneId )
		{
			Zone z = null;
			DataSet ds = ZoneSql.ZoneGetByZoneId( zoneId );
			if( DataSetHelper.HasRow( ds ) )
			{
				z = LoadZone( ds.Tables[0].Rows[0] );
			}
			return z;
		}

		/// <summary>
		/// Gets all zones.
		/// </summary>
		/// <returns></returns>
		public static ZoneList GetAllZones()
		{
			ZoneList list = new ZoneList();

			DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.ZoneSql.GetZones();
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( LoadZone( dr ) );
			}

			return list;
		}

		/// <summary>
		/// Gets the zone.
		/// </summary>
		/// <param name="zone">The zone code.</param>
		/// <param name="utility">The utility code.</param>
		/// <returns></returns>
		public static Zone GetZone( string zone, string utility )
		{
			Zone z = null;
			DataSet ds = ZoneSql.ZoneGetByZoneAndUtility( zone, utility );
			if( DataSetHelper.HasRow( ds ) )
			{
				z = LoadZone( ds.Tables[0].Rows[0] );
			}
			return z;
		}

		/// <summary>
		/// Gets zones for specified utility
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <returns>Returns a list of zones for specified utility.</returns>
		public static ZoneList GetZonesForUtility( int utilityID )
		{
			ZoneList list = new ZoneList();
			DataSet ds = lp.UtilitySql.SelectZonesForUtility( utilityID );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					Zone zone = new Zone();
					zone.Identity = Convert.ToInt32( dr["ID"] );
					zone.ZoneCode = dr["ZoneCode"].ToString();
					list.Add( zone );
				}
			}
			return list;
		}

		/// <summary>
		/// Loads the zone object.
		/// </summary>
		/// <param name="dataRow">The data row.</param>
		/// <returns></returns>
		private static Zone LoadZone( DataRow dataRow )
		{
			Zone z = new Zone();

			z.Identity = Convert.ToInt32( dataRow["zone_id"] );
			z.ZoneCode = Convert.ToString( dataRow["zone"] );
			z.RetailMarket = Convert.ToString( dataRow["retail_mkt_id"] );
			z.UtilityCode = Convert.ToString( dataRow["utility_id"] );

			return z;
		}

		/// <summary>
		/// Creates a zone object from data row.
		/// </summary>
		/// <param name="dr">Data row</param>
		/// <returns>Returns a zone object from data row.</returns>
		public static Zone CreateZone( DataRow dr )
		{
			Zone z = new Zone();

			z.Identity = Convert.ToInt32( dr["ZoneID"] );
			z.ZoneCode = dr["zone"].ToString();

			return z;
		}

		/// <summary>
		/// get the list of zones for a specific ISO
		/// </summary>
		/// <param name="ISO">ISO</param>
		/// <param name="addDefaultValue">if = True, Add < None > as a default entry to the top of the list</param>
		/// <returns>dictionary with a list of zones: key= zone, value = zone</returns>
		public static Dictionary<string, string> GetZoneList( string ISO, bool addDefaultValue )
		{
			try
			{
				Dictionary<string, string> zoneList = new Dictionary<string, string>();
				if( addDefaultValue )
					zoneList.Add( "< None >", "< None >" );

				DataSet ds = ZoneSql.GetZonesByISO( ISO );
				if( DataSetHelper.HasRow( ds ) )
					foreach( DataRow dr in ds.Tables[0].Rows )
						zoneList.Add( dr["zone"].ToString(), dr["zone"].ToString() );

				return zoneList;
			}
			catch
			{
				return null;
			}
		}

		/// <summary>
		/// Check if a utility has no zones, meaning there is only one default zone for it.
		/// </summary>
		/// <param name="utilityCode">Utility Code</param>
		/// <param name="zone">the One zone, the utility belongs to</param>
		/// <returns>True if Utility is a one zone utility</returns>
		public static bool OneZoneUtility( string utilityCode, out string zone )
		{
			zone = string.Empty;
			try
			{
				ZoneList zl = GetZonesByUtility( utilityCode,false );
				if (zl != null && zl.Count.Equals(1))
				{
					zone = zl[0].ZoneCode;
					return true;
				}
				return false;
			}
			catch (Exception)
			{
				return false;
			}
			
		}

        public static DataSet GetZonesByDate(string lastModifiedDate)
        {

            DataSet zones = LibertyPower.DataAccess.SqlAccess.CommonSql.ZoneSql.GetZonesByDate(lastModifiedDate);
            return zones;
        }

	}
}
