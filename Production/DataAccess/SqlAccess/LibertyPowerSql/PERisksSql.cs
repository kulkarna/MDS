using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PERisksSql
    {

        /// <summary>
        /// Selects a Risks
        /// </summary>
        /// <param name=RisksId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectRisks(Int32 risksId, Decimal markToMarketEnergyAdder, Decimal markToMarketEnergyLossAdder, Decimal arCreditReserve, Decimal markToMarketEnergyCreditReserve, Decimal markToMarketEnergyLossCreditReserve, Decimal executionRiskEnergy, Decimal executionRiskEnergyLoss, Decimal bandwidthPremium)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PERisksSelect";

                    cmd.Parameters.Add(new SqlParameter("@RisksId", risksId));
                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketEnergyAdder", markToMarketEnergyAdder));
                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketEnergyLossAdder", markToMarketEnergyLossAdder));
                    cmd.Parameters.Add(new SqlParameter("@ArCreditReserve", arCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketEnergyCreditReserve", markToMarketEnergyCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketEnergyLossCreditReserve", markToMarketEnergyLossCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@ExecutionRiskEnergy", executionRiskEnergy));
                    cmd.Parameters.Add(new SqlParameter("@ExecutionRiskEnergyLoss", executionRiskEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@BandwidthPremium", bandwidthPremium));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a Risks
        /// </summary>
        /// <param name=Risks></param>
        public static int InsertRisks(Decimal markToMarketEnergyAdder, Decimal markToMarketEnergyLossAdder, Decimal arCreditReserve, Decimal markToMarketEnergyCreditReserve, Decimal markToMarketEnergyLossCreditReserve, Decimal executionRiskEnergy, Decimal executionRiskEnergyLoss, Decimal bandwidthPremium)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PERisksInsert";

                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketEnergyAdder", markToMarketEnergyAdder));
                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketEnergyLossAdder", markToMarketEnergyLossAdder));
                    cmd.Parameters.Add(new SqlParameter("@ArCreditReserve", arCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketEnergyCreditReserve", markToMarketEnergyCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketEnergyLossCreditReserve", markToMarketEnergyLossCreditReserve));
                    cmd.Parameters.Add(new SqlParameter("@ExecutionRiskEnergy", executionRiskEnergy));
                    cmd.Parameters.Add(new SqlParameter("@ExecutionRiskEnergyLoss", executionRiskEnergyLoss));
                    cmd.Parameters.Add(new SqlParameter("@BandwidthPremium", bandwidthPremium));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        public static DataSet GetAllBandwidths( )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PERisksBandwidthPremiumSelect";

                    using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
                    {
                        da.Fill( ds );
                    }
                }
            }
            return ds;
        }
    }
}

