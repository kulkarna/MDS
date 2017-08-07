using System;
using System.DirectoryServices.AccountManagement;
using System.ServiceModel.Description;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using System.Net;

namespace LibertyPower.RepositoryManagement.Web.Crm
{
    public static class Crm
    {
        public const string MESSAGE_KEY = "lpc_message";
        public const string REQUEST_STATUS_KEY = "lpc_requeststatus";
        public const string USAGE_RESPONSE_KEY = "lpc_usageresponse";
        public const string DATA_PROCESSED_KEY = "lpc_dataprocessed";
        public const string FULFILLMENT_TIMESTAMP_KEY = "lpc_fulfillment_date";
        public const string IS_HIA_KEY = "lpc_hia";
        public const string FULFILMENT_MODE_KEY = "lpc_fulfillment_mode";
        public const string REQUEST_TYPE_KEY = "lpc_request_type";

        public const string NAME = "lpc_name";
        public const string TRANSACTION_ID = "lpc_transactionid";
        public const string REQUEST_MODE = "lpc_request_mode";

        public const string DATA_REQUEST_ENTITY = "lpc_datarequest";
        public const string SERVICE_ACCOUNT_ENTITY = "lpc_serviceaccount";
        public const string SERVICE_ACCOUNT_KEY = "lpc_accountnumber";
        public const string SERVICE_ACCOUNT_ID_KEY = "lpc_serviceaccountid";
        public const string UTILITY_ENTITY = "lpc_utility";
        public const string UTILITY_KEY = "lpc_utility_id";//int
        public const string UTILITY_ID_KEY = "lpc_utilityid";//guid

        public const int USAGE_RESPONSE_VALUE_REJECTED = 3;
        public const int USAGE_RESPONSE_VALUE_ACCEPTED = 2;
        public const int REQUEST_STATUS_VALUE_PENDING = 1;
        public const int REQUEST_TYPE_VALUE_HU = 1;
        public const int REQUEST_TYPE_VALUE_IDR = 2;
        public const int REQUEST_TYPE_VALUE_AI = 3;

        public const int DATA_PROCESSED_VALUE_PENDING = 1;
        public const int DATA_PROCESSED_VALUE_COMPLETE = 2;
        public const int DATA_PROCESSED_VALUE_FAILED = 3;

        private static AuthenticationCredentials authenticationCredentials;
        private static IServiceManagement<IOrganizationService> serviceManagement;

        public static bool JoinServiceAccountEntity(this QueryExpression query, string accountNumber, int utilityId)
        {
            var serviceAccountEntityLink = query.AddLink(SERVICE_ACCOUNT_ENTITY, SERVICE_ACCOUNT_ID_KEY, SERVICE_ACCOUNT_ID_KEY, JoinOperator.Inner);
            serviceAccountEntityLink.LinkCriteria.AddCondition(SERVICE_ACCOUNT_KEY, ConditionOperator.Equal, accountNumber);

            var utilityEntityLink = serviceAccountEntityLink.AddLink(UTILITY_ENTITY, UTILITY_ID_KEY, UTILITY_ID_KEY, JoinOperator.Inner);
            utilityEntityLink.LinkCriteria.AddCondition(UTILITY_KEY, ConditionOperator.Equal, utilityId);

            return true;
        }

        public static int OptionValue(this Entity e, string name)
        {
            object o;
            if (!e.Attributes.TryGetValue(name, out o))
                return 0;

            return ((OptionSetValue)o).Value;
        }

        public static string Value(this Entity e, string name)
        {
            object o;
            if (!e.Attributes.TryGetValue(name, out o))
                return null;

            return Convert.ToString(o);
        }

        public static void SetOption(this Entity e, string name, int value)
        {
            if (e.Contains(name))
                e[name] = new OptionSetValue(value);
            else
                e.Attributes.Add(name, new OptionSetValue(value));
        }

        public static void SetValue<T>(this Entity e, string name, T value)
        {
            if (e.Contains(name))
                e[name] = value;
            else
                e.Attributes.Add(name, value);
        }

        public static OrganizationServiceProxy GetProxy()
        {
            return GetProxy(Configuration.CrmUrl);
        }

        public static OrganizationServiceProxy GetProxy(string url)
        {
            var cred = new ClientCredentials();
            cred.Windows.ClientCredential = CredentialCache.DefaultNetworkCredentials;
            var uri = new Uri(url);

            if (serviceManagement == null)
            {
                serviceManagement = ServiceConfigurationFactory.CreateManagement<IOrganizationService>(uri);
                authenticationCredentials = serviceManagement.Authenticate(new AuthenticationCredentials { ClientCredentials = cred });
                authenticationCredentials.UserPrincipalName = UserPrincipal.Current.UserPrincipalName;
            }

            return new OrganizationServiceProxy(serviceManagement, authenticationCredentials.ClientCredentials);
        }
    }
}