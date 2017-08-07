using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PESupplyQuoteSupplierSql
    {

        /// <summary>
        /// Selects a DataValidation
        /// </summary>
        /// <param name=DataValidationId></param>
        /// <returns>A dataset with all attributes</returns>
        public static DataSet SelectSupplyQuoteSupplierList()
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESupplyQuoteSupplierSelectList";

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
       /// <summary>
        /// Inserts a new supplierQuoteSupplier
       /// </summary>
       /// <param name="supplierQuoteSupplier"></param>
       /// <param name="activeFlag"></param>
       /// <returns></returns>
        public static int InsertSupplyQuoteSupplier( string supplyQuoteSupplier )
        {
            DataSet ds = new DataSet();
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_PESupplyQuoteSupplierInsert";

                    cmd.Parameters.Add( new SqlParameter( "@SupplyQuoteSupplier", supplyQuoteSupplier ) );

                    conn.Open();
                    return Convert.ToInt32( cmd.ExecuteScalar() );

                }
            }
        }

       
    }
}

