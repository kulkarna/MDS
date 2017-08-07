using System.Configuration;

namespace LibertyPower.DataAccess.ConfigAccess.SqlSecurityConfig
{
    public class ServerSettingsManager : ConfigurationSection
    {

        public static ServerCollection ManagedServers
        {
            get { return ((ServerSettingsManager)ConfigurationManager.GetSection("managedServers")).Servers; }
        }

        [ConfigurationProperty("servers", IsDefaultCollection = false),
         ConfigurationCollection(typeof(ServerCollection), AddItemName = "addServer", ClearItemsName = "clearServers", RemoveItemName = "removeServer")]
        public ServerCollection Servers
        {
            get { return this["servers"] as ServerCollection; }
        }
    }

}