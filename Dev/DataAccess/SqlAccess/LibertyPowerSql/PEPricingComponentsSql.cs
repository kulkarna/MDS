using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEPricingComponentsSql
    {

        /// <summary>
        /// Selects a PricingComponents
        /// </summary>
        /// <param name=PricingComponentsId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectPricingComponents(Int32 pricingComponentsId, Int32 energyCostsId, Int32 nonEnergyCostsId, Int32 internalFeesId, Int32 risksId, Int32 addersId)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingComponentsSelect";

                    cmd.Parameters.Add(new SqlParameter("@PricingComponentsId", pricingComponentsId));
                    cmd.Parameters.Add(new SqlParameter("@EnergyCostsId", energyCostsId));
                    cmd.Parameters.Add(new SqlParameter("@NonEnergyCostsId", nonEnergyCostsId));
                    cmd.Parameters.Add(new SqlParameter("@InternalFeesId", internalFeesId));
                    cmd.Parameters.Add(new SqlParameter("@RisksId", risksId));
                    cmd.Parameters.Add(new SqlParameter("@AddersId", addersId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a PricingComponents
        /// </summary>
        /// <param name=PricingComponents></param>
        public static int InsertPricingComponents(Int32 energyCostsId, Int32 nonEnergyCostsId, Int32 internalFeesId, Int32 risksId, Int32 addersId)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEPricingComponentsInsert";

                    cmd.Parameters.Add(new SqlParameter("@EnergyCostsId", energyCostsId));
                    cmd.Parameters.Add(new SqlParameter("@NonEnergyCostsId", nonEnergyCostsId));
                    cmd.Parameters.Add(new SqlParameter("@InternalFeesId", internalFeesId));
                    cmd.Parameters.Add(new SqlParameter("@RisksId", risksId));
                    cmd.Parameters.Add(new SqlParameter("@AddersId", addersId));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

