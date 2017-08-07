using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PECommentSql
    {
        /// <summary>
        /// Inserts a Comment
        /// </summary>
        /// <param name=Comment></param>
        public static int InsertComment( String dataSetName, String source, String sourceVersion, String analysisMethod, String analyst, String comment, int uploadedCurveFilesId )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PECommentInsert";

                    cmd.Parameters.Add(new SqlParameter("@DataSetName", dataSetName));
                    cmd.Parameters.Add(new SqlParameter("@Source", source));
                    cmd.Parameters.Add(new SqlParameter("@SourceVersion", sourceVersion));
                    cmd.Parameters.Add(new SqlParameter("@AnalysisMethod", analysisMethod));
                    cmd.Parameters.Add(new SqlParameter("@Analyst", analyst));
                    cmd.Parameters.Add(new SqlParameter("@Comment", comment));
                    cmd.Parameters.Add( new SqlParameter("@UploadedCurveFilesId", uploadedCurveFilesId ) );
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());

                }
            }
        }
    }
}

