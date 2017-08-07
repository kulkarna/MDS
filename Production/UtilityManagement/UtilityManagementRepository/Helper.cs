using System;
using System.Configuration;


namespace UtilityManagementRepository
{
    internal sealed class Helper
    {
        /// <summary>
        /// Returns the DataSync ConnectionString
        /// </summary>
        public static string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["DataSync"].ConnectionString; }
        }
    }
}
