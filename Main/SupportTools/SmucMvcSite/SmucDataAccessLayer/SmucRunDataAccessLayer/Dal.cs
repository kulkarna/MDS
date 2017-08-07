using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SmucRunDto;
using UtilityLogging;
using UtilityUnityLogging;
using Utilities;


namespace SmucRunDataAccessLayer
{
    public class Dal : IDal
    {

        #region private variables
        string _connectionString = string.Empty;
        ILogger _logger = null;
        const string LP_TRANSACTIONS = "Transactions";
        private const string NAMESPACE = "SmucRunDataAccessLayer";
        private const string CLASS = "Dal";
        private const string USP_EDI_ACCOUNT_ICAP_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER = "usp_EdiAccountICapByUtilityCodeAndAccountNumber";
        private const string USP_EDI_ACCOUNT_TCAP_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER = "usp_EdiAccountTCapByUtilityCodeAndAccountNumber";
        private const string USP_EDI_ACCOUNT_ZONE_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER = "usp_EdiAccountZoneByUtilityCodeAndAccountNumber";
        private const string USP_EDI_ACCOUNT_LOAD_PROFILE_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER = "usp_EdiAccountLoadProfileByUtilityCodeAndAccountNumber";
        private const string USP_EDI_ACCOUNT_RATE_CLASS_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER = "usp_EdiAccountRateClassByUtilityCodeAndAccountNumber";
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


                _connectionString = ConfigurationManager.ConnectionStrings[LP_TRANSACTIONS].ConnectionString;


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



        #region public method
        public ResultData Process(string selectStatement, string connectionString, string fieldName, ResultData resultData)
        {
            string messageId = Guid.NewGuid().ToString();
            DataSet dataSet = new DataSet();
            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(selectStatement, connectionString);
            sqlDataAdapter.Fill(dataSet);
            if (dataSet != null && dataSet.Tables != null && dataSet.Tables.Count > 0 && dataSet.Tables[0] != null & dataSet.Tables[0].Rows != null && dataSet.Tables[0].Rows.Count > 0 && dataSet.Tables[0].Rows[0] != null)
            {
                foreach (DataRow dataRow in dataSet.Tables[0].Rows)
                {
                    resultData.PopulateDataRow(messageId, dataRow, fieldName);
                }
            }
            return resultData;
        }



        public DataSet usp_EdiAccountICapByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber)
        {
            string method = string.Format("usp_EdiAccountICapByUtilityCodeAndAccountNumber(messageId,utilityCode:{0},accountNumber:{1})", Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountNumber));
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = new DataSet();
                using (SqlConnection sqlConnection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand(USP_EDI_ACCOUNT_ICAP_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER, sqlConnection))
                    {
                        sqlCommand.Parameters.Add(UTILITY_CODE, utilityCode);
                        sqlCommand.Parameters.Add(ACCOUNT_NUMBER, accountNumber);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dataSet);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }



        public DataSet usp_EdiAccountTCapByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber)
        {
            string method = string.Format("usp_EdiAccountTCapByUtilityCodeAndAccountNumber(messageId,utilityCode:{0},accountNumber:{1})", Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountNumber));
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = new DataSet();
                using (SqlConnection sqlConnection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand(USP_EDI_ACCOUNT_TCAP_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER, sqlConnection))
                    {
                        sqlCommand.Parameters.Add(UTILITY_CODE, utilityCode);
                        sqlCommand.Parameters.Add(ACCOUNT_NUMBER, accountNumber);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);

                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dataSet);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }



        public DataSet usp_EdiAccountZoneByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber)
        {
            string method = string.Format("usp_EdiAccountZoneByUtilityCodeAndAccountNumber(messageId,utilityCode:{0},accountNumber:{1})", Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountNumber));
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = new DataSet();
                using (SqlConnection sqlConnection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand(USP_EDI_ACCOUNT_ZONE_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER, sqlConnection))
                    {
                        sqlCommand.Parameters.Add(UTILITY_CODE, utilityCode);
                        sqlCommand.Parameters.Add(ACCOUNT_NUMBER, accountNumber);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dataSet);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }



        public DataSet usp_EdiAccountLoadProfileByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber)
        {
            string method = string.Format("usp_EdiAccountLoadProfileByUtilityCodeAndAccountNumber(messageId,utilityCode:{0},accountNumber:{1})", Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountNumber));
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = new DataSet();
                using (SqlConnection sqlConnection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand(USP_EDI_ACCOUNT_LOAD_PROFILE_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER, sqlConnection))
                    {
                        sqlCommand.Parameters.Add(UTILITY_CODE, utilityCode);
                        sqlCommand.Parameters.Add(ACCOUNT_NUMBER, accountNumber);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dataSet);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }



        public DataSet usp_EdiAccountRateClassByUtilityCodeAndAccountNumber(string messageId, string utilityCode, string accountNumber)
        {
            string method = string.Format("usp_EdiAccountRateClassByUtilityCodeAndAccountNumber(messageId,utilityCode:{0},accountNumber:{1})", Utilities.Common.NullSafeString(utilityCode), Utilities.Common.NullSafeString(accountNumber));
            try
            {
                DateTime beginDateTime = DateTime.Now;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                DataSet dataSet = new DataSet();
                using (SqlConnection sqlConnection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand sqlCommand = new SqlCommand(USP_EDI_ACCOUNT_RATE_CLASS_BY_UTILITY_CODE_AND_ACCOUNT_NUMBER, sqlConnection))
                    {
                        sqlCommand.Parameters.Add(UTILITY_CODE, utilityCode);
                        sqlCommand.Parameters.Add(ACCOUNT_NUMBER, accountNumber);
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.Fill(dataSet);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} return dataSet END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDateTime).Milliseconds.ToString()));
                return dataSet;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


    }
}
