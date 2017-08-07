using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEOfferDocumentDataSql
    {

        /// <summary>
        /// Selects an OfferDocumentData
        /// </summary>
        /// <param name=OfferDocumentDataId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectOfferDocumentData(Int32 offerDocumentDataId, Int32 contractPriceId, DateTime flowStart, Int32 term, String group, String utilityList, String numberOfAccounts, Decimal price, Decimal termUsage, Decimal termPeakUsage, Decimal termOffPeakUsage )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOfferDocumentDataSelect";

                    cmd.Parameters.Add(new SqlParameter("@OfferDocumentDataId", offerDocumentDataId));
                    cmd.Parameters.Add(new SqlParameter("@ContractPriceId", contractPriceId));
                    cmd.Parameters.Add(new SqlParameter("@FlowStart", flowStart));
                    cmd.Parameters.Add(new SqlParameter("@Term", term));
                    cmd.Parameters.Add(new SqlParameter("@Group", group));
                    cmd.Parameters.Add(new SqlParameter("@UtilityList", utilityList));
                    cmd.Parameters.Add(new SqlParameter("@NumberOfAccounts", numberOfAccounts));
                    cmd.Parameters.Add(new SqlParameter("@Price", price));
                    cmd.Parameters.Add(new SqlParameter("@TermUsage", termUsage));
                    cmd.Parameters.Add(new SqlParameter("@TermPeakUsage", termPeakUsage));
                    cmd.Parameters.Add(new SqlParameter("@TermOffPeakUsage", termOffPeakUsage));
                     

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an OfferDocumentData
        /// </summary>
        /// <param name=OfferDocumentData></param>
        public static int InsertOfferDocumentData(Int32 contractPriceId, DateTime flowStart, Int32 term, String group, String utilityList, String numberOfAccounts, Decimal price, Decimal termUsage, Decimal termPeakUsage, Decimal termOffPeakUsage )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEOfferDocumentDataInsert";

                    cmd.Parameters.Add(new SqlParameter("@ContractPriceId", contractPriceId));
                    cmd.Parameters.Add(new SqlParameter("@FlowStart", flowStart));
                    cmd.Parameters.Add(new SqlParameter("@Term", term));
                    cmd.Parameters.Add(new SqlParameter("@Group", group));
                    cmd.Parameters.Add(new SqlParameter("@UtilityList", utilityList));
                    cmd.Parameters.Add(new SqlParameter("@NumberOfAccounts", numberOfAccounts));
                    cmd.Parameters.Add(new SqlParameter("@Price", price));
                    cmd.Parameters.Add(new SqlParameter("@TermUsage", termUsage));
                    cmd.Parameters.Add(new SqlParameter("@TermPeakUsage", termPeakUsage));
                    cmd.Parameters.Add(new SqlParameter("@TermOffPeakUsage", termOffPeakUsage));
                     
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

