using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	public static class EflSql
	{
		public static DataSet GetEflDataRange()
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflDataRangeSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetEflCharges(string utilityCode, string accountType)
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflChargesSelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetEflModifiers( string utilityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflModifiersSelect";

					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertEflCharges( string utilityCode, string accountType, decimal tdspFixed,
			decimal tdspKwh, decimal tdspFixedAbove, decimal tdspKwhAbove, decimal tdspKw )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflChargesInsert";

					cmd.Parameters.Add( new SqlParameter( "@UtilityCode", utilityCode ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );
					cmd.Parameters.Add( new SqlParameter( "@TdspFixed", tdspFixed ) );
					cmd.Parameters.Add( new SqlParameter( "@TdspKwh", tdspKwh ) );
					cmd.Parameters.Add( new SqlParameter( "@TdspFixedAbove", tdspFixedAbove ) );
					cmd.Parameters.Add( new SqlParameter( "@TdspKwhAbove", tdspKwhAbove ) );
					cmd.Parameters.Add( new SqlParameter( "@TdspKw", tdspKw ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetParameters( string accountType )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflParametersSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetMonthlyServiceCharges( string accountType )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflMonthlyServiceChargesSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetAverageMonthlyUsages( string accountType )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflAverageMonthlyUsagesSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetProducts( string accountType, string process )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflProductsSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );
					cmd.Parameters.Add( new SqlParameter( "@Process", process ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetTerms( string accountType, string productId, string process )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflTermsSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductId", productId ) );
					cmd.Parameters.Add( new SqlParameter( "@Process", process ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetDefaultProductData( string accountType, string marketCode, int month, int year )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflDefaultProductSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );
					cmd.Parameters.Add( new SqlParameter( "@MarketCode", marketCode ) );
					cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
					cmd.Parameters.Add( new SqlParameter( "@Year", year ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertDefaultProductData( string accountType, string marketCode, int month,
			int year, decimal mcpe, decimal adder, string username, DateTime dateCreated )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflDefaultProductInsert";

					cmd.Parameters.Add( new SqlParameter( "@MarketCode", marketCode ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountType", accountType ) );
					cmd.Parameters.Add( new SqlParameter( "@Month", month ) );
					cmd.Parameters.Add( new SqlParameter( "@Year", year ) );
					cmd.Parameters.Add( new SqlParameter( "@Mcpe", mcpe ) );
					cmd.Parameters.Add( new SqlParameter( "@Adder", adder ) );
					cmd.Parameters.Add( new SqlParameter( "@Username", username ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated", dateCreated ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetDocumentTemplateMultiRateTable( string contractNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( System.Configuration.ConfigurationManager.ConnectionStrings["Documents"].ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_document_print_template_table_mulitrate_sel";

					cmd.Parameters.Add( new SqlParameter( "@contract_number", contractNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetDocumentTemplateAddressTable( string contractNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( System.Configuration.ConfigurationManager.ConnectionStrings["Documents"].ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_document_print_template_table_address_sel";

					cmd.Parameters.Add( new SqlParameter( "@contract_number", contractNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetDocumentTemplateContractTable( string contractNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( System.Configuration.ConfigurationManager.ConnectionStrings["Documents"].ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_document_print_template_table_contract_sel";

					cmd.Parameters.Add( new SqlParameter( "@contract_number", contractNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetEflContractData( string contractNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EflContractDataSelect";

					cmd.Parameters.Add( new SqlParameter( "@ContractNumber", contractNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetIsAbcSalesChannel( string salesChannelRole )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IsAbcChannelSelect";

					cmd.Parameters.Add( new SqlParameter( "@SalesChannelRole", salesChannelRole ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
	}

}
