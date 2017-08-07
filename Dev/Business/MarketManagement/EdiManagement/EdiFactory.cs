namespace LibertyPower.Business.MarketManagement.EdiManagement
{
	using System;
	using System.Data;
	using System.Collections.Generic;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.DataAccess.SqlAccess.IstaSql;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
	using LibertyPower.DataAccess.SqlAccess.CommonSql;
	using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

	/// <summary>
	/// ISTA related methods
	/// </summary>
	public static class EdiFactory
	{
		/// <summary>
		/// Gets latest EDI account data that has usage data associated with it.
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns an EDI account list and it's associated usage list.</returns>
		public static EdiAccountList GetEdiAccount( string accountNumber, string utilityCode )
		{
			EdiAccountList accounts = new EdiAccountList();

			DataSet ds = TransactionsSql.GetEdiAccount( accountNumber, utilityCode );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					accounts.Add( BuildEdiAccount( dr ) );
			}
			return accounts;
		}

		/// <summary>
		/// Gets all EDI account data for specified account that has usage data associated with it.
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns an EDI account list and it's associated usage list.</returns>
		public static EdiAccountList GetEdiAccountAll( string accountNumber, string utilityCode )
		{
			EdiAccountList accounts = new EdiAccountList();

			DataSet ds = TransactionsSql.GetEdiAccountAll( accountNumber, utilityCode );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					accounts.Add( BuildEdiAccount( dr ) );
			}
			return accounts;
		}

		private static EdiAccount BuildEdiAccount( DataRow dr )
		{
			int ediAccountId = Convert.ToInt32( dr["ID"] );

			EdiAccount account = new EdiAccount();

			account.AccountNumber = Convert.ToString( dr["AccountNumber"] == DBNull.Value ? String.Empty : dr["AccountNumber"] );
			account.AccountStatus = Convert.ToString( dr["AccountStatus"] == DBNull.Value ? String.Empty : dr["AccountStatus"] );
			account.AccountType = Convert.ToString( dr["AccountType"] == DBNull.Value ? String.Empty : dr["AccountType"] );
			account.AnuualUsage = Convert.ToInt32( dr["AnuualUsage"] == DBNull.Value ? 0 : dr["AnuualUsage"] );
			account.BillCalculation = Convert.ToString( dr["BillCalculation"] == DBNull.Value ? String.Empty : dr["BillCalculation"] );
			account.BillGroup = Convert.ToString( dr["BillGroup"] == DBNull.Value ? String.Empty : dr["BillGroup"] );
			account.BillingAccountNumber = Convert.ToString( dr["BillingAccountNumber"] == DBNull.Value ? String.Empty : dr["BillingAccountNumber"] );
			account.BillingType = Convert.ToString( dr["BillingType"] == DBNull.Value ? String.Empty : dr["BillingType"] );
			account.ContactName = Convert.ToString( dr["ContactName"] == DBNull.Value ? String.Empty : dr["ContactName"] );
			account.CustomerName = Convert.ToString( dr["CustomerName"] == DBNull.Value ? String.Empty : dr["CustomerName"] );
			account.DunsNumber = Convert.ToString( dr["DunsNumber"] == DBNull.Value ? String.Empty : dr["DunsNumber"] );
			account.EdiFileLogID = Convert.ToInt32( dr["EdiFileLogID"] == DBNull.Value ? 0 : dr["EdiFileLogID"] );
			account.EdiUsageList = GetEdiUsage( ediAccountId );
			account.EmailAddress = Convert.ToString( dr["EmailAddress"] == DBNull.Value ? String.Empty : dr["EmailAddress"] );
			account.EspAccountNumber = Convert.ToString( dr["EspAccountNumber"] == DBNull.Value ? String.Empty : dr["EspAccountNumber"] );
			account.Fax = Convert.ToString( dr["Fax"] == DBNull.Value ? String.Empty : dr["Fax"] );
			account.HomePhone = Convert.ToString( dr["HomePhone"] == DBNull.Value ? String.Empty : dr["HomePhone"] );
			account.Icap = Convert.ToDecimal( dr["Icap"] == DBNull.Value ? -1 : dr["Icap"] );
			account.ID = ediAccountId;
			account.LoadProfile = Convert.ToString( dr["LoadProfile"] == DBNull.Value ? String.Empty : dr["LoadProfile"] );
			account.LoadShapeId = Convert.ToString( dr["LoadShapeId"] == DBNull.Value ? String.Empty : dr["LoadShapeId"] );
			account.LossFactor = Convert.ToDecimal( dr["LossFactor"] == DBNull.Value ? 0 : dr["LossFactor"] );
			account.MeterMultiplier = Convert.ToInt32( dr["MeterMultiplier"] == DBNull.Value ? 0 : dr["MeterMultiplier"] );
			account.MeterNumber = Convert.ToString( dr["MeterNumber"] == DBNull.Value ? String.Empty : dr["MeterNumber"] );
			account.MeterType = Convert.ToString( dr["MeterType"] == DBNull.Value ? String.Empty : dr["MeterType"] );
			account.MonthsToComputeKwh = Convert.ToInt32( dr["MonthsToComputeKwh"] == DBNull.Value ? 0 : dr["MonthsToComputeKwh"] );
			account.NameKey = Convert.ToString( dr["NameKey"] == DBNull.Value ? String.Empty : dr["NameKey"] );
			account.PreviousAccountNumber = Convert.ToString( dr["PreviousAccountNumber"] == DBNull.Value ? String.Empty : dr["PreviousAccountNumber"] );
			account.ProductAltType = Convert.ToString( dr["ProductAltType"] == DBNull.Value ? String.Empty : dr["ProductAltType"] );
			account.ProductType = Convert.ToString( dr["ProductType"] == DBNull.Value ? String.Empty : dr["ProductType"] );
			account.RateClass = Convert.ToString( dr["RateClass"] == DBNull.Value ? String.Empty : dr["RateClass"] );
			account.RetailMarketCode = Convert.ToString( dr["RetailMarketCode"] == DBNull.Value ? String.Empty : dr["RetailMarketCode"] );
			account.ServiceDeliveryPoint = Convert.ToString( dr["ServiceDeliveryPoint"] == DBNull.Value ? String.Empty : dr["ServiceDeliveryPoint"] );
			account.ServicePeriodEnd = Convert.ToDateTime( dr["ServicePeriodEnd"] == DBNull.Value ? DateTime.MinValue : dr["ServicePeriodEnd"] );
			account.ServicePeriodStart = Convert.ToDateTime( dr["ServicePeriodStart"] == DBNull.Value ? DateTime.MinValue : dr["ServicePeriodStart"] );
			account.ServiceType = Convert.ToString( dr["ServiceType"] == DBNull.Value ? String.Empty : dr["ServiceType"] );
			account.Tcap = Convert.ToDecimal( dr["Tcap"] == DBNull.Value ? -1 : dr["Tcap"] );
			account.Telephone = Convert.ToString( dr["Telephone"] == DBNull.Value ? String.Empty : dr["Telephone"] );
			account.TransactionType = Convert.ToString( dr["TransactionType"] == DBNull.Value ? String.Empty : dr["TransactionType"] );
			account.UtilityCode = Convert.ToString( dr["UtilityCode"] == DBNull.Value ? String.Empty : dr["UtilityCode"] );
			account.Voltage = Convert.ToString( dr["Voltage"] == DBNull.Value ? String.Empty : dr["Voltage"] );
			account.Workphone = Convert.ToString( dr["Workphone"] == DBNull.Value ? String.Empty : dr["Workphone"] );
			account.ZoneCode = Convert.ToString( dr["ZoneCode"] == DBNull.Value ? String.Empty : dr["ZoneCode"] );

			return account;
		}

		/// <summary>
		/// Gets EDI usage data for specified EDI account ID
		/// </summary>
		/// <param name="ediAccountId">EDI account record identifier</param>
		/// <returns>Returns a list of EDI usage objects for specified EDI account ID.</returns>
		public static EdiUsageList GetEdiUsage( int ediAccountId )
		{
			EdiUsageList usages = new EdiUsageList();

			DataSet ds = TransactionsSql.GetEdiUsage( ediAccountId );
			if( DataSetHelper.HasRow( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					usages.Add( BuildEdiUsage( dr ) );
			}
			return usages;
		}

		private static EdiUsage BuildEdiUsage( DataRow dr )
		{
			EdiUsage usage = new EdiUsage();

			usage.BeginDate = Convert.ToDateTime( dr["BeginDate"] == DBNull.Value ? DateTime.MinValue : dr["BeginDate"] );
			usage.EdiAccountID = Convert.ToInt32( dr["EdiAccountID"] == DBNull.Value ? 0 : dr["EdiAccountID"] );
			usage.EndDate = Convert.ToDateTime( dr["EndDate"] == DBNull.Value ? DateTime.MinValue : dr["EndDate"] );
			usage.ID = Convert.ToInt32( dr["ID"] == DBNull.Value ? 0 : dr["ID"] );
			usage.MeasurementSignificanceCode = Convert.ToString( dr["MeasurementSignificanceCode"] == DBNull.Value ? String.Empty : dr["MeasurementSignificanceCode"] );
			usage.MeterNumber = Convert.ToString( dr["MeterNumber"] == DBNull.Value ? String.Empty : dr["MeterNumber"] );
			usage.Quantity = Convert.ToDecimal( dr["Quantity"] == DBNull.Value ? 0m : dr["Quantity"] );
			usage.ServiceDeliveryPoint = Convert.ToString( dr["ServiceDeliveryPoint"] == DBNull.Value ? String.Empty : dr["ServiceDeliveryPoint"] );
			usage.TransactionSetPurposeCode = Convert.ToString( dr["TransactionSetPurposeCode"] == DBNull.Value ? String.Empty : dr["TransactionSetPurposeCode"] );
			usage.UnitOfMeasurement = Convert.ToString( dr["UnitOfMeasurement"] == DBNull.Value ? String.Empty : dr["UnitOfMeasurement"] );

			return usage;
		}
		/// <summary>
		/// Gets the last 814 key processed
		/// </summary>
		/// <returns></returns>
		private static int GetLastProcessedKey814()
		{
			int last814Key = 0;
			DataTable dt = EdiSql.SelectLastProcessed814Key().Tables[0];

			if( dt.Rows.Count > 0 )
				last814Key = Convert.ToInt32( dt.Rows[0][0] );
			else
				throw new Key814NotFoundException( "Last 814 key not found." );

			return last814Key;
		}

		/// <summary>
		/// Gets the latest unprocessed 814 records
		/// </summary>
		/// <returns>Returns an 814 header list</returns>
		public static IstaHeader814List GetUnprocessed814Records()
		{
			return Build814Objects( EdiSql.GetUnprocessed814Transactions( GetLastProcessedKey814() ) );
		}

		/// <summary>
		/// Builds objects for 814 records
		/// </summary>
		/// <param name="ds">DataSet containing 814 tables</param>
		/// <returns>Returns an 814 header list</returns>
		private static IstaHeader814List Build814Objects( DataSet ds )
		{
			IstaHeader814List transactions = new IstaHeader814List();
			DataTable dtHeader = ds.Tables["Header"];
			DataTable dtService = ds.Tables["Service"];

			foreach( DataRow drH in dtHeader.Rows )
			{
				Ista814Header header = new Ista814Header();
				header.Direction = Convert.ToInt32( drH["Direction"] );
				header.Key814 = Convert.ToInt32( drH["814_Key"] );
				header.UtilityDuns = drH["UtilityDuns"].ToString();

				// response type - enrollment or deenrollment, accept or reject
				ResponseType responseType = (ResponseType) Enum.ToObject( typeof( ResponseType ), Convert.ToInt32( drH["ResponseType"] ) );
				header.ResponseType = responseType;

				header.LibertyPowerReasonCode = drH["LibertyPowerReasonCode"].ToString();

				DataSet ds2 = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilitySql.GetUtilityCodeByDuns( drH["UtilityDuns"].ToString() );

				if( ds2.Tables[0].Rows.Count > 0 )
					header.UtilityCode = ds2.Tables[0].Rows[0]["UtilityCode"].ToString().Trim();
				else
					header.UtilityCode = "";

				foreach( DataRow drS in dtService.Rows )
				{
					// create related service objects, add to header
					if( Convert.ToInt32( drS["814_Key"] ) == header.Key814 )
					{
						Ista814Service service = new Ista814Service();
						service.Key814 = Convert.ToInt32( drS["814_Key"] );
						service.AccountNumber = drS["AccountNumber"].ToString();
						service.TransactionStatus = drS["TransactionStatus"].ToString();
						service.ServiceType2 = drS["ServiceType2"].ToString();
						try
						{
							service.FlowStartDate = Convert.ToDateTime( drS["FlowStartDate"] );
						}
						catch
						{

						}
						try
						{
							service.DeEnrollmentDate = Convert.ToDateTime( drS["DeEnrollmentDate"] );
						}
						catch
						{

						}
						header.AddIsta814Service( service );
					}
				}

				transactions.Add( header );
			}

			return transactions;
		}

		public static WebAccountList GetWebAccountList( EdiAccountList ediAccountList )
		{
			WebAccountList webAccountList = new WebAccountList();

			foreach( EdiAccount ediAccount in ediAccountList )
				webAccountList.Add( GetWebAccount( ediAccount ) );

			return webAccountList;
		}

		public static WebAccount GetWebAccount( EdiAccount ediAccount )
		{
			WebAccount webAccount = new WebAccount();
			webAccount.AccountNumber = ediAccount.AccountNumber;
			webAccount.Icap = ediAccount.Icap;
			webAccount.LoadProfile = ediAccount.LoadProfile;
			webAccount.LoadShapeId = ediAccount.LoadShapeId;
			webAccount.RateClass = ediAccount.RateClass;
			webAccount.Tcap = ediAccount.Tcap;
			webAccount.UtilityCode = ediAccount.UtilityCode;
			webAccount.Voltage = ediAccount.Voltage;
			webAccount.WebUsageList = GetWebUsageList( ediAccount.EdiUsageList );
			webAccount.ZoneCode = ediAccount.ZoneCode;

			return webAccount;
		}

		public static WebUsageList GetWebUsageList( EdiUsageList ediUsageList )
		{
			WebUsageList webUsageList = new WebUsageList();

			foreach( EdiUsage ediUsage in ediUsageList )
				webUsageList.Add( GetWebUsage( ediUsage ) );

			return webUsageList;
		}

		public static WebUsage GetWebUsage( EdiUsage ediUsage )
		{
			DateTime from = ediUsage.BeginDate;
			DateTime to = ediUsage.EndDate;
			TimeSpan span = to.Subtract( from );

			WebUsage webUsage = new WebUsage();
			webUsage.BeginDate = ediUsage.BeginDate;
			webUsage.EndDate = ediUsage.EndDate;
			webUsage.Days = span.Days;
			webUsage.MeterNumber = ediUsage.MeterNumber;
			webUsage.TotalKwh = Convert.ToInt32( ediUsage.Quantity );

			return webUsage;
		}
	}
}
