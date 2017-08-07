using System;
using System.Collections.Generic;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using System.Data;
using System.Configuration;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class MarketRateFactory
	{

		/// <summary>
		/// Gets today's market rate.
		/// </summary>
		/// <param name="companyAccount"></param>
		/// <param name="lostTermMonths">Number of months still left on the contract</param>
		/// <param name="dropMonthIndicator">Indicator how many months after the today's date the deenrollment will occur (possible values 0 = current Month, 1, 2, 3)</param>
		/// <returns></returns>
		public static MarketRate GetMarketRate( CompanyAccount companyAccount, int lostTermMonths, int dropMonthIndicator )
		{
			DateTime todaysDate = new DateTime( DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day );
			return GetMarketRate( todaysDate, companyAccount, lostTermMonths, dropMonthIndicator );
		}

		/// <summary>
		/// Gets the market rate for the specified effective date.
		/// </summary>
		/// <param name="effectiveDate">Effective Pricing Date</param>
		/// <param name="companyAccount"></param>
		/// <param name="lostTermMonths">Number of months still left on the contract</param>
		/// <param name="dropMonthIndicator">Indicator how many months after the today's date the deenrollment will occur (possible values 0 = current Month, 1, 2, 3)</param>
		/// <returns></returns>
		public static MarketRate GetMarketRate( DateTime effectiveDate, CompanyAccount companyAccount, int lostTermMonths, int dropMonthIndicator )
		{
			string method1Error = "";
			DataSet ds = null;
			DateTime StartDateRange = new DateTime();
			StartDateRange = effectiveDate.AddDays( -Convert.ToDouble( ConfigurationManager.AppSettings["effective_date_start"] ) );

			if( lostTermMonths == 0 )
				return new MarketRate( 0 );

			ds = EtfSql.GetEtfMarketRateUtilityZoneServiceClass( StartDateRange, effectiveDate, companyAccount.RetailMarketCode, companyAccount.UtilityCode, companyAccount.ZoneCode, companyAccount.RateClass, lostTermMonths, dropMonthIndicator, companyAccount.AccountType.ToString() );

			if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
			{
				method1Error += "Method 1 failed: Unable to get zone and service class based on PricingID." + Environment.NewLine;

				// If no data was found, try old method to find Market Rate
				PricingMode pricingMode;
				UtilityDictionary utilityDictionary = UtilityFactory.GetActiveUtilities();
				string utilCode = companyAccount.UtilityCode.Trim();
				if( utilityDictionary.ContainsKey( utilCode ) )
				{
					pricingMode = utilityDictionary[utilCode].PricingMode;
				}
				else
				{
					return new MarketRate( method1Error + "Method 2 failed: Pricing Mode could not be determined for Utility "
						+ companyAccount.UtilityCode );
				}

				switch( pricingMode )
				{
					case PricingMode.Utility:
						ds = EtfSql.GetEtfMarketRateUtility( StartDateRange, effectiveDate, companyAccount.RetailMarketCode, companyAccount.UtilityCode, lostTermMonths, dropMonthIndicator, companyAccount.AccountType.ToString() );
						break;
					case PricingMode.Utility_Zone:
						ds = EtfSql.GetEtfMarketRateUtilityZone( StartDateRange, effectiveDate, companyAccount.RetailMarketCode, companyAccount.UtilityCode, companyAccount.ZoneCode, lostTermMonths, dropMonthIndicator, companyAccount.AccountType.ToString() );
						break;
					case PricingMode.Utility_Zone_ServiceClass:
						ds = EtfSql.GetEtfMarketRateUtilityZoneServiceClass( StartDateRange, effectiveDate, companyAccount.RetailMarketCode, companyAccount.UtilityCode, companyAccount.ZoneCode, companyAccount.RateClass, lostTermMonths, dropMonthIndicator, companyAccount.AccountType.ToString() );
						break;
				}

				if( ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0 )
				{
					string err = method1Error + "Method 2 failed: Market Rate could not be found for the given parameters. "
						+ Environment.NewLine + "Effective Date: " + effectiveDate.ToShortDateString()
						+ Environment.NewLine + "MarketCode: " + companyAccount.RetailMarketCode
						+ Environment.NewLine + "Utility: " + companyAccount.UtilityCode
						+ Environment.NewLine + "Lost Term Months: " + lostTermMonths
						+ Environment.NewLine + "Drop Month Indicator: " + dropMonthIndicator;

					switch( pricingMode )
					{
						case PricingMode.Utility_Zone:
							err += Environment.NewLine + "Zone: " + companyAccount.ZoneCode;
							break;
						case PricingMode.Utility_Zone_ServiceClass:
							err += Environment.NewLine + "Zone: " + companyAccount.ZoneCode
								+ Environment.NewLine + "Service Class: " + companyAccount.RateClass;
							break;
					}

					err += Environment.NewLine + "Account Type: " + companyAccount.AccountType.ToString();

					// Check if we have data for the effective date at all
					ds = EtfSql.MarketRateDataExistsForEffectiveDate( StartDateRange, effectiveDate );
					if( Convert.ToInt32( ds.Tables[0].Rows[0][0] ) == 0 )
					{
						err += Environment.NewLine + Environment.NewLine + "NO MARKET RATES WERE FOUND FOR EFFECTIVE DATE: " + effectiveDate;
					}
					return new MarketRate( err );
				}
				else
				{
					return new MarketRate( Convert.ToSingle( ds.Tables[0].Rows[0][0] ) );
				}
			}
			else
			{
				return new MarketRate( Convert.ToSingle( ds.Tables[0].Rows[0][0] ) );
			}
		}
	}
}
