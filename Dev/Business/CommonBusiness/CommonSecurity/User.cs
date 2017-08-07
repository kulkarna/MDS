using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    [Serializable]
    public class User
    {

        public static int SystemUserID = 1029;
        //UserID
        //UserName
        //Password
        //Firstname
        //Lastname
        //Email
        //DateCreated

        #region Properties

        private int userID;
        private string userName;
        private string password;
        private string firstName;
        private string lastName;
        private string email;
        private DateTime dateCreated;
        private DateTime dateModified;
        private int modifiedBy;
        private int createdBy;
        private ActivityList listOfActivites;
        private RoleList listOfRoles;
        private TypeofUser userType;
        private List<string> validationMessages;
        private string userGuid;
        private string userImage;


        private int legacyID;

        /// <summary>
        /// Gets or sets the legacy ID.
        /// Legacy ID is being phased out and will no longer be needed.
        /// </summary>
        /// <value>The legacy ID.</value>
        public int LegacyID
        {
            get { return legacyID; }
            set { legacyID = value; }
        }

        /// <summary>
        /// Gets or sets the type of the user.
        /// </summary>
        /// <value><c>Internal</c> or <c>External</c></value>
        public TypeofUser UserType
        {
            get { return userType; }
            set { userType = value; }
        }

        /// <summary>
        /// Gets or sets the list of the users activites.
        /// </summary>
        /// <value>The list of activites.</value>
        public ActivityList ListOfActivites
        {
            get
            {
                if (listOfActivites == null)
                    listOfActivites = UserFactory.GetActivitiesOfUser(this).ListOfActivites;

                return listOfActivites;
            }
            set { listOfActivites = value; }
        }

        /// <summary>
        /// Gets or sets the list of the users roles.
        /// </summary>
        /// <value>The list of roles.</value>
        public RoleList ListOfRoles
        {
            get
            {
                if (listOfRoles == null)
                    listOfRoles = UserFactory.GetRolesOfUser(this.UserID).ListOfRoles;

                return listOfRoles;
            }
            set { listOfRoles = value; }
        }

        /// <summary>
        /// Gets or sets the user ID.
        /// </summary>
        /// <value>The user ID.</value>
        public int UserID
        {
            get { return userID; }
            set { userID = value; }
        }

        /// <summary>
        /// Gets or sets the username.
        /// </summary>
        /// <value>The username.</value>
        public string Username
        {
            get { return userName; }
            set { userName = value; }
        }

        /// <summary>
        /// Gets or sets the password.
        /// </summary>
        /// <value>The password.</value>
        public string Password
        {
            get { return password; }
            set
            {
                string tempPassword = (string.IsNullOrEmpty(value)) ? null : value.Trim();
                password = (string.IsNullOrEmpty(tempPassword)) ? null : tempPassword;
            }
        }

        public string FirstName
        {
            get { return firstName; }
            set { firstName = value; }
        }

        /// <summary>
        /// Gets or sets the last name.
        /// </summary>
        /// <value>The last name.</value>
        public string LastName
        {
            get { return lastName; }
            set { lastName = value; }
        }

        /// <summary>
        /// Gets the user's display name.
        /// </summary>
        /// <value>The display name.</value>
        public string DisplayName
        {
            get { return string.Format("{0} {1}", FirstName, LastName); }
        }

        /// <summary>
        /// Gets or sets the email.
        /// </summary>
        /// <value>The email.</value>
        public string Email
        {
            get { return email; }
            set { email = value; }
        }

        /// <summary>
        /// Gets or sets the date created.
        /// </summary>
        /// <value>The date created.</value>
        public DateTime DateCreated
        {
            get { return dateCreated; }
            set { dateCreated = value; }
        }

        /// <summary>
        /// Gets or sets the date modified.
        /// </summary>
        /// <value>The date modified.</value>
        public DateTime DateModified
        {
            get { return dateModified; }
            set { dateModified = value; }
        }

        /// <summary>
        /// Gets or sets the created by.
        /// </summary>
        /// <value>The created by.</value>
        public int CreatedBy
        {
            get { return createdBy; }
            set { createdBy = value; }
        }

        /// <summary>
        /// Gets or sets the modified by.
        /// </summary>
        /// <value>The modified by.</value>
        public int ModifiedBy
        {
            get { return modifiedBy; }
            set { modifiedBy = value; }
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is active.
        /// </summary>
        /// <value><c>true</c> if this instance is active; otherwise, <c>false</c>.</value>
        public bool IsActive { get; set; }

        /// <summary>
        /// Gets if is LP Employee.
        /// </summary>
        public bool IsLibertyEmployee
        {
            get { return IsAssignedToRole("libertypoweremployes"); }
        }

        /// <summary>
        /// Gets or sets the user guid.
        /// </summary>
        /// <value>The user guid.</value>
        public string UserGuid
        {
            get { return this.userGuid; }
            set { this.userGuid = value; }
        }

        /// <summary>
        /// Gets or sets the user image.
        /// </summary>
        /// <value>The user image.</value>
        public string UserImage
        {
            get { return this.userImage; }
            set { this.userImage = value; }
        }

        #endregion

        #region Constructors


        public User()
        { }

        internal User(int userid, string username, string password,
            string firstname, string lastname, string email, DateTime dtcreated, DateTime datemodified,
            int createdby, int modifiedby, int legacyid, TypeofUser userType, bool isActive)
        {
            this.dateCreated = dtcreated;
            this.email = email;

            this.FirstName = firstname;
            this.LastName = lastname;
            this.Password = password;
            this.UserID = userid;
            this.Username = username;
            this.DateCreated = dtcreated;
            this.CreatedBy = createdby;
            this.ModifiedBy = modifiedby;
            this.DateModified = datemodified;
            this.UserType = userType;
            this.IsActive = isActive;
            this.legacyID = legacyid;
        }

        internal User(int userID, string userName)
        {
            this.userID = userID;
            this.userName = userName;
        }


        /// <summary>
        /// Initializes a new instance of the <see cref="User"/> class.
        /// </summary>
        /// <param name="username">The username.</param>
        /// <param name="password">The password.</param>
        /// <param name="firstname">The firstname.</param>
        /// <param name="lastname">The lastname.</param>
        /// <param name="email">The email.</param>
        /// <param name="userType">Type of the user.</param>
        /// <param name="isActive">if set to <c>true</c> [is active].</param>
        public User(string username, string password,
            string firstname, string lastname, string email, TypeofUser userType, bool isActive)
            : this(username, password, firstname, lastname, email, 0, userType, isActive)
        { }

        /// <summary>
        /// Initializes a new instance of the <see cref="User"/> class.
        /// </summary>
        /// <param name="username">The username.</param>
        /// <param name="password">The password.</param>
        /// <param name="firstname">The firstname.</param>
        /// <param name="lastname">The lastname.</param>
        /// <param name="email">The email.</param>
        /// <param name="legacyid">The legacyid.</param>
        /// <param name="userType">Type of the user.</param>
        /// <param name="isActive">if set to <c>true</c> [is active].</param>
        public User(string username, string password,
            string firstname, string lastname, string email, int legacyid, TypeofUser userType, bool isActive)
        {
            this.email = email;

            this.FirstName = firstname;
            this.LastName = lastname;
            this.Password = password;
            this.userName = username;
            this.UserType = userType;
            this.IsActive = isActive;
            this.LegacyID = legacyid;
        }

        #endregion

        #region Methods

        private bool Validate()
        {
            validationMessages = new List<string>();

            bool isValid = true;

            if (string.IsNullOrEmpty(this.userName))
            {
                validationMessages.Add("Username is required");
                isValid = false;
            }

            if (this.UserType.ToString() == "0")
            {
                validationMessages.Add("UserType is required");
                isValid = false;
            }

            if (this.UserID == 0 && string.IsNullOrEmpty(this.Password.Trim()))
            {
                validationMessages.Add("Password is required for new user.");
                isValid = false;
            }
            if (!string.IsNullOrEmpty(this.Email) && !ValidationHelper.isEmailAddressValid(this.Email))
            {
                {
                    validationMessages.Add("Email is not in the proper format.");
                    isValid = false;
                }
            }

            return isValid;
        }

        /// <summary>
        /// Saves this instance.
        /// </summary>
        public void Save()
        {
            Save(0);
        }


        /// <summary>
        /// Saves the specified current user id.
        /// </summary>
        /// <param name="currentUserId">The ID of the User makeing the save.</param>
        public void Save(int currentUserId)
        {
            if (!this.Validate())
            {
                string exceptionMessage = string.Empty;

                foreach (string message in validationMessages)
                {
                    exceptionMessage += message + "|";
                }
                throw new SecurityException("Cannot Save: " + exceptionMessage);
            }

            if (this.UserID == 0)
            {
                // Save
                User savedUser = UserFactory.CreateUser(this.Username, this.Password, this.FirstName, this.LastName, this.Email, currentUserId, this.LegacyID, this.UserType, this.IsActive);
                this.UserID = savedUser.UserID;
            }
            else
            {
                // Insert
                UserFactory.UpdateUser(this.UserID, this.Username, this.Password, this.FirstName, this.LastName, this.Email, this.IsActive, this.UserType, currentUserId);
            }
        }

        /// <summary>
        /// Determines whether current User instance [is assigned to role].
        /// </summary>
        /// <param name="roleName">Name of the role.</param>
        /// <returns>
        /// 	<c>true</c> if user [is assigned to role] ; otherwise, <c>false</c>.
        /// </returns>
        public bool IsAssignedToRole(string roleName)
        {
            bool isAssigned = false;

            foreach (Role r in this.ListOfRoles)
            {
                if (r.RoleName.Equals(roleName, StringComparison.OrdinalIgnoreCase))
                {
                    isAssigned = true;
                    break;
                }
            }

            return isAssigned;
        }

        /// <summary>
        /// Determines whether current User instance [is assigned to role].
        /// </summary>
        /// <param name="role">The role.</param>
        /// <returns>
        /// 	<c>true</c> if user [is assigned to role] ; otherwise, <c>false</c>.
        /// </returns>
        public bool IsAssignedToRole(Role role)
        {
            return ListOfRoles.Exists(delegate(Role r) { return r.RoleName == role.RoleName; });
        }

        /// <summary>
        /// Determines whether User [is assigned to activity].
        /// </summary>
        /// <param name="activityName">Name of the activity.</param>
        /// <returns>
        /// 	<c>true</c> if User [is assigned to activity]; otherwise, <c>false</c>.
        /// </returns>
        public bool IsAssignedToActivity(string activityName)
        {
            return IsAssignedToActivity(activityName, null);
        }

        /// <summary>
        /// Determines whether User [is assigned to activity].
        /// </summary>
        /// <param name="activityName">Name of the activity.</param>
        /// <param name="applicationKey">The application key.</param>
        /// <returns>
        /// 	<c>true</c> if User [is assigned to activity]; otherwise, <c>false</c>.
        /// </returns>
        public bool IsAssignedToActivity(string activityName, string applicationKey)
        {
            bool isAssigned = false;
            foreach (Activity a in this.ListOfActivites)
            {
                if (a.ActivityDesc.Equals(activityName, StringComparison.OrdinalIgnoreCase))
                {
                    if (string.IsNullOrEmpty(applicationKey) || (a.AppKey.Equals(applicationKey, StringComparison.OrdinalIgnoreCase)))
                    {
                        isAssigned = true;
                        break;
                    }
                }
            }
            return isAssigned;
        }

        public Dictionary<string, bool> GetUserAssignedActivities(string applicationKey)
        {
            Dictionary<string, bool> returnValue = new Dictionary<string, bool>();
            foreach (Activity a in this.ListOfActivites)
            {
                bool isAssigned = false;
                if (string.IsNullOrEmpty(applicationKey) || (a.AppKey.Equals(applicationKey, StringComparison.OrdinalIgnoreCase)))
                {
                    isAssigned = true;
                }
                if (!returnValue.ContainsKey(a.ActivityDesc.ToLower()))
                {
                    returnValue.Add(a.ActivityDesc.ToLower(), isAssigned);
                }
            }
            return returnValue;
        }

        /// <summary>
        /// Determines whether User [is assigned to activity].
        /// </summary>
        /// <param name="activity">The activity.</param>
        /// <returns>
        /// 	<c>true</c> if User [is assigned to activity]; otherwise, <c>false</c>.
        /// </returns>
        public bool IsAssignedToActivity(Activity activity)
        {
            return IsAssignedToActivity(activity.ActivityDesc);
        }

        /// <summary>
        /// Determines whether User [is assigned to activity].
        /// </summary>
        /// <param name="activity">The activity.</param>
        /// <param name="applicationKey">The application key.</param>
        /// <returns>
        /// 	<c>true</c> if User [is assigned to activity]; otherwise, <c>false</c>.
        /// </returns>
        public bool IsAssignedToActivity(Activity activity, string applicationKey)
        {
            return IsAssignedToActivity(activity.ActivityDesc, applicationKey);
        }
        #endregion

        public override string ToString()
        {
            return this.DisplayName;
        }


    }
}

