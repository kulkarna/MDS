using System.Configuration;

namespace LibertyPower.DataAccess.ConfigAccess.SqlSecurityConfig
{
    public class ServerElement : ConfigurationElement
    {
        public ServerElement() { }

        public ServerElement(string name, string connectionString)
        {
            this.ConnectionString = connectionString;
            this.Name = name;
        }

        [ConfigurationProperty("name", IsRequired = true)]
        public string Name
        {
            get { return (string)this["name"]; }
            set { this["name"] = value; }
        }

        [ConfigurationProperty("connectionString", IsRequired = false, DefaultValue = "*")]
        public string ConnectionString
        {
            get
            {
                string conn = (string)this["connectionString"];
                if (conn == "*" || conn == "")
                    conn = ConfigurationManager.ConnectionStrings[Name].ConnectionString;
                return conn;
            }
            set { this["connectionString"] = value; }
        }
    }
}
