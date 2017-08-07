using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEDataValidationSql
    {

        /// <summary>
        /// Selects a DataValidation
        /// </summary>
        /// <param name=DataValidationId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectDataValidation(Int32 dataValidationId, String parameterTableName, String parameterName, String validationMinValue, String validationMaxValue, String validationMeanValue, Int32 validationTypeId)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDataValidationSelect";

                    cmd.Parameters.Add(new SqlParameter("@DataValidationId", dataValidationId));
                    cmd.Parameters.Add(new SqlParameter("@ParameterTableName", parameterTableName));
                    cmd.Parameters.Add(new SqlParameter("@ParameterName", parameterName));
                    cmd.Parameters.Add(new SqlParameter("@ValidationMinValue", validationMinValue));
                    cmd.Parameters.Add(new SqlParameter("@ValidationMaxValue", validationMaxValue));
                    cmd.Parameters.Add(new SqlParameter("@ValidationMeanValue", validationMeanValue));
                    cmd.Parameters.Add(new SqlParameter("@ValidationTypeId", validationTypeId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        /// <summary>
        /// Inserts a DataValidation
        /// </summary>
        /// <param name=DataValidation></param>
        public static int InsertDataValidation(String parameterTableName, String parameterName, String validationMinValue, String validationMaxValue, String validationMeanValue, Int32 validationTypeId)
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PEDataValidationInsert";

                    cmd.Parameters.Add(new SqlParameter("@ParameterTableName", parameterTableName));
                    cmd.Parameters.Add(new SqlParameter("@ParameterName", parameterName));
                    cmd.Parameters.Add(new SqlParameter("@ValidationMinValue", validationMinValue));
                    cmd.Parameters.Add(new SqlParameter("@ValidationMaxValue", validationMaxValue));
                    cmd.Parameters.Add(new SqlParameter("@ValidationMeanValue", validationMeanValue));
                    cmd.Parameters.Add(new SqlParameter("@ValidationTypeId", validationTypeId));
                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }
    }
}

