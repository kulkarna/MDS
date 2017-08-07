using System;
using System.ComponentModel.Composition;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;
using LibertyPower.MarketDataServices.UsageEclWcfServiceData;

namespace LibertyPower.MarketDataServices.UsageEclRepository
{
    [Export(typeof(IRepository))]
    public class SqlRepository : IRepository
    {

        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.UsageEclRepository";
        private const string CLASS = "SqlRepository";
        private string _connectionStringECLCloud;
        private ILogger _logger;
        #endregion

        #region public constructors
        public SqlRepository(string messageId, ILogger log)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("SqlRepository(string messageId:{0}, ILog log)",messageId);
            _logger = log;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                VerifyConfiguration(messageId);
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
        #endregion


        #region public methods
        public DataSet DoesEclDataExist(string messageId, string accountNumber, int utilityId)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("DoesEclDataExist(messageId:{0},accountNumber:{1},utilityId:{2})",
                Utilities.Common.NullSafeString(messageId), Utilities.Common.NullSafeString(accountNumber), Utilities.Common.NullSafeInteger(utilityId));

            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                DataSet dataSet = new DataSet();

                ////Connect and Query the data using StoreProcedure
                using (SqlConnection conn = new SqlConnection(_connectionStringECLCloud))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_IsIdrEligible";
                        cmd.Connection = conn;

                        cmd.Parameters.Add(new SqlParameter("AccountNumber", accountNumber));
                        cmd.Parameters.Add(new SqlParameter("UtilityId", utilityId));

                        using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd))
                        {
                            sqlDataAdapter.Fill(dataSet);
                        }
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return dataSet;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
        #endregion


        #region private methods
        private void VerifyConfiguration(string messageId)
        {
            DateTime beginTime = DateTime.Now;
            string method = "VerifyConfiguration()";

            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                _connectionStringECLCloud = ConfigurationManager.ConnectionStrings["ECLCloud"].ConnectionString;
                if (string.IsNullOrWhiteSpace(_connectionStringECLCloud))
                {
                    var ex = new ConfigurationErrorsException("Connection string not found with name of ECLCloud");
                    _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                    throw ex;
                }
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                throw;
            }
        }
        #endregion
    }
}