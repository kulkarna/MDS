using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaEnrollmentService;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{
	/// <summary>
	/// Contains common methods used by multiple services
	/// </summary>
	public static class ServiceHelper
	{

		/// <summary>
		///  Converts to ISTA billing type from LibertyPower billing type
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
		/// Translates from liberty tax assessment type code to ISTA list of tax assessments.
		/// </summary>
		/// <param name="taxCode">Liberty tax code</param>
		/// <returns>ISTA Tax assessment list</returns>
		public static IstaEnrollmentService.TaxAssessmentOptions[] GetIstaTaxAssessmentList( int taxCode )
		{
			//IstaEnrollmentService.TaxAssessmentOptions[] TaxAssessmentOptionsList = null;
            List<IstaEnrollmentService.TaxAssessmentOptions> TaxAssessmentOptionsList = new List<IstaEnrollmentService.TaxAssessmentOptions>();

            if ((taxCode & 1) == 1)
                TaxAssessmentOptionsList.Add(IstaEnrollmentService.TaxAssessmentOptions.State);
            if ((taxCode & 2) == 2)
                TaxAssessmentOptionsList.Add(IstaEnrollmentService.TaxAssessmentOptions.County);
            if ((taxCode & 4) == 4)
                TaxAssessmentOptionsList.Add(IstaEnrollmentService.TaxAssessmentOptions.City);
            if ((taxCode & 8) == 8)
                TaxAssessmentOptionsList.Add(IstaEnrollmentService.TaxAssessmentOptions.Special);
            if ((taxCode & 16) == 16)
                TaxAssessmentOptionsList.Add(IstaEnrollmentService.TaxAssessmentOptions.PUC);
            if ((taxCode & 32) == 32)
                TaxAssessmentOptionsList.Add(IstaEnrollmentService.TaxAssessmentOptions.GRT);
            if ((taxCode & 64) == 64)
                TaxAssessmentOptionsList.Add(IstaEnrollmentService.TaxAssessmentOptions.Franchise);

			return TaxAssessmentOptionsList.ToArray();
		}

        /// <summary>
        /// Translates from liberty tax assessment type code to ISTA list of tax assessments.
        /// </summary>
        /// <param name="taxCode">Liberty tax code</param>
        /// <returns>ISTA Tax assessment list</returns>
        public static IstaEnrollmentService.TaxAssessmentOptions[] GetIstaTaxAssessmentListOld(int taxCode)
        {
            IstaEnrollmentService.TaxAssessmentOptions[] TaxAssessmentOptionsList = null;

            switch (taxCode)
            {
                //Case 15 'liberty tax code 15 = state tax only
                //TaxAssessmentOptionsList = New TaxAssessmentOptions() {TaxAssessmentOptions.State}
                case 0:
                    //liberty tax code 0 = excludes everything
                    TaxAssessmentOptionsList = new IstaEnrollmentService.TaxAssessmentOptions[] { };
                    break;
                case 32:
                    //liberty tax code 32 = only GRT
                    TaxAssessmentOptionsList = new IstaEnrollmentService.TaxAssessmentOptions[] { IstaEnrollmentService.TaxAssessmentOptions.GRT };
                    break;
                case 48:
                    //liberty tax code 48 = only PUC and GRT
                    TaxAssessmentOptionsList = new IstaEnrollmentService.TaxAssessmentOptions[] {
					IstaEnrollmentService.TaxAssessmentOptions.GRT,
					IstaEnrollmentService.TaxAssessmentOptions.PUC
				};
                    break;
                case 79:
                    //liberty tax code 79 = everything except PUC and GRT
                    TaxAssessmentOptionsList = new IstaEnrollmentService.TaxAssessmentOptions[] {
					IstaEnrollmentService.TaxAssessmentOptions.City,
					IstaEnrollmentService.TaxAssessmentOptions.County,
					IstaEnrollmentService.TaxAssessmentOptions.Franchise,
					IstaEnrollmentService.TaxAssessmentOptions.Special,
					IstaEnrollmentService.TaxAssessmentOptions.State
				};
                    break;
                case 127:
                    //liberty tax code 127 = "all" taxes
                    TaxAssessmentOptionsList = new IstaEnrollmentService.TaxAssessmentOptions[] {
					IstaEnrollmentService.TaxAssessmentOptions.City,
					IstaEnrollmentService.TaxAssessmentOptions.County,
					IstaEnrollmentService.TaxAssessmentOptions.Franchise,
					IstaEnrollmentService.TaxAssessmentOptions.GRT,
					IstaEnrollmentService.TaxAssessmentOptions.PUC,
					IstaEnrollmentService.TaxAssessmentOptions.Special,
					IstaEnrollmentService.TaxAssessmentOptions.State
				};
                    break;
                default:
                    throw new NotImplementedException("The handling for the specified taxation type is not currently implemented.");
            }

            return TaxAssessmentOptionsList;
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
		/// <returns>ISTA Tax Percentage list</returns>
		public static IstaEnrollmentService.EnrollPremiseTaxPercentage[] GetEnrollPremiseTaxPercentageList( decimal Tax_State, decimal Tax_County, decimal Tax_City, decimal Tax_Special, decimal Tax_PUC, decimal Tax_GRT, decimal Tax_Franchise )
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
			TaxPercentageList = new IstaEnrollmentService.EnrollPremiseTaxPercentage[] {
		        TaxPercentage_City,
		        TaxPercentage_County,
		        TaxPercentage_Franchise,
		        TaxPercentage_Special,
		        TaxPercentage_State
	        };

			return TaxPercentageList;
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
				case "4":
					return IstaEnrollmentService.PlanTypeOptions.MCPE; 
				case "5":
					return IstaEnrollmentService.PlanTypeOptions.CustomBilling;
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
		/// <returns></returns>
		public static IstaEnrollmentService.EnrollRateDetail[] GetISTARateList( string PlanType, DateTime RateEffectiveDate, DateTime RateEndDate, decimal Rate, string ISTA_Class_ID, decimal MeterCharge )
		{
			PlanType = PlanType.Trim();
			//RateSubCategory = RateSubCategory.Trim()

			IstaEnrollmentService.EnrollRateDetail[] RateDetailList = null;

			if( PlanType == "4" )
			{
				IstaEnrollmentService.EnrollRateDetail rateDetail = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail.RateTemplateID = 8;
				rateDetail.RateEffectiveDate = RateEffectiveDate;
				rateDetail.RateExpirationDate = RateEndDate;
				rateDetail.RateAmount = Rate;
				rateDetail.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail.RateVariableTypeID = 1;

				IstaEnrollmentService.EnrollRateDetail rateDetail2 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail2.RateTemplateID = 9;
				rateDetail2.RateEffectiveDate = RateEffectiveDate;
				rateDetail2.RateExpirationDate = RateEndDate;
				rateDetail2.RateAmount = 0;
				rateDetail2.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail2.RateVariableTypeID = 1;

				IstaEnrollmentService.EnrollRateDetail rateDetail3 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail3.RateTemplateID = 10;
				rateDetail3.RateEffectiveDate = RateEffectiveDate;
				rateDetail3.RateExpirationDate = RateEndDate;
				rateDetail3.RateAmount = 0;
				rateDetail3.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail3.RateVariableTypeID = 1;

				RateDetailList = new IstaEnrollmentService.EnrollRateDetail[] {
	                rateDetail,
	                rateDetail2,
	                rateDetail3
                };
				//Custom Variable
			}
			else if( PlanType == "2" )
			{
				IstaEnrollmentService.EnrollRateDetail rateDetail = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail.RateTemplateID = 5;
				rateDetail.RateEffectiveDate = RateEffectiveDate;
				rateDetail.RateExpirationDate = RateEndDate;
				rateDetail.RateAmount = Rate;
				rateDetail.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail.RateVariableTypeID = 1;

				IstaEnrollmentService.EnrollRateDetail rateDetail2 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail2.RateTemplateID = 6;
				rateDetail2.RateEffectiveDate = RateEffectiveDate;
				rateDetail2.RateExpirationDate = RateEndDate;
				rateDetail2.RateAmount = 0;
				rateDetail2.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail2.RateVariableTypeID = 1;

				IstaEnrollmentService.EnrollRateDetail rateDetail3 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail3.RateTemplateID = 7;
				rateDetail3.RateEffectiveDate = RateEffectiveDate;
				rateDetail3.RateExpirationDate = RateEndDate;
				rateDetail3.RateAmount = 0;
				rateDetail3.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail3.RateVariableTypeID = 1;

				RateDetailList = new IstaEnrollmentService.EnrollRateDetail[] {
			        rateDetail,
			        rateDetail2,
			        rateDetail3
		        };
				//Complex Billing
			}
			else if( PlanType == "5" )
			{
				IstaEnrollmentService.EnrollRateDetail rateDetail = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail.RateTemplateID = 11;
				rateDetail.RateEffectiveDate = RateEffectiveDate;
				rateDetail.RateExpirationDate = RateEndDate;
				rateDetail.RateAmount = Rate;
				rateDetail.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail.RateVariableTypeID = 1;

				IstaEnrollmentService.EnrollRateDetail rateDetail2 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail2.RateTemplateID = 12;
				rateDetail2.RateEffectiveDate = RateEffectiveDate;
				rateDetail2.RateExpirationDate = RateEndDate;
				rateDetail2.RateAmount = 0;
				rateDetail2.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail2.RateVariableTypeID = 1;

				IstaEnrollmentService.EnrollRateDetail rateDetail3 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail3.RateTemplateID = 13;
				rateDetail3.RateEffectiveDate = RateEffectiveDate;
				rateDetail3.RateExpirationDate = RateEndDate;
				rateDetail3.RateAmount = 0;
				rateDetail3.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail3.RateVariableTypeID = 1;

				RateDetailList = new IstaEnrollmentService.EnrollRateDetail[] {
			        rateDetail,
			        rateDetail2,
			        rateDetail3
		        };
			}
			else if( PlanType == "1" )
			{
				IstaEnrollmentService.EnrollRateDetail rateDetail = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail.RateTemplateID = 4;
				rateDetail.RateEffectiveDate = RateEffectiveDate;
				rateDetail.RateExpirationDate = RateEndDate;
				rateDetail.RateAmount = Rate;
				rateDetail.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail.RateVariableTypeID = 1;

				RateDetailList = new IstaEnrollmentService.EnrollRateDetail[] { rateDetail };
			}
			else if( PlanType == "0" )
			{
				IstaEnrollmentService.EnrollRateDetail rateDetail = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail.RateTemplateID = 1;
				rateDetail.RateEffectiveDate = RateEffectiveDate;
				rateDetail.RateExpirationDate = RateEndDate;
				rateDetail.RateAmount = Rate;
				rateDetail.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail.RateVariableTypeID = 1;

				//Fixed Adder detail
				IstaEnrollmentService.EnrollRateDetail rateDetail2 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail2.RateTemplateID = 2;
				rateDetail2.RateEffectiveDate = RateEffectiveDate;
				rateDetail2.RateExpirationDate = RateEndDate;
				rateDetail2.RateAmount = 0;
				rateDetail2.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail2.RateVariableTypeID = 1;

				//Meter Charge detail
				IstaEnrollmentService.EnrollRateDetail rateDetail3 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail3.RateTemplateID = 3;
				rateDetail3.RateEffectiveDate = RateEffectiveDate;
				rateDetail3.RateExpirationDate = RateEndDate;
				rateDetail3.RateAmount = 0;
				rateDetail3.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail3.RateVariableTypeID = 1;

				if( MeterCharge != 0 )
				{
					RateDetailList = new IstaEnrollmentService.EnrollRateDetail[] {
				rateDetail,
				rateDetail3
			};
				}
				else
				{
					RateDetailList = new IstaEnrollmentService.EnrollRateDetail[] { rateDetail };
				}
			}
			else
			{
				IstaEnrollmentService.EnrollRateDetail rateDetail = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail.RateTemplateID = 1;
				rateDetail.RateEffectiveDate = RateEffectiveDate;
				rateDetail.RateExpirationDate = RateEndDate;
				rateDetail.RateAmount = Rate;
				rateDetail.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail.RateVariableTypeID = 1;

				//Fixed Adder detail
				IstaEnrollmentService.EnrollRateDetail rateDetail2 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail2.RateTemplateID = 2;
				rateDetail2.RateEffectiveDate = RateEffectiveDate;
				rateDetail2.RateExpirationDate = RateEndDate;
				rateDetail2.RateAmount = 0;
				rateDetail2.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail2.RateVariableTypeID = 1;

				//Meter Charge detail
				IstaEnrollmentService.EnrollRateDetail rateDetail3 = new IstaEnrollmentService.EnrollRateDetail();
				rateDetail3.RateTemplateID = 3;
				rateDetail3.RateEffectiveDate = RateEffectiveDate;
				rateDetail3.RateExpirationDate = RateEndDate;
				rateDetail3.RateAmount = 0;
				rateDetail3.UsageClassID = Convert.ToInt32( ISTA_Class_ID );
				rateDetail3.RateVariableTypeID = 1;

				RateDetailList = new IstaEnrollmentService.EnrollRateDetail[] {
			rateDetail,
			rateDetail2,
			rateDetail3
		};
			}

			return RateDetailList;
		}

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
			istaCustomer.ApplyLateFees = true;
			//istaCustomer.LateFeeRate = (decimal) 0.05;
            //SR1-2966641
			//istaCustomer.LateFeeGracePeriod = 3;
            istaCustomer.LateFeeGracePeriod = Convert.ToInt32(accountData["GracePeriod"].ToString());

             // SD 22422 Begin
            // Determine if the market is Texas and set the late fee to 0.05
            if (accountData["MarketCode"].ToString().ToUpper() == "TX")
            {
                istaCustomer.LateFeeRate = (decimal)0.05;
            }
            else
            {
                istaCustomer.LateFeeRate = (decimal)0.015;
            }
            // SD 22422 End

			int iTerms = 0;
			if( accountData["ARTerms"] != null )
				Int32.TryParse( accountData["ARTerms"].ToString(), out iTerms );
			istaCustomer.ARTerms = iTerms;

			istaCustomer.DBA = null;
			istaCustomer.FederalTaxId = null;
			istaCustomer.DigitalSignature = null;
			istaCustomer.FirstName = accountData["FirstName"].ToString();

			bool bTax = true;
			if( accountData["taxable"] != null )
				bool.TryParse( accountData["taxable"].ToString(), out bTax );
			istaCustomer.IsTaxable = bTax;

			istaCustomer.LastName = accountData["LastName"].ToString();
			istaCustomer.MiddleName = accountData["middlename"].ToString();
			istaCustomer.ESPDuns = accountData["LPC_Duns"].ToString();
			istaCustomer.TDSPDuns = accountData["utility_duns"].ToString();

			istaCustomer.ContractStartDate = (DateTime) accountData["ContractStartDate"];
			istaCustomer.ContractEndDate = (DateTime) accountData["ContractEndDate"];

			if( enrollmentType == "OffCycleNoPostcard" )
				istaCustomer.NotificationWaiver = false;
			else
				istaCustomer.NotificationWaiver = true;

			istaCustomer.PrintLayout = (IstaEnrollmentService.PrintLayoutOptions) System.Enum.Parse( typeof( IstaEnrollmentService.PrintLayoutOptions ), accountData["printlayout"].ToString() );
			istaCustomer.Salutation = accountData["salutation"].ToString();

			if( accountData["servicestate"].ToString().Equals( "TX", StringComparison.CurrentCultureIgnoreCase ) )
				istaCustomer.SubmitHURequest = true;
			else
				istaCustomer.SubmitHURequest = false;

			//build customer premise (service location) object
			IstaEnrollmentService.EnrollPremise custPremise = new IstaEnrollmentService.EnrollPremise();
			custPremise.Address1 = accountData["servicestreet"].ToString();
			custPremise.Address2 = accountData["servicesuite"].ToString();
			custPremise.City = accountData["servicecity"].ToString();
			custPremise.NameKey = accountData["NameKey"].ToString();
			custPremise.EnrollmentType = ServiceHelper.GetIstaEnrollmentType( enrollmentType );

			if( enrollmentType != "OnCycle" )
				custPremise.SpecialReadDate = startDate;

			custPremise.EsiId = accountData["account_number"].ToString();

			if( accountData["ista_zone_id"] != null && accountData["ista_zone_id"].ToString() != "" )
				custPremise.LBMPID = Convert.ToInt32( accountData["ista_zone_id"].ToString() );
			else
				custPremise.LBMPID = null;

			custPremise.MeterNumber = accountData["Meter"].ToString();
			custPremise.State = accountData["servicestate"].ToString();
			decimal Tax_State = (decimal) accountData["Tax_State"];
			decimal Tax_County = (decimal) accountData["Tax_County"];
			decimal Tax_City = (decimal) accountData["Tax_City"];
			decimal Tax_Special = (decimal) accountData["Tax_Special"];
			decimal Tax_PUC = (decimal) accountData["Tax_PUC"];
			decimal Tax_GRT = (decimal) accountData["Tax_GRT"];
			decimal Tax_Franchise = (decimal) accountData["Tax_Franchise"];

			custPremise.EnrollPremiseTaxPercentageList = ServiceHelper.GetEnrollPremiseTaxPercentageList( Tax_State, Tax_County, Tax_City, Tax_Special, Tax_PUC, Tax_GRT, Tax_Franchise );

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
			product.EnrollRateDetailList = GetISTARateList( accountData["plantype"].ToString(), Convert.ToDateTime( accountData["rateEffectiveDate"] ), Convert.ToDateTime( accountData["rateEndDate"] ), Convert.ToDecimal( accountData["rate"] ), accountData["ista_class_id"].ToString(), Convert.ToDecimal( accountData["MeterCharge"] ) );

			//'build default product object
			//TODO: default product details are hardcoded for now.
			IstaEnrollmentService.EnrollDefaultRate defaultProduct = new IstaEnrollmentService.EnrollDefaultRate();

			if( accountData["defaultplantype"] != null && accountData["defaultplantype"].ToString() != "" )
				defaultProduct.PlanType = GetPlanType( accountData["defaultplantype"] );

			defaultProduct.LDCRateCode = accountData["defaultratecode"].ToString();
			defaultProduct.SwitchDate = ((DateTime) accountData["rateEndDate"]).AddDays( 1 );
			//use the enddate for the rate as the startdate for the fallback/default product
			//defaultProduct.EnrollRateDetailList = New EnrollRateDetail() {defaultRateDetail}
			defaultProduct.EnrollRateDetailList = GetISTARateList( accountData["defaultplantype"].ToString(), Convert.ToDateTime( accountData["rateEndDate"] ), Convert.ToDateTime( accountData["rateEndDate"] ).AddYears( 1 ), Convert.ToDecimal( accountData["defaultrate"] ), accountData["ista_class_id"].ToString(), Convert.ToDecimal( accountData["MeterCharge"] ) );

			istaCustomer.EnrollRate = product;
			istaCustomer.EnrollDefaultRate = defaultProduct;
			istaCustomer.EnrollPremise = custPremise;

			return istaCustomer;
		}
        /// <summary>
        /// Builds ISTA EnrollCustomer object for use pre-enrollment usage requests
        /// </summary>
        /// <returns></returns>
        public static IstaEnrollmentService.EnrollCustomer BuildPreEnrollmentCustomer(string accountNumber, string billingAddress1, string billingAddress2, string billingCity, string billingState,
            string billingZip, string billingContact, string contactEmail, string contactPhone, string customerName, string firstName, string lastName, string LPC_Duns, string utilityDuns,
            string serviceStreet, string serviceSuite, string serviceCity, string serviceState, string serviceZip, string nameKey, string meter, string billingAccountNumber,
            string domainUser, string meterType, string utility, string appName)
        {
            var startDate = DateTime.Now;

            //build customer object
            IstaEnrollmentService.EnrollCustomer istaCustomer = new IstaEnrollmentService.EnrollCustomer();
            istaCustomer.BillingAddress1 = billingAddress1;
            istaCustomer.BillingAddress2 = billingAddress2;
            istaCustomer.BillingCity = billingCity;
            istaCustomer.BillingContact = billingContact;
            istaCustomer.BillingEmail = contactEmail;
            istaCustomer.BillingPhone = contactPhone;
            istaCustomer.BillingState = billingState;
            istaCustomer.BillingType = GetBillingType("DUAL");
            istaCustomer.BillingZip = billingZip;
            istaCustomer.CustomerAccountNumber = billingAccountNumber;
            istaCustomer.CustomerGroup = "NA";
            istaCustomer.CustomerName = customerName;

            istaCustomer.CustomerType = (IstaEnrollmentService.LibertyCustomerTypeOptions)System.Enum.Parse(typeof(IstaEnrollmentService.LibertyCustomerTypeOptions), "SMB", true);
            istaCustomer.ApplyLateFees = true;
            //istaCustomer.LateFeeRate = (decimal) 0.05;
            //SR1-2966641
            //istaCustomer.LateFeeGracePeriod = 3;
            istaCustomer.LateFeeGracePeriod = Convert.ToInt32("30");

            // SD 22422 Begin
            // Determine if the market is Texas and set the late fee to 0.05
            if (billingState.ToUpper() == "TX")
            {
                istaCustomer.LateFeeRate = (decimal)0.05;
            }
            else
            {
                istaCustomer.LateFeeRate = (decimal)0.015;
            }
            // SD 22422 End

            int iTerms = 0;

            istaCustomer.DBA = null;
            istaCustomer.FederalTaxId = null;
            istaCustomer.DigitalSignature = null;
            istaCustomer.FirstName =firstName;

            bool bTax = true;
            istaCustomer.IsTaxable = bTax;

            istaCustomer.LastName = lastName;
            istaCustomer.MiddleName = "";
            istaCustomer.ESPDuns = LPC_Duns;
            istaCustomer.TDSPDuns = utilityDuns;


            int startMonth = DateTime.Now.Month == 12 ? 1 : DateTime.Now.Month + 1;
            int startYear = startMonth == 1 ? DateTime.Now.Year + 1 : DateTime.Now.Year;
            istaCustomer.ContractStartDate = new DateTime(startYear, startMonth, 1);
            istaCustomer.ContractEndDate = new DateTime(startYear + 1, startMonth, 1);

            istaCustomer.NotificationWaiver = false;


            istaCustomer.PrintLayout = (IstaEnrollmentService.PrintLayoutOptions)System.Enum.Parse(typeof(IstaEnrollmentService.PrintLayoutOptions), "Standard");
            istaCustomer.Salutation = "";

            if (serviceState.Equals("TX", StringComparison.CurrentCultureIgnoreCase))
                istaCustomer.SubmitHURequest = true;
            else
                istaCustomer.SubmitHURequest = false;

            //build customer premise (service location) object
            IstaEnrollmentService.EnrollPremise custPremise = new IstaEnrollmentService.EnrollPremise();
            custPremise.Address1 = serviceStreet;
            custPremise.Address2 = serviceSuite;
            custPremise.City = serviceCity;
            custPremise.NameKey = nameKey;
            custPremise.EnrollmentType = ServiceHelper.GetIstaEnrollmentType("OnCycle");


            custPremise.EsiId = accountNumber;

            custPremise.LBMPID = null;

            custPremise.MeterNumber = "";
            custPremise.State = serviceState;
            decimal Tax_State = (decimal)0;
            decimal Tax_County = (decimal)0;
            decimal Tax_City = (decimal)0;
            decimal Tax_Special = (decimal)0;
            decimal Tax_PUC = (decimal)0;
            decimal Tax_GRT = (decimal)0;
            decimal Tax_Franchise = (decimal)0;

            custPremise.EnrollPremiseTaxPercentageList = ServiceHelper.GetEnrollPremiseTaxPercentageList(Tax_State, Tax_County, Tax_City, Tax_Special, Tax_PUC, Tax_GRT, Tax_Franchise);

            custPremise.BillingAccountNumber = billingAccountNumber;
            custPremise.Zip = serviceZip;

            //New California fields have been hardcoded for now.  2010-04-07
            IstaEnrollmentService.EnrollCustomerPremiseMeterServiceProvider MeterProvider = new IstaEnrollmentService.EnrollCustomerPremiseMeterServiceProvider();
            MeterProvider.OwnerDUNS = "";
            MeterProvider.InstallerDUNS = "";
            MeterProvider.ReaderDUNS = "";
            MeterProvider.MaintenanceProviderDUNS = "";
            MeterProvider.DataManagementAgentDUNS = "";
            //The duns value for BP is 625275755
            MeterProvider.SchedulingCoordinatorDUNS = "";
            MeterProvider.UsageCode = IstaEnrollmentService.UsageCodes.UNK;
            MeterProvider.PackageOption = IstaEnrollmentService.PackageOptions.BASIC;
            custPremise.MeterServiceProvider = MeterProvider;
            //End California fields.

            //'build product object
            IstaEnrollmentService.EnrollRate product = new IstaEnrollmentService.EnrollRate();
            product.PlanType = GetPlanType(0);
            product.LDCRateCode = "";
            product.EnrollRateDetailList = GetISTARateList("0", istaCustomer.ContractStartDate, istaCustomer.ContractEndDate, .1M,"0", 0M);

            //'build default product object
            //TODO: default product details are hardcoded for now.
            IstaEnrollmentService.EnrollDefaultRate defaultProduct = new IstaEnrollmentService.EnrollDefaultRate();

            defaultProduct.LDCRateCode = "";
            defaultProduct.SwitchDate = istaCustomer.ContractEndDate.AddDays(1);
            //use the enddate for the rate as the startdate for the fallback/default product
            //defaultProduct.EnrollRateDetailList = New EnrollRateDetail() {defaultRateDetail}
            defaultProduct.EnrollRateDetailList = GetISTARateList("0", istaCustomer.ContractEndDate, istaCustomer.ContractEndDate.AddYears(1), .1M, "0", 0M);

            istaCustomer.EnrollRate = product;
            istaCustomer.EnrollDefaultRate = defaultProduct;
            istaCustomer.EnrollPremise = custPremise;

            return istaCustomer;
        }

	}
}
