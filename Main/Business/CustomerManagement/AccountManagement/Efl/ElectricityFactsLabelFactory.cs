using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.Business.CustomerAcquisition.ProductManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class ElectricityFactsLabelFactory
	{
		/// <summary>
		/// Creates a Electricity Facts Label in PDF format
		/// </summary>
		/// <param name="market">Identifier of market</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="productId">Identifier of product</param>
		/// <param name="term">Term (in months)</param>
		/// <param name="rate">Rate</param>
		/// <param name="lpFixed">Monthly service charge</param>
		/// <param name="accountType">Type of account (SMB, RES, LCI)</param>
		/// <returns>Returns a path to the Electricity Facts Label PDF file</returns>
		public static string CreateElectricityFactsLabelPdf( string market, string utilityCode,
			string productId, int term, decimal rate, decimal lpFixed, string accountType )
		{
			string pdfPath = "";
			EflTemplateType eflType = EflTemplateType.OnDemand;
			CompanyAccountType acctType = CompanyAccountFactory.GetCompanyAccountType( accountType );
			int accountTypeID = accountType.ToUpper().Equals( CompanyAccountType.SMB.ToString() ) ? 1 : 2;

			EflRequest request = new EflRequest( utilityCode, term, rate, lpFixed, accountType, productId );

			ValidateRequest( request );

			RateUsageList rateUsages = CreateRateUsages( utilityCode, accountType, request, 0m, 0m, "" );

			ElectricityFactsLabelList eflList = new ElectricityFactsLabelList();

			eflList.Add( CreateElectricityFactsLabel( rateUsages, term, utilityCode, DateTime.Today ) );

			pdfPath = PdfFactory.CreatePdf( ConvertEflListToDataSet( eflList, acctType, market, utilityCode, productId, lpFixed, eflType ), "EFD", productId, accountTypeID );

			return pdfPath;
		}

		/// <summary>
		/// Creates a Electricity Facts Label for the default product in PDF format
		/// </summary>
		/// <param name="market">Identifier of market</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="productId">Identifier of product</param>
		/// <param name="term">Term (in months)</param>
		/// <param name="rate">Rate</param>
		/// <param name="lpFixed">Monthly service charge</param>
		/// <param name="accountType">Type of account (SMB, RES, LCI)</param>
		/// <returns>Returns a path to the Electricity Facts Label PDF file</returns>
		public static string CreateEflDefaultProductPdf( string market, string accountType,
			int month, int year, string process )
		{
			string pdfPath = "";
			EflTemplateType eflType = EflTemplateType.OnDemand;
			string productId = GetDefaultProductId( accountType, process );
			int accountTypeID = accountType.ToUpper().Equals( CompanyAccountType.SMB.ToString() ) ? 1 : 2;

			CompanyAccountType acctType = CompanyAccountFactory.GetCompanyAccountType( accountType );

			RateUsageList rateUsages = CreateRateUsages( market, accountType, month, year );

			rateUsages = SumMcpeAndAdder( rateUsages );

			ElectricityFactsLabelList eflList = new ElectricityFactsLabelList();

			eflList.Add( CreateElectricityFactsLabel( rateUsages, 1 ) );

			pdfPath = PdfFactory.CreatePdf( ConvertEflListToDataSet( eflList, acctType, market, "", productId, 0m, eflType ), "EFH", productId, accountTypeID );

			return pdfPath;
		}

		public static DataSet GetElectricityFactsLabels( string contractNumber, EflTemplateType eflType )
		{
			string marketCode = "TX";
			string utilityCode = "";
			string productId = "";
			string productCategory = "";
			string productSubCategory = "";
			string docMgtProductId = "";
			string effectiveMonth = "";
			DateTime contractStartDate;
			DateTime dealDate;
			int month = 0;
			int year = 0;
			int term = 0;
			//int termPrev = 0;
			decimal rate = 0m;
			decimal lpFixed = 0m;
			decimal mcpe = 0m;
			decimal adder = 0m;
			string accountType = "SMB";
			string salesChannelRole = "";
			bool isAbcSalesChannel = false;

			// MCPE product category and sub category (Variable, Fixed Adder)
			ProductCategory mcpeProductCategory = new ProductCategory();
			mcpeProductCategory = ProductCategory.Variable;
			ProductSubCategory mcpeProductSubCategory = new ProductSubCategory();
			mcpeProductSubCategory = ProductSubCategory.FixedAdder;

			int isCustom = 0;

			DataSet dsFinal = new DataSet();
			CompanyAccountType acctType = new CompanyAccountType();
			ElectricityFactsLabelList eflList = new ElectricityFactsLabelList();

			DataSet ds = EflSql.GetEflContractData( contractNumber );
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					marketCode = dr["MarketCode"].ToString();
					utilityCode = dr["UtilityCode"].ToString();
					term = Convert.ToInt32( dr["Term"] );
					rate = Convert.ToDecimal( dr["Rate"] );
					accountType = dr["AccountType"].ToString();
					salesChannelRole = dr["SalesChannelRole"].ToString();
					productId = dr["ProductId"].ToString();
					productCategory = dr["ProductCategory"].ToString();
					productSubCategory = dr["ProductSubCategory"].ToString();
					dealDate = Convert.ToDateTime( dr["DealDate"] );
					contractStartDate = Convert.ToDateTime( dr["ContractStartDate"] );
					isCustom = Convert.ToInt32( dr["IsCustom"] );
					month = contractStartDate.Month;
					year = contractStartDate.Year;

					DataSet dsMonth = GeneralSql.GetMonthByNumber( month );
					if( IsValidDataSet( dsMonth ) )
						effectiveMonth = dsMonth.Tables[0].Rows[0]["MonthText"].ToString() + ", " + year.ToString();


					// if neither of these, method will return an empty dataset
					if( accountType.ToLower().Contains( "smb" ) )
						accountType = "SMB";
					if( accountType.ToLower().Contains( "res" ) )
						accountType = "RES";

					DataSet dsChannel = EflSql.GetIsAbcSalesChannel( salesChannelRole );
					if( IsValidDataSet( dsChannel ) )
						isAbcSalesChannel = Convert.ToBoolean( dsChannel.Tables[0].Rows[0][0] );

					DataSet dsProducts = EflSql.GetProducts( accountType, eflType.ToString() );
					if( IsValidDataSet( dsProducts ) )
					{
						foreach( DataRow drProd in dsProducts.Tables[0].Rows )
						{
							if( accountType.Equals( "SMB" ) )
							{
								if( term.Equals( 3 ) && drProd["ProductDescription"].ToString().Contains( "90" ) )
								{
									docMgtProductId = drProd["ProductId"].ToString();
									break;
								}
								if( !term.Equals( 3 ) && drProd["ProductDescription"].ToString().ToLower().Contains( "fixed" ) )
								{
									docMgtProductId = drProd["ProductId"].ToString();
									break;
								}
							}
							if( accountType.Equals( "RES" ) )
							{
								docMgtProductId = drProd["ProductId"].ToString();
								break;
							}
						}
					}

					// no monthly service charge for ABC channels
					if( isAbcSalesChannel )
						lpFixed = 0.00m;
					else
					{
						DataSet dsLpFixed = EflSql.GetMonthlyServiceCharges( accountType );
						if( IsValidDataSet( dsLpFixed ) )
							lpFixed = Convert.ToDecimal( dsLpFixed.Tables[0].Rows[0]["MonthlyServiceCharge"] );
					}

					acctType = CompanyAccountFactory.GetCompanyAccountType( accountType );

					// determine if product is MCPE. If so, add MCPE to rate (rate will be the adder for MCPE products)
					if( productCategory.Trim().ToLower().Equals( mcpeProductCategory.ToString().ToLower() )
						&& productSubCategory.Trim().ToLower().Equals( EnumHelper.GetEnumDescription( mcpeProductSubCategory ).ToLower() )
						&& (isCustom == 0) )
					{
						try
						{
							EflDefaultProduct product = GetEflDefaultProduct( accountType, marketCode, month, year );
							mcpe = product.Mcpe;
							adder = rate;

							rate += mcpe;
						}
						catch
						{
							string format = "MCPE not found for Contract: {0}, Account Type: {1}, Market: {2}, {3}/{4}.";
							throw new McpeNotFoundExcpetion( String.Format( format, contractNumber, accountType, marketCode, month.ToString(), year.ToString() ) );
						}
					}

					EflRequest request = new EflRequest( utilityCode, term, rate, lpFixed, accountType, productId, eflType.ToString() );

					if( eflType != EflTemplateType.Welcome )
						ValidateRequest( request );

					RateUsageList rateUsages = CreateRateUsages( utilityCode, accountType, request, mcpe, adder, effectiveMonth );

					eflList.Add( CreateElectricityFactsLabel( rateUsages, term, utilityCode, dealDate ) );

				}

				dsFinal = ConvertEflListToDataSet( eflList, acctType, marketCode, "", docMgtProductId, 0m, eflType );
			}

			// return an empty table if none exists in dataset
			if( dsFinal.Tables.Count == 0 )
				dsFinal.Tables.Add( CreateEflDataTable() );

			return dsFinal;
		}

		/// <summary>
		/// Converts an EFL list to a dataset
		/// </summary>
		/// <param name="eflList">List of ElectricityFactsLabels</param>
		/// <param name="acctType">Type of account (SMB, RES, LCI)</param>
		/// <param name="market">Identifier of market</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="productId">Identifier of product</param>
		/// <param name="lpFixed">Monthly service charge</param>
		/// <returns>Returns a dataset containing EFL data</returns>
		private static DataSet ConvertEflListToDataSet( ElectricityFactsLabelList eflList,
			CompanyAccountType acctType, string market, string utilityCode, string productId, decimal lpFixed, EflTemplateType eflType )
		{
			DataSet ds = new DataSet();
			DataTable dt = CreateEflDataTable();
			DataTable dtMain = CreateEflMainDataTable();

			ds.Tables.Add( dt );
			ds.Tables.Add( dtMain );

			// add additional tables required for the document repository webservice
			DataSet dsAdditional = CreateAdditionalTables( market, utilityCode, productId );
			foreach( DataTable dtAdd in dsAdditional.Tables )
				ds.Tables.Add( dtAdd.Copy() );


			// add EFL data to table
			foreach( ElectricityFactsLabel label in eflList )
				AddEflToDataTables( label, dt, dtMain, acctType, productId, lpFixed, eflType );

			return ds;
		}

		/// <summary>
		/// Gets all utilities associated with specified market
		/// </summary>
		/// <param name="market">Identifier of market</param>
		/// <returns>Returns a list of utilities associated with specified market</returns>
		public static EflUtilityList GetUtilitiesByMarket( string market )
		{
			EflUtilityList list = new EflUtilityList();
			DataSet ds = UtilitySql.GetUtilitiesByMarket( market );
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					EflUtility utility = new EflUtility();
					utility.FullName = dr["FullName"].ToString();
					utility.ID = Convert.ToInt32( dr["ID"] );
					utility.ShortName = dr["ShortName"].ToString();
					utility.UtilityCode = dr["UtilityCode"].ToString();
					list.Add( utility );
				}
			}
			return list;
		}

		/// <summary>
		/// Gets EFL products for specified account type
		/// </summary>
		/// <param name="accountType">Type of account (SMB, RES, LCI)</param>
		/// <returns>Returns a list of products for specified account type</returns>
		public static EflProductList GetProducts( string accountType, EflTemplateType eflType )
		{
			EflProductList list = new EflProductList();
			DataSet ds = EflSql.GetProducts( accountType, eflType.ToString() );
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					EflProduct product = new EflProduct();
					product.AccountTypeID = Convert.ToInt32( dr["AccountTypeID"] );
					product.ProductDescription = dr["ProductDescription"].ToString();
					product.ProductId = dr["ProductId"].ToString();
					list.Add( product );
				}
			}
			return list;
		}

		/// <summary>
		/// Gets monthly service charges for specified account type
		/// </summary>
		/// <param name="accountType">Type of account (SMB, RES, LCI)</param>
		/// <returns>Returns a list of monthly service charges for specified account type</returns>
		public static List<decimal> GetMonthlyServiceCharges( string accountType )
		{
			List<decimal> list = new List<decimal>();
			DataSet ds = EflSql.GetMonthlyServiceCharges( accountType );
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( Convert.ToDecimal( dr["MonthlyServiceCharge"] ) );
			}
			return list;
		}

		/// <summary>
		/// Adds th data from an Electricity Facts Label to a datatable
		/// </summary>
		/// <param name="label">ElectricityFactsLabel object</param>
		/// <param name="dt">DataTable object</param>
		/// <param name="acctType">Type of account (SMB, RES, LCI)</param>
		/// <param name="productId">Identifier of product</param>
		/// <param name="lpFixed">Monthly service charges</param>
		private static void AddEflToDataTables( ElectricityFactsLabel label, DataTable dt, DataTable dtMain,
			CompanyAccountType acctType, string productId, decimal lpFixed, EflTemplateType eflType )
		{
			int counter = 0;

			if( acctType == CompanyAccountType.SMB || acctType == CompanyAccountType.RES )
			{
				DataRow dr = dt.NewRow();
				DataRow drMain = dtMain.NewRow();

				Type typeCurrent;
				Type typeDefaultProduct = typeof( RateUsageDefaultProd );

				for( int i = 0; i < label.RateUsages.Count; i++ )
				{
					if( i == 0 )
					{
						DateTime dateRate = label.DateRate;
						string month = dateRate.Month.ToString().PadLeft( 2, Convert.ToChar( "0" ) );
						string day = dateRate.Day.ToString().PadLeft( 2, Convert.ToChar( "0" ) );
						string year = dateRate.Year.ToString().Substring( 2 );
						drMain["dtformatted"] = string.Format( "{0}{1}{2}", month, day, year );
						drMain["date"] = dateRate.ToShortDateString();
						drMain["Term"] = label.Term;
						dtMain.Rows.Add( drMain );
					}

					typeCurrent = label.RateUsages[i].GetType();

					dr["ProductID"] = productId;
					dr["Product_id"] = productId;
					dr["date"] = label.DateRate.ToShortDateString();
					dr["UtilityShortName"] = label.RateUsages[i].UtilityShortName;
					dr["ServiceCharge"] = Decimal.Round( lpFixed, 2 ).ToString( "###0.00" );
					dr["Term"] = label.Term;

					if( eflType == EflTemplateType.OnDemand || eflType == EflTemplateType.Welcome )
						dr["Rate"] = Decimal.Round( label.RateUsages[i].Rate * 100.0m, 1 ).ToString( "###0.0" ); // convert from dollars to cents
					else
						dr["Rate"] = Decimal.Round( label.RateUsages[i].Rate, 5 ).ToString( "###0.00000" );

					//dr["MCPE"] = Decimal.Round((label.RateUsages[i].Adder + label.RateUsages[i].Mcpe) * 100.0m, 1).ToString("###0.0"); // convert from dollars to cents
					// ticket 20157.  The rate below was incorrect because it was adding the "adder" to the MCPE value.
					// But the adder was already included earlier in the code.
					dr["MCPE"] = Decimal.Round( (label.RateUsages[i].Mcpe) * 100.0m, 1 ).ToString( "###0.0" ); // convert from dollars to cents
					dr["EffectiveMonth"] = label.RateUsages[i].EffectiveMonth;

					switch( counter )
					{
						case 0:
							{
								if( eflType == EflTemplateType.OnDemand || eflType == EflTemplateType.Welcome )
									dr["RateUsage1"] = Decimal.Round( label.RateUsages[i].RateUsageComputed * 100.0m, 1 ).ToString( "###0.0" ); // convert from dollars to cents
								else
									dr["RateUsage1"] = Decimal.Round( label.RateUsages[i].RateUsageComputed, 5 ).ToString( "###0.00000" );
								break;
							}
						case 1:
							{
								if( eflType == EflTemplateType.OnDemand || eflType == EflTemplateType.Welcome )
									dr["RateUsage2"] = Decimal.Round( label.RateUsages[i].RateUsageComputed * 100.0m, 1 ).ToString( "###0.0" ); // convert from dollars to cents
								else
									dr["RateUsage2"] = Decimal.Round( label.RateUsages[i].RateUsageComputed, 5 ).ToString( "###0.00000" );
								break;
							}
						case 2:
							{
								if( eflType == EflTemplateType.OnDemand || eflType == EflTemplateType.Welcome )
									dr["RateUsage3"] = Decimal.Round( label.RateUsages[i].RateUsageComputed * 100.0m, 1 ).ToString( "###0.0" ); // convert from dollars to cents
								else
									dr["RateUsage3"] = Decimal.Round( label.RateUsages[i].RateUsageComputed, 5 ).ToString( "###0.00000" );
								break;
							}
					}
					counter++;

					// add row, reset counter, and create a new row for additional records
					if( counter == 3 )
					{
						dt.Rows.Add( dr );
						dr = dt.NewRow();
						counter = 0;
					}
				}
			}
		}

		/// <summary>
		/// Creates an Electricity Facts Label object
		/// </summary>
		/// <param name="request">Request object</param>
		/// <param name="rateUsages">List of rate usages</param>
		/// <param name="term">Term (in months)</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <returns>Returns an Electricity Facts Label object</returns>
		private static ElectricityFactsLabel CreateElectricityFactsLabel(
			RateUsageList rateUsages, int term, string utilityCode, DateTime date )
		{
			string utilityShortName = "";

			DataSet ds = UtilitySql.GetUtility( utilityCode );
			if( IsValidDataSet( ds ) )
				utilityShortName = ds.Tables[0].Rows[0]["ShortName"].ToString();

			ElectricityFactsLabel label = new ElectricityFactsLabel( date, rateUsages, term, utilityCode, utilityShortName );

			return label;
		}

		/// <summary>
		/// Creates an Electricity Facts Label object
		/// </summary>
		/// <param name="request">Request object</param>
		/// <param name="rateUsages">List of rate usages</param>
		/// <param name="term">Term (in months)</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <returns>Returns an Electricity Facts Label object</returns>
		private static ElectricityFactsLabel CreateElectricityFactsLabel(
			RateUsageList rateUsages, int term )
		{
			DateTime today = DateTime.Today;
			ElectricityFactsLabel label = new ElectricityFactsLabel( today, rateUsages, term, "", "" );

			return label;
		}

		/// <summary>
		/// Creates an Electricity Facts Label object
		/// </summary>
		/// <param name="request">Request object</param>
		/// <param name="rateUsages">List of rate usages</param>
		/// <param name="term">Term (in months)</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="effectiveMonth">Month of default product</param>
		/// <param name="mcpe">MCPE</param>
		/// <returns>Returns an Electricity Facts Label object</returns>
		private static ElectricityFactsLabel CreateElectricityFactsLabel(
			RateUsageList rateUsages, int term, string effectiveMonth, decimal mcpe )
		{
			DateTime today = DateTime.Today;
			ElectricityFactsLabel label = new ElectricityFactsLabel( today, rateUsages, term, "", "" );

			return label;
		}

		/// <summary>
		/// Creates a list of rate usages
		/// </summary>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="accountType">Type of account (SMB, RES, LCI)</param>
		/// <param name="request">Request object</param>
		/// <returns>Returns a list of rate usages</returns>
		private static RateUsageList CreateRateUsages( string utilityCode, string accountType, EflRequest request,
			decimal mcpe, decimal adder, string effectiveMonth )
		{
			decimal lpFixed = request.LpFixed;
			decimal tdspFixed = 0m;
			decimal tdspKwh = 0m;
			decimal tdspFixedAbove = 0m;
			decimal tdspKwhAbove = 0m;
			decimal tdspKw = 0m;
			decimal tdspModifier = 1m;
			string utilityShortName = "";
			int counter = 0;

			utilityCode = utilityCode.Trim();

			RateUsageList list = new RateUsageList();

			// get utility short name
			DataSet ds = UtilitySql.GetUtility( utilityCode );
			if( IsValidDataSet( ds ) )
				utilityShortName = ds.Tables[0].Rows[0]["ShortName"].ToString();
			else // if short name not found, use utility code
				utilityShortName = utilityCode;

			// get charges for utility and account type
			ds = EflSql.GetEflCharges( utilityCode, accountType );
			if( IsValidDataSet( ds ) )
			{
				//lpFixed = Convert.ToDecimal( ds.Tables[0].Rows[0]["LpFixed"] );
				tdspFixed = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspFixed"] );
				tdspKwh = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKwh"] );
				tdspFixedAbove = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspFixedAbove"] );
				tdspKwhAbove = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKwhAbove"] );
				tdspKw = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKw"] );
			}
			else
				throw new EflChargesNotFoundException( "Charges not found for utility " + utilityCode + " account type " + accountType + "." );

			// get monthly usages for specified account type, building rate usage objects for each usage
			ds = EflSql.GetAverageMonthlyUsages( accountType );

			// get EFL modifiers
			EflModifier modifier = GetEflModifier( utilityCode );

			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					switch( counter )
					{
						case 0:
							{
								tdspModifier = modifier.RateUsage1;
								break;
							}
						case 1:
							{
								tdspModifier = modifier.RateUsage2;
								break;
							}
						case 2:
							{
								tdspModifier = modifier.RateUsage3;
								break;
							}
					}

					// build rate usage list
					if( accountType.ToUpper().Equals( CompanyAccountType.SMB.ToString() ) )
					{
						switch( utilityCode )
						{
							case "TXNMP":
								{
									RateUsageSpecial1 rateUsageSpecial = new RateUsageSpecial1( request.Rate,
										lpFixed, tdspFixedAbove, tdspKwhAbove, tdspKw, tdspModifier,
										Convert.ToInt32( dr["AverageMonthlyUsage"] ), utilityShortName, mcpe, adder, effectiveMonth );
									list.Add( rateUsageSpecial );
									break;
								}
							default:
								{
									// use standard rate usage for rate usage 1 only
									if( counter == 0 )
									{
										RateUsageStandard rateUsageStandard = new RateUsageStandard( request.Rate,
											lpFixed, tdspFixed, tdspKwh,
											Convert.ToInt32( dr["AverageMonthlyUsage"] ), utilityShortName, mcpe, adder, effectiveMonth );
										list.Add( rateUsageStandard );
									}
									else
									{
										RateUsageSpecial1 rateUsageSpecial = new RateUsageSpecial1( request.Rate,
											lpFixed, tdspFixedAbove, tdspKwhAbove, tdspKw, tdspModifier,
											Convert.ToInt32( dr["AverageMonthlyUsage"] ), utilityShortName, mcpe, adder, effectiveMonth );
										list.Add( rateUsageSpecial );
									}
									break;
								}
						}
					}
					if( accountType.ToUpper().Equals( CompanyAccountType.RES.ToString().Substring( 0, 3 ) ) )
					{
						RateUsageStandard rateUsage = new RateUsageStandard( request.Rate, lpFixed,
							tdspFixed, tdspKwh, Convert.ToInt32( dr["AverageMonthlyUsage"] ), utilityShortName, mcpe, adder, effectiveMonth );
						list.Add( rateUsage );
					}

					counter++;
				}
			}
			else
				throw new EflAvgMonthluUsageNotFoundException( "Average monthly usages not found for account type " + accountType + "." );



			return list;
		}

		/// <summary>
		/// Creates a rate usage list for all utilities in specified market and account type
		/// </summary>
		/// <param name="marketCode">Identifier of market</param>
		/// <param name="accountType">Account type</param>
		/// <param name="month">Numeric month value</param>
		/// <param name="year">Year</param>
		/// <returns>Returns a rate usage list for all utilities in specified market and account type.</returns>
		private static RateUsageList CreateRateUsages( string marketCode,
			string accountType, int month, int year )
		{
			DataSet ds;
			string utilityCode;
			string utilityShortName;
			string effectiveMonth = "";
			decimal mcpe = 0m;
			decimal adder = 0m;
			decimal lpFixed = 0m;
			decimal tdspFixed = 0m;
			decimal tdspKwh = 0m;
			decimal tdspFixedAbove = 0m;
			decimal tdspKwhAbove = 0m;
			decimal tdspKw = 0m;
			decimal tdspModifier = 1m;
			int counter = 0;

			RateUsageList list = new RateUsageList();

			// get MCPE, Adder and Month data
			EflDefaultProduct product = GetEflDefaultProduct( accountType, marketCode, month, year );
			mcpe = product.Mcpe;
			adder = product.Adder;

			//DataSet ds = GeneralSql.GetMonthByNumber( month );
			//if( IsValidDataSet( ds ) )
			//    effectiveMonth = ds.Tables[0].Rows[0]["MonthText"].ToString() + ", " + year.ToString();

			effectiveMonth = month.ToString().PadLeft( 2, Convert.ToChar( "0" ) ) + "/" + year.ToString();

			DataSet dsUtilities = UtilitySql.GetUtilitiesByMarket( marketCode, "AEPCE,AEPNO,CTPEN,ONCOR,TXNMP,ONCOR-SESCO" );
			if( IsValidDataSet( dsUtilities ) )
			{
				foreach( DataRow drUtilities in dsUtilities.Tables[0].Rows )
				{
					utilityCode = drUtilities["UtilityCode"].ToString();
					utilityShortName = drUtilities["ShortName"].ToString();

					// get charges for utility and account type
					ds = EflSql.GetEflCharges( utilityCode, accountType );
					if( IsValidDataSet( ds ) )
					{
						lpFixed = Convert.ToDecimal( ds.Tables[0].Rows[0]["LpFixed"] );
						tdspFixed = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspFixed"] );
						tdspKwh = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKwh"] );
						tdspFixedAbove = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspFixedAbove"] );
						tdspKwhAbove = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKwhAbove"] );
						tdspKw = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKw"] );
					}
					else
						throw new EflChargesNotFoundException( "Charges not found for utility " + utilityCode + " account type " + accountType + "." );

					// get monthly usages for specified account type, building rate usage objects for each usage
					ds = EflSql.GetAverageMonthlyUsages( accountType );

					// get EFL modifiers
					EflModifier modifier = GetEflModifier( utilityCode );

					if( IsValidDataSet( ds ) )
					{
						counter = 0;

						foreach( DataRow dr in ds.Tables[0].Rows )
						{
							switch( counter )
							{
								case 0:
									{
										tdspModifier = modifier.RateUsage1;
										break;
									}
								case 1:
									{
										tdspModifier = modifier.RateUsage2;
										break;
									}
								case 2:
									{
										tdspModifier = modifier.RateUsage3;
										break;
									}
							}

							// build rate usage list
							if( accountType.ToUpper() == CompanyAccountType.SMB.ToString() )
							{
								switch( utilityCode )
								{
									case "TXNMP":
										{
											RateUsageDefaultProd rateUsage = new RateUsageDefaultProd( utilityShortName, lpFixed, mcpe,
												adder, tdspFixedAbove, tdspKwhAbove, tdspKw, tdspModifier, Convert.ToInt32( dr["AverageMonthlyUsage"] ), effectiveMonth );
											list.Add( rateUsage );
											break;
										}
									default:
										{
											if( counter == 0 )
											{
												// tdspKw = 0 per requirement IT001-FR03-5-3

												RateUsageDefaultProd rateUsage = new RateUsageDefaultProd( utilityShortName, lpFixed, mcpe,
													adder, tdspFixed, tdspKwh, 0, tdspModifier, Convert.ToInt32( dr["AverageMonthlyUsage"] ), effectiveMonth );
												list.Add( rateUsage );
											}
											else
											{
												RateUsageDefaultProd rateUsage = new RateUsageDefaultProd( utilityShortName, lpFixed, mcpe,
													adder, tdspFixedAbove, tdspKwhAbove, tdspKw, tdspModifier, Convert.ToInt32( dr["AverageMonthlyUsage"] ), effectiveMonth );
												list.Add( rateUsage );
											}
											break;
										}
								}
							}
							if( accountType.ToUpper() == CompanyAccountType.RES.ToString().Substring( 0, 3 ) )
							{
								RateUsageDefaultProd rateUsage = new RateUsageDefaultProd( utilityShortName, lpFixed, mcpe,
									adder, tdspFixed, tdspKwh, tdspKw, tdspModifier, Convert.ToInt32( dr["AverageMonthlyUsage"] ), effectiveMonth );
								list.Add( rateUsage );
							}

							counter++;
						}
					}
					else
						throw new EflAvgMonthluUsageNotFoundException( "Average monthly usages not found for account type " + accountType + "." );
				}
			}
			else
				throw new UtilityNotFoundException( "No utilities found for market " + marketCode + "." );

			return list;
		}

		/// <summary>
		/// Gets the default product data for specified market, month, and year
		/// </summary>
		/// <param name="marketCode">Identifier of market</param>
		/// <param name="month">Numeric month value</param>
		/// <param name="year">Four digit year</param>
		/// <returns></returns>
		public static EflDefaultProduct GetEflDefaultProduct( string accountType, string marketCode, int month, int year )
		{
			EflDefaultProduct product = new EflDefaultProduct();

			DataSet ds = EflSql.GetDefaultProductData( accountType, marketCode, month, year );

			if( IsValidDataSet( ds ) )
			{
				product = CreateEflDefaultProduct( Convert.ToInt32( ds.Tables[0].Rows[0]["ID"] ),
					ds.Tables[0].Rows[0]["MarketCode"].ToString(),
					Convert.ToInt32( ds.Tables[0].Rows[0]["Month"] ),
					Convert.ToInt32( ds.Tables[0].Rows[0]["Year"] ),
					Convert.ToDecimal( ds.Tables[0].Rows[0]["Mcpe"] ),
					Convert.ToDecimal( ds.Tables[0].Rows[0]["Adder"] ),
					ds.Tables[0].Rows[0]["Username"].ToString(),
					Convert.ToDateTime( ds.Tables[0].Rows[0]["DateCreated"] ) );
			}
			else
				throw new EflDefaultProductNotFoundException( "No data found for specified criteria." );

			return product;
		}

		/// <summary>
		/// Inserts a default product record
		/// </summary>
		/// <param name="marketCode">Identifier of market</param>
		/// <param name="month">Numeric month value</param>
		/// <param name="year">Four digit year</param>
		/// <param name="mcpe">MCPE</param>
		/// <param name="adder">Adder</param>
		/// <param name="username">Username</param>
		/// <param name="dateCreated">Date created</param>
		public static void InsertEflDefaultProduct( string accountType, string marketCode, int month, int year,
			decimal mcpe, decimal adder, string username, DateTime dateCreated )
		{
			EflSql.InsertDefaultProductData( accountType, marketCode, month, year, mcpe, adder, username, dateCreated );
		}

		/// <summary>
		/// Gets TDSP charges for utility and account type
		/// </summary>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="accountType">Account type</param>
		/// <returns>Returns TDSP charges for utility and account type.</returns>
		public static EflCharges GetEflCharges( string utilityCode, string accountType )
		{
			EflCharges charges = new EflCharges();
			DataSet ds = EflSql.GetEflCharges( utilityCode, accountType );
			if( IsValidDataSet( ds ) )
			{
				charges.AccountType = accountType;
				charges.LpFixed = Convert.ToDecimal( ds.Tables[0].Rows[0]["LpFixed"] );
				charges.TdspFixed = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspFixed"] );
				charges.TdspKwh = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKwh"] );
				charges.TdspFixedAbove = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspFixedAbove"] );
				charges.TdspKwhAbove = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKwhAbove"] );
				charges.TdspKw = Convert.ToDecimal( ds.Tables[0].Rows[0]["TdspKw"] );
				charges.UtilityCode = utilityCode;
			}
			else
				throw new EflChargesNotFoundException( "TDSP charges not found for specified criteria." );

			return charges;
		}

		/// <summary>
		/// Inserts/updates Efl charges for specified utility and account type
		/// </summary>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="accountType">Account type</param>
		/// <param name="tdspFixed">TDSP fixed charges</param>
		/// <param name="tdspUsage">TDSP per kWh charges</param>
		public static void InsertEflCharges( string utilityCode, string accountType, decimal tdspFixed,
			decimal tdspKwh, decimal tdspFixedAbove, decimal tdspKwhAbove, decimal tdspKw )
		{
			EflSql.InsertEflCharges( utilityCode, accountType, tdspFixed, tdspKwh, tdspFixedAbove, tdspKwhAbove, tdspKw );
		}

		/// <summary>
		/// Gets current and next month's numeric values with associated text
		/// </summary>
		/// <returns>Returns current and next month's numeric values with associated text.</returns>
		public static MonthList GetCurrentAndNextMonth()
		{
			MonthList list = new MonthList();

			for( int i = 0; i < 2; i++ )
			{
				Month month = new Month();

				// if month is greater than 12, then month is next year, set to 1.
				month.MonthNumber = (DateTime.Today.Month + i) > 12 ? 1 : (DateTime.Today.Month + i);

				if( i == 0 )
					month.MonthText = "Current Month";
				else
					month.MonthText = "Next Month";

				list.Add( month );
			}
			return list;
		}

		private static EflModifier GetEflModifier( string utilityCode )
		{
			decimal rateUsage1 = 1m;
			decimal rateUsage2 = 1m;
			decimal rateUsage3 = 1m;

			DataSet ds = EflSql.GetEflModifiers( utilityCode );
			if( IsValidDataSet( ds ) )
			{
				rateUsage1 = Convert.ToDecimal( ds.Tables[0].Rows[0]["RateUsage1"] );
				rateUsage2 = Convert.ToDecimal( ds.Tables[0].Rows[0]["RateUsage2"] );
				rateUsage3 = Convert.ToDecimal( ds.Tables[0].Rows[0]["RateUsage3"] );
			}

			return new EflModifier( rateUsage1, rateUsage2, rateUsage3 );
		}

		/// <summary>
		/// Creates an EflDefaultProduct object with no record ID
		/// </summary>
		/// <param name="marketCode">Identifier of market</param>
		/// <param name="month">Numeric month value</param>
		/// <param name="year">Four digit year</param>
		/// <param name="mcpe">MCPE</param>
		/// <param name="adder">Adder</param>
		/// <param name="username">Username</param>
		/// <param name="dateCreated">Date created</param>
		/// <returns>Returns an EflDefaultProduct object</returns>
		private static EflDefaultProduct CreateEflDefaultProduct( string marketCode, int month, int year,
			decimal mcpe, decimal adder, string username, DateTime dateCreated )
		{
			return new EflDefaultProduct( marketCode, month, year, mcpe, adder, username, dateCreated );
		}

		/// <summary>
		/// Creates an EflDefaultProduct object with a record ID
		/// </summary>
		/// <param name="id">Identifier of record</param>/// 
		/// <param name="marketCode">Identifier of market</param>
		/// <param name="month">Numeric month value</param>
		/// <param name="year">Four digit year</param>
		/// <param name="mcpe">MCPE</param>
		/// <param name="adder">Adder</param>
		/// <param name="username">Username</param>
		/// <param name="dateCreated">Date created</param>
		/// <returns>Returns an EflDefaultProduct object</returns>
		private static EflDefaultProduct CreateEflDefaultProduct( int id, string marketCode, int month, int year,
			decimal mcpe, decimal adder, string username, DateTime dateCreated )
		{
			return new EflDefaultProduct( id, marketCode, month, year, mcpe, adder, username, dateCreated );
		}

		/// <summary>
		/// Gets months with numerical values
		/// </summary>
		/// <returns>Returns months with numerical values</returns>
		public static MonthDictionary GetMonths()
		{
			MonthDictionary dict = new MonthDictionary();
			DataSet ds = GeneralSql.GetMonths();
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					Month month = new Month();
					month.MonthNumber = Convert.ToInt32( dr["MonthNumber"] );
					month.MonthText = dr["MonthText"].ToString();
					dict.Add( month.MonthNumber, month );
				}
			}
			return dict;
		}

		/// <summary>
		/// Gets four digit year values
		/// </summary>
		/// <returns>Returns four digit year values</returns>
		public static List<int> GetYears()
		{
			List<int> list = new List<int>();
			DataSet ds = GeneralSql.GetYears();
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
					list.Add( Convert.ToInt32( dr["YearNumber"] ) );
			}

			return list;
		}

		/// <summary>
		/// Gets the default product id for specified account type
		/// </summary>
		/// <param name="accountType">Account type</param>
		/// <returns>Returns the default product id for specified account type.</returns>
		private static string GetDefaultProductId( string accountType, string process )
		{
			string productId = "";


			DataSet ds = EflSql.GetProducts( accountType, process );
			if( IsValidDataSet( ds ) )
			{
				foreach( DataRow dr in ds.Tables[0].Rows )
				{
					if( dr["ProductDescription"].ToString().ToLower().Contains( "default product" ) )
					{
						productId = dr["ProductId"].ToString();
						break;
					}
				}
			}

			return productId;
		}

		/// <summary>
		/// Modifies MCPE to be the sum of MCPE and Adder
		/// </summary>
		/// <param name="rateUsages">RateUsage list</param>
		/// <returns>Returns a RateUsage list that has the MCPE property of each RateUsage being the sum of MCPE and Adder</returns>
		private static RateUsageList SumMcpeAndAdder( RateUsageList rateUsages )
		{
			foreach( RateUsage rateUsage in rateUsages )
				rateUsage.Mcpe = rateUsage.Mcpe + rateUsage.Adder;

			return rateUsages;
		}

		/// <summary>
		/// Creates a datatable with the neccessary columns for holding EFL data
		/// </summary>
		/// <returns>Returns a datatable with the neccessary columns for holding EFL datareturns>
		private static DataTable CreateEflDataTable()
		{
			DataTable dt = new DataTable( "EFL" );

			dt.Columns.Add( new DataColumn( "ProductID", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "Product_id", typeof( string ) ) );

			dt.Columns.Add( new DataColumn( "date", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "UtilityShortName", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "Rate", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "RateUsage1", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "RateUsage2", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "RateUsage3", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "ServiceCharge", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "Term", typeof( int ) ) );
			dt.Columns.Add( new DataColumn( "EffectiveMonth", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "MCPE", typeof( string ) ) );


			return dt;
		}

		private static DataTable CreateEflMainDataTable()
		{
			DataTable dt = new DataTable( "EFLMain" );
			dt.Columns.Add( new DataColumn( "dtformatted", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "date", typeof( string ) ) );
			dt.Columns.Add( new DataColumn( "Term", typeof( int ) ) );
			return dt;
		}



		/// <summary>
		/// Creates additional tables needed for document repository web service to function properly
		/// </summary>
		/// <param name="market">Identifier of market</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="productId">Identifier of product</param>
		/// <returns>Returns a dataset containing additional tables needed for document repository web service to function properly</returns>
		private static DataSet CreateAdditionalTables( string market, string utilityCode, string productId )
		{
			DataSet ds = new DataSet();
			DataSet dsAdd = new DataSet();
			DataTable dt;
			DataRow dr;
			DataTable dtProduct = new DataTable( "Product" );
			ds.Tables.Add( dtProduct );
			dtProduct.Columns.Add( new DataColumn( "Market" ) );
			dtProduct.Columns.Add( new DataColumn( "product_id" ) );
			dtProduct.Columns.Add( new DataColumn( "utility_id" ) );
			dr = dtProduct.NewRow();
			dr["Market"] = market;
			dr["product_id"] = productId;
			dr["utility_id"] = utilityCode;
			dtProduct.Rows.Add( dr );

			DataTable dtUtility = new DataTable( "Utility" );
			ds.Tables.Add( dtUtility );
			dtUtility.Columns.Add( new DataColumn( "utility_id" ) );
			dtUtility.Columns.Add( new DataColumn( "retail_mkt_id" ) );
			dr = dtUtility.NewRow();
			dr["utility_id"] = utilityCode;
			dr["retail_mkt_id"] = market;
			dtUtility.Rows.Add( dr );

			DataTable dtMarket = new DataTable( "Market" );
			ds.Tables.Add( dtMarket );
			dtMarket.Columns.Add( new DataColumn( "retail_mkt_id" ) );
			dr = dtMarket.NewRow();
			dr["retail_mkt_id"] = market;
			dtMarket.Rows.Add( dr );

			//DataTable dtContractRate = new DataTable( "ContractRate" );
			//ds.Tables.Add( dtContractRate );
			//dtContractRate.Columns.Add( new DataColumn( "product_id" ) );
			//dr = dtContractRate.NewRow();
			//dr["product_id"] = productId;
			//dtContractRate.Rows.Add( dr );

			dsAdd = EflSql.GetDocumentTemplateMultiRateTable( "NONE" );
			dt = dsAdd.Tables[0].Copy();
			dt.TableName = "Account";
			dr = dt.NewRow();
			dr["ProductID"] = productId;
			dt.Rows.Add( dr );
			ds.Tables.Add( dt );

			dsAdd = EflSql.GetDocumentTemplateAddressTable( "NONE" );
			dt = dsAdd.Tables[0].Copy();
			dt.TableName = "Address";
			ds.Tables.Add( dt );

			dsAdd = EflSql.GetDocumentTemplateContractTable( "NONE" );
			dt = dsAdd.Tables[0].Copy();
			dt.TableName = "ContractRate";
			ds.Tables.Add( dt );

			//foreach( DataTable dtAdd in dsAdditional.Tables )
			//    ds.Tables.Add( dtAdd.Copy() );

			return ds;
		}

		/// <summary>
		/// Validates a request objetc's data
		/// </summary>
		/// <param name="request">Request objetc containing data for producing EFL label</param>
		private static void ValidateRequest( EflRequest request )
		{
			ValidEflInputRule rule = new ValidEflInputRule( request );

			if( !rule.Validate() )
			{
				string errors = "<b>" + rule.Exception.Message + "</b><br/>";

				foreach( Exception ex in rule.Exception.DependentExceptions )
					errors += ex.Message + "<br/>";

				throw new InvalidEflInputException( errors );
			}
		}

		/// <summary>
		/// Verifies that the dataset contains at least one table and at least one record
		/// </summary>
		/// <param name="ds">DataSet object</param>
		/// <returns>Returns a true or false indicating whether the dataset contains at least one table and at least one record</returns>
		private static bool IsValidDataSet( DataSet ds )
		{
			return (ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0);
		}
	}
}
