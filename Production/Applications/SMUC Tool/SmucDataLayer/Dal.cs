using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UtilityLogging;
using UtilityUnityLogging;
using Utilities;
using System.Configuration;
using System.Data;
using System.Reflection;
using System.Data.SqlClient;

namespace SmucDataLayer
{
    public class Dal : IDal
    {

        #region private variables
        private string _connectionString = string.Empty;
        private string _connectionStringLpTransactions = string.Empty;
        private const string LP_TRANSACTIONS = "Transactions";
        private const string LibertyPowerConnectionString = "LPConnectionString";

        private ILogger _logger = null;
        private const string NAMESPACE = "SmucDataLayer";

        private const string CLASS = "Dal";
        private const string UTILITY_CODE = "UtilityCode";
        private const string ACCOUNT_NUMBER = "AccountNumber";
        #endregion



        #region public constructors
        public Dal()
        { }

        public Dal(string messageId, ILogger logger)
        {
            string method = "Dal(messageId, logger)";
            try
            {
                if (logger == null)
                {
                    _logger = UnityLoggerGenerator.GenerateLogger();
                }
                else
                {
                    _logger = logger;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                _connectionString = ConfigurationManager.ConnectionStrings[LibertyPowerConnectionString].ConnectionString;
                _connectionStringLpTransactions = ConfigurationManager.ConnectionStrings[LP_TRANSACTIONS].ConnectionString;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion
        #region Public Methods

        public DataTable Usp_GetAccountDetails(string messageId, DataTable dtRecords)
        {

            string method = string.Format("Usp_GetAccountDetails(string messageId,DataTable dtRecords)");
            DataSet dsResult = new DataSet();
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                using (SqlConnection sqlConnection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand("Usp_GetAccountDetails", sqlConnection))
                    {
                        sqlCommand.Parameters.Add("@ListAccounts", dtRecords);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dsResult);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                if (dsResult.Tables.Count > 0)
                    return dsResult.Tables[0];
                return null;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return null;
                throw;
            }
        }
        
    public   DataSet Usp_GetUtilityByIso(string messageId, string isoId)
        {
            string method = string.Format("Usp_GetUtilityByIso(string messageId, string isoId)");
            DataSet dsResult = new DataSet();
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                using (SqlConnection sqlConnection = new SqlConnection(_connectionStringLpTransactions))
                {
                    using (SqlCommand sqlCommand = new SqlCommand("Usp_GetUtilityByIso", sqlConnection))
                    {
                        sqlCommand.Parameters.Add("@IsoId", isoId);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dsResult);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));

                return dsResult;


            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return null;
                throw;
            }
        }
     public   DataSet Usp_GetIso(string messageId)
        {
            string method = string.Format("Usp_GetIso(string messageId)");
            DataSet dsResult = new DataSet();
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                using (SqlConnection sqlConnection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand("Usp_GetIso", sqlConnection))
                    {
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dsResult);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return dsResult;
                

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return null;
                throw;
            }
        }
        public DataTable Usp_GetDetailsDetailsByTransactionId(string messageId, DataTable dtRecords)
        {

            string method = string.Format("Usp_GetDetailsDetailsByTransactionId(string messageId,DataTable dtRecords)");
            DataSet dsResult = new DataSet();
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                using (SqlConnection sqlConnection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand("Usp_GetDetailsDetailsByTransactionId", sqlConnection))
                    {
                        sqlCommand.Parameters.Add("@ListTransactionIds", dtRecords);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dsResult);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                if (dsResult.Tables.Count > 0)
                    return dsResult.Tables[0];
                return null;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return null;
                throw;
            }
        }


        #endregion
    }
}
