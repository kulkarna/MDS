using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEInternalFeesSql
    {

        /// <summary>
        /// Selects an InternalFees
        /// </summary>
        /// <param name=InternalFeesId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectInternalFees(Int32 internalFeesId, Decimal schedulingFee, Decimal billingTransactionCost, Decimal porFee, Decimal financeFee, Decimal paymentTermPremium, Decimal summaryBillingPremium)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEInternalFeesSelect";

                    cmd.Parameters.Add(new SqlParameter("@InternalFeesId", internalFeesId));
                    cmd.Parameters.Add(new SqlParameter("@SchedulingFee", schedulingFee));
                    cmd.Parameters.Add(new SqlParameter("@BillingTransactionCost", billingTransactionCost));
                    cmd.Parameters.Add(new SqlParameter("@PorFee", porFee));
                    cmd.Parameters.Add(new SqlParameter("@FinanceFee", financeFee));
                    cmd.Parameters.Add(new SqlParameter("@PaymentTermPremium", paymentTermPremium));
                    cmd.Parameters.Add(new SqlParameter("@SummaryBillingPremium", summaryBillingPremium));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an InternalFees
        /// </summary>
        /// <param name=InternalFees></param>
        public static int InsertInternalFees(Decimal schedulingFee, Decimal billingTransactionCost, Decimal porFee, Decimal financeFee, Decimal paymentTermPremium, Decimal summaryBillingPremium)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEInternalFeesInsert";

                    cmd.Parameters.Add(new SqlParameter("@SchedulingFee", schedulingFee));
                    cmd.Parameters.Add(new SqlParameter("@BillingTransactionCost", billingTransactionCost));
                    cmd.Parameters.Add(new SqlParameter("@PorFee", porFee));
                    cmd.Parameters.Add(new SqlParameter("@FinanceFee", financeFee));
                    cmd.Parameters.Add(new SqlParameter("@PaymentTermPremium", paymentTermPremium));
                    cmd.Parameters.Add(new SqlParameter("@SummaryBillingPremium", summaryBillingPremium));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

