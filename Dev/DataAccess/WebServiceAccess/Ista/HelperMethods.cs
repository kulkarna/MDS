using System;
using System.Data;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{
	/// <summary>
	/// Generic methods to be used for ISTA
	/// </summary>
	public static class HelperMethods
	{
		/// <summary>
		/// Builds ISTA EnrollCustomer object for use by transaction methods
		/// </summary>
		/// <param name="accountData"></param>
		/// <param name="startDate"></param>
		/// <param name="enrollmentType"></param>
		/// <returns></returns>
		public static IstaEnrollmentService.EnrollCustomer BuildCustomer( DataRow accountData, DateTime startDate, string enrollmentType )
		{
			if( startDate == Convert.ToDateTime( "12:00 AM" ) )
			{
				startDate = DateTime.Now;
			}

			//build customer object
			IstaEnrollmentService.EnrollCustomer istaCustomer = new IstaEnrollmentService.EnrollCustomer();
			istaCustomer.BillingAddress1 = accountData["billingaddress1"].ToString();
			istaCustomer.BillingAddress2 = accountData["billingaddress2"].ToString();
			istaCustomer.BillingCity = accountData["billingcity"].ToString();
			istaCustomer.BillingContact = accountData["BillingContact"].ToString();
			istaCustomer.BillingEmail = accountData["contactemail"].ToString();
			istaCustomer.BillingPhone = accountData["contactPhone"].ToString();
			istaCustomer.BillingState = accountData["billingstate"].ToString();
			istaCustomer.BillingType = GetBillingType( accountData["billing_type"].ToString() );
			istaCustomer.BillingZip = accountData["billingzip"].ToString();
			istaCustomer.CustomerAccountNumber = null;
			istaCustomer.CustomerGroup = accountData["CustomerGroup"].ToString();
			istaCustomer.CustomerName = accountData["CustomerName"].ToString();
			istaCustomer.CustomerType = (IstaEnrollmentService.LibertyCustomerTypeOptions) System.Enum.Parse( typeof( IstaEnrollmentService.LibertyCustomerTypeOptions ), accountData["customerType"].ToString(), true );
            istaCustomer.ApplyLateFees = Convert.ToBoolean(Convert.ToInt16(accountData["ApplyLateFees"].ToString()));
			//istaCustomer.ApplyLateFees = true;
			//istaCustomer.LateFeeRate = (decimal)0.05;
			//SR1-2966641
			//istaCustomer.LateFeeGracePeriod = 3;
			istaCustomer.LateFeeGracePeriod = Convert.ToInt32( accountData["GracePeriod"].ToString() );
			istaCustomer.ARTerms = Convert.ToInt32( accountData["ARTerms"] );

			// SD 22422 Begin
			// Determine if the market is Texas and set the late fee to 0.05
			if( accountData["MarketCode"].ToString().ToUpper() == "TX" )
			{
				istaCustomer.LateFeeRate = (decimal) 0.05;
			}
			else
			{
				istaCustomer.LateFeeRate = (decimal) 0.015;
			}
			// SD 22422 End

			istaCustomer.DBA = null;
			istaCustomer.FederalTaxId = null;
			istaCustomer.DigitalSignature = null;
			istaCustomer.FirstName = accountData["FirstName"].ToString();
			istaCustomer.IsTaxable = bool.Parse( accountData["taxable"].ToString() );
			istaCustomer.LastName = accountData["LastName"].ToString();
			istaCustomer.MiddleName = accountData["middlename"].ToString();
			istaCustomer.ESPDuns = accountData["LPC_Duns"].ToString();
			istaCustomer.TDSPDuns = accountData["utility_duns"].ToString();
			istaCustomer.ContractStartDate = (DateTime) accountData["ContractStartDate"];
			istaCustomer.ContractEndDate = (DateTime) accountData["ContractEndDate"];

			//if (accountData["LPC_Duns"].ToString().ToUpper() == "YES")// || accountData["MarketCode"].ToString().ToUpper() != "IL")
			istaCustomer.PORFlag = Convert.ToBoolean( accountData["por_option"] );

			if( enrollmentType == "OffCycleNoPostcard" )
				istaCustomer.NotificationWaiver = false;
			else
				istaCustomer.NotificationWaiver = true;

			istaCustomer.PrintLayout = (IstaEnrollmentService.PrintLayoutOptions) System.Enum.Parse( typeof( IstaEnrollmentService.PrintLayoutOptions ), accountData["printlayout"].ToString() );
			istaCustomer.Salutation = accountData["salutation"].ToString();

			if( accountData["servicestate"].ToString().Equals( "TX", StringComparison.CurrentCultureIgnoreCase ) )
			{
				istaCustomer.SubmitHURequest = true;
			}
			else
			{
				istaCustomer.SubmitHURequest = false;
			}

			//build customer premise (service location) object
			IstaEnrollmentService.EnrollPremise custPremise = new IstaEnrollmentService.EnrollPremise();
			custPremise.Address1 = accountData["servicestreet"].ToString();
			custPremise.Address2 = accountData["servicesuite"].ToString();
			custPremise.City = accountData["servicecity"].ToString();
			
            /////MTJ-68730- Changes
            //custPremise.NameKey = accountData["NameKey"].ToString();
            if (accountData["NameKey"] != null )
                custPremise.NameKey = accountData["NameKey"].ToString().ToUpper();
            else
                custPremise.NameKey = null;
           
			custPremise.EnrollmentType = GetIstaEnrollmentType( enrollmentType );

			if( enrollmentType != "OnCycle" )
				custPremise.SpecialReadDate = startDate;

			custPremise.EsiId = accountData["account_number"].ToString();
			if( accountData["ista_zone_id"].ToString() != "" )
			{
				custPremise.LBMPID = Convert.ToInt32( accountData["ista_zone_id"] );
			}
			else
			{
				custPremise.LBMPID = null;
			}

			custPremise.MeterNumber = accountData["Meter"].ToString();
			custPremise.State = accountData["servicestate"].ToString();
			decimal Tax_State = (decimal) accountData["Tax_State"];
			decimal Tax_County = (decimal) accountData["Tax_County"];
			decimal Tax_City = (decimal) accountData["Tax_City"];
			decimal Tax_Special = (decimal) accountData["Tax_Special"];
			decimal Tax_PUC = (decimal) accountData["Tax_PUC"];
			decimal Tax_GRT = (decimal) accountData["Tax_GRT"];
			decimal Tax_Franchise = (decimal) accountData["Tax_Franchise"];

			custPremise.TaxAssessmentList = ServiceHelper.GetIstaTaxAssessmentList( (int) accountData["taxcode"] );
			custPremise.EnrollPremiseTaxPercentageList = GetEnrollPremiseTaxPercentageList( Tax_State, Tax_County, Tax_City, Tax_Special, Tax_PUC, Tax_GRT, Tax_Franchise, (int) accountData["taxcode"] );

			custPremise.BillingAccountNumber = accountData["BillingAccountNumber"].ToString();
			custPremise.Zip = accountData["servicezip"].ToString();
			//New California fields have been hardcoded for now.  2010-04-07
			IstaEnrollmentService.EnrollCustomerPremiseMeterServiceProvider MeterProvider = new IstaEnrollmentService.EnrollCustomerPremiseMeterServiceProvider();
			MeterProvider.OwnerDUNS = accountData["MeterOwner"].ToString();
			MeterProvider.InstallerDUNS = accountData["MeterInstaller"].ToString();
			MeterProvider.ReaderDUNS = accountData["MeterReader"].ToString();
			MeterProvider.MaintenanceProviderDUNS = accountData["MeterServiceProvider"].ToString();
			MeterProvider.DataManagementAgentDUNS = accountData["MeterDataMgmtAgent"].ToString();
			//The duns value for BP is 625275755
			MeterProvider.SchedulingCoordinatorDUNS = accountData["SchedulingCoordinator"].ToString();
			MeterProvider.UsageCode = IstaEnrollmentService.UsageCodes.UNK;
			MeterProvider.PackageOption = IstaEnrollmentService.PackageOptions.BASIC;
			custPremise.MeterServiceProvider = MeterProvider;
			//End California fields.

			//'build product object
			IstaEnrollmentService.EnrollRate product = new IstaEnrollmentService.EnrollRate();
			product.PlanType = GetPlanType( accountData["plantype"] );
			product.LDCRateCode = accountData["ratecode"].ToString();
			int VariableTypeID = Convert.ToInt16( accountData["VariableTypeID"] );

			product.EnrollRateDetailList = GetISTARateList( accountData["plantype"].ToString(), Convert.ToDateTime( accountData["rateEffectiveDate"] ), Convert.ToDateTime( accountData["rateEndDate"] ), Convert.ToDecimal( accountData["rate"] ), accountData["ista_class_id"].ToString(), Convert.ToDecimal( accountData["MeterCharge"] ), VariableTypeID );

			//'build default product object
			//TODO: default product details are hardcoded for now.
			IstaEnrollmentService.EnrollDefaultRate defaultProduct = new IstaEnrollmentService.EnrollDefaultRate();

			if( accountData["defaultplantype"].ToString() != "" )
				defaultProduct.PlanType = GetPlanType( accountData["defaultplantype"] );

			defaultProduct.LDCRateCode = accountData["defaultratecode"].ToString();
			defaultProduct.SwitchDate = ((DateTime) accountData["rateEndDate"]).AddDays( 1 );
			//use the enddate for the rate as the startdate for the fallback/default product
			//defaultProduct.EnrollRateDetailList = New EnrollRateDetail() {defaultRateDetail}
			defaultProduct.EnrollRateDetailList = GetISTARateList( accountData["defaultplantype"].ToString(), Convert.ToDateTime( accountData["rateEndDate"] ), Convert.ToDateTime( accountData["rateEndDate"] ).AddYears( 1 ), Convert.ToDecimal( accountData["defaultrate"] ), accountData["ista_class_id"].ToString(), Convert.ToDecimal( accountData["MeterCharge"] ), VariableTypeID );

			istaCustomer.EnrollRate = product;
			istaCustomer.EnrollDefaultRate = defaultProduct;
			istaCustomer.EnrollPremise = custPremise;
            istaCustomer.CreditInsuranceFlag = accountData["IsCreditInsured"] == System.DBNull.Value ? false : Convert.ToBoolean(accountData["IsCreditInsured"]);

			return istaCustomer;
		}

		/// <summary>
		/// Gets the plan type enumeration to update the record with
		/// </summary>
		/// <param name="Plantype">type of product</param>
		/// <returns>PlanTypeOptions enumeration object</returns>
		public static IstaEnrollmentService.PlanTypeOptions GetPlanType( object Plantype )
		{
			switch( Plantype.ToString().Trim() )
			{
				case "0":
					return IstaEnrollmentService.PlanTypeOptions.Fixed;
				case "1":
					return IstaEnrollmentService.PlanTypeOptions.PortfolioVariable;
				case "2":
					return IstaEnrollmentService.PlanTypeOptions.CustomVariable;
				case "3":
					return IstaEnrollmentService.PlanTypeOptions.HeatRate;
				case "4":
					return IstaEnrollmentService.PlanTypeOptions.MCPE;
				case "5":
					return IstaEnrollmentService.PlanTypeOptions.CustomBilling;
				case "6":
					return IstaEnrollmentService.PlanTypeOptions.Ruc;
				case "7":
					return IstaEnrollmentService.PlanTypeOptions.CustomIndex;
				default:
					throw new NotImplementedException( "There was an error converting the Plantype value from the database into an enumerated value." );
			}
		}

		/// <summary>
		/// Gets the plan type enumeration to update the record with
		/// </summary>
		/// <param name="Plantype">type of product</param>
		/// <returns>PlanTypeOptions enumeration object</returns>
		public static IstaRateService.PlanTypeOptions GetPlanType( string Plantype )
		{
			switch( Plantype.Trim() )
			{
				case "0":
					return IstaRateService.PlanTypeOptions.Fixed;
				case "1":
					return IstaRateService.PlanTypeOptions.PortfolioVariable;
				case "2":
					return IstaRateService.PlanTypeOptions.CustomVariable;
				case "3":
					return IstaRateService.PlanTypeOptions.HeatRate;
				case "4":
					return IstaRateService.PlanTypeOptions.MCPE;
				case "5":
					return IstaRateService.PlanTypeOptions.CustomBilling;
				case "6":
					return IstaRateService.PlanTypeOptions.Ruc;
				case "7":
					return IstaRateService.PlanTypeOptions.CustomIndex;
				default:
					throw new NotImplementedException( "There was an error converting the Plantype value from the database into an enumerated value." );
			}
		}

		/// <summary>
		/// Gets the list of rate details for a product
		/// </summary>
		/// <param name="PlanType"></param>
		/// <param name="RateEffectiveDate"></param>
		/// <param name="RateEndDate"></param>
		/// <param name="Rate"></param>
		/// <param name="ISTA_Class_ID"></param>
		/// <param name="MeterCharge"></param>
		/// <param name="VariableTypeID">This is used in the rate look up for portfolio variable accounts.</param>
		/// <returns></returns>
		public static IstaEnrollmentService.EnrollRateDetail[] GetISTARateList( string PlanType, DateTime RateEffectiveDate, DateTime RateEndDate, decimal Rate, string ISTA_Class_ID, decimal MeterCharge, int VariableTypeID )
		{
			return GetISTARateDetailsList( PlanType, RateEffectiveDate, RateEndDate, Rate, ISTA_Class_ID, MeterCharge, "EnrollRateDetail", VariableTypeID );
		}

		/// <summary>
		/// Get ISTA enroll rate detail list and converts it ro a rate rollover detail list
		/// </summary>
		/// <param name="planType"></param>
		/// <param name="rateEffectiveDate"></param>
		/// <param name="rateEndDate"></param>
		/// <param name="rate"></param>
		/// <param name="istaClassId"></param>
		/// <param name="meterCharge"></param>
		/// <param name="variableTypeID"></param>
		/// <returns></returns>
		public static IstaRateService.RateRolloverDetail[] GetISTARolloverRateList( string planType, DateTime rateEffectiveDate, DateTime rateEndDate, decimal rate1, string istaClassId, decimal meterCharge, int variableTypeID )
		{
			return GetISTARolloverRateList( planType, rateEffectiveDate, rateEndDate, rate1, 0, 0, istaClassId, meterCharge, variableTypeID );
		}

		public static IstaRateService.RateRolloverDetail[] GetISTARolloverRateList( string planType, DateTime rateEffectiveDate, DateTime rateEndDate, decimal rate1, decimal rate2, decimal rate3, string istaClassId, decimal meterCharge, int variableTypeID )
		{
			IstaEnrollmentService.EnrollRateDetail[] rateDetailsList = GetISTARateDetailsList( planType, rateEffectiveDate, rateEndDate, rate1, rate2, rate3, istaClassId, meterCharge, "RateRolloverDetail", variableTypeID );
			IstaRateService.RateRolloverDetail[] rateRolloverDetailsList = new IstaRateService.RateRolloverDetail[rateDetailsList.Length];
			IstaRateService.RateRolloverDetail rateDetail;
			int pos = 0;
			foreach( IstaEnrollmentService.EnrollRateDetail enrollRateDetail in rateDetailsList )
			{
				rateDetail = ConvertToRolloverDetal( enrollRateDetail );
				rateRolloverDetailsList[pos] = rateDetail;
				pos++;
			}
			return rateRolloverDetailsList;
		}

		/// <summary>
		/// Converts enroll rate detail object and converts it ro a rate rollover detail one
		/// </summary>
		/// <param name="enrollRateDetail"></param>
		/// <returns></returns>
		private static IstaRateService.RateRolloverDetail ConvertToRolloverDetal( IstaEnrollmentService.EnrollRateDetail enrollRateDetail )
		{
			IstaRateService.RateRolloverDetail rateDetail = new IstaRateService.RateRolloverDetail();
			rateDetail.RateTemplateID = enrollRateDetail.RateTemplateID;
			rateDetail.RateEffectiveDate = enrollRateDetail.RateEffectiveDate;
			rateDetail.RateExpirationDate = enrollRateDetail.RateExpirationDate;
			rateDetail.RateAmount = enrollRateDetail.RateAmount;
			rateDetail.UsageClassID = enrollRateDetail.UsageClassID;
			rateDetail.RateVariableTypeID = enrollRateDetail.RateVariableTypeID;

			return rateDetail;
		}

		/// <summary>
		/// Creates the rate detail list to be send to ISTA
		/// </summary>
		/// <param name="planType"></param>
		/// <param name="rateEffectiveDate"></param>
		/// <param name="rateEndDate"></param>
		/// <param name="rate1"></param>
		/// <param name="istaClassId"></param>
		/// <param name="meterCharge"></param>
		/// <param name="rateType"></param>
		/// <param name="variableTypeID"></param>
		/// <returns></returns>
		public static IstaEnrollmentService.EnrollRateDetail[] GetISTARateDetailsList( string planType, DateTime rateEffectiveDate, DateTime rateEndDate, decimal rate1, string istaClassId, decimal meterCharge, string rateType, int variableTypeID )
		{
			return GetISTARateDetailsList( planType, rateEffectiveDate, rateEndDate, rate1, 0, 0, istaClassId, meterCharge, rateType, variableTypeID );
		}

		/// <summary>
		/// Creates the rate detail list to be send to ISTA
		/// </summary>
		/// <param name="planType"></param>
		/// <param name="rateEffectiveDate"></param>
		/// <param name="rateEndDate"></param>
		/// <param name="rate1"></param>
		/// <param name="rate2"></param>
		/// <param name="istaClassId"></param>
		/// <param name="meterCharge"></param>
		/// <param name="rateType"></param>
		/// <param name="variableTypeID"></param>
		/// <returns></returns>
		public static IstaEnrollmentService.EnrollRateDetail[] GetISTARateDetailsList( string planType, DateTime rateEffectiveDate, DateTime rateEndDate, decimal rate1, decimal rate2, string istaClassId, decimal meterCharge, string rateType, int variableTypeID )
		{
			return GetISTARateDetailsList( planType, rateEffectiveDate, rateEndDate, rate1, rate2, 0, istaClassId, meterCharge, rateType, variableTypeID );
		}

		/// <summary>
		/// Creates the rate detail list to be send to ISTA
		/// </summary>
		/// <param name="planType"></param>
		/// <param name="rateEffectiveDate"></param>
		/// <param name="rateEndDate"></param>
		/// <param name="rate1"></param>
		/// <param name="rate2"></param>
		/// <param name="rate3"></param>
		/// <param name="istaClassId"></param>
		/// <param name="meterCharge"></param>
		/// <param name="rateType"></param>
		/// <param name="variableTypeID"></param>
		/// <returns></returns>
		public static IstaEnrollmentService.EnrollRateDetail[] GetISTARateDetailsList( string planType, DateTime rateEffectiveDate, DateTime rateEndDate, decimal rate1, decimal rate2, decimal rate3, string istaClassId, decimal meterCharge, string rateType, int variableTypeID )
		{
			// Create as EnrollRateDetail and convert later if it is a rollover (both classes have the same properties)
			IstaEnrollmentService.EnrollRateDetail rateDetail1 = new IstaEnrollmentService.EnrollRateDetail();
			rateDetail1.RateEffectiveDate = rateEffectiveDate;
			rateDetail1.RateExpirationDate = rateEndDate;
			rateDetail1.RateAmount = rate1;
			rateDetail1.UsageClassID = Convert.ToInt32( istaClassId );
			rateDetail1.RateVariableTypeID = variableTypeID;

			// Fixed Adder detail
			IstaEnrollmentService.EnrollRateDetail rateDetail2 = new IstaEnrollmentService.EnrollRateDetail();
			rateDetail2.RateEffectiveDate = rateEffectiveDate;
			rateDetail2.RateExpirationDate = rateEndDate;
			rateDetail2.RateAmount = rate2;
			rateDetail2.UsageClassID = Convert.ToInt32( istaClassId );
			rateDetail2.RateVariableTypeID = variableTypeID;

			// Meter Charge detail
			IstaEnrollmentService.EnrollRateDetail rateDetail3 = new IstaEnrollmentService.EnrollRateDetail();
			rateDetail3.RateEffectiveDate = rateEffectiveDate;
			rateDetail3.RateExpirationDate = rateEndDate;
			rateDetail3.RateAmount = rate3;
			rateDetail3.UsageClassID = Convert.ToInt32( istaClassId );
			rateDetail3.RateVariableTypeID = variableTypeID;


			//Plan type = MCPE
			if( planType == "4" )
			{
				rateDetail1.RateTemplateID = 8;
				rateDetail2.RateTemplateID = 9;
				rateDetail3.RateTemplateID = 10;

				return new IstaEnrollmentService.EnrollRateDetail[] { rateDetail1, rateDetail2, rateDetail3 };
			}
			//Plan type = CustomVariable
			else if( planType == "2" )
			{
				rateDetail1.RateTemplateID = 5;

				return new IstaEnrollmentService.EnrollRateDetail[] { rateDetail1 };
			}
			//Plan type = CustomBilling
			else if( planType == "5" )
			{
				rateDetail1.RateTemplateID = 11;
				rateDetail2.RateTemplateID = 12;
				rateDetail3.RateTemplateID = 13;

				return new IstaEnrollmentService.EnrollRateDetail[] { rateDetail1, rateDetail2, rateDetail3 };
			}
			//Plan type = PortfolioVariable
			else if( planType == "1" )
			{
				rateDetail1.RateTemplateID = 4;
				return new IstaEnrollmentService.EnrollRateDetail[] { rateDetail1 };
			}
			//Plan type = Fixed
			else if( planType == "0" )
			{
				rateDetail1.RateTemplateID = 1;
				rateDetail2.RateTemplateID = 2;
				rateDetail3.RateTemplateID = 3;

				if( meterCharge != 0 )
				{
					return new IstaEnrollmentService.EnrollRateDetail[] { rateDetail1, rateDetail3 };
				}
				else
				{
					return new IstaEnrollmentService.EnrollRateDetail[] { rateDetail1 };
				}
			}
			// Simple Index
			else if( planType == "7" )
			{
				rateDetail1.RateTemplateID = 18; // Metered Energy Charges
				rateDetail2.RateTemplateID = 19; // Fixed Adder

				return new IstaEnrollmentService.EnrollRateDetail[] { rateDetail1, rateDetail2 };
			}
			else
			{
				rateDetail1.RateTemplateID = 1;
				rateDetail2.RateTemplateID = 2;
				rateDetail3.RateTemplateID = 3;

				return new IstaEnrollmentService.EnrollRateDetail[] { rateDetail1, rateDetail2, rateDetail3 };
			}

		}

		#region ISTA Enum translation routines
		/// <summary>
		/// Converts to ISTA billing type from LibertyPower billing type
		/// </summary>
		/// <param name="libertyBillingType"></param>
		/// <returns>A IstaWebServices.BillingTypeOptions object which represents the ISTA Billing Type</returns>
		public static IstaEnrollmentService.BillingTypeOptions GetBillingType( string libertyBillingType )
		{
			switch( libertyBillingType.Trim() )
			{
				case "BR":
					return IstaEnrollmentService.BillingTypeOptions.BillReady;
				case "SC":
					return IstaEnrollmentService.BillingTypeOptions.SupplierConsolidated;
				case "DUAL":
					return IstaEnrollmentService.BillingTypeOptions.Dual;
				case "RR":
					return IstaEnrollmentService.BillingTypeOptions.RateReady;
				default:
					throw new NotImplementedException( "The billing type translation for the specified billing type has not yet been implemented." );
			}
		}

		/// <summary>
		/// Converts to ISTA enrollment type from LibertyPower enrollment type
		/// </summary>
		/// <param name="enrollmentType">Liberty Power enrollment type</param>
		/// <returns>ISTA Enrollment Type object to represent the specified liberty enrollment type</returns>
		public static IstaEnrollmentService.EnrollmentTypeOptions GetIstaEnrollmentType( string enrollmentType )
		{
			switch( enrollmentType )
			{
				case "OnCycle":
					return IstaEnrollmentService.EnrollmentTypeOptions.SWITCH;
				case "OffCycle":
					return IstaEnrollmentService.EnrollmentTypeOptions.OFF_CYCLE_SWITCH;
				case "OffCycleNoPostcard":
					return IstaEnrollmentService.EnrollmentTypeOptions.OFF_CYCLE_SWITCH;
				case "MoveIn":
					return IstaEnrollmentService.EnrollmentTypeOptions.MOVE_IN;
				case "PriorityMoveIn":
					return IstaEnrollmentService.EnrollmentTypeOptions.PRIORITY_MOVE_IN;
				default:
					throw new NotImplementedException( "The enrollment type translation for the specified enrollment type has not yet been implemented" );
			}
		}

		/// <summary>
		/// Transforms set of Tax values into ISTA list of tax assessments/percentages object.
		/// </summary>
		/// <param name="Tax_State"></param>
		/// <param name="Tax_County"></param>
		/// <param name="Tax_City"></param>
		/// <param name="Tax_Special"></param>
		/// <param name="Tax_PUC"></param>
		/// <param name="Tax_GRT"></param>
		/// <param name="Tax_Franchise"></param>
		/// <param name="TaxCode"></param>
		/// <returns>ISTA Tax Percentage list</returns>
		public static IstaEnrollmentService.EnrollPremiseTaxPercentage[] GetEnrollPremiseTaxPercentageList( decimal Tax_State, decimal Tax_County, decimal Tax_City, decimal Tax_Special, decimal Tax_PUC, decimal Tax_GRT, decimal Tax_Franchise, int TaxCode )
		{
			IstaEnrollmentService.EnrollPremiseTaxPercentage TaxPercentage_City = new IstaEnrollmentService.EnrollPremiseTaxPercentage();
			TaxPercentage_City.TaxAssessmentValue = IstaEnrollmentService.TaxAssessmentOptions.City;
			TaxPercentage_City.Percentage = Tax_City;

			IstaEnrollmentService.EnrollPremiseTaxPercentage TaxPercentage_State = new IstaEnrollmentService.EnrollPremiseTaxPercentage();
			TaxPercentage_State.TaxAssessmentValue = IstaEnrollmentService.TaxAssessmentOptions.State;
			TaxPercentage_State.Percentage = Tax_State;

			IstaEnrollmentService.EnrollPremiseTaxPercentage TaxPercentage_County = new IstaEnrollmentService.EnrollPremiseTaxPercentage();
			TaxPercentage_County.TaxAssessmentValue = IstaEnrollmentService.TaxAssessmentOptions.County;
			TaxPercentage_County.Percentage = Tax_County;

			IstaEnrollmentService.EnrollPremiseTaxPercentage TaxPercentage_Special = new IstaEnrollmentService.EnrollPremiseTaxPercentage();
			TaxPercentage_Special.TaxAssessmentValue = IstaEnrollmentService.TaxAssessmentOptions.Special;
			TaxPercentage_Special.Percentage = Tax_Special;

			IstaEnrollmentService.EnrollPremiseTaxPercentage TaxPercentage_PUC = new IstaEnrollmentService.EnrollPremiseTaxPercentage();
			TaxPercentage_PUC.TaxAssessmentValue = IstaEnrollmentService.TaxAssessmentOptions.PUC;
			TaxPercentage_PUC.Percentage = Tax_PUC;

			IstaEnrollmentService.EnrollPremiseTaxPercentage TaxPercentage_GRT = new IstaEnrollmentService.EnrollPremiseTaxPercentage();
			TaxPercentage_GRT.TaxAssessmentValue = IstaEnrollmentService.TaxAssessmentOptions.GRT;
			TaxPercentage_GRT.Percentage = Tax_GRT;

			IstaEnrollmentService.EnrollPremiseTaxPercentage TaxPercentage_Franchise = new IstaEnrollmentService.EnrollPremiseTaxPercentage();
			TaxPercentage_Franchise.TaxAssessmentValue = IstaEnrollmentService.TaxAssessmentOptions.Franchise;
			TaxPercentage_Franchise.Percentage = Tax_Franchise;

			IstaEnrollmentService.EnrollPremiseTaxPercentage[] TaxPercentageList = null;

			switch( TaxCode )
			{
				//Case 15 'liberty tax code 15 = state tax only
				//TaxAssessmentOptionsList = New TaxAssessmentOptions() {TaxAssessmentOptions.State}
				case 0:
					//liberty tax code 0 = excludes everything
					TaxPercentageList = new IstaEnrollmentService.EnrollPremiseTaxPercentage[] { };
					break;
				case 32:
					//liberty tax code 32 = only GRT
					TaxPercentageList = new IstaEnrollmentService.EnrollPremiseTaxPercentage[] {
		                                TaxPercentage_GRT
	                                };
					break;
				case 48:
					//liberty tax code 48 = only PUC and GRT
					TaxPercentageList = new IstaEnrollmentService.EnrollPremiseTaxPercentage[] {
		                                TaxPercentage_GRT,
		                                TaxPercentage_PUC
	                                };
					break;
				case 79:
					//liberty tax code 79 = everything except PUC and GRT
					TaxPercentageList = new IstaEnrollmentService.EnrollPremiseTaxPercentage[] {
		                                TaxPercentage_City,
		                                TaxPercentage_County,
		                                TaxPercentage_Franchise,
		                                TaxPercentage_Special,
		                                TaxPercentage_State
	                                };
					break;
				case 127:
					//liberty tax code 127 = "all" taxes
					TaxPercentageList = new IstaEnrollmentService.EnrollPremiseTaxPercentage[] {
		        TaxPercentage_City,
		        TaxPercentage_County,
		        TaxPercentage_Franchise,
                                        TaxPercentage_GRT,
                                        TaxPercentage_PUC,
		        TaxPercentage_Special,
		        TaxPercentage_State
	        };
					break;
                case 111:
                    //liberty tax code 111 = everything except PUC
                    TaxPercentageList = new IstaEnrollmentService.EnrollPremiseTaxPercentage[] {
		                                TaxPercentage_City,
		                                TaxPercentage_County,
		                                TaxPercentage_Franchise,
                                        TaxPercentage_GRT,
		                                TaxPercentage_Special,
		                                TaxPercentage_State
	                                };
                    break;
                case 95:
                    //liberty tax code 95 = everything except GRT
                    TaxPercentageList = new IstaEnrollmentService.EnrollPremiseTaxPercentage[] {
		                                TaxPercentage_City,
		                                TaxPercentage_County,
		                                TaxPercentage_Franchise,
                                        TaxPercentage_PUC,
		                                TaxPercentage_Special,
		                                TaxPercentage_State
	                                };
                    break;
				default:
					throw new NotImplementedException( "The handling for the specified taxation type is not currently implemented." );

			}

			return TaxPercentageList;
		}

		#endregion

		private static bool EnableSimpleIndex()
		{
			bool enableSimpleIndex = false;

			if( bool.TryParse( System.Configuration.ConfigurationManager.AppSettings["EnableSimpleIndex"], out  enableSimpleIndex ) )
			{
				if( enableSimpleIndex )
				{
					return true;
				}
			}
			return false;
		}
	}
}
