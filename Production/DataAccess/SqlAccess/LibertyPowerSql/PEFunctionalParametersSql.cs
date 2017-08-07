using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEFunctionalParametersSql
    {

        /// <summary>
        /// Selects a FunctionalParameters
        /// </summary>
        /// <param name=FunctionalParametersId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectFunctionalParameters()
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEFunctionalParametersConfigurationSelect";
					                    
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a FunctionalParameters
        /// </summary>
        /// <param name=FunctionalParameters></param>
        public static int InsertFunctionalParametersConfiguration(DateTime effectiveDate, decimal wacc, Int32 minimumCurveDuration, string oeMailingList, Int32 executionRiskTimeWindow, decimal arCreditRiskPolicyFactor, decimal markToMarketCreditRiskPolicyFactor, char activeFlag)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEFunctionalParametersConfigurationInsert";

                    cmd.Parameters.Add(new SqlParameter("@EffectiveDate", effectiveDate));
					cmd.Parameters.Add(new SqlParameter("@WeightedAverageCostCapital", wacc));
                    cmd.Parameters.Add(new SqlParameter("@MinimumCurveDuration", minimumCurveDuration));
                    cmd.Parameters.Add(new SqlParameter("@OeMailingList", oeMailingList));
                    cmd.Parameters.Add(new SqlParameter("@ExecutionRiskTimeWindow", executionRiskTimeWindow));
                    cmd.Parameters.Add(new SqlParameter("@ArCreditRiskPolicyFactor", arCreditRiskPolicyFactor));
                    cmd.Parameters.Add(new SqlParameter("@MarkToMarketCreditRiskPolicyFactor", markToMarketCreditRiskPolicyFactor));
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );
                    
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        /// <summary>
        /// Updates a FunctionalParameters.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="activeFlag"></param>
        public static void UpdateFunctionalParameters( int id, char activeFlag )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEFunctionalParametersConfigurationUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@Id", id ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }
     
    }
}

