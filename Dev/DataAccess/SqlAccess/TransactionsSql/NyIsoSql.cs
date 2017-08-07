namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql
{
	using System;
	using System.Data;
	using System.Data.SqlClient;

	// May 2010
    // Changes to Bill Group type by ManojTFS-63739 -3/09/15
	public static class NyIsoSql
	{

		// ------------------------------------------------------------------------------------
		public static DataSet ConedAccountInsert( string customerName, string accountNumber, string serviceAddress, string town, string zipCode,
			string seasonalTurnOff, DateTime nextScheduledReadDate, string tensionCode, string stratumVariable, decimal? iCAP, Int16 residential,
			string zone, string billGroup, string rateClass, string previousAccountNumber, string taxable, string Profile,
			string meterType, string createdBy, string pfjIcap, Int16 minMonthlyDemand, string todCode, string muni )
		{
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ConedAccountInsert";

					command.Parameters.Add( new SqlParameter( "customerName", customerName ) );
					command.Parameters.Add( new SqlParameter( "accountNumber", accountNumber ) );
					command.Parameters.Add( new SqlParameter( "serviceAddress", serviceAddress ) );
					command.Parameters.Add( new SqlParameter( "town", town ) );
					command.Parameters.Add( new SqlParameter( "zipCode", zipCode ) );
					command.Parameters.Add( new SqlParameter( "seasonalTurnOff", seasonalTurnOff ) );
					command.Parameters.Add( new SqlParameter( "nextScheduledReadDate", nextScheduledReadDate ) );
					command.Parameters.Add( new SqlParameter( "tensionCode", tensionCode ) );
					command.Parameters.Add( new SqlParameter( "stratumVariable", stratumVariable ) );
					command.Parameters.Add( new SqlParameter( "iCAP", iCAP ) );
					command.Parameters.Add( new SqlParameter( "PfjIcap", pfjIcap ) );
					command.Parameters.Add( new SqlParameter( "residential", residential ) );
					command.Parameters.Add( new SqlParameter( "zone", zone ) );
					command.Parameters.Add( new SqlParameter( "billGroup", billGroup ) );
					command.Parameters.Add( new SqlParameter( "rateClass", rateClass ) );
					command.Parameters.Add( new SqlParameter( "previousAccountNumber", previousAccountNumber ) );
					command.Parameters.Add( new SqlParameter( "MinMonthlyDemand", minMonthlyDemand ) );
					command.Parameters.Add( new SqlParameter( "TodCode", todCode ) );
					command.Parameters.Add( new SqlParameter( "taxable", taxable ) );
					command.Parameters.Add( new SqlParameter( "Profile", Profile ) );
					command.Parameters.Add( new SqlParameter( "Muni", muni ) );
					command.Parameters.Add( new SqlParameter( "meterType", meterType ) );
					command.Parameters.Add( new SqlParameter( "createdBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet ConedUsageInsert( string accountNumber, int usage, DateTime fromDate, DateTime toDate, decimal demand, decimal billAmount,
			string createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_ConedUsageInsert";

					command.Parameters.Add( new SqlParameter( "accountNumber", accountNumber ) );
					command.Parameters.Add( new SqlParameter( "from", fromDate ) );
					command.Parameters.Add( new SqlParameter( "to", toDate ) );
					command.Parameters.Add( new SqlParameter( "usage", usage ) );
					command.Parameters.Add( new SqlParameter( "demand", demand ) );
					command.Parameters.Add( new SqlParameter( "billAmount", billAmount ) );
					command.Parameters.Add( new SqlParameter( "createdBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet NysegAccountInsert( string accountNumber, string customerName, string currentRateCategory, string futureRateCategory,
			string revenueClass, string loadShapeID, string grid, string taxJurisdiction, string taxDistrict,
			string mailingStreet, string mailingCity, string mailingZipCode, string mailingStateCode, string serviceStreet,
			string serviceCity, string serviceZipCode, string serviceStateCode, string createdBy, string meterNumber, decimal icap,string billGroup )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NysegAccountInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerName", customerName ) );
					cmd.Parameters.Add( new SqlParameter( "@CurrentRateCategory", currentRateCategory ) );
					cmd.Parameters.Add( new SqlParameter( "@FutureRateCategory", futureRateCategory ) );
					cmd.Parameters.Add( new SqlParameter( "@RevenueClass", revenueClass ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadShapeID", loadShapeID ) );
					cmd.Parameters.Add( new SqlParameter( "@Grid", grid ) );
					cmd.Parameters.Add( new SqlParameter( "@TaxJurisdiction", taxJurisdiction ) );
					cmd.Parameters.Add( new SqlParameter( "@TaxDistrict", taxDistrict ) );
					cmd.Parameters.Add( new SqlParameter( "@MailingStreet", mailingStreet ) );
					cmd.Parameters.Add( new SqlParameter( "@MailingCity", mailingCity ) );
					cmd.Parameters.Add( new SqlParameter( "@MailingStateCode", mailingStateCode ) );
					cmd.Parameters.Add( new SqlParameter( "@MailingZipCode", mailingZipCode ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceStreet", serviceStreet ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceCity", serviceCity ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceStateCode", serviceStateCode ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceZipCode", serviceZipCode ) );
					cmd.Parameters.Add( new SqlParameter( "@MeterNumber", meterNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@createdBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@Icap", icap ) );
                    cmd.Parameters.Add(new SqlParameter("@BillGroup", billGroup));

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet NysegUsageInsert( string accountNumber, DateTime beginDate, DateTime endDate, string readType,
			decimal kwOn, decimal kwOff, decimal kwhOn, decimal kwhOff, decimal kwhMid, decimal total, decimal totalTax, int days, string createdBy,
			decimal kw, decimal kwh, decimal rkvah )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NysegUsageInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@BeginDate", beginDate ) );
					cmd.Parameters.Add( new SqlParameter( "@EndDate", endDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Days", days ) );
					cmd.Parameters.Add( new SqlParameter( "@ReadType", readType ) );
					cmd.Parameters.Add( new SqlParameter( "@kw", kw ) );
					cmd.Parameters.Add( new SqlParameter( "@KwOn", kwOn ) );
					cmd.Parameters.Add( new SqlParameter( "@KwOff", kwOff ) );
					cmd.Parameters.Add( new SqlParameter( "@kwh", kwh ) );
					cmd.Parameters.Add( new SqlParameter( "@KwhOn", kwhOn ) );
					cmd.Parameters.Add( new SqlParameter( "@KwhOff", kwhOff ) );
					cmd.Parameters.Add( new SqlParameter( "@KwhMid", kwhMid ) );
					cmd.Parameters.Add( new SqlParameter( "@rkvah", rkvah ) );
					cmd.Parameters.Add( new SqlParameter( "@Total", total ) );
					cmd.Parameters.Add( new SqlParameter( "@TotalTax", totalTax ) );
					cmd.Parameters.Add( new SqlParameter( "@createdBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet RgeAccountInsert( string accountNumber, string customerName, string currentRateCategory, string futureRateCategory,
			string revenueClass, string loadShapeID, string grid, string taxJurisdiction, string taxDistrict,
			string mailingStreet, string mailingCity, string mailingZipCode, string mailingStateCode, string serviceStreet,
            string serviceCity, string serviceZipCode, string serviceStateCode, string createdBy, string meterNumber, decimal icap, string billGroup)
		{
			SqlParameter accountNumberParam;
			SqlParameter customerNameParam;
			SqlParameter currentRatecategoryParam;
			SqlParameter futureRateCategoryParam;
			SqlParameter revenueClassParam;
			SqlParameter loadShapeIDParam;
			SqlParameter gridParam;
			SqlParameter taxJurisdictionParam;
			SqlParameter taxDistrictParam;
			SqlParameter mailingStreetParam;
			SqlParameter mailingCityParam;
			SqlParameter mailingZipCodeParam;
			SqlParameter mailingStateCodeParam;
			SqlParameter serviceStreetParam;
			SqlParameter serviceCityParam;
			SqlParameter serviceZipCodeParam;
			SqlParameter serviceStateCodeParam;
			SqlParameter meterNumberParam;
			SqlParameter createdByParam;
			SqlParameter icapParam;
            SqlParameter billgroupParam;
			DataSet ds = new DataSet();

			accountNumberParam = new SqlParameter( "@AccountNumber", accountNumber );
			customerNameParam = new SqlParameter( "@CustomerName", customerName );
			currentRatecategoryParam = new SqlParameter( "@CurrentRateCategory", currentRateCategory );
			futureRateCategoryParam = new SqlParameter( "@FutureRateCategory", futureRateCategory );
			revenueClassParam = new SqlParameter( "@RevenueClass", revenueClass );
			loadShapeIDParam = new SqlParameter( "@LoadShapeID", loadShapeID );
			gridParam = new SqlParameter( "@Grid", grid );
			taxJurisdictionParam = new SqlParameter( "@TaxJurisdiction", taxJurisdiction );
			taxDistrictParam = new SqlParameter( "@TaxDistrict", taxDistrict );
			mailingStreetParam = new SqlParameter( "@MailingStreet", mailingStreet );
			mailingCityParam = new SqlParameter( "@MailingCity", mailingCity );
			mailingZipCodeParam = new SqlParameter( "@MailingZipCode", mailingZipCode );
			mailingStateCodeParam = new SqlParameter( "@MailingStateCode", mailingStateCode );
			serviceStreetParam = new SqlParameter( "@ServiceStreet", serviceStreet );
			serviceCityParam = new SqlParameter( "@ServiceCity", serviceCity );
			serviceZipCodeParam = new SqlParameter( "@ServiceZipCode", serviceZipCode );
			serviceStateCodeParam = new SqlParameter( "@ServiceStateCode", serviceStateCode );
			meterNumberParam = new SqlParameter( "@MeterNumber", meterNumber );
			createdByParam = new SqlParameter( "@createdBy", createdBy );
			icapParam = new SqlParameter( "@Icap", icap );
            billgroupParam=new SqlParameter("@BillGroup", billGroup);

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_RgeAccountInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( accountNumberParam );
					cmd.Parameters.Add( customerNameParam );
					cmd.Parameters.Add( currentRatecategoryParam );
					cmd.Parameters.Add( futureRateCategoryParam );
					cmd.Parameters.Add( revenueClassParam );
					cmd.Parameters.Add( loadShapeIDParam );
					cmd.Parameters.Add( gridParam );
					cmd.Parameters.Add( taxJurisdictionParam );
					cmd.Parameters.Add( taxDistrictParam );
					cmd.Parameters.Add( mailingStreetParam );
					cmd.Parameters.Add( mailingCityParam );
					cmd.Parameters.Add( mailingZipCodeParam );
					cmd.Parameters.Add( mailingStateCodeParam );
					cmd.Parameters.Add( serviceStreetParam );
					cmd.Parameters.Add( serviceCityParam );
					cmd.Parameters.Add( serviceZipCodeParam );
					cmd.Parameters.Add( serviceStateCodeParam );
					cmd.Parameters.Add( meterNumberParam );
					cmd.Parameters.Add( createdByParam );
					cmd.Parameters.Add( icapParam );
                    cmd.Parameters.Add(billgroupParam);

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet RgeUsageInsert( string accountNumber, DateTime beginDate, DateTime endDate, string readType,
			decimal kwOn, decimal kwOff, decimal kwhOn, decimal kwhOff, decimal kwhMid, decimal total, decimal totalTax, int days, string createdBy,
			decimal kw, decimal kwh, decimal rkvah )
		{
			SqlParameter accountNumberParam;
			SqlParameter beginDateParam;
			SqlParameter endDateParam;
			SqlParameter readTypeParam;
			SqlParameter kwOnParam;
			SqlParameter kwOffParam;
			SqlParameter kwhOnParam;
			SqlParameter kwhOffParam;
			SqlParameter kwhMidParam;
			SqlParameter totalParam;
			SqlParameter totalTaxParam;
			SqlParameter daysParam;
			SqlParameter createdByParam;
			SqlParameter kwParam;
			SqlParameter kwhParam;
			SqlParameter rkvahParam;
			DataSet ds = new DataSet();

			accountNumberParam = new SqlParameter( "@AccountNumber", accountNumber );
			beginDateParam = new SqlParameter( "@BeginDate", beginDate );
			endDateParam = new SqlParameter( "@EndDate", endDate );
			readTypeParam = new SqlParameter( "@ReadType", readType );
			kwParam = new SqlParameter( "@kw", kw );
			kwOnParam = new SqlParameter( "@KwOn", kwOn );
			kwOffParam = new SqlParameter( "@KwOff", kwOff );
			kwhParam = new SqlParameter( "@kwh", kwh );
			kwhOnParam = new SqlParameter( "@KwhOn", kwhOn );
			kwhOffParam = new SqlParameter( "@KwhOff", kwhOff );
			kwhMidParam = new SqlParameter( "@KwhMid", kwhMid );
			rkvahParam = new SqlParameter( "@rkvah", rkvah );
			totalParam = new SqlParameter( "@Total", total );
			totalTaxParam = new SqlParameter( "@TotalTax", totalTax );
			daysParam = new SqlParameter( "@Days", days );
			createdByParam = new SqlParameter( "@createdBy", createdBy );

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_RgeUsageInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( accountNumberParam );
					cmd.Parameters.Add( beginDateParam );
					cmd.Parameters.Add( endDateParam );
					cmd.Parameters.Add( readTypeParam );
					cmd.Parameters.Add( kwhParam );
					cmd.Parameters.Add( kwhOnParam );
					cmd.Parameters.Add( kwhOffParam );
					cmd.Parameters.Add( kwParam );
					cmd.Parameters.Add( kwOnParam );
					cmd.Parameters.Add( kwOffParam );
					cmd.Parameters.Add( kwhMidParam );
					cmd.Parameters.Add( rkvahParam );
					cmd.Parameters.Add( totalParam );
					cmd.Parameters.Add( totalTaxParam );
					cmd.Parameters.Add( daysParam );
					cmd.Parameters.Add( createdByParam );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet NimoAccountInsert( string accountNumber, string customerName, string rateClass,
			string rateCode, string taxDistrict, string voltage, string zoneCode, string createdBy, string mailingStreet, string mailingCity,
			string mailingStateCode, string mailingZipCode )
		{
			SqlParameter accountNumberParam = new SqlParameter( "@AccountNumber", accountNumber );
			SqlParameter customerNameParam = new SqlParameter( "@CustomerName", customerName );
			SqlParameter rateClassParam = new SqlParameter( "@RateClass", rateClass );
			SqlParameter rateCodeParam = new SqlParameter( "@RateCode", rateCode );
			SqlParameter taxDistrictParam = new SqlParameter( "@TaxDistrict", taxDistrict );
			SqlParameter voltageParam = new SqlParameter( "@Voltage", voltage );
			SqlParameter zoneCodeParam = new SqlParameter( "@ZoneCode", zoneCode );
			SqlParameter createdByParam = new SqlParameter( "@CreatedBy", createdBy );
			SqlParameter mailingStreetParam = new SqlParameter( "@MailingStreet", mailingStreet );
			SqlParameter mailingCityParam = new SqlParameter( "@MailingCity", mailingCity );
			SqlParameter mailingStateCodeParam = new SqlParameter( "@MailingStateCode", mailingStateCode );
			SqlParameter mailingZipCodeParam = new SqlParameter( "@MailingZipCode", mailingZipCode );
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NimoAccountInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( accountNumberParam );
					cmd.Parameters.Add( customerNameParam );
					cmd.Parameters.Add( rateClassParam );
					cmd.Parameters.Add( rateCodeParam );
					cmd.Parameters.Add( taxDistrictParam );
					cmd.Parameters.Add( voltageParam );
					cmd.Parameters.Add( zoneCodeParam );
					cmd.Parameters.Add( mailingStreetParam );
					cmd.Parameters.Add( mailingCityParam );
					cmd.Parameters.Add( mailingStateCodeParam );
					cmd.Parameters.Add( mailingZipCodeParam );
					cmd.Parameters.Add( createdByParam );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet NimoUsageInsert( string accountNumber, DateTime beginDate, DateTime endDate, string billCode,
			int days, decimal billedKwhTotal, decimal meteredPeakKw, decimal meteredOnPeakKw, decimal billedPeakKw,
			decimal billedOnPeakKw, decimal billDetailAmt, decimal billedRkva, decimal onPeakKwh,
			decimal offPeakKwh, decimal shoulderKwh, decimal offSeasonKwh, string createdBy )
		{
			SqlParameter accountNumberParam = new SqlParameter( "@AccountNumber", accountNumber );
			SqlParameter beginDateParam = new SqlParameter( "@BeginDate", beginDate );
			SqlParameter endDateParam = new SqlParameter( "@EndDate", endDate );
			SqlParameter billCodeParam = new SqlParameter( "@BillCode", billCode );
			SqlParameter daysParam = new SqlParameter( "@Days", days );
			SqlParameter billedKwhTotalParam = new SqlParameter( "@BilledKwhTotal", billedKwhTotal );
			SqlParameter meteredPeakKwParam = new SqlParameter( "@MeteredPeakKw", meteredPeakKw );
			SqlParameter meteredOnPeakKwParam = new SqlParameter( "@MeteredOnPeakKw", meteredOnPeakKw );
			SqlParameter billedPeakKwParam = new SqlParameter( "@BilledPeakKw", billedPeakKw );
			SqlParameter billedOnPeakKwParam = new SqlParameter( "@BilledOnPeakKw", billedOnPeakKw );
			SqlParameter billDetailAmtParam = new SqlParameter( "@BilldetailAmt", billDetailAmt );
			SqlParameter billedRkvaParam = new SqlParameter( "@BilledRkva", billedRkva );
			SqlParameter onPeakKwhParam = new SqlParameter( "@OnPeakKwh", onPeakKwh );
			SqlParameter offPeakKwhParam = new SqlParameter( "@OffPeakKwh", offPeakKwh );
			SqlParameter shoulderKwhParam = new SqlParameter( "@ShoulderKwh", shoulderKwh );
			SqlParameter offSeasonKwhParam = new SqlParameter( "@OffSeasonKwh", offSeasonKwh );
			SqlParameter createdByParam = new SqlParameter( "@CreatedBy", createdBy );
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NimoUsageInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( accountNumberParam );
					cmd.Parameters.Add( beginDateParam );
					cmd.Parameters.Add( endDateParam );
					cmd.Parameters.Add( billCodeParam );
					cmd.Parameters.Add( daysParam );
					cmd.Parameters.Add( billedKwhTotalParam );
					cmd.Parameters.Add( meteredPeakKwParam );
					cmd.Parameters.Add( meteredOnPeakKwParam );
					cmd.Parameters.Add( billedPeakKwParam );
					cmd.Parameters.Add( billedOnPeakKwParam );
					cmd.Parameters.Add( billDetailAmtParam );
					cmd.Parameters.Add( billedRkvaParam );
					cmd.Parameters.Add( onPeakKwhParam );
					cmd.Parameters.Add( offPeakKwhParam );
					cmd.Parameters.Add( shoulderKwhParam );
					cmd.Parameters.Add( offSeasonKwhParam );
					cmd.Parameters.Add( createdByParam );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet CenhudAccountInsert( string accountNumber, string cityName, string county, string billCycle, string billFrequency,
			decimal taxRate, string rateCode, string loadZone, string loadShapeId, string zoneCode,
			decimal usageFactor, string createdBy, DateTime NextScheduledReadDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand commandBuilder = new SqlCommand() )
				{
					commandBuilder.CommandType = CommandType.StoredProcedure;
					commandBuilder.CommandText = "usp_CenhudAccountInsert";
					commandBuilder.Connection = conn;

					commandBuilder.Parameters.AddWithValue( "AccountNumber", accountNumber );
					commandBuilder.Parameters.AddWithValue( "CityName", cityName );
					commandBuilder.Parameters.AddWithValue( "County", county );
					commandBuilder.Parameters.AddWithValue( "Cycle", billCycle );
					commandBuilder.Parameters.AddWithValue( "BillFrequency", billFrequency );
					commandBuilder.Parameters.AddWithValue( "TaxRate", taxRate );
					commandBuilder.Parameters.AddWithValue( "RateCode", rateCode );
					commandBuilder.Parameters.AddWithValue( "LoadZone", loadZone );
					commandBuilder.Parameters.AddWithValue( "LoadShapeId", loadShapeId );
					commandBuilder.Parameters.AddWithValue( "ZoneCode", zoneCode );
					commandBuilder.Parameters.AddWithValue( "UsageFactor", usageFactor );
					commandBuilder.Parameters.AddWithValue( "CreatedBy", createdBy );
					commandBuilder.Parameters.AddWithValue( "NextScheduledReadDate", NextScheduledReadDate );

					using( SqlDataAdapter da = new SqlDataAdapter( commandBuilder ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet CenhudUsageInsert( string accountNumber, string readCode, decimal numberOfMonths,
			DateTime beginDate, DateTime endDate, int days, string meterNumber, int totalKwh,
			decimal demandKw, decimal totalBilledAmount, decimal salesTax, string createdBy, decimal onPeak, decimal offPeak )
		{
			DataSet ds = new DataSet();

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand commandBuilder = new SqlCommand() )
				{
					commandBuilder.CommandType = CommandType.StoredProcedure;
					commandBuilder.CommandText = "usp_CenhudUsageInsert";
					commandBuilder.Connection = conn;

					commandBuilder.Parameters.AddWithValue( "AccountNumber", accountNumber );
					commandBuilder.Parameters.AddWithValue( "ReadCode", readCode );
					commandBuilder.Parameters.AddWithValue( "NumberOfMonths", numberOfMonths );
					commandBuilder.Parameters.AddWithValue( "BeginDate", beginDate );
					commandBuilder.Parameters.AddWithValue( "EndDate", endDate );
					commandBuilder.Parameters.AddWithValue( "Days", days );
					commandBuilder.Parameters.AddWithValue( "MeterNumber", meterNumber );
					commandBuilder.Parameters.AddWithValue( "TotalKwh", totalKwh );
					commandBuilder.Parameters.AddWithValue( "DemandKw", demandKw );
					commandBuilder.Parameters.AddWithValue( "TotalBilledAmount", totalBilledAmount );
					commandBuilder.Parameters.AddWithValue( "SalesTax", salesTax );
					commandBuilder.Parameters.AddWithValue( "OnPeakKwh", onPeak );
					commandBuilder.Parameters.AddWithValue( "OffPeakKwh", offPeak );
					commandBuilder.Parameters.AddWithValue( "CreatedBy", createdBy );

					using( SqlDataAdapter da = new SqlDataAdapter( commandBuilder ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

	}
}
