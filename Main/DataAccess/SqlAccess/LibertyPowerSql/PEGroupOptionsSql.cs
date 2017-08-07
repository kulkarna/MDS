using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEGroupOptionsSql
    {

        /// <summary>
        /// Selects a GroupOptions
        /// </summary>
        /// <param name=GroupOptionsId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectGroupOptions(Int32 iD, Int32 sortOrder, String name, String propertyName)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEGroupOptionsSelect";

                    cmd.Parameters.Add(new SqlParameter("@ID", iD));
                    cmd.Parameters.Add(new SqlParameter("@SortOrder", sortOrder));
                    cmd.Parameters.Add(new SqlParameter("@Name", name));
                    cmd.Parameters.Add(new SqlParameter("@PropertyName", propertyName));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a GroupOptions
        /// </summary>
        /// <param name=GroupOptions></param>
        public static int InsertGroupOptions(Int32 sortOrder, String name, String propertyName)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEGroupOptionsInsert";

                    cmd.Parameters.Add(new SqlParameter("@SortOrder", sortOrder));
                    cmd.Parameters.Add(new SqlParameter("@Name", name));
                    cmd.Parameters.Add(new SqlParameter("@PropertyName", propertyName));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

