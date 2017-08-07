using System.Configuration;

namespace LibertyPower.RepositoryManagement.Web
{
    public static class Connections
    {
        public static string RepositoryManagement
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["RepositoryManagementDb"].ConnectionString;
            }
        }

        public static string LibertyPower
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["LibertyPowerDb"].ConnectionString;
            }
        }
    }
}