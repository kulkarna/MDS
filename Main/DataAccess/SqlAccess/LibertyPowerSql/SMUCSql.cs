using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
  public static class  SMUCSql
    {
        // ------------------------------------------------------------------------------------
        /// <summary>
        /// 
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityCode"></param>
      
        /// <returns>DataSet</returns>
        public static DataSet GetAccountDetailsByUtilityCode(string  accountNumber,string utilityCode)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Usp_GetAccountDetailsByUtilityCode";

                    cmd.Parameters.Add(new SqlParameter("AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("UtilityCode", utilityCode));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }

            return ds;
        }

    }
}
