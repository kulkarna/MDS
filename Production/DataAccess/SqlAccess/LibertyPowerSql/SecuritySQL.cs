using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	[Serializable]
	public static class SecuritySql
	{
		/// <summary>
		/// Get User fields from the User table in the LibertyPower database. 
		/// </summary>
		/// <param name="userName">This is the domain name/username value</param>
		/// <returns></returns>
		public static DataSet GetUserByLogin( string userName )
		{
			string SQL = "usp_UserGetByLogin";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@Username", userName );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		public static DataSet GetUserByLegacyID( int legacyId )
		{
			string SQL = "usp_UserGetByLegacyID";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@LegacyID", legacyId );

				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		public static DataSet UserSetActive( int userId, bool isActive )
		{
			string SQL = "usp_UserSetActive";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@UserID", userId );
				SqlParameter p2 = new SqlParameter( "@IsActive", isActive );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.Fill( ds );
			}

			return ds;
		}


		public static DataSet GetUserByUserID( int userId )
		{
			string SQL = "usp_UserGetByUserID";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@UserID", userId );

				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Gets all the users that have a determined role assigned
		/// </summary>
		/// <param name="roleId">the id of the role</param>
		/// <returns>A dataset containing all the records of users assigned to that role</returns>
		public static DataSet GetUsersAssignedToRole( int roleId )
		{
			string SQL = "usp_UserGetAssignedToRole";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@RoleID", roleId );

				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Removes a determined role from all users assigned to it
		/// </summary>
		/// <param name="roleId">The id of the role</param>
		public static void RemoveRoleFromAllUsers( int roleId )
		{
			string SQL = "usp_RemoveRoleFromAllUsers";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@RoleID", roleId );

				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}
		}


		#region  User Methods


		#region AppName Methods
		/// <summary>
		/// Retrieve a dataset of all application names in the AppNames table.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetAppNamesForUsers()
		{
			string SQL = "usp_AppNameGetALL";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString );
			DataSet ds = new DataSet();
			da.SelectCommand.CommandType = CommandType.StoredProcedure;
			da.Fill( ds );
			return ds;
		}


		/// <summary>
		/// /// Update the appName for a single entry, then 
		/// Retrieve a dataset for the updated entry in the AppNames table.
		/// </summary>
		/// <param name="appName">the description of the application name.</param>
		/// <param name="appKey">the unique key for the application. </param>
		/// <param name="modifiedBy">last user id to modify the record.</param>
		/// <returns></returns>
		public static DataSet UpdateAppNameForUser( string appName, string appKey, int modifiedBy )
		{
			string SQL = "usp_AppNameUpdate";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString );
			DataSet ds = new DataSet();
			da.SelectCommand.CommandType = CommandType.StoredProcedure;
			SqlParameter p0 = new SqlParameter( "@appKey", appKey );
			SqlParameter p1 = new SqlParameter( "@AppDescription", appName );
			SqlParameter p2 = new SqlParameter( "@ModifiedBy", modifiedBy );

			da.SelectCommand.Parameters.Add( p0 );
			da.SelectCommand.Parameters.Add( p1 );
			da.SelectCommand.Parameters.Add( p2 );

			da.Fill( ds );
			return ds;
		}


		/// <summary>
		///  /// /// Create a new entry Retrieve a dataset for the new entry in the AppNames table.
		/// </summary>
		/// <param name="appName">the description of the application name.</param>
		/// <param name="appKey">the unique key for the application. </param>
		/// <param name="createdBy">user id of the person who created the entry</param>
		/// <returns></returns>
		public static DataSet CreateAppNameForUser( string appName, string appKey, int createdBy )
		{
			string SQL = "usp_AppNameInsert";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString );
			DataSet ds = new DataSet();
			da.SelectCommand.CommandType = CommandType.StoredProcedure;
			SqlParameter p0 = new SqlParameter( "@appKey", appKey );
			SqlParameter p1 = new SqlParameter( "@AppDescription", appName );
			SqlParameter p2 = new SqlParameter( "@CreatedBy", createdBy );

			da.SelectCommand.Parameters.Add( p0 );
			da.SelectCommand.Parameters.Add( p1 );
			da.SelectCommand.Parameters.Add( p2 );

			da.Fill( ds );
			return ds;
		}

		#endregion


		#region Role Methods
		/// <summary>
		/// Create an entry that maps a single user to a role in the UserRole table.
		/// </summary>
		/// <param name="userId">integer value in the user table.</param>
		/// <param name="roleId">integer value in the role table.</param>
		/// <param name="createdBy">user id of the person who created the entry</param>
		/// <returns></returns>
		public static DataSet AssignUserRoleForUser( int userId, int roleId, int createdBy )
		{
			string SQL = "usp_UserRoleInsert";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@roleID", roleId );
				SqlParameter p1 = new SqlParameter( "@userID", userId );
				SqlParameter p2 = new SqlParameter( "@createdBy", createdBy );

				da.SelectCommand.Parameters.Add( p0 );
				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.Fill( ds );
			}
			return ds;
		}


		/// <summary>
		/// Remove an entry that maps a single user to a role in the UserRole table.
		/// </summary>
		/// <param name="userId">integer value in the user table.</param>
		/// <param name="roleId">integer value in the role table.</param>
		/// <returns></returns>
		public static DataSet RemoveUserRoleForUser( int userId, int roleId )
		{
			string SQL = "usp_UserRoleRemoveFromRole";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@roleID", roleId );
				SqlParameter p1 = new SqlParameter( "@userID", userId );
				da.SelectCommand.Parameters.Add( p0 );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Create a new role in the Role table.
		/// </summary>
		/// <param name="roleName">Text field </param>
		/// <param name="createdBy">ID of user creating the role</param>
		/// <returns></returns>
		public static DataSet CreateRoleForUser( string roleName, string description, int createdBy )
		{
			string SQL = "usp_RoleInsert";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;

			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@RoleName", roleName );
				SqlParameter p1 = new SqlParameter( "@Description", description );
				SqlParameter p2 = new SqlParameter( "@createdBy", createdBy );


				da.SelectCommand.Parameters.Add( p0 );
				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Updates the role.
		/// </summary>
		/// <param name="roleId">The role id.</param>
		/// <param name="roleName">Name of the role.</param>
		/// <param name="description">The description.</param>
		/// <param name="modifiedBy">The id of the user making update.</param>
		/// <returns></returns>
		public static DataSet UpdateRole( int roleId, string roleName, string description, int modifiedBy )
		{
			string SQL = "usp_RoleUpdate";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;

			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@RoleID", roleId );
				SqlParameter p1 = new SqlParameter( "@RoleName", roleName );
				SqlParameter p2 = new SqlParameter( "@Description", description );
				SqlParameter p3 = new SqlParameter( "@modifiedBy", modifiedBy );

				da.SelectCommand.Parameters.Add( p0 );
				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.Fill( ds );
			}
			return ds;
		}


		/// <summary>
		/// Add a new mapping for a role to an activity. A role typically has several activities.
		/// </summary>
		/// <param name="activityId">Unique integer value in the activity table.</param>
		/// <param name="roleId">Unique integer value in the Role table.</param>
		/// <param name="createdBy">id of the user creating the entry</param>
		/// <returns></returns>
		public static DataSet AssignActivityRoleForUser( int activityId, int roleId, int createdBy )
		{
			string SQL = "usp_ActivityRoleInsert";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@roleID", roleId );
				SqlParameter p1 = new SqlParameter( "@activityID", activityId );
				SqlParameter p2 = new SqlParameter( "@createdBy", createdBy );

				da.SelectCommand.Parameters.Add( p0 );
				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Deletes all activities from role.
		/// </summary>
		/// <param name="roleId">The role ID.</param>
		public static void DeleteActivitiesFromRole( int roleId )
		{
			string SQL = "usp_ActivityRoleRemoveAllFromRole";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@roleID", roleId );

				da.SelectCommand.Parameters.Add( p0 );
				da.Fill( ds );
			}
		}


		/// <summary>
		/// Retrieve a dataset containing the role data for a single role.
		/// </summary>
		/// <param name="roleId">The role id.</param>
		/// <returns></returns>
		public static DataSet GetRoleByRoleId( int roleId )
		{
			string SQL = "usp_RoleGetByRoleId";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@roleId", roleId );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// retrieve a dataset containing the role data for a single role.
		/// </summary>
		/// <param name="roleName">name of the role</param>
		/// <returns></returns>
		public static DataSet GetRoleByRoleName( string roleName )
		{
			string SQL = "usp_RoleGetByRoleName";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@roleName", roleName );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Gets the roles assigned to an activity key.
		/// </summary>
		/// <param name="activityKey">The activity key.</param>
		/// <returns></returns>
		public static DataSet GetRoleByActivityKey( int activityKey )
		{
			string SQL = "usp_RoleGetByActivityKey";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ActivityKey", activityKey );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Get all of the available roles as a dataset from the role table.
		/// </summary>
		/// <returns></returns>
		public static DataSet RoleGetAllForUser()
		{
			string SQL = "usp_RoleGetAll";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill( ds );
			}

			return ds;
		}


		public static DataSet RemoveALLUserRoleForUser( int userID )
		{
			string SQL = "usp_UserRoleRemoveAllRoles";

			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@userID", userID );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Clones the user roles.
		/// </summary>
		/// <param name="copyFromUserId">The copy from user id.</param>
		/// <param name="copyToUserId">The copy to user id.</param>
		/// <param name="isExactClone">if set to <c>true</c> then the copyToUser's current roles are deleted so that that it will have only the roles that the copyFromUser currently has.</param>
		/// <param name="modifiedBy">The modified by.</param>
		/// <returns></returns>
		public static DataSet CloneUserRoles( int copyFromUserId, int copyToUserId, bool isExactClone, int modifiedBy )
		{
			string SQL = "usp_UserRoleCloneUser";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;

				SqlParameter p1 = new SqlParameter( "@CopyFromUser_id", copyFromUserId );
				SqlParameter p2 = new SqlParameter( "@CopyToUser_id", copyToUserId );
				SqlParameter p3 = new SqlParameter( "@Clone", isExactClone );
				SqlParameter p4 = new SqlParameter( "@CurrentUser_id", modifiedBy );

				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.Fill( ds );
			}

			return ds;
		}


		public static DataSet GetRolesContain( string partialRoleName )
		{
			string SQL = "usp_RoleGetByRoleNameLike";

			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@p_partialRoleName", partialRoleName );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}

		#endregion


		#region Activity Methods
		/// <summary>
		/// Create a new activity in the activity Role table.
		/// </summary>
		/// <param name="appKey">Unique name for an application in the appName table.</param>
		/// <param name="activityDesc">Description for an activity</param>
		/// <param name="createdBy">integer id of the user creating the activity</param>
		/// <returns></returns>
		public static DataSet CreateActivityForUser( string appKey, string activityDesc, int createdBy )
		{
			string SQL = "usp_ActivityInsert";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;

			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@ActivityDesc", activityDesc );
				SqlParameter p1 = new SqlParameter( "@appKey", appKey );
				SqlParameter p2 = new SqlParameter( "@createdBy", createdBy );

				da.SelectCommand.Parameters.Add( p0 );
				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.Fill( ds );
			}
			return ds;
		}


		/// <summary>
		/// Gets all activities.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetActivities()
		{
			string SQL = "usp_ActivityGetAll";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;

			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill( ds );
			}
			return ds;
		}


		/// <summary>
		/// Gets the activity by activity key.
		/// </summary>
		/// <param name="activityKey">The activity key.</param>
		/// <returns></returns>
		public static DataSet GetActivityByActivityKey( int activityKey )
		{
			string SQL = "usp_ActivityGetByActivityKey";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;

			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ActivityKey", activityKey );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Gets the activity by activity desc.
		/// </summary>
		/// <param name="activityDesc">The activity desc.</param>
		/// <returns></returns>
		public static DataSet GetActivityByActivityDesc( string activityDesc )
		{
			string SQL = "usp_ActivityGetByActivityDesc";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;

			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@ActivityDesc", activityDesc );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Get a dataset of Activities for a specific application.
		/// </summary>
		/// <param name="appKey">Unique name of an application in the appKey table.</param>
		/// <returns></returns>
		public static DataSet GetActivityByAppKeyForUser( string appKey )
		{
			string SQL = "usp_ActivityGetByAppKey";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;

			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p1 = new SqlParameter( "@AppKey", appKey );
				da.SelectCommand.Parameters.Add( p1 );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Get a dataset of Activities for a specific Role.
		/// </summary>
		/// <param name="roleId">Role id in the Role and ActivityRole table </param>
		/// <returns></returns>
		public static DataSet GetActivityByRoleForUser( int roleId )
		{
			string SQL = "usp_ActivityGetByRoleID";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;

			DataSet ds = new DataSet();
			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;

				SqlParameter p1 = new SqlParameter( "@RoleID", roleId );
				da.SelectCommand.Parameters.Add( p1 );

				da.Fill( ds );
			}

			return ds;
		}
		#endregion


		#region User Methods
		/// <summary>
		/// Get a dataset of Users by role.
		/// </summary>
		/// <returns></returns> 
		public static DataSet GetUsers( string roleList, bool mustHaveAllRoles )
		{
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			var ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( "usp_GetUsersWithRoles", cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.SelectCommand.Parameters.Add( new SqlParameter( "@RoleList", roleList ) );
				da.SelectCommand.Parameters.Add( new SqlParameter( "@MustHaveAllRoles", mustHaveAllRoles ) );
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Get a dataset of All  Users.
		/// </summary>
		/// <returns></returns>
		public static DataSet GetUsers()
		{
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			var ds = new DataSet();

			using( var da = new SqlDataAdapter( "usp_UserGetALL", cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Get a  dataset of roles of a single user by his userid.
		/// </summary>
		/// <param name="userId">unique integer value in the user table</param>
		/// <returns></returns>
		public static DataSet GetUserRoleByUserIDForUser( int userId )
		{
			string SQL = "usp_UserRoleGetByuserID";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString );
			DataSet ds = new DataSet();
			da.SelectCommand.CommandType = CommandType.StoredProcedure;
			SqlParameter p1 = new SqlParameter( "@userID", userId );
			da.SelectCommand.Parameters.Add( p1 );
			da.Fill( ds );
			return ds;
		}


		/// <summary>
		/// Update a user in the user table.
		/// </summary>
		/// <param name="userId">user id in the user table.</param>
		/// <param name="userName">user Name in the user table.</param>
		/// <param name="password">password of the user in the user table.</param>
		/// <param name="firstname">firstname of the user in the user table</param>
		/// <param name="lastname">lastname of the user in the user table</param>
		/// <param name="email">email of the user in the user table</param>
		/// <param name="modifiedBy">last user id to modify the entry</param>
		/// <returns>A dataset of the updated values</returns>
		public static DataSet UpdateUserForUser( int userId, string userName, string password, string firstname, string lastname,
												string email, char isActive, string stTypeOfUser, int modifiedBy )
		{
			string SQL = "usp_UserUpdate";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@UserName", userName );
				SqlParameter p1 = new SqlParameter( "@Password", (string.IsNullOrEmpty( password ) ? DBNull.Value : (object) password) );
				SqlParameter p2 = new SqlParameter( "@Firstname", firstname );
				SqlParameter p3 = new SqlParameter( "@Lastname", (string.IsNullOrEmpty( lastname ) ? DBNull.Value : (object) lastname) );
				SqlParameter p4 = new SqlParameter( "@Email", email );
				SqlParameter p5 = new SqlParameter( "@UserID", userId );
				SqlParameter p6 = new SqlParameter( "@modifiedBy", modifiedBy );
				SqlParameter p7 = new SqlParameter( "@IsActive", isActive );
				SqlParameter p8 = new SqlParameter( "@UserType", (string.IsNullOrEmpty( stTypeOfUser ) ? DBNull.Value : (object) stTypeOfUser) );

				da.SelectCommand.Parameters.Add( p0 );
				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.SelectCommand.Parameters.Add( p6 );
				da.SelectCommand.Parameters.Add( p7 );
				da.SelectCommand.Parameters.Add( p8 );

				da.Fill( ds );
			}

			return ds;
		}


		/// <summary>
		/// Create a new user with a unique username in the user table.
		/// </summary>
		/// <param name="userName">userName of the user in the user table</param>
		/// <param name="password">password of the user in the user table</param>
		/// <param name="firstname">firstname of the user in the user table</param>
		/// <param name="lastname">lastname of the user in the user table</param>
		/// <param name="email">email of the user in the user table</param>
		/// <param name="createdBy">id of the user that created this entry</param>
		/// <param name="legacyId">id of user in the lp_Portal database</param>
		/// <param name="userType">Internal (Active directory account) or External(non-employee)</param>
		/// <returns>A dataset of the newly inserted values</returns>
		public static DataSet CreateUserForUser( string userName, string password, string firstname, string lastname,
									   string email, int createdBy, int legacyId, string userType, char isActive )
		{
			string SQL = "usp_UserInsert";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			DataSet ds = new DataSet();

			using( SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString ) )
			{
				da.SelectCommand.CommandType = CommandType.StoredProcedure;
				SqlParameter p0 = new SqlParameter( "@UserName", userName );
				SqlParameter p1 = new SqlParameter( "@Password", password != null ? (object) password : DBNull.Value );
				SqlParameter p2 = new SqlParameter( "@Firstname", firstname != null ? (object) firstname : DBNull.Value );
				SqlParameter p3 = new SqlParameter( "@Lastname", lastname != null ? (object) lastname : DBNull.Value );
				SqlParameter p4 = new SqlParameter( "@Email", email != null ? (object) email : DBNull.Value );
				SqlParameter p5 = new SqlParameter( "@createdBy", createdBy );
				SqlParameter p6 = new SqlParameter( "@legacyID", legacyId );
				SqlParameter p7 = new SqlParameter( "@userType", userType );
				SqlParameter p8 = new SqlParameter( "@IsActive", isActive );

				da.SelectCommand.Parameters.Add( p0 );
				da.SelectCommand.Parameters.Add( p1 );
				da.SelectCommand.Parameters.Add( p2 );
				da.SelectCommand.Parameters.Add( p3 );
				da.SelectCommand.Parameters.Add( p4 );
				da.SelectCommand.Parameters.Add( p5 );
				da.SelectCommand.Parameters.Add( p6 );
				da.SelectCommand.Parameters.Add( p7 );
				da.SelectCommand.Parameters.Add( p8 );
				da.Fill( ds );
			}
			return ds;
		}


		/// <summary>
		/// Get a dataset of activities for a given userid. Each activity is mapped to an activity for an application.
		/// </summary>
		/// <param name="userId">user id in the user table.</param>
		/// <returns></returns>
		public static DataSet GetActivitiesForUser( int userId, string appKey )
		{
			string SQL = "usp_ActivityGetByUserID";
			string cnnString = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
			SqlDataAdapter da = new SqlDataAdapter( SQL, cnnString );
			DataSet ds = new DataSet();
			da.SelectCommand.CommandType = CommandType.StoredProcedure;
			SqlParameter p1 = new SqlParameter( "@userID", userId );
			SqlParameter p2 = new SqlParameter( "@AppKey", appKey );

			da.SelectCommand.Parameters.Add( p1 );
			da.SelectCommand.Parameters.Add( p2 );
			da.Fill( ds );
			return ds;
		}

        /// <summary>
        /// Get a dataset of activities for a given userid. Each activity is mapped to an activity for an application.
        /// </summary>
        /// <param name="userID">user id in the user table.</param>
        /// <returns></returns>
        public static DataSet GetAllActivitiesForUser(int userID)
        {
            string SQL = "usp_ActivityGetAllByUserID";
            string cnnString = ConfigurationManager.ConnectionStrings["LPConnectionString"].ConnectionString;
            SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString);
            DataSet ds = new DataSet();
            da.SelectCommand.CommandType = CommandType.StoredProcedure;
            SqlParameter p1 = new SqlParameter("@userID", userID);

            da.SelectCommand.Parameters.Add(p1);

            da.Fill(ds);
            return ds;
        }
		#endregion


		#endregion
	}

}

