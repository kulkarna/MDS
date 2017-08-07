using System;
using System.ComponentModel.Composition;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Common.Logging;
using UsageWindowsService.Entities;

namespace UsageWindowsService.Repository
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

            if(ConfigurationManager.ConnectionStrings["SQL9"] == null)
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
                    if(!long.TryParse(cmd.Parameters["TransactionId"].Value.ToString(), out transactionId))
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

    }
}