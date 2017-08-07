using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.DataAccess.SqlAccess.CommonSql;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class AccountEventHistoryFactory
	{
		public static AccountEventHistory CreateAccountEventHistory( AccountEvent evt )
		{
			CompanyAccount account = evt.Account;
			int productTypeID = account.ProductRate.Product.ProductType.Identity;
			decimal productRate = productTypeID == 7 ? CompanyAccountFactory.GetMultiTermRateWeightedAverage( account.Identifier ) : account.ProductRate.Rate;
			decimal grossMargin = productTypeID == 7 ? CompanyAccountFactory.GetMultiTermGrossMargin( account.Identifier ) : account.ProductRate.GrossMarginValue != null ? Convert.ToDecimal( account.ProductRate.GrossMarginValue ) : 0;
			int term = account.Term;
			int annualUsage = account.AnnualUsage;
			decimal annualRevenue = productRate * Convert.ToDecimal( annualUsage );
			decimal termRevenue = annualRevenue * (Convert.ToDecimal( term ) / Convert.ToDecimal( 12 ));

			AccountEventHistory aeh = new AccountEventHistory( grossMargin, term, annualUsage, evt.EventType );

			aeh.AccountEventType = evt.EventType;
			aeh.AccountId = account.Identifier;
			aeh.AdditionalGrossMargin = 0m; // initalize to zero
			aeh.ContractDate = account.ContractStartDate;
			aeh.ContractEndDate = account.ContractEndDate;
			aeh.ContractNumber = account.ContractNumber;
			aeh.ContractType = account.ContractType;
			aeh.DateDeal = account.DateDeal;
			aeh.DateFlowStart = account.FlowStartDate;
			aeh.DateSubmit = account.DateSubmit;
			aeh.EventEffectiveDate = GetEventEffectiveDate( evt );
			aeh.ProductId = account.ProductRate.Product.ProductId;
			aeh.Rate = account.Rate;
			aeh.RateId = account.ProductRate.RateId;
			aeh.RateEndDate = GetMeterReadDate( account );
			aeh.SalesChannelId = account.SalesChannelId;
			aeh.SalesRep = account.SalesRep;
			aeh.ProductTypeID = productTypeID;

			aeh.AnnualRevenue = annualRevenue;
			aeh.TermRevenue = termRevenue;

			return aeh;
		}

		public static AccountEventHistory CreateAccountEventHistory( string contractNumber, string accountId, int eventId )
		{
			AccountEventHistory aeh = null;

			DataSet ds = AccountEventSql.SelectLastAccountEventByEventId( contractNumber, accountId, eventId );

			if( ds != null && ds.Tables != null && ds.Tables.Count > 0 )
			{
				aeh = new AccountEventHistory();
				DataRow dr = ds.Tables[0].Rows[0];

				aeh.AccountEventType = (AccountEventType) Enum.Parse( typeof( AccountEventType ), dr["EventID"].ToString(), true );
				aeh.AccountId = accountId;
				aeh.AdditionalGrossMargin = Convert.ToDecimal( dr["AdditionalGrossMargin"] );
				aeh.AnnualGrossProfit = Convert.ToDecimal( dr["AnnualGrossProfit"] );
				aeh.AnnualGrossProfitAdjustment = Convert.ToDecimal( dr["AnnualGrossProfitAdjustment"] );
				aeh.AnnualRevenue = Convert.ToDecimal( dr["AnnualRevenue"] );
				aeh.AnnualRevenueAdjustment = Convert.ToDecimal( dr["AnnualRevenueAdjustment"] );
				aeh.AnnualUsage = Convert.ToInt32( dr["AnnualUsage"] );
				aeh.ContractDate = Convert.ToDateTime( dr["ContractDate"] );
				aeh.ContractEndDate = Convert.ToDateTime( dr["ContractEndDate"] );
				aeh.ContractNumber = dr["ContractNumber"].ToString();
				aeh.ContractType = dr["ContractType"].ToString();
				aeh.DateDeal = Convert.ToDateTime( dr["DealDate"] );
				aeh.DateFlowStart = Convert.ToDateTime( dr["DateFlowStart"] );
				aeh.DateSubmit = Convert.ToDateTime( dr["SubmitDate"] );
				aeh.EventEffectiveDate = Convert.ToDateTime( dr["EventEffectiveDate"] );
				aeh.GrossMargin = Convert.ToDecimal( dr["GrossMarginValue"] );
				aeh.Id = Convert.ToInt32( dr["ID"] );
				aeh.ProductId = dr["ProductId"].ToString();
				aeh.Rate = Convert.ToDecimal( dr["Rate"] );
				aeh.RateEndDate = Convert.ToDateTime( dr["RateEndDate"] );
				aeh.RateId = Convert.ToInt32( dr["RateID"] );
				aeh.SalesChannelId = dr["SalesChannelId"].ToString();
				aeh.SalesRep = dr["SalesRep"].ToString();
				aeh.Term = Convert.ToInt32( dr["Term"] );
				aeh.TermGrossProfit = Convert.ToDecimal( dr["TermGrossProfit"] );
				aeh.TermGrossProfitAdjustment = Convert.ToDecimal( dr["TermGrossProfitAdjustment"] );
				aeh.TermRevenue = Convert.ToDecimal( dr["TermRevenue"] );
				aeh.TermRevenueAdjustment = Convert.ToDecimal( dr["TermRevenueAdjustment"] );
				aeh.ProductTypeID = dr["ProductTypeID"] == DBNull.Value ? 0 : Convert.ToInt32( dr["ProductTypeID"] );
			}

			return aeh;
		}

		public static AccountEventHistory CreateAccountEventHistory( string accountId )
		{
			AccountEventHistory aeh = null;

			DataSet ds = AccountEventSql.SelectLastAccountEventByAccountId( accountId );

			if( ds != null && ds.Tables != null && ds.Tables.Count > 0 )
			{
				aeh = new AccountEventHistory();
				DataRow dr = ds.Tables[0].Rows[0];

				aeh.AccountEventType = (AccountEventType) Enum.Parse( typeof( AccountEventType ), dr["EventID"].ToString(), true );
				aeh.AccountId = accountId;
				aeh.AdditionalGrossMargin = Convert.ToDecimal( dr["AdditionalGrossMargin"] );
				aeh.AnnualGrossProfit = Convert.ToDecimal( dr["AnnualGrossProfit"] );
				aeh.AnnualGrossProfitAdjustment = Convert.ToDecimal( dr["AnnualGrossProfitAdjustment"] );
				aeh.AnnualRevenue = Convert.ToDecimal( dr["AnnualRevenue"] );
				aeh.AnnualRevenueAdjustment = Convert.ToDecimal( dr["AnnualRevenueAdjustment"] );
				aeh.AnnualUsage = Convert.ToInt32( dr["AnnualUsage"] );
				aeh.ContractDate = Convert.ToDateTime( dr["ContractDate"] );
				aeh.ContractEndDate = Convert.ToDateTime( dr["ContractEndDate"] );
				aeh.ContractNumber = dr["ContractNumber"].ToString();
				aeh.ContractType = dr["ContractType"].ToString();
				aeh.DateDeal = Convert.ToDateTime( dr["DealDate"] );
				aeh.DateFlowStart = Convert.ToDateTime( dr["DateFlowStart"] );
				aeh.DateSubmit = Convert.ToDateTime( dr["SubmitDate"] );
				aeh.EventEffectiveDate = Convert.ToDateTime( dr["EventEffectiveDate"] );
				aeh.GrossMargin = Convert.ToDecimal( dr["GrossMarginValue"] );
				aeh.Id = Convert.ToInt32( dr["ID"] );
				aeh.ProductId = dr["ProductId"].ToString();
				aeh.Rate = Convert.ToDecimal( dr["Rate"] );
				aeh.RateEndDate = Convert.ToDateTime( dr["RateEndDate"] );
				aeh.RateId = Convert.ToInt32( dr["RateID"] );
				aeh.SalesChannelId = dr["SalesChannelId"].ToString();
				aeh.SalesRep = dr["SalesRep"].ToString();
				aeh.Term = Convert.ToInt32( dr["Term"] );
				aeh.TermGrossProfit = Convert.ToDecimal( dr["TermGrossProfit"] );
				aeh.TermGrossProfitAdjustment = Convert.ToDecimal( dr["TermGrossProfitAdjustment"] );
				aeh.TermRevenue = Convert.ToDecimal( dr["TermRevenue"] );
				aeh.TermRevenueAdjustment = Convert.ToDecimal( dr["TermRevenueAdjustment"] );
				aeh.ProductTypeID = dr["ProductTypeID"] == DBNull.Value ? 0 : Convert.ToInt32( dr["ProductTypeID"] );
			}

			return aeh;
		}

		public static void SaveAccountEventHistory( AccountEventHistory aeh )
		{
			AccountEventSql.InsertAccountEvent( aeh.ContractNumber, aeh.AccountId,
				aeh.ProductId, aeh.RateId, aeh.Rate, aeh.RateEndDate, Convert.ToInt32( aeh.AccountEventType ),
				aeh.EventEffectiveDate, aeh.ContractType, aeh.ContractDate, aeh.ContractEndDate,
				aeh.DateFlowStart, aeh.Term, aeh.AnnualUsage, aeh.GrossMargin, aeh.AnnualGrossProfit,
				aeh.TermGrossProfit, aeh.AnnualGrossProfitAdjustment, aeh.TermGrossProfitAdjustment,
				aeh.AnnualRevenue, aeh.TermRevenue, aeh.AnnualRevenueAdjustment, aeh.TermRevenueAdjustment,
				aeh.AdditionalGrossMargin, aeh.DateSubmit, aeh.DateDeal, aeh.SalesChannelId, aeh.SalesRep, aeh.ProductTypeID );
		}


		private static DateTime GetEventEffectiveDate( AccountEvent evt )
		{
			DateTime effectiveDate = DateTime.MinValue;

			switch( evt.EventEffectiveDate )
			{
				case "FlowStartDate":
					{
						effectiveDate = evt.Account.FlowStartDate;
						break;
					}
				case "DeenrollmentDate":
					{
						effectiveDate = evt.Account.ContractStartDate;
						break;
					}
				default:  // default to ContractDate
					{
						effectiveDate = evt.Account.ContractStartDate;
						break;
					}
			}

			return effectiveDate;
		}

		private static DateTime GetMeterReadDate( CompanyAccount account )
		{
			DateTime meterReadDate = Convert.ToDateTime( "1/1/1900" );

			int year = account.ContractEndDate.Year;
			int month = account.ContractEndDate.Month;
			string utilityCode = account.UtilityCode;
			string readCycleId = account.ReadCycleId;

			DataSet ds = MeterReadCalendarSql.GetScheduleItem( utilityCode, year, month, readCycleId );

			if( ds != null && ds.Tables[0].Rows.Count > 0 )
				meterReadDate = Convert.ToDateTime( ds.Tables[0].Rows[0]["ReadDate"] );
			else
				ErrorFactory.LogError( account.Identifier, "AccountEventHistoryFactory", "No Meter Read Date", DateTime.Now );

			return meterReadDate;
		}
	}
}
