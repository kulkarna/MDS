using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    [Serializable]
    public static class PEPricingComponentsConfigurationSql
    {           
		/// <summary>
		/// Selects All the pricing components descriptions
		/// </summary>
		/// <returns></returns>
		public static DataSet SelectPricingComponentDescriptions()
		{
			DataSet ds = new DataSet();
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEPricingComponentsDescriptionSelect";
					
					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Selects All the pricing components per market 
		/// </summary>
		/// <returns>Returns a Dataset with the active Pricing Components Per market</returns>
		public static DataSet SelectPricingComponentPermarket(string marketCode)
		{
			DataSet ds = new DataSet();
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEPricingComponentsPerMarketSelect";
					cmd.Parameters.Add(new SqlParameter("@market_code", marketCode));

					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts the Pricing Components Per Market Header
		/// </summary>
		/// <param name="MarketCode">Market code</param>
		/// <param name="DateCreated">Date Created</param>
		/// <param name="Status">Status (A-Active, I-Inactive)</param>
		/// <returns>identity value</returns>
		public static int InsertPricingComponentsPerMarketHeader(string MarketCode, DateTime DateCreated, string Status)
		{
			DataSet ds = new DataSet();
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEPricingComponentsPerMarketHeaderInsert";

					cmd.Parameters.Add(new SqlParameter("@MarketCode", MarketCode));
					cmd.Parameters.Add(new SqlParameter("@DateCreated", DateCreated));
					cmd.Parameters.Add(new SqlParameter("@Status", Status));

					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return Convert.ToInt32(ds.Tables[0].Rows[0][0]);
		}

		/// <summary>
		/// Inserts the pricing components per market details
		/// </summary>
		/// <param name="headerId">Pricing Component Header Id</param>
		/// <param name="descriptionId">Pricing Component Description Id</param>
		/// <param name="allowPassthrough">Allow passthrough or not</param>
		/// <returns>identity value</returns>
		public static int InsertPricingComponentsPerMarketDetail(int headerId, int descriptionId, bool allowPassthrough)
		{
			DataSet ds = new DataSet();
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEPricingComponentsPerMarketDetailInsert";

					cmd.Parameters.Add(new SqlParameter("@PricingComponentsPerMarketHeaderId", headerId));
					cmd.Parameters.Add(new SqlParameter("@PricingComponentDescriptionId", descriptionId));
					cmd.Parameters.Add(new SqlParameter("@AllowPassthrough", allowPassthrough));

					using (SqlDataAdapter da = new SqlDataAdapter(cmd))
					{
						da.Fill(ds);
					}
				}
			}
			return Convert.ToInt32(ds.Tables[0].Rows[0][0]);
		}

		/// <summary>
		/// Updates the status of the Pricing Components configuration per Market to A-Active or I-Inactive 
		/// </summary>
		/// <param name="id">Id of the PEPricingComponentPerMarketHeader</param>
		/// <param name="status">A or I</param>
		public static void UpdatePricingComponentsPerMarketHeader(int id, string status)
		{
			using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PEPricingComponentsPerMarketHeaderUpdateStatus";

                    cmd.Parameters.Add( new SqlParameter( "@PricingComponentPerMarketHeaderId", id ) );
                    cmd.Parameters.Add(new SqlParameter("@Status", status));

					conn.Open();
					cmd.ExecuteNonQuery();
					conn.Close();
				}
			}
		}
	}
}
