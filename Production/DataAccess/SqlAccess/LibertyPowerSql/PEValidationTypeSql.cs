using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEValidationTypeSql
    {

        /// <summary>
        /// Selects a ValidationType
        /// </summary>
        /// <param name=ValidationTypeId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectValidationType(Int32 validationTypeId, String validationTypeDescription)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEValidationTypeSelect";

                    cmd.Parameters.Add(new SqlParameter("@ValidationTypeId", validationTypeId));
                    cmd.Parameters.Add(new SqlParameter("@ValidationTypeDescription", validationTypeDescription));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a ValidationType
        /// </summary>
        /// <param name=ValidationType></param>
        public static int InsertValidationType(String validationTypeDescription)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEValidationTypeInsert";

                    cmd.Parameters.Add(new SqlParameter("@ValidationTypeDescription", validationTypeDescription));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

