using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    
    public static class PEUserSql
    {
        public static DataSet SelectAllUsers()
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEUsersSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }
    }
}
