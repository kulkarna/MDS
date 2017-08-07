namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql
{
	using System;
	using System.Data;
	using System.Data.SqlClient;

	// December 2010
    // Changes to Bill Group type by ManojTFS-63739 -3/09/15
	public static class PjmIsoSql
	{

		public static DataSet BgeAccountInsert( string accountNumber, string customerName, string customerSegment, int tariffCode,
			decimal capPLC, decimal transPLC, decimal capPLCPrev, decimal transPLCPrev,
			DateTime capPLCEffectiveDt, DateTime transPLCEffectiveDt, DateTime capPLCPrevEffectiveDt, DateTime transPLCPrevEffectiveDt,
			string POLRType, string billGroup, string specialBilling, string multipleMeters,
			string serviceAddressStreet, string serviceAddressCityName, string serviceAddressStateCode,
			string serviceAddressZipCode, string billingAddressStreet, string billingAddressCityName,
			string billingAddressStateCode, string billingAddressZipCode, string createdBy )
		{
			DataSet ds = new DataSet();
			SqlParameter accountNumberParam;
			SqlParameter customerNameParam;
			SqlParameter customerSegmentParam;
			SqlParameter tariffCodeParam;
			SqlParameter capPLCParam;
			SqlParameter transPLCParam;
			SqlParameter capPLCPrevParam;
			SqlParameter transPLCPrevParam;
			SqlParameter capPLCEffectiveDtParam;
			SqlParameter transPLCEffectiveDtParam;
			SqlParameter capPLCPrevEffectiveDtParam;
			SqlParameter transPLCPrevEffectiveDtParam;
			SqlParameter POLRTypeParam;
			SqlParameter billGroupParam;
			SqlParameter specialBillingParam;
			SqlParameter multipleMetersParam;
			SqlParameter serviceAddressStreetParam;
			SqlParameter serviceAddressCityNameParam;
			SqlParameter serviceAddressStateCodeParam;
			SqlParameter serviceAddressZipCodeParam;
			SqlParameter billingAddressStreetParam;
			SqlParameter billingAddressCityNameParam;
			SqlParameter billingAddressStateCodeParam;
			SqlParameter billingAddressZipCodeParam;
			SqlParameter createdByParam;

			accountNumberParam = new SqlParameter( "@AccountNumber", accountNumber );
			customerNameParam = new SqlParameter( "@CustomerName", customerName );
			customerSegmentParam = new SqlParameter( "@CustomerSegment", customerSegment );
			tariffCodeParam = new SqlParameter( "@TariffCode", tariffCode );
			capPLCParam = new SqlParameter( "@CapPLC", capPLC );
			transPLCParam = new SqlParameter( "@TransPLC", transPLC );
			capPLCPrevParam = new SqlParameter( "@CapPLCPrev", capPLCPrev );
			transPLCPrevParam = new SqlParameter( "@TransPLCPrev", transPLCPrev );
			capPLCEffectiveDtParam = new SqlParameter( "@CapPLCEffectiveDt", capPLCEffectiveDt );
			transPLCEffectiveDtParam = new SqlParameter( "@TransPLCEffectiveDt", transPLCEffectiveDt );
			capPLCPrevEffectiveDtParam = new SqlParameter( "@CapPLCPrevEffectiveDt", capPLCPrevEffectiveDt );
			transPLCPrevEffectiveDtParam = new SqlParameter( "@TransPLCPrevEffectiveDt", transPLCPrevEffectiveDt );
			POLRTypeParam = new SqlParameter( "@POLRType", POLRType );
			billGroupParam = new SqlParameter( "@BillGroup", billGroup );
			specialBillingParam = new SqlParameter( "@SpecialBilling", specialBilling );
			multipleMetersParam = new SqlParameter( "@MultipleMeters", multipleMeters );
			serviceAddressStreetParam = new SqlParameter( "@ServiceAddressStreet", serviceAddressStreet );
			serviceAddressCityNameParam = new SqlParameter( "@ServiceAddressCityName", serviceAddressCityName );
			serviceAddressStateCodeParam = new SqlParameter( "@ServiceAddressStateCode", serviceAddressStateCode );
			serviceAddressZipCodeParam = new SqlParameter( "@ServiceAddressZipCode", serviceAddressZipCode );
			billingAddressStreetParam = new SqlParameter( "@BillingAddressStreet", billingAddressStreet );
			billingAddressCityNameParam = new SqlParameter( "@BillingAddressCityName", billingAddressCityName );
			billingAddressStateCodeParam = new SqlParameter( "@BillingAddressStateCode", billingAddressStateCode );
			billingAddressZipCodeParam = new SqlParameter( "@BillingAddressZipCode", billingAddressZipCode );
			createdByParam = new SqlParameter( "@CreatedBy", createdBy );

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BgeAccountInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( accountNumberParam );
					cmd.Parameters.Add( customerNameParam );
					cmd.Parameters.Add( customerSegmentParam );
					cmd.Parameters.Add( tariffCodeParam );
					cmd.Parameters.Add( capPLCParam );
					cmd.Parameters.Add( transPLCParam );
					cmd.Parameters.Add( capPLCPrevParam );
					cmd.Parameters.Add( transPLCPrevParam );

					if( capPLCEffectiveDt != DateTime.MinValue )
						cmd.Parameters.Add( capPLCEffectiveDtParam );

					if( transPLCEffectiveDt != DateTime.MinValue )
						cmd.Parameters.Add( transPLCEffectiveDtParam );

					if( capPLCPrevEffectiveDt != DateTime.MinValue )
						cmd.Parameters.Add( capPLCPrevEffectiveDtParam );

					if( transPLCPrevEffectiveDt != DateTime.MinValue )
						cmd.Parameters.Add( transPLCPrevEffectiveDtParam );

					cmd.Parameters.Add( POLRTypeParam );
					cmd.Parameters.Add( billGroupParam );
					cmd.Parameters.Add( specialBillingParam );
					cmd.Parameters.Add( multipleMetersParam );
					cmd.Parameters.Add( serviceAddressStreetParam );
					cmd.Parameters.Add( serviceAddressStateCodeParam );
					cmd.Parameters.Add( serviceAddressCityNameParam );
					cmd.Parameters.Add( serviceAddressZipCodeParam );
					cmd.Parameters.Add( billingAddressStreetParam );
					cmd.Parameters.Add( billingAddressStateCodeParam );
					cmd.Parameters.Add( billingAddressCityNameParam );
					cmd.Parameters.Add( billingAddressZipCodeParam );
					cmd.Parameters.Add( createdByParam );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet BgeUsageInsert( string accountNumber, DateTime beginDate, DateTime endDate, int days,
			int totalKwh, decimal onPeakKwh, decimal offPeakKwh, string readingSource, decimal intermediatePeakKwh,
			string seasonalCrossOver, decimal deliveryDemandKw, decimal genTransDemandKw, decimal usageFactorNonTOU,
			decimal usageFactorOnPeak, decimal usageFactorOffPeak, decimal usagaFactorIntermediate,
			string meterNumber, string meterType, string createdBy )
		{
			DataSet ds = new DataSet();
			SqlParameter accountNumberParam;
			SqlParameter beginDateParam;
			SqlParameter endDateParam;
			SqlParameter daysParam;
			SqlParameter totalKwhParam;
			SqlParameter onPeakKwhParam;
			SqlParameter offPeakKwhParam;
			SqlParameter readingSourceParam;
			SqlParameter intermediatePeakKwhParam;
			SqlParameter seasonalCrossOverParam;
			SqlParameter deliveryDemandKwParam;
			SqlParameter genTransDemandKwParam;
			SqlParameter usageFactorNonTOUParam;
			SqlParameter usageFactorOnPeakParam;
			SqlParameter usageFactorOffPeakParam;
			SqlParameter usageFactorIntermediateParam;
			SqlParameter meterNumberParam;
			SqlParameter meterTypeParam;
			SqlParameter createdbyParam;

			accountNumberParam = new SqlParameter( "@AccountNumber", accountNumber );
			beginDateParam = new SqlParameter( "@BeginDate", beginDate );
			endDateParam = new SqlParameter( "@EndDate", endDate );
			daysParam = new SqlParameter( "@Days", days );
			totalKwhParam = new SqlParameter( "@TotalKwh", totalKwh );
			onPeakKwhParam = new SqlParameter( "@OnPeakKwh", onPeakKwh );
			offPeakKwhParam = new SqlParameter( "@OffPeakKwh", offPeakKwh );
			readingSourceParam = new SqlParameter( "@ReadingSource", readingSource );
			intermediatePeakKwhParam = new SqlParameter( "@IntermediatePeakKwh", intermediatePeakKwh );
			seasonalCrossOverParam = new SqlParameter( "@SeasonalCrossOver", seasonalCrossOver );
			deliveryDemandKwParam = new SqlParameter( "@DeliveryDemandKw", deliveryDemandKw );
			genTransDemandKwParam = new SqlParameter( "@GenTransDemandKw", genTransDemandKw );
			usageFactorNonTOUParam = new SqlParameter( "@UsageFactorNonTOU", usageFactorNonTOU );
			usageFactorOnPeakParam = new SqlParameter( "@UsageFactorOnPeak", usageFactorOnPeak );
			usageFactorOffPeakParam = new SqlParameter( "@UsageFactorOffPeak", usageFactorOffPeak );
			usageFactorIntermediateParam = new SqlParameter( "@UsageFactorIntermediate", usagaFactorIntermediate );
			meterNumberParam = new SqlParameter( "@MeterNumber", meterNumber );
			meterTypeParam = new SqlParameter( "@MeterType", meterType );
			createdbyParam = new SqlParameter( "@CreatedBy", createdBy );

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BgeUsageInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( accountNumberParam );
					cmd.Parameters.Add( beginDateParam );
					cmd.Parameters.Add( endDateParam );
					cmd.Parameters.Add( daysParam );
					cmd.Parameters.Add( totalKwhParam );
					cmd.Parameters.Add( onPeakKwhParam );
					cmd.Parameters.Add( offPeakKwhParam );
					cmd.Parameters.Add( readingSourceParam );
					cmd.Parameters.Add( intermediatePeakKwhParam );
					cmd.Parameters.Add( seasonalCrossOverParam );
					cmd.Parameters.Add( deliveryDemandKwParam );
					cmd.Parameters.Add( genTransDemandKwParam );
					cmd.Parameters.Add( usageFactorNonTOUParam );
					cmd.Parameters.Add( usageFactorOnPeakParam );
					cmd.Parameters.Add( usageFactorOffPeakParam );
					cmd.Parameters.Add( usageFactorIntermediateParam );
					cmd.Parameters.Add( meterNumberParam );
					cmd.Parameters.Add( meterTypeParam );
					cmd.Parameters.Add( createdbyParam );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet ComedAccountInsert( string accountNumber, string billGroup, decimal capacityPLCValue1,
			DateTime? capacityPLCStartDate1, DateTime? capacityPLCEndDate1, decimal capacityPLCValue2,
			DateTime? capacityPLCStartDate2, DateTime? capacityPLCEndDate2, decimal networkServicePLCValue,
			DateTime? networkServicePLCStartDate, DateTime? networkServicePLCEndDate, string condoException,
			string currentSupplyGroupName, DateTime? currentSupplyGroupEffectiveDate, string pendingSupplyGroupName,
			DateTime? pendingSupplyGroupEffectiveDate, DateTime? minimumStayDate, string createdBy, string meterNumber )
		{
			SqlParameter accountNumberParam;
			SqlParameter billGroupParam;
			SqlParameter capacityPLC1Param;
			SqlParameter capacityPLC1StartDateParam;
			SqlParameter capacityPLC1EndDateParam;
			SqlParameter capacityPLC2Param;
			SqlParameter capacityPLC2StartDateParam;
			SqlParameter capacityPLC2EndDateParam;
			SqlParameter networkServicePLCParam;
			SqlParameter networkServicePLCStartDateParam;
			SqlParameter networkServicePLCEndDateParam;
			SqlParameter condoExceptionParam;
			SqlParameter currentSupplyGroupNameParam;
			SqlParameter currentSupplyGroupEffectiveDateParam;
			SqlParameter pendingSupplyGroupNameParam;
			SqlParameter pendingSupplyGroupEffectiveDateParam;
			SqlParameter minimumStayDateParam;
			SqlParameter createdByParam;
			DataSet ds = new DataSet();

			accountNumberParam = new SqlParameter( "@AccountNumber", accountNumber );
			billGroupParam = new SqlParameter( "@BillGroup", billGroup );
			capacityPLC1Param = new SqlParameter( "@CapacityPLC1Value", capacityPLCValue1 );
			capacityPLC1StartDateParam = new SqlParameter( "@CapacityPLC1StartDate", capacityPLCStartDate1 != DateTime.MinValue ? capacityPLCStartDate1 : null );
			capacityPLC1EndDateParam = new SqlParameter( "@CapacityPLC1EndDate", capacityPLCEndDate1 != DateTime.MinValue ? capacityPLCEndDate1 : null );
			capacityPLC2Param = new SqlParameter( "@CapacityPLC2Value", capacityPLCValue2 );
			capacityPLC2StartDateParam = new SqlParameter( "@CapacityPLC2StartDate", capacityPLCStartDate2 != DateTime.MinValue ? capacityPLCStartDate2 : null );
			capacityPLC2EndDateParam = new SqlParameter( "@CapacityPLC2EndDate", capacityPLCEndDate2 != DateTime.MinValue ? capacityPLCEndDate2 : null );
			networkServicePLCParam = new SqlParameter( "@NetworkServicePLCValue", networkServicePLCValue );
			networkServicePLCStartDateParam = new SqlParameter( "@NetworkServicePLCStartDate", networkServicePLCStartDate != DateTime.MinValue ? networkServicePLCStartDate : null );
			networkServicePLCEndDateParam = new SqlParameter( "@NetworkServicePLCEndDate", networkServicePLCEndDate != DateTime.MinValue ? networkServicePLCEndDate : null );
			condoExceptionParam = new SqlParameter( "@CondoException", condoException );
			currentSupplyGroupNameParam = new SqlParameter( "@CurrentSupplyGroupName", currentSupplyGroupName );
			currentSupplyGroupEffectiveDateParam = new SqlParameter( "@CurrentSupplyGroupEffectiveDate", currentSupplyGroupEffectiveDate != DateTime.MinValue ? currentSupplyGroupEffectiveDate : null );
			pendingSupplyGroupNameParam = new SqlParameter( "@PendingSupplyGroupName", pendingSupplyGroupName );
			pendingSupplyGroupEffectiveDateParam = new SqlParameter( "@PendingSupplyGroupEffectiveDate", pendingSupplyGroupEffectiveDate != DateTime.MinValue ? pendingSupplyGroupEffectiveDate : null );
			minimumStayDateParam = new SqlParameter( "@MinimumStayDate", minimumStayDate != DateTime.MinValue ? minimumStayDate : null );
			createdByParam = new SqlParameter( "@CreatedBy", createdBy );
			SqlParameter meterNumberParam = new SqlParameter( "@meterNumber", meterNumber );

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ComedAccountInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( accountNumberParam );
					cmd.Parameters.Add( billGroupParam );
					cmd.Parameters.Add( capacityPLC1Param );
					cmd.Parameters.Add( capacityPLC1StartDateParam );
					cmd.Parameters.Add( capacityPLC1EndDateParam );
					cmd.Parameters.Add( capacityPLC2Param );
					cmd.Parameters.Add( capacityPLC2StartDateParam );
					cmd.Parameters.Add( capacityPLC2EndDateParam );
					cmd.Parameters.Add( networkServicePLCParam );
					cmd.Parameters.Add( networkServicePLCStartDateParam );
					cmd.Parameters.Add( networkServicePLCEndDateParam );
					cmd.Parameters.Add( condoExceptionParam );
					cmd.Parameters.Add( currentSupplyGroupNameParam );
					cmd.Parameters.Add( currentSupplyGroupEffectiveDateParam );
					cmd.Parameters.Add( pendingSupplyGroupNameParam );
					cmd.Parameters.Add( pendingSupplyGroupEffectiveDateParam );
					cmd.Parameters.Add( minimumStayDateParam );
					cmd.Parameters.Add( createdByParam );
					cmd.Parameters.Add( meterNumberParam );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet ComedUsageInsert( string accountNumber, string rate, DateTime? beginDate, DateTime? endDate,
			int days, int totalKwh, decimal onPeakKwh, decimal offPeakKwh, decimal billingDemandKw,
			decimal monthlyPeakDemandKw, string createdBy )
		{
			SqlParameter accountNumberParam;
			SqlParameter rateParam;
			SqlParameter beginDateParam;
			SqlParameter endDateParam;
			SqlParameter daysParam;
			SqlParameter totalKwhParam;
			SqlParameter onPeakKwhParam;
			SqlParameter offPeakKwhParam;
			SqlParameter billingDemandKwParam;
			SqlParameter monthlyPeakDemandKwParam;
			SqlParameter createdyParam;
			DataSet ds = new DataSet();

			accountNumberParam = new SqlParameter( "@AccountNumber", accountNumber );
			rateParam = new SqlParameter( "@Rate", rate );
			beginDateParam = new SqlParameter( "@BeginDate", beginDate != DateTime.MinValue ? beginDate : null );
			endDateParam = new SqlParameter( "@EndDate", endDate != DateTime.MinValue ? endDate : null );
			daysParam = new SqlParameter( "@Days", days );
			totalKwhParam = new SqlParameter( "@TotalKwh", totalKwh );
			onPeakKwhParam = new SqlParameter( "@OnPeakKwh", onPeakKwh );
			offPeakKwhParam = new SqlParameter( "@OffPeakKwh", offPeakKwh );
			billingDemandKwParam = new SqlParameter( "@BillingDemandKw", billingDemandKw );
			monthlyPeakDemandKwParam = new SqlParameter( "@MonthlyPeakDemandKw", monthlyPeakDemandKw );
			createdyParam = new SqlParameter( "@CreatedBy", createdBy );

			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ComedUsageInsert";
					cmd.Connection = conn;

					cmd.Parameters.Add( accountNumberParam );
					cmd.Parameters.Add( rateParam );
					cmd.Parameters.Add( beginDateParam );
					cmd.Parameters.Add( endDateParam );
					cmd.Parameters.Add( daysParam );
					cmd.Parameters.Add( totalKwhParam );
					cmd.Parameters.Add( onPeakKwhParam );
					cmd.Parameters.Add( offPeakKwhParam );
					cmd.Parameters.Add( billingDemandKwParam );
					cmd.Parameters.Add( monthlyPeakDemandKwParam );
					cmd.Parameters.Add( createdyParam );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet PecoAccountInsert( string accountNumber, string serviceZipCode, string billGroup, decimal iCAP, DateTime icapBeginDate,
			DateTime icapEndDate, decimal tcap, DateTime tcapBeginDate, DateTime tcapEndDate, string rateCode,
			string strata, string rateClass, string createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_PecoAccountInsert";

					command.Parameters.Add( new SqlParameter( "@accountNumber", accountNumber ) );
					command.Parameters.Add( new SqlParameter( "@serviceZipCode", serviceZipCode ) );
					command.Parameters.Add( new SqlParameter( "@billGroup", billGroup ) );
					command.Parameters.Add( new SqlParameter( "@icap", iCAP ) );
					command.Parameters.Add( new SqlParameter( "@icapBeginDate", icapBeginDate ) );
					command.Parameters.Add( new SqlParameter( "@icapEndDate", icapEndDate ) );
					command.Parameters.Add( new SqlParameter( "@tcap", tcap ) );
					command.Parameters.Add( new SqlParameter( "@tcapBeginDate", tcapBeginDate ) );
					command.Parameters.Add( new SqlParameter( "@tcapEndDate", tcapEndDate ) );
					command.Parameters.Add( new SqlParameter( "@rateCode", rateCode ) );
					command.Parameters.Add( new SqlParameter( "@strata", strata ) );
					command.Parameters.Add( new SqlParameter( "@rateClass", rateClass ) );
					command.Parameters.Add( new SqlParameter( "createdBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		public static DataSet PecoUsageInsert( string accountNumber, int usage, DateTime fromDate, DateTime toDate, decimal demand, string createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection connection = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand command = new SqlCommand() )
				{
					command.Connection = connection;
					command.CommandType = CommandType.StoredProcedure;
					command.CommandText = "usp_PecoUsageInsert";

					command.Parameters.Add( new SqlParameter( "accountNumber", accountNumber ) );
					command.Parameters.Add( new SqlParameter( "from", fromDate ) );
					command.Parameters.Add( new SqlParameter( "to", toDate ) );
					command.Parameters.Add( new SqlParameter( "usage", usage ) );
					command.Parameters.Add( new SqlParameter( "demand", demand ) );
					command.Parameters.Add( new SqlParameter( "createdBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( command ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

	}
}
