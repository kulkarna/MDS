using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using LibertyPower.Business.CustomerAcquisition.DailyPricing;
using LibertyPower.Business.CustomerAcquisition.SalesChannel;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace FrameworkTest
{
	[TestClass]
	public class BackFillSalesChannelPrices
	{
		string connStrWorkSpace = "Data Source=LPCD7X64-010;Initial Catalog=Workspace;Integrated Security=SSPI";

		[TestMethod]
		public void FillPrices()
		{
			try
			{
				int backFillPriceDateID = 0;
				DateTime priceDate = DateTime.MinValue;

				InitializeData();

				while( GetPriceDate( out backFillPriceDateID, out priceDate ) )
				{
					SalesChannel salesChannel = null;
					while( GetSalesChannel( out salesChannel ) )
					{
						int channelID = salesChannel.ChannelID;
						PricingSheetFactory.CreatePricesForSalesChannelForDate( salesChannel, priceDate, 5, 10000, true );

						// set channel to complete
						UpdateSalesChannel( channelID, 1 );
					}

					// set date to complete
					UpdatePriceDate( backFillPriceDateID, 1 );
				}
			}
			catch( Exception ex )
			{
				File.WriteAllText( "error.txt", String.Concat( "Error: ", ex.Message, Environment.NewLine, Environment.NewLine, "Stack Trace:", Environment.NewLine, Environment.NewLine, ex.StackTrace ) );
				return;
			}
		}

		private void InitializeData()
		{
			using( SqlConnection cn = new SqlConnection( connStrWorkSpace ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BackFillPriceDatesInsert";

					cn.Open();
					cmd.ExecuteNonQuery();

					cmd.CommandText = "usp_BackFillSalesChannelInsert";
					cmd.ExecuteNonQuery();
				}
			}
		}

		private bool GetPriceDate( out int backFillPricesID, out DateTime priceDate )
		{
			DataSet ds = new DataSet();
			backFillPricesID = 0;
			priceDate = DateTime.MinValue;

			using( SqlConnection cn = new SqlConnection( connStrWorkSpace ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BackFillPriceDatesSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			if( DataSetHelper.HasRow( ds ) )
			{
				backFillPricesID = Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] );
				priceDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["WorkDay"] );
				return true;
			}
			return false;
		}

		private bool GetSalesChannel( out SalesChannel salesChannel )
		{
			salesChannel = null;
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( connStrWorkSpace ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BackFillSalesChannelSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			if( DataSetHelper.HasRow( ds ) )
			{
				int channelID = Convert.ToInt32( ds.Tables[0].Rows[0]["ChannelID"] );
				salesChannel = SalesChannelFactory.GetSalesChannel( channelID );
				return true;
			}
			return false;
		}

		private void UpdateSalesChannel( int channelID, int isComplete )
		{
			using( SqlConnection cn = new SqlConnection( connStrWorkSpace ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BackFillSalesChannelUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ChannelID", channelID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsComplete", isComplete ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		private void UpdatePriceDate( int backFillPriceDateID, int isComplete )
		{
			using( SqlConnection cn = new SqlConnection( connStrWorkSpace ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BackFillPriceDatesUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ID", backFillPriceDateID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsComplete", isComplete ) );

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}

		private void ResetSalesChannels()
		{
			using( SqlConnection cn = new SqlConnection( connStrWorkSpace ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BackFillSalesChannelReset";

					cn.Open();
					cmd.ExecuteNonQuery();
				}
			}
		}
	}
}
