using System.Configuration;

namespace LibertyPower.RepositoryManagement.Common
{
    internal static class Configuration
    {
        /// <summary>
        /// Gets the name to use when writing to the event log.
        /// </summary>
        public static string CrmUrl
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("CrmUrl");
            }
        }

        public static string CrmUser
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("CrmUser");
            }
        }

        public static string CrmPassword
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("CrmPassword");
            }
        }

        /// <summary>
        /// Gets the name to use when writing to the event log.
        /// </summary>
        public static string EventSourceName
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("EventSourceName");
            }
        }

        /// <summary>
        /// Specifies log name such as Application, System, Security.
        /// </summary>
        public static string EventLogName
        {
            get
            {
                return ConfigurationManager.AppSettings.Get("EventLogName");
            }
        }

        /// <summary>
        /// If true loads repository types that only mimick the behavior of application's data stores 
        /// </summary>
        public static bool BindToNullRepositories
        {
            get
            {
                return bool.Parse(ConfigurationManager.AppSettings.Get("LoadNullRepositories"));
            }
        }

        public static int CacheUtilitiesRequiredAccountFieldsTimeOutMinutes
        {
            get { return int.Parse(ConfigurationManager.AppSettings.Get("CacheUtilitiesRequiredAccountFieldsTimeOutMinutes")); }
        }
    }
}