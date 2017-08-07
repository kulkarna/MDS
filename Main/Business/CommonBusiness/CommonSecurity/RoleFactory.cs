using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    public static class RoleFactory
    {
        
        /// <summary>
        /// Create a new role for a non employee (not in active directory) user.
        /// </summary>
        /// <param name="roleName">unique name</param>
        /// <param name="createdBy">user id of the current user</param>
        /// <returns></returns>
        public static Role CreateRoleForUser(string roleName, string description,  int createdBy)
        {
			DataSet ds = SecuritySql.CreateRoleForUser(roleName, description, createdBy);
            return GetRole(ds.Tables[0].Rows[0]);
        }

		/// <summary>
		/// Updates the role.
		/// </summary>
		/// <param name="role">The role.</param>
		/// <param name="modifiedBy">The modified by.</param>
		/// <returns></returns>
		public static Role UpdateRole(Role role,int modifiedBy)
		{
			return UpdateRole(role.RoleID, role.RoleName, role.Description, modifiedBy);
		}

		/// <summary>
		/// Updates the role.
		/// </summary>
		/// <param name="roleId">The role id.</param>
		/// <param name="roleName">Name of the role.</param>
		/// <param name="description">The description.</param>
		/// <param name="modifiedBy">The modified by.</param>
		/// <returns></returns>
		public static Role UpdateRole(int roleId, string roleName, string description, int modifiedBy)
		{
			DataSet ds = SecuritySql.UpdateRole(roleId, roleName, description, modifiedBy);
			return GetRole(ds.Tables[0].Rows[0]);
		}


        /// <summary>
        /// load a role object from a datarow. the row must contain the following:
        /// RoleName
        /// RoleID
        /// </summary>
        /// <param name="dr"></param>
        /// <returns></returns>
        public static Role GetInternalRole(DataRow dr)
        {
            if (dr["RoleName"] is DBNull)
            {
                return null;
            }
            else
            {
                string roleName = (string)dr["RoleName"];
                int roleID;
                bool isGood = int.TryParse(Convert.ToString(dr["RoleID"]), out roleID);

                return new Role(roleID, roleName, DateTime.MinValue, DateTime.MinValue, 0, 0); 
            }
        }
        /// <summary>
        /// load a role object from a datarow. The row must contain the following:
        /// RoleName
        /// RoleID
        /// DateCreated
        /// DateModified
        /// createdBy
        /// ModifiedBy
        /// </summary>
        /// <param name="dr"></param>
        /// <returns></returns>
        public static Role GetRole(DataRow dr)
        {
            if (dr["RoleName"] is DBNull)
            {
                return null;
            }
            else
            {
                string roleName = (string)dr["RoleName"];
                int roleID;
                bool isGood = int.TryParse(Convert.ToString(dr["RoleID"]), out roleID);
               
                DateTime dtCreated;
                bool result = DateTime.TryParse(Convert.ToString(dr["DateCreated"]), out dtCreated);
                DateTime dtModified;
                bool result2 = DateTime.TryParse(Convert.ToString(dr["DateModified"]), out dtModified);
                int createdBy;
                bool isGood2 = int.TryParse(Convert.ToString(dr["createdBy"]), out createdBy);

                int modifiedBy;
                bool isGood3 = int.TryParse(Convert.ToString(dr["ModifiedBy"]), out modifiedBy);

				string description = "";
                if(dr.Table.Columns.Contains("description") == true)
                    description = Convert.ToString(dr["description"]);


				return new Role(roleID, roleName, description, dtCreated, dtModified, createdBy, modifiedBy);
            }
        }
        /// <summary>
        /// assign an activity to a role. A role usually contains several activities.
        /// return a loaded role from a single row of the entry
        /// </summary>
        /// <param name="roleID"></param>
        /// <param name="activityID"></param>
        /// <param name="createdBy"></param>
        /// <returns></returns>
        public static Role AssignActivityToRoleForUser(int roleID, int activityID, int createdBy)
        {
            DataSet ds = SecuritySql.AssignActivityRoleForUser(activityID, roleID, createdBy);
            Activity ac = ActivityFactory.GetActivityForUser(ds.Tables[0].Rows[0]);
            Role r = GetRole(ds.Tables[0].Rows[0]);

            r.ActivitiesOfRole.Add(ac);
            return r;
        }

		/// <summary>
		/// Removes all activities from role.
		/// </summary>
		/// <param name="roleId">The role id.</param>
		public static void RemoveAllActivitiesFromRole(int roleId)
		{
			SecuritySql.DeleteActivitiesFromRole(roleId);
		}

		public static Role GetRoleById(int roleId)
		{
			Role r = null;
			DataSet ds = SecuritySql.GetRoleByRoleId(roleId);
			if (SecurityCommon.IsValidDataset(ds))
			{
				r = RoleFactory.GetRole(ds.Tables[0].Rows[0]);
			}
			return r;
		}

        /// <summary>
        /// return a list of roles from a query by the role name.
        /// </summary>
        /// <param name="roleName"></param>
        /// <returns></returns>
        public static RoleList GetRoleByRolename(string roleName)
        {
            DataSet ds = SecuritySql.GetRoleByRoleName(roleName);
            if (SecurityCommon.IsValidDataset(ds))
            {

                RoleList rList = new RoleList();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Role r = RoleFactory.GetRole(dr);
                    rList.Add(r);
                }
                return rList;
            }
            else
            {
                return null;
            }

        }

		/// <summary>
		/// Return a list of roles from a query by the role name.
		/// </summary>
		/// <param name="roleName">Name of the role.</param>
		/// <param name="allowPartialMatch">if set to <c>true</c> results will include results that contain the role name parameter. if set to <c>false</c> results will include only exact matchers.</param>
		/// <returns></returns>
		public static RoleList GetRoleByRolename(string roleName, bool allowPartialMatch)
		{
			RoleList rList = new RoleList();
			if (allowPartialMatch)
			{
				DataSet ds = SecuritySql.GetRolesContain(roleName);
				if (SecurityCommon.IsValidDataset(ds))
				{
					foreach (DataRow dr in ds.Tables[0].Rows)
					{
						rList.Add(RoleFactory.GetRole(dr));
					}
				}
			}
			else
			{
				rList = GetRoleByRolename(roleName);
			}
			return rList;
		}

		/// <summary>
		/// Gets the role by activity key.
		/// </summary>
		/// <param name="activityKey">The activity key.</param>
		/// <returns></returns>
		public static RoleList GetRoleByActivityKey(int activityKey)
		{
			RoleList rList = new RoleList();
			DataSet ds = SecuritySql.GetRoleByActivityKey(activityKey);
			if (CommonHelper.DataSetHelper.HasRow(ds))
			{
				foreach (DataRow dr in ds.Tables[0].Rows)
				{
					rList.Add(RoleFactory.GetRole(dr));
				}
			}

			return rList;
		}

        /// <summary>
        /// Get the full list of roles as a RoleList from the Liberty Power database.
        /// </summary>
        /// <returns></returns>
		public static RoleList GetUserRoles()
		{
			RoleList rList = new RoleList();
			DataSet ds = SecuritySql.RoleGetAllForUser();
			if (SecurityCommon.IsValidDataset(ds))
			{
				foreach (DataRow dr in ds.Tables[0].Rows)
				{
					Role r = RoleFactory.GetRole(dr);
					rList.Add(r);
				}
			}
			return rList;
		}


		#region Deprecated methods
		/// <summary>
        /// assign an activity to a role. A role usually contains several activities.
        /// return a loaded role from a single row of the entry
        /// </summary>
        /// <param name="roleID"></param>
        /// <param name="activityID"></param>
        /// <param name="createdBy"></param>
        /// <returns></returns>
		[Obsolete("AssignActivityToRoleForExternalUser has been deprecated. Use AssignActivityToRoleForUser")]
		public static Role AssignActivityToRoleForExternalUser(int roleID, int activityID, int createdBy)
        {
			return AssignActivityToRoleForUser(roleID, activityID, createdBy);
		}

		/// <summary>
		/// Create a new role for a non employee (not in active directory) user.
		/// </summary>
		/// <param name="roleName">unique name</param>
		/// <param name="createdBy">user id of the current user</param>
		/// <returns></returns>
		[Obsolete("CreateRoleForExternalUser has been deprecated. Use CreateRoleForUser")]
		public static Role CreateRoleForExternalUser(string roleName, int createdBy)
		{
			return CreateRoleForUser(roleName, null, createdBy);
		}

		/// <summary>
		/// Get the full list of roles as a RoleList from the Liberty Power database.
		/// </summary>
		/// <returns></returns>
		[Obsolete("GetExternalUserRoles has been deprecated. Use GetUserRoles")]
		public static RoleList GetExternalUserRoles()
		{
			return GetUserRoles();
		}

		#endregion Deprecated methods
	}

}
