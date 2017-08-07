using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace UsageResponseImportProcessor.DataAccess.Base
{
    public class SqlSettings : ISqlSettings
    {
        public string GetLibertyPowerDatabaseConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["LibertyPower"].ConnectionString;
        }
    }
}