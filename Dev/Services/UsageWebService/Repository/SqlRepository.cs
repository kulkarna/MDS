using System;
using System.ComponentModel.Composition;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Common.Logging;
using UsageWebService.Entities;

namespace UsageWebService.Repository
{
    [Export(typeof(IRepository))]
    public class SqlRepository : IRepository
    {
        private string _connectionStringLpTransactions;
        private string _connectionStringLpCommon;
        private string _connectionStringSQL9;
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public SqlRepository()
        {
            _verifyConfiguration();
        }

        private void _verifyConfiguration()
        {
            var configValuesLpTransactions = ConfigurationManager.AppSettings.GetValues("ConnectionStringNameLpTransactions");
            if (configValuesLpTransactions == null)
            {
                var ex = new ConfigurationErrorsException("Connection string name not found in app settings key of ConnectionStringNameLpTransactions");
                Log.Error(ex.Message, ex);
                throw ex;
            }

            _connectionStringLpTransactions = ConfigurationManager.ConnectionStrings[configValuesLpTransactions[0]].ConnectionString;
            if (string.IsNullOrWhiteSpace(_connectionStringLpTransactions))
            {
                var ex = new ConfigurationErrorsException("Connection string not found with name of " + configValuesLpTransactions[0]);
                Log.Error(ex.Message, ex);
                throw ex;
            }

            var configValuesLpCommons = ConfigurationManager.AppSettings.GetValues("ConnectionStringNameLpCommons");
            if (configValuesLpCommons == null)
            {
                var ex = new ConfigurationErrorsException("Connection string name not found in app settings key of ConnectionStringNameLpCommons");
                Log.Error(ex.Message, ex);
                throw ex;
            }

            _connectionStringLpCommon = ConfigurationManager.ConnectionStrings[configValuesLpCommons[0]].ConnectionString;
            if (string.IsNullOrWhiteSpace(_connectionStringLpCommon))
            {
                var ex = new ConfigurationErrorsException("Connection string not found with name of " + configValuesLpCommons[0]);
                Log.Error(ex.Message, ex);
                throw ex;
            }

            if (ConfigurationManager.ConnectionStrings["SQL9"] == null)
            {
                var ex = new ConfigurationErrorsException("Connection string not found with name of SQL9");
                Log.Error(ex.Message, ex);
                throw ex;
            }
            _connectionStringSQL9 = ConfigurationManager.ConnectionStrings["SQL9"].ConnectionString;

        }

        public long CreateTransaction(string accountNumber, string utilityCode, string source)
        {
            long transactionId;

            using (var con = new SqlConnection(_connectionStringLpTransactions))
            {
                using (var cmd = new SqlCommand("usp_UsageEvents_StartTransaction", con))
                {
                    cmd.Parameters.Add(new SqlParameter
                        {
                            ParameterName = "TransactionId",
                            SqlDbType = SqlDbType.BigInt,
                            Direction = ParameterDirection.Output
                        });
                    cmd.Parameters.Add(new SqlParameter("AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("Source", source));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                    if (!long.TryParse(cmd.Parameters["TransactionId"].Value.ToString(), out transactionId))
                        Log.Error("Invalid transaction number returned from procedure");
                }
            }

            return transactionId;
        }

        public long GetTransactionId(string accountNumber, string utilityCode)
        {
            using (var con = new SqlConnection(_connectionStringLpTransactions))
            {
                using (var cmd = new SqlCommand("usp_UsageEvents_GetTransactionId", con))
                {
                    cmd.Parameters.Add(new SqlParameter("AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("UtilityCode", utilityCode));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        if (reader.Read())
                            return reader.GetInt64(0);
                    }
                }
            }

            return 0;
        }

        public UsageTransaction GetTransaction(long transactionId)
        {
            using (var con = new SqlConnection(_connectionStringLpTransactions))
            {
                using (var cmd = new SqlCommand("usp_UsageEvents_GetTransactionById", con))
                {
                    cmd.Parameters.Add(new SqlParameter("TransactionId", transactionId));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        if (reader.Read())
                            return new UsageTransaction
                                {
                                    Id = reader.GetInt64(0),
                                    TimeStamp = reader.GetDateTime(1),
                                    AccountNumber = reader.GetString(2),
                                    UtilityCode = reader.GetString(3),
                                    IsComplete = reader.GetBoolean(4),
                                    Error = reader.GetString(5)
                                };
                    }
                }
            }

            return null;
        }

        public AccountStatusMessageType GetAccountStatusMessageType(string message)
        {
            using (var con = new SqlConnection(_connectionStringLpTransactions))
            {
                using (var cmd = new SqlCommand("usp_UsageEvents_GetAccountStatusMessageType", con))
                {
                    cmd.Parameters.Add(new SqlParameter("Message", message));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        //select IsRejection, IsAcceptanceInformational, IsAcceptance, IsAcceptanceIdrAvailable, Description
                        if (reader.Read())
                            return new AccountStatusMessageType
                            {
                                Message = message,
                                IsRejection = !reader.IsDBNull(0) && reader.GetBoolean(0),
                                IsAcceptanceInformational = !reader.IsDBNull(1) && reader.GetBoolean(1),
                                IsAcceptance = !reader.IsDBNull(2) && reader.GetBoolean(2),
                                IsAcceptanceIdrAvailable = !reader.IsDBNull(3) && reader.GetBoolean(3),
                                Description = reader.IsDBNull(4) ? string.Empty : reader.GetString(4)
                            };
                    }
                }
            }

            return null;
        }

        public string GetUtilityCode(int utilityId)
        {
            using (var con = new SqlConnection(_connectionStringLpTransactions))
            {
                using (var cmd = new SqlCommand("usp_GetUtilityCodeById", con))
                {
                    cmd.Parameters.Add(new SqlParameter("UtilityId", utilityId));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        if (reader.Read())
                            return reader.GetString(0);
                    }
                }
            }

            return null;
        }

        public int GetUtilityId(string utilityCode)
        {
            using (var con = new SqlConnection(_connectionStringLpTransactions))
            {
                using (var cmd = new SqlCommand("usp_GetUtilityIdByCode", con))
                {
                    cmd.Parameters.Add(new SqlParameter("UtilityCode", utilityCode));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        if (reader.Read())
                            return reader.GetInt32(0);
                    }
                }
            }

            Log.Fatal("Could not get utility id from code: " + utilityCode);

            return 0;
        }

        public void SetTransactionAsComplete(long transactionId)
        {
            SetTransactionAsComplete(transactionId, null);
        }

        public void SetTransactionAsComplete(long transactionId, string error)
        {
            try
            {
                using (var con = new SqlConnection(_connectionStringLpTransactions))
                {
                    using (var cmd = new SqlCommand("usp_UsageEvents_SetTransactionAsComplete", con))
                    {
                        cmd.Parameters.Add(new SqlParameter("TransactionId", transactionId));
                        cmd.Parameters.Add(string.IsNullOrWhiteSpace(error) ? new SqlParameter("Error", DBNull.Value) : new SqlParameter("Error", error));
                        cmd.CommandType = CommandType.StoredProcedure;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(string.Format("Could not set transaction as complete with id of {0}. Message was {1}", transactionId, ex.Message), ex);
            }

        }

        public string GetLpcDunsNumber(string utilityCode)
        {
            try
            {
                using (var con = new SqlConnection(_connectionStringLpCommon))
                {
                    //Todo: Make this a proc!
                    var sqlStatement =
                        string.Format(@"SELECT CASE WHEN '{0}' = 'DELDE' THEN e.duns_number + 'P' ELSE e.duns_number END
                            FROM	lp_common..common_utility u WITH (NOLOCK) 
		                            INNER JOIN lp_common..common_entity e WITH (NOLOCK) ON u.entity_id = e.entity_id
                            WHERE	u.utility_id = '{0}'", utilityCode);
                    using (var cmd = new SqlCommand(sqlStatement, con))
                    {
                        cmd.CommandType = CommandType.Text;
                        con.Open();
                        using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                        {
                            if (reader.Read())
                                return reader.GetString(0);
                        }
                    }
                }


            }
            catch (Exception ex)
            {
                Log.Error(string.Format("Could not get utility lpc duns number for {0}. Message was {1}", utilityCode, ex.Message), ex);
            }

            return string.Empty;
        }

        public string GetIdrUsageDate(string accountNumber, string utilitycd)
        {

            DateTime beginTime = DateTime.Now;
            string lsIdrDate = DateTime.MinValue.ToString();
            try
            {
                DataSet dataSet = new DataSet();
                LogManager.GetCurrentClassLogger().Debug(string.Format("GetIdrUsageDate Request DB call BEGIN: Utility: {0} account: {1}", utilitycd, accountNumber));
                ////Connect and Query the data using StoreProcedure
                if (string.IsNullOrWhiteSpace(accountNumber) || string.IsNullOrWhiteSpace(utilitycd))
                {
                    LogManager.GetCurrentClassLogger().Debug(string.Format("GetIdrUsageDate Invalid AccountNumber or Utility Code: Utility: {0} account: {1}", utilitycd, accountNumber));
                    return DateTime.MinValue.ToString(); ;
                }
                using (SqlConnection conn = new SqlConnection(_connectionStringLpTransactions))
                {
                    LogManager.GetCurrentClassLogger().Debug(string.Format("GetIdrUsageDate DBConnection: Utility: {0} account: {1}", utilitycd, accountNumber));
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_GetIdrUsageDate";
                        cmd.Connection = conn;
                        cmd.Parameters.Add(new SqlParameter("@p_AccountNumber", accountNumber));
                        cmd.Parameters.Add(new SqlParameter("@p_UtilityCode", utilitycd));
                        conn.Open();

                        using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd))
                        {
                            sqlDataAdapter.Fill(dataSet);
                        }
                        if ((dataSet != null) && (dataSet.Tables != null) && (dataSet.Tables.Count > 0) && (dataSet.Tables[0].Rows != null))
                        {
                            //Check the data existance
                            if (dataSet.Tables[0].Rows.Count > 0)
                            {
                                lsIdrDate = Convert.ToString(dataSet.Tables[0].Rows[0][0]);
                            }
                        }
                        ///Check whether   the  value  returned is a  Good---If no date found or and error occured,  the SP  return '50000'
                        if (lsIdrDate != "50000")
                        {
                            LogManager.GetCurrentClassLogger().Debug(string.Format(" GetIdrUsageDate Request DB call END: utility: {0} account: {1} IdrUsageDate: {2} Method Duration ms:{3} ", utilitycd, accountNumber, lsIdrDate, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                            return lsIdrDate;
                        }
                        else
                        {
                            lsIdrDate = DateTime.MinValue.ToString();
                            LogManager.GetCurrentClassLogger().Debug(string.Format(" GetIdrUsageDate Request DB call END: utility: {0} account: {1} IdrUsageDate: {2} Method Duration ms:{3} ", utilitycd, accountNumber, lsIdrDate, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                            return lsIdrDate;
                        }
                    }
                }

            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;

                LogManager.GetCurrentClassLogger().Debug(string.Format("Usage Date Request DB Query Exception: {0} account: {1} Error: {2} Method Duration ms:{3}", utilitycd, accountNumber, errorMessage, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                lsIdrDate = DateTime.MinValue.ToString();
                return lsIdrDate;
            }
        }

        public bool DoesEclDataExist(string accountNumber, int utilityId)
        {
            var utilityTableName = "ECL_PECO_HU_T_Customer";

            try
            {
                using (var con = new SqlConnection(_connectionStringSQL9))
                {
                    //Todo: Make this a proc!
                    var sqlStatement =
                        string.Format(@"select 1 where exists(SELECT id FROM {1} where AccountNumber = '{0}' and MeterType = 'Y')", accountNumber, utilityTableName);
                    using (var cmd = new SqlCommand(sqlStatement, con))
                    {
                        cmd.CommandType = CommandType.Text;
                        con.Open();
                        using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                        {
                            return reader.HasRows;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(string.Format("Peco account data verification failed for {0}. Message was {1}", accountNumber, ex.Message), ex);
            }

            return false;
        }

       public  UsageResponseIdr GetUsageListIdr(string messageId, DataTable dtUsageRequestIdr)
        {
            UsageResponseIdr usageResponseIdr=new UsageResponseIdr();
            DataSet dataSet = new DataSet();
            try
            {
                LogManager.GetCurrentClassLogger().Debug(string.Format("GetUsageListIdr(string messageId, DataTable usageRequestIdr)"));
                ////Connect and Query the data using StoreProcedure
                using (SqlConnection conn = new SqlConnection(_connectionStringLpTransactions))
                {
                    LogManager.GetCurrentClassLogger().Debug(string.Format("GetUsageListIdr(messageId, UsageRequestIdr"));
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Usp_GetIdrHourlyUsage";
                        cmd.Connection = conn;
                        cmd.Parameters.Add(new SqlParameter("@ACCOUNTUSAGELIST", dtUsageRequestIdr));
                        
                        conn.Open();
                        using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd))
                        {
                            sqlDataAdapter.Fill(dataSet);
                        }
                            //Check the data existance
                            if (dataSet.Tables[0].Rows.Count > 0)
                            {
                                foreach(DataRow drGetUsage in dataSet.Tables[0].Rows)
                                {
                                   usageResponseIdr.lstUsageResponseIdrItem.Add(
                                       new UsageResponseIdrItem(
                                       Convert.ToString(drGetUsage["AccountNumber"])
                                       ,Convert.ToInt32(drGetUsage["UtilityId"])
                                       ,Convert.ToDateTime(drGetUsage["Date"])
                                       ,Convert.ToString(drGetUsage["Usage"])
                                       ,Convert.ToString(drGetUsage["MeterNumber"])
                                       , Convert.ToString(drGetUsage["ErrorMessage"])
                                       ));
                                }
                               usageResponseIdr.Code="0000";
                               usageResponseIdr.IsSuccess=true;
                               usageResponseIdr.MessageId=messageId;

                            }
                        
                        
                    }
                }

            }
            catch (Exception exc)
            {
                string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
                string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
                string errorMessage = exception + innerException;
                usageResponseIdr.MessageId=messageId;
                usageResponseIdr.Message=errorMessage;
                usageResponseIdr.IsSuccess=false;
                usageResponseIdr.Code="9999";
                usageResponseIdr.lstUsageResponseIdrItem=null;
                LogManager.GetCurrentClassLogger().Debug(string.Format("Error Occured for GetUsageListIdr ErrorMessage:",errorMessage));
                
            }
           return usageResponseIdr;
        }

       public UsageResponseNonIdr GetUsageListNonIdr(string messageId, DataTable dtUsageRequestNonIdr)
       {
           UsageResponseNonIdr usageResponseNonIdr = new UsageResponseNonIdr();
           DataSet dataSet = new DataSet();
           try
           {
               LogManager.GetCurrentClassLogger().Debug(string.Format("GetUsageListNonIdr(string messageId, DataTable dtUsageRequestNonIdr)"));
               ////Connect and Query the data using StoreProcedure
               using (SqlConnection conn = new SqlConnection(_connectionStringLpTransactions))
               {
                   LogManager.GetCurrentClassLogger().Debug(string.Format("GetUsageListNonIdr(messageId, dtUsageRequestNonIdr"));
                   using (SqlCommand cmd = new SqlCommand())
                   {
                       cmd.CommandType = CommandType.StoredProcedure;
                       cmd.CommandText = "usp_GetNonConsolidatedUsage";
                       cmd.Connection = conn;
                       cmd.Parameters.Add(new SqlParameter("@ACCOUNTUSAGELIST", dtUsageRequestNonIdr));
                       
                       conn.Open();
                       using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd))
                       {
                           sqlDataAdapter.Fill(dataSet);
                       }
                       //Check the data existance
                       if (dataSet.Tables[0].Rows.Count > 0)
                       {
                           foreach (DataRow drGetUsage in dataSet.Tables[0].Rows)
                           {
                               usageResponseNonIdr.lstUsageResponseNonIdrItem.Add(
                                   new UsageResponseNonIdrItem(
                                   Convert.ToString(drGetUsage["AccountNumber"])
                                   , Convert.ToInt32(drGetUsage["UtilityId"])
                                   , Convert.ToDateTime(drGetUsage["FromDate"])
                                   , Convert.ToDateTime(drGetUsage["ToDate"])
                                   , Convert.ToDouble(drGetUsage["TotalKwh"])
                                   , Convert.ToInt32(drGetUsage["DaysUsed"])
                                   , Convert.ToString(drGetUsage["ErrorMessage"])
                                   , Convert.ToString(drGetUsage["MeterNumber"])
                                   ));
                           }
                           usageResponseNonIdr.Code = "0000";
                           usageResponseNonIdr.IsSuccess = true;
                           usageResponseNonIdr.MessageId = messageId;

                       }


                   }
               }

           }
           catch (Exception exc)
           {
               string innerException = exc == null ? "NULL VALUE" : exc.InnerException == null ? "NULL VALUE" : exc.InnerException.ToString();
               string exception = exc == null ? "NULL VALUE" : exc.Message == null ? "NULL VALUE" : exc.Message;
               string errorMessage = exception + innerException;
               usageResponseNonIdr.MessageId = messageId;
               usageResponseNonIdr.Message = errorMessage;
               usageResponseNonIdr.IsSuccess = false;
               usageResponseNonIdr.Code = "9999";
               usageResponseNonIdr.lstUsageResponseNonIdrItem = null;
               LogManager.GetCurrentClassLogger().Debug(string.Format("Error Occured for GetUsageListNonIdr ErrorMessage:", errorMessage));

           }
           return usageResponseNonIdr;
       }
    }
}