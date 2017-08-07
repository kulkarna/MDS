using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DALEntity = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using System.Data;

using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using PricingBal = LibertyPower.Business.CustomerAcquisition.DailyPricing;
using ProductBal = LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.CustomerAcquisition.ProspectManagement;
using System.Globalization;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	/// <summary>
	///
	/// </summary>
	public static class AccountContractRateFactory
	{
		public static AccountContractRate GetAccountContractRate( int accountContractRateId )
		{
			DataSet ds = CRMLibertyPowerSql.GetAccountContractRate( accountContractRateId );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				AccountContractRate accountContractRate = new AccountContractRate();
				MapDataRowToAccountContractRate( ds.Tables[0].Rows[0], accountContractRate );
				return accountContractRate;
			}

			return null;
		}

		public static List<AccountContractRate> GetAccountContractRates( int accountContractId )
		{
			//LAR at 10/5/2012 has fixed the name of CRMLibertyPowerSql methods
			DataSet ds = CRMLibertyPowerSql.GetAccountContractRatesByAccountContractId( accountContractId );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				List<AccountContractRate> accountContractRates = new List<AccountContractRate>();

				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					AccountContractRate accountContractRate = new AccountContractRate();
					MapDataRowToAccountContractRate( dr, accountContractRate );
					accountContractRates.Add( accountContractRate );
				}

				return accountContractRates;
			}

			return null;
		}

		public static string GetRateSubtermStringByAccountContractId( int accountContractId )
		{
			var accountContractRatelist = GetAccountContractRates( accountContractId );
			string output = string.Empty;
			foreach( var accountContractRate in accountContractRatelist )
			{
				if( accountContractRate.IsContractedRate )
				{
					if( accountContractRate.ProductCrossPriceMultiID > 0 )
					{
						if( output == string.Empty )
						{
							output = (accountContractRate.Rate == null ? "0.00000" : ((double) accountContractRate.Rate).ToString( "0.00000" )) +
									 " (" + (accountContractRate.Term == null ? "" : ((int) accountContractRate.Term).ToString()) + ")";
						}
						else
						{
							output += "<br/>" + (accountContractRate.Rate == null ? "0.00000" : ((double) accountContractRate.Rate).ToString( "0.00000" )) +
									 " (" + (accountContractRate.Term == null ? "" : ((int) accountContractRate.Term).ToString()) + ")";
						}
					}
					else
					{
						output = (accountContractRate.Term == null ? "" : ((int) accountContractRate.Term).ToString());
					}

				}

			}

			return output;
		}

		/// <summary>
		/// Gets all account contract rates for specified account number and utility ID.
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="isRenewal">Renewal flag</param>
		/// <returns>Returns all account contract rates for specified account number and utility ID.</returns>
		public static AccountContractRateList GetAccountContractRates( string accountNumber, int utilityID, int isRenewal )
		{
			DataSet ds = CRMLibertyPowerSql.GetAccountContractRateByAccountNumberUtilityID( accountNumber, utilityID, isRenewal );

			if( DataSetHelper.HasRow( ds ) )
			{
				AccountContractRateList accountContractRates = new AccountContractRateList();
				AccountContractRateList orderedList = new AccountContractRateList();

				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					AccountContractRate accountContractRate = new AccountContractRate();
					MapDataRowToAccountContractRate( dr, accountContractRate );
					accountContractRates.Add( accountContractRate );
				}

				orderedList.AddRange( (from r in accountContractRates
									   orderby r.RateStart
									   select r).ToList() );
				return orderedList;
			}
			return null;
		}

		public static bool InsertAccountContractRate( AccountContractRate accountContractRate, out List<GenericError> errors )
		{
			errors = new List<GenericError>();

			if( !accountContractRate.IsStructureValidForInsert() )
			{
				throw new InvalidOperationException( "The structure of the AccountContractRate Object is not valid" );
			}

			errors = accountContractRate.IsValidForInsert();

			if( errors.Count > 0 )
			{
				return false;
			}

			if( accountContractRate.IsVariable )
			{
				// VAR Rate with rate code 1202 (may need to include 1200, 1201 as they are 
				// common elements found in the VAR entries).
				return processForVARRates( accountContractRate, out errors );
			}
			else
			{
				// All other contract rate adds...
				return processForContractRates( accountContractRate, out errors );
			}

		}

		public static List<AccountContractRateQueue> GetAccountContractRateQueue()
		{
			List<AccountContractRateQueue> list = new List<AccountContractRateQueue>();

			DataSet ds = CRMLibertyPowerSql.GetAccountContractRateQueue();

			if( DataSetHelper.HasRow( ds ) )
			{
				list.AddRange( from DataRow dr in ds.Tables[0].Rows select BuildAccountContractRateQueue( dr ) );
			}
			return list;
		}

		public static List<AccountContractRateQueue> GetAccountContractRateQueueByID( int queueID )
		{
			List<AccountContractRateQueue> list = new List<AccountContractRateQueue>();

			DataSet ds = CRMLibertyPowerSql.GetAccountContractRateQueueByID( queueID );

			if( DataSetHelper.HasRow( ds ) )
			{
				list.AddRange( from DataRow dr in ds.Tables[0].Rows select BuildAccountContractRateQueue( dr ) );
			}
			return list;
		}

		public static List<AccountContractRateQueue> GetAccountContractRateQueueBySendDateStatus( DateTime sendDate, DataTable status )
		{
			List<AccountContractRateQueue> list = new List<AccountContractRateQueue>();

			DataSet ds = CRMLibertyPowerSql.GetAccountContractRateQueueBySendDateStatus( sendDate, status );

			if( DataSetHelper.HasRow( ds ) )
			{
				list.AddRange( from DataRow dr in ds.Tables[0].Rows select BuildAccountContractRateQueue( dr ) );
			}
			return list;
		}

		private static AccountContractRateQueue BuildAccountContractRateQueue( DataRow dr )
		{
			return new AccountContractRateQueue()
			{
				AccountContractId = Convert.ToInt32( dr["AccountContractID"] ),
				AccountContractRateQueueID = Convert.ToInt32( dr["AccountContractRateQueueID"] ),
				AdditionalGrossMargin = Convert.ToDouble( dr["AdditionalGrossMargin"] ),
				CommissionRate = Convert.ToDouble( dr["CommissionRate"] ),
				CreatedBy = Convert.ToInt32( dr["CreatedBy"] ),
				DateCreated = Convert.ToDateTime( dr["DateCreated"] ),
				GrossMargin = Convert.ToDouble( dr["GrossMargin"] ),
				HeatIndexSourceId = Convert.ToInt32( dr["HeatIndexSourceId"] ),
				HeatRate = Convert.ToDecimal( dr["HeatRate"] ),
				IsContractedRate = Convert.ToBoolean( dr["IsContractedRate"] ),
				IsCustomEnd = Convert.ToBoolean( dr["IsCustomEnd"] ),
				LegacyProductId = dr["LegacyProductId"].ToString(),
				Modified = Convert.ToDateTime( dr["Modified"] ),
				ModifiedBy = Convert.ToInt32( dr["ModifiedBy"] ),
				PriceId = Convert.ToInt64( dr["PriceId"] ),
				ProductCrossPriceMultiID = Convert.ToInt64( dr["ProductCrossPriceMultiID"] ),
				Rate = Convert.ToDouble( dr["Rate"] ),
				RateCode = dr["RateCode"].ToString(),
				RateEnd = Convert.ToDateTime( dr["RateEnd"] ),
				RateId = Convert.ToInt32( dr["RateId"] ),
				RateStart = Convert.ToDateTime( dr["RateStart"] ),
				SendDate = Convert.ToDateTime( dr["SendDate"] ),
				Status = (AcrQueueUpdateStatus) Enum.Parse( typeof( AcrQueueUpdateStatus ), dr["Status"].ToString() ),
				StatusNotes = dr["StatusNotes"].ToString(),
				Term = Convert.ToInt32( dr["Term"] ),
				TransferRate = Convert.ToDouble( dr["TransferRate"] )
			};
		}

		public static int InsertAccountContractRateQueue( AccountContractRateQueue acrQueue, out List<GenericError> errors )
		{
			errors = new List<GenericError>();

			// We need to prepopulate legacy product and rate info:
			int isFlexible = 0;
			PricingBal.CrossProductPriceSalesChannel price = PricingBal.CrossProductPriceFactory.GetSalesChannelPrice( acrQueue.PriceId.Value );

			if( price == null )
			{
				errors.Add( new GenericError() { Code = 1, Message = "AccountContractRateQueue: Could not find the priceId record" } );
				return 0;
			}

			if( price.ChannelType.Identity == 2 )
			{
				isFlexible = 1;
			}

			if( string.IsNullOrEmpty( acrQueue.LegacyProductId ) )
				acrQueue.LegacyProductId = GetLegacyProductId( price.ProductBrand.ProductBrandID, price.Utility.Code, price.Segment.Identity, isFlexible );

			if( !acrQueue.RateId.HasValue )
			{
				acrQueue.RateId = ProductBal.ProductRateFactory.GetNewRateID();
			}

			if( !acrQueue.RateId.HasValue )
			{
				errors.Add( new GenericError() { Code = 1, Message = "AccountContractRateQueue: Could not find the RateId record" } );
				return 0;
			}

			if( string.IsNullOrEmpty( acrQueue.LegacyProductId ) )
			{
				errors.Add( new GenericError() { Code = 1, Message = "AccountContractRateQueue: Could not find the LegacyProductId record" } );
				return 0;
			}

			if( !acrQueue.TransferRate.HasValue )
			{
				acrQueue.TransferRate = Convert.ToDouble( price.Price );
			}

			//add rate to the legacy rateID common product table 
			ProductBal.ProductRateFactory.AddProductRate( acrQueue.LegacyProductId, acrQueue.RateId.Value, decimal.Parse( acrQueue.Rate.Value.ToString() ), price.DisplayText, price.Term, price.GrossMargin, string.Empty, 0, price.StartDate, price.CostRateEffectiveDate, price.CostRateExpirationDate, 365, price.Zone.Identity, price.ServiceClass.Identity, DateTime.Today, DateTime.Today, acrQueue.CreatedBy.ToString() );

			DataSet ds = CRMLibertyPowerSql.InsertAccountContractRateQueue( acrQueue.AccountContractId, acrQueue.LegacyProductId, acrQueue.Term, acrQueue.RateId,
				acrQueue.Rate, acrQueue.RateCode, acrQueue.RateStart, acrQueue.RateEnd, acrQueue.IsContractedRate, acrQueue.HeatIndexSourceId,
				acrQueue.HeatRate, acrQueue.TransferRate, acrQueue.GrossMargin, acrQueue.CommissionRate, acrQueue.AdditionalGrossMargin,
				acrQueue.PriceId, acrQueue.ProductCrossPriceMultiID, acrQueue.IsCustomEnd, acrQueue.ModifiedBy, acrQueue.CreatedBy,
				(int) acrQueue.Status, acrQueue.StatusNotes, acrQueue.SendDate );

			if( DataSetHelper.HasRow( ds ) )
			{
				return Convert.ToInt32( ds.Tables[0].Rows[0]["AccountContractRateQueueID"] );
			}
			return 0;
		}

		public static void UpdateAccountContractRateQueue( AccountContractRateQueue acrQueue )
		{
			CRMLibertyPowerSql.UpdateAccountContractRateQueue( acrQueue.AccountContractRateQueueID, acrQueue.AccountContractId, acrQueue.LegacyProductId, acrQueue.Term, acrQueue.RateId,
				acrQueue.Rate, acrQueue.RateCode, acrQueue.RateStart, acrQueue.RateEnd, acrQueue.IsContractedRate, acrQueue.HeatIndexSourceId,
				acrQueue.HeatRate, acrQueue.TransferRate, acrQueue.GrossMargin, acrQueue.CommissionRate, acrQueue.AdditionalGrossMargin,
				acrQueue.PriceId, acrQueue.ProductCrossPriceMultiID, acrQueue.IsCustomEnd, acrQueue.ModifiedBy, acrQueue.CreatedBy,
				(int) acrQueue.Status, acrQueue.StatusNotes, acrQueue.SendDate );
		}

		public static void UpdateAccountContractRateQueueStatus( int queueID, int status, string statusNotes, int modifiedBy )
		{
			CRMLibertyPowerSql.UpdateAccountContractRateQueueStatus( queueID, status, statusNotes, modifiedBy );
		}

		public static void DeleteAccountContractRateQueue( int queueID )
		{
			CRMLibertyPowerSql.DeleteAccountContractRateQueue( queueID );
		}

		public static List<AccountContractRateQueue> GetAccountContractRateQueueForAcr( DateTime startDate, DataTable status )
		{
			List<AccountContractRateQueue> list = new List<AccountContractRateQueue>();

			DataSet ds = CRMLibertyPowerSql.GetAccountContractRateQueueForAcr( startDate, status );

			if( DataSetHelper.HasRow( ds ) )
			{
				list.AddRange( from DataRow dr in ds.Tables[0].Rows select BuildAccountContractRateQueue( dr ) );
			}
			return list;
		}

		/// <summary>
		///  VAR ACR Entry.  When VRE is generating a VAR price that we are registering, then we bypass Channel price lookup, lagacy checks, etc.
		/// </summary>
		/// <param name="accountContractRate">The ACR Entry</param>
		/// <param name="errors">Error list if any</param>
		/// <returns>Did it work?</returns>
		private static bool processForVARRates( AccountContractRate accountContractRate, out List<GenericError> errors )
		{
			errors = new List<GenericError>();

			////
			// The enrollment system's default AccountContractRate structure defaults
			// the rate to contractrate = true. We need to clear that flag due to this
			// being a variable rate.
			///
			accountContractRate.IsContractedRate = false;

			////
			// Although validation typeically goes into teh model, the validation set out for the API/VAR
			// rate is different from a normal enrollment validation.  With that in mind we wil validate
			// those special elements here.  We may want to merge these into the model validation at a later
			// date, but we want to make sure we don't change the existing behavior.
			///
			if( !isValidVARRateRequest( accountContractRate, ref errors ) )
			{
				return false;
			}

			DataSet ds = CRMLibertyPowerSql.InsertAccountContractRate( accountContractRate.AccountContractId, accountContractRate.LegacyProductId, accountContractRate.Term, accountContractRate.RateId, accountContractRate.Rate, accountContractRate.RateCode, accountContractRate.RateStart, accountContractRate.RateEnd, accountContractRate.IsContractedRate, accountContractRate.HeatIndexSourceId, accountContractRate.HeatRate, accountContractRate.TransferRate, accountContractRate.GrossMargin, accountContractRate.CommissionRate, accountContractRate.AdditionalGrossMargin, accountContractRate.PriceId, accountContractRate.ProductCrossPriceMultiID, accountContractRate.IsCustomEnd, accountContractRate.ModifiedBy, accountContractRate.CreatedBy, accountContractRate.ContractRate );

			MapDataRowToAccountContractRate( ds.Tables[0].Rows[0], accountContractRate );

			return true;
		}

		private static bool isValidVARRateRequest( AccountContractRate accountContractRate, ref List<GenericError> errors )
		{
			bool isValid = true;
			if( accountContractRate.RateStart >= accountContractRate.RateEnd )
			{
				errors.Add( new GenericError() { Code = 999, Message = "Rate start needs to be earlier than rate end" } );
				isValid = false;
			}

			if( accountContractRate.Rate <= 0 )
			{
				errors.Add( new GenericError() { Code = 999, Message = "Rate must be greater than 0" } );
				isValid = false;
			}

			if( accountContractRate.Term <= 0 )
			{
				errors.Add( new GenericError() { Code = 999, Message = "Term must be greater than 0" } );
				isValid = false;
			}

			return isValid;
		}

		/// <summary>
		///  Handles traditional ACR entries.  This is the normal path for contract rates managed by enrollment.
		/// </summary>
		/// <param name="accountContractRate">The ACR Entry</param>
		/// <param name="errors">Error list if any</param>
		/// <returns>Did it work?</returns>
		private static bool processForContractRates( AccountContractRate accountContractRate, out List<GenericError> errors )
		{
			errors = new List<GenericError>();

			// We need to prepopulate legacy product and rate info:
			int isFlexible = 0;
			PricingBal.CrossProductPriceSalesChannel price = PricingBal.CrossProductPriceFactory.GetSalesChannelPrice( accountContractRate.PriceId.Value );

			if( price == null )
			{
				errors.Add( new GenericError() { Code = 1, Message = "AccountContractRate: Could not find the priceId record" } );
				return false;
			}

			if( price.ChannelType.Identity == 2 )
			{
				isFlexible = 1;
			}

			if( string.IsNullOrEmpty( accountContractRate.LegacyProductId ) )
				accountContractRate.LegacyProductId = GetLegacyProductId( price.ProductBrand.ProductBrandID, price.Utility.Code, price.Segment.Identity, isFlexible );

			if( !accountContractRate.RateId.HasValue )
			{
				accountContractRate.RateId = ProductBal.ProductRateFactory.GetNewRateID();
			}

			if( !accountContractRate.RateId.HasValue )
			{
				errors.Add( new GenericError() { Code = 1, Message = "AccountContractRate: Could not find the RateId record" } );
				return false;
			}

			if( string.IsNullOrEmpty( accountContractRate.LegacyProductId ) )
			{
				errors.Add( new GenericError() { Code = 1, Message = "AccountContractRate: Could not find the LegacyProductId record" } );
				return false;
			}

			if( !accountContractRate.TransferRate.HasValue )
			{
				accountContractRate.TransferRate = Convert.ToDouble( price.Price );
			}

			//TODO: Find out why this is disabled
			// multi-term price
			// Disabled 
			//if( price.ProductType.Identity == 7 )
			//{
			//    PricingBal.MultiTermList multiTermList = PricingBal.DailyPricingFactory.GetMultiTermByPriceID( price.Identity );
			//    if( CollectionHelper.HasItem( multiTermList ) )
			//    {
			//        price.GrossMargin = multiTermList[0].MarkupRate / 1000;
			//        price.Price = multiTermList[0].Price;
			//    }
			//}

			//add rate to the legacy rateID common product table 
			ProductBal.ProductRateFactory.AddProductRate( accountContractRate.LegacyProductId, accountContractRate.RateId.Value, decimal.Parse( accountContractRate.Rate.Value.ToString() ), price.DisplayText, price.Term, price.GrossMargin, string.Empty, 0, price.StartDate, price.CostRateEffectiveDate, price.CostRateExpirationDate, 365, price.Zone.Identity, price.ServiceClass.Identity, DateTime.Today, DateTime.Today, accountContractRate.CreatedBy.ToString() );

			// Validate grace period:
			// the username part is not used so hardcoded it
			// Disabled by: 1-55554252
			//int gracePeriod = AccountManagement.ContractValidation.GetGracePeriodByProductIdAndRateId( "libertypower\\system", accountContractRate.LegacyProductId, accountContractRate.RateId.Value );
			//if( gracePeriod != 0 )
			//{
			//    if( accountContractRate.RateStart.AddDays( gracePeriod ) <= DateTime.Today )
			//    {
			//        string str = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.AccountDal.SelectMessage( LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.LpMessageApplication.DEAL, "00000036" );
			//        errors.Add( new GenericError() { Code = 1, Message = str } );
			//        return false;
			//    }
			//}

            DataSet ds = CRMLibertyPowerSql.InsertAccountContractRate(accountContractRate.AccountContractId, accountContractRate.LegacyProductId, accountContractRate.Term, accountContractRate.RateId, accountContractRate.Rate, accountContractRate.RateCode, accountContractRate.RateStart, accountContractRate.RateEnd, accountContractRate.IsContractedRate, accountContractRate.HeatIndexSourceId, accountContractRate.HeatRate, accountContractRate.TransferRate, accountContractRate.GrossMargin, accountContractRate.CommissionRate, accountContractRate.AdditionalGrossMargin, accountContractRate.PriceId, accountContractRate.ProductCrossPriceMultiID, accountContractRate.IsCustomEnd, accountContractRate.ModifiedBy, accountContractRate.CreatedBy, accountContractRate.ContractRate);

			MapDataRowToAccountContractRate( ds.Tables[0].Rows[0], accountContractRate );

			return true;
		}

		public static bool UpdateAccountContractRate( AccountContractRate accountContractRate, out List<GenericError> errors )
		{
			errors = new List<GenericError>();

			if( !accountContractRate.IsStructureValidForUpdate() )
			{
				throw new InvalidOperationException( "The structure of the AccountContractRate Object is not valid" );
			}

			errors = accountContractRate.IsValidForUpdate();

			if( errors.Count > 0 )
			{
				return false;
			}

            DataSet ds = CRMLibertyPowerSql.UpdateAccountContractRate(accountContractRate.AccountContractRateId, accountContractRate.AccountContractId, accountContractRate.LegacyProductId, accountContractRate.Term, accountContractRate.RateId, accountContractRate.Rate, accountContractRate.ContractRate, accountContractRate.RateCode, accountContractRate.RateStart, accountContractRate.RateEnd, accountContractRate.IsContractedRate, accountContractRate.HeatIndexSourceId, accountContractRate.HeatRate, accountContractRate.TransferRate, accountContractRate.GrossMargin, accountContractRate.CommissionRate, accountContractRate.AdditionalGrossMargin, accountContractRate.PriceId, accountContractRate.ProductCrossPriceMultiID, accountContractRate.ModifiedBy);

			MapDataRowToAccountContractRate( ds.Tables[0].Rows[0], accountContractRate );

			return true;
		}

		private static void MapDataRowToAccountContractRate( DataRow dataRow, AccountContractRate accountContractRate )
		{
			accountContractRate.AccountContractRateId = dataRow.Field<int?>( "AccountContractRateID" );
			accountContractRate.AccountContractId = dataRow.Field<int?>( "AccountContractID" );
			accountContractRate.LegacyProductId = dataRow.Field<String>( "LegacyProductID" );
			accountContractRate.Term = dataRow.Field<int?>( "Term" );
			accountContractRate.RateId = dataRow.Field<int?>( "RateID" );
			accountContractRate.Rate = dataRow.Field<Double?>( "Rate" );
            accountContractRate.ContractRate = dataRow.Field<Double?>("ContractRate");//PBI 142028 - Andre Damasceno - 10/10/2016 - Added new column
			accountContractRate.RateCode = dataRow.Field<String>( "RateCode" );
			accountContractRate.RateStart = dataRow.Field<DateTime>( "RateStart" );
			accountContractRate.RateEnd = dataRow.Field<DateTime>( "RateEnd" );
			accountContractRate.IsContractedRate = dataRow.Field<bool>( "IsContractedRate" );
			accountContractRate.HeatIndexSourceId = dataRow.Field<int?>( "HeatIndexSourceID" );
			accountContractRate.HeatRate = dataRow.Field<Decimal?>( "HeatRate" );
			accountContractRate.TransferRate = dataRow.Field<Double?>( "TransferRate" );
			accountContractRate.GrossMargin = dataRow.Field<Double?>( "GrossMargin" );
			accountContractRate.CommissionRate = dataRow.Field<Double?>( "CommissionRate" );
			accountContractRate.AdditionalGrossMargin = dataRow.Field<Double?>( "AdditionalGrossMargin" );
			accountContractRate.PriceId = dataRow.Field<Int64?>( "PriceId" );
			accountContractRate.Modified = dataRow.Field<DateTime>( "Modified" );
			accountContractRate.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
			accountContractRate.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            accountContractRate.CreatedBy = dataRow.Field<int>("CreatedBy");

			if( dataRow.Table.Columns.Contains( "ProductCrossPriceMultiID" ) )
			{
				accountContractRate.ProductCrossPriceMultiID = dataRow.Field<Int64?>( "ProductCrossPriceMultiID" );
			}
		}

		/// <summary>
		/// Attempts to get the current rate in specified list.
		///  If none are current, attempts to get first rate in the future.
		///   If all are in the past, will return null.
		/// </summary>
		/// <param name="multiTermList">Account contract rate list</param>
		/// <returns>Returns current or upcoming rate, or null if not found.</returns>
		public static AccountContractRate GetCurrentAccountContractRate( AccountContractRateList rateList )
		{
			DateTime today = DateTime.Today;
			AccountContractRate rate = null;

			if( CollectionHelper.HasItem( rateList ) )
			{
				// first, try to get current rate
				rate = (from r in rateList
						where r.RateStart <= today && r.RateEnd >= today
						select r).FirstOrDefault();

				// if no rate is in effect, 
				// try to get first one in the future.
				if( rate == null )
				{
					DateTime minDate = rateList.Min( r => r.RateStart );
					if( minDate > today )
					{
						rate = (from r in rateList
								where r.RateStart == minDate
								select r).FirstOrDefault();
					}
				}
			}
			return rate;
		}

		/// <summary>
		/// Updates rates for account
		/// </summary>
		/// <param name="rateToSave">New rate for current account contract rate</param>
		/// <param name="currentAccountContractRate">Current account contract rate object</param>
		/// <param name="accountContractRateList">Account contract rate list object</param>
		/// <returns>Returns any errors in the update process</returns>
		public static List<GenericError> UpdateAccountContractRates( double newRate, AccountContractRate currentAccountContractRate, AccountContractRateList accountContractRateList )
		{
			List<GenericError> errors = null;

			if( newRate > 0 && currentAccountContractRate != null && accountContractRateList != null )
			{
				double currentRate = (double) ( currentAccountContractRate.ContractRate == null ? 0 : currentAccountContractRate.ContractRate );
				double rateDiff = newRate - currentRate;

				foreach( AccountContractRate acr in accountContractRateList )
				{
                    if (acr.ContractRate == null)
                        acr.ContractRate = 0;
                    acr.ContractRate = acr.ContractRate + rateDiff;
					UpdateAccountContractRate( acr, out errors );
				}
			}
			return errors;
		}

		/// <summary>
		/// Updates rates for account
		/// </summary>
		/// <param name="rateToSave">New rate for current account contract rate</param>
		/// <param name="currentAccountContractRate">Current account contract rate object</param>
		/// <param name="accountContractRateList">Account contract rate list object</param>
		/// <returns>Returns any errors in the update process</returns>
		public static List<GenericError> UpdateAccountContractRates_StartDate( DateTime newStartDate, int term, AccountContractRateList accountContractRateList )
		{
			List<GenericError> errors = null;

			if( accountContractRateList != null )
			{
				DateTime firstRateStart = (from r in accountContractRateList
										   where r.RateStart == accountContractRateList.Min( s => s.RateStart )
										   select r).FirstOrDefault().RateStart;
				int daysDiff = (newStartDate - firstRateStart).Days;
				int lastAccountContractRateId = Convert.ToInt32( (from r in accountContractRateList
																  where r.RateStart == accountContractRateList.Max( s => s.RateStart )
																  select r).FirstOrDefault().AccountContractRateId );

				foreach( AccountContractRate acr in accountContractRateList )
				{
					acr.RateStart = acr.RateStart.AddDays( daysDiff );

					if( accountContractRateList.Count == 1 ) // standard term
					{
						acr.RateEnd = acr.RateStart.AddMonths( term ).AddDays( -1 );
					}
					else // multi-term
					{
						if( acr.AccountContractRateId != lastAccountContractRateId )
						{
							acr.RateEnd = acr.RateEnd.AddDays( daysDiff );
						}
					}
					UpdateAccountContractRate( acr, out errors );
				}
			}
			return errors;
		}

		// Toggle ! yay !			//NOTE: Toggle the callers, not the new functionality.  That way everything still compiles.  Yay!
		public static PricingBal.MultiTermList ConvertAccountContractRateToMultiTerm( AccountContractRateList accountContractRateList )
		{
			PricingBal.MultiTermList multiTermList = new PricingBal.MultiTermList();

			if( CollectionHelper.HasItem( accountContractRateList ) )
			{
				foreach( AccountContractRate acr in accountContractRateList )
				{
					int productCrossPriceMultiId = Convert.ToInt32( acr.ProductCrossPriceMultiID ?? 0 );
					const int productCrossPriceId = 0;
					DateTime startDate = acr.RateStart;
					int term = acr.Term ?? 0;
					decimal markupRate = Convert.ToDecimal( acr.GrossMargin ?? 0 );
					decimal price = Convert.ToDecimal( acr.Rate ?? 0 );
					multiTermList.Add( new PricingBal.MultiTerm( productCrossPriceMultiId, productCrossPriceId, startDate, term, markupRate, price ) );
				}
			}
			return multiTermList;
		}

		/// <summary>
		/// Updates rates for account
		/// </summary>
		/// <param name="rateToSave">New rate for current account contract rate</param>
		/// <param name="currentAccountContractRate">Current account contract rate object</param>
		/// <param name="accountContractRateList">Account contract rate list object</param>
		/// <returns>Returns any errors in the update process</returns>
		public static List<GenericError> UpdateAccountContractRates( AccountContractRateList accountContractRateList )
		{
			List<GenericError> errors = null;

			foreach( AccountContractRate acr in accountContractRateList )
			{
				UpdateAccountContractRate( acr, out errors );
			}
			return errors;
		}

		public static AccountContractRateList ModifyAccountContractRates( AccountContractRateList accountContractRateList, PricingBal.MultiTermList multiTermList )
		{
			if( CollectionHelper.HasItem( accountContractRateList ) && CollectionHelper.HasItem( multiTermList ) )
			{
				foreach( AccountContractRate acr in accountContractRateList )
				{
					PricingBal.MultiTerm mt = (from m in multiTermList
											   where m.ProductCrossPriceMultiID == acr.ProductCrossPriceMultiID
											   select m).FirstOrDefault();
					if( mt != null )
					{
						acr.Term = mt.Term;
						acr.Rate = (double?) mt.Price;
					}
				}
			}
			return accountContractRateList;
		}

		/// <summary>
		/// Updates rates for account
		/// </summary>
		/// <param name="newStartDate">The new start date</param>
		/// <param name="accountContractRateList">Account contract rate list object</param>
		/// <returns>Returns any errors in the update process</returns>
		public static List<GenericError> UpdateAccountContractRatesStartDate( DateTime newStartDate, AccountContractRateList accountContractRateList )
		{
			List<GenericError> errors = null;

			if( accountContractRateList == null )
			{
				return null;
			}

			var rateStartMin = (from r in accountContractRateList
								where r.RateStart == accountContractRateList.Min( s => s.RateStart )
								select r).FirstOrDefault();

			DateTime firstRateStart = (rateStartMin != null ? rateStartMin.RateStart : new DateTime());

			int daysDiff = (newStartDate - firstRateStart).Days;

			var ratesStartMax = (from r in accountContractRateList
								 where r.RateStart == accountContractRateList.Max( s => s.RateStart )
								 select r).FirstOrDefault();

			int lastAccountContractRateId = Convert.ToInt32( ratesStartMax != null ? ratesStartMax.AccountContractRateId : 0 );

			foreach( AccountContractRate acr in accountContractRateList )
			{
				acr.RateStart = acr.RateStart.AddDays( daysDiff );

				if( acr.AccountContractRateId != lastAccountContractRateId )
				{
					acr.RateEnd = acr.RateEnd.AddDays( daysDiff );
				}

				UpdateAccountContractRate( acr, out errors );
			}

			return errors;
		}

		public static AccountContractRateList ConvertMultiTermToAccountContractRate( PricingBal.MultiTermList multiTermList )
		{
			AccountContractRateList accountContractRateList = new AccountContractRateList();

			if( CollectionHelper.HasItem( multiTermList ) )
			{
				foreach( PricingBal.MultiTerm mt in multiTermList )
				{
					int productCrossPriceMultiId = Convert.ToInt32( mt.ProductCrossPriceMultiID );
					const int productCrossPriceId = 0;
					DateTime startDate = mt.StartDate;
					int term = mt.Term;
					double markupRate = Convert.ToDouble( mt.MarkupRate );
					double price = Convert.ToDouble( mt.Price );
					accountContractRateList.Add( new AccountContractRate( productCrossPriceMultiId, startDate, term, (double?) markupRate, (double?) price ) );
				}
			}
			return accountContractRateList;
		}


		/// <summary>
		/// 
		/// </summary>
		/// <param name="productBrandId"></param>
		/// <param name="utilityCode"></param>
		/// <param name="legacyAccountType">This is NOT the primary id of Libertypower..AccountType, should be the [ProductAccountTypeID]</param>
		/// <param name="isFlexible"></param>
		/// <returns></returns>
		public static string GetLegacyProductId( int productBrandId, string utilityCode, int legacyAccountTypeId, int isFlexible )
		{
			string legacyProductId = string.Empty;

			// try  the old fashion way:
			legacyProductId = ProductBal.ProductFactory.GetProductID( productBrandId, utilityCode, legacyAccountTypeId, isFlexible );

			if( string.IsNullOrWhiteSpace( legacyProductId ) )
			{
				// try with dal:
				DALEntity.Lp_commonEntities dal = new DALEntity.Lp_commonEntities();
				utilityCode = utilityCode.ToUpper();
				var matches = from p in dal.common_product
							  where p.ProductBrandID == productBrandId
							  && p.utility_id.ToUpper() == utilityCode
							  && p.account_type_id == legacyAccountTypeId
							  select p;

				if( matches != null && matches.Count() > 0 )
				{
					legacyProductId = matches.First().product_id.Trim().ToUpper();
				}

			}
			return legacyProductId;
		}

		public static void DeleteAdditionalAccountContractRates( int accountContractRateID, AccountContractRateList accountContractRateList )
		{
			foreach( AccountContractRate acr in accountContractRateList )
			{
				if( (int) acr.AccountContractRateId != accountContractRateID )
					DeleteAccountContractRate( (int) acr.AccountContractRateId );
			}
		}

		public static void DeleteAccountContractRate( int accountContractRateID )
		{
			LibertyPowerSql.DeleteAccountContractRate( accountContractRateID );
		}

		public static void GetUpdatedAccountContractRate( AccountContractRate acr, Int64 priceID, int userID )
		{
			acr.PriceId = priceID;
			acr.Modified = DateTime.Now;
			acr.ModifiedBy = userID;

			string productID = String.Empty;
			int? rateId = null;
			int? term = null;
			double? rate = null;
			double? cost = null;
			decimal? commission = null;
			double? grossMargin = null;
			DateTime startDate = acr.RateStart;
			DateTime endDate = acr.RateEnd;
			string zone = String.Empty;
			string serviceClass = String.Empty;
            long? productCrossPriceMultiID = null;

			// custom price
			DataSet ds = ProspectContractFactory.GetCustomRate( priceID );
			if( DataSetHelper.HasRow( ds ) )
			{
				DataRow dr = ds.Tables[0].Rows[0];

				productID = dr["ProductId"].ToString();
				rateId = Convert.ToInt32( dr["RateId"] );
				term = dr["Term"] != DBNull.Value ? (int?) dr["Term"] : 0;
				rate = dr["ContractRate"] != DBNull.Value ? (double?) Convert.ToDouble( dr["ContractRate"] ) : null;
				cost = dr["Cost"] != DBNull.Value ? (double?) Convert.ToDouble( dr["Cost"] ) : null;
				commission = dr["Commission"] != DBNull.Value ? (decimal?) dr["Commission"] : null;
				grossMargin = dr["GrossMargin"] != DBNull.Value ? (double?) Convert.ToDouble( dr["GrossMargin"] ) : null;

				startDate = dr["StartDate"] != DBNull.Value ? new DateTime (Convert.ToDateTime(dr["StartDate"].ToString()).Year, 
                    Convert.ToDateTime(dr["StartDate"].ToString()).Month, acr.RateStart.Day) : acr.RateStart;               
				
                endDate = startDate.AddMonths( (int) term ).AddDays( -1 );
			}
			else // standard price
			{
				PricingBal.CrossProductPriceSalesChannel price = PricingBal.CrossProductPriceFactory.GetSalesChannelPrice( priceID );
				if( price != null )
				{
                    rateId = AddProductRate(priceID, out productID, out rate, out zone, out serviceClass);

                    if (price.ProductBrand.IsMultiTerm)
                    {
                        PricingBal.CrossProductPriceSalesChannel cppsc = PricingBal.CrossProductPriceFactory.GetSalesChannelPrice(priceID);
                        PricingBal.MultiTerm multiTerm = PricingBal.DailyPricingFactory.GetMultiTermCurrent(price.MultiTermList);
                        acr.ProductCrossPriceMultiID = multiTerm.ProductCrossPriceMultiID;
                        rate = Convert.ToDouble(multiTerm.Price);
                        startDate = new DateTime(multiTerm.StartDate.Year, multiTerm.StartDate.Month, acr.RateStart.Day);
                        term = multiTerm.Term;
                        endDate = startDate.AddMonths((int)term).AddDays(-1);

                        cost = (double?)multiTerm.Price;
                        grossMargin = (double?)multiTerm.MarkupRate;
                    }
                    else
                    {
                        term = price.Term;
                        cost = (double?)price.Price;
                        grossMargin = (double?)price.GrossMargin;
                        startDate = new DateTime(price.StartDate.Year, price.StartDate.Month, acr.RateStart.Day);
                        endDate = startDate.AddMonths((int)term).AddDays(-1);
                    }
				}
			}

			acr.LegacyProductId = productID;
			acr.RateId = rateId;
			acr.Rate = rate;
			acr.TransferRate = cost;
			acr.Term = term;
			acr.RateStart = startDate;
			acr.RateEnd = endDate;
			acr.GrossMargin = grossMargin;
			acr.ProductCrossPriceMultiID = productCrossPriceMultiID;
		}

		public static bool AccountIsRenewing( int accountID )
		{
			DataSet ds = CRMLibertyPowerSql.AccountIsRenewing( accountID );

			if( DataSetHelper.HasRow( ds ) )
			{
				return Convert.ToBoolean( ds.Tables[0].Rows[0][0] );
			}
			return false;
		}

		public static bool AccountIsActive( int accountID )
		{
			DataSet ds = CRMLibertyPowerSql.AccountIsActive( accountID );

			if( DataSetHelper.HasRow( ds ) )
			{
				return Convert.ToBoolean( ds.Tables[0].Rows[0][0] );
			}
			return false;
		}

		public static AccountContractRate DemoteAccountContractRateQueue( AccountContractRateQueue account, int userID )
		{
			return new AccountContractRate()
			{
				AccountContractId = account.AccountContractId,
				AccountContractRateId = account.AccountContractRateId,
				AdditionalGrossMargin = account.AdditionalGrossMargin,
				CommissionRate = account.CommissionRate,
				CreatedBy = userID,
				DateCreated = DateTime.Now,
				GrossMargin = account.GrossMargin,
				HeatIndexSourceId = account.HeatIndexSourceId,
				HeatRate = account.HeatRate,
				IsContractedRate = account.IsContractedRate,
				IsCustomEnd = account.IsCustomEnd,
				IsVariable = account.IsVariable,
				LegacyProductId = account.LegacyProductId,
				Modified = DateTime.Now,
				ModifiedBy = userID,
				Price = account.Price,
				PriceId = account.PriceId,
				ProductCrossPriceMultiID = account.ProductCrossPriceMultiID,
				Rate = account.Rate,
				RateCode = account.RateCode,
				RateEnd = account.RateEnd,
				RateId = account.RateId,
				RateStart = account.RateStart,
				Term = account.Term,
				TransferRate = account.TransferRate
			};
		}

		private static int? AddProductRate( Int64 priceID, out string productId, out double? rate, out string zone, out string serviceClass )
		{
			int isFlexible = 0;
			rate = 0;
			int? rateID = 0;
			productId = String.Empty;
			zone = String.Empty;
			serviceClass = String.Empty;

			PricingBal.CrossProductPriceSalesChannel price = PricingBal.CrossProductPriceFactory.GetSalesChannelPrice( priceID );
			if( price != null )
			{
				if( price.ChannelType.Identity == 2 ) { isFlexible = 1; }

				rateID = ProductBal.ProductRateFactory.GetNewRateID();
				rate = (double?) price.Price;
				string rateDescription = price.DisplayText;
				int term = price.Term;
				decimal grossMargin = price.GrossMargin;
				string indexType = String.Empty;
				int billingTypeID = 0;
				DateTime startDate = price.StartDate;
				DateTime effectiveDate = price.CostRateEffectiveDate;
				DateTime dueDate = price.CostRateExpirationDate;
				int gracePeriod = 365;
				int zoneID = price.Zone.Identity;
				int serviceClassID = price.ServiceClass.Identity;
				DateTime activeDate = DateTime.Today;
				DateTime dateCreated = DateTime.Today;
				string username = "ENROLLMENT";

				Zone z = ZoneFactory.GetZone( zoneID );
				if( z != null ) { zone = z.ZoneCode; }

				ServiceClass s = ServiceClassFactory.GetServiceClass( serviceClassID );
				if( s != null ) { serviceClass = s.Code; }

				string utilityCode = price.Utility.Code;
				int productBrandID = price.ProductBrand.ProductBrandID;
				int accountTypeID = PricingBal.DailyPricingFactory.ConvertAccountTypeID( price.Segment.Identity, "LEGACY" );

				productId = ProductBal.ProductFactory.GetProductID( productBrandID, utilityCode, accountTypeID, isFlexible );

				ProductBal.ProductRateFactory.AddProductRate( productId, (int) rateID, (decimal) rate, rateDescription, term, grossMargin, indexType, billingTypeID,
					startDate, effectiveDate, dueDate, gracePeriod, zoneID, serviceClassID, activeDate, dateCreated, username );
			}
			return rateID;
		}
        /// <summary>
        /// This method updates the RateEnd and IsCustomEnd flag for AccountContractRate record.
        /// </summary>
        /// <param name="accountContractRate"></param>
        /// <param name="errors"></param>
        /// <returns>Returns True if the operation is successful otherwise returns False.</returns>
        public static bool AdjustRolloverContractEndDate(AccountContractRate accountContractRate, out List<GenericError> errors)
        {
            errors = new List<GenericError>();

            if (!accountContractRate.IsStructureValidForUpdate())
            {
                throw new InvalidOperationException("The structure of the AccountContractRate Object is not valid");
            }

            errors = accountContractRate.IsValidForUpdate();

            if (errors.Count > 0)
            {
                return false;
            }
            return LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.ContractDal.AdjustRolloverContractEndDate(accountContractRate.AccountContractRateId.Value,
                accountContractRate.RateEnd, accountContractRate.IsCustomEnd, accountContractRate.ModifiedBy);
        }
    
    
    }
}
