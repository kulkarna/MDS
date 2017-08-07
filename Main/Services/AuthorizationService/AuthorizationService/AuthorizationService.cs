using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using LibertyPower.Business.CommonBusiness.SecurityManager;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;

namespace AuthorizationService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in both code and config file together.
    public class AuthorizationService : IAuthorizationService
    {

        #region private variables and constants
        private const string CLASS = "AuthorizationService";
        #endregion

        public string GetData(int value) 
        {
            return string.Format("You entered: {0}", value);
        }

        public Dictionary<string, bool> GetUserActivities(string messageId, string userName)
        {
            string method = string.Format("GetUserActivities(string messageId,string userName:{0})", Common.NullSafeString(userName));
            ILogger logger = UnityLoggerGenerator.GenerateLogger();
            Dictionary<string, bool> returnValue = new Dictionary<string, bool>();
            try
            {
                logger.LogInfo(Common.NullSafeString(messageId), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                User CurrentUser = UserFactory.GetUserByLogin(userName);
                returnValue = CurrentUser.GetUserAssignedActivities(null);

                logger.LogInfo(Common.NullSafeString(messageId), string.Format("{0}.{1}.{2} return returnValue:{3} {4}", Common.NAMESPACE, CLASS, method, returnValue, Common.END));
                return returnValue;
            }
            catch (Exception exc)
            {
                StringBuilder innerExceptions = new StringBuilder();
                Exception innerException = new Exception();
                innerException = exc.InnerException;
                while (innerException != null)
                {
                    innerExceptions.AppendFormat("InnerException:{0};", innerException.Message);
                    innerException = innerException.InnerException;
                }
                string stackTrace = exc.StackTrace ?? "Null Stack Trace";
                logger.LogError(Common.NullSafeString(messageId), string.Format("{0}.{1}.{2}  {3} {4} {5}", Common.NAMESPACE, CLASS, method, exc.Message, innerExceptions.ToString(), stackTrace), exc);
                logger.LogInfo(Common.NullSafeString(messageId), string.Format("{0}.{1}.{2}  {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return new Dictionary<string,bool>();
            }
        }

        public bool AuthorizeUserActivity(string MessageId, string Username, string ActivityName)
        {
            string method = string.Format("AuthorizeUserActivity(MessageId,Username:{0},ActivityName:{1})", Common.NullSafeString(Username), Common.NullSafeString(ActivityName));
            ILogger logger = UnityLoggerGenerator.GenerateLogger(); 
            try
            {
                logger.LogInfo(Common.NullSafeString(MessageId), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                bool isUserAssignedToActivity = false;

                User CurrentUser = UserFactory.GetUserByLogin(Username);
                isUserAssignedToActivity = CurrentUser.IsAssignedToActivity(ActivityName);

                logger.LogInfo(Common.NullSafeString(MessageId), string.Format("{0}.{1}.{2} return isUserAssignedToActivity:{3} {4}", Common.NAMESPACE, CLASS, method, isUserAssignedToActivity, Common.END));
                return isUserAssignedToActivity;
            }
            catch (Exception exc)
            {
                StringBuilder innerExceptions = new StringBuilder();
                Exception innerException = new Exception();
                innerException = exc.InnerException;
                while (innerException != null)
                {
                    innerExceptions.AppendFormat("InnerException:{0};", innerException.Message);
                    innerException = innerException.InnerException;
                }
                string stackTrace = exc.StackTrace ?? "Null Stack Trace";
                logger.LogError(Common.NullSafeString(MessageId), string.Format("{0}.{1}.{2}  {3} {4} {5}", Common.NAMESPACE, CLASS, method, exc.Message, innerExceptions.ToString(), stackTrace), exc);
                logger.LogInfo(Common.NullSafeString(MessageId), string.Format("{0}.{1}.{2}  {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return false;
            }
        }
    }
}
