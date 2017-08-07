using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class WorkflowAutoCompleteSql
    {
        public static DataSet GetAutoApprovalDocumentsConfigurations()
        {
            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AutoApproveDocumentsConfigurationSelect";

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataSet results = new DataSet();
                        adapter.Fill(results);
                        return results;
                    }
                }
            }
        }

        public static DataSet GetUserAutoApprovalDocumentsConfiguration(int UserID)
        {
            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AutoApproveDocumentsConfigurationUserSelect";
                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataSet results = new DataSet();
                        adapter.Fill(results);
                        return results;
                    }
                }
            }
        }

        public static int InsertAutoApprovalDocumentsConfiguration(int UserID, bool AutoApprove)
        {
            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AutoApproveDocumentsConfigurationInsert";
                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                    cmd.Parameters.Add(new SqlParameter("@AutoApprove", AutoApprove));

                    con.Open();
                    return int.Parse(cmd.ExecuteScalar().ToString());
                }
            }
        }

        public static void UpdateAutoApprovalDocumentsConfiguration(int UserID, bool AutoApprove)
        {
            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AutoApproveDocumentsConfigurationUpdate";
                    cmd.Parameters.Add(new SqlParameter("@UserID", UserID));
                    cmd.Parameters.Add(new SqlParameter("@AutoApprove", AutoApprove));

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
