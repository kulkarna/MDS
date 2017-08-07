using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PENonEnergyCostsSql
    {

        /// <summary>
        /// Selects a NonEnergyCosts
        /// </summary>
        /// <param name=NonEnergyCostsId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectNonEnergyCosts(Int32 nonEnergyCostsId, String ancillaryService, String replacementReserve, Decimal renewablePortfolioStandardPrice, Decimal voluntaryRenewablesPrice, Decimal uCap, Decimal tCap, Decimal arrCharge)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PENonEnergyCostsSelect";

                    cmd.Parameters.Add(new SqlParameter("@NonEnergyCostsId", nonEnergyCostsId));
                    cmd.Parameters.Add(new SqlParameter("@AncillaryService", ancillaryService));
                    cmd.Parameters.Add(new SqlParameter("@ReplacementReserve", replacementReserve));
                    cmd.Parameters.Add(new SqlParameter("@RenewablePortfolioStandardPrice", renewablePortfolioStandardPrice));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewablesPrice", voluntaryRenewablesPrice));
                    cmd.Parameters.Add(new SqlParameter("@UCap", uCap));
                    cmd.Parameters.Add(new SqlParameter("@TCap", tCap));
                    cmd.Parameters.Add(new SqlParameter("@ArrCharge", arrCharge));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a NonEnergyCosts
        /// </summary>
        /// <param name=NonEnergyCosts></param>
        public static int InsertNonEnergyCosts(String ancillaryService, String replacementReserve, Decimal renewablePortfolioStandardPrice, Decimal voluntaryRenewablesPrice, Decimal uCap, Decimal tCap, Decimal arrCharge)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PENonEnergyCostsInsert";

                    cmd.Parameters.Add(new SqlParameter("@AncillaryService", ancillaryService));
                    cmd.Parameters.Add(new SqlParameter("@ReplacementReserve", replacementReserve));
                    cmd.Parameters.Add(new SqlParameter("@RenewablePortfolioStandardPrice", renewablePortfolioStandardPrice));
                    cmd.Parameters.Add(new SqlParameter("@VoluntaryRenewablesPrice", voluntaryRenewablesPrice));
                    cmd.Parameters.Add(new SqlParameter("@UCap", uCap));
                    cmd.Parameters.Add(new SqlParameter("@TCap", tCap));
                    cmd.Parameters.Add(new SqlParameter("@ArrCharge", arrCharge));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

