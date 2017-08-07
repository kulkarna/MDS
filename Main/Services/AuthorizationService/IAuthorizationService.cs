using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace AuthorizationService
{
    [ServiceContract]
    public interface IAuthorizationService
    { 
        [OperationContract]
        string GetData(int value);

        [OperationContract]
        bool AuthorizeUserActivity(string MessageId, string Username, string ActivityName);

        [OperationContract]
        Dictionary<string, bool> GetUserActivities(string messageId, string userName);
    }
}
