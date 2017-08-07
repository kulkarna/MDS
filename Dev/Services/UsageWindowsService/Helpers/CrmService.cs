using System;
using System.Collections.Generic;
using System.Configuration;
using System.DirectoryServices.AccountManagement;
using System.Linq;
using System.Security.Authentication;
using System.Security.Principal;
using System.ServiceModel.Description;
using Common.Logging;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Discovery;
using Microsoft.Xrm.Sdk.Query;
using UsageEventAggregator.Helpers;
using UsageWebService.Repository;

namespace UsageWebService.Helpers
{
    public static class CrmService
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public const string URL = "CrmUrl";
        public const string USERNAME = "CrmUserName";
        public const string PASSWORD = "CrmPassword";
        public const string DOMAIN = "CrmDomainName";
        public const string ORG = "CrmOrgName";
        public const string DATA_REQUEST_ENTITY = "lpc_datarequest";
        public const string SERVICE_ACCOUNT_ENTITY = "lpc_serviceaccount";
        public const string SERVICE_ACCOUNT_KEY = "lpc_accountnumber";
        public const string SERVICE_ACCOUNT_ID_KEY = "lpc_serviceaccountid";
        public const string UTILITY_ENTITY = "lpc_utility";
        public const string UTILITY_KEY = "lpc_utility_id";
        public const string UTILITY_ID_KEY = "lpc_utilityid";
        public const string DATA_RESPONSE_KEY = "lpc_usageresponse";
        public const string DATA_PROCESSED_KEY = "lpc_dataprocessed";
        public const string FULFILMENT_MODE_KEY = "lpc_fulfillment_mode";
        public const string FULFILLMENT_TIMESTAMP_KEY = "lpc_fulfillment_date";
        public const string MESSAGE_KEY = "lpc_message";
        public const string IS_HIA_KEY = "lpc_hia";
        public const string REQUEST_TYPE_KEY = "lpc_request_type";
        public const string REQUEST_STATUS_KEY = "lpc_requeststatus";

        public const int DATA_RESPONSE_VALUE_REJECTED = 3;
        public const int DATA_RESPONSE_VALUE_ACCEPTED = 2;
        public const int REQUEST_STATUS_VALUE_PENDING = 1;
        public const int REQUEST_TYPE_VALUE_HU = 1;
        public const int REQUEST_TYPE_VALUE_IDR = 2;
        public const int DATA_PROCESSED_VALUE_PENDING = 1;
        public const int DATA_PROCESSED_VALUE_COMPLETE = 2;
        public const int DATA_PROCESSED_VALUE_FAILED = 3;

        private static AuthenticationCredentials _authenticationCredentials;
        private static IServiceManagement<IOrganizationService> _serviceManagement;

        public static bool JoinServiceAccountEntity(this QueryExpression query, string accountNumber, string utilityCode)
        {
            var repository = Locator.Current.GetInstance<IRepository>();
            var utilityId = repository.GetUtilityId(utilityCode);

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

            return ((OptionSetValue) o).Value;
     
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

            Log.Trace(string.Format("Setting option {0}.{1} = {2}", e.LogicalName, name, value));

            if (e.Contains(name))
                e[name] = new OptionSetValue(value);
            else e.Attributes.Add(name, new OptionSetValue(value));

        }

        public static void SetValue<T>(this Entity e, string name, T value)
        {
            Log.Trace(string.Format("Setting Value {0}.{1} = {2}", e.LogicalName, name, value));
            if (e.Contains(name))
                e[name] = value;
            else e.Attributes.Add(name, value);
        }


        public static OrganizationServiceProxy GetProxy()
        {
            var url = ConfigurationManager.AppSettings[URL];
            if (!string.IsNullOrEmpty(url) && (url.Contains("Discovery") || !string.IsNullOrWhiteSpace(ConfigurationManager.AppSettings["UseADFS"])))
                return GetProxyThroughADFS();
            return GetProxy(ConfigurationManager.AppSettings[URL]);
        }

        public static OrganizationServiceProxy GetProxy(string url)
        {
            var cred = new ClientCredentials();
            cred.Windows.ClientCredential = System.Net.CredentialCache.DefaultNetworkCredentials;
            var uri = new Uri(url);

            if(_serviceManagement == null)
            {
               _serviceManagement = ServiceConfigurationFactory.CreateManagement<IOrganizationService>(uri);
                _authenticationCredentials = _serviceManagement.Authenticate(new AuthenticationCredentials { ClientCredentials = cred});
                _authenticationCredentials.UserPrincipalName = UserPrincipal.Current.UserPrincipalName;
            }

            WindowsIdentity identity = null;
            if (Log.IsTraceEnabled)
            {
                identity = WindowsIdentity.GetCurrent();
                Log.Trace(string.Format("Creating proxy via AD for Identity: {0} UPN: {2} Url: {1}", identity != null ? identity.Name : "Identity Unknown", url, _authenticationCredentials.UserPrincipalName));
            }

            var proxy = new OrganizationServiceProxy(_serviceManagement, _authenticationCredentials.ClientCredentials);

            if (Log.IsTraceEnabled)
            {
                Log.Trace(string.Format("Proxy created via AD for Identity: {0} UPN: {2} Url: {1}", identity != null ? identity.Name : "Identity Unknown", url, _authenticationCredentials.UserPrincipalName));    
            }
            

            return proxy;

        }

        public static OrganizationServiceProxy GetProxyThroughADFS()
        {
            var address = ConfigurationManager.AppSettings[URL];
            if(string.IsNullOrWhiteSpace(address))
                throw new AuthenticationException("Address is blank");
            var orgName = ConfigurationManager.AppSettings[ORG];
            if(string.IsNullOrWhiteSpace(orgName))
                throw new AuthenticationException("Organization unique name is blank");

            IServiceManagement<IDiscoveryService> serviceManagement =
                    ServiceConfigurationFactory.CreateManagement<IDiscoveryService>(
                    new Uri(address));
            AuthenticationProviderType endpointType = serviceManagement.AuthenticationType;

            // Set the credentials.
            AuthenticationCredentials authCredentials = GetCredentials(endpointType);

            if (Log.IsTraceEnabled)
                Log.Trace(string.Format("Creating proxy via ADFS for Username: {0} Url: {1}", authCredentials.ClientCredentials.UserName.UserName , address));

            String organizationUri = String.Empty;
            // Get the discovery service proxy.
            using (DiscoveryServiceProxy discoveryProxy =
                GetProxy<IDiscoveryService, DiscoveryServiceProxy>(serviceManagement, authCredentials))
            {
                // Obtain organization information from the Discovery service. 
                if (discoveryProxy != null)
                {
                    // Obtain information about the organizations that the system user belongs to.
                    OrganizationDetailCollection orgs = DiscoverOrganizations(discoveryProxy);
                    // Obtains the Web address (Uri) of the target organization.
                    organizationUri = FindOrganization(orgName, orgs.ToArray()).Endpoints[EndpointType.OrganizationService];

                }
            }

            if (!String.IsNullOrWhiteSpace(organizationUri))
            {
                if (_serviceManagement == null)
                {
                    _serviceManagement =
                    ServiceConfigurationFactory.CreateManagement<IOrganizationService>(
                    new Uri(organizationUri));

                    // Set the credentials.
                    _authenticationCredentials = GetCredentials(endpointType);
                }

                if (Log.IsTraceEnabled)
                    Log.Trace(string.Format("Created proxy via ADFS for Username: {0} Url: {1}", authCredentials.ClientCredentials.UserName.UserName, address));

                // Get the organization service proxy.
                return GetProxy<IOrganizationService, OrganizationServiceProxy>(_serviceManagement, _authenticationCredentials);

            }

            Log.Error("Could not get org through discovery");
            return null;
        }

        /// <summary>
        /// Obtain the AuthenticationCredentials based on AuthenticationProviderType.
        /// </summary>
        /// <param name="endpointType">An AuthenticationProviderType of the CRM environment.</param>
        /// <returns>Get filled credentials.</returns>
        private static AuthenticationCredentials GetCredentials(AuthenticationProviderType endpointType)
        {
            var userName = ConfigurationManager.AppSettings[USERNAME];
            if (string.IsNullOrWhiteSpace(userName))
                throw new AuthenticationException("Username is blank");
            var password = ConfigurationManager.AppSettings[PASSWORD];
            if (string.IsNullOrWhiteSpace(password))
                throw new AuthenticationException("Password is blank");
            var domain = ConfigurationManager.AppSettings[DOMAIN];
            if (string.IsNullOrWhiteSpace(domain))
                throw new AuthenticationException("Domain name is blank");

            AuthenticationCredentials authCredentials = new AuthenticationCredentials();
            switch (endpointType)
            {
                case AuthenticationProviderType.ActiveDirectory:
                    authCredentials.ClientCredentials.Windows.ClientCredential =
                        new System.Net.NetworkCredential(userName, password, domain);
                    break;
                default: // For Federated and OnlineFederated environments.                    
                    authCredentials.ClientCredentials.UserName.UserName = userName;
                    authCredentials.ClientCredentials.UserName.Password = password;
                    // For OnlineFederated single-sign on, you could just use current UserPrincipalName instead of passing user name and password.
                    // authCredentials.UserPrincipalName = UserPrincipal.Current.UserPrincipalName;  //Windows/Kerberos
                    break;
            }

            return authCredentials;
        }

        /// <summary>
        /// Discovers the organizations that the calling user belongs to.
        /// </summary>
        /// <param name="service">A Discovery service proxy instance.</param>
        /// <returns>Array containing detailed information on each organization that 
        /// the user belongs to.</returns>
        public static OrganizationDetailCollection DiscoverOrganizations(
            IDiscoveryService service)
        {
            if (service == null) throw new ArgumentNullException("service");
            RetrieveOrganizationsRequest orgRequest = new RetrieveOrganizationsRequest();
            RetrieveOrganizationsResponse orgResponse =
                (RetrieveOrganizationsResponse)service.Execute(orgRequest);

            return orgResponse.Details;
        }

        /// <summary>
        /// Finds a specific organization detail in the array of organization details
        /// returned from the Discovery service.
        /// </summary>
        /// <param name="orgUniqueName">The unique name of the organization to find.</param>
        /// <param name="orgDetails">Array of organization detail object returned from the discovery service.</param>
        /// <returns>Organization details or null if the organization was not found.</returns>
        /// <seealso cref="DiscoveryOrganizations"/>
        public static OrganizationDetail FindOrganization(string orgUniqueName,
            OrganizationDetail[] orgDetails)
        {
            if (String.IsNullOrWhiteSpace(orgUniqueName))
                throw new ArgumentNullException("orgUniqueName");
            if (orgDetails == null)
                throw new ArgumentNullException("orgDetails");
            OrganizationDetail orgDetail = null;

            foreach (OrganizationDetail detail in orgDetails)
            {
                if (String.Compare(detail.UniqueName, orgUniqueName,
                    StringComparison.InvariantCultureIgnoreCase) == 0)
                {
                    orgDetail = detail;
                    break;
                }
            }
            return orgDetail;
        }

        /// <summary>
        /// Generic method to obtain discovery/organization service proxy instance.
        /// </summary>
        /// <typeparam name="TService">
        /// Set IDiscoveryService or IOrganizationService type to request respective service proxy instance.
        /// </typeparam>
        /// <typeparam name="TProxy">
        /// Set the return type to either DiscoveryServiceProxy or OrganizationServiceProxy type based on TService type.
        /// </typeparam>
        /// <param name="serviceManagement">An instance of IServiceManagement</param>
        /// <param name="authCredentials">The user's Microsoft Dynamics CRM logon credentials.</param>
        /// <returns></returns>
        private static TProxy GetProxy<TService, TProxy>(
            IServiceManagement<TService> serviceManagement,
            AuthenticationCredentials authCredentials)
            where TService : class
            where TProxy : ServiceProxy<TService>
        {
            Type classType = typeof(TProxy);

            if (serviceManagement.AuthenticationType !=
                AuthenticationProviderType.ActiveDirectory)
            {
                AuthenticationCredentials tokenCredentials =
                    serviceManagement.Authenticate(authCredentials);
                // Obtain discovery/organization service proxy for Federated, LiveId and OnlineFederated environments. 
                // Instantiate a new class of type using the 2 parameter constructor of type IServiceManagement and SecurityTokenResponse.
                return (TProxy)classType
                    .GetConstructor(new Type[] { typeof(IServiceManagement<TService>), typeof(SecurityTokenResponse) })
                    .Invoke(new object[] { serviceManagement, tokenCredentials.SecurityTokenResponse });
            }

            // Obtain discovery/organization service proxy for ActiveDirectory environment.
            // Instantiate a new class of type using the 2 parameter constructor of type IServiceManagement and ClientCredentials.
            return (TProxy)classType
                .GetConstructor(new Type[] { typeof(IServiceManagement<TService>), typeof(ClientCredentials) })
                .Invoke(new object[] { serviceManagement, authCredentials.ClientCredentials });
        }

    }
}