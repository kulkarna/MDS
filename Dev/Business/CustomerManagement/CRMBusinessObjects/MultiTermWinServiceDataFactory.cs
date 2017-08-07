using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class MultiTermWinServiceDataFactory
    {
        public static List<MultiTermWinServiceData> GetAllMultyTermServiceRecords()
        {
            List<MultiTermWinServiceData> recordsToProcess = new List<MultiTermWinServiceData>();
            try
            {
                DataSet ds = MultiTermServiceSql.GetAllMultyTermServiceRecords();
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        MultiTermWinServiceData recordToProcess = GetAssignedRecord(dr);
                        recordsToProcess.Add(recordToProcess);
                    }
                }
            }
            catch (Exception)
            {
                //TODO log the exeption
                recordsToProcess = new List<MultiTermWinServiceData>();
            }
            return recordsToProcess;
        }

        public static List<MultiTermWinServiceData> GetMultyTermWinServiceDataReadyToIsta(int winServiceStatusId, DateTime submittionDate, out string errorMsg)
        {
            var recordsToProcess = new List<MultiTermWinServiceData>();
            bool updateSucceeded = true;
            errorMsg = string.Empty;
            try
            {
                DataSet ds = MultiTermServiceSql.GetMultiTermWinServiceDataReadyToSubmitToIstaByStatusId(winServiceStatusId, submittionDate);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        updateSucceeded = (bool)dr["UpdateSucceeded"];
                        MultiTermWinServiceData recordToProcess = GetAssignedRecord(dr);
                        recordsToProcess.Add(recordToProcess);
                    }
                }
                if (!updateSucceeded)
                {
                    errorMsg = "Cannot setup the processing status to DeEnnrolled value into MultiTermWinServiceData table at ";
                }
            }
            catch (Exception ex)
            {
                //TODO log the exeption
                errorMsg = "The following exception occers " + ex.Message + " at ";
            }
            return recordsToProcess;
        }

        public static void UpdateMultiTermWinServiceData(MultiTermWinServiceData mtwsd, int userId)
        {

            try
            {
                MultiTermServiceSql.UpdateStatusMultiTermRecord(mtwsd.RecordId, mtwsd.MultiTermWinServiceStatusId, userId);
            }
            catch (Exception ex)
            {
                //TODO log the exeption
            }
        }


        private static MultiTermWinServiceData GetAssignedRecord(DataRow dataRow)
        {
            //initiate MultyTermWinServiceData object
            MultiTermWinServiceData recordToProcess = new MultiTermWinServiceData();
            try
            {
                //assign property of MultyTermWinServiceData object
                recordToProcess.RecordId = dataRow.Field<int>("ID");
                recordToProcess.LeadTime = dataRow.Field<int>("LeadTime");
                recordToProcess.StartToSubmitDate = dataRow.Field<DateTime>("StartToSubmitDate");
                recordToProcess.ToBeExpiredAccountContactRateId = dataRow.Field<int>("ToBeExpiredAccountContactRateId");
                recordToProcess.MeterReadDate = dataRow.Field<DateTime>("MeterReadDate");
                recordToProcess.NewAccountContractRateId = dataRow.Field<int>("NewAccountContractRateId");
                recordToProcess.RateEndDateAjustedByService = dataRow.Field<bool>("RateEndDateAjustedByService");
                recordToProcess.MultiTermWinServiceStatusId = dataRow.Field<int>("MultiTermWinServiceStatusId");
                recordToProcess.ServiceLastRunDate = dataRow.Field<DateTime?>("ServiceLastRunDate");
                recordToProcess.DateCreated = dataRow.Field<DateTime>("DateCreated");
                recordToProcess.CreatedBy = dataRow.Field<int>("CreatedBy");
                recordToProcess.DateModified = dataRow.Field<DateTime?>("DateModified");
                recordToProcess.ModifiedBy = dataRow.Field<int?>("ModifiedBy");
				//----------Reenrollment implementation PBI1004 task4700 start here ------
				recordToProcess.ReenrollmentFollowingMeterDate = dataRow.Field<DateTime?>("ReenrollmentFollowingMeterDate");
				//----------Reenrollment implementation PBI1004 task4700 end here ------
            }
            catch (Exception ex)
            {
                //TODO log the exeption
            }
            //return object
            return recordToProcess;
        }
    }
}
