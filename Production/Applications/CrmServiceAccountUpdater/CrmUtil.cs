using System;
using System.Configuration;
using System.ServiceModel.Description;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;

namespace CrmServiceAccountUpdater
{
    public static class CrmUtil
    {
        public static bool IsADFS { get { return (ConfigurationManager.AppSettings["ADFS"] == "1") ? true : false; } }
        public static bool IsSSL { get { return (ConfigurationManager.AppSettings["SSL"] == "1") ? true : false; } }
        public static string Server { get { return ConfigurationManager.AppSettings["Server"]; } }
        public static string OrgName { get { return ConfigurationManager.AppSettings["OrgName"]; } }
        public static string Domain { get { return ConfigurationManager.AppSettings["Domain"]; } }
        public static string User { get { return ConfigurationManager.AppSettings["User"]; } }
        public static string Pwd { get { return ConfigurationManager.AppSettings["Pwd"]; } }
        private static string URL_ORG_SERVICE = "/XrmServices/2011/organization.svc";

        public static OrganizationServiceProxy GetProxy()
        {
            ClientCredentials cred = GetUserCredentialsDefault();

            string sUrl = GetCrmOrgUrlOnPremise(IsSSL, Server, OrgName);
            return GetOrgProxyOnPremise(sUrl, cred);

        }


        public static string GetCrmOrgUrlOnPremise(bool IsSecure, string sServerName, string sOrgName)
        {
            string sUrl = (IsSecure) ? "https://" : "http://";
            sUrl += sServerName;

            if (!sUrl.EndsWith("/"))
                sUrl += "/";

            return sUrl + sOrgName.Trim() + URL_ORG_SERVICE;//"/XRMServices/2011/Organization.svc";
        }

        static public OrganizationServiceProxy GetOrgProxyOnPremise(string url, ClientCredentials cred)
        {
            var orgUri = new Uri(url);

            Microsoft.Xrm.Sdk.Client.IServiceManagement<IOrganizationService> OrgSvceMgmt =
                ServiceConfigurationFactory.CreateManagement<IOrganizationService>(orgUri);

            return new OrganizationServiceProxy(OrgSvceMgmt, cred);
        }

        public static ClientCredentials GetUserCredentialsDefault()
        {
            ClientCredentials cred = new ClientCredentials();

            cred.Windows.ClientCredential = System.Net.CredentialCache.DefaultNetworkCredentials;

            return cred;
        }

        public static void SetCrmDate(Entity e, string AttribName, DateTime dtValue)
        {
            if (dtValue != DateTime.MinValue)
                SetAttribute(e, AttribName, dtValue);
        }

        public static void SetAttribute(Entity e, string KeyName, object KeyValue)
        {
            if (e.Attributes.Contains(KeyName))
                e[KeyName] = KeyValue;
            else
                e.Attributes.Add(KeyName, KeyValue);
        }
    }
}