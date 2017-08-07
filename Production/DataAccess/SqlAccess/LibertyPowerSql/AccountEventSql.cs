using System;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
	/// <summary>
	/// Data related methods for account events
	/// </summary>
	public static class AccountEventSql
	{
		/// <summary>
		/// Select event history record
		/// </summary>
		/// <param name="id">Identifier of record</param>
		/// <returns>Returns DataSet containing specified record.</returns>
		public static DataSet SelectAccountEventById( int id )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_AccountEventHistorySelectById";

					cmd.Parameters.Add( new SqlParameter( "@Id", id ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet SelectAccountEventByAccountId( string accountId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_AccountEventHistorySelectByAccountId";

					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet SelectLastAccountEventByAccountId( string accountId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_AccountEventHistorySelectLastByAccountId";

					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet SelectLastAccountEventByEventId( string contractNumber, string accountId, int eventId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_AccountEventHistorySelectLastByEventId";

					cmd.Parameters.Add( new SqlParameter( "@ContractNumber", contractNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@EventId", eventId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Insert account event record in to history table
		/// </summary>
		/// <param name="contractNumber">Identifier of contract</param>
		/// <param name="accountId">Identifier od account</param>
		/// <param name="productId">Identifier of product</param>
		/// <param name="rateId">Identifier of rate</param>
		/// <param name="rate">Rate of product</param>
		/// <param name="rateEndDate">Rate end date</param>
		/// <param name="eventId">Identifier of event type</param>
		/// <param name="eventEffectiveDate">Event effective date</param>
		/// <param name="contractType">Type of contract</param>
		/// <param name="contractDate">Date of contract</param>
		/// <param name="contractEndDate">Contract end date</param>
		/// <param name="dateFlowStart">Flow start date</param>
		/// <param name="term">Term of contract (in months)</param>
		/// <param name="annualUsage">Annual usage (in Kwhs)</param>
		/// <param name="grossMarginValue">Gross margin value</param>
		/// <param name="annualGrossProfit">Annualized gross profit</param>
		/// <param name="termGrossProfit">Term gross profit</param>
		/// <param name="annualGrossProfitAdjustment">Annualized gross profit adjustment</param>
		/// <param name="termGrossProfitAdjustment">Term gross profit adjustment</param>
		/// <param name="annualRevenue">Annual revenue</param>
		/// <param name="termRevenue">Term revenue</param>
		/// <param name="annualRevenueAdjustment">Annual revenue adjustment</param>
		/// <param name="termRevenueAdjustment">Term revenue adjustment</param>
		/// <returns>Returns a DataSet containing inserted record with the addition of the record ID.</returns>
		public static DataSet InsertAccountEvent( string contractNumber, string accountId,
			string productId, int rateId, decimal rate, DateTime rateEndDate, int eventId,
			DateTime eventEffectiveDate, string contractType, DateTime contractDate,
			DateTime contractEndDate, DateTime dateFlowStart, int term, int annualUsage,
			decimal grossMarginValue, decimal annualGrossProfit, decimal termGrossProfit,
			decimal annualGrossProfitAdjustment, decimal termGrossProfitAdjustment,
			decimal annualRevenue, decimal termRevenue, decimal annualRevenueAdjustment,
			decimal termRevenueAdjustment, decimal additionalGrossMargin, DateTime dateSubmit,
			DateTime dateDeal, string salesChannelId, string salesRep, int productTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_AccountEventHistoryInsert";

					cmd.Parameters.Add( new SqlParameter( "@ContractNumber", contractNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductId", productId ) );
					cmd.Parameters.Add( new SqlParameter( "@RateID", rateId ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
					cmd.Parameters.Add( new SqlParameter( "@RateEndDate", rateEndDate ) );
					cmd.Parameters.Add( new SqlParameter( "@EventID", eventId ) );
					cmd.Parameters.Add( new SqlParameter( "@EventEffectiveDate", eventEffectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractType", contractType ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractDate", contractDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractEndDate", contractEndDate ) );
					cmd.Parameters.Add( new SqlParameter( "@DateFlowStart", dateFlowStart ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@AnnualUsage", annualUsage ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMarginValue", grossMarginValue ) );
					cmd.Parameters.Add( new SqlParameter( "@AnnualGrossProfit", annualGrossProfit ) );
					cmd.Parameters.Add( new SqlParameter( "@TermGrossProfit", termGrossProfit ) );
					cmd.Parameters.Add( new SqlParameter( "@AnnualGrossProfitAdj", annualGrossProfitAdjustment ) );
					cmd.Parameters.Add( new SqlParameter( "@TermGrossProfitAdj", termGrossProfitAdjustment ) );
					cmd.Parameters.Add( new SqlParameter( "@AnnualRevenue", annualRevenue ) );
					cmd.Parameters.Add( new SqlParameter( "@TermRevenue", termRevenue ) );
					cmd.Parameters.Add( new SqlParameter( "@AnnualRevenueAdj", annualRevenueAdjustment ) );
					cmd.Parameters.Add( new SqlParameter( "@TermRevenueAdj", termRevenueAdjustment ) );
					cmd.Parameters.Add( new SqlParameter( "@AdditionalGrossMargin", additionalGrossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@SubmitDate", dateSubmit ) );
					cmd.Parameters.Add( new SqlParameter( "@DealDate", dateDeal ) );
					cmd.Parameters.Add( new SqlParameter( "@SalesChannelId", salesChannelId ) );
					cmd.Parameters.Add( new SqlParameter( "@SalesRep", salesRep ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductTypeID", productTypeID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets the effective date for event type
		/// </summary>
		/// <param name="eventId">Event identifier</param>
		/// <returns>Returns a DataSet containing the event effective date.</returns>
		public static DataSet SelectAccountEventEffectiveDate( int eventId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_AccountEventEffectiveDateSelect";

					cmd.Parameters.Add( new SqlParameter( "@EventId", eventId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}
	}
}
