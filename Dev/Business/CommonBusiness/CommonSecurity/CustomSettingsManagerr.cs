using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;


namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    public class CustomSettingsManager : ConfigurationSection
    {
        /// <summary>
        /// Retrieve all configuration data values in the config file called OMSConfig.config.
        /// return the values in an object with properties. No constructor needed.
        /// </summary>
        private static CustomSettingsManager settings = ConfigurationManager.GetSection("SecurityManager") as CustomSettingsManager;

        public static CustomSettingsManager Settings
        {
            get { return settings; }
        }

        #region Config Properties
       
        
        /// <summary>
        /// /// domain for Active directory methods
        /// </summary>
        [ConfigurationProperty("ADDomain", DefaultValue = "ADDomain_NOT_SET", IsRequired = true)]
        public string ADDomain
        {
            get
            {
                return (String)this["ADDomain"];
            }
            set
            {
                this["ADDomain"] = value;
            }
        }

        /// <summary>
        /// /// LdapServer
        /// </summary>
        [ConfigurationProperty("LdapServer", DefaultValue = "LdapServer_NOT_SET", IsRequired = true)]
        public string LdapServer
        {
            get
            {
                return (String)this["LdapServer"];
            }
            set
            {
                this["LdapServer"] = value;
            }
        }
        
       

        #endregion
    }
}
