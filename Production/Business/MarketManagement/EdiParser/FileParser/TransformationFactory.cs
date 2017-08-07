namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Class for transforming objects and data types
	/// </summary>
	public static class TransformationFactory
	{
		/// <summary>
		/// Transforms strings to correct data types for account and associated usage objects.
		/// </summary>
		/// <param name="ediAccountList">List of accounts with their associated usage  having all properties as strings.</param>
		/// <param name="fileType">Format of the file (814, 867 or status update).</param>
		/// <returns>Returns an account list and associated usage objects.</returns>
		public static UtilityUsageAccountList TransformEdiAccountList( EdiAccountList ediAccountList, EdiFileType fileType )
		{
			UtilityUsageAccountList accountList = new UtilityUsageAccountList();

			foreach( EdiAccount ediAccount in ediAccountList )
			{
				//System.Diagnostics.Debug.Print( "Account: " + ediAccount.AccountNumber );
				UtilityUsageAccount account = new UtilityUsageAccount();

				account.AccountNumber = ediAccount.AccountNumber;
				account.AnnualUsage = Convert.ToInt32( ediAccount.AnnualUsage );
				account.BillCalculation = ediAccount.BillCalculation;
				account.BillGroup =  ediAccount.BillGroup ;
				account.BillingAccount = ediAccount.BillingAccount;
				account.BillingAddress = ediAccount.BillingAddress;
				account.BillingType = ediAccount.BillingType;

				if( ediAccount.Contact != null )
				{
					account.ContactName = ediAccount.Contact.Name;
					account.Telephone = ediAccount.Contact.Telephone;
					account.HomePhone = ediAccount.Contact.HomePhone;
					account.WorkPhone = ediAccount.Contact.WorkPhone;
					account.Fax = ediAccount.Contact.Fax;
					account.EmailAddress = ediAccount.Contact.EmailAddress;
				}

				account.ContractStartDate = (ediAccount.ServicePeriodStart != null) ? ediAccount.ServicePeriodStart : DateHelper.DefaultDate;
				account.ContractEndDate = (ediAccount.ServicePeriodEnd != null) ? ediAccount.ServicePeriodEnd : DateHelper.DefaultDate;
				account.CustomerName = ediAccount.CustomerName;
				account.DunsNumber = ediAccount.DunsNumber;
				account.EnrollmentStatus = ediAccount.AccountStatus;
				account.EspAccount = ediAccount.EspAccount;
				account.Icap = ediAccount.Icap;
				account.LoadProfile = ediAccount.LoadProfile;
				account.LossFactor = ediAccount.LossFactor;
				account.MeterMultiplier = ediAccount.MeterMultiplier;
				account.MeterNumber = ediAccount.MeterNumber;
				account.MeterType = ediAccount.MeterType;
				account.MonthsToComputeKwh = Convert.ToInt16( ediAccount.MonthsToComputeKwh );
				account.NameKey = ediAccount.NameKey;
				account.PreviousAccountNumber = ediAccount.PreviousAccountNumber;
				account.ProductAltType = ediAccount.ProductAltType;
				account.ProductType = ediAccount.ProductType;
				account.RateClass = ediAccount.RateClass;
				account.RetailMarketCode = ediAccount.RetailMarketCode;
				account.ServiceAddress = ediAccount.ServiceAddress;
				account.ServiceDeliveryPoint = ediAccount.ServiceDeliveryPoint;
				account.ServiceType = ediAccount.ServiceType;
				account.Tcap = Convert.ToDecimal( ediAccount.Tcap );
				account.TransactionType = ediAccount.TransactionType;
				account.UtilityCode = ediAccount.UtilityCode;
				account.Voltage = ediAccount.Voltage;
				account.ZoneCode = ediAccount.ZoneCode;

				if( fileType == EdiFileType.EightSixSeven )	// 814's don't have usage..
				{
					account.UtilityUsageList = TransformEdiUsageList( ediAccount.EdiUsageList );

					if( ediAccount.IdrUsageList != null && ediAccount.IdrUsageList.Count > 0 )
						account.IdrUsageList = TransformIdrUsageList( ediAccount.IdrUsageList );
				}

				accountList.Add( account );
			}
			return accountList;
		}

		/// <summary>
		/// Transforms strings to correct data types for usage objects.
		/// </summary>
		/// <param name="ediUsageList">Edi usage list</param>
		/// <returns>Returns a usage list</returns>
		private static UtilityUsageList TransformEdiUsageList( EdiUsageList ediUsageList )
		{
			UtilityUsageList usageList = new UtilityUsageList();

			foreach( EdiUsage ediUsage in ediUsageList )
			{
				if( ediUsage.BeginDate == null || ediUsage.BeginDate == DateHelper.DefaultDate )									// per duggy - 02/07/2011
					return usageList;

				UtilityUsage usage = new UtilityUsage();
				usage.BeginDate = ediUsage.BeginDate ;
				usage.EndDate = ediUsage.EndDate ;
				usage.MeasurementSignificanceCode = ediUsage.MeasurementSignificanceCode == null ? "" : ediUsage.MeasurementSignificanceCode;
				usage.MeterNumber = ediUsage.MeterNumber == null ? "" : ediUsage.MeterNumber;
				usage.ServiceDeliveryPoint = ediUsage.ServiceDeliveryPoint == null ? "" : ediUsage.ServiceDeliveryPoint;
				usage.Quantity = ediUsage.Quantity;
				usage.TransactionSetPurposeCode = ediUsage.TransactionSetPurposeCode == null ? "" : ediUsage.TransactionSetPurposeCode;
				usage.UnitOfMeasurement = ediUsage.UnitOfMeasurement == null ? "" : ediUsage.UnitOfMeasurement;
				usage.UsageSource = UsageSource.Edi;
				usage.UsageType = UsageType.Historical;
				usage.PtdLoop = ediUsage.PtdLoop == null ? "" : ediUsage.PtdLoop;

				usageList.Add( usage );
			}


			return usageList;
		}

		// September 2010
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Transforms strings to correct data types for idr-usage objects.
		/// </summary>
		/// <param name="idrList">Idr usage list</param>
		/// <returns>Returns an idr usage list</returns>
		public static UtilityIdrUsageList TransformIdrUsageList( Dictionary<string, EdiIdrUsage> idrList )
		{
			UtilityIdrUsageList list = new UtilityIdrUsageList();

			foreach( EdiIdrUsage idrUsage in idrList.Values )
			{
				UtilityIdrUsage usage = new UtilityIdrUsage();

				usage.Date = idrUsage.Date;
				usage.Interval = Convert.ToInt16( idrUsage.Interval);
				usage.Quantity = Convert.ToDecimal( idrUsage.Quantity );
				usage.TransactionSetPurposeCode = idrUsage.TransactionSetPurposeCode == null ? "" : idrUsage.TransactionSetPurposeCode;
				usage.UnitOfMeasurement = idrUsage.UnitOfMeasurement == null ? "" : idrUsage.UnitOfMeasurement;
				usage.PtdLoop = idrUsage.PtdLoop == null ? "" : idrUsage.PtdLoop;

				list.Add( usage );
			}

			return list;
		}

		}
	}
