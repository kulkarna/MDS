using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class PEOfferPricingComponentsPassthroughSql
	{
		/// <summary>
		/// Selects the records of the PEOfferPricingComponentsPassthrough table
		/// </summary>
		/// <param name="offerId">Offer Id</param>
		/// <returns>Dataset </returns>
		public static DataSet SelectOfferPricingComponentsPassthrough(string offerId)
		{
			DataSet ds = new DataSet();

			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEOfferPricingComponentsPassthroughSelect";

					cmd.Parameters.Add(new SqlParameter("@offerId", offerId));

					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
						da.Fill(ds);
				}
			}
			return ds;
		}
		/// <summary>
		/// Inserts a record into table PEOfferPricingComponentspassthrough
		/// </summary>
		/// <param name="offerId">Offer Id</param>
		/// <param name="descriptionId">PEPricingComponentDescription Id</param>
		/// <param name="passthrough">True or False</param>
		/// <returns>Record identity</returns>
		public static int InsertOfferPricingComponentPassthrough(string offerId, int descriptionId, bool passthrough)
		{
			DataSet ds = new DataSet();
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEOfferPricingComponentsPassthroughInsert";

					cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));
					cmd.Parameters.Add(new SqlParameter("@PricingComponentDescriptionId", descriptionId));
					cmd.Parameters.Add(new SqlParameter("@Passthrough", passthrough));

					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return Convert.ToInt32(ds.Tables[0].Rows[0][0]);
		}

		/// <summary>
		/// Deletes all records from PEOfferPricingComponentspassthrough given an offer Id
		/// </summary>
		/// <param name="offerId">Offer Id</param>
		public static void DeleteOfferPricingComponentsPassthroughs(string offerId)
		{
			
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEOfferPricingComponentsPassthroughDelete";

					cmd.Parameters.Add(new SqlParameter("@OfferId", offerId));

					conn.Open();
					cmd.ExecuteNonQuery();
					conn.Close();
				}
			}
			
		}
	}


}
