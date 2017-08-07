namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.DirectoryServices;
    using System.DirectoryServices.AccountManagement;
    using System.Configuration;
    using LibertyPower.DataAccess.SqlAccess.PortalSql;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
    using LibertyPower.Business.CommonBusiness.CommonHelper;
    using System.Net.Mail;
    using System.Web;
    using System.Collections;
    using System.Linq;

    public static class UserFactory
    {
        private const long ACCOUNT_NEVER_EXPIRES = 9223372036854775807;

        /// <summary>
        /// Login method for all users. 
        /// </summary>
        /// <param name="userName">text they have typed for their username</param>
        /// <param name="password">text for their password</param>
        /// <returns>returns a user object loaded with the activities for when he is authorized. 
        /// this method throws an exceptsion when the login fails. </returns>
        /// /// <exception cref="InvalidLoginException" >thrown when userName and/or passowrd is not a valid login</exception>
        public static User LoginUser(string userName, string password, string appKey)
        {
            User u = UserFactory.GetUserByLogin(userName);
            if (u == null || !u.IsActive)
            {
                // User does not exist in the Liberty Power User repository or is listed as inactive.
                throw new InvalidLoginException("INVALID LOGIN");
            }
            if (u.UserType == TypeofUser.EXTERNAL)
            {
                if (!(u.Username.ToLower() == userName.ToLower() && u.Password == password))
                {
                    throw new InvalidLoginException("INVALID LOGIN");
                }
            }
            else if (u.UserType == TypeofUser.INTERNAL)
            {
                string errorMessage;
                userName = System.Text.RegularExpressions.Regex.Replace(userName, @"libertypower\\", "", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                bool isValidActiveDirectoryUser = IsValidADCredentials(userName, password, out errorMessage);

                if (!isValidActiveDirectoryUser)
                    throw new InvalidLoginException(errorMessage);
            }
            else { throw new InvalidLoginException("INVALID LOGIN"); }

            return u;
        }




        /// <summary>
        /// Full login name which must include the network domain in front.
        /// </summary>
        /// <param name="networkUserName">login name from the logged in user</param>
        /// <returns>return a user object loaded with activities when successful. 
        /// if invalid login, throws an InvalidLoginException</returns>
        /// <exception cref="InvalidLoginException" >thrown when networkUserName is not a valid user or is expired</exception>
        public static User LoginUser(string networkUserName, string appKey)
        {
            char[] splitCharacter = { '\\' };
            string[] userNameArray = networkUserName.Split(splitCharacter);
            string userName = userNameArray[1];
            string domainName = userNameArray[0].ToLower();
            User u;
            u = UserFactory.GetUserByLogin(networkUserName);

            if (domainName == "libertypower")
            {

                if (u == null) //this means the user was not found.
                {
                    throw new InvalidLoginException("No application account found for user: " + networkUserName);
                }
            }
            else if (domainName != "libertypower")
            {
                throw new InvalidLoginException("No account found for user: " + networkUserName);
            }



            if (u.UserType == TypeofUser.INTERNAL)
            {
                //make active directory call here.
                if (UserFactory.IsActiveDirectoryUser(u.Username))
                {

                    User userWithActivities = UserFactory.GetActivitiesOfUser(u.UserID, appKey);

                    //BUG 3039
                    if (userWithActivities != null)
                    {
                        userWithActivities.UserID = u.UserID;
                        return userWithActivities;
                    }
                    else
                    {
                        return u;
                    }
                }
                else
                {
                    throw new InvalidLoginException("INVALID LOGIN");
                }
            }
            else
            {
                throw new InvalidLoginException("INVALID LOGIN");
            }


        }


        /// <summary>
        /// Full login name which must include the network domain in front.
        /// </summary>
        /// <param name="networkUserName">login name from the logged in user</param>
        /// <returns>return a user object loaded with activities when successful. 
        /// if invalid login, throws an InvalidLoginException</returns>
        /// <exception cref="InvalidLoginException" >thrown when networkUserName is not a valid user or is expired</exception>
        public static User LoginUser(string networkUserName)
        {
            char[] splitCharacter = { '\\' };
            string[] userNameArray = networkUserName.Split(splitCharacter);
            string userName = userNameArray[1];
            string domainName = userNameArray[0].ToLower();
            User u;
            u = UserFactory.GetUserByLogin(networkUserName);

            if (domainName == "libertypower")
            {

                if (u == null) //this means the user was not found.
                {
                    throw new InvalidLoginException("No application account found for user: " + networkUserName);
                }
            }
            else if (domainName != "libertypower")
            {
                throw new InvalidLoginException("No account found for user: " + networkUserName);
            }

            if (u.UserType == TypeofUser.INTERNAL)
            {
                //make active directory call here.

                if (UserFactory.IsActiveDirectoryUser(u.Username))
                {

                    User userWithActivities = UserFactory.GetAllActivitiesOfUser(u.UserID);

                    //BUG 3039
                    if (userWithActivities != null)
                    {
                        userWithActivities.UserID = u.UserID;
                        return userWithActivities;
                    }
                    else
                    {
                        return u;
                    }
                }
                else
                {
                    throw new InvalidLoginException("INVALID LOGIN");
                }
            }
            else
            {
                throw new InvalidLoginException("INVALID LOGIN");
            }


        }
        /// <summary>
        /// Creates and saves the user.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <param name="password">The password.</param>
        /// <param name="firstname">The firstname.</param>
        /// <param name="lastname">The lastname.</param>
        /// <param name="email">The email.</param>
        /// <param name="createdBy">The created by.</param>
        /// <param name="legacyID">user id in the legacy system in lp_Portal.users</param>
        /// <param name="t">TypeOfUser- Internal or External enumerated type.</param>
        /// <param name="isActive">if set to <c>true</c> [is active].</param>
        /// <returns>A User object.</returns>
        public static User CreateUser(string userName, string password, string firstname,
                                        string lastname, string email, int createdBy, int legacyID, TypeofUser t, bool isActive)
        {
            User newUser = null;
            try
            {
                char isActiveChar = (isActive) ? 'Y' : 'N';
                DataSet ds = SecuritySql.CreateUserForUser(userName, password,
                    firstname, lastname, email, createdBy, legacyID, t.ToString(), isActiveChar);
                if (DataSetHelper.HasRow(ds) == true)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    newUser = LoadUserObject(ds.Tables[0].Rows[0]);
                }
            }
            catch (System.Data.SqlClient.SqlException exc)
            {
                if (exc.Message.Contains("ALREADY EXISTS"))
                {
                    throw new SecurityException("This user name already exists. Please choose another username.", exc);
                }
                else
                {
                    throw exc;
                }
            }
            return newUser;
        }

        public static User UserSetIsActive(int userID, bool isActive)
        {
            DataSet ds = SecuritySql.UserSetActive(userID, isActive);
            if (DataSetHelper.HasRow(ds) == true)
            {
                DataRow dr = ds.Tables[0].Rows[0];
                return LoadUserObject(ds.Tables[0].Rows[0]);
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Update user entry by the userid.
        /// Defaults the User to Active.
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <param name="firstname"></param>
        /// <param name="lastname"></param>
        /// <param name="email"></param>
        /// <param name="oUserType"></param>
        /// <param name="modifiedBy"></param>
        /// <returns></returns>
        public static User UpdateUser(int userID, string userName, string password,
                                    string firstname, string lastname,
                                     string email, TypeofUser oUserType, int modifiedBy)
        {
            return UpdateUser(userID, userName, password, firstname, lastname, email, true, oUserType, modifiedBy);
        }

        /// <summary>
        /// Update user entry by the userid.
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <param name="firstname"></param>
        /// <param name="lastname"></param>
        /// <param name="email"></param>
        /// <param name="isActive"></param>
        /// <param name="modifiedBy"></param>
        /// <returns></returns>
        public static User UpdateUser(int userID, string userName, string password,
                                    string firstname, string lastname,
                                     string email, bool isActive, TypeofUser oUserType, int modifiedBy)
        {
            User updatedUser = null;
            try
            {
                if (string.IsNullOrEmpty(password))
                {
                    // If the password is blank, then we need to get the current user so that we do not overwrite the password field.
                    User origUser = UserFactory.GetUser(userID);
                    password = origUser.Password;
                }
                else
                {
                    password = password.Trim();
                }

                char isActiveChar = (isActive) ? 'Y' : 'N';
                DataSet ds = SecuritySql.UpdateUserForUser(userID, userName.Trim(), password, firstname.Trim(), lastname.Trim(), email.Trim(), isActiveChar, oUserType.ToString(), modifiedBy);
                if (DataSetHelper.HasRow(ds) == true)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    updatedUser = LoadUserObject(ds.Tables[0].Rows[0]);
                }
            }
            catch (System.Data.SqlClient.SqlException exc)
            {
                if (exc.Message.Contains("ALREADY EXISTS"))
                {
                    throw new SecurityException("This user name already exists. Please choose another username.", exc);
                }
                else
                {
                    throw exc;
                }
            }
            return updatedUser;
        }

        /// <summary>
        /// Get the type of user by login name.
        /// </summary>
        /// <param name="loginName">username from either the login page or from the server varaible collection
        /// </param>
        /// <returns>user object loaded with their entry data</returns>
        public static User GetUserByLogin(string loginName)
        {
            User user = null;
            DataSet ds = SecuritySql.GetUserByLogin(loginName);

            if (DataSetHelper.HasRow(ds))
            {
                DataRow dr = ds.Tables[0].Rows[0];
                user = LoadUserObject(dr);
            }
            else
            {
                //this means the user was not in the userType table.
                //return null so that the other methods for internal users can work correctly.
            }
            return user;

        }

        /// <summary>
        /// Gets the user data.
        /// </summary>
        /// <param name="userID">The user ID.</param>
        /// <returns></returns>
        public static User GetUser(int userID)
        {
            User u = null;
            DataSet ds = SecuritySql.GetUserByUserID(userID);
            if (DataSetHelper.HasRow(ds))
            {
                DataRow dr = ds.Tables[0].Rows[0];
                u = LoadUserObject(dr);
            }
            return u;
        }

        /// <summary>
        /// Gets a list of all users.
        /// </summary>
        /// <returns></returns>
        public static UserList GetUsers()
        {
            DataSet ds = SecuritySql.GetUsers();
            UserList usrList = new UserList();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                User u = LoadUserObject(dr);
                usrList.Add(u);
            }
            return usrList;
        }

        /// <summary>
        ///  if user exists based on first name, last name and email.
        /// </summary>
        /// <returns></returns>
        public static User GetUsers(User User)
        {

            UserList usrList =  GetUsers();

           return ((from u in usrList
                    where u.FirstName.ToUpper() == User.FirstName.ToUpper()
              && u.LastName.ToUpper() == User.LastName.ToUpper()
              && u.Email.ToUpper() == User.Email.ToUpper()
              select u).FirstOrDefault());
           
        }

        public static List<User> GetUserMarginThresholdList(int? userID)
        {
            List<User> users = new List<User>();
            DataSet ds = SecuritySql.GetUsers("Revenue Management", true);
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                if (userID == null || (int)dr["UserID"] != userID)
                {
                    User u = LoadUserObject(dr);
                    users.Add(u);
                }
            }
            return users;
        }

        /// <summary>
        /// Gets a list of users by roles.
        /// </summary>
        /// <returns></returns>
        public static UserList GetUsers(string roleLista, bool mustHaveAllRoles)
        {
            DataSet ds = SecuritySql.GetUsers(roleLista, mustHaveAllRoles);
            UserList usrList = new UserList();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                User u = LoadUserObject(dr);
                usrList.Add(u);
            }
            return usrList;
        }

        public static string SendPasswordEmailToUser(string userLogin)
        {
            try
            {
                if (!userLogin.StartsWith("libertypower\\", StringComparison.CurrentCultureIgnoreCase))
                    userLogin = "libertypower\\" + userLogin;

                User user = UserFactory.GetUserByLogin(userLogin);
                if (user == null)
                    return "No user was found for the informed username.";

                if (user.UserType == TypeofUser.INTERNAL)
                {
                    return "Please contact your system administrator to have you Network password reset.";
                }

                if (String.IsNullOrEmpty(user.Password))
                {
                    user.Password = user.FirstName + "#" + String.Format("{0:D3}", user.UserID);
                    user.ModifiedBy = 0;
                    UserFactory.UpdateUser(user.UserID, user.Username, user.Password, user.FirstName, user.LastName, user.Email, user.UserType, user.ModifiedBy);
                }

                string fromEmail = "do-not-reply@libertypowercorp.com";
                string fromName = "Liberty Power Sales Portal";
                string subject = "Liberty Power Sales Portal Account Information";

                string email = "Dear " + user.DisplayName + ", <br/><br/>" +
                                "You have requested to have your password sent to you. Your new password is <i>" + user.Password + "</i>. <br/><br/>" +
                                "You may now login to the Liberty Power portal by clicking here: " +
                                "<a href=\"https://enrollment.libertypowercorp.com/proddealcapture/login.aspx?stay=a\">Liberty Power Sales Portal</a><br/><br/>" +
                                "<img src=\"https://enrollment.libertypowercorp.com/proddealcapture/images/libertypowerlogo.jpg\" alt=\"LibertyPower\" /><br/>" +
                                "<h5>The information contained in this transmission may contain confidential and proprietary information. It is intended only for the " +
                                "use of the person(s) named above. Intended recipients are reminded of their obligation to maintain the confidentiality of applicable " +
                                "Liberty Power information. If you have been sent this message in error, you are hereby notified that any review, dissemination, " +
                                "distribution or duplication of this communication is strictly prohibited. Further, if you have been sent this message in error, please " +
                                "contact the sender by reply email and destroy all copies of the original message. To reply to our email administrator directly, please " +
                                "send an email to <a href=\"mailto:email.security@libertypowercorp.com\">email.security@libertypowercorp.com</a>.</h5>";

                MailHandler.SendMailMessage(CreateEmail(fromEmail, fromName, user.Email, user.DisplayName, subject, email));

                return "An email with your password was sent.";
            }
            catch (Exception e)
            {
                throw new Exception(e.Message + " " + e.StackTrace);
            }
        }

        public static MailMessage CreateEmail(string from, string fromName, string to, string toName, string subject, string body)
        {
            MailMessage message = new MailMessage();
            MailAddress fromAddress = new MailAddress(from, fromName);
            message.From = fromAddress;
            message.To.Add(to);
            message.Subject = subject;
            message.IsBodyHtml = true;
            message.Body = body;
            return message;
        }

        /// <summary>
        /// Creates an entry in the userRole table in liberty power for a non active directory account.
        /// </summary>
        /// <param name="roleName">Name of the role.</param>
        /// <param name="userID">The user ID.</param>
        /// <param name="createdBy">The created by.</param>
        /// <returns>return a loaded user object with the newly assigned role.</returns>
        public static User AssignRoleToUser(string roleName, int userID, int createdBy)
        {
            RoleList roleList = RoleFactory.GetRoleByRolename(roleName);
            if (roleList == null || roleList.Count == 0)
            {
                throw new SecurityException(string.Format("Rolename, \"{0}\" does not exist", roleName));
            }
            return AssignRoleToUser(roleList[0].RoleID, userID, createdBy);
        }

        /// <summary>
        /// Creates an entry in the userRole table in liberty power for a non active directory account.
        /// </summary>
        /// <param name="roleID">role id in the role table</param>
        /// <param name="userID">user id in the user table.</param>
        /// <param name="createdBy"></param>
        /// <returns>return a loaded user object with the newly assigned role.</returns>
        public static User AssignRoleToUser(int roleID, int userID, int createdBy)
        {
            User u = null;
            DataSet ds = SecuritySql.AssignUserRoleForUser(userID, roleID, createdBy);

            if (DataSetHelper.HasRow(ds))
            {
                u = LoadUserObject(ds.Tables[0].Rows[0]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Role r = RoleFactory.GetRole(dr);
                    u.ListOfRoles.Add(r);
                }
            }
            return u;
        }

        /// <summary>
        /// Removes the role of user.
        /// </summary>
        /// <param name="roleName">Name of the role.</param>
        /// <param name="userID">The user ID.</param>
        /// <returns>returns the user object with their current roles</returns>
        public static User RemoveRoleOfUser(int userID, string roleName)
        {
            RoleList roleList = RoleFactory.GetRoleByRolename(roleName);
            if (roleList == null || roleList.Count == 0)
            {
                throw new SecurityException(string.Format("Rolename, \"{0}\" does not exist", roleName));
            }
            return RemoveRoleOfUser(userID, roleList[0].RoleID);
        }

        /// <summary>
        /// removes a role from a user
        /// </summary>
        /// <param name="userID">Id of the role.</param>
        /// <param name="roleID"></param>
        /// <returns>returns the user object with their current roles</returns>
        public static User RemoveRoleOfUser(int userID, int roleID)
        {
            DataSet ds = SecuritySql.RemoveUserRoleForUser(userID, roleID);
            User u = null;
            if (DataSetHelper.HasRow(ds))
            {
                u = UserFactory.LoadUserObject(ds.Tables[0].Rows[0]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Role r = RoleFactory.GetRole(dr);
                    if (r != null)
                    {
                        u.ListOfRoles.Add(r);
                    }
                }
            }
            return u;
        }

        /// <summary>
        /// Removes all roles of user.
        /// </summary>
        /// <param name="userID">The user ID.</param>
        /// <returns></returns>
        public static User RemoveAllRolesOfUser(int userID)
        {
            User u = null;
            DataSet ds = SecuritySql.RemoveALLUserRoleForUser(userID);

            if (DataSetHelper.HasRow(ds) == true)
            {
                u = UserFactory.LoadUserObject(ds.Tables[0].Rows[0]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Role r = RoleFactory.GetRole(dr);
                    if (r != null)
                    {
                        u.ListOfRoles.Add(r);
                    }
                }
            }
            return u;
        }

        /// <summary>
        /// Copies one user's role to another user.
        /// </summary>
        /// <param name="copyFromUserId">The copy from user id.</param>
        /// <param name="copyToUserId">The copy to user id.</param>
        /// <param name="isExactClone">if set to <c>true</c> then the copyToUser's current roles are deleted so that that it will have only the roles that the copyFromUser currently has.</param>
        /// <returns></returns>
        public static User CloneUserRoles(int copyFromUserId, int copyToUserId, bool isExactClone)
        {
            return CloneUserRoles(copyFromUserId, copyToUserId, isExactClone, 1);
        }

        /// <summary>
        /// Copies one user's role to another user.
        /// </summary>
        /// <param name="copyFromUserId">The copy from user id.</param>
        /// <param name="copyToUserId">The copy to user id.</param>
        /// <param name="isExactClone">if set to <c>true</c> then the copyToUser's current roles are deleted so that that it will have only the roles that the copyFromUser currently has.</param>
        /// <param name="modifiedBy">The modified by.</param>
        /// <returns></returns>
        public static User CloneUserRoles(int copyFromUserId, int copyToUserId, bool isExactClone, int modifiedBy)
        {
            User copyToUser = null;
            DataSet ds = SecuritySql.CloneUserRoles(copyFromUserId, copyToUserId, isExactClone, modifiedBy);
            if (DataSetHelper.HasRow(ds))
                copyToUser = LoadUserObject(ds.Tables[0].Rows[0]);

            return copyToUser;
        }

        /// <summary>
        /// retrieve the activities for an user
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="userID">integer value used for the query</param>
        /// <returns>returns a loaded user with his ListOfActivies loaded</returns>
        public static User GetActivitiesOfUser(int userID)
        {
            return GetActivitiesOfUser(userID, null);
        }

        /// <summary>
        /// retrieve the activities for an user
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="userID">integer value used for the query</param>
        /// <returns>returns a loaded user with his ListOfActivies loaded</returns>
        public static User GetAllActivitiesOfUser(int userID)
        {
            User u = null;
            DataSet ds = SecuritySql.GetAllActivitiesForUser(userID);

            if (DataSetHelper.HasRow(ds) == true)
            {
                u = UserFactory.LoadUserObject(ds.Tables[0].Rows[0]);
                ActivityList activityList = new ActivityList();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Activity a = ActivityFactory.GetActivityForUser(dr);
                    if (a != null)
                    {
                        activityList.Add(a);
                    }
                }
                u.ListOfActivites = activityList;
            }
            return u;
        }

        /// <summary>
        /// retrieve the activities for an user
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="userID">integer value used for the query</param>
        /// <param name="appKey">string vaule used for the query</param>
        /// <returns>returns a loaded user with his ListOfActivies loaded</returns>
        public static User GetActivitiesOfUser(int userID, string appKey)
        {
            User u = null;
            DataSet ds = SecuritySql.GetActivitiesForUser(userID, appKey);

            if (DataSetHelper.HasRow(ds) == true)
            {
                u = UserFactory.LoadUserObject(ds.Tables[0].Rows[0]);
                ActivityList activityList = new ActivityList();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Activity a = ActivityFactory.GetActivityForUser(dr);
                    if (a != null)
                    {
                        activityList.Add(a);
                    }
                }
                u.ListOfActivites = activityList;
            }
            return u;
        }

        /// <summary>
        /// retrieve the activities for an user
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns></returns>
        public static User GetActivitiesOfUser(User user)
        {
            return GetActivitiesOfUser(user, null);
        }

        /// <summary>
        /// retrieve the activities for an user
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <param name="appKey">The app key.</param>
        /// <returns></returns>
        public static User GetActivitiesOfUser(User user, string appKey)
        {
            DataSet ds = SecuritySql.GetActivitiesForUser(user.UserID, appKey);
            ActivityList activityList = new ActivityList();
            if (DataSetHelper.HasRow(ds) == true)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Activity a = ActivityFactory.GetActivityForUser(dr);
                    if (a != null)
                    {
                        activityList.Add(a);
                    }
                }
            }
            user.ListOfActivites = activityList;

            return user;
        }

        /// <summary>
        /// Get the roles for a user by his userid
        /// </summary>
        /// <param name="userID"></param>
        /// <returns>return a user with his list of Roles.</returns>
        public static User GetRolesOfUser(int userID)
        {
            User u = null;
            DataSet ds = SecuritySql.GetUserRoleByUserIDForUser(userID);
            if (DataSetHelper.HasRow(ds) == true)
            {
                RoleList roleList = new RoleList();
                u = UserFactory.LoadUserObject(ds.Tables[0].Rows[0]);
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Role r = RoleFactory.GetRole(dr);
                    if (r != null)
                    {
                        roleList.Add(r);
                    }
                }
                u.ListOfRoles = roleList;
            }
            return u;
        }

        /// <summary>
        /// Gets the roles of user.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns>return a user with its list of Roles.</returns>
        public static User GetRolesOfUser(User user)
        {
            DataSet ds = SecuritySql.GetUserRoleByUserIDForUser(user.UserID);
            RoleList roleList = new RoleList();
            if (DataSetHelper.HasRow(ds) == true)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Role r = RoleFactory.GetRole(dr);
                    if (r != null)
                    {
                        roleList.Add(r);
                    }
                }
            }
            user.ListOfRoles = roleList;

            return user;
        }

        /// <summary>
        /// Validates username and password against Active Directory
        /// </summary>
        /// <param name="username">Username</param>
        /// <param name="password">Password</param>
        /// <param name="error">Exception message</param>
        /// <returns>True or false</returns>
        public static bool IsValidADCredentials(string username, string password, out string error)
        {
            try
            {
                string domain = string.Empty;
                string domainAndUsername = string.Empty;
                string adsPath = string.Empty;
                error = "";

                domain = CustomSettingsManager.Settings.ADDomain;
                domainAndUsername = domain + @"\" + username;
                DirectoryEntry entry = new DirectoryEntry(adsPath, domainAndUsername, password);


                object obj = entry.NativeObject;
                DirectorySearcher search = new DirectorySearcher(entry);

                search.Filter = "(SAMAccountName=" + username + ")";
                search.PropertiesToLoad.Add("cn");
                SearchResult result = search.FindOne();

                if (null == result)
                    return false;
            }
            catch (Exception ex)
            {
                error = "Error authenticating user. " + ex.Message;
                return false;
            }

            return true;
        }

        /// <summary>
        /// Gets all the users that have a determined role assigned
        /// </summary>
        /// <param name="roleID">the id of the role</param>
        /// <returns>User list containing all the users assigned to that role</returns>
        public static UserList GetUsersAssignedToRole(int roleID)
        {
            DataSet ds = SecuritySql.GetUsersAssignedToRole(roleID);
            UserList usrList = new UserList();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                User u = LoadUserObject(dr);
                usrList.Add(u);
            }
            return usrList;
        }

       
        /// <summary>
        /// Gets all the sales channel agents
        /// </summary>
        /// <param name="channelId">The sales Channel Id</param>
        /// <returns>Sales channel agents list</returns>
        public static UserList GetSalesChannelUserList(int channelId)
        {
            DataSet ds = SalesChannelSql.GetSalesChannelAgentList(channelId);
            UserList usrList = new UserList();
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                User u = LoadUserObject(dr);
                usrList.Add(u);
            }
            return usrList;

        }
       
        /// <summary>
        /// Removes a determined role from all users assigned to it
        /// </summary>
        /// <param name="roleID">The id of the role</param>
        public static void RemoveRoleOfAllUsers(int roleID)
        {
            SecuritySql.RemoveRoleFromAllUsers(roleID);
        }

        #region Private Methods

        /// <summary>
        /// Loads the user object from a datarow.
        /// The datarow must include the following:
        ///		UserName
        ///		Password
        ///		Firstname
        ///		Lastname
        ///		Email
        ///		DateCreated
        ///		DateModified
        ///		CreatedBy
        ///		ModifiedBY
        ///		LegacyID
        ///		UserType
        ///		IsActive
        /// </summary>
        /// <param name="datarow">The datarow.</param>
        /// <returns>Return a loaded user object</returns>
        private static User LoadUserObject(DataRow datarow)
        {
            User u = new User();
            u.UserID = (int)(datarow["UserID"] as int? ?? 0);
            u.Username = Convert.ToString(datarow["UserName"]);
            u.Password = Convert.ToString(datarow["Password"]);
            u.FirstName = Convert.ToString(datarow["Firstname"]);
            u.LastName = Convert.ToString(datarow["Lastname"]);
            u.Email = Convert.ToString(datarow["Email"]);
            u.DateCreated = (DateTime)(datarow["DateCreated"] as DateTime? ?? u.DateCreated);
            u.DateModified = (DateTime)(datarow["DateModified"] as DateTime? ?? u.DateModified);
            u.CreatedBy = (int)(datarow["CreatedBy"] as int? ?? 0);
            u.ModifiedBy = (int)(datarow["ModifiedBy"] as int? ?? 0);
            u.IsActive = (Convert.ToString(datarow["isActive"]) == "Y") ? true : false;
            u.LegacyID = (int)(datarow["LegacyID"] as int? ?? 0);

            string userTypeName = Convert.ToString(datarow["userType"]);
            u.UserType = (TypeofUser.EXTERNAL.ToString("g").Equals(userTypeName, StringComparison.OrdinalIgnoreCase)) ? TypeofUser.EXTERNAL : TypeofUser.INTERNAL;

            return u;
        }


        public static bool IsGroupMember(string groupName, string username)
        {
            try
            {

                var domain = "";
                if (CustomSettingsManager.Settings == null)
                {
                    domain = "libertypower.local";
                }
                else
                {
                    domain = CustomSettingsManager.Settings.ADDomain;
                }

                var context = RetrievePrincipalContext(domain);

                if (context == null)
                    return false;
                UserPrincipal user = null;

                try
                {
                    user = UserPrincipal.FindByIdentity(context, username);
                }
                catch{}

                if (user == null)
                    return false;

                var groups = user.GetAuthorizationGroups();

                var myGroups = groups.Where(s => (s.ContextType == ContextType.Domain || s.ContextType == ContextType.Machine) && s.Name.Equals(groupName));


                using (var iter = myGroups.GetEnumerator())
                {
                    while (iter.MoveNext())
                    {
                        try
                        {
                            if (iter.Current is Principal)
                            {
                                var p = iter.Current;
                                if (p.Name.Equals(groupName))
                                    return true;
                            }
                            else
                            {
                                return false;
                            }
                        }
                        catch
                        {
                            return false;
                        }
                    }
                }
            }
            catch
            {
                return false;
            }

            return false;

        }

        public static bool IsGroupMember(string groupName)
        {
            try
            {

                var domain = "";
                if (CustomSettingsManager.Settings == null)
                {
                    domain = "libertypower.local";
                }
                else
                {
                    domain = CustomSettingsManager.Settings.ADDomain;
                }

                var context = RetrievePrincipalContext(domain);

                if (context == null)
                    return false;

                var groups = UserPrincipal.Current.GetAuthorizationGroups();

                var myGroups = groups.Where(s => (s.ContextType == ContextType.Domain || s.ContextType == ContextType.Machine) && s.Name.Equals(groupName));


                using (var iter = myGroups.GetEnumerator())
                {
                    while (iter.MoveNext())
                    {
                        try
                        {
                            if (iter.Current is Principal)
                            {
                                var p = iter.Current;
                                if (p.Name.Equals(groupName))
                                    return true;
                            }
                            else
                            {
                                return false;
                            }
                        }
                        catch
                        {
                            return false;
                        }
                    }
                }
            }
            catch
            {
                return false;
            }

            return false;

        }

        /// <summary>
        /// Active directory method for internal users to check if the user account is enabled.
        /// </summary>
        /// <param name="loginName">login name without the domain in front..
        /// ie afranco NOT libertypower/afranco.</param>
        /// <param name="resultText"></param>
        /// <returns>true or false. True is good.</returns>
        private static bool IsActiveDirectoryUser(string loginName)
        {
            //return true;
            var domain = "";
            if (CustomSettingsManager.Settings == null)
            {
                domain = "libertypower";
            }
            else
            {
                domain = CustomSettingsManager.Settings.ADDomain;
            }

            var context = RetrievePrincipalContext(domain);

            if (context == null)
                return false;

            using (var user = UserPrincipal.FindByIdentity(context, loginName))
            {
                return user != null;
            }

        }

        public static PrincipalContext RetrievePrincipalContext(string domain)
        {
            PrincipalContext context = null;
            if (HttpContext.Current != null) //check if data is cached already
            {
                context = System.Web.HttpContext.Current.Application["PrincipalContext"] as PrincipalContext;
                if (context == null)
                {
                    context = new PrincipalContext(ContextType.Domain, domain);
                    HttpContext.Current.Cache.Add("PrincipalContext", context, null, DateTime.Now + TimeSpan.FromMinutes(10), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Default, null);
                }

            }
            else
            {
                context = new PrincipalContext(ContextType.Domain, domain);
            }
            return context;
        }


        /// <summary>
        /// Get limited list of activities that match a role name.
        /// </summary>
        /// <param name="roleName">name of the role to user for the filter</param>
        /// <param name="actList">full list of activities</param>
        /// <returns>return a activity list containing only the activities for the role.</returns>
        private static ActivityList FilterActivitiesByRole(string roleName, ActivityList actList)
        {
            ActivityList matchingActList = new ActivityList();
            foreach (Activity a in actList)
            {
                if (a.RoleName == roleName)
                {
                    matchingActList.Add(a);
                }
            }
            return matchingActList;
        }
        #endregion Private Methods

        #region Legacy related methods that will be obsolete
        [Obsolete("This is OMS specific. Should this be removed?")]
        public static UserList GetInternalUsersForDevMgrAssigment()
        {
            UserList usrList = new UserList();
            DataSet ds = InternalUserSql.GetInternalUsersForDevMgrRole();
            if (DataSetHelper.HasRow(ds))
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    //load the user
                    User u = GetInternalUserFromDNN(dr);
                    RoleList rList = new RoleList();
                    foreach (DataRow dr2 in ds.Tables[0].Rows)
                    {
                        //load only OMS ROLES
                        Role r = RoleFactory.GetInternalRole(dr2);
                        if (r.RoleName.Contains("OMS"))
                        {
                            rList.Add(r);
                        }
                    }

                    u.ListOfRoles = rList;
                    usrList.Add(u);
                }
                return usrList;

            }
            return null;
        }

        [Obsolete("Legacy Sales User will no longer be needed.")]
        public static User GetInternalUserByLegacyID(int legacyID)
        {
            DataSet ds = SecuritySql.GetUserByLegacyID(legacyID);
            if (DataSetHelper.HasRow(ds))
            {
                DataRow dr = ds.Tables[0].Rows[0];
                return LoadUserObject(dr);
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// return a loaded user object from a datarow from the legacy system. The datarow must contain:
        /// /// UserName
        /// Firstname
        /// Lastname
        /// Email
        /// UserID
        /// </summary>
        /// <param name="dr"></param>
        /// <returns>a loaded user object</returns>
        [Obsolete("DNN is going away.")]
        public static User GetInternalUserFromDNN(DataRow dr)
        {
            int userID = 0;
            string username = Convert.ToString(dr["UserName"]);
            string pwd = "";//Convert.ToString(dr["Password"]);
            string firstname = Convert.ToString(dr["Firstname"]);
            string lastname = Convert.ToString(dr["Lastname"]);
            string email = Convert.ToString(dr["Email"]);
            int legacyID;
            bool result2 = int.TryParse(Convert.ToString(dr["UserID"]), out legacyID);
            TypeofUser t = TypeofUser.INTERNAL;
            bool isActive = false;

            DataSet ds = SecuritySql.GetUserByLegacyID(legacyID);
            if (DataSetHelper.HasRow(ds))
            {
                userID = Convert.ToInt32(ds.Tables[0].Rows[0]["UserID"]);
                isActive = (Convert.ToString(ds.Tables[0].Rows[0]["UserID"]) == "Y") ? true : false;

            }

            User u = new User(userID, username, pwd, firstname, lastname, email, DateTime.MinValue, DateTime.MinValue, 0, 0, legacyID, t, isActive);
            return u;
        }

        /// <summary>
        /// a user loaded with his roles from his id in the lp_Portal users and roles tables.
        /// </summary>
        /// <param name="legacyID">the userid in the lp_portal table</param>
        /// <returns>user object loaded with roles</returns>
        [Obsolete("GetUserRolesInternal is going away.")]
        public static User GetUserRolesInternal(int legacyID)
        {
            //get the user info from the lp_security database.
            //load a user object with roles from the data.
            DataSet ds = InternalUserSql.GetInternalUserByUserID(legacyID);
            if (!DataSetHelper.HasRow(ds))
            {
                return null;
            }
            else
            {
                DataRow dr = ds.Tables[0].Rows[0];
                //load the user
                User u = GetInternalUserFromDNN(dr);
                RoleList rList = new RoleList();
                foreach (DataRow dr2 in ds.Tables[0].Rows)
                {
                    //load the roles
                    Role r = RoleFactory.GetInternalRole(dr2);
                    rList.Add(r);
                }
                u.ListOfRoles = rList;

                return u;
            }
        }



        /// <summary>
        /// main method for retrieving the activities 
        /// for a user based on the userid in the legacy system.
        /// </summary>
        /// <param name="legacyID"></param>
        /// <returns>returns an activitylist of activities for the user from the legacy system.</returns>
        [Obsolete("GetActivitiesForInternalUser is going away.")]
        public static User GetActivitiesForInternalUser(int legacyID, string AppKey)
        {
            User u = UserFactory.GetUserRolesInternal(legacyID);
            if (u != null)
            {
                //Get List of all activities by appname
                ActivityList actList = ActivityFactory.GetActivitiesForInternalUsers(AppKey);
                foreach (Role r in u.ListOfRoles)
                {
                    ActivityList aList = UserFactory.FilterActivitiesByRole(r.RoleName, actList);
                    u.ListOfActivites.AddRange(aList);
                }

                DataSet dsUser = SecuritySql.GetUserByLegacyID(legacyID);
                u.UserID = Convert.ToInt32(dsUser.Tables[0].Rows[0]["UserID"]);
                u.Username = Convert.ToString(dsUser.Tables[0].Rows[0]["UserName"]);
            }
            return u;
        }
        #endregion Legacy related methods that will be obsolete

        #region Deprecated methods
        /// <summary>
        /// Creates an entry in the userRole table in liberty power for a non active directory account.
        /// </summary>
        /// <param name="roleID">role id in the role table</param>
        /// <param name="userID">user id in the user table.</param>
        /// <param name="createdBy"></param>
        /// <returns>return a loaded user object with the newly assigned role.</returns>
        [Obsolete("AssignRoleToExternalUser has been deprecated. Use AssignRoleToUser")]
        public static User AssignRoleToExternalUser(int roleID, int userID, int createdBy)
        {
            return AssignRoleToUser(roleID, userID, createdBy);
        }
        /// <summary>
        /// removes a role from a user
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="roleID"></param>
        /// <returns>returns the user object with their current roles</returns>
        [Obsolete("RemoveRoleOfExternalUser has been deprecated. Use RemoveRoleOfUser")]
        public static User RemoveRoleOfExternalUser(int userID, int roleID)
        {
            return RemoveRoleOfUser(userID, roleID);
        }

        [Obsolete("RemoveAllRolesOfExternalUser has been deprecated. Use RemoveAllRolesOfUser")]
        public static User RemoveAllRolesOfExternalUser(int userID)
        {
            return RemoveAllRolesOfUser(userID);
        }

        [Obsolete("Legacy Sales Channel will no longer be needed.")]
        public static UserList GetLegacySalesChannels()
        {

            //DataSet ds = DataAccess.SqlAccess.PortalSql.InternalUserSql.GetInternalSalesChannels();
            //UserList usrList = new UserList();
            //if (DataSetHelper.HasRow(ds))
            //{
            //    foreach (DataRow dr in ds.Tables[0].Rows)
            //    {
            //        //load the user
            //        User u = GetInternalUserFromDNN(dr);
            //        RoleList rList = new RoleList();
            //        foreach (DataRow dr2 in ds.Tables[0].Rows)
            //        {

            //            Role r = RoleFactory.GetInternalRole(dr2);

            //            rList.Add(r);

            //        }

            //        u.ListOfRoles = rList;
            //        usrList.Add(u);
            //    }
            //    return usrList;

            //}
            return null;
        }

        /// <summary>
        /// create a new user in the user table from info in the legacy system of lp_portal 
        /// only if they do not yet exist in liberty power database.
        /// </summary>
        /// <param name="userName">unique username</param>
        /// <param name="password">password</param>
        /// <param name="firstname"></param>
        /// <param name="lastname"></param>
        /// <param name="email"></param>
        /// <param name="createdBy"></param>
        /// <param name="legacyID">user id in the legacy system in lp_portal.users table.</param>
        /// <param name="t">Type Of user-enumerated value- TypeOfUser.Internal or TypeOfUser.External</param>
        /// <returns>a loaded user with the newly created entry data</returns>
        [Obsolete("CreateAccountForInternalUser has been deprecated. Use the CreateUser function.")]
        public static User CreateAccountForInternalUser(string userName, string password, string firstname,
                                                            string lastname, string email, int createdBy, int legacyID, TypeofUser t)
        {
            return CreateUser(userName, password, firstname, lastname, email, createdBy, legacyID, t, true);
        }

        /// <summary>
        /// create a new user in the user table of Liberty Power.
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <param name="firstname"></param>
        /// <param name="lastname"></param>
        /// <param name="email"></param>
        /// <param name="createdBy"></param>
        /// <param name="legacyID">user id in the legacy system in lp_Portal.users</param>
        /// <param name="t">TypeOfUser- Internal or External enumerated type.</param>
        /// <returns></returns>
        [Obsolete("CreateExternalUser has been deprecated. Use the CreateUser function.")]
        public static User CreateExternalUser(string userName, string password, string firstname, string lastname, string email, int createdBy, int legacyID, TypeofUser t)
        {
            return CreateUser(userName, password, firstname, lastname, email, createdBy, legacyID, t, true);
        }

        /// <summary>
        /// Constructor for user object 
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="userName"></param>
        /// <returns></returns>
        [Obsolete("GetInternalUserData has been deprecated. Use function GetUser")]
        public static User GetInternalUserData(int userID)
        {
            User u = GetUser(userID);
            if (u != null)
                u.UserType = TypeofUser.INTERNAL;

            return u;
        }

        /// <summary>
        /// load an internal user after creating a entry in the user table.
        /// the datarow must include:
        /// UserName
        /// Firstname
        /// Lastname
        /// Email
        /// UserID
        /// 
        /// </summary>
        /// <param name="dr"></param>
        /// <returns>return a loaded user object</returns>
        [Obsolete("GetNewlyCreatedInternalUser has been deprecated. Use the function LoadUserObject")]
        public static User GetNewlyCreatedInternalUser(DataRow dr)
        {
            return LoadUserObject(dr);
        }

        /// <summary>
        /// Constructor for a user object of type external.
        /// The datarow dr must include:
        /// 
        /// UserName
        /// Password
        /// Firstname
        /// Lastname
        /// Email
        /// DateCreated
        /// DateModified
        /// CreatedBy
        /// ModifiedBY
        /// LegacyID
        /// userType
        /// 
        /// </summary>
        /// <param name="dr"></param>
        /// <returns>returns a loaded user object</returns>
        [Obsolete("GetNewlyCreatedInternalUser has been deprecated. Use the function LoadUserObject")]
        public static User GetExternalUser(DataRow dr)
        {
            return LoadUserObject(dr);
        }

        /// <summary>
        /// return a loaded  user object of type Internal from a datarow. Columns must include:
        /// UserName
        /// Firstname
        /// Lastname
        /// Email
        /// legacyID
        /// </summary>
        /// <param name="dr"></param>
        /// <returns></returns>
        [Obsolete("GetInternalUser has been deprecated. Use the function LoadUserObject.")]
        public static User GetInternalUser(DataRow dr)
        {
            return LoadUserObject(dr);
        }

        /// <summary>
        /// retrieve the activities for an external user(not in active directory) 
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="userID">integer value used for the query</param>
        /// <returns>returns a loaded user with his ListOfActivies loaded</returns>
        [Obsolete("GetActivitiesOfExternalUser has been deprecated. Use the function GetActivitiesOfUser.")]
        public static User GetActivitiesOfExternalUser(int userID)
        {
            return GetActivitiesOfUser(userID, null);
        }

        /// <summary>
        /// retrieve the activities for an external user(not in active directory) 
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="userID">integer value used for the query</param>
        /// <param name="appKey">string vaule used for the query</param>
        /// <returns>returns a loaded user with his ListOfActivies loaded</returns>
        [Obsolete("GetActivitiesOfExternalUser has been deprecated. Use the function GetActivitiesOfUser.")]
        public static User GetActivitiesOfExternalUser(int userID, string appKey)
        {
            return GetActivitiesOfUser(userID, appKey);
        }

        /// <summary>
        /// retrieve the activities for an external user(not in active directory) 
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns></returns>
        [Obsolete("GetActivitiesOfExternalUser has been deprecated. Use the function GetActivitiesOfUser.")]
        public static User GetActivitiesOfExternalUser(User user)
        {
            return GetActivitiesOfUser(user, null);
        }

        /// <summary>
        /// retrieve the activities for an external user(not in active directory) 
        /// by their userid in the Liberty Power table.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <param name="appKey">The app key.</param>
        /// <returns></returns>
        [Obsolete("GetActivitiesOfExternalUser has been deprecated. Use the function GetActivitiesOfUser.")]
        public static User GetActivitiesOfExternalUser(User user, string appKey)
        {
            return GetActivitiesOfUser(user, appKey);
        }

        /// <summary>
        /// Get the roles for a user by his userid
        /// </summary>
        /// <param name="userID"></param>
        /// <returns>return a user with his list of Roles.</returns>
        [Obsolete("GetRolesOfExternalUser has been deprecated. Use the function GetRolesOfUser.")]
        public static User GetRolesOfExternalUser(int userID)
        {
            return GetRolesOfUser(userID);
        }

        /// <summary>
        /// Gets the roles of external user.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns>return a user with its list of Roles.</returns>
        [Obsolete("GetRolesOfExternalUser has been deprecated. Use the function GetRolesOfUser.")]
        public static User GetRolesOfExternalUser(User user)
        {
            return GetRolesOfUser(user);
        }

        /// <summary>
        /// constructor for a user object for an external user
        /// </summary>
        /// <param name="userID">userid in user table</param>
        /// <param name="userName">username in user table.</param>
        /// <returns>returns a loaded user object</returns>
        [Obsolete("GetExternalUser has been deprecated.")]
        public static User GetExternalUser(int userID, string userName)
        {
            User u = new User(userID, userName);
            u.UserType = TypeofUser.EXTERNAL;
            return u;
        }
        ///// <summary>
        ///// Constructor for user object 
        ///// </summary>
        ///// <param name="userID"></param>
        ///// <param name="userName"></param>
        ///// <returns></returns>
        [Obsolete("GetInternalUser has been deprecated.")]
        public static User GetInternalUser(int userID, string userName)
        {

            User u = new User(userID, userName);
            u.UserType = TypeofUser.INTERNAL;
            return u;
        }

        #endregion Deprecated methods
    }
}
