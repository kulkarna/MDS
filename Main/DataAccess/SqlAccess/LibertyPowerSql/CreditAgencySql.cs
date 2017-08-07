using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public class CreditAgencySql
    {
        /// <summary>
        /// Get the Credit Agency´s Dataset
        /// </summary>
        /// <returns>DataSet</returns>
        public static DataSet GetCreditAgencyList()
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditAgencySelectList";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.Fill(ds);
                }
            }
            return ds;
        }
        /// <summary>
        /// Get the Credit Agency by Id
        /// </summary>
        /// <param name="id">Id</param>
        /// <returns>Dataset</returns>
        public static DataSet GetCreditAgency(int id)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditAgencySelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@p_CreditAgencyID", id);
                    da.Fill(ds);
                }
            }
            return ds;
        }

		/// <summary>
		/// Get the Credit Agency by Code
		/// </summary>
		/// <param name="creditAgencyCode"></param>
		/// <returns>Dataset</returns>
		public static DataSet GetCreditAgency(string creditAgencyCode)
		{
			string connStr = Helper.ConnectionString;
			DataSet ds = new DataSet();

			using (SqlConnection connection = new SqlConnection(connStr))
			{
				string SQL = "usp_CreditAgencySelect_byCode";
				using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
				{
					da.SelectCommand.CommandType = CommandType.StoredProcedure;
					da.SelectCommand.Parameters.AddWithValue("@p_code", creditAgencyCode);
					da.Fill(ds);
				}
			}
			return ds;
		}
        
        
        /// <summary>
        /// Gets the Credit Ratings Dataset
        /// </summary>
        /// <param name="CreditAgencyID">Agency´s ID</param>
        /// <param name="order">0=ascending, 1=Descending</param>
        /// <returns></returns>
        public static DataSet GetCreditRatings(int CreditAgencyID, int order)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditRatingSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@CreditAgencyID",CreditAgencyID);
                    da.SelectCommand.Parameters.AddWithValue("@order", order);
                    da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets the list of Score Ranges of an agency
        /// </summary>
        /// <param name="agencyID">Id</param>
        /// <returns>Datase</returns>
        public static DataSet GetCreditScoreRanges(int agencyID)
        {
            string connStr = Helper.ConnectionString;
            DataSet ds = new DataSet();

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                string SQL = "usp_CreditScoreRangeSelect";
                using (SqlDataAdapter da = new SqlDataAdapter(SQL, connStr))
                {
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    da.SelectCommand.Parameters.AddWithValue("@CreditAgencyID ", agencyID);
                    da.Fill(ds);
                }
            }
            return ds;
        }
     }
}
