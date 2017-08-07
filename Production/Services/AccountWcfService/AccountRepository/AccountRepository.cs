using System;
using System.ComponentModel.Composition;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using Utilities;
using UtilityLogging;
using UtilityUnityLogging;
using System.Reflection;
using System.Collections.Generic;
namespace LibertyPower.MarketDataServices.AccountRepository
{
    [Export(typeof(IAccountRepository))]

    public class AccountServiceRepository : IAccountRepository
    {

        #region private variables
        private const string NAMESPACE = "LibertyPower.MarketDataServices.AccountRepository";
        private const string CLASS = "AccountRepository";
        private string _connectionStringAccount;
        private ILogger _logger;

        #region public constructors
        public AccountServiceRepository(string messageId, ILogger logger)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("AccountRepository(string messageId:{0}, ILog log)",messageId);
            _logger = logger;
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
        public DataSet UpdateAnnualUsageBulk(string messageId, AnnualUsageTranRecordList annualUsageList)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("UpdateAnnualUsageBulk(messageId:{0})", Utilities.Common.NullSafeString(messageId));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                DataSet dataSet = new DataSet();

                ////Connect and Query the data using StoreProcedure
                using (SqlConnection selectConnection = new SqlConnection(_connectionStringAccount))
                {
                    using (SqlCommand command = new SqlCommand())
                    {
                        command.Connection = selectConnection;
                        command.CommandType = CommandType.StoredProcedure;
                        command.CommandTimeout = 300;
                        command.CommandText = "[usp_UpdateAnnualUsageBulk]";
                        var aphTT = new SqlParameter("@AccountUsageList", SqlDbType.Structured) { Value = ToDataTable<AnnualUsageTranRecord>(annualUsageList), TypeName = "AnnualUsageTranRecord" };
                        command.Parameters.Add(aphTT);
                        using (SqlDataAdapter da = new SqlDataAdapter(command))
                        {
                            da.Fill(dataSet);
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
       
        public DataSet PopulateEnrolledAccounts(string messageId)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("PopulateEnrolledAccounts(messageId:{0})", Utilities.Common.NullSafeString(messageId));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                DataSet dataSet = new DataSet();

                ////Connect and Query the data using StoreProcedure
                using (SqlConnection conn = new SqlConnection(_connectionStringAccount))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_EnrolledAccounts_Insert";
                        cmd.Connection = conn;

                        //cmd.Parameters.Add(new SqlParameter("@p_UtilityId", utilityId));

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
        public DataSet GetEnrolledAccountsToProcess(string messageId,int numberOfAccounts)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("GetEnrolledAccountsToProcess(messageId:{0} NumberOf Accoutns{1})", Utilities.Common.NullSafeString(messageId), numberOfAccounts);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                DataSet dataSet = new DataSet();

                ////Connect and Query the data using StoreProcedure
                using (SqlConnection conn = new SqlConnection(_connectionStringAccount))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_GetEnrolledAccountsToProcess";
                        cmd.Connection = conn;

                        cmd.Parameters.Add(new SqlParameter("@p_NumberofAccount", numberOfAccounts));

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
        public static DataTable ToDataTable<T>(List<T> list)
        {
            DataTable dt = new DataTable();

            Type listType = typeof(T);

            //Get element properties and add datatable columns  
            PropertyInfo[] properties = listType.GetProperties();
            foreach (PropertyInfo property in properties)
                dt.Columns.Add(new DataColumn() { ColumnName = property.Name });
            foreach (T item in list)
            {
                var dr = dt.NewRow();
                foreach (DataColumn col in dt.Columns)
                {

                    dr[col] = listType.GetProperty(col.ColumnName).GetValue(item, null);

                }

                dt.Rows.Add(dr);
            }
            return dt;
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
                _connectionStringAccount = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
                if (string.IsNullOrWhiteSpace(_connectionStringAccount))
                {
                    var ex = new ConfigurationErrorsException("Connection string not found with name of Transactions");
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
        #endregion
}