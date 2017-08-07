using Microsoft.Practices.Unity.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using UtilityLogging;
using UtilityUnityLogging;
using Utilities;
using UtilityManagementServiceData;


namespace UtilityManagementRepository
{
    public class DataRepository : IDataRepositoryV3
    {
        #region private variables
        private const string NAMESPACE = "UtilityManagementRepository";
        private const string CLASS = "DataRepository";
        private string _messageId = Guid.NewGuid().ToString();
        private string _lp_DataSyncConnectionStr;
        private ILogger _logger;
        #endregion

        #region public constructors
        public DataRepository()
        {
            string method = "DataRepository()";
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                _lp_DataSyncConnectionStr = Helper.ConnectionString;

                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(_messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(_messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion

        #region public properties
        public string MessageId { get { return _messageId; } set { _messageId = value; } }
        #endregion
        #region public Method
        /// <summary>
        /// Method to Check that Whether Utility Belongs to corect ISO.
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="Iso"></param>
        /// <param name="UtilityCode"></param>
        /// <returns></returns>

        public bool DoesUtilityCodeBelongToIso(string messageId, string Iso, string UtilityCode)
        {
            string method = string.Format("DoesUtilityCodeBelongToIso(messageId,Iso:{0},UtilityCode:{1})", Iso, UtilityCode);
            DataSet dataSet = null;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN ConnectionString : _lp_DataSyncConnectionStr {3} ", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));
                bool returnValue = false;
                using (SqlConnection sqlConnection = new SqlConnection(_lp_DataSyncConnectionStr))
                {

                    using (SqlCommand sqlCommand = new SqlCommand("usp_UtilityCompany_DoesUtilityCodeBelongToIso", sqlConnection))
                    {
                        dataSet = new DataSet();
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@IsoName", Iso));
                        sqlDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", UtilityCode));
                        sqlDataAdapter.Fill(dataSet);
                    }
                }

                bool.TryParse((Convert.ToString(dataSet.Tables[0].Rows[0][0]) == "1") ? "true" : "false", out returnValue);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Method to Check that Whether Utility is Accelerated or not
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="UtilityCode"></param>
        /// <returns></returns>

        public bool GetAcceleratedSwitchbyUtilityCode(string messageId, string UtilityCode)
        {
            string method = string.Format("GetAcceleratedSwitchbyUtilityCode(messageId,UtilityCode:{0})", UtilityCode);
            DataSet dataSet = null;
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN Connection String : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));
                bool returnValue = false;
                using (SqlConnection sqlConnection = new SqlConnection(_lp_DataSyncConnectionStr))
                {

                    using (SqlCommand sqlCommand = new SqlCommand("usp_GetAcceleratedSwitch_ByUtilityCode", sqlConnection))
                    {
                        dataSet = new DataSet();
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                        sqlDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        sqlDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", UtilityCode));
                        sqlDataAdapter.Fill(dataSet);
                    }
                }

                bool.TryParse((Convert.ToString(dataSet.Tables[0].Rows[0]["AcceleratedSwitch"]) == "1") ? "true" : "false", out returnValue);

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, returnValue));

                return returnValue;

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        /// <summary>
        /// Returns the Data for All Utilities
        /// </summary>
        /// <param name="messageId"></param>
        /// <returns></returns>
        public DataSet GetAllUtilitiesData(string messageId)
        {
            string method = "GetAllUtilitiesData(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN Connection String :_lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_UtilityGetAllUtilitiesData", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Get Meter Read Calender by UtilityCode
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityCode"></param>
        /// <returns></returns>
        public DataSet GetMeterReadCalendarByUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("GetMeterReadCalendarByUtilityCode(messageId,utilityCode:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN Connection String : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));


                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalendar_GetByUtilityCode", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Get Id Request Mode by Stored Procedure USP_GetIDRRequestModeData
        /// </summary>
        /// <param name="messageId"></param>
        /// <param namnamee="rateClassCode"></param>
        /// <param name="loadProfileCode"></param>
        /// <param name="tariffCodeCode"></param>
        /// <param name="eligibility"></param>
        /// <param ="hia"></param>
        /// <param name="utilityIdInt"></param>
        /// <param name="usage"></param>
        /// <param name="enrollmentType"></param>
        /// <returns></returns>
        public DataSet GetIdrRequestModeData(string messageId, string rateClassCode, string loadProfileCode, string tariffCodeCode, bool? eligibility, bool? hia, int? utilityIdInt, int? usage, EnrollmentType enrollmentType)
        {
            string method = string.Format("GetIdrRequestModeData(messageId,rateClassCode:{0},loadProfileCode:{1},tariffCodeCode:{2},eligibility:{3},hia:{4},utilityIdInt:{5},usage:{6},enrollmentType:{7})",
                Common.NullSafeString(rateClassCode), Common.NullSafeString(loadProfileCode), Common.NullSafeString(tariffCodeCode), Common.NullSafeString(eligibility), Common.NullSafeString(hia), Common.NullSafeString(utilityIdInt), Common.NullSafeString(usage), Common.NullSafeString(enrollmentType));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN Connection String : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));


                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("USP_GetIDRRequestModeData", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@utilityId", utilityIdInt));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@enrollmentType", Common.NullSafeString(enrollmentType)));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClass", rateClassCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfile", loadProfileCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCode", tariffCodeCode));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Eligibility", eligibility));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Hia", hia));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Usage", usage));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        /// <summary>
        /// Get Request Mode Data By Parameter
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityIdInt"></param>
        /// <param name="serviceAccount"></param>
        /// <param name="enrollmentType"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <param name="annualUsage"></param>
        /// <param name="hia"></param>
        /// <returns></returns>
        public DataSet GetIdrRequestModeDataValuesByParam(string messageId, int utilityIdInt, string serviceAccount, EnrollmentType enrollmentType, string rateClass, string loadProfile, string tariffCode, string annualUsage, bool hia)
        {
            string method = string.Format("GetIdrRequestModeDataValuesByParam(messageId,utilityIdInt:{0},serviceAccount:{1},enrollmentType:{2},rateClass:{3},loadProfile:{4},tariffCode:{5}annualUsage:{6},hia:{7})", utilityIdInt, serviceAccount, enrollmentType, rateClass, loadProfile, tariffCode, annualUsage, hia.ToString());
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN Connection String : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));


                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_IdrRuleAndRequestMode_SelectByParams", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityIdInt", utilityIdInt));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@EnrollmentType", Common.NullSafeString(enrollmentType)));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClassCode", rateClass));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfileCode", loadProfile));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@Hia", hia));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@AnnualUsage", annualUsage));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        /// <summary>
        /// Get UtilityCode by UtilityId
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <returns></returns>
        public string GetUtilityCodebyUtilityId(string messageId, string utilityId)
        {
            string method = string.Format("GetUtilityCodebyUtilityId(messageId,utilityId:{0})", utilityId);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));
                string utilityCode = string.Empty;
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection : _lp_DataSyncConnectionStr :{3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));
                    using (SqlCommand cmd = new SqlCommand("usp_GetUtilityCodebyUtilityId", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        if (connection.State == ConnectionState.Closed)
                            connection.Open();
                        utilityCode = Convert.ToString(cmd.ExecuteScalar());
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd.ExecuteScalar();", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, utilityCode));

                return utilityCode;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// We Get the Next Meter Read Suppose the Inquiry Date is 01/13/2017 then it will provide the Meter Read Just Next to It.
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="readCycleId"></param>
        /// <param name="isAmr"></param>
        /// <param name="inquiryDate"></param>
        /// <returns></returns>
        public DataSet GetMeterReadCalenderNextReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            // declare variables used throughout the method
            string method = string.Format("GetMeterReadCalenderNextReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId,utilityId:{0},readCycleId:{1},isAmr:{2},inquiryDate:{3})",
                Utilities.Common.NullSafeString(utilityId), Utilities.Common.NullSafeString(readCycleId), Utilities.Common.NullSafeString(isAmr), Utilities.Common.NullSafeDateToString(inquiryDate));
            DataSet ds = new DataSet();

            try
            {
                //  log the method entry
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));



                // create a connection utilizing "using" so all references to the data connection are cleaned up once the thread exits the using statement
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    // create and execute the database command
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalenderGetNextReadDateByUtilityIdReadCycleIdAndInquiryDate", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ReadCycleId", readCycleId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsAmr", isAmr));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@InquiryDate", inquiryDate));
                        adapter.Fill(ds);
                    }
                }

                // log the exit and return the dataset
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return ds;
            }
            catch (Exception exc)
            {
                // log our exception and our exit from the method and rethrow the exception
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        /// <summary>
        /// We Get the Previous Meter Read Suppose the Inquiry Date is 01/13/2017 then it will provide the Previous Meter Read Date Just Previous to It.
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="readCycleId"></param>
        /// <param name="isAmr"></param>
        /// <param name="inquiryDate"></param>
        /// <returns></returns>
        public DataSet GetMeterReadCalenderPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate(string messageId, int utilityId, string readCycleId, bool isAmr, DateTime inquiryDate)
        {
            // declare variables used throughout the method
            string method = string.Format("GetMeterReadCalenderPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate(messageId,utilityId:{0},readCycleId:{1},isAmr:{2},inquiryDate:{3})",
                Utilities.Common.NullSafeString(utilityId), Utilities.Common.NullSafeString(readCycleId), Utilities.Common.NullSafeString(isAmr), Utilities.Common.NullSafeDateToString(inquiryDate));
            DataSet ds = new DataSet();

            try
            {
                //  log the method entry
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                // create a connection utilizing "using" so all references to the data connection are cleaned up once the thread exits the using statement
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    // create and execute the database command
                    using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalenderGetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@ReadCycleId", readCycleId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@IsAmr", isAmr));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@InquiryDate", inquiryDate));
                        adapter.Fill(ds);
                    }
                }

                // log the exit and return the dataset
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                return ds;
            }
            catch (Exception exc)
            {
                // log our exception and our exit from the method and rethrow the exception
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Get UtilityId by UtilityCode
        /// /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityCode"></param>
        /// <returns></returns>
        public string GetUtilityIdbyUtilityCode(string messageId, string utilityCode)
        {
            string method = string.Format("GetUtilityIdbyUtilityCode(messageId,utilityId:{0})", utilityCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING :_lp_DataSyncConnectionStr : {3} ", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));
                string utilityId = string.Empty;
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_GetUtilityIdbyUtilityCode", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        if (connection.State == ConnectionState.Closed)
                            connection.Open();
                        utilityId = Convert.ToString(cmd.ExecuteScalar());
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd.ExecuteScalar();", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, utilityCode));

                return utilityId; ;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        //DataSet GetRequestModeIcap(string messageId, int utilityId, int enrollmentTypeInt)
        //{
        //    // declare variables used throughout the method
        //    string method = string.Format("GetRequestModeIcap(messageId,utilityId:{0},enrollmentTypeInt:{1})",
        //        Utilities.Common.NullSafeString(utilityId), Utilities.Common.NullSafeString(enrollmentTypeInt));
        //    DataSet ds = new DataSet();

        //    try
        //    {
        //        //  log the method entry
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

        //        // create a connection utilizing "using" so all references to the data connection are cleaned up once the thread exits the using statement
        //        using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
        //        {
        //            // create and execute the database command
        //            using (SqlCommand cmd = new SqlCommand("usp_MeterReadCalenderGetPreviousReadDateByUtilityIdReadCycleIdAndInquiryDate", connection))
        //            {
        //                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        //                adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
        //                adapter.SelectCommand.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
        //                adapter.SelectCommand.Parameters.Add(new SqlParameter("@EnrollmentType", enrollmentTypeInt));
        //                adapter.Fill(ds);
        //            }
        //        }

        //        // log the exit and return the dataset
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
        //        return ds;
        //    }
        //    catch (Exception exc)
        //    {
        //        // log our exception and our exit from the method and rethrow the exception
        //        _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
        //        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
        //        throw;
        //    }
        //}

        /// <summary>
        /// Returns the Data for All Utilities with Accelerated Switch
        /// </summary>
        /// <param name="messageId"></param>
        /// <returns></returns>
        public DataSet GetAllUtilitiesAcceleratedSwitchData(string messageId)
        {
            string method = "GetAllUtilitiesAcceleratedSwitchData(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING :_lp_DataSyncConnectionStr : {3} ", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_GetAllUtilities_AcceleratedSwitch", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Returns the Lead Time for Enrollment
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tarrifCode"></param>
        /// <returns></returns>
        public DataSet GetEnrollmentLeadTimeData(string messageId, int utilityId, string rateClass, string loadProfile, string tariffCode)
        {
            string method = string.Format("GetEnrollmentLeadTimeData(messageId,utilityCode:{0},rateClass:{1},loadProfile:{2},tariffCode:{3})", Common.NullSafeString(utilityId), rateClass, loadProfile, tariffCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_GetEnrollmentLeadTimes", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        cmd.Parameters.Add(new SqlParameter("@RateClass", rateClass));
                        cmd.Parameters.Add(new SqlParameter("@LoadProfile", loadProfile));
                        cmd.Parameters.Add(new SqlParameter("@TariffCode", tariffCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Returns the Data for All Utilities Required Fields
        /// </summary>
        /// <param name="messageId"></param>
        /// <returns></returns>
        public DataSet GetAllUtilityAccountInfoRequiredFields(string messageId)
        {
            string method = "GetAllUtilityAccountInfoRequiredFields(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("USP_GetAllUtilityAccountInfoRequiredFields", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Returns the ICap Request Mode
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="enrollmentType"></param>
        /// <returns></returns>
        public DataSet GetAIRequestMode(string messageId, int utilityId, string enrollmentType)
        {
            string method = "GetAIRequestMode(messageId,utilityId,enrollmentType)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_GetAIRequestMode", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@utilityId", utilityId));
                        cmd.Parameters.Add(new SqlParameter("@enrollmentType", enrollmentType));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Get All Request Mode Like Pre Enrollment and Post Enrollment
        /// </summary>
        /// <param name="messageId"></param>
        /// <returns></returns>
        public DataSet GetAllRequestModeEnrollmentTypes(string messageId)
        {
            string method = "GetAllRequestModeEnrollmentTypes(messageId)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_GetAllRequestModeEnrollmentTypes", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Return The Billing Type of Utility
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <returns></returns>
        public DataSet GetBillingType(string messageId, int utilityId, string rateClass, string loadProfile, string tariffCode)
        {
            string method = string.Format("GetBillingType(messageId,utilityCode:{0},rateClass:{1},loadProfile:{2},tariffCode:{3})", Common.NullSafeString(utilityId), rateClass, loadProfile, tariffCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("USP_GetBillingTypes", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        cmd.Parameters.Add(new SqlParameter("@RateClass", rateClass));
                        cmd.Parameters.Add(new SqlParameter("@LoadProfile", loadProfile));
                        cmd.Parameters.Add(new SqlParameter("@TariffCode", tariffCode));
                        adapter.Fill(ds);
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Return The Billing Type of Utility
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <returns></returns>
        public DataSet GetBillingTypeWithDefault(string messageId, int utilityId, string rateClass, string loadProfile, string tariffCode)
        {
            string method = string.Format("GetBillingTypeWithDefault(messageId,utilityCode:{0},rateClass:{1},loadProfile:{2},tariffCode:{3})", Common.NullSafeString(utilityId), rateClass, loadProfile, tariffCode);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING :_lp_DataSyncConnectionStr : {3} ", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("USP_GetBillingTypesDefault", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@UtilityId", utilityId));
                        cmd.Parameters.Add(new SqlParameter("@RateClass", rateClass));
                        cmd.Parameters.Add(new SqlParameter("@LoadProfile", loadProfile));
                        cmd.Parameters.Add(new SqlParameter("@TariffCode", tariffCode));
                        adapter.Fill(ds);
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        /// <summary>
        /// Returns the Capacity Threshold Value
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityCode"></param>
        /// <param name="accountType"></param>
        /// <returns></returns>
        public DataSet GetCapacityThresholdRuleGetByUtilityCodeCustomerAccountType(string messageId, string utilityCode, string accountType)
        {
            string method = string.Format("GetCapacityThresholdRuleGetByUtilityCodeCustomerAccountType(messageId,utilityCode:{0},accountType:{1})", Common.NullSafeString(utilityCode), accountType);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN CONNECTION STRING : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));

                DataSet ds = new DataSet();
                string connectionString = Common.NullSafeString(_lp_DataSyncConnectionStr);
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("usp_CapacityThresholdRuleGetByUtilityCodeCustomerAccountType", connection))
                    {
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                        cmd.Parameters.Add(new SqlParameter("@AccountType", accountType));
                        adapter.Fill(ds);
                    }
                }
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));
                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message));
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        /// <summary>
        /// Get Purchase of Receivable data
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="rateClass"></param>
        /// <param name="loadProfile"></param>
        /// <param name="tariffCode"></param>
        /// <param name="effectiveDate"></param>
        /// <returns></returns>
        public DataSet GetPurchaseOfReceivableAssurance(string messageId, int utilityId, string loadProfile, string rateClass, string tariffCode, DateTime effectiveDate)
        {
            string method = string.Format("GetPurchaseOfReceivableAssurance(messageId,utilityId:{0},rateClass:{1},loadProfile:{2},tariffCode:{3},effectiveDate:{4})", utilityId, rateClass, loadProfile, tariffCode, effectiveDate);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN Connection String : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));


                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_HasPORAssuranceForWCF", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@utilityId", utilityId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@EffectiveDate", Common.NullSafeDateTime(effectiveDate)));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@RateClass", rateClass));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@LoadProfile", loadProfile));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@TariffCode", tariffCode));
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        /// <summary>
        /// Method to get Request Mode for HU
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="utilityId"></param>
        /// <param name="enrollmentType"></param>
        /// <returns></returns>
        public DataSet GetRequestModeHUData(string messageId, int utilityId, EnrollmentType enrollmentType)
        {
            string method = string.Format("GetRequestModeHUData(messageId,utilityId:{0},EnrollmentType:{1})", utilityId, enrollmentType);
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN Connection String : _lp_DataSyncConnectionStr : {3}", NAMESPACE, CLASS, method, _lp_DataSyncConnectionStr));


                DataSet ds = new DataSet();
                using (SqlConnection connection = new SqlConnection(_lp_DataSyncConnectionStr))
                {
                    _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} connection", NAMESPACE, CLASS, method));
                    using (SqlCommand cmd = new SqlCommand("usp_GetHURequestMode", connection))
                    {
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} cmd", NAMESPACE, CLASS, method));

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter", NAMESPACE, CLASS, method));

                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@utilityId", utilityId));
                        adapter.SelectCommand.Parameters.Add(new SqlParameter("@enrollmentType",Common.NullSafeString(enrollmentType)));

                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds); b4", NAMESPACE, CLASS, method));
                        adapter.Fill(ds);
                        _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} adapter.Fill(ds);", NAMESPACE, CLASS, method));
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} returnValue:{3} END", NAMESPACE, CLASS, method, ds));

                return ds;
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message + exc.InnerException == null ? "" : exc.InnerException.ToString()));
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion


    }
}
