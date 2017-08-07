using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class AccountStatusCodeSql
    {

        /// <summary>
        /// Get list of Status Codes.
        /// By default, it will not retrieve inactive status or renewal status..
        /// </summary>
        /// <param name="includeInactive"></param>
        /// <param name="includeRenewal"></param>
        /// <returns></returns>
        public static DataSet GetAccountStatusCodeList(bool includeInactive = false, bool includeRenewal = false)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusCodeSelect";

                    command.Parameters.Add(new SqlParameter("@IncludeInactive", includeInactive));
                    command.Parameters.Add(new SqlParameter("@IncludeRenewal", includeRenewal));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }

            return ds;
        }

        /// <summary>
        /// Get a list of Account Status Codes by ID
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        public static DataSet GetAccountStatusCodeByID(int ID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusCodeByID";

                    command.Parameters.Add(new SqlParameter("@ID", ID));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }

            return ds;
        }

        /// <summary>
        /// Get Account Status Code by Status and Substatus
        /// </summary>
        /// <param name="status"></param>
        /// <param name="subStatus"></param>
        /// <returns></returns>
        public static DataSet GetAccountStatusCode(string status, string subStatus)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountStatusCodeByStatusSubStatus";

                    command.Parameters.Add(new SqlParameter("@Status", status));
                    command.Parameters.Add(new SqlParameter("@SubStatus", subStatus));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }

            return ds;
        }


    }
}
