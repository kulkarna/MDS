using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class AccountSqlLP
    {

        public static int UpdateCurrentEtfID(int accountID, int? currentEtfID)
        {
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_AccountCurrentEtfIDUpdate";

                    command.Parameters.Add(new SqlParameter("AccountID", accountID));
                    object helper = DBNull.Value;
                    if (currentEtfID.HasValue)
                    {
                        helper = currentEtfID;
                    }
                    command.Parameters.Add(new SqlParameter("CurrentEtfID", helper));

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            return accountID;
        }

        public static void UpdateEtfCorrespondence(int accountID, bool waiveEtf, int? waivedEtfReasonCodeID)
        {
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountEtfWaivedUpdate";
                    cmd.Parameters.Add(new SqlParameter("@AccountID", accountID));
                    cmd.Parameters.Add(new SqlParameter("@WaiveEtf", waiveEtf));
                    cmd.Parameters.Add(new SqlParameter("@WaivedEtfReasonCodeID", waivedEtfReasonCodeID));

                    cn.Open();
                    cmd.ExecuteScalar();
                }
            }
        }

        //Rafael Vasconcelos - Ticket 1-5350120
        //If enrollment type is "Do not Enroll" 
        public static bool CheckIfAccountIsDoNotEnroll(string accountNumber)
        {
            bool result = false;

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_CheckIfAccountIsDoNotEnroll";
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    cn.Open();
                    result = (bool)cmd.ExecuteScalar();
                }
            }

            return result;
        }

        public static DataSet GetDoNotEnrollAccounts()
        {
            DataSet result = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountSelectDoNotEnroll";

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(result);
                    }
                }
            }

            return result;
        }

        public static DataSet GetEnrollmentAccounts(string utilityCode, string processName)
        {
            DataSet result = new DataSet();
            try
            {

                using (SqlConnection cn = new SqlConnection(Helper.LpHistoryConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = cn;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_usage_acquire_accounts_sel";
                        cmd.Parameters.Add(new SqlParameter("p_utility_id", utilityCode));
                        cmd.Parameters.Add(new SqlParameter("p_process", processName));
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(result);
                        }
                    }
                }
            }
            catch (SqlException ex)
            {
                throw;
            }
            catch (Exception ex)
            {   
                throw;
            }

            return result;
        }

        public static DataSet GetCheckAuditUsageUsed(string accountNumber)
        {
            DataSet result = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_CheckAuditUsageUsed";
                    cmd.Parameters.Add(new SqlParameter("p_account_number", accountNumber));
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(result);
                    }
                }
            }

            return result;
        }
        /// <summary>
        /// Extracted from the AcquireUsage project (when the scraper fails)..
        /// </summary>
        /// <param name="contractNbr"></param>
        public static void RejectAccount(string contractNbr)
        {

            DataSet result = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.EnrollmentConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_check_account_approval_reject";
                    cmd.Parameters.Add(new SqlParameter("p_username", "USAGE ACQUIRE SCRAPER"));
                    cmd.Parameters.Add(new SqlParameter("p_contract_nbr", contractNbr));
                    cmd.Parameters.Add(new SqlParameter("p_account_number", " "));
                    cmd.Parameters.Add(new SqlParameter("p_check_type", "USAGE ACQUIRE"));
                    cmd.Parameters.Add(new SqlParameter("p_check_request_id", "ENROLLMENT"));
                    cmd.Parameters.Add(new SqlParameter("p_approval_status", "INCOMPLETE"));
                    cmd.Parameters.Add(new SqlParameter("p_comment", "New (no historical usage) or Invalid account"));
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(result);
                    }
                }
            }

        }
        public static void UpdateEnrollmentAccounts(string accountNumber)
        {
            DataSet result = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.LpAccountConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_account_usage_upd";
                    cmd.Parameters.Add(new SqlParameter("p_account_number", accountNumber));
                    cn.Open();
                    cmd.ExecuteScalar();
                }
            }


        }

        public static void InsertDoNotEnrollAccount(string userName, string accountNumber, string accountId, string accountName, DateTime requestedDate,
            DateTime expirationDate, string utilityId, string phoneNumber, string street, string city, string marketCode, string zip, string comments)
        {

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    SqlParameter[] parameters = new SqlParameter[] 
                        {
                         new SqlParameter("@UserName", userName),
                         new SqlParameter("@AccountID", accountId),
                         new SqlParameter("@AccNumber", accountNumber),
                         new SqlParameter("@AccName", accountName),
                         new SqlParameter("@RequestedDate", requestedDate),
                         new SqlParameter("@ExpirationDate", expirationDate),
                         new SqlParameter("@UtilityID", utilityId),
                         new SqlParameter("@Phone", phoneNumber),
                         new SqlParameter("@Street", street),
                         new SqlParameter("@City", city),
                         new SqlParameter("@State", marketCode),
                         new SqlParameter("@Zip", zip),
                         new SqlParameter("@Comment", comments)
                        };

                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountInsertAsDoNotEnroll";
                    cmd.Parameters.AddRange(parameters);
                    cn.Open();
                    cmd.ExecuteNonQuery();
                    cn.Close();
                }
            }
        }


        public static void UpdateDoNotEnrollAccount(string accountNumber, string userName,
            string accountName, int expirationDays, string phone, string address, string city, string state, string zip)
        {

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountUpdateAsDoNotEnroll";

                    SqlParameter[] parameters = new SqlParameter[] 
                        {
                         new SqlParameter("@UserName", userName),
                         new SqlParameter("@AccNumber", accountNumber),
                         new SqlParameter("@AccName", accountName),
                         new SqlParameter("@ExpirationDays", expirationDays),
                         new SqlParameter("@Phone", phone),
                         new SqlParameter("@Street", address),
                         new SqlParameter("@City", city),
                         new SqlParameter("@State", state),
                         new SqlParameter("@Zip", zip)                         
                        };

                    cmd.Parameters.AddRange(parameters);

                    cn.Open();
                    cmd.ExecuteNonQuery();
                    cn.Close();
                }
            }
        }

        public static void DeleteDoNotEnrollAccount(string accountNumber)
        {

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountDeleteDoNotEnroll";
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public static bool CheckIfAccountExists(int? accountId, string accountNumber)
        {
            bool result = false;

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_CheckAccountExists";
                    cmd.Parameters.Add(new SqlParameter("@AccountID", accountId));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    cn.Open();
                    result = (bool)cmd.ExecuteScalar();
                }
            }

            return result;
        }

        public static string GetNewAccountId(string userName)
        {
            string result = string.Empty;

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetNewAccountID";
                    cmd.Parameters.Add(new SqlParameter("@UserName", userName));

                    cn.Open();
                    result = (string)cmd.ExecuteScalar();
                }
            }

            return result;
        }

        /// <summary>
        /// Get the list of active accounts that are missing the Icap values
        /// </summary>
        /// <returns></returns>
        public static DataSet GetAccountsWithMissingIcap()
        {
            DataSet ds = new DataSet();
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_GetAccountsWithMissingIcap";
                    command.CommandTimeout = 60;

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Remove duplicate Icap/Tcap values
        /// </summary>
        /// <returns></returns>
        public static DataSet RemoveDuplicateValues(string sourceType)
        {
            DataSet ds = new DataSet();
            string storedProcedureName = string.Empty;

            switch (sourceType.ToUpper())
            {
                case "ICAP":
                    storedProcedureName = "usp_RemoveDuplicateIcap";
                    break;

                case "TCAP":
                    storedProcedureName = "usp_RemoveDuplicateTcap";
                    break;
            }

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storedProcedureName;
                    command.CommandTimeout = 0;

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Close Icap/Tcap end dates
        /// </summary>
        /// <returns></returns>
        public static DataSet EndPreviousValue(string sourceType)
        {
            DataSet ds = new DataSet();
            string storedProcedureName = string.Empty;

            switch (sourceType.ToUpper())
            {
                case "ICAP":
                    storedProcedureName = "usp_CloseIcapEndDates";
                    break;

                case "TCAP":
                    storedProcedureName = "usp_CloseTcapEndDates";
                    break;
            }
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storedProcedureName;
                    command.CommandTimeout = 0;

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        //Rafael Vasconcelos - End - Ticket 1-5350120

        //public static void UpdateOutgoingDeenrollmentRequestFlag( int accountID, bool isOutgoingDeenrollmentRequest )
        //{
        //    using ( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
        //    {
        //        using ( SqlCommand cmd = new SqlCommand() )
        //        {
        //            cmd.Connection = cn;
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.CommandText = "usp_AccountIsOutgoingDeenrollmentRequestUpdate";
        //            cmd.Parameters.Add( new SqlParameter( "@AccountID", accountID ) );
        //            cmd.Parameters.Add( new SqlParameter( "@IsOutgoingDeenrollmentRequest", isOutgoingDeenrollmentRequest ) );

        //            cn.Open();
        //            cmd.ExecuteScalar();
        //        }
        //    }
        //}

        /// <summary>
        /// get the AccountID from the table Account
        /// </summary>
        /// <param name="AccountNumber">AccountNumber</param>
        /// <param name="UtilityCode">UtilityCode</param>
        /// <returns></returns>
        public static Int32 GetAccountIdentifier(string AccountNumber, string UtilityCode)
        {
            int id;
            using (var cn = new SqlConnection(Helper.ConnectionString))
            {
                using (var cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountIdentifierSelect";
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", AccountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", UtilityCode));

                    cn.Open();
                    object accountObj = cmd.ExecuteScalar();
                    int.TryParse(accountObj.ToString(), out id);
                }
            }
            return id;
        }
    }

}
