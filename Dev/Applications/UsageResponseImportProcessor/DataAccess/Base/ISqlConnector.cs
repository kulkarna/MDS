using System;
using System.Data.SqlClient;

namespace UsageResponseImportProcessor.DataAccess.Base
{
    public interface ISqlConnector
    {
        SqlConnection ConnectToLibertyPowerDatabase();
    }
}