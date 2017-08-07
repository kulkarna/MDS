using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.MarketManagement.EdiManagement;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class AccountEventProcessor
	{
		/// <summary>
		/// Record account event history
		/// </summary>
		/// <param name="eventType">Type of event</param>
		/// <param name="accountNumber">Identifier of account</param>
		/// <param name="utilityCode">Identifier of utility</param>
		public static void ProcessEvent( AccountEventType eventType, string accountNumber, string utilityCode )
		{
			ProcessEvent( AccountEventType.None, eventType, accountNumber, utilityCode, ResponseType.None, null );
		}

		/// <summary>
		/// Record account event history
		/// </summary>
		/// <param name="eventType">Type of event</param>
		/// <param name="accountNumber">Identifier of account</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="responseType">EDI Response Type (Accept or Reject)</param>
		public static void ProcessEvent( AccountEventType eventType, string accountNumber, string utilityCode, ResponseType responseType )
		{
			ProcessEvent( AccountEventType.None, eventType, accountNumber, utilityCode, responseType, null );
		}

		/// <summary>
		/// Record account event history for commission transaction
		/// </summary>
		/// <param name="eventType">Type of event</param>
		/// <param name="accountNumber">Identifier of account</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="commissionTransaction">Commission transaction object</param>
		public static void ProcessEvent( AccountEventType eventType, string accountNumber, string utilityCode, CommissionTransaction commissionTransaction )
		{
			ProcessEvent( AccountEventType.None, eventType, accountNumber, utilityCode, ResponseType.None, commissionTransaction );
		}

		/// <summary>
		/// Record account event history
		/// </summary>
		/// <param name="eventAssociate">An event associated with the account event (DealSubmission or RenewalSubmission - 
		///  used for determining which table to pull data from)</param>
		/// <param name="eventType">Type of event</param>
		/// <param name="accountNumber">Identifier of account</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="responseType">EDI Response Type (Accept or Reject)</param>
		public static void ProcessEvent( AccountEventType eventAssociate, AccountEventType eventType, string accountNumber,
			string utilityCode, ResponseType responseType )
		{
			ProcessEvent( eventAssociate, eventType, accountNumber, utilityCode, responseType, null );
		}

		/// <summary>
		/// Record account event history
		/// </summary>
		/// <param name="eventAssociate">An event associated with the account event (DealSubmission or RenewalSubmission - 
		///  used for determining which table to pull data from)</param>
		/// <param name="eventType">Type of event</param>
		/// <param name="accountNumber">Identifier of account</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="responseType">EDI Response Type (Accept or Reject)</param>
		/// <param name="ct">Commission transaction object</param>
		public static void ProcessEvent( AccountEventType eventAssociate, AccountEventType eventType, string accountNumber,
			string utilityCode, ResponseType responseType, CommissionTransaction ct )
		{
			CompanyAccount account = null;
			AccountEventHistory aeh;

			if( eventType == AccountEventType.Commission ) // see if renewal has not hit yet. if it has, then pull will come from account table
			{
				// pull from account_renewal table
				account = CompanyAccountFactory.GetCompanyAccountRenewalByContract( ct.AccountNumber, ct.ContractNumber, true );
			}
			else if( eventAssociate.Equals( AccountEventType.RenewalSubmission ) || eventType.Equals( AccountEventType.RenewalSubmission )
				|| eventAssociate.Equals( AccountEventType.ContractConversion ) )
			{
				account = CompanyAccountFactory.GetCompanyAccountRenewal( accountNumber, utilityCode, true );
			}

			if( account == null )
			{
				account = CompanyAccountFactory.GetCompanyAccount( accountNumber, utilityCode );
			}

			AccountEvent evt = new AccountEvent( account, eventType );

			aeh = AccountEventHistoryFactory.CreateAccountEventHistory( evt );

			if( CalculateGrossProfitAndRevenueAdjustments( aeh, account, evt, responseType, ct ) )
				AccountEventHistoryFactory.SaveAccountEventHistory( aeh );
		}

		/// <summary>
		/// Calculate annual and term gross profit, annual and term revenue adjustments
		/// </summary>
		/// <param name="aeh">AccountEventHistory object</param>
		/// <param name="account">CompanyAccount object</param>
		/// <param name="evt">AccountEvent object</param>
		/// <param name="responseType">EDI Response Type (Accept or Reject)</param>
		/// <param name="ct">Commission transaction object</param>
		private static bool CalculateGrossProfitAndRevenueAdjustments( AccountEventHistory aeh,
			CompanyAccount account, AccountEvent evt, ResponseType responseType, CommissionTransaction ct )
		{
			// rate change calculations ------------------------------------------------------------------
			// term gross profit adjustment calculation *** daily usage * remaining days in term * (new gross margin - old gross margin) / days in term
			// new term gross profit = term gross profit + term gross profit adjustment
			// term revenue adjustment calculation *** daily usage * remaining days in term * (new rate - old rate) / days in term
			// new term revenue = old term revenue + term revenue adjustment 

			// if event is a deenrollment or rate change, calculation is based on remaining term of contract.

			TimeSpan span;								// for determining days difference
			DateTime endDate;							/* based either on meter read date of contract end date 
														or contract end date if meter read date is not available */
			int contractTotalDays;						// total days in contract
			int contractDaysRemaining;					// days remaining in contract when event occurs
			decimal dailyGrossProfit;					// profit broken down into days
			decimal dailyRevenue;						// revenue broken down into days
			decimal rate;								// old rate
			bool saveEvent = true;						// will determine whether to insert event record

			decimal annualGrossProfitAdjustment = 0m;
			decimal termGrossProfitAdjustment = 0m;
			decimal annualRevenueAdjustment = 0m;
			decimal termRevenueAdjustment = 0m;

			int annualUsage = account.AnnualUsage;
			int prevAnnualUsage;
			int daysInYear = DateTime.IsLeapYear( DateTime.Today.Year ) ? 366 : 365;
			decimal dailyUsage = Convert.ToDecimal( annualUsage ) / Convert.ToDecimal( daysInYear );
			decimal grossMargin;
			decimal additionalGrossMargin;
			decimal annualGrossProfit;
			decimal termGrossProfit;
			decimal termGrossProfitTemp;
			decimal annualRevenue;
			decimal termRevenue;
			decimal termRevenueTemp;
			int productTypeID;
			DataSet ds = new DataSet();


			// get last account event history for account and current contract of commission transaction event
			if( evt.EventType.Equals( AccountEventType.Commission ) )
			{
				ds = AccountEventSql.SelectLastAccountEventByEventId( ct.ContractNumber, ct.AccountId, Convert.ToInt32( AccountEventType.Commission ) );

				// if commission event that does not have a previous commission event recorded, 
				// then get last event record for account.
				if( ds == null || ds.Tables == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
					ds = AccountEventSql.SelectLastAccountEventByAccountId( ct.AccountId );
			}
			else
				ds = AccountEventSql.SelectLastAccountEventByAccountId( account.Identifier );

			if( ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				prevAnnualUsage = Convert.ToInt32( ds.Tables[0].Rows[0]["AnnualUsage"] );
				grossMargin = Convert.ToDecimal( ds.Tables[0].Rows[0]["GrossMarginValue"] );
				annualGrossProfit = Convert.ToDecimal( ds.Tables[0].Rows[0]["AnnualGrossProfit"] );
				termGrossProfit = Convert.ToDecimal( ds.Tables[0].Rows[0]["TermGrossProfit"] );
				annualRevenue = Convert.ToDecimal( ds.Tables[0].Rows[0]["AnnualRevenue"] );
				termRevenue = Convert.ToDecimal( ds.Tables[0].Rows[0]["TermRevenue"] );
				rate = Convert.ToDecimal( ds.Tables[0].Rows[0]["Rate"] );
				additionalGrossMargin = Convert.ToDecimal( ds.Tables[0].Rows[0]["AdditionalGrossMargin"] );
				productTypeID = ds.Tables[0].Rows[0]["ProductTypeID"] == DBNull.Value ? 1 : Convert.ToInt32( ds.Tables[0].Rows[0]["ProductTypeID"] ); // default to fixed if not found

				// when rate end date is 1/1/1900, meter read date was not available,
				// so 1/1/1900 was the default. In this case, use contract end date for calculation.
				if( aeh.RateEndDate.Date.Equals( Convert.ToDateTime( "1/1/1900" ) ) )
					endDate = aeh.ContractEndDate;
				else // use rate end date for calculation
					endDate = aeh.RateEndDate;

				// total days of contract
				span = endDate - aeh.ContractDate;
				contractTotalDays = span.Days;

				// days left in contract
				span = endDate - DateTime.Today;
				contractDaysRemaining = span.Days;

				// if contract end date is past, prevent a negative number
				if( contractDaysRemaining < 0 )
					contractDaysRemaining = 0;

				// daily gross profit
				dailyGrossProfit = termGrossProfit / Convert.ToDecimal( contractTotalDays );

				// daily revenue
				dailyRevenue = termRevenue / Convert.ToDecimal( contractTotalDays );

				// annual gross profit adjustment
				annualGrossProfitAdjustment = 0m;

				// annual revenue adjustment
				annualRevenueAdjustment = 0m;

				switch( evt.EventType )
				{
					case AccountEventType.CheckAccountEvent:
						{
							if( responseType.Equals( ResponseType.EnrollmentReject ) )
							{
								// term gross profit adjustment
								termGrossProfitAdjustment = termGrossProfit;

								// term revenue adjustment
								termRevenueAdjustment = termRevenue;

								// set values
								aeh.AnnualGrossProfit = 0m;
								aeh.TermGrossProfit = 0m;
								aeh.AnnualRevenue = 0m;
								aeh.TermRevenue = 0m;
							}

							break;
						}
					case AccountEventType.ContractConversion:
						{
							annualGrossProfitAdjustment = aeh.AnnualGrossProfit - annualGrossProfit;
							annualRevenueAdjustment = aeh.AnnualRevenue - annualRevenue;

							// gross profit  -------------------------------------------------------------
							// adjust term gross profit for term up to today
							termGrossProfitAdjustment = dailyGrossProfit * Convert.ToDecimal( contractDaysRemaining );
							termGrossProfitTemp = termGrossProfit - termGrossProfitAdjustment;

							// recalculate daily gross profit for remaining term
							dailyGrossProfit = aeh.TermGrossProfit / Convert.ToDecimal( contractTotalDays );

							// add term gross profit for remaining term to previous term gross profit
							termGrossProfitTemp = termGrossProfitTemp + (dailyGrossProfit * Convert.ToDecimal( contractDaysRemaining ));

							// adjustment from old to new gross profit
							termGrossProfitAdjustment = termGrossProfitTemp - termGrossProfit;

							// term revenue  -------------------------------------------------------------
							// term revenue adjustment
							termRevenueAdjustment = dailyRevenue * Convert.ToDecimal( contractDaysRemaining );
							termRevenueTemp = termRevenue - termRevenueAdjustment;

							// recalculate daily revenue for remaining term
							dailyRevenue = aeh.TermRevenue / Convert.ToDecimal( contractTotalDays );
							termRevenueTemp = termRevenueTemp + (dailyRevenue * Convert.ToDecimal( contractDaysRemaining ));

							// adjustment from old to new term revenue
							termRevenueAdjustment = termRevenueTemp - termRevenue;

							// set values
							aeh.TermGrossProfit = termGrossProfitTemp;
							aeh.TermRevenue = termRevenueTemp;

							break;
						}
					case AccountEventType.DealSubmission:
						{
							// get the weighted average gross margin for all multi-terms
							if( aeh.ProductTypeID == 7 )
							{
								SetMultiTermValues( aeh );
							}
							break;
						}
					case AccountEventType.DeEnrollment:
						{
							if( responseType.Equals( ResponseType.DeenrollmentAccept ) )
							{
								aeh.AnnualGrossProfit = 0m;
								aeh.AnnualRevenue = 0m;

								annualGrossProfitAdjustment = annualGrossProfit;
								annualRevenueAdjustment = annualRevenue;

								// term gross profit adjustment
								termGrossProfitAdjustment = dailyGrossProfit * Convert.ToDecimal( contractDaysRemaining );
								termGrossProfit = termGrossProfit - termGrossProfitAdjustment;

								// term revenue adjustment
								termRevenueAdjustment = dailyRevenue * Convert.ToDecimal( contractDaysRemaining );
								termRevenue = termRevenue - termRevenueAdjustment;

								// set values
								aeh.AnnualGrossProfit = annualGrossProfit;
								aeh.TermGrossProfit = termGrossProfit;
								aeh.AnnualRevenue = annualRevenue;
								aeh.TermRevenue = termRevenue;
							}

							break;
						}
					case AccountEventType.RateChange:
					case AccountEventType.RateChangeManual:
						{
							annualGrossProfitAdjustment = aeh.AnnualGrossProfit - annualGrossProfit;
							annualRevenueAdjustment = aeh.AnnualRevenue - annualRevenue;

							// term gross profit adjustment
							termGrossProfitAdjustment = dailyUsage * Convert.ToDecimal( contractDaysRemaining ) * ((aeh.GrossMargin + (aeh.AdditionalGrossMargin * Convert.ToDecimal( 1000 ))) - (grossMargin + (aeh.AdditionalGrossMargin * Convert.ToDecimal( 1000 )))) / Convert.ToDecimal( contractTotalDays );
							termGrossProfit = termGrossProfit + termGrossProfitAdjustment;

							// term revenue adjustment
							termRevenueAdjustment = dailyUsage * Convert.ToDecimal( contractDaysRemaining ) * (account.Rate - rate);
							termRevenue = termRevenue + termRevenueAdjustment;

							// set values
							aeh.Rate = account.Rate;
							aeh.TermGrossProfit = termGrossProfit;
							aeh.AnnualRevenue = annualRevenue;
							aeh.TermRevenue = termRevenue;

							break;
						}
					case AccountEventType.Enrollment:
						{
							if( responseType.Equals( ResponseType.EnrollmentAccept ) )
							{
								annualGrossProfitAdjustment = aeh.AnnualGrossProfit - annualGrossProfit;
								termGrossProfitAdjustment = aeh.TermGrossProfit - termGrossProfit;
								annualRevenueAdjustment = aeh.AnnualRevenue - annualRevenue;
								termRevenueAdjustment = aeh.TermRevenue - termRevenue;
							}
							else // rejected...denied, no way 
							{
								annualGrossProfitAdjustment = annualGrossProfit;
								annualRevenueAdjustment = annualRevenue;
								termGrossProfitAdjustment = termGrossProfit;
								termRevenueAdjustment = termRevenue;

								// set values
								aeh.AnnualGrossProfit = 0m;
								aeh.TermGrossProfit = 0m;
								aeh.AnnualRevenue = 0m;
								aeh.TermRevenue = 0m;
							}

							break;
						}
					case AccountEventType.RenewalSubmission:
						{
							// get the weighted average gross margin for all multi-terms
							if( aeh.ProductTypeID == 7 )
							{
								SetMultiTermValues( aeh );
							}
							break;
						}
					case AccountEventType.ContractMerge:
					case AccountEventType.Rollover:
						{
							// no adjustment for contract merges, renewals, or rollovers
							break;
						}
					case AccountEventType.UsageUpdate:
					case AccountEventType.UsageUpdateManual:
						{
							// only record event if usage is different
							if( prevAnnualUsage != aeh.AnnualUsage )
							{
								if( aeh.ProductTypeID == 7 )
								{
									SetMultiTermValues( aeh );
								}

								annualGrossProfitAdjustment = aeh.AnnualGrossProfit - annualGrossProfit;
								termGrossProfitAdjustment = aeh.TermGrossProfit - termGrossProfit;
								annualRevenueAdjustment = aeh.AnnualRevenue - annualRevenue;
								termRevenueAdjustment = aeh.TermRevenue - termRevenue;
							}
							else // do not record event
								saveEvent = false;

							break;
						}
					case AccountEventType.Commission:
						{
							decimal housePct = ct.HousePct;
							decimal rateRequested = ct.RateRequested;
							decimal rateSplitPoint = ct.RateSplitPoint;
							decimal totalAddGrossMargin = 0m;
							decimal addGrossMargin = 0m;
							decimal adjustedAddGrossMargin = 0m;

							// if rate request is not greater than rate split point,
							// then there is no house split.
							if( rateRequested > rateSplitPoint )
							{
								totalAddGrossMargin = rateRequested - rateSplitPoint;
								addGrossMargin = totalAddGrossMargin * housePct;

								// change AccountEventHistory object to the last event record 
								//aeh = AccountEventHistoryFactory.CreateAccountEventHistory( ct.AccountId );

								// adjustment for gross margin using the house split for current commission record
								// and house split for previous commission record
								adjustedAddGrossMargin = addGrossMargin - additionalGrossMargin;

								aeh.AdditionalGrossMargin += adjustedAddGrossMargin;

								annualGrossProfit = (Convert.ToDecimal( aeh.AnnualUsage ) * (aeh.GrossMargin + (aeh.AdditionalGrossMargin * Convert.ToDecimal( 1000 )))) / Convert.ToDecimal( 1000 );
								termGrossProfit = (Convert.ToDecimal( aeh.AnnualUsage ) * (aeh.GrossMargin + (aeh.AdditionalGrossMargin * Convert.ToDecimal( 1000 ))) * (Convert.ToDecimal( aeh.Term ) / Convert.ToDecimal( 12 ))) / Convert.ToDecimal( 1000 );

								annualGrossProfitAdjustment = annualGrossProfit - aeh.AnnualGrossProfit;
								termGrossProfitAdjustment = termGrossProfit - aeh.TermGrossProfit;
								annualRevenueAdjustment = 0m;
								termRevenueAdjustment = 0m;

								// set new values for gross profit
								aeh.AnnualGrossProfit = annualGrossProfit;
								aeh.TermGrossProfit = termGrossProfit;

								if( aeh.AdditionalGrossMargin == 0m ) // do not record event if add gross margin = 0
									saveEvent = false;
							}
							else // do not record event
								saveEvent = false;

							break;
						}
				}

				aeh.AnnualGrossProfitAdjustment = annualGrossProfitAdjustment;
				aeh.TermGrossProfitAdjustment = termGrossProfitAdjustment;
				aeh.AnnualRevenueAdjustment = annualRevenueAdjustment;
				aeh.TermRevenueAdjustment = termRevenueAdjustment;
			}
			else
			{
				// get the weighted average gross margin for all multi-terms
				if( aeh.ProductTypeID == 7 )
				{
					SetMultiTermValues( aeh );
				}
				aeh.AnnualGrossProfitAdjustment = 0m;
				aeh.TermGrossProfitAdjustment = 0m;
				aeh.AnnualRevenueAdjustment = 0m;
				aeh.TermRevenueAdjustment = 0m;
			}

			return saveEvent;
		}

		/// <summary>
		/// Gets the weighted average gorss margin for all multi-terms and adjusts gross profits
		/// </summary>
		/// <param name="aeh">AccountEventHistory object</param>
		private static void SetMultiTermValues( AccountEventHistory aeh )
		{
			decimal weightedAvgGrossMargin = CompanyAccountFactory.GetMultiTermGrossMargin( aeh.AccountId );
			aeh.GrossMargin = Decimal.Round( (weightedAvgGrossMargin == 0m ? aeh.GrossMargin : weightedAvgGrossMargin), 5 );
			aeh.TermGrossProfit = Decimal.Round( ((Convert.ToDecimal( aeh.AnnualUsage ) * aeh.GrossMargin * (Convert.ToDecimal( aeh.Term ) / Convert.ToDecimal( 12 ))) / Convert.ToDecimal( 1000 )), 5 );
			aeh.AnnualGrossProfit = Decimal.Round( ((Convert.ToDecimal( aeh.AnnualUsage ) * aeh.GrossMargin) / Convert.ToDecimal( 1000 )), 5 );

			// for multi-term, product rate record needs to have gross margin value updated with weighted average
			UpdateProductRateGrossMargin( aeh.ProductId, aeh.RateId, aeh.GrossMargin );
		}

		/// <summary>
		/// Updates gross margin value
		/// </summary>
		/// <param name="productId">Product Id</param>
		/// <param name="rateId">Rate Id</param>
		/// <param name="grossMargin">Gross margin value</param>
		private static void UpdateProductRateGrossMargin( string productId, int rateId, decimal grossMargin )
		{
			ProductRateFactory.UpdateGrossMargin( productId, rateId, grossMargin );
		}
	}
}
