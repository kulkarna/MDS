namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using DataSynchronizationServiceReference;
	using System.Data;
	using System.Security.Principal;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.Business.CommonBusiness.CommonEntity;

	// November 2010
    // Changes to Bill Group type by ManojTFS-63739 -3/09/15
	public static class ScraperFactory
	{
		#region AMEREN

		private static WebAccountList GetAmerenAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetAmerenScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildAmeren( dr ) );
			}
			return account;
		}

		private static Ameren BuildAmeren( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			Ameren account = new Ameren();
			account.AccountNumber = accountNumber;
            account.BillGroup = Convert.ToString(dr["BillGroup"] == DBNull.Value ? String.Empty : dr["BillGroup"]);
			account.CurrentSupplyGoupAndType = Convert.ToString( dr["CurrentSupplyGroupAndType"] == DBNull.Value ? String.Empty : dr["CurrentSupplyGroupAndType"] );
			account.CustomerName = Convert.ToString( dr["CustomerName"] == DBNull.Value ? String.Empty : dr["CustomerName"] );
			account.DeliveryVoltage = Convert.ToString( dr["DeliveryVoltage"] == DBNull.Value ? String.Empty : dr["DeliveryVoltage"] );
			account.EffectivePLC = Convert.ToDecimal( dr["EffectivePLC"] == DBNull.Value ? 0m : dr["EffectivePLC"] );
			account.EligibleSwitchDate = Convert.ToDateTime( dr["EligibleSwitchDate"] == DBNull.Value ? DateTime.MinValue : dr["EligibleSwitchDate"] );
			account.FutureSupplyGroupAndType = Convert.ToString( dr["FutureSupplyGroupAndType"] == DBNull.Value ? String.Empty : dr["FutureSupplyGroupAndType"] );
			//Per Ricky in pricing LoadShapeID should always fill LoadProfile from scraping (except CONED)
			account.LoadProfile = Convert.ToString( dr["ProfileClass"] == DBNull.Value ? String.Empty : dr["ProfileClass"] );
			account.LoadShapeId = Convert.ToString( dr["ProfileClass"] == DBNull.Value ? String.Empty : dr["ProfileClass"] );
			account.Meter = Convert.ToString( dr["MeterNumber"] == DBNull.Value ? String.Empty : dr["MeterNumber"] );
			account.MeterVoltage = Convert.ToString( dr["MeterVoltage"] == DBNull.Value ? String.Empty : dr["MeterVoltage"] );
            //Thought to do this...but might be confusing since it is actually at the meter level
            //account.Voltage = Convert.ToString(dr["MeterVoltage"] == DBNull.Value ? String.Empty : dr["MeterVoltage"]);
			account.OperatingCompany = Convert.ToString( dr["OperatingCompany"] == DBNull.Value ? String.Empty : dr["OperatingCompany"] );
			account.ServiceClass = Convert.ToString( dr["ServiceClass"] == DBNull.Value ? String.Empty : dr["ServiceClass"] );
			account.RateClass = Convert.ToString( dr["ServiceClass"] == DBNull.Value ? String.Empty : dr["ServiceClass"] );
			account.ServicePoint = Convert.ToString( dr["ServicePoint"] == DBNull.Value ? String.Empty : dr["ServicePoint"] );
			account.SupplyVoltage = Convert.ToString( dr["SupplyVoltage"] == DBNull.Value ? String.Empty : dr["SupplyVoltage"] );
			account.TransformationCharge = Convert.ToString( dr["TransformationCharge"] == DBNull.Value ? String.Empty : dr["TransformationCharge"] );
			account.UtilityCode = "AMEREN";
			account.WebUsageList = GetAmerenWebUsageList( accountNumber, from, to );
			account.ZoneCode = Convert.ToString( dr["OperatingCompany"] == DBNull.Value ? String.Empty : dr["OperatingCompany"] );

		    account.Icap = account.EffectivePLC;
			return account;
		}


		/// <summary>
		/// Returns the entire Ameren dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetAmerenListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetAmerenScrapedMeterReadsByOffer( offerID, "", from, to );
			return GetAmerenList( ds1, usageType );
		}


		// December 2010
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire Ameren dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
        private static UsageList GetAmerenList(string accountNumber, DateTime from, DateTime to, UsageType usageType)
        {
            return GetAmerenList(accountNumber, from, to, usageType, false);
        }

        private static UsageList GetAmerenList(string accountNumber, DateTime from, DateTime to, UsageType usageType, bool forUsageConsolidation)
        {

            DataSet ds1;
            if (forUsageConsolidation)
                ds1 = TransactionsSql.GetAmerenScrapedMeterReadsMostRecent(accountNumber, "", from, to);
            else
                ds1 = TransactionsSql.GetAmerenScrapedMeterReads(accountNumber, "", from, to);
            return GetAmerenList(ds1, usageType);
        }

		private static WebUsageList GetAmerenWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetAmerenScrapedMeterReads( accountNumber, "", from, to );
			return GetAmerenWebUsageList( ds );
		}

		private static WebUsageList GetAmerenWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildAmerenWebUsage( dr ) );
			}
			return list;
		}

		private static AmerenUsage BuildAmerenWebUsage( DataRow dr )
		{
			AmerenUsage usage = new AmerenUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] );
			usage.Days = Convert.ToInt32( dr["Days"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] );
			usage.MeterNumber = Convert.ToString( dr["MeterNumber"] == DBNull.Value ? String.Empty : dr["MeterNumber"] );
			usage.OffPeakDemandKw = Convert.ToDecimal( dr["OffPeakDemandKw"] == DBNull.Value ? 0m : dr["OffPeakDemandKw"] );
			usage.OffPeakKwh = Convert.ToDecimal( dr["OffPeakKwh"] == DBNull.Value ? 0m : dr["OffPeakKwh"] );
			usage.OnPeakDemandKw = Convert.ToDecimal( dr["OnPeakDemandKw"] == DBNull.Value ? 0m : dr["OnPeakDemandKw"] );
			usage.OnPeakKwh = Convert.ToDecimal( dr["OnPeakKwh"] == DBNull.Value ? 0m : dr["OnPeakKwh"] );
			usage.PeakReactivePowerKvar = Convert.ToDecimal( dr["PeakReactivePowerKvar"] == DBNull.Value ? 0m : dr["PeakReactivePowerKvar"] );
			usage.TotalKwh = Convert.ToInt32( dr["TotalKwh"] );

			return usage;
		}

		private static UsageList GetAmerenList( string accountNumber, string meterNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetAmerenScrapedMeterReads( accountNumber, meterNumber, from, to );
			return GetAmerenList( ds1, usageType );
		}

		private static UsageList GetAmerenList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetAmerenItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetAmerenItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "AMEREN";
			string meter = row["MeterNumber"] == DBNull.Value ? "" : (string) row["MeterNumber"];
			DateTime from = (DateTime) row["beginDate"];
			DateTime to = (DateTime) row["endDate"];
			int kwh = Convert.ToInt32( row["TotalKwh"] );

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.IsConsolidated = false;
			item.MeterNumber = meter;
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];

			return item;
		}

		#endregion

		#region BGE

		private static WebAccountList GetBgeAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetBgeScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildBge( dr ) );
			}
			return account;
		}

		private static Bge BuildBge( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			GeographicalAddress billingAddress = new GeographicalAddress();
			billingAddress.CityName = Convert.ToString( dr["BillingAddressCityName"] == DBNull.Value ? String.Empty : dr["BillingAddressCityName"] );
			billingAddress.PostalCode = Convert.ToString( dr["BillingAddressZipCode"] == DBNull.Value ? String.Empty : dr["BillingAddressZipCode"] );
			billingAddress.State = Convert.ToString( dr["BillingAddressStateCode"] == DBNull.Value ? String.Empty : dr["BillingAddressStateCode"] );
			billingAddress.Street = Convert.ToString( dr["BillingAddressStreet"] == DBNull.Value ? String.Empty : dr["BillingAddressStreet"] );

			GeographicalAddress serviceAddress = new GeographicalAddress();
			serviceAddress.CityName = Convert.ToString( dr["ServiceAddressCityName"] == DBNull.Value ? String.Empty : dr["ServiceAddressCityName"] );
			serviceAddress.PostalCode = Convert.ToString( dr["ServiceAddressZipCode"] == DBNull.Value ? String.Empty : dr["ServiceAddressZipCode"] );
			serviceAddress.State = Convert.ToString( dr["ServiceAddressStateCode"] == DBNull.Value ? String.Empty : dr["ServiceAddressStateCode"] );
			serviceAddress.Street = Convert.ToString( dr["ServiceAddressStreet"] == DBNull.Value ? String.Empty : dr["ServiceAddressStreet"] );

			Bge account = new Bge();
			account.AccountNumber = accountNumber;
			account.Address = serviceAddress;
            account.BillGroup = Convert.ToString(dr["BillGroup"] == DBNull.Value ? String.Empty : dr["BillGroup"]);
			account.BillingAddress = billingAddress;
			account.CapPLC = Convert.ToDecimal( dr["CapPLC"] == DBNull.Value ? 0m : dr["CapPLC"] );
			account.CustomerName = Convert.ToString( dr["AccountName"] == DBNull.Value ? String.Empty : dr["AccountName"] );
			account.CustomerSegment = Convert.ToString( dr["CustomerSegment"] == DBNull.Value ? String.Empty : dr["CustomerSegment"] );
			account.LoadProfile = Convert.ToString( dr["CustomerSegment"] == DBNull.Value ? String.Empty : dr["CustomerSegment"] );
            account.Icap = Convert.ToDecimal( dr["CapPLC"] == DBNull.Value ? 0m : dr["CapPLC"] );
			account.MultipleMeters = Convert.ToString( dr["MultipleMeters"] == DBNull.Value ? String.Empty : dr["MultipleMeters"] );
			account.POLRType = Convert.ToString( dr["POLRType"] == DBNull.Value ? String.Empty : dr["POLRType"] );
			account.SpecialBilling = Convert.ToString( dr["SpecialBilling"] == DBNull.Value ? String.Empty : dr["SpecialBilling"] );
			account.TariffCode = Convert.ToInt32( dr["TariffCode"] == DBNull.Value ? 0 : dr["TariffCode"] );
			account.Tcap = Convert.ToDecimal( dr["TransPLC"] == DBNull.Value ? 0m : dr["TransPLC"] );
			account.TransPLC = Convert.ToDecimal( dr["TransPLC"] == DBNull.Value ? 0m : dr["TransPLC"] );
			account.UtilityCode = "BGE";
			account.WebUsageList = GetBgeWebUsageList( accountNumber, from, to );

			return account;
		}

		/// <summary>
		/// Returns the entire Bge dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetBgeListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetBgeScrapedMeterReadsByOffer( offerID, from, to );
			return GetBgeList( ds1, usageType );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire Bge dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetBgeList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetBgeScrapedMeterReads( accountNumber, from, to );
			return GetBgeList( ds1, usageType );
		}

		private static WebUsageList GetBgeWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetBgeScrapedMeterReads( accountNumber, from, to );
			return GetBgeWebUsageList( ds );
		}

		private static WebUsageList GetBgeWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildBgeWebUsage( dr ) );
			}
			return list;
		}

		private static BgeUsage BuildBgeWebUsage( DataRow dr )
		{
			BgeUsage usage = new BgeUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] );
			usage.Days = Convert.ToInt32( dr["Days"] );
			usage.DeliveryDemandKw = Convert.ToDecimal( dr["DeliveryDemandKw"] == DBNull.Value ? 0m : dr["DeliveryDemandKw"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] );
			usage.GenTransDemandKw = Convert.ToDecimal( dr["GenTransDemandKw"] == DBNull.Value ? 0m : dr["GenTransDemandKw"] );
			usage.IntermediatePeakKwh = Convert.ToDecimal( dr["IntermediatePeakKwh"] == DBNull.Value ? 0m : dr["IntermediatePeakKwh"] );
			usage.MeterNumber = Convert.ToString( dr["MeterNumber"] == DBNull.Value ? String.Empty : dr["MeterNumber"] );
			usage.MeterType = Convert.ToString( dr["MeterType"] == DBNull.Value ? String.Empty : dr["MeterType"] );
			usage.OffPeakKwh = Convert.ToDecimal( dr["OffPeakKwh"] == DBNull.Value ? 0m : dr["OffPeakKwh"] );
			usage.OnPeakKwh = Convert.ToDecimal( dr["OnPeakKwh"] == DBNull.Value ? 0m : dr["OnPeakKwh"] );
			usage.ReadingSource = Convert.ToString( dr["ReadingSource"] == DBNull.Value ? String.Empty : dr["ReadingSource"] );
			usage.SeasonalCrossover = Convert.ToString( dr["SeasonalCrossOver"] == DBNull.Value ? String.Empty : dr["SeasonalCrossOver"] );
			usage.TotalKwh = Convert.ToInt32( dr["TotalKwh"] );
			usage.UsageFactorIntermediate = Convert.ToDecimal( dr["UsageFactorIntermediate"] == DBNull.Value ? 0m : dr["UsageFactorIntermediate"] );
			usage.UsageFactorNonTOU = Convert.ToDecimal( dr["UsageFactorNonTOU"] == DBNull.Value ? 0m : dr["UsageFactorNonTOU"] );
			usage.UsageFactorOffPeak = Convert.ToDecimal( dr["UsageFactorOffPeak"] == DBNull.Value ? 0m : dr["UsageFactorOffPeak"] );
			usage.UsageFactorOnPeak = Convert.ToDecimal( dr["UsageFactorOnPeak"] == DBNull.Value ? 0m : dr["UsageFactorOnPeak"] );

			return usage;
		}

		private static UsageList GetBgeList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetBgeItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetBgeItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "BGE";
			DateTime from = (DateTime) row["beginDate"];
			DateTime to = (DateTime) row["endDate"];
			int kwh = Convert.ToInt32( row["TotalKwh"] );
			string meter = row["MeterNumber"] == DBNull.Value ? "" : (string) row["MeterNumber"];
			usageType = (string) row["ReadingSource"] == "E" ? UsageType.UtilityEstimate : usageType;

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.MeterNumber = meter;
			item.IsConsolidated = false;
			item.OnPeakKwh = Convert.ToDecimal( row["OnPeakKwh"] );
			item.OffPeakKwh = Convert.ToDecimal( row["OffPeakKwh"] );
			item.IntermediateKwh = Convert.ToDecimal( row["IntermediatePeakKwh"] );
			item.BillingDemandKw = Convert.ToDecimal( row["deliveryDemandKw"] );
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		#region CENHUD

		private static WebAccountList GetCenhudAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetCenhudScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildCenhud( dr ) );
			}
			return account;
		}

		private static Cenhud BuildCenhud( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			Cenhud account = new Cenhud();
			account.AccountNumber = accountNumber;
			account.BillFrequency = Convert.ToString( dr["BillFrequency"] == DBNull.Value ? String.Empty : dr["BillFrequency"] );
			account.County = Convert.ToString( dr["County"] == DBNull.Value ? String.Empty : dr["County"] );
			account.Cycle = Convert.ToString( dr["BillCycle"] == DBNull.Value ? String.Empty : dr["BillCycle"] );
			account.LoadShapeId = Convert.ToString( dr["LoadProfile"] == DBNull.Value ? String.Empty : dr["LoadProfile"] );
			account.LoadProfile = Convert.ToString( dr["LoadProfile"] == DBNull.Value ? String.Empty : dr["LoadProfile"] );
			account.LoadZone = Convert.ToString( dr["LoadZone"] == DBNull.Value ? String.Empty : dr["LoadZone"] );
			account.RateCode = Convert.ToString( dr["RateCode"] == DBNull.Value ? String.Empty : dr["RateCode"] );
			account.SalesTaxRate = Convert.ToDecimal( dr["SalesTaxRate"] == DBNull.Value ? 0m : dr["SalesTaxRate"] );
			account.UsageFactor = Convert.ToDecimal( dr["UsageFactor"] == DBNull.Value ? 0m : dr["UsageFactor"] );
			account.UtilityCode = "CENHUD";
			account.WebUsageList = GetCenhudWebUsageList( accountNumber, from, to );
			account.ZoneCode = Convert.ToString( dr["ZoneCode"] == DBNull.Value ? String.Empty : dr["ZoneCode"] );

			account.Municipality = Convert.ToString( dr["Municipality"] == DBNull.Value ? String.Empty : dr["Municipality"] );
			account.NextScheduledMeterRead = Convert.ToDateTime( dr["NextScheduledMeterReadDate"] == DBNull.Value ? null : dr["NextScheduledMeterReadDate"] );
			return account;
		}

		/// <summary>
		/// Returns the entire Cenhud dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetCenhudListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetCenhudScrapedMeterReadsByOffer( offerID, from, to );
			return GetCenhudList( ds1, usageType );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire Cenhud dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetCenhudList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetCenhudScrapedMeterReads( accountNumber, from, to );
			return GetCenhudList( ds1, usageType );
		}

		private static WebUsageList GetCenhudWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetCenhudScrapedMeterReads( accountNumber, from, to );
			return GetCenhudWebUsageList( ds );
		}

		private static WebUsageList GetCenhudWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildCenhudWebUsage( dr ) );
			}
			return list;
		}

		private static CenhudUsage BuildCenhudWebUsage( DataRow dr )
		{
			CenhudUsage usage = new CenhudUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] );
			usage.Days = Convert.ToInt32( dr["Days"] );
			usage.DemandKw = Convert.ToDecimal( dr["DemandKw"] == DBNull.Value ? 0m : dr["DemandKw"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] );
			usage.MeterNumber = Convert.ToString( dr["MeterNumber"] == DBNull.Value ? String.Empty : dr["MeterNumber"] );
			usage.NumberOfMonths = Convert.ToDecimal( dr["NumberOfMonths"] == DBNull.Value ? 0m : dr["NumberOfMonths"] );
			usage.OffPeakKwh = Convert.ToDecimal( dr["OffPeakKwh"] == DBNull.Value ? 0m : dr["OffPeakKwh"] );
			usage.OnPeakKwh = Convert.ToDecimal( dr["OnPeakKwh"] == DBNull.Value ? 0m : dr["OnPeakKwh"] );
			usage.ReadCode = Convert.ToString( dr["ReadCode"] == DBNull.Value ? String.Empty : dr["ReadCode"] );
			usage.SalesTax = Convert.ToDecimal( dr["SalesTax"] == DBNull.Value ? 0m : dr["SalesTax"] );
			usage.TotalBilledAmount = Convert.ToDecimal( dr["TotalBilledAmount"] == DBNull.Value ? 0m : dr["TotalBilledAmount"] );
			usage.TotalKwh = Convert.ToInt32( dr["TotalKwh"] );

			return usage;
		}

		private static UsageList GetCenhudList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetCenhudItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetCenhudItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "CENHUD";
			DateTime from = (DateTime) row["beginDate"];
			DateTime to = (DateTime) row["endDate"];
			int kwh = Convert.ToInt32( row["TotalKwh"] );
			string meter = row["MeterNumber"] == DBNull.Value ? "" : (string) row["MeterNumber"];

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.MeterNumber = meter;
			item.IsConsolidated = false;
			item.OnPeakKwh = Convert.ToDecimal( row["demandKw"] );
			item.Days = Convert.ToInt16( row["days"] );
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		#region CMP

		private static WebAccountList GetCmpAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetCmpScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildCmp( dr ) );
			}
			return account;
		}

		private static Cmp BuildCmp( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			Cmp account = new Cmp();
			account.AccountNumber = accountNumber;
            account.BillGroup = Convert.ToString(dr["BillGroup"] == DBNull.Value ? String.Empty : dr["BillGroup"]);
			account.Cycle = Convert.ToString( dr["ReadCycle"] == DBNull.Value ? String.Empty : dr["ReadCycle"] );
			account.UtilityCode = "CMP";
			account.WebUsageList = GetCmpWebUsageList( accountNumber, from, to );

			return account;
		}

		/// <summary>
		/// Returns the entire CMP dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber">account number belonging to CMP</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetCmpListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetCmpScrapedMeterReadsByOffer( offerID, from, to );
			return GetCmpList( ds1, usageType );
		}

		// February 2011
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire CMP dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber">account number belonging to CMP</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetCmpList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetCmpScrapedMeterReads( accountNumber, from, to );
			return GetCmpList( ds1, usageType );
		}

		private static WebUsageList GetCmpWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetCmpScrapedMeterReads( accountNumber, from, to );
			return GetCmpWebUsageList( ds );
		}

		private static WebUsageList GetCmpWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildCmpWebUsage( dr ) );
			}
			return list;
		}

		private static CmpUsage BuildCmpWebUsage( DataRow dr )
		{
			CmpUsage usage = new CmpUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] );
			usage.Days = Convert.ToInt32( dr["Days"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] );
			usage.HighestDemandKw = Convert.ToDecimal( dr["HighestDemandKw"] == DBNull.Value ? 0m : dr["HighestDemandKw"] );
			usage.MeterNumber = Convert.ToString( dr["MeterNumber"] == DBNull.Value ? String.Empty : dr["MeterNumber"] );
			usage.RateCode = Convert.ToString( dr["RateCode"] == DBNull.Value ? String.Empty : dr["RateCode"] );
			usage.TotalActiveUnmeteredServices = Convert.ToInt32( dr["TotalActiveUmetered"] );
			usage.TotalKwh = Convert.ToInt32( dr["TotalKwh"] );
			usage.TotalUnmeteredServices = Convert.ToInt32( dr["TotalUnmetered"] );

			return usage;
		}

		private static UsageList GetCmpList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetCmpItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetCmpItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "CMP";
			DateTime from = (DateTime) row["beginDate"];
			DateTime to = (DateTime) row["endDate"];
			int kwh = Convert.ToInt32( row["totalKwh"] );
			string meter = row["MeterNumber"] == DBNull.Value ? "" : (string) row["MeterNumber"];

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.IsConsolidated = false;
			item.MeterNumber = meter;
			item.BillingDemandKw = Convert.ToDecimal( row["HighestDemandKw"] );
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		#region COMED

		private static WebAccountList GetComedAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetComedScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildComed( dr ) );
			}
			return account;
		}

		private static Comed BuildComed( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			List<Comed.ComedPLCMeter> capPlcMeters = new List<Comed.ComedPLCMeter>();
			List<Comed.ComedPLCMeter> netPlcMeters = new List<Comed.ComedPLCMeter>();

            //Ticket SR 1-17533745

            Comed.ComedPLCMeter meter1 = new Comed.ComedPLCMeter();
			meter1.EndDate = Convert.ToDateTime( dr["CapacityPLC1EndDate"] == DBNull.Value ? DateTime.MinValue : dr["CapacityPLC1EndDate"] );
			meter1.StartDate = Convert.ToDateTime( dr["CapacityPLC1StartDate"] == DBNull.Value ? DateTime.MinValue : dr["CapacityPLC1StartDate"] );
			meter1.Value = Convert.ToDecimal( dr["CapacityPLC1Value"] == DBNull.Value ? 0m : dr["CapacityPLC1Value"] );
			capPlcMeters.Add( meter1 );

            Comed.ComedPLCMeter meter2 = new Comed.ComedPLCMeter();
			meter2.EndDate = Convert.ToDateTime( dr["CapacityPLC2EndDate"] == DBNull.Value ? DateTime.MinValue : dr["CapacityPLC2EndDate"] );
			meter2.StartDate = Convert.ToDateTime( dr["CapacityPLC2StartDate"] == DBNull.Value ? DateTime.MinValue : dr["CapacityPLC2StartDate"] );
			meter2.Value = Convert.ToDecimal( dr["CapacityPLC2Value"] == DBNull.Value ? 0m : dr["CapacityPLC2Value"] );
			capPlcMeters.Add( meter2 );

            Comed.ComedPLCMeter meter3 = new Comed.ComedPLCMeter();
			meter3.EndDate = Convert.ToDateTime( dr["NetworkServicePLCEndDate"] == DBNull.Value ? DateTime.MinValue : dr["NetworkServicePLCEndDate"] );
			meter3.StartDate = Convert.ToDateTime( dr["NetworkServicePLCStartDate"] == DBNull.Value ? DateTime.MinValue : dr["NetworkServicePLCStartDate"] );
			meter3.Value = Convert.ToDecimal( dr["NetworkServicePLCValue"] == DBNull.Value ? 0m : dr["NetworkServicePLCValue"] );
			netPlcMeters.Add( meter3 );

            Comed.SupplyGroup currentSupplyGroup = new Comed.SupplyGroup();
			currentSupplyGroup.EffectiveStartDate = Convert.ToDateTime( dr["CurrentSupplyGroupEffectiveDate"] == DBNull.Value ? DateTime.MinValue : dr["CurrentSupplyGroupEffectiveDate"] );
			currentSupplyGroup.Name = Convert.ToString( dr["CurrentSupplyGroupName"] == DBNull.Value ? String.Empty : dr["CurrentSupplyGroupName"] );

            Comed.SupplyGroup pendingSupplyGroup = new Comed.SupplyGroup();
			pendingSupplyGroup.EffectiveStartDate = Convert.ToDateTime( dr["PendingSupplyGroupEffectiveDate"] == DBNull.Value ? DateTime.MinValue : dr["CurrentSupplyGroupEffectiveDate"] );
			pendingSupplyGroup.Name = Convert.ToString( dr["PendingSupplyGroupName"] == DBNull.Value ? String.Empty : dr["PendingSupplyGroupName"] );

            Comed account = new Comed();
			if( capPlcMeters.Count > 2 && capPlcMeters[1].StartDate <= DateTime.Now )
                account.Icap = capPlcMeters[1].Value;
            else
                account.Icap = capPlcMeters[0].Value;

            #region before ticketSR 1-17533745
            
            //Comed.ComedPLCMeter meter = new Comed.ComedPLCMeter();
            //meter.EndDate = Convert.ToDateTime( dr["CapacityPLC1EndDate"] == DBNull.Value ? DateTime.MinValue : dr["CapacityPLC1EndDate"] );
            //meter.StartDate = Convert.ToDateTime( dr["CapacityPLC1StartDate"] == DBNull.Value ? DateTime.MinValue : dr["CapacityPLC1StartDate"] );
            //meter.Value = Convert.ToDecimal( dr["CapacityPLC1Value"] == DBNull.Value ? 0m : dr["CapacityPLC1Value"] );
            //capPlcMeters.Add( meter );

            //meter = new Comed.ComedPLCMeter();
            //meter.EndDate = Convert.ToDateTime( dr["CapacityPLC2EndDate"] == DBNull.Value ? DateTime.MinValue : dr["CapacityPLC2EndDate"] );
            //meter.StartDate = Convert.ToDateTime( dr["CapacityPLC2StartDate"] == DBNull.Value ? DateTime.MinValue : dr["CapacityPLC2StartDate"] );
            //meter.Value = Convert.ToDecimal( dr["CapacityPLC2Value"] == DBNull.Value ? 0m : dr["CapacityPLC2Value"] );
            //capPlcMeters.Add( meter );

            //meter = new Comed.ComedPLCMeter();
            //meter.EndDate = Convert.ToDateTime( dr["NetworkServicePLCEndDate"] == DBNull.Value ? DateTime.MinValue : dr["NetworkServicePLCEndDate"] );
            //meter.StartDate = Convert.ToDateTime( dr["NetworkServicePLCStartDate"] == DBNull.Value ? DateTime.MinValue : dr["NetworkServicePLCStartDate"] );
            //meter.Value = Convert.ToDecimal( dr["NetworkServicePLCValue"] == DBNull.Value ? 0m : dr["NetworkServicePLCValue"] );
            //netPlcMeters.Add( meter );

            //Comed.SupplyGroup currentSupplyGroup = new Comed.SupplyGroup();
            //currentSupplyGroup.EffectiveStartDate = Convert.ToDateTime( dr["CurrentSupplyGroupEffectiveDate"] == DBNull.Value ? DateTime.MinValue : dr["CurrentSupplyGroupEffectiveDate"] );
            //currentSupplyGroup.Name = Convert.ToString( dr["CurrentSupplyGroupName"] == DBNull.Value ? String.Empty : dr["CurrentSupplyGroupName"] );

            //Comed.SupplyGroup pendingSupplyGroup = new Comed.SupplyGroup();
            //pendingSupplyGroup.EffectiveStartDate = Convert.ToDateTime( dr["PendingSupplyGroupEffectiveDate"] == DBNull.Value ? DateTime.MinValue : dr["CurrentSupplyGroupEffectiveDate"] );
            //pendingSupplyGroup.Name = Convert.ToString( dr["PendingSupplyGroupName"] == DBNull.Value ? String.Empty : dr["PendingSupplyGroupName"] );

            //Comed account = new Comed();
            //account.Icap = capPlcMeters[0].Value;

            #endregion
            
            account.Tcap = netPlcMeters[0].Value;
			account.AccountNumber = accountNumber;
            account.BillGroup = Convert.ToString(dr["MeterBillGroupNumber"] == DBNull.Value ? String.Empty : dr["MeterBillGroupNumber"]);
			account.CapacityPLC = capPlcMeters;
			account.CondoException = Convert.ToString( dr["CondoException"] == DBNull.Value ? String.Empty : dr["CondoException"] );
			account.CurrentSupplyGroup = currentSupplyGroup;
			account.MinimumStayDate = Convert.ToDateTime( dr["MinimumStayDate"] == DBNull.Value ? DateTime.MinValue : dr["MinimumStayDate"] );
			account.NetworkServicePLC = netPlcMeters;
			account.PendingSupplyGroup = pendingSupplyGroup;
			account.UtilityCode = "COMED";
			account.WebUsageList = GetComedWebUsageList( accountNumber, from, to );

			account.RateClass = Convert.ToString( dr["Rate"] == DBNull.Value ? String.Empty : dr["Rate"] );
			return account;
		}


		/// <summary>
		/// Returns the entire COMED dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="offerid">offer</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetComedListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetComedScrapedMeterReadsByOffer( offerID, from, to );
			return GetComedList( ds1, usageType );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire COMED dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber">account number belonging to COMED</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetComedList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetComedScrapedMeterReads( accountNumber, from, to );
			return GetComedList( ds1, usageType );
		}

		private static WebUsageList GetComedWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetComedScrapedMeterReads( accountNumber, from, to );
			return GetComedWebUsageList( ds );
		}

		private static WebUsageList GetComedWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildComedWebUsage( dr ) );
			}
			return list;
		}

		private static ComedUsage BuildComedWebUsage( DataRow dr )
		{
			ComedUsage usage = new ComedUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] );
			usage.BillingDemandKw = Convert.ToDecimal( dr["BillingDemandKw"] == DBNull.Value ? 0m : dr["BillingDemandKw"] );
			usage.Days = Convert.ToInt32( dr["Days"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] );
			usage.MonthlyPeakDemandKw = Convert.ToDecimal( dr["MonthlyPeakDemandKw"] == DBNull.Value ? 0m : dr["MonthlyPeakDemandKw"] );
			usage.OffPeakKwh = Convert.ToDecimal( dr["OffPeakKwh"] == DBNull.Value ? 0m : dr["OffPeakKwh"] );
			usage.OnPeakKwh = Convert.ToDecimal( dr["OnPeakKwh"] == DBNull.Value ? 0m : dr["OnPeakKwh"] );
			usage.Rate = Convert.ToString( dr["Rate"] == DBNull.Value ? String.Empty : dr["Rate"] );
			usage.TotalKwh = Convert.ToInt32( dr["TotalKwh"] );

			return usage;
		}

		private static UsageList GetComedList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetComedItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetComedItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "COMED";
			DateTime from = (DateTime) row["BeginDate"];
			DateTime to = (DateTime) row["EndDate"];
			int kwh = Convert.ToInt32( row["TotalKwh"] );

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.IsConsolidated = false;
			item.MeterNumber = "";
			item.BillingDemandKw = Convert.ToDecimal( row["BillingDemandKw"] );
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		#region CONED

		private static WebAccountList GetConedAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetConedScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildConed( dr ) );
			}
			return account;
		}

		private static Coned BuildConed( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			Coned account = new Coned();
			account.AccountNumber = accountNumber;
            account.BillGroup = Convert.ToString(dr["TripNumber"] == DBNull.Value ? String.Empty : dr["TripNumber"]);
			account.CustomerName = Convert.ToString( dr["CustomerName"] == DBNull.Value ? String.Empty : dr["CustomerName"] );
			account.Icap = Convert.ToDecimal( dr["ICAP"] == DBNull.Value ? 0m : dr["ICAP"] );
			account.MeterType = Convert.ToString( dr["MeterType"] == DBNull.Value ? String.Empty : dr["MeterType"] );
			account.NextScheduledReadDate = Convert.ToDateTime( dr["NextScheduledReadDate"] == DBNull.Value ? DateTime.MinValue : dr["NextScheduledReadDate"] );
			account.PreviousAccountNumber = Convert.ToString( dr["PreviousAccountNumber"] == DBNull.Value ? String.Empty : dr["PreviousAccountNumber"] );
			account.LoadProfile = Convert.ToString( dr["Profile"] == DBNull.Value ? String.Empty : dr["Profile"] );
            account.RateClass = Convert.ToString( dr["ServiceClass"] == DBNull.Value ? String.Empty : dr["ServiceClass"] );
			account.Residential = Convert.ToInt16( dr["Residential"] == DBNull.Value ? 0 : dr["Residential"] );
			account.SeasonalTurnOff = Convert.ToString( dr["SeasonalTurnOff"] == DBNull.Value ? String.Empty : dr["SeasonalTurnOff"] );
			account.StratumVariable = Convert.ToString( dr["StratumVariable"] == DBNull.Value ? String.Empty : dr["StratumVariable"] );
			account.Taxable = Convert.ToString( dr["Taxable"] == DBNull.Value ? String.Empty : dr["Taxable"] );
			account.TensionCode = Convert.ToString( dr["TensionCode"] == DBNull.Value ? String.Empty : dr["TensionCode"] );
			account.UtilityCode = "CONED";
			account.WebUsageList = GetConedWebUsageList( accountNumber, from, to );
			account.ZoneCode = Convert.ToString( dr["LbmpZone"] == DBNull.Value ? String.Empty : dr["LbmpZone"] );
			account.PfjIcap = Convert.ToString( dr["PfjIcap"] == DBNull.Value ? String.Empty : dr["PfjIcap"] );
			account.MinMonthlyDemand = Convert.ToInt16( dr["MinMonthlyDemand"] == DBNull.Value ? 0 : dr["MinMonthlyDemand"] );
			account.TodCode = Convert.ToString( dr["TodCode"] == DBNull.Value ? String.Empty : dr["TodCode"] );
			account.Muni = Convert.ToString( dr["Muni"] == DBNull.Value ? String.Empty : dr["Muni"] );

			return account;
		}


		/// <summary>
		/// Returns the entire CONED dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber">account number belonging to CONED</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetConedListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetConedScrapedMeterReadsByOffer( offerID, from, to );
			return GetConedList( ds1, usageType );
		}


		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire CONED dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber">account number belonging to CONED</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetConedList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetConedScrapedMeterReads( accountNumber, from, to );
			return GetConedList( ds1, usageType );
		}

		private static WebUsageList GetConedWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetConedScrapedMeterReads( accountNumber, from, to );
			return GetConedWebUsageList( ds );
		}

		private static WebUsageList GetConedWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildConedWebUsage( dr ) );
			}
			return list;
		}

		private static ConedUsage BuildConedWebUsage( DataRow dr )
		{
			DateTime beginDate = Convert.ToDateTime( dr["FromDate"] );
			DateTime endDate = Convert.ToDateTime( dr["ToDate"] );
			TimeSpan span = endDate.Subtract( beginDate );
			int days = span.Days;

			ConedUsage usage = new ConedUsage();

			usage.BeginDate = Convert.ToDateTime( dr["FromDate"] );
			usage.BillAmount = Convert.ToDecimal( dr["BillAmount"] == DBNull.Value ? 0m : dr["BillAmount"] );
			usage.Days = days;
			usage.Demand = Convert.ToDecimal( dr["Demand"] == DBNull.Value ? 0m : dr["Demand"] );
			usage.EndDate = Convert.ToDateTime( dr["ToDate"] );
			usage.TotalKwh = Convert.ToInt32( dr["Usage"] );

			return usage;
		}

		private static UsageList GetConedList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetConedItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetConedItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "CONED";
			DateTime from = (DateTime) row["fromDate"];
			DateTime to = (DateTime) row["toDate"];
			int kwh = Convert.ToInt32( row["usage"] );

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.IsConsolidated = false;
			item.MeterNumber = "";
			decimal demand = decimal.Zero;
			decimal.TryParse( row["demand"].ToString(), out demand );
			item.BillingDemandKw = demand;
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		#region NIMO

		private static WebAccountList GetNimoAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetNimoScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildNimo( dr ) );
			}
			return account;
		}

		private static Nimo BuildNimo( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			GeographicalAddress address = new GeographicalAddress();
			address.CityName = Convert.ToString( dr["MailingCity"] == DBNull.Value ? String.Empty : dr["MailingCity"] );
			address.PostalCode = Convert.ToString( dr["MailingZipCode"] == DBNull.Value ? String.Empty : dr["MailingZipCode"] );
			address.State = Convert.ToString( dr["MailingStateCode"] == DBNull.Value ? String.Empty : dr["MailingStateCode"] );
			address.Street = Convert.ToString( dr["MailingStreet"] == DBNull.Value ? String.Empty : dr["MailingStreet"] );

			Nimo account = new Nimo();
			account.AccountNumber = accountNumber;
			account.Address = address;
			account.CustomerName = Convert.ToString( dr["CustomerName"] == DBNull.Value ? String.Empty : dr["CustomerName"] );
			account.RateClass = Convert.ToString( dr["RateClass"] == DBNull.Value ? String.Empty : dr["RateClass"] );
			account.RateCode = Convert.ToString( dr["RateCode"] == DBNull.Value ? String.Empty : dr["RateCode"] );
			account.TaxDistrict = Convert.ToString( dr["TaxDistrict"] == DBNull.Value ? String.Empty : dr["TaxDistrict"] );
			account.UtilityCode = "NIMO";
			account.Voltage = Convert.ToString( dr["Voltage"] == DBNull.Value ? String.Empty : dr["Voltage"] );
			account.WebUsageList = GetNimoWebUsageList( accountNumber, from, to );
			account.ZoneCode = Convert.ToString( dr["ZoneCode"] == DBNull.Value ? String.Empty : dr["ZoneCode"] );

			return account;
		}



		/// <summary>
		/// Returns the entire NIMO dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="offerID"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetNimoListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetNimoScrapedMeterReadsByOffer( offerID, from, to );
			return GetNimoList( ds1, usageType );
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire NIMO dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetNimoList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetNimoScrapedMeterReads( accountNumber, from, to );
			return GetNimoList( ds1, usageType );
		}

		private static WebUsageList GetNimoWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetNimoScrapedMeterReads( accountNumber, from, to );
			return GetNimoWebUsageList( ds );
		}

		private static WebUsageList GetNimoWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildNimoWebUsage( dr ) );
			}
			return list;
		}

		private static NimoUsage BuildNimoWebUsage( DataRow dr )
		{
			NimoUsage usage = new NimoUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] );
			usage.BillCode = Convert.ToString( dr["BillCode"] == DBNull.Value ? String.Empty : dr["BillCode"] );
			usage.BillDetailAmt = Convert.ToDecimal( dr["BillDetailAmt"] == DBNull.Value ? 0m : dr["BillDetailAmt"] );
			usage.BilledKwhTotal = Convert.ToDecimal( dr["BilledKwhTotal"] == DBNull.Value ? 0m : dr["BilledKwhTotal"] );
			usage.BilledOnPeakKw = Convert.ToDecimal( dr["BilledOnPeakKw"] == DBNull.Value ? 0m : dr["BilledOnPeakKw"] );
			usage.BilledPeakKw = Convert.ToDecimal( dr["BilledPeakKw"] == DBNull.Value ? 0m : dr["BilledPeakKw"] );
			usage.BilledRkva = Convert.ToDecimal( dr["BilledRkva"] == DBNull.Value ? 0m : dr["BilledRkva"] );
			usage.Days = Convert.ToInt32( dr["Days"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] );
			usage.MeteredOnPeakKw = Convert.ToDecimal( dr["MeteredOnPeakKw"] == DBNull.Value ? 0m : dr["MeteredOnPeakKw"] );
			usage.MeteredPeakKw = Convert.ToDecimal( dr["MeteredPeakKw"] == DBNull.Value ? 0m : dr["MeteredPeakKw"] );
			usage.OffPeakKwh = Convert.ToDecimal( dr["OffPeakKwh"] == DBNull.Value ? 0m : dr["OffPeakKwh"] );
			usage.OffSeasonKwh = Convert.ToDecimal( dr["OffSeasonKwh"] == DBNull.Value ? 0m : dr["OffSeasonKwh"] );
			usage.OnPeakKwh = Convert.ToDecimal( dr["OnPeakKwh"] == DBNull.Value ? 0m : dr["OnPeakKwh"] );
			usage.ShoulderKwh = Convert.ToDecimal( dr["ShoulderKwh"] == DBNull.Value ? 0m : dr["ShoulderKwh"] );

			return usage;
		}

		private static UsageList GetNimoList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetNimoItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetNimoItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "NIMO";
			DateTime from = (DateTime) row["beginDate"];
			DateTime to = (DateTime) row["endDate"];
			int kwh = Convert.ToInt32( row["billedKwhTotal"] );

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.MeterNumber = "";
			item.IsConsolidated = false;
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		#region NYSEG

		private static WebAccountList GetNysegAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetNysegScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildNyseg( dr ) );
			}
			return account;
		}

		private static Nyseg BuildNyseg( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			GeographicalAddress mailingAddress = new GeographicalAddress();
			mailingAddress.CityName = Convert.ToString( dr["MailingCity"] == DBNull.Value ? String.Empty : dr["MailingCity"] );
			mailingAddress.PostalCode = Convert.ToString( dr["MailingZipCode"] == DBNull.Value ? String.Empty : dr["MailingZipCode"] );
			mailingAddress.State = Convert.ToString( dr["MailingStateCode"] == DBNull.Value ? String.Empty : dr["MailingStateCode"] );
			mailingAddress.Street = Convert.ToString( dr["MailingStreet"] == DBNull.Value ? String.Empty : dr["MailingStreet"] );

			GeographicalAddress serviceAddress = new GeographicalAddress();
			serviceAddress.CityName = Convert.ToString( dr["ServiceCity"] == DBNull.Value ? String.Empty : dr["ServiceCity"] );
			serviceAddress.PostalCode = Convert.ToString( dr["ServiceZipCode"] == DBNull.Value ? String.Empty : dr["ServiceZipCode"] );
			serviceAddress.State = Convert.ToString( dr["ServiceStateCode"] == DBNull.Value ? String.Empty : dr["ServiceStateCode"] );
			serviceAddress.Street = Convert.ToString( dr["ServiceStreet"] == DBNull.Value ? String.Empty : dr["ServiceStreet"] );

			Nyseg account = new Nyseg();
			account.AccountNumber = accountNumber;
			account.Address = mailingAddress;
			account.CurrentRateCategory = Convert.ToString( dr["CurrentRateCategory"] == DBNull.Value ? String.Empty : dr["CurrentRateCategory"] );
			account.CustomerName = Convert.ToString( dr["CustomerName"] == DBNull.Value ? String.Empty : dr["CustomerName"] );
			account.FutureRateCategory = Convert.ToString( dr["FutureRateCategory"] == DBNull.Value ? String.Empty : dr["FutureRateCategory"] );
			account.Grid = Convert.ToString( dr["Grid"] == DBNull.Value ? String.Empty : dr["Grid"] );
			account.Icap = dr["Icap"] == DBNull.Value ? -1m : Convert.ToDecimal( dr["Icap"] );
			account.LoadProfile = Convert.ToString( dr["Profile"] == DBNull.Value ? String.Empty : dr["Profile"] );
			account.RevenueClass = Convert.ToString( dr["RevenueClass"] == DBNull.Value ? String.Empty : dr["RevenueClass"] );
			account.ServiceAddress = serviceAddress;
			account.TaxDistrict = Convert.ToString( dr["TaxDistrict"] == DBNull.Value ? String.Empty : dr["TaxDistrict"] );
			account.TaxJurisdiction = Convert.ToString( dr["TaxJurisdiction"] == DBNull.Value ? String.Empty : dr["TaxJurisdiction"] );
			account.UtilityCode = "NYSEG";
			account.WebUsageList = GetNysegWebUsageList( accountNumber, from, to );

			return account;
		}


		/// <summary>
		/// Returns the entire NYSEG dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetNysegListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetNysegScrapedMeterReadsByOffer( offerID, from, to );
			return GetNysegList( ds1, usageType );
		}


		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire NYSEG dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <param name="usageType"></param>
		/// <returns></returns>
		private static UsageList GetNysegList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetNysegScrapedMeterReads( accountNumber, from, to );
			return GetNysegList( ds1, usageType );
		}

		private static WebUsageList GetNysegWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetNysegScrapedMeterReads( accountNumber, from, to );
			return GetNysegWebUsageList( ds );
		}

		private static WebUsageList GetNysegWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildNysegWebUsage( dr ) );
			}
			return list;
		}

		private static NysegUsage BuildNysegWebUsage( DataRow dr )
		{
			NysegUsage usage = new NysegUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] );
			usage.Days = Convert.ToInt32( dr["Days"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] );
			usage.Kw = Convert.ToDecimal( dr["Kw"] == DBNull.Value ? 0m : dr["Kw"] );
			usage.Kwh = Convert.ToDecimal( dr["Kwh"] == DBNull.Value ? 0m : dr["Kwh"] );
			usage.KwhMid = Convert.ToDecimal( dr["KwhMid"] == DBNull.Value ? 0m : dr["KwhMid"] );
			usage.KwhOff = Convert.ToDecimal( dr["KwhOff"] == DBNull.Value ? 0m : dr["KwhOff"] );
			usage.KwhOn = Convert.ToDecimal( dr["KwhOn"] == DBNull.Value ? 0m : dr["KwhOn"] );
			usage.KwOff = Convert.ToDecimal( dr["KwOff"] == DBNull.Value ? 0m : dr["KwOff"] );
			usage.KwOn = Convert.ToDecimal( dr["KwOn"] == DBNull.Value ? 0m : dr["KwOn"] );
			usage.ReadType = Convert.ToString( dr["ReadType"] == DBNull.Value ? String.Empty : dr["ReadType"] );
			usage.Rkvah = Convert.ToDecimal( dr["Rkvah"] == DBNull.Value ? 0m : dr["Rkvah"] );
			usage.Total = Convert.ToDecimal( dr["Total"] == DBNull.Value ? 0m : dr["Total"] );
			usage.TotalTax = Convert.ToDecimal( dr["TotalTax"] == DBNull.Value ? 0m : dr["TotalTax"] );

			if( dr["Kwh"] != DBNull.Value )
				usage.TotalKwh = Convert.ToInt32( dr["Kwh"] ) == 0 ? Convert.ToInt32( dr["KwhOn"] ) + Convert.ToInt32( dr["KwhOff"] ) : Convert.ToInt32( dr["Kwh"] );
			else
				usage.TotalKwh = Convert.ToInt32( dr["KwhOn"] ) + Convert.ToInt32( dr["KwhOff"] );

			return usage;
		}

		private static UsageList GetNysegList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetNysegItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetNysegItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "NYSEG";
			DateTime from = (DateTime) row["beginDate"];
			DateTime to = (DateTime) row["endDate"];
			int kwh = Convert.ToInt32( row["Kwh"] );
			usageType = (string) row["ReadType"] == "Estimated" ? UsageType.UtilityEstimate : usageType;

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.IsConsolidated = false;
			item.OnPeakKwh = Convert.ToDecimal( row["KwOn"] );
			item.OffPeakKwh = Convert.ToDecimal( row["KwOff"] );

			//nyseg sometimes posts on and off peak kwh but not the total..
			kwh = Convert.ToInt32( row["KwhOn"] ) + Convert.ToInt32( row["KwhOff"] );

			if( item.TotalKwh == 0 && kwh > 0 )
				item.TotalKwh = kwh;

			item.IsActive = 1;
			item.MeterNumber = (string) row["MeterNumber"];
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		#region PECO

		private static WebAccountList GetPecoAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetPecoScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildPeco( dr ) );
			}
			return account;
		}

		private static Peco BuildPeco( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			GeographicalAddress serviceAddress = new GeographicalAddress();
			serviceAddress.PostalCode = Convert.ToString( dr["ServiceZipCode"] == DBNull.Value ? String.Empty : dr["ServiceZipCode"] );

			Peco account = new Peco();
			account.AccountNumber = accountNumber;
			account.Address = serviceAddress;
            account.BillGroup = Convert.ToString(dr["BillGroup"] == DBNull.Value ? String.Empty : dr["BillGroup"]);
			account.Icap = Convert.ToDecimal( dr["Icap"] == DBNull.Value ? 0m : dr["Icap"] );
			account.IcapEndDate = Convert.ToDateTime( dr["IcapEndDate"] == DBNull.Value ? DateTime.MinValue : dr["IcapEndDate"] );
			account.IcapStartDate = Convert.ToDateTime( dr["IcapBeginDate"] == DBNull.Value ? DateTime.MinValue : dr["IcapBeginDate"] );
			account.RateClass = Convert.ToString( dr["RateClass"] == DBNull.Value ? String.Empty : dr["RateClass"] );
			account.RateCode = Convert.ToString( dr["RateCode"] == DBNull.Value ? String.Empty : dr["RateCode"] );
			account.StratumVariable = Convert.ToString( dr["Strata"] == DBNull.Value ? String.Empty : dr["Strata"] );
			account.Tcap = Convert.ToDecimal( dr["Tcap"] == DBNull.Value ? 0m : dr["Tcap"] );
			account.TcapBeginDate = Convert.ToDateTime( dr["TcapBeginDate"] == DBNull.Value ? DateTime.MinValue : dr["TcapBeginDate"] );
			account.TcapEndDate = Convert.ToDateTime( dr["TcapEndDate"] == DBNull.Value ? DateTime.MinValue : dr["TcapEndDate"] );
			account.UtilityCode = "PECO";
			account.WebUsageList = GetPecoWebUsageList( accountNumber, from, to );

			return account;
		}


		/// <summary>
		/// Returns the entire PECO dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber">account number belonging to PECO</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetPecoListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetPecoScrapedMeterReadsByOffer( offerID, from, to );
			return GetPecoList( ds1, usageType );
		}


		// February 2011
		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire PECO dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber">account number belonging to PECO</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetPecoList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetPecoScrapedMeterReads( accountNumber, from, to );
			return GetPecoList( ds1, usageType );
		}

		private static WebUsageList GetPecoWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetPecoScrapedMeterReads( accountNumber, from, to );
			return GetPecoWebUsageList( ds );
		}

		private static WebUsageList GetPecoWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildPecoWebUsage( dr ) );
			}
			return list;
		}

		private static PecoUsage BuildPecoWebUsage( DataRow dr )
		{
			PecoUsage usage = new PecoUsage();

			usage.BeginDate = Convert.ToDateTime( dr["FromDate"] );
			usage.Demand = Convert.ToDecimal( dr["Demand"] == DBNull.Value ? 0m : dr["Demand"] );
			usage.EndDate = Convert.ToDateTime( dr["ToDate"] );
			usage.TotalKwh = Convert.ToInt32( dr["Usage"] == DBNull.Value ? 0m : dr["Usage"] );

			return usage;
		}

		private static UsageList GetPecoList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetPecoItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetPecoItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "PECO";
			DateTime from = (DateTime) row["fromDate"];
			DateTime to = (DateTime) row["toDate"];
			int kwh = Convert.ToInt32( row["usage"] );

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.IsConsolidated = false;
			item.MeterNumber = "";
			item.BillingDemandKw = Convert.ToDecimal( row["demand"] );
			item.IsActive = 1;
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		#region RGE

		private static WebAccountList GetRgeAccount( string accountNumber )
		{
			WebAccountList account = new WebAccountList();
			DataSet ds = TransactionsSql.GetRgeScrapedAccount( accountNumber );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					account.Add( BuildRge( dr ) );
			}
			return account;
		}

		private static Rge BuildRge( DataRow dr )
		{
			string accountNumber = dr["AccountNumber"].ToString();
			DateTime to = DateTime.Today.Date;
			DateTime from = to.AddYears( -2 );

			GeographicalAddress mailingAddress = new GeographicalAddress();
			mailingAddress.CityName = Convert.ToString( dr["MailingCity"] == DBNull.Value ? String.Empty : dr["MailingCity"] );
			mailingAddress.PostalCode = Convert.ToString( dr["MailingZipCode"] == DBNull.Value ? String.Empty : dr["MailingZipCode"] );
			mailingAddress.State = Convert.ToString( dr["MailingStateCode"] == DBNull.Value ? String.Empty : dr["MailingStateCode"] );
			mailingAddress.Street = Convert.ToString( dr["MailingStreet"] == DBNull.Value ? String.Empty : dr["MailingStreet"] );

			GeographicalAddress serviceAddress = new GeographicalAddress();
			serviceAddress.CityName = Convert.ToString( dr["ServiceCity"] == DBNull.Value ? String.Empty : dr["ServiceCity"] );
			serviceAddress.PostalCode = Convert.ToString( dr["ServiceZipCode"] == DBNull.Value ? String.Empty : dr["ServiceZipCode"] );
			serviceAddress.State = Convert.ToString( dr["ServiceStateCode"] == DBNull.Value ? String.Empty : dr["ServiceStateCode"] );
			serviceAddress.Street = Convert.ToString( dr["ServiceStreet"] == DBNull.Value ? String.Empty : dr["ServiceStreet"] );

			Rge account = new Rge();
			account.AccountNumber = accountNumber;
			account.Address = mailingAddress;
			account.CurrentRateCategory = Convert.ToString( dr["CurrentRateCategory"] == DBNull.Value ? String.Empty : dr["CurrentRateCategory"] );
			account.CustomerName = Convert.ToString( dr["CustomerName"] == DBNull.Value ? String.Empty : dr["CustomerName"] );
			account.FutureRateCategory = Convert.ToString( dr["FutureRateCategory"] == DBNull.Value ? String.Empty : dr["FutureRateCategory"] );
			account.Grid = Convert.ToString( dr["Grid"] == DBNull.Value ? String.Empty : dr["Grid"] );
			account.Icap = dr["Icap"] == DBNull.Value ? -1m : Convert.ToDecimal( dr["Icap"] );
			account.LoadProfile = Convert.ToString( dr["Profile"] == DBNull.Value ? String.Empty : dr["Profile"] );
			account.MeterNumber = Convert.ToString( dr["MeterNumber"] == DBNull.Value ? String.Empty : dr["MeterNumber"] );
			account.RevenueClass = Convert.ToString( dr["RevenueClass"] == DBNull.Value ? String.Empty : dr["RevenueClass"] );
			account.ServiceAddress = serviceAddress;
			account.TaxDistrict = Convert.ToString( dr["TaxDistrict"] == DBNull.Value ? String.Empty : dr["TaxDistrict"] );
			account.TaxJurisdiction = Convert.ToString( dr["TaxJurisdiction"] == DBNull.Value ? String.Empty : dr["TaxJurisdiction"] );
			account.UtilityCode = "RGE";
			account.WebUsageList = GetRgeWebUsageList( accountNumber, from, to );

			return account;
		}


		/// <summary>
		/// Returns the entire RGE dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="offerID">account number belonging to RGE</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetRgeListByOffer( string offerID, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetRgeScrapedMeterReadsByOffer( offerID, from, to );
			return GetRgeList( ds1, usageType );
		}


		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Returns the entire RGE dataset from Scraped (lp_transactions) meter read table
		/// </summary>
		/// <param name="accountNumber">account number belonging to RGE</param>
		/// <param name="from">begin period</param>
		/// <param name="to">end period</param>
		/// <returns></returns>
		private static UsageList GetRgeList( string accountNumber, DateTime from, DateTime to, UsageType usageType )
		{
			DataSet ds1 = TransactionsSql.GetRgeScrapedMeterReads( accountNumber, from, to );
			return GetRgeList( ds1, usageType );
		}

		private static WebUsageList GetRgeWebUsageList( string accountNumber, DateTime from, DateTime to )
		{
			DataSet ds = TransactionsSql.GetRgeScrapedMeterReads( accountNumber, from, to );
			return GetRgeWebUsageList( ds );
		}

		private static WebUsageList GetRgeWebUsageList( DataSet ds )
		{
			WebUsageList list = new WebUsageList();

			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( BuildRgeWebUsage( dr ) );
			}
			return list;
		}

		private static RgeUsage BuildRgeWebUsage( DataRow dr )
		{
			RgeUsage usage = new RgeUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] );
			usage.Days = Convert.ToInt32( dr["Days"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] );
			usage.Kw = Convert.ToDecimal( dr["Kw"] == DBNull.Value ? 0m : dr["Kw"] );
			usage.Kwh = Convert.ToDecimal( dr["Kwh"] == DBNull.Value ? 0m : dr["Kwh"] );
			usage.KwhMid = Convert.ToDecimal( dr["KwhMid"] == DBNull.Value ? 0m : dr["KwhMid"] );
			usage.KwhOff = Convert.ToDecimal( dr["KwhOff"] == DBNull.Value ? 0m : dr["KwhOff"] );
			usage.KwhOn = Convert.ToDecimal( dr["KwhOn"] == DBNull.Value ? 0m : dr["KwhOn"] );
			usage.KwOff = Convert.ToDecimal( dr["KwOff"] == DBNull.Value ? 0m : dr["KwOff"] );
			usage.KwOn = Convert.ToDecimal( dr["KwOn"] == DBNull.Value ? 0m : dr["KwOn"] );
			usage.ReadType = Convert.ToString( dr["ReadType"] == DBNull.Value ? String.Empty : dr["ReadType"] );
			usage.Rkvah = Convert.ToDecimal( dr["Rkvah"] == DBNull.Value ? 0m : dr["Rkvah"] );
			usage.Total = Convert.ToDecimal( dr["Total"] == DBNull.Value ? 0m : dr["Total"] );
			usage.TotalTax = Convert.ToDecimal( dr["TotalTax"] == DBNull.Value ? 0m : dr["TotalTax"] );

			if( dr["Kwh"] != DBNull.Value )
				usage.TotalKwh = Convert.ToInt32( dr["Kwh"] ) == 0 ? Convert.ToInt32( dr["KwhOn"] ) + Convert.ToInt32( dr["KwhOff"] ) : Convert.ToInt32( dr["Kwh"] );
			else
				usage.TotalKwh = Convert.ToInt32( dr["KwhOn"] ) + Convert.ToInt32( dr["KwhOff"] );

			return usage;
		}

		private static UsageList GetRgeList( DataSet ds, UsageType usageType )
		{
			UsageList list = null;

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				foreach( DataRow dr1 in ds.Tables[0].Rows )
				{
					if( list == null ) { list = new UsageList(); }

					list.Add( GetRgeItem( dr1, usageType ) );
				}
			}

			return list;
		}

		private static Usage GetRgeItem( DataRow row, UsageType usageType )
		{
			Usage item = null;

			string account = (string) row["accountNumber"];
			string utility = "RGE";
			DateTime from = (DateTime) row["beginDate"];
			DateTime to = (DateTime) row["endDate"];
			int kwh = Convert.ToInt32( row["kwh"] );
			usageType = (string) row["ReadType"] == "Estimated" ? UsageType.UtilityEstimate : usageType;

			item = new Usage( account, utility, UsageSource.Scraper, usageType, from, to, kwh );

			item.IsConsolidated = false;
			item.MeterNumber = "";
			item.IntermediateKwh = Convert.ToDecimal( row["kwhMid"] );
			item.MonthlyOffPeakDemandKw = Convert.ToDecimal( row["kwOff"] );
			item.MonthlyPeakDemandKw = Convert.ToDecimal( row["kwOn"] );
			item.OffPeakKwh = Convert.ToDecimal( row["kwhOff"] );
			item.OnPeakKwh = Convert.ToDecimal( row["kwhOn"] );
			item.Days = Convert.ToInt16( row["Days"] );
			item.IsActive = 1;
			item.MeterNumber = (string) row["MeterNumber"];
			item.ReasonCode = ReasonCode.InsertedFromFramework;
			item.DateCreated = (row["Created"] == DBNull.Value) ? DateTime.MinValue : (DateTime) row["Created"];
			return item;
		}

		#endregion

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Gets raw account data and associated raw usage
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a web account list containing raw account data and associated raw usage.</returns>
		public static WebAccountList GetAccount( string accountNumber, string utilityCode )
		{
			WebAccountList account = new WebAccountList();

			switch( utilityCode )
			{
				case "AMEREN":
					account = GetAmerenAccount( accountNumber );
					break;
				case "BGE":
					account = GetBgeAccount( accountNumber );
					break;
				case "CENHUD":
					account = GetCenhudAccount( accountNumber );
					break;
				case "CMP":
					account = GetCmpAccount( accountNumber );
					break;
				case "COMED":
					account = GetComedAccount( accountNumber );
					break;
				case "CONED":
					account = GetConedAccount( accountNumber );
					break;
				case "NIMO":
					account = GetNimoAccount( accountNumber );
					break;
				case "NYSEG":
					account = GetNysegAccount( accountNumber );
					break;
				case "PECO":
					account = GetPecoAccount( accountNumber );
					break;
				case "RGE":
					account = GetRgeAccount( accountNumber );
					break;
			}

			return account;
		}

		/// <summary>
		/// Method responsible for determining which raw source to get usage from (depending on the Utility)
		/// </summary>
		/// <param name="accountNumber">account number</param>
		/// <param name="utilityCode">utility code</param>
		/// <param name="fromDate">begin date range</param>
		/// <param name="toDate">end date range</param>
		/// <param name="isAccountEnrolled"></param>
		/// <returns></returns>
		public static UsageList GetListByOffer( string offerID, string utilityCode, DateTime fromDate, DateTime toDate, bool isAccountEnrolled )
		{
			UsageList list = null;
			UsageType type = UsageType.Historical;

			if( isAccountEnrolled )
				type = UsageType.Billed;

			switch( utilityCode )
			{
				case "AMEREN":
					list = GetAmerenListByOffer( offerID, fromDate, toDate, type );
					break;
				case "BGE":
					list = GetBgeListByOffer( offerID, fromDate, toDate, type );
					break;
				case "CENHUD":
					list = GetCenhudListByOffer( offerID, fromDate, toDate, type );
					break;
				case "CMP":
					list = GetCmpListByOffer( offerID, fromDate, toDate, type );
					break;
				case "COMED":
					list = GetComedListByOffer( offerID, fromDate, toDate, type );
					break;
				case "CONED":
					list = GetConedListByOffer( offerID, fromDate, toDate, type );
					break;
				case "NIMO":
					list = GetNimoListByOffer( offerID, fromDate, toDate, type );
					break;
				case "NYSEG":
					list = GetNysegListByOffer( offerID, fromDate, toDate, type );
					break;
				case "PECO":
					list = GetPecoListByOffer( offerID, fromDate, toDate, type );
					break;
				case "RGE":
					list = GetRgeListByOffer( offerID, fromDate, toDate, type );
					break;
			}

			return list;
		}


		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Method responsible for determining which raw source to get usage from (depending on the Utility)
		/// </summary>
		/// <param name="accountNumber">account number</param>
		/// <param name="utilityCode">utility code</param>
		/// <param name="fromDate">begin date range</param>
		/// <param name="toDate">end date range</param>
		/// <returns></returns>
        public static UsageList GetList(string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate, bool isAccountEnrolled)
        {
            return GetList(accountNumber, utilityCode, fromDate, toDate, isAccountEnrolled, false);
        }

        public static UsageList GetList(string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate, bool isAccountEnrolled, bool forUsageConsolidation)
        {
            UsageList list = null;
            UsageType type = UsageType.Historical;

            if (isAccountEnrolled)
                type = UsageType.Billed;

            switch (utilityCode)
            {
                case "AMEREN":
                    list = GetAmerenList(accountNumber, fromDate, toDate, type, forUsageConsolidation);
                    break;
                case "BGE":
                    list = GetBgeList(accountNumber, fromDate, toDate, type);
                    break;
                case "CENHUD":
                    list = GetCenhudList(accountNumber, fromDate, toDate, type);
                    break;
                case "CMP":
                    list = GetCmpList(accountNumber, fromDate, toDate, type);
                    break;
                case "COMED":
                    list = GetComedList(accountNumber, fromDate, toDate, type);
                    break;
                case "CONED":
                    list = GetConedList(accountNumber, fromDate, toDate, type);
                    break;
                case "NIMO":
                    list = GetNimoList(accountNumber, fromDate, toDate, type);
                    break;
                case "NYSEG":
                    list = GetNysegList(accountNumber, fromDate, toDate, type);
                    break;
                case "PECO":
                    list = GetPecoList(accountNumber, fromDate, toDate, type);
                    break;
                case "RGE":
                    list = GetRgeList(accountNumber, fromDate, toDate, type);
                    break;
            }

            return list;
        }

		#region Run Scrapers

		/// <summary>
		/// Runs scraper for given account and utility code combination. This is an overload for phoenix removing html exceptions.
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityID">Utility code</param>
		/// <returns>True if successful</returns>
		public static bool RunScraper( string accountNumber, string utilityID, out string exceptions )
		{
			exceptions = string.Empty;
			const string INCENTED_LOAD = "[Has Incented Load]. ";

			if( string.IsNullOrWhiteSpace( accountNumber ) )
				throw new ArgumentNullException( accountNumber, "Account number must not be blank." );
			if( string.IsNullOrWhiteSpace( utilityID ) )
				throw new ArgumentNullException( utilityID, "Utility code must not be blank." );

			var userName = "unknown";
			var identity = WindowsIdentity.GetCurrent();
			if( identity != null )
				userName = identity.Name.Split( '\\' ).GetValue( 1 ).ToString();


			accountNumber = accountNumber.ToUpper().Trim();
			utilityID = utilityID.ToUpper().Trim();

			object answer = null;
			switch( utilityID )
			{
				case "AMEREN":
					WebAccountList webAccounts = RunAmerenScraper( accountNumber, userName, out exceptions );
					answer = webAccounts;
					break;

				case "CMP":
					Cmp cmp = RunCmpScraper( accountNumber, userName, out exceptions );
					answer = cmp;
					break;

				case "CENHUD":
					Cenhud cenhud = RunCenhudScraper( accountNumber, userName, out exceptions );
					answer = cenhud;
					break;

				case "CONED":
					Coned coned = RunConedScraper( accountNumber, userName, out exceptions );
					answer = coned;
					break;

				case "NYSEG":
					Nyseg nyseg = RunNysegScraper( accountNumber, userName, out exceptions );
					answer = nyseg;
					break;

				case "RGE":
					Rge rge = RunRgeScraper( accountNumber, userName, out exceptions );
					answer = rge;
					break;

				case "COMED":
					Comed comed = RunComedScraper( accountNumber, userName, out exceptions, string.Empty );
					answer = comed;
					break;

				case "BGE":
					Bge bge = RunBgeScraper( accountNumber, userName, out exceptions );
					answer = bge;
					break;

				case "PECO":
					Peco peco = RunPecoScraper( accountNumber, userName, out exceptions, string.Empty );
					answer = peco;
					break;

				case "NIMO":
					Nimo nimo = RunNimoScraper( accountNumber, userName, out exceptions );
					answer = nimo;
					break;

                default:
                    {
                        throw new Exception("Utility does not have a scraper.");
                        
                    }
                    
			}
			/*this is being called from the service bus now
			 * //synchronize the account info like zone and profile we got from EDI with the Account table in the libertyPower DB
			try
			{
				var dataSyncClient = new DataSynchronizationClient( "BasicHttpBinding_IDataSynchronization" );
				dataSyncClient.SynchronizeFromScrapersAsync( accountNumber, utilityID );
				//dataSyncClient.SynchronizeFromScrapers( accountNumber, utilityID );
			}
			catch( Exception ex )
			{
			}*/

			var account = answer as WebAccount;
			var accountList = answer as WebAccountList;

			if( account != null )
			{
				if( account.WebUsageList != null )
				{
					var usageCount = account.WebUsageList.Count;
					// SR 1-3502533 - check for incented load
					if( exceptions.ToLower().Contains( "incented load" ) )
					{
						exceptions = String.Format( "Account Number: {0}{1} - Usage count: {2}", accountNumber, INCENTED_LOAD, usageCount );
					}
				}

			}
			else if( accountList != null )
			{
				foreach( var webAccount in accountList )
				{
					if( webAccount.WebUsageList == null )
						continue;
					var usageCount = webAccount.WebUsageList.Count;

					// SR 1-3502533 - check for incented load
					if( exceptions.ToLower().Contains( "incented load" ) )
					{
						exceptions += String.Format( " Account Number: {0}{1} - Usage count: {2}", webAccount.AccountNumber, INCENTED_LOAD, usageCount );
					}
				}
			}
			else if( answer == null && !string.IsNullOrWhiteSpace( exceptions ) )
			{
				exceptions = String.Format( "Account Number: {0} - Error: {1}", accountNumber, exceptions );
			}

			return string.IsNullOrWhiteSpace( exceptions );
		}

		public static object RunScraper( string accountNumber, string utilityID, string hint, out string exceptions )
		{
			string userName = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
			exceptions = "Usage scraping successful";
			userName = (string) userName.Split( '\\' ).GetValue( 1 );
			accountNumber = accountNumber.ToUpper().Trim();
			hint = hint.ToUpper().Trim();
			object answer = null;
			//todo generalize this
			utilityID = utilityID.ToUpper().Trim();
			switch( utilityID )
			{
				case "AMEREN":
					WebAccountList webAccounts = RunAmerenScraper( accountNumber, userName, out exceptions );
					answer = webAccounts;
					break;

				case "CMP":
					Cmp cmp = RunCmpScraper( accountNumber, userName, out exceptions );
					answer = cmp;
					break;

				case "CENHUD":
					Cenhud cenhud = RunCenhudScraper( accountNumber, userName, out exceptions );
					answer = cenhud;
					break;

				case "CONED":
					Coned coned = RunConedScraper( accountNumber, userName, out exceptions );
					answer = coned;
					break;

				case "NYSEG":
					Nyseg nyseg = RunNysegScraper( accountNumber, userName, out exceptions );
					answer = nyseg;
					break;

				case "RGE":
					Rge rge = RunRgeScraper( accountNumber, userName, out exceptions );
					answer = rge;
					break;

				case "COMED":
					Comed comed = RunComedScraper( accountNumber, userName, out exceptions, hint );
					answer = comed;
					break;

				case "BGE":
					Bge bge = RunBgeScraper( accountNumber, userName, out exceptions );
					answer = bge;
					break;

				case "PECO":
					Peco peco = RunPecoScraper( accountNumber, userName, out exceptions, hint );
					answer = peco;
					break;

				case "NIMO":
					Nimo nimo = RunNimoScraper( accountNumber, userName, out exceptions );
					answer = nimo;
					break;

				default:
					break;
			}
			
			/*this is being called from the service bus now
			//synchronize the account info like zone and profile we got from EDI with the Account table in the libertyPower DB
			try
			{
				var dataSyncClient = new DataSynchronizationClient( "BasicHttpBinding_IDataSynchronization" );
				dataSyncClient.SynchronizeFromScrapersAsync( accountNumber, utilityID );
			//dataSyncClient.SynchronizeFromScrapers( accountNumber, utilityID );
			}
			catch( Exception ex )
			{
			}
			*/

			if( answer != null && answer is WebAccount )
            {
				if( ((WebAccount) answer).WebUsageList != null )
                {
                    int items = ((WebAccount) answer).WebUsageList.Count;
					// SR 1-3502533 - check for incented load
					string incentedLoad = String.Empty;
					if( exceptions.ToLower().Contains( "incented load" ) )
					{
						incentedLoad = "[Has Incented Load]. ";
					}
					exceptions = String.Format( "</br>Account Number: {0}{1} - {2} usage items successfully scraped</br>", accountNumber, incentedLoad, items );
                }
            }
			else if( answer != null && answer is WebAccountList )
            {
                var bufExceptions = "";
				foreach( var item in (WebAccountList) answer )
                {
					if( ((WebAccount) item).WebUsageList != null )
                    {
						int items = ((WebAccount) item).WebUsageList.Count;
                        // SR 1-3502533 - check for incented load
                        string incentedLoad = String.Empty;
						if( exceptions.ToLower().Contains( "incented load" ) )
                        {
                            incentedLoad = "[Has Incented Load]. ";
                        }
						bufExceptions += String.Format( "</br>Account Number: {0}{1} - {2} usage items successfully scraped</br>", accountNumber, incentedLoad, items );
                    }
                }
                exceptions = bufExceptions;
            }
			else if( answer == null && exceptions.Trim().Length > 0 )
            {
				exceptions = String.Format( "<span><font color=red></br>Account Number: {0} - {1}</br></font></span>", accountNumber, exceptions );
            }
			return answer;
		}

		public static WebAccountList RunAmerenScraper( string accountNumber, string userName, out string exceptions )
		{
			int accountId = 0;

			WebAccountList amerenAcct = AmerenFactory.GetUsage( accountNumber, out exceptions );
			if( amerenAcct == null )
                return amerenAcct;

			foreach( Ameren meter in amerenAcct )
			{
				// insert account into database..
				DataSet ds = MisoSql.AmerenAccountInsert( meter.AccountNumber, meter.CustomerName, meter.BillGroup, meter.OperatingCompany,
					meter.ServicePoint, meter.DeliveryVoltage, meter.SupplyVoltage, meter.MeterVoltage, meter.LoadShapeId,
					meter.CurrentSupplyGoupAndType, meter.FutureSupplyGroupAndType, meter.ServiceClass, meter.EligibleSwitchDate,
					meter.TransformationCharge, meter.EffectivePLC, userName, meter.Meter );

				if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
					accountId = Convert.ToInt32( ds.Tables[0].Rows[0]["Id"] );

				if( accountId != 0 )
				{
					foreach( AmerenUsage usage in meter.WebUsageList )
						MisoSql.AmerenUsageInsert( accountId, usage.BeginDate, usage.EndDate, usage.Days,
							usage.TotalKwh, usage.OnPeakKwh, usage.OffPeakKwh, usage.OnPeakDemandKw, usage.OffPeakDemandKw,
							usage.PeakReactivePowerKvar, userName );
				}
			}

			return amerenAcct;
		}

		// ------------------------------------------------------------------------------------
		public static Bge RunBgeScraper( string accountNumber, string userName, out string exceptions )
		{
			Bge bgeAccount = BgeFactory.GetUsage( accountNumber, out exceptions );
			if( bgeAccount == null )
                return bgeAccount;

			// insert account into database..
			PjmIsoSql.BgeAccountInsert( bgeAccount.AccountNumber, bgeAccount.CustomerName, bgeAccount.CustomerSegment, bgeAccount.TariffCode,
				bgeAccount.CapPLC, bgeAccount.TransPLC, bgeAccount.CapPlcPrev, bgeAccount.TransPlcPre,
				bgeAccount.CapPlcEffectiveDate, bgeAccount.TransPlcEffectiveDate, bgeAccount.CapPlcPrevEffectiveDate, bgeAccount.TransPlcPrevEffectiveDate,
				bgeAccount.POLRType, bgeAccount.BillGroup, bgeAccount.SpecialBilling, bgeAccount.MultipleMeters, bgeAccount.Address.Street, bgeAccount.Address.CityName,
				(bgeAccount.Address as UsGeographicalAddress).StateCode, (bgeAccount.Address as UsGeographicalAddress).ZipCode, bgeAccount.BillingAddress.Street,
				bgeAccount.BillingAddress.CityName, (bgeAccount.BillingAddress as UsGeographicalAddress).StateCode, (bgeAccount.BillingAddress as UsGeographicalAddress).ZipCode,
				userName );

			foreach( BgeUsage usage in bgeAccount.WebUsageList )
				PjmIsoSql.BgeUsageInsert( bgeAccount.AccountNumber, usage.BeginDate, usage.EndDate, usage.Days, usage.TotalKwh,
					usage.OnPeakKwh, usage.OffPeakKwh, usage.ReadingSource, usage.IntermediatePeakKwh, usage.SeasonalCrossover,
					usage.DeliveryDemandKw, usage.GenTransDemandKw, usage.UsageFactorNonTOU, usage.UsageFactorOnPeak,
					usage.UsageFactorOffPeak, usage.UsageFactorIntermediate, usage.MeterNumber, usage.MeterType, userName );

			return bgeAccount;
		}

		// ------------------------------------------------------------------------------------
		public static Cenhud RunCenhudScraper( string accountNumber, string userName, out string exceptions )
		{
			Cenhud cenhudAcct = CenhudFactory.GetUsage( accountNumber, out exceptions );
			if( cenhudAcct == null )
                return cenhudAcct;

			// insert account into database..
			NyIsoSql.CenhudAccountInsert( cenhudAcct.AccountNumber, cenhudAcct.Address.CityName, cenhudAcct.County, cenhudAcct.Cycle,
				cenhudAcct.BillFrequency, cenhudAcct.SalesTaxRate, cenhudAcct.RateCode, cenhudAcct.LoadZone, cenhudAcct.LoadShapeId,
				cenhudAcct.ZoneCode, cenhudAcct.UsageFactor, userName, cenhudAcct.NextScheduledMeterRead.Value );

			foreach( CenhudUsage usage in cenhudAcct.WebUsageList )
				NyIsoSql.CenhudUsageInsert( cenhudAcct.AccountNumber, usage.ReadCode, usage.NumberOfMonths, usage.BeginDate,
					usage.EndDate, usage.Days, usage.MeterNumber, usage.TotalKwh, usage.DemandKw,
					usage.TotalBilledAmount, usage.SalesTax, userName, usage.OnPeakKwh, usage.OffPeakKwh );

			return cenhudAcct;
		}

		// ------------------------------------------------------------------------------------
		public static Cmp RunCmpScraper( string accountNumber, string userName, out string exceptions )
		{
			Cmp cmpAccount = CmpFactory.GetUsage( accountNumber, out exceptions );

			if( cmpAccount == null )
                return cmpAccount;

			// insert account into database..
			NeIsoSql.CmpAccountInsert( cmpAccount.AccountNumber, cmpAccount.BillGroup, cmpAccount.Cycle, userName );

			foreach( CmpUsage usage in cmpAccount.WebUsageList )
				NeIsoSql.CmpUsageInsert( cmpAccount.AccountNumber, usage.HighestDemandKw, usage.RateCode, usage.BeginDate,
					usage.EndDate, usage.Days, usage.MeterNumber, usage.TotalKwh, usage.TotalUnmeteredServices, usage.TotalActiveUnmeteredServices, userName );

			return cmpAccount;
		}

		// ------------------------------------------------------------------------------------
		public static Comed RunComedScraper( string accountNumber, string userName, out string exceptions, string meterNumber )
		{
			Comed comedAcct = ComedFactory.GetUsage( accountNumber, meterNumber, out exceptions );
			if( comedAcct == null )
                return comedAcct;

			PjmIsoSql.ComedAccountInsert(
				comedAcct.AccountNumber, comedAcct.BillGroup,
				comedAcct.CapacityPLC.Count > 0 ? comedAcct.CapacityPLC[0].Value : -1,
				comedAcct.CapacityPLC.Count > 0 ? comedAcct.CapacityPLC[0].StartDate : DateTime.MinValue,
				comedAcct.CapacityPLC.Count > 0 ? comedAcct.CapacityPLC[0].EndDate : DateTime.MinValue,
				comedAcct.CapacityPLC.Count > 1 ? comedAcct.CapacityPLC[1].Value : -1,
				comedAcct.CapacityPLC.Count > 1 ? comedAcct.CapacityPLC[1].StartDate : DateTime.MinValue,
				comedAcct.CapacityPLC.Count > 1 ? comedAcct.CapacityPLC[1].EndDate : DateTime.MinValue,
				comedAcct.NetworkServicePLC.Count > 0 ? comedAcct.NetworkServicePLC[0].Value : -1,
				comedAcct.NetworkServicePLC.Count > 0 ? comedAcct.NetworkServicePLC[0].StartDate : DateTime.MinValue,
				comedAcct.NetworkServicePLC.Count > 0 ? comedAcct.NetworkServicePLC[0].EndDate : DateTime.MinValue,
				comedAcct.CondoException,
				comedAcct.CurrentSupplyGroup != null ? comedAcct.CurrentSupplyGroup.Name : null,
				comedAcct.CurrentSupplyGroup != null ? comedAcct.CurrentSupplyGroup.EffectiveStartDate : DateTime.MinValue,
				comedAcct.PendingSupplyGroup != null ? comedAcct.PendingSupplyGroup.Name : null,
				comedAcct.PendingSupplyGroup != null ? comedAcct.PendingSupplyGroup.EffectiveStartDate : DateTime.MinValue,
				comedAcct.MinimumStayDate,
				userName, meterNumber
				);

			foreach( ComedUsage usage in comedAcct.WebUsageList )
				PjmIsoSql.ComedUsageInsert( comedAcct.AccountNumber, usage.Rate, usage.BeginDate, usage.EndDate, usage.Days,
					usage.TotalKwh, usage.OnPeakKwh, usage.OffPeakKwh, usage.BillingDemandKw, usage.MonthlyPeakDemandKw, userName );

			return comedAcct;
		}

		// ------------------------------------------------------------------------------------
		public static Coned RunConedScraper( string accountNumber, string userName, out string exceptions )
		{
			DataSet ds = null;

			Coned conedAcct = ConedFactory.GetUsage( accountNumber, out exceptions );
			if( conedAcct == null )
                return conedAcct;

			// insert account into database..
			ds = NyIsoSql.ConedAccountInsert( conedAcct.CustomerName, conedAcct.AccountNumber, conedAcct.Address.Street, conedAcct.Address.CityName,
				conedAcct.Address.PostalCode, conedAcct.SeasonalTurnOff, conedAcct.NextScheduledReadDate, conedAcct.TensionCode, conedAcct.StratumVariable,
				conedAcct.Icap, conedAcct.Residential, conedAcct.ZoneCode, conedAcct.BillGroup, conedAcct.RateClass, conedAcct.PreviousAccountNumber, conedAcct.Taxable,
				conedAcct.Profile, conedAcct.MeterType, userName, conedAcct.PfjIcap, conedAcct.MinMonthlyDemand, conedAcct.TodCode, conedAcct.Muni );

			foreach( ConedUsage item in conedAcct.WebUsageList )
				NyIsoSql.ConedUsageInsert( conedAcct.AccountNumber, item.TotalKwh, item.BeginDate, item.EndDate, item.Demand, item.BillAmount, userName );

			return conedAcct;
		}

		// ------------------------------------------------------------------------------------
		public static Nimo RunNimoScraper( string accountNumber, string userName, out string exceptions )
		{
			Nimo nimoAccount = null;

			nimoAccount = NimoFactory.GetUsage( accountNumber, out exceptions );
			if( nimoAccount == null )
                return nimoAccount;

			// insert account into database..
			NyIsoSql.NimoAccountInsert( nimoAccount.AccountNumber, nimoAccount.CustomerName, nimoAccount.RateClass, nimoAccount.RateCode,
				nimoAccount.TaxDistrict, nimoAccount.Voltage, nimoAccount.ZoneCode, userName, nimoAccount.Address.Street, nimoAccount.Address.CityName,
				(nimoAccount.Address as UsGeographicalAddress).StateCode, (nimoAccount.Address as UsGeographicalAddress).ZipCode );

			foreach( NimoUsage ùsage in nimoAccount.WebUsageList )
			{
				NyIsoSql.NimoUsageInsert( nimoAccount.AccountNumber, ùsage.BeginDate, ùsage.EndDate, ùsage.BillCode,
					ùsage.Days, ùsage.BilledKwhTotal, ùsage.MeteredPeakKw, ùsage.MeteredOnPeakKw, ùsage.BilledPeakKw,
					ùsage.BilledOnPeakKw, ùsage.BillDetailAmt, ùsage.BilledRkva, ùsage.OnPeakKwh, ùsage.OffPeakKwh,
					ùsage.ShoulderKwh, ùsage.OffSeasonKwh, userName );
			}

			return nimoAccount;
		}

		// ------------------------------------------------------------------------------------
		public static Nyseg RunNysegScraper( string accountNumber, string userName, out string exceptions )
		{
			DataSet ds = null;
			Nyseg nysegAcct = NysegFactory.GetUsage( accountNumber, out exceptions );
			if( nysegAcct == null )
                return nysegAcct;

            string meterNumber = "";

			if( nysegAcct.WebUsageList != null && nysegAcct.WebUsageList.Count > 0 )
                meterNumber = nysegAcct.WebUsageList[0].MeterNumber;

			// insert account into database..
			ds = NyIsoSql.NysegAccountInsert( nysegAcct.AccountNumber, nysegAcct.CustomerName, nysegAcct.CurrentRateCategory, nysegAcct.FutureRateCategory, nysegAcct.RevenueClass, nysegAcct.LoadShapeId,
				nysegAcct.Grid, nysegAcct.TaxJurisdiction, nysegAcct.TaxDistrict, nysegAcct.Address.Street, nysegAcct.Address.CityName,
				(nysegAcct.Address as UsGeographicalAddress).ZipCode, (nysegAcct.Address as UsGeographicalAddress).StateCode, nysegAcct.ServiceAddress.Street, nysegAcct.ServiceAddress.CityName,
                (nysegAcct.ServiceAddress as UsGeographicalAddress).ZipCode, (nysegAcct.ServiceAddress as UsGeographicalAddress).StateCode, userName, meterNumber, nysegAcct.Icap, nysegAcct.BillGroup);

			foreach( NysegUsage usage in nysegAcct.WebUsageList )
				NyIsoSql.NysegUsageInsert( nysegAcct.AccountNumber, usage.BeginDate, usage.EndDate, usage.ReadType, usage.KwOn, usage.KwOff, usage.KwhOn,
					 usage.KwhOff, usage.KwhMid, usage.Total, usage.TotalKwh, usage.Days, userName, usage.Kw, usage.Kwh, usage.Rkvah );

			return nysegAcct;
		}

		// ------------------------------------------------------------------------------------
		public static Peco RunPecoScraper( string accountNumber, string userName, out string exceptions, string postalCode )
		{
			Peco pecoAccount = PecoFactory.GetUsage( accountNumber, out exceptions, postalCode );
			if( pecoAccount == null )
                return pecoAccount;

			PjmIsoSql.PecoAccountInsert( pecoAccount.AccountNumber, (pecoAccount.Address as UsGeographicalAddress).ZipCode, pecoAccount.BillGroup, pecoAccount.Icap,
				pecoAccount.IcapStartDate, pecoAccount.IcapEndDate, pecoAccount.Tcap, pecoAccount.TcapBeginDate, pecoAccount.TcapEndDate, pecoAccount.RateCode,
				pecoAccount.StratumVariable, pecoAccount.RateClass, userName );

			foreach( PecoUsage usage in pecoAccount.WebUsageList )
				PjmIsoSql.PecoUsageInsert( pecoAccount.AccountNumber, usage.TotalKwh, usage.BeginDate, usage.EndDate, usage.Demand, userName );

			return pecoAccount;
		}

		// ------------------------------------------------------------------------------------
		public static Rge RunRgeScraper( string accountNumber, string userName, out string exceptions )
		{
			Rge parseRge = RgeFactory.GetUsage( accountNumber, out exceptions );
			if( parseRge == null )
                return parseRge;

		    string meterNumber = "";

			if( parseRge.WebUsageList != null && parseRge.WebUsageList.Count > 0 )
                meterNumber = parseRge.WebUsageList[0].MeterNumber;

			NyIsoSql.RgeAccountInsert( parseRge.AccountNumber, parseRge.CustomerName, parseRge.CurrentRateCategory, parseRge.FutureRateCategory, parseRge.RevenueClass, parseRge.LoadShapeId,
				parseRge.Grid, parseRge.TaxJurisdiction, parseRge.TaxDistrict, parseRge.Address.Street, parseRge.Address.CityName,
				(parseRge.Address as UsGeographicalAddress).ZipCode, (parseRge.Address as UsGeographicalAddress).StateCode, parseRge.ServiceAddress.Street, parseRge.ServiceAddress.CityName,
                (parseRge.ServiceAddress as UsGeographicalAddress).ZipCode, (parseRge.ServiceAddress as UsGeographicalAddress).StateCode, userName, meterNumber, parseRge.Icap, parseRge.BillGroup);

			foreach( RgeUsage usage in parseRge.WebUsageList )
				NyIsoSql.RgeUsageInsert( parseRge.AccountNumber, usage.BeginDate, usage.EndDate, usage.ReadType, usage.KwOn, usage.KwOff, usage.KwhOn,
					 usage.KwhOff, usage.KwhMid, usage.Total, usage.TotalTax, usage.Days, userName, usage.Kw, usage.Kwh, usage.Rkvah );

			return parseRge;
		}

		#endregion // Run Scrapers
	}
}
