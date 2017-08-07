using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService.DataAccess
{
    /// <summary>
    /// Retrieves application settings related to data access.
    /// </summary>
    interface IDataAccessSettings
    {
        /// <summary>
        /// Returns the Liberty Power's database connection string.
        /// If the connection string is not found, throws an exception.
        /// </summary>
        string GetLibertyPowerConnectionString();
    }

    sealed class DataAccessSettings : IDataAccessSettings
    {
        public string GetLibertyPowerConnectionString()
        {
            var connectionStringSetting = ConfigurationManager.ConnectionStrings["LibertyPower"];
            if (connectionStringSetting == null)
                throw new Exception("No connection string was found for the Liberty Power database. Please check the application's configuration file for a connection string under the key 'LibertyPower'.");

            return connectionStringSetting.ConnectionString;
        }
    }
}
