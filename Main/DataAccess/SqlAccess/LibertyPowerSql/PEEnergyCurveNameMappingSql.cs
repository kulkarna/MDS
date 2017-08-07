using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEEnergyCurveNameMappingSql
    {

        /// <summary>
        /// Selects an EnergyCurveNameMapping
        /// </summary>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectEnergyCurveNameMapping()
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyCurveNameMappingSelectList";
                   
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts an EnergyCurveNameMapping
        /// </summary>
        /// <param name=EnergyCurveNameMapping></param>
        public static int InsertEnergyCurveNameMapping(string curveName, string curveType, string zoneId, char activeFlag)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyCurveNameMappingInsert";

                    cmd.Parameters.Add(new SqlParameter("@CurveName", curveName));
                    cmd.Parameters.Add(new SqlParameter("@CurveType", curveType));
                    cmd.Parameters.Add( new SqlParameter( "@ZoneId", zoneId ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        public static void UpdateEnergyCurveNameMapping( int id, char activeFlag )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEEnergyCurveNameMappingUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@Id", id ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }
    }
}

