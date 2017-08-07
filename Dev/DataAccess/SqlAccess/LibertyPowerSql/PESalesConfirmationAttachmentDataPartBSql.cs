using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PESalesConfirmationAttachmentDataPartBSql
    {

        /// <summary>
        /// Selects a SalesConfirmationAttachmentDataPartB
        /// </summary>
        /// <param name=SalesConfirmationAttachmentDataPartBId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectSalesConfirmationAttachmentDataPartB(Int32 salesConfirmationAttachmentDataPartBId, String utilityCode, String deliveryPoint, Int32 month, Int32 year, Decimal icap, Decimal peak, Decimal offPeak, Decimal atc )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESalesConfirmationAttachmentDataPartBSelect";

                    cmd.Parameters.Add(new SqlParameter("@SalesConfirmationAttachmentDataPartBId", salesConfirmationAttachmentDataPartBId));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@DeliveryPoint", deliveryPoint));
                    cmd.Parameters.Add(new SqlParameter("@Month", month));
                    cmd.Parameters.Add(new SqlParameter("@Year", year));
                    cmd.Parameters.Add(new SqlParameter("@Icap", icap));
                    cmd.Parameters.Add(new SqlParameter("@Peak", peak));
                    cmd.Parameters.Add(new SqlParameter("@OffPeak", offPeak));
                    cmd.Parameters.Add(new SqlParameter("@Atc", atc));
                     

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a SalesConfirmationAttachmentDataPartB
        /// </summary>
        /// <param name=SalesConfirmationAttachmentDataPartB></param>
        public static int InsertSalesConfirmationAttachmentDataPartB(String utilityCode, String deliveryPoint, Int32 month, Int32 year, Decimal icap, Decimal peak, Decimal offPeak, Decimal atc )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESalesConfirmationAttachmentDataPartBInsert";

                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@DeliveryPoint", deliveryPoint));
                    cmd.Parameters.Add(new SqlParameter("@Month", month));
                    cmd.Parameters.Add(new SqlParameter("@Year", year));
                    cmd.Parameters.Add(new SqlParameter("@Icap", icap));
                    cmd.Parameters.Add(new SqlParameter("@Peak", peak));
                    cmd.Parameters.Add(new SqlParameter("@OffPeak", offPeak));
                    cmd.Parameters.Add(new SqlParameter("@Atc", atc));
                     
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

