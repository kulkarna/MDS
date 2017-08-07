using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEMailingListSql
    {
     
        /// <summary>
        /// Get all emails from Mailing List.
        /// </summary>
        /// <returns></returns>
        public static DataSet GetAllEmailsFromMailingList()
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMailingListSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }

        /// <summary>
        /// Inserts an email into the Mailing List.
        /// </summary>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <param name="email"></param>
        /// <returns>ID of email added.</returns>
        public static int InsertMailingList(string firstName, string lastName, string email )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEMailingListInsert";

                    cmd.Parameters.Add( new SqlParameter( "@FirstName", firstName ) );
                    cmd.Parameters.Add( new SqlParameter( "@LastName", lastName ) );
                    cmd.Parameters.Add( new SqlParameter( "@Email", email ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

