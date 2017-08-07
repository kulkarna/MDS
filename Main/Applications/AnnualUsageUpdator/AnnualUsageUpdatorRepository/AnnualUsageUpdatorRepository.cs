using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Utilities;
using UtilityUnityLogging;
using UtilityLogging;
using System.Reflection;
using LibertyPower.MarketDataServices.AccountWcfServiceData;
using UsageWebService.Entities;


namespace LibertyPower.MarketDataServices.AnnualUsageUpdatorRespository
{
    /// <summary>
    /// Class AnnualUsageUpdatorRespositoryManagement
    /// </summary>
    public class AnnualUsageUpdatorRespositoryManagement : IAnnualUsageUpdatorRespositoryManagement
    {
        #region private variables
        private const string NAMESPACE = "AnnualUsageUpdatorRespository";
        private const string CLASS = "AnnualUsageUpdatorRespository";
        private static ILogger _logger;
        
        #endregion

        #region public constructors
        /// <summary>
        /// Initializes a new instance of the <see cref="UsageManagementWcfServiceRepositoryManagement"/> class.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        public AnnualUsageUpdatorRespositoryManagement()
        {
            string method = "AnnualUsageUpdatorRespository(messageId)";
            string messageId = Guid.NewGuid().ToString();
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
               _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString(), exc));
               _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
         
        #endregion

        /// <summary>
        /// Process the account s to get the annual usage updated.
        /// </summary>
        /// <param name="messageId">The message identifier.</param>
        /// <param name="numberOfAccounts">Thenumber of accounts to proces at a time int.</param>
        /// <returns>System.Int32.</returns>
        
        public  int CheckjobStatus(string messageId,int numberOfDays)
        {
            DateTime beginTime = DateTime.Now;
            string method = string.Format("CheckjobStatus(NumberOfAccounts", numberOfDays.ToString());
            int liReturn = 0;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                DataSet dataSet = new DataSet();
                var _connectionStringAccount = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
                ////Connect and Query the data using StoreProcedure
                using (SqlConnection conn = new SqlConnection(_connectionStringAccount))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_CheckAnnualUsageJobStatus";
                        cmd.Connection = conn;

                        cmd.Parameters.Add(new SqlParameter("@p_IntervalDays", numberOfDays));

                        using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd))
                        {
                            sqlDataAdapter.Fill(dataSet);
                        }
                    }
                }
                DataTable dtAccounts;
                if ((dataSet != null) && (dataSet.Tables != null) && (dataSet.Tables.Count > 0) && (dataSet.Tables[0].Rows != null))
                {
                    dtAccounts = dataSet.Tables[0];
                    DataRow dr1 = dtAccounts.Rows[0];
                    liReturn = Convert.ToInt32(dr1.ItemArray[0].ToString());
                }
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return liReturn;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                 return 0;
            }
        }

        public  Report GetUpdateReport(string messageId)
        {
            DateTime beginTime = DateTime.Now;
            Report UpdateReport = new Report();
            
            string method = string.Format("GetUpdateReport", messageId);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} BEGIN", Utilities.Common.NullSafeDateToString(beginTime), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method));
                DataSet dataSet = new DataSet();
                var _connectionStringAccount = ConfigurationManager.ConnectionStrings["LibertyPowerConnectionString"].ConnectionString;
                ////Connect and Query the data using StoreProcedure
                using (SqlConnection conn = new SqlConnection(_connectionStringAccount))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_GetAnnualUsageUpdateReport";
                        cmd.Connection = conn;

                        //cmd.Parameters.Add(new SqlParameter("@p_IntervalDays", numberOfDays));

                        using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(cmd))
                        {
                            sqlDataAdapter.Fill(dataSet);
                        }
                    }
                }
                DataTable dtAccounts;
                if ((dataSet != null) && (dataSet.Tables != null) && (dataSet.Tables.Count > 0) && (dataSet.Tables[0].Rows != null))
                {
                    dtAccounts = dataSet.Tables[0];
                    DataRow dr1 = dtAccounts.Rows[0];
                    UpdateReport.AccountBegin = Convert.ToInt32(dr1.ItemArray[0].ToString());
                    UpdateReport.AccountProcessed = Convert.ToInt32(dr1.ItemArray[1].ToString());
                    UpdateReport.AccountPending = Convert.ToInt32(dr1.ItemArray[2].ToString());
                    UpdateReport.AccountUpdated = Convert.ToInt32(dr1.ItemArray[3].ToString());
                }
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).Milliseconds.ToString()));
                return UpdateReport;
            }
            catch (Exception ex)
            {
                _logger.LogError(messageId, string.Format("{0} {1} {2}.{3}.{4} ERROR {5} {6} Duration:{7} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, Utilities.Common.NullSafeString(ex.Message), Utilities.Common.NullSafeString(ex.StackTrace), DateTime.Now.Subtract(beginTime).ToString()));
                _logger.LogInfo(messageId, string.Format("{0} {1} {2}.{3}.{4} END {5} ms", Utilities.Common.NullSafeDateToString(DateTime.Now), Utilities.Common.NullSafeString(messageId), NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginTime).ToString()));
                return UpdateReport;
            }
        }
    }
}
