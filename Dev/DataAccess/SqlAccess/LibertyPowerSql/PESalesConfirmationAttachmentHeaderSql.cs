using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PESalesConfirmationAttachmentHeaderSql
    {

        /// <summary>
        /// Selects a SalesConfirmationAttachmentHeader
        /// </summary>
        /// <param name=SalesConfirmationAttachmentHeaderId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectSalesConfirmationAttachmentHeader(Int32 salesConfirmationAttachmentHeaderId, Int32 offerId, DateTime expirationTime, String customerName )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESalesConfirmationAttachmentHeaderSelect";

                    cmd.Parameters.Add(new SqlParameter("@SalesConfirmationAttachmentHeaderId", salesConfirmationAttachmentHeaderId));
                    cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
                    cmd.Parameters.Add(new SqlParameter("@ExpirationTime", expirationTime));
                    cmd.Parameters.Add(new SqlParameter("@CustomerName", customerName));
                     

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a SalesConfirmationAttachmentHeader
        /// </summary>
        /// <param name=SalesConfirmationAttachmentHeader></param>
        public static int InsertSalesConfirmationAttachmentHeader(Int32 offerId, DateTime expirationTime, String customerName )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESalesConfirmationAttachmentHeaderInsert";

                    cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
                    cmd.Parameters.Add(new SqlParameter("@ExpirationTime", expirationTime));
                    cmd.Parameters.Add(new SqlParameter("@CustomerName", customerName));
                     
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

