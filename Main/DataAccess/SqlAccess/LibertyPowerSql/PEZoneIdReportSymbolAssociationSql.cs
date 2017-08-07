using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public class PEZoneIdReportSymbolAssociationSql
    {
        /// <summary>
        /// Inserts a Association of Zone Id to  Report Symbol
        /// </summary>
        /// <param name=Comment></param>
        public static int InsertZoneIdReportSymbolAssociation( string zoneId, string snapshotSymbol, string baselineSymbol, char activeFlag )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEZoneIdReportSymbolAssociationInsert";

                    cmd.Parameters.Add( new SqlParameter( "@ZoneId", zoneId ) );
                    cmd.Parameters.Add( new SqlParameter( "@SnapshotSymbol", snapshotSymbol ) );
                    cmd.Parameters.Add( new SqlParameter( "@BaselineSymbol", baselineSymbol ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );
                    conn.Open();

                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

        public static void UpdateZoneIdReportSymbolAssociation( int id, char activeFlag )
        {
            DataSet ds = new DataSet();
            using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
            {
                using( SqlCommand cmd = new SqlCommand() )
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEZoneIdReportSymbolAssociationUpdate";

                    cmd.Parameters.Add( new SqlParameter( "@Id", id ) );
                    cmd.Parameters.Add( new SqlParameter( "@ActiveFlag", activeFlag ) );

                    conn.Open();
                    cmd.ExecuteScalar();

                }
            }
        }

        public static DataSet SelectZoneIdReportSymbolAssociation()
		{
			DataSet ds = new DataSet();
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEZoneIdReportSymbolAssociationSelectList";

					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}



    }
}
