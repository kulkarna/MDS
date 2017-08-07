using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;


namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class MultiTermServiceSql
    {
        #region Methods


        public static DataSet GetAllMultyTermServiceRecords()
        {
            const string storeProcName = "usp_GetAllMultyTermServiceRecords";
            var ds = new DataSet();
            using (var selectConnection = new SqlConnection(Helper.ConnectionString))
            {
                using (var command = new SqlCommand())
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storeProcName;

                    using (var da = new SqlDataAdapter(command))
                    {
                        ds = GetDataSet(ds, da);
                    }
                }
            }
            return ds;
        }

        public static DataSet GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId(int processStatusId, DateTime submittionDate)
        {
            const string storeProcName = "usp_GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId";
            var ds = new DataSet();
            using (var selectConnection = new SqlConnection(Helper.ConnectionString))
            {
                using (var command = new SqlCommand())
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storeProcName;
                    command.Parameters.Add(new SqlParameter("@ProcessStatusId", processStatusId));
                    command.Parameters.Add(new SqlParameter("@SubmittionDate", submittionDate));
                    using (var da = new SqlDataAdapter(command))
                    {
                        ds = GetDataSet(ds, da);
                    }
                }
            }
            return ds;
        }

        public static void AddMultiTermRecordsToBeProcessedByService(int numberDaysInAdvance, int numberDaysAfterMeterDateToIstaSubmission, int userId, int defaultLeadTimePeriod, int standardLeadTimePeriod, int productTypeId)
        {
            const string storeProcName = "usp_AddMultiTermRecordsToBeProcessedByService";
            using (var selectConnection = new SqlConnection(Helper.ConnectionString))
            {
                using (var command = new SqlCommand())
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storeProcName;
                    command.Parameters.Add(new SqlParameter("@NumberDaysInAdvance", numberDaysInAdvance));
                    command.Parameters.Add(new SqlParameter("@NumberDaysAfterMeterDateToIstaSubmission", numberDaysAfterMeterDateToIstaSubmission));
                    command.Parameters.Add(new SqlParameter("@UserId", userId));
					command.Parameters.Add(new SqlParameter("@DefaultLeadTimePeriod", defaultLeadTimePeriod));
					command.Parameters.Add(new SqlParameter("@StandardLeadTimePeriod", standardLeadTimePeriod));
                    ExecuteCommandNoReturn(command);

                }
            }
        }

		public static void AddMultiTermRecordsToBeProcessedByService(int numberDaysInAdvance, int numberDaysAfterMeterDateToIstaSubmission, int userId)
		{
			const string storeProcName = "usp_AddMultiTermRecordsToBeProcessedByService";
			using (var selectConnection = new SqlConnection(Helper.ConnectionString))
			{
				using (var command = new SqlCommand())
				{
					command.Connection = selectConnection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = storeProcName;
					command.Parameters.Add(new SqlParameter("@NumberDaysInAdvance", numberDaysInAdvance));
					command.Parameters.Add(new SqlParameter("@NumberDaysAfterMeterDateToIstaSubmission", numberDaysAfterMeterDateToIstaSubmission));
					command.Parameters.Add(new SqlParameter("@UserId", userId));
					ExecuteCommandNoReturn(command);

				}
			}
		}

        public static void VerifyAndAdjustRateEndAndFollowingStartDatesToMeterDate(int userId)
        {
            const string storeProcName = "usp_VerifyAndAdjustRateEndStartDateToMeterDate";
            using (var selectConnection = new SqlConnection(Helper.ConnectionString))
            {
                using (var command = new SqlCommand())
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storeProcName;
                    command.Parameters.Add(new SqlParameter("@UserId", userId));
                    ExecuteCommandNoReturn(command);

                }
            }
        }

        public static void UpdateStatusMultiTermRecord(int recordId, int processStatusId, int userId)
        {
            const string storeProcName = "usp_UpdateStatusMultiTermRecord";
            using (var selectConnection = new SqlConnection(Helper.ConnectionString))
            {
                using (var command = new SqlCommand())
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storeProcName;
                    command.Parameters.Add(new SqlParameter("@RecordId", recordId));
                    command.Parameters.Add(new SqlParameter("@ProcessStatusId", processStatusId));
                    command.Parameters.Add(new SqlParameter("@UserId", userId));
                    ExecuteCommandNoReturn(command);

                }
            }
        }

		public static void UpdateStatusMultiTermRecord(int recordId, int processStatusId, int userId, string errMsg)
		{
			const string storeProcName = "usp_UpdateStatusMultiTermRecord";
			using (var selectConnection = new SqlConnection(Helper.ConnectionString))
			{
				using (var command = new SqlCommand())
				{
					command.Connection = selectConnection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = storeProcName;
					command.Parameters.Add(new SqlParameter("@RecordId", recordId));
					command.Parameters.Add(new SqlParameter("@ProcessStatusId", processStatusId));
					command.Parameters.Add(new SqlParameter("@UserId", userId));
					command.Parameters.Add(new SqlParameter("@ErrMsg", errMsg));
					ExecuteCommandNoReturn(command);

				}
			}
		}

        public static int GetProductTipeIdByPriceId(long priceId)
        {
            int rtrnVal = 0;
            const string storeProcName = "usp_GetProductTipeIdByPriceId";
            using (var selectConnection = new SqlConnection(Helper.ConnectionString))
            {
                using (var command = new SqlCommand())
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storeProcName;
                    command.Parameters.Add(new SqlParameter("@PriceId", priceId));
                    rtrnVal = (int)ExecuteCommandScalar(command);
                }
            }
            return rtrnVal;
        }

        public static void SaveErrorMessage(int recordId, string errorMssg, int userId)
        {
            const string storeProcName = "usp_SaveErrorMessage";
            using (var selectConnection = new SqlConnection(Helper.ConnectionString))
            {
                using (var command = new SqlCommand())
                {
                    command.Connection = selectConnection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = storeProcName;
                    command.Parameters.Add(new SqlParameter("@RecordId", recordId));
                    command.Parameters.Add(new SqlParameter("@ErrorMssg", errorMssg));
                    command.Parameters.Add(new SqlParameter("@UserId", userId));
                    ExecuteCommandNoReturn(command);
                }
            }
        }

        private static Object ExecuteCommandScalar(SqlCommand cmd)
        {
            Object rtrnVal=null;
            try
            {
                cmd.Connection.Open();
                rtrnVal=cmd.ExecuteScalar();
                cmd.Connection.Close();
            }
            catch (Exception ex)
            {
                cmd.Connection.Close();
                throw ex;
            }
            return rtrnVal;
        }

        private static void ExecuteCommandNoReturn(SqlCommand cmd)
        {
            try
            {
                cmd.Connection.Open();
                cmd.ExecuteNonQuery();
                cmd.Connection.Close();
            }
            catch (Exception ex)
            {
                cmd.Connection.Close();
                throw ex;
            }
        }

        private static DataSet GetDataSet(DataSet ds, SqlDataAdapter da)
        {
            try
            {
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return ds;
        }
        #endregion
    }
}
