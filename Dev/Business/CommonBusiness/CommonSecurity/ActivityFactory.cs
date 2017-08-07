using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.DataAccess.SqlAccess.SecuritySql;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    public static class ActivityFactory
    {
		/// <summary>
		/// create a new activity in the liberty power databse
		/// </summary>
		/// <param name="appKey">unique application keyname in the appName table.</param>
		/// <param name="activityDesc">description of the activity</param>
		/// <param name="createdBy"></param>
		/// <returns>a dataset with a single for the newly created activity</returns>
        public static Activity CreateActivityForUser(string appKey, string activityDesc, int createdBy)
        {
			// Check to see if the an Activity with the same name exists.
			DataSet dsExisting = SecuritySql.GetActivityByActivityDesc(activityDesc);
			if (CommonHelper.DataSetHelper.HasRow(dsExisting))
			{
				throw new Exception(string.Format("An activity with the name\"{0}\" already exists.", activityDesc));
			}

            DataSet ds = SecuritySql.CreateActivityForUser(appKey, activityDesc, createdBy);
			
            return GetActivityForUser(ds.Tables[0].Rows[0]);
        }

        
        /// <summary>
        /// Retrieve a loaded activity object for a single datarow
        /// </summary>
        /// <param name="dr">the row must contain the following:
        /// ActivityDesc
        /// ActivityKey
        /// AppKey
        /// DateCreated
        /// DateModified
        /// createdBy
        /// ModifiedBy
        /// 
        /// </param>
        /// <returns></returns>
        public static Activity GetActivityForUser(DataRow dr)
        {

            string desc = Convert.ToString(dr["ActivityDesc"]);
            int activityKey;
            bool result = int.TryParse(Convert.ToString(dr["ActivityKey"]), out activityKey);
            string appKey = Convert.ToString(dr["AppKey"]);
            DateTime dtCreated = (DateTime)dr["DateCreated"];
            DateTime dtModified = (DateTime)dr["DateModified"];
            int createdBy;
            bool result2 = int.TryParse(Convert.ToString(dr["createdBy"]), out createdBy);

            int ModifiedBy;
            bool result3 = int.TryParse(Convert.ToString(dr["ModifiedBy"]), out ModifiedBy);

            Activity ac = new Activity(activityKey, desc, appKey, dtCreated, dtModified, createdBy, ModifiedBy);
            return ac;
        }

		/// <summary>
		/// Gets all activities.
		/// </summary>
		/// <returns></returns>
		public static ActivityList GetActivities()
		{
			DataSet ds = SecuritySql.GetActivities();
			ActivityList actList = new ActivityList();
			foreach( DataRow dr in ds.Tables[0].Rows )
			{
				actList.Add( GetActivityForUser( dr ) );
			}
			return actList;
		}

		/// <summary>
		/// Gets the activity by activity key.
		/// </summary>
		/// <param name="activityKey">The activity key.</param>
		/// <returns></returns>
		public static Activity GetActivityByActivityKey(int activityKey)
		{
			Activity a = null;
			DataSet ds = SecuritySql.GetActivityByActivityKey(activityKey);
			if (CommonHelper.DataSetHelper.HasRow(ds))
			{
				a = GetActivityForUser(ds.Tables[0].Rows[0]);
			}
			return a;
		}

        /// <summary>
        /// Retrieve a dataset and then load a list of activities(activityList) for a single appKey (application name).
        /// </summary>
        /// <param name="appKey">unique application name in the appName table in liberty power.</param>
        /// <returns></returns>
        public static ActivityList GetActivityByAppKeyForUser(string appKey)
        {
            DataSet ds = SecuritySql.GetActivityByAppKeyForUser(appKey);
            ActivityList actList = new ActivityList();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
				actList.Add(GetActivityForUser(dr));
            }
            return actList;
        }

        /// <summary>
        /// Get a loaded activity list of activities for all user that have an active directory account (internal users).
        /// </summary>
        /// <param name="appKey">unique application name in the appName table in liberty power.</param>
        /// <returns></returns>
        public static ActivityList GetActivitiesOfRole(int RoleID)
        {
            DataSet ds = SecuritySql.GetActivityByRoleForUser(RoleID);
            ActivityList actList = new ActivityList();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
				actList.Add(GetActivityForUser(dr));
            }
            return actList;

        }

		#region Legacy related methods that will be obsolete
		/// <summary>
		/// Retrieve a loaded activity object for a single datarow
		/// </summary>
		/// <param name="dr">the row must contain the following:
		/// Activity_Descp
		/// Activity_ID
		/// system_code
		/// 
		/// </param>
		/// <returns></returns>
		[Obsolete("Legacy")]
		public static Activity GetSingleActivityForInternalUser(DataRow dr)
		{
			string desc = Convert.ToString(dr["Activity_Descp"]);
			int activity_ID;
			bool result = int.TryParse(Convert.ToString(dr["Activity_ID"]), out activity_ID);

			string roleName = Convert.ToString(dr["Role_name"]);
			string appKey = Convert.ToString(dr["system_code"]);
			Activity ac = new Activity(roleName, activity_ID, desc, appKey);
			return ac;
		}

		/// <summary>
		/// Get a loaded activity list of activities for all user that have an active directory account (internal users).
		/// </summary>
		/// <param name="appKey">unique application name in the appName table in liberty power.</param>
		/// <returns></returns>
		[Obsolete("Legacy")]
		public static ActivityList GetActivitiesForInternalUsers(string appKey)
		{
			DataSet ds = ActivitySql.GetActivityByAppKeyForInternalUser(appKey);

			ActivityList actList = new ActivityList();
			foreach (DataRow dr in ds.Tables[0].Rows)
			{
				actList.Add(GetSingleActivityForInternalUser(dr));
			}
			return actList;
		}
		#endregion

		#region Deprecated methods
		/// <summary>
		/// create a new activity in the liberty portal databse
		/// </summary>
		/// <param name="appKey">unique application keyname in the appName table.</param>
		/// <param name="activityDesc">description of the activity</param>
		/// <param name="createdBy"></param>
		/// <returns>a dataset with a single for the newly created activity</returns>
		[Obsolete("CreateActivityForExternalUser has been deprecated. Use AssignActivityToRoleForUser")]
		public static Activity CreateActivityForExternalUser(string appKey, string activityDesc, int createdBy)
		{
			return CreateActivityForUser(appKey, activityDesc, createdBy);
		}

		[Obsolete("GetActivityForExternalUser has been deprecated. Use GetActivityForUser")]
		public static Activity GetActivityForExternalUser(DataRow dr)
		{
			return GetActivityForUser(dr);
		}

		/// <summary>
		/// Retrieve a dataset and then load a list of activities(activityList) for a single appKey (application name).
		/// 
		/// </summary>
		/// <param name="appKey">unique application name in the appName table in liberty power.</param>
		/// <returns></returns>
		[Obsolete("GetActivityByAppKeyForExternalUser has been deprecated. Use GetActivityForUser")]
		public static ActivityList GetActivityByAppKeyForExternalUser(string appKey)
		{
			return GetActivityByAppKeyForUser(appKey);
		}

		/// <summary>
        /// Get a loaded activity list of activities for all user that have an active directory account (internal users).
        /// </summary>
        /// <param name="appKey">unique application name in the appName table in liberty power.</param>
		/// <returns></returns>
		[Obsolete("GetActivitiesOfExternalRole has been deprecated. Use GetActivitiesOfRole")]
		public static ActivityList GetActivitiesOfExternalRole(int RoleID)
		{
			return GetActivitiesOfRole(RoleID);
		}

		#endregion Deprecated methods
	}
}
