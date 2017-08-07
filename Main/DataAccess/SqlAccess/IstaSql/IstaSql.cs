using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.IstaSql
{
    /// <summary>
    /// ISTA related methods
    /// </summary>
    public static class IstaSql
    {

        /// <summary>
        /// Gets the ISTA custid for a Liberty Power account number
        /// Use GetCustIDByAccountNumberAndUtility
        /// </summary>
        /// <param name="accountNumber">Liberty Power account number</param>
        /// <returns>Returns the ISTA custid</returns>
        [Obsolete]
        public static Object GetCustIDByAccountNumber(string accountNumber)
        {
            Object custID = null;

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetCustIDByAccountNumber";
                    cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    cn.Open();

                    custID = cmd.ExecuteScalar();

                }
            }

            return custID;
        }

        /// <summary>
        /// Gets the ISTA custid for a Liberty Power account number
        /// </summary>
        /// <param name="accountNumber">Liberty Power account number</param>
        /// <param name="utilityId">Utility of the account</param>
        /// <returns>Returns the ISTA custid</returns>
        public static Object GetCustIDByAccountAndUtility(string accountNumber, string utilityId)
        {
            Object custID = null;

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetCustIDByAccountNumberAndUtility";
                    cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityId", utilityId));

                    cn.Open();

                    custID = cmd.ExecuteScalar();

                }
            }

            return custID;
        }

        /// <summary>
        /// Returns a row corresponding to an Ista customer given an LPC account number
        /// </summary>
        /// <param name="lpcAccountNumber"></param>
        /// <returns></returns>
        public static DataSet GetIstaCustomer(string lpcAccountNumber)
        {

            DataSet ds = new DataSet();
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_IstaCustomerSelect";
                    cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@p_account_number", lpcAccountNumber));
                    
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        /// <summary>
        /// Returns the class id given an account number
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityId"></param>
        /// <returns></returns>
        public static Object GetClassIdByAccountAndUtility(string accountNumber, string utilityId)
        {
            Object custID = null;

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetClassIdByAccountNumberAndUtility";
                    cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityId", utilityId));

                    cn.Open();

                    custID = cmd.ExecuteScalar();

                }
            }

            return custID;
        }

    }
}
