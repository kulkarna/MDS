using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PESalesConfirmationAttachmentDataPartASql
    {

        /// <summary>
        /// Selects a SalesConfirmationAttachmentDataPartA
        /// </summary>
        /// <param name=SalesConfirmationAttachmentDataPartAId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectSalesConfirmationAttachmentDataPartA(Int32 salesConfirmationAttachmentDataPartAId, Int32 contractPriceId, String accountNumber, String utilityCode, String deliveryPoint, String voltage, String serviceClass, String serviceAddress, String city, String state, String zipCode, Decimal currentIcap, Decimal annualAnticipatedRetailUsage, DateTime startDate, DateTime endDate, Decimal voluntaryGreen, Decimal contractPrice )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESalesConfirmationAttachmentDataPartASelect";

                    cmd.Parameters.Add(new SqlParameter("@SalesConfirmationAttachmentDataPartAId", salesConfirmationAttachmentDataPartAId));
                    cmd.Parameters.Add(new SqlParameter("@ContractPriceId", contractPriceId));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@DeliveryPoint", deliveryPoint));
                    cmd.Parameters.Add(new SqlParameter("@Voltage", voltage));
                    cmd.Parameters.Add(new SqlParameter("@ServiceClass", serviceClass));
                    cmd.Parameters.Add(new SqlParameter("@ServiceAddress", serviceAddress));
                    cmd.Parameters.Add(new SqlParameter("@City", city));
                    cmd.Parameters.Add(new SqlParameter("@State", state));
                    cmd.Parameters.Add(new SqlParameter("@ZipCode", zipCode));
                    cmd.Parameters.Add(new SqlParameter("@CurrentIcap", currentIcap));
                    cmd.Parameters.Add(new SqlParameter("@AnnualAnticipatedRetailUsage", annualAnticipatedRetailUsage));
                    cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryGreen", voluntaryGreen));
                    cmd.Parameters.Add(new SqlParameter("@ContractPrice", contractPrice));
                     

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a SalesConfirmationAttachmentDataPartA
        /// </summary>
        /// <param name=SalesConfirmationAttachmentDataPartA></param>
        public static int InsertSalesConfirmationAttachmentDataPartA(Int32 contractPriceId, String accountNumber, String utilityCode, String deliveryPoint, String voltage, String serviceClass, String serviceAddress, String city, String state, String zipCode, Decimal currentIcap, Decimal annualAnticipatedRetailUsage, DateTime startDate, DateTime endDate, Decimal voluntaryGreen, Decimal contractPrice )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESalesConfirmationAttachmentDataPartAInsert";

                    cmd.Parameters.Add(new SqlParameter("@ContractPriceId", contractPriceId));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@DeliveryPoint", deliveryPoint));
                    cmd.Parameters.Add(new SqlParameter("@Voltage", voltage));
                    cmd.Parameters.Add(new SqlParameter("@ServiceClass", serviceClass));
                    cmd.Parameters.Add(new SqlParameter("@ServiceAddress", serviceAddress));
                    cmd.Parameters.Add(new SqlParameter("@City", city));
                    cmd.Parameters.Add(new SqlParameter("@State", state));
                    cmd.Parameters.Add(new SqlParameter("@ZipCode", zipCode));
                    cmd.Parameters.Add(new SqlParameter("@CurrentIcap", currentIcap));
                    cmd.Parameters.Add(new SqlParameter("@AnnualAnticipatedRetailUsage", annualAnticipatedRetailUsage));
                    cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryGreen", voluntaryGreen));
                    cmd.Parameters.Add(new SqlParameter("@ContractPrice", contractPrice));
                     
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

