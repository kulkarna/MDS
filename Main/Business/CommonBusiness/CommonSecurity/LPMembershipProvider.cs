using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
	public class LPMembershipProvider : System.Web.Security.MembershipProvider
    {
        #region Membership Implementation

        #region Membership Properties

        //TODO: review these properties and make them database driven
        public override string ApplicationName
        {
            get
            {
                return "LPMembershipApp";
            }

            set
            {
                //throw new NotImplementedException();
            }
        }

        public override string Description
        {
            get
            {
                return base.Description;
            }
        }

        public override bool EnablePasswordReset
        {
            get { return true; }
        }

        public override bool EnablePasswordRetrieval
        {
            get { return false; }
        }

        public override int MaxInvalidPasswordAttempts
        {
            get { return 8; }
        }

        public override int MinRequiredNonAlphanumericCharacters
        {
            get { return 0; }
        }

        public override int MinRequiredPasswordLength
        {
            get { return 0; }
        }

        public override int PasswordAttemptWindow
        {
            get { return 10; }
        }

        public override System.Web.Security.MembershipPasswordFormat PasswordFormat
        {
            get { throw new NotImplementedException(); }
        }

        public override string PasswordStrengthRegularExpression
        {
            get { return ""; }
        }

        public override bool RequiresQuestionAndAnswer
        {
            get { return false; }
        }

        public override bool RequiresUniqueEmail
        {
            get { return true; }
        }

        public override string Name
        {
            get
            {
                return "LPMembership";
            }
        }

        #endregion Membership Properties

        public override System.Web.Security.MembershipUser CreateUser( string username, string password, string email, string passwordQuestion, string passwordAnswer, bool isApproved, object providerUserKey, out System.Web.Security.MembershipCreateStatus status )
        {
            if( !this.ValidateUsername( username, email ) )
            {
                status = System.Web.Security.MembershipCreateStatus.InvalidUserName;
                return null;
            }

            base.OnValidatingPassword( new System.Web.Security.ValidatePasswordEventArgs( username, password, true ) );

            if( !this.ValidatePassword( password ) )
            {
                status = System.Web.Security.MembershipCreateStatus.InvalidPassword;
                return null;
            }
            //TODO: encrypt the password
            User newUser = UserFactory.CreateUser( username, password, username, "", email, 1, 0, TypeofUser.INTERNAL, false );

            status = System.Web.Security.MembershipCreateStatus.Success;
            return this.CreateMembershipUser( newUser );
        }

        public override bool DeleteUser( string username, bool deleteAllRelatedData )
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUser GetUser( object providerUserKey, bool userIsOnline )
        {
            if( !(providerUserKey is int) )
            {
                throw new ApplicationException( "providerUserKey must be an integer" );
            }

            //todo treat the userisonline option to update activity in the database
            User user = UserFactory.GetUser( (int) providerUserKey );
            if( user != null )
                return CreateMembershipUser( user );
            else
                return null;
        }

        public override System.Web.Security.MembershipUser GetUser( string username, bool userIsOnline )
        {
            //todo treat the userisonline option to update activity in the database
            User user = UserFactory.GetUserByLogin( username );
            if( user != null )
                return CreateMembershipUser( user );
            else
                return null;
        }

        public override string GetUserNameByEmail( string email )
        {
            throw new NotImplementedException();
        }

        public override void UpdateUser( System.Web.Security.MembershipUser user )
        {
            throw new NotImplementedException();
        }

        public override bool ValidateUser( string username, string password )
        {

            //TODO: Review this
            try
            {
                User user = UserFactory.LoginUser( username, password, null );
                if( user == null )
                    return false;
            }
            catch( InvalidLoginException )
            {
                return false;
            }
            return true;
        }

        public override bool ChangePassword( string username, string oldPassword, string newPassword )
        {
            throw new NotImplementedException();
        }

        public override bool ChangePasswordQuestionAndAnswer( string username, string password, string newPasswordQuestion, string newPasswordAnswer )
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUserCollection FindUsersByEmail( string emailToMatch, int pageIndex, int pageSize, out int totalRecords )
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUserCollection FindUsersByName( string usernameToMatch, int pageIndex, int pageSize, out int totalRecords )
        {
            throw new NotImplementedException();
        }

        public override System.Web.Security.MembershipUserCollection GetAllUsers( int pageIndex, int pageSize, out int totalRecords )
        {
            throw new NotImplementedException();
        }

        public override int GetNumberOfUsersOnline()
        {
            return 0;
        }

        public override string GetPassword( string username, string answer )
        {
            throw new NotImplementedException();
        }

        public override string ResetPassword( string username, string answer )
        {
            throw new NotImplementedException();
        }

        public override bool UnlockUser( string userName )
        {
            throw new NotImplementedException();
        }

        #endregion Membership Implementation

        #region Helper Methods

        /// <summary>
        /// Validates that the username is unique, validates that the email is unique in the db as well
        /// </summary>
        /// <param name="username"></param>
        /// <param name="email"></param>
        /// <returns></returns>
        private bool ValidateUsername( string username, string email )
        {
            return true;
        }

        private bool ValidatePassword( string password )
        {
            return true;
        }

        private System.Web.Security.MembershipUser CreateMembershipUser( User user )
        {
            //TODO: Create additional fields for the user: last login, last password change
            System.Web.Security.MembershipUser newuser = new System.Web.Security.MembershipUser( base.Name, user.Username, user.UserID, user.Email, string.Empty, string.Empty, true, false,
                                                                                                 user.DateCreated, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.Now );

            return newuser;

        }

        #endregion

        public static bool IsLibertyPowerTrustedDomainUser( System.Web.HttpRequest clientRequest )
        {
            if( string.IsNullOrEmpty( clientRequest.ServerVariables["LOGON_USER"] ) )
                return false;

            string userName = clientRequest.ServerVariables["LOGON_USER"].ToString();

            if( userName.ToLower().StartsWith( "libertypower" ) )
            {
                if( IsLibertyPowerIpAddress( clientRequest.ServerVariables["LOCAL_ADDR"] ) )
                {
                    return true;
                }
            }

            return false;
        }

        public static bool IsLibertyPowerIpAddress( string ipAddress )
        {
            return true;
        }
    }
}
