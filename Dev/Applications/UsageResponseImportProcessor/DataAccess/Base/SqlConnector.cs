using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace UsageResponseImportProcessor.DataAccess.Base
{
    public class SqlConnector : ISqlConnector
    {
        private ISqlSettings settings;

        public SqlConnector(ISqlSettings settings)
        {
            this.settings = settings;
        }

        public SqlConnection ConnectToLibertyPowerDatabase()
        {
            return new SqlConnection(settings.GetLibertyPowerDatabaseConnectionString());
        }
    }
}