using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEEnergyCostsSql
    {

        /// <summary>
        /// Selects an EnergyCosts
        /// </summary>
        /// <param name=EnergyCostsId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectEnergyCosts(Int32 energyCostsId, Decimal peakBlockEnergy, Decimal offPeakBlockEnergy, Decimal peakSupplierPremium, Decimal offPeakSupplierPremium, Decimal peakShapingPremium, Decimal offPeakShapingPremium, Decimal peakIntradayAdjustment, Decimal offPeakIntradayAdjustment, Decimal peakEnergyLoss, Decimal offPeakEnergyLoss)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyCostsSelect";

                    cmd.Parameters.Add(new SqlParameter("@EnergyCostsId", energyCostsId));
                    cmd.Parameters.Add(new SqlParameter("@PeakBlockEnergy", peakBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakBlockEnergy", offPeakBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@PeakSupplierPremium", peakSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakSupplierPremium", offPeakSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@PeakShapingPremium", peakShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakShapingPremium", offPeakShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@PeakIntradayAdjustment", peakIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakIntradayAdjustment", offPeakIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@PeakEnergyLoss", peakEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakEnergyLoss", offPeakEnergyLoss));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an EnergyCosts
        /// </summary>
        /// <param name=EnergyCosts></param>
        public static int InsertEnergyCosts(Decimal peakBlockEnergy, Decimal offPeakBlockEnergy, Decimal peakSupplierPremium, Decimal offPeakSupplierPremium, Decimal peakShapingPremium, Decimal offPeakShapingPremium, Decimal peakIntradayAdjustment, Decimal offPeakIntradayAdjustment, Decimal peakEnergyLoss, Decimal offPeakEnergyLoss)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyCostsInsert";

                    cmd.Parameters.Add(new SqlParameter("@PeakBlockEnergy", peakBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakBlockEnergy", offPeakBlockEnergy));
                    cmd.Parameters.Add(new SqlParameter("@PeakSupplierPremium", peakSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakSupplierPremium", offPeakSupplierPremium));
                    cmd.Parameters.Add(new SqlParameter("@PeakShapingPremium", peakShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakShapingPremium", offPeakShapingPremium));
                    cmd.Parameters.Add(new SqlParameter("@PeakIntradayAdjustment", peakIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakIntradayAdjustment", offPeakIntradayAdjustment));
                    cmd.Parameters.Add(new SqlParameter("@PeakEnergyLoss", peakEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@OffPeakEnergyLoss", offPeakEnergyLoss));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

