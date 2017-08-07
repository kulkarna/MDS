using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class ACMTAccountSql
    {


        /// <summary>
        /// Get Account and Status Code by Account Number and Utility Code
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityCode"></param>
        /// <returns></returns>
        public static DataSet GetAccountWithStatusCode(string accountNumber, string utilityCode)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountWithStatusCodeSelect";

                    command.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    command.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }

            return ds;
        }

        /// <summary>
        /// Get a list of Accounts and Status Code by Contract number
        /// </summary>
        /// <param name="contractNumber"></param>
        /// <returns></returns>
        public static DataSet GetAccountListWithStatusCode(string contractNumber)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountWithStatusCodeSelectByContract";

                    command.Parameters.Add(new SqlParameter("@ContractNumber", contractNumber));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }

            return ds;
        }

        /// <summary>
        /// Update Account Service Start Date using accountIdLegacy and startDate
        /// </summary>
        /// <param name="accountIdLegacy"></param>
        /// <param name="startDate"></param>
        public static void UpdateAccountServiceStart(string accountIdLegacy, DateTime startDate)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountServiceUpdate";

                    command.Parameters.Add(new SqlParameter("@AccountIDLegacy", accountIdLegacy));
                    command.Parameters.Add(new SqlParameter("@ServiceStartDate", startDate));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Update Account Service End Date using accountIdLegacy and endDate
        /// </summary>
        /// <param name="accountIdLegacy"></param>
        /// <param name="endDate"></param>
        public static void UpdateAccountServiceEnd(string accountIdLegacy, DateTime? endDate)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountServiceUpdate";

                    command.Parameters.Add(new SqlParameter("@AccountIDLegacy", accountIdLegacy));
                    command.Parameters.Add(new SqlParameter("@ServiceEndDate", endDate));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Create new Account Service Start Date by accountIdLegacy and startDate
        /// </summary>
        /// <param name="accountIdLegacy"></param>
        /// <param name="startDate"></param>
        public static void InsertAccountServiceStart(string accountIdLegacy, DateTime startDate)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountServiceUpdate";

                    command.Parameters.Add(new SqlParameter("@AccountIDLegacy", accountIdLegacy));
                    command.Parameters.Add(new SqlParameter("@ServiceStartDate", startDate));
                    command.Parameters.Add(new SqlParameter("@Insert", true));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        public static bool HasPendingEDITransaction(string accountIdLegacy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountPendingEDITransactionSelect";

                    command.Parameters.Add(new SqlParameter("@AccountIDLegacy", accountIdLegacy));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }
            return (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0);
        }

        public static bool NotApprovedInDealScreening(string accountIdLegacy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountNotApprovedInDealScreeningSelect";

                    command.Parameters.Add(new SqlParameter("@AccountIDLegacy", accountIdLegacy));

                    SqlDataAdapter da = new SqlDataAdapter(command);

                    da.Fill(ds);
                }
            }
            return (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0);
        }


    }
}
