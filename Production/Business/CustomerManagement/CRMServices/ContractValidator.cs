using System;
using System.Linq;
using System.Collections.Generic;
using CRMBAL = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using SecurityBAL = LibertyPower.Business.CommonBusiness.SecurityManager;
using SalesChannelBAL = LibertyPower.Business.CustomerAcquisition.SalesChannel;
using ProductBAL = LibertyPower.Business.CustomerAcquisition.ProductManagement;
using PricingBAL = LibertyPower.Business.CustomerAcquisition.DailyPricing;
using UtilityBAL = LibertyPower.Business.MarketManagement.UtilityManagement;
using EFDal = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.Business.CustomerManagement.AccountManagement;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.Business.CustomerAcquisition.DailyPricing;
using LibertyPower.Business.CustomerManagement.CRMServices.CustomPriceServiceReference;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CustomerAcquisition.SalesChannel;

namespace LibertyPower.Business.CustomerManagement.CRMServices
{
	/// <summary>
	/// This class is the main validation engine for contract submission, it requires 3 inputs and to add validation just add a new private function and in the function
	/// you can interact with the contract, customer and user classes to do the validation.
	/// All functions need to return bool and any errors need to be added in the error list. 
	/// Once you are done with the function, add it to the main validation function called:
	/// AreContractSubmissionBusinessRulesValid
	/// 
	/// </summary>
	public partial class ContractValidator
	{
		#region Fields

		private CRMBAL.Customer customer;
		private CRMBAL.Contract contract;
		///Bug 7839: 1-64232573 Contract Amendments
		///Amendment Added on June 17 2013
		private CRMBAL.Contract existingContract;
		private SecurityBAL.User user;
		private List<CRMBAL.GenericError> errors;

		#endregion

		#region Properties

		public List<CRMBAL.GenericError> CurrentErrors
		{
			get
			{
				return this.errors;
			}
		}

		public bool HasErrors
		{
			get
			{
				return this.errors.Count > 0;
			}
		}

		#endregion

		#region Constructors

		private ContractValidator()
		{
			this.errors = new List<CRMBAL.GenericError>();
		}

		public ContractValidator( CRMBAL.Customer customer, CRMBAL.Contract contract, SecurityBAL.User enrollmentSpecialist )
			: this()
		{
			this.customer = customer;
			this.contract = contract;
			this.user = enrollmentSpecialist;
		}

		///Bug 7839: 1-64232573 Contract Amendments
		///Amendment Added on June 17 2013
		public ContractValidator( CRMBAL.Customer customer, CRMBAL.Contract contract, CRMBAL.Contract existingContract, SecurityBAL.User enrollmentSpecialist )
			: this()
		{
			this.customer = customer;
			this.contract = contract;
			this.existingContract = existingContract;
			this.user = enrollmentSpecialist;
		}

		#endregion

		#region Standard Methods

		public void ClearErrorHistory()
		{
			this.errors.Clear();
		}

		/// <summary>
		/// Validates all rules in the contract
		/// </summary>
		/// <returns></returns>
		public bool IsContractSubmissionValid()
		{
			this.ClearErrorHistory();
			if( this.IsClassStructureValid() &&
				this.AreContractSubmissionRequiredFieldsValid() &&
				this.AreContractSubmissionBusinessRulesValid() )
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		/// <summary>
		/// Validates that the basic class structure has some minimal values, checks for nulls
		/// </summary>
		/// <returns>True if there are no errors</returns>
		public bool IsClassStructureValid()
		{
			if( this.IsRequiredClassStructureValid() )
			{
				this.IsAdditionalRequiredClassStructureValid();
			}
			return !this.HasErrors;
		}

		/// <summary>
		/// This validation mostly run the "IsValid" Procedure for most classes to do a surface check of basic values,
		/// You shouldnt be here in the regular bases
		/// </summary>
		/// <returns></returns>
		public bool AreContractSubmissionRequiredFieldsValid()
		{
			if( this.HasErrors )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 10, Message = "ValidateContractSubmissionRequiredFields: clear previous errors before this validation step" } );
				return !this.HasErrors;
			}
			errors.AddRange( contract.IsValid() );
			//TODO: review if this makes sense to remove the isvalid of the customer
			// errors.AddRange( customer.IsValid() );
			//if( errors.Count > 0 )
			//{
			//    return !this.HasErrors;
			//}

			foreach( CRMBAL.AccountContract ac in contract.AccountContracts )
			{
				errors.AddRange( ac.IsValid() );

				if( ac.Account != null )
				{
					//TODO: Review this, was removed because of the address change, needs to be here?
					//errors.AddRange( ac.Account.IsValid() );
					// Check if utility Id is set for the contract submission, this needs to be checked here
					if( !ac.Account.UtilityId.HasValue )
					{
						errors.Add( new CRMBAL.GenericError() { Code = 10, Message = "Account.UtilityId is required" } );
					}

					if( ac.Account.AccountUsages != null )
					{
						foreach( CRMBAL.AccountUsage usage in ac.Account.AccountUsages )
						{
							errors.AddRange( usage.IsValid() );
						}
					}
				}

				if( ac.AccountContractCommission != null )
				{
					errors.AddRange( ac.AccountContractCommission.IsValid() );
				}

				if( ac.AccountStatus != null )
				{
					errors.AddRange( ac.AccountStatus.IsValid() );
				}

				if( ac.AccountContractRates != null )
				{
					foreach( CRMBAL.AccountContractRate rate in ac.AccountContractRates )
					{
						errors.AddRange( rate.IsValid() );
					}
				}
			}

			return !this.HasErrors;
		}

		/// <summary>
		/// This validation is a second level structural validation.
		/// It relies in the fact that some of the basic structure has been tested so that it can query other structure validation .
		/// It also relies in the fact that SET DEFAULT VALUES function has been called thus generating necessary default information based on the deal
		/// based on fields objects that have been checked already 
		/// </summary>
		/// <returns></returns>
		private bool IsAdditionalRequiredClassStructureValid()
		{
			if( this.HasErrors )
			{
				return this.HasErrors;
			}
			// There should be a customer preferences records in the DB, so its not required when is not a new deal
			if( this.contract.ContractDealType == CRMBAL.Enums.ContractDealType.New )
			{
				if( customer.Preferences == null )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing Customer Preference object from Customer" } );
				}

				foreach( CRMBAL.AccountContract ac in contract.AccountContracts )
				{
					//TODO: Check this logic , why are they not required ?
					// Commissions and Rates  only required when doing new deals ?
					if( ac.AccountContractCommission == null )
					{
						errors.Add( new CRMBAL.GenericError() { Code = 2, Message = "Missing Commission Object from Account Contract" } );
					}

					if( ac.AccountContractRates == null || ac.AccountContractRates.Count == 0 )
					{
						errors.Add( new CRMBAL.GenericError() { Code = 2, Message = "Missing Rate Objects from Account Contract" } );
					}
				}
			}
			return !this.HasErrors;
		}

		/// <summary>
		/// Checks that the objects are not null and the structure graph is valid
		///  GRaph should be:
		///   Contract 
		///             ---> AccountContracts
		///                                     ---> Account
		///                                                     ---> AccountDetail
		///                                                     ---> BillingAddress
		///                                                     ---> ServiceAddress
		///                                                     ---> BillingContact
		///                                     ---> AccountCommission
		///                                     ---> AccountContractRates
		///                                     ---> AccountStatus
		///                                     
		/// Customer
		///         ---> CustomerAddress
		///         ---> Contact
		///         ---> CustomerPreference
		/// </summary>
		/// <returns></returns>
		private bool IsRequiredClassStructureValid()
		{
			if( contract == null )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing Contract object" } );
			}
			else
			{
				if( contract.AccountContracts == null )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing AccountsContracts, contract doesnt have accounts associated" } );
				}
				else
				{
					foreach( CRMBAL.AccountContract accountContract in contract.AccountContracts )
					{
						if( accountContract.Account == null )
						{
							errors.Add( new CRMBAL.GenericError() { Code = 2, Message = "Missing Account Object in contract.AccountContract" } );
						}
						else
						{
							if( accountContract.Account.ServiceAddress == null )
							{
								errors.Add( new CRMBAL.GenericError() { Code = 2, Message = "Missing Account.ServiceAddress Object in contract.AccountContract" } );
							}
							if( accountContract.Account.BillingAddress == null )
							{
								errors.Add( new CRMBAL.GenericError() { Code = 2, Message = "Missing Account.BillingAddress Object in contract.AccountContract" } );
							}
							if( accountContract.Account.BillingContact == null )
							{
								errors.Add( new CRMBAL.GenericError() { Code = 2, Message = "Missing Account.BillingContact Object in contract.AccountContract" } );
							}
						}
					}
				}
			}

			if( user == null )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "User object is null" } );
			}


			if( customer == null )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing Customer object" } );
			}
			else
			{
				if( customer.CustomerAddress == null )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing prospect Customer.CustomerAddress Object" } );
				}

				if( customer.Contact == null )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing prospect Customer.Contact Object" } );
				}
			}

			return !this.HasErrors;
		}

		#endregion

		#region ADD VALIDATION RULES HERE

		/// <summary>
		/// Pure business rules validator, main class for all business rules validation.
		/// Here, we have the flexibility to do complex business rule checking accross multiple objects.
		/// We can assume that the graph object structure is valid and the required fields are also checked for existence
		/// </summary>
		/// <returns></returns>
		public bool AreContractSubmissionBusinessRulesValid()
		{
			if( this.HasErrors )
			{
				//errors.Add( new CRMBAL.GenericError() { Code = 10, Message = "ValidateContractSubmissionBusinessRules: clear previous errors before this validation step" } );
				return !this.HasErrors;
			}

			if( contract.ContractTypeId == (int) CRMBAL.Enums.ContractType.EDI ) // contract.ContractType != "POLR" && contract.ContractType != "POWER MOVE" )
			{
				// EDI type accounts need no  validation?
				return !this.HasErrors;
			}

			if( contract.AccountContracts.Count < 1 )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "At least 1 account must exist" } );
				return !this.HasErrors;
			}

			#region Space to put new validation rules

			if( !ValidateUserRoles() )
			{
				return !this.HasErrors;
			}

            if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal || contract.ContractDealType == CRMBAL.Enums.ContractDealType.RolloverRenewal)
			{
				if( !this.IsValidRenewal() )
				{
					return !this.HasErrors;
				}
            }
            if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal)
            {
				//Get the minimum contract Renewal start Date

				////Check Rates for renewal Added Sept 03 2013
				//if (!CheckRenewalRateDates(contract))
				//{
				//    return !this.HasErrors;
				//}

				///Add Logic for Sales Channel
				if( !UserHasSalesChannelAccessforRenewals() )
					return !this.HasErrors;
			}
			//validation for contract Amendment- both the sales Channel should be the same
			///Bug 7839: 1-64232573 Contract Amendments
			///Amendment Added on June 17 2013
			else if( contract.ContractDealType == CRMBAL.Enums.ContractDealType.Amendment )
			{
				if( !IsContractAmendmentValuesValid() )
				{
					return false;
				}
			}

            this.ValidateClientApplicationKey();

			//This for each can be used to run validation on a per account basis, but is not limited to that
			foreach( CRMBAL.AccountContract ac in contract.AccountContracts )
			{
				// Check if the Accounts need to have additional info saved:
				this.AreAccountUtilityRulesValid( ac );

				this.ValidateSOHOTaxIdRequired( ac );

				//Validate Account Info
				this.AreAccountInfoFieldsValid( ac );

				if( ac.Account.IsTexasAccount() )
				{
					this.AreAccountTexasUtilityRulesValid( ac );
				}

				this.AreRateRulesValid( ac );

				this.AreMultiTermRateRulesValid( ac );

				this.ValidateNJMinimunRate( ac );
							
                if (contract.ContractDealType == CRMBAL.Enums.ContractDealType.Renewal || contract.ContractDealType == CRMBAL.Enums.ContractDealType.RolloverRenewal)
				{
					this.IsAccountCurrentlyNotInRenewalUnderDifferentContract( ac );
                    this.CheckAccountEligibilityForContractStart( ac );
                    this.CheckRenewalRateDates( ac );
				}

				//ValidatePromotionCodes
				//Sept 25 2013  PBI 20711
				this.ValidatePromotionCodes( ac );

                this.AccountHasValidOrigin( ac );

                this.IsAccountInDoNotEnrollList(ac);
			}

			if( contract.ContractDealType == CRMBAL.Enums.ContractDealType.New )
			{
				this.AreNewContractRulesValid();
			}

			this.CheckAccountMeters();

			this.CheckDuplicateAccounts();

			this.IsWorkflowAvailableForContract();

			if( this.contract.AccountContracts[0].AccountContractRates[0].Price.ProductBrand.IsCustom )
				this.IsCustomDealValid();

			#endregion Space to put new validation rules

			return !this.HasErrors;
		}

		#region Validation Functions

		private bool AreAccountInfoFieldsValid( CRMBAL.AccountContract accountContract )
		{
			if( this.HasErrors )
			{
				//errors.Add( new CRMBAL.GenericError() { Code = 10, Message = "ValidateAccountInfoFields: clear previous errors before this validation step" } );
				return !this.HasErrors;
			}

			if( !accountContract.Account.HasRequiredAdditionalFields() )
			{
				return !this.HasErrors;
			}

			List<CRMBAL.UtilityRequiredData> requiredUtilityData = CRMBAL.CRMBaseFactory.GetUtilityRequiredData( accountContract.Account.Utility.Code );
			string fields = "";
			// The utility requires additional fields
			if( accountContract.Account.AccountInfo == null )
			{
				requiredUtilityData.ForEach( f => fields += f.AccountInfoField + ", " );
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information fields : " + fields + " for account: " + accountContract.Account.AccountNumber } );
			}
			else
			{
				//at least the object was sent, check now:
				foreach( var item in requiredUtilityData )
				{
					switch( item.AccountInfoField.Trim() )
					{
						case "name_key":
							if( string.IsNullOrEmpty( accountContract.Account.AccountInfo.NameKey ) )
								errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information field " + item.AccountInfoField.Trim() + " for account: " + accountContract.Account.AccountNumber } );
							break;
						case "BillingAccount":
							if( string.IsNullOrEmpty( accountContract.Account.AccountInfo.BillingAccount ) )
								errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information field " + item.AccountInfoField.Trim() + " for account: " + accountContract.Account.AccountNumber } );
							break;
						case "MeterDataMgmtAgent":
							if( string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterDataMgmtAgent ) )
								errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information field " + item.AccountInfoField.Trim() + " for account: " + accountContract.Account.AccountNumber } );
							break;
						case "MeterServiceProvider":
							if( string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterServiceProvider ) )
								errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information field " + item.AccountInfoField.Trim() + " for account: " + accountContract.Account.AccountNumber } );
							break;
						case "MeterInstaller":
							if( string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterInstaller ) )
								errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information field " + item.AccountInfoField.Trim() + " for account: " + accountContract.Account.AccountNumber } );
							break;
						case "MeterReader":
							if( string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterReader ) )
								errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information field " + item.AccountInfoField.Trim() + " for account: " + accountContract.Account.AccountNumber } );
							break;
						case "MeterOwner":
							if( string.IsNullOrEmpty( accountContract.Account.AccountInfo.MeterOwner ) )
								errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information field " + item.AccountInfoField.Trim() + " for account: " + accountContract.Account.AccountNumber } );
							break;
						case "SchedulingCoordinator":
							if( string.IsNullOrEmpty( accountContract.Account.AccountInfo.SchedulingCoordinator ) )
								errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing additional account information field " + item.AccountInfoField.Trim() + " for account: " + accountContract.Account.AccountNumber } );
							break;
					}
				}
			}
			return !this.HasErrors;
		}

		private bool AreNewContractRulesValid()
		{
			// These rules require no previous errors.
			if( this.HasErrors )
			{
				//removed message since it doesnt add more value to the end user
				// errors.Add( new CRMBAL.GenericError() { Code = 10, Message = "ValidateNewContractRules: clear previous errors before this validation step" } );
				return !this.HasErrors;
			}

			if( contract.SignedDate < DateTime.Today.AddDays( -365 ) || contract.SignedDate > DateTime.Now )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "SignedDate is out of range" } );
			}
			// make sure that contract complies with rules:

			if( !this.AreNewAccountRulesValid() )
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "New customer contract has invalid accounts" } );

			return !this.HasErrors;
		}

		private bool AreAccountUtilityRulesValid( CRMBAL.AccountContract acc )
		{
			if( acc.Account.Utility.Code == "CMD" && (acc.Account.AccountNumber.Length <= 13 || !acc.Account.AccountNumber.StartsWith( "0" )) )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "CMD AccountNumber needs start  with 0" } );
			}

			if( acc.Account.Utility.AccountNumberLength > 0 && acc.Account.AccountNumber.Length != acc.Account.Utility.AccountNumberLength )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "AccountNumber has an invalid length" } );
			}

			if( !string.IsNullOrEmpty( acc.Account.Utility.AccountNumberPrefix ) && acc.Account.Utility.AccountNumberPrefix != "0" && !acc.Account.AccountNumber.StartsWith( acc.Account.Utility.AccountNumberPrefix ) )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "AccountNumber has an invalid prefix" } );
			}

			return !this.HasErrors;
		}

		private bool AreAccountTexasUtilityRulesValid( CRMBAL.AccountContract acc )
		{
			// Removed this validation due to ticket # 1-51015991, need to follow up to see why we were restricting accounts to be entered like this
			//if( (acc.Account.Details.EnrollmentType != CRMBAL.Enums.EnrollmentType.Standard) )
			//{
			//    errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Invalid enrollment type. Cannot enroll Texas Accounts that are not Enrollment Type Standard" } );
			//}

			if( acc.RequestedStartDate == null )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "RequestedStartDate can't be null for TX accounts" } );
				return !this.HasErrors;
			}
			if( acc.RequestedStartDate.Value.DayOfWeek == DayOfWeek.Sunday || acc.RequestedStartDate.Value.DayOfWeek == DayOfWeek.Saturday )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "RequestedStartDate is not a business day" } );
			}
			if( acc.Account.Details.EnrollmentType == CRMBAL.Enums.EnrollmentType.StandardFutureMonth )
			{
				if( Convert.ToDateTime( acc.RequestedStartDate.Value.ToString( "MM/" ) + "01/" + acc.RequestedStartDate.Value.ToString( "yyyy" ) ) <
				Convert.ToDateTime( DateTime.Today.AddMonths( 1 ).ToString( "MM/" ) + "01/" + DateTime.Today.AddMonths( 1 ).ToString( "yyyy" ) ) ||
				Convert.ToDateTime( acc.RequestedStartDate.Value.ToString( "MM/" ) + "01/" + acc.RequestedStartDate.Value.ToString( "yyyy" ) ) >
				Convert.ToDateTime( DateTime.Today.AddMonths( 12 ).ToString( "MM/" ) + "01/" + DateTime.Today.AddMonths( 1 ).ToString( "yyyy" ) ) )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "RequestedStartDate must be between 1 and 12 months in future" } );
				}
			}
			if( acc.Account.Details.EnrollmentType == CRMBAL.Enums.EnrollmentType.MoveInCurrentlyDeenergized )
			{
				DateTime aux = DateTime.Today;
				DateTime aux2 = DateTime.Today;

				if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Sunday )
					aux = DateTime.Today.AddDays( 4 );
				else if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Saturday )
					aux = DateTime.Today.AddDays( 5 );
				else
					aux = DateTime.Today.AddDays( 3 );

				if( DateTime.Today.AddDays( 60 ).DayOfWeek == DayOfWeek.Sunday )
					aux2 = DateTime.Today.AddDays( 58 );
				else if( DateTime.Today.AddDays( 60 ).DayOfWeek == DayOfWeek.Saturday )
					aux2 = DateTime.Today.AddDays( 59 );
				else
					aux2 = DateTime.Today.AddDays( 60 );

				if( acc.RequestedStartDate.Value < aux || acc.RequestedStartDate.Value > aux2 )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "RequestedStartDate requires three days notice for MVI-Energized" } );
				}
			}

			if( acc.Account.Details.EnrollmentType == CRMBAL.Enums.EnrollmentType.OffcyclePriority )
			{
				DateTime aux = DateTime.Today;
				if( DateTime.Today.AddDays( 5 ).DayOfWeek == DayOfWeek.Sunday )
					aux = DateTime.Today.AddDays( 6 );
				else if( DateTime.Today.AddDays( 3 ).DayOfWeek == DayOfWeek.Saturday )
					aux = DateTime.Today.AddDays( 7 );
				else
					aux = DateTime.Today.AddDays( 5 );
				if( acc.RequestedStartDate.Value < aux )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "RequestedStartDate not valid for today's transaction" } );
				}

				if( DateTime.Today.AddDays( 14 ).DayOfWeek == DayOfWeek.Sunday )
					aux = DateTime.Today.AddDays( 19 );
				else
					aux = DateTime.Today.AddDays( 18 );

				if( acc.RequestedStartDate.Value > aux )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "RequestedStartDate must be between" } );
				}
			}

			if( acc.Account.Details.EnrollmentType == CRMBAL.Enums.EnrollmentType.SelfSelected )
			{
				DateTime aux = DateTime.Today;
				if( DateTime.Today.AddDays( -15 ).DayOfWeek == DayOfWeek.Sunday )
					aux = DateTime.Today.AddDays( -20 );
				else if( DateTime.Today.AddDays( -15 ).DayOfWeek == DayOfWeek.Monday )
					aux = DateTime.Today.AddDays( -21 );
				else
					aux = DateTime.Today.AddDays( -19 );
				if( acc.RequestedStartDate.Value < aux )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "RequestedStartDate for offcycle switch must be at least 15 days in future" } );
				}
			}
			return !this.HasErrors;
		}

		private bool AreNewAccountRulesValid()
		{
			if( this.HasErrors )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 10, Message = "ValidateNewAccountRules: clear previous errors before this validation step" } );
				return !this.HasErrors;
			}

			foreach( CRMBAL.AccountContract acc in this.contract.AccountContracts )
			{
				if( CRMBAL.AccountFactory.IsAccountNumberInTheSystem( acc.Account.AccountNumber, acc.Account.UtilityId.Value ) )
				{
					if( CRMBAL.AccountFactory.IsAccountActive( acc.Account.AccountNumber, acc.Account.UtilityId.Value ) )
						errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Account: " + acc.Account.AccountNumber + " already exists in system" } );
				}
			}
			return !this.HasErrors;
		}

		private bool AreRateRulesValid( CRMBAL.AccountContract acc )
		{
			double historicalRate = 0;
			foreach( CRMBAL.AccountContractRate acr in acc.AccountContractRates )
			{
				historicalRate = (Double) acr.Price.Price;
				if( acr.Rate < historicalRate && acr.Price.ProductBrand.Category == ProductBAL.ProductCategory.Fixed && !acc.Account.RetailMarket.Code.ToUpper().Equals( "NJ" ) )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Rate is invalid" } );
				}
				double customCap = 0.035;
				// var rate = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.
				using( EFDal.LpDealCaptureEntities dal = new EFDal.LpDealCaptureEntities() )
				{
					//var tableCap = dal.deal_rate.FirstOrDefault();
					//if (tableCap != null)
					customCap = 0.035;
				}

				if( (acr.Rate > historicalRate + customCap) && acr.Price.ProductBrand.IsFlexible )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Rate is too high" } );
				}
                //if( acr.Rate < historicalRate)
                //{
                //    errors.Add(new CRMBAL.GenericError() { Code = 1, Message = "The contract rate " + acr.Rate + " is lower than the transfer rate " + historicalRate  });
                //}

                LibertyPower.Business.MarketManagement.UtilityManagement.Utility utility = UtilityFactory.GetUtilityById((int)acc.Account.UtilityId);
                CrossProductPriceSalesChannel price = DailyPricingFactory.GetPrice((long)acr.PriceId);
                var sales = SalesChannelFactory.GetSalesChannel((int)acc.Contract.SalesChannelId);
                
                if (!price.ProductBrand.IsCustom && utility.RateCodeRequired == "1")
                {
                    var lstDailyPrice = DailyPricingFactory.GetSalesChannelPrices(sales, acc.Contract.SignedDate, (int)acc.Account.RetailMktId, (int)acc.Account.UtilityId, (int)acc.Account.AccountTypeId, (int)price.ProductBrand.ProductBrandID, (int)price.Term);

                    var lstPrice = lstDailyPrice.Select(p => p.Price == (decimal)acr.Rate).ToList();

                    if (lstPrice == null || lstPrice.Count == 0)
                    {
                        errors.Add(new CRMBAL.GenericError() { Code = 1, Message = "Rate is invalid for Rate Code Utility" });
			}
                }
			}
			return !this.HasErrors;
		}

		private bool IsAccountCurrentlyNotInRenewalUnderDifferentContract( CRMBAL.AccountContract accountContract )
		{
			if( this.HasErrors )
			{
				//errors.Add( new CRMBAL.GenericError() { Code = 10, Message = "ValidateAccountInfoFields: clear previous errors before this validation step" } );
				return !this.HasErrors;
			}

            int utilityId = 0;
            if (accountContract.Account.UtilityId != null && accountContract.Account.UtilityId > 0)
			{
                utilityId = Convert.ToInt16(accountContract.Account.UtilityId);
            }

			if( CRMBAL.AccountFactory.IsAccountCurrentlyInRenewalUnderDifferentContract( accountContract.Account.AccountNumber, utilityId ) )
			{
                CRMBAL.Account account = CRMBAL.AccountFactory.GetAccountWithContracts(Convert.ToInt32(accountContract.Account.AccountId));
                if (account != null && account.CurrentRenewalContractId != null)
                {
                    CRMBAL.Contract contract = CRMBAL.ContractFactory.GetContract(Convert.ToInt32(account.CurrentRenewalContractId), true);

                    if (!(contract.ContractDealTypeId.HasValue && contract.ContractDealTypeId == Convert.ToInt32(CRMBAL.Enums.ContractDealType.RolloverRenewal)))
                        errors.Add(new CRMBAL.GenericError() { Code = 1, Message = accountContract.Account.AccountNumber + " is in renewal process under different contract number" });
                }
			}

			return !this.HasErrors;
		}

		private bool IsValidRenewal()
		{
			if( this.HasErrors )
			{
				return !this.HasErrors;
			}

			foreach( CRMBAL.AccountContract acc in this.contract.AccountContracts )
			{
				//if the account already exists in the system , then it ashould be active else it is okay
				if( CRMBAL.AccountFactory.IsAccountNumberInTheSystem( acc.Account.AccountNumber, acc.Account.UtilityId.Value ) )
				{
					if( CRMBAL.AccountFactory.IsAccountActive( acc.Account.AccountNumber, acc.Account.UtilityId.Value ) )
						return true;
				}
				else //Else added on Aug 08 2013  renewals validation when new account is added
					return true;
			}

			errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "The renewal contract does not have valid accounts to be renewed" } );

			return !this.HasErrors;
		}

		private bool CheckAccountMeters()
		{
			foreach( var accounts in this.contract.AccountContracts.Select( s => s.Account ) )
			{
				if( accounts.MeterNumbers != null && accounts.MeterNumbers.Count > 0 )
				{
					foreach( var meter in accounts.MeterNumbers )
					{
						if( string.IsNullOrEmpty( meter ) )
							this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Meter numbers cannot be empty or null" } );
					}
				}
			}
			return !this.HasErrors;
		}
        
        private bool ValidateClientApplicationKey()
        {
            bool retVal = false;
			if( contract.ClientSubmitApplicationKey.HasValue )
            {
				using( EFDal.LibertyPowerEntities dal = new EFDal.LibertyPowerEntities() )
                {
                    IQueryable<ClientSubmitApplicationKey> applicationKeyDetails = dal.ClientSubmitApplicationKeys
						.Where( f => f.ApplicationKey == contract.ClientSubmitApplicationKey.Value );
					if( applicationKeyDetails.Count() > 0 )
                    {
                        retVal = true;
                    }
                    else
                    {
						this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Please provide a valid ClientApplicationKey." } );
                    }

                }
            }
            else
            {
				this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Missing ClientSubmitApplicationKey" } );
             
            }
            return retVal;
        }
		
        private bool CheckDuplicateAccounts()
		{
			//get the count of each account 
			var accountCount = from a in contract.AccountContracts
							   group a by a.Account.AccountNumber into g
							   select new { Account = g.Key, Count = g.Count() };

			//get the list of counts that are greater than 1
			var ct = from c in accountCount
					 where c.Count > 1
					 select c.Count;

			//if the count is > 1, then we have duplicates account, therefore throw an error
			if( ct != null && ct.Count() > 0 )
				this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Contract has duplicate accounts" } );

			return !this.HasErrors;
		}

		private bool IsWorkflowAvailableForContract()
		{
			int utilityId = (int) this.contract.AccountContracts[0].Account.UtilityId;
			int marketId = (int) this.contract.AccountContracts[0].Account.RetailMktId;
			int contractTypeId = (int) this.contract.ContractTypeId;
			int contractDealTypeId = (int) this.contract.ContractDealTypeId;
			int contractTemplateTypeId = (int) this.contract.ContractTemplateId;

			bool isWorkflowQueueAvailable = false;
			using( LibertyPowerEntities dal = new LibertyPowerEntities() )
			{
				var result = dal.usp_IsWorkflowQueueAvailable( utilityId, marketId, contractTypeId, contractDealTypeId, contractTemplateTypeId );
				if( result != null )
					isWorkflowQueueAvailable = Convert.ToBoolean( (int) result.First() );
			}

			if( !isWorkflowQueueAvailable )
				this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "There is no workflow available for the contract" } );

			return !this.HasErrors;
		}

		#region Multi-Term Validation

		private bool AreMultiTermRateRulesValid( CRMBAL.AccountContract accountContract )
		{
			AreMultiTermRatesValid( accountContract );

			AreMultiTermTermsValid( accountContract );

			AreMultiTermDatesFlushWithThemselves( accountContract );

			AreMultiTermDatesFlushWithContractDate( accountContract );

			return !this.HasErrors;
		}

		private bool AreMultiTermRatesValid( CRMBAL.AccountContract accountContract )
		{
			//commented toggle
			//foreach( CRMBAL.AccountContractRate accountContractRate in accountContract.AccountContractRates )
			//{
			//    if( accountContractRate.Price.ProductBrand.IsMultiTerm )
			//    {
			//        foreach( PricingBAL.MultiTerm multiTerm in accountContractRate.Price.MultiTermList )
			//        {
			//            if( multiTerm.ProductCrossPriceMultiID == accountContractRate.ProductCrossPriceMultiID )
			//            {
			//                if( accountContractRate.Price.ProductBrand.IsABC )
			//                {
			//                    if( ((decimal) accountContractRate.Rate.Value) < multiTerm.Price )
			//                    {
			//                        errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "The rate submitted by an ABC [" + accountContractRate.Rate.ToString() + "] must be greater than or equal to the transfer rate [" + multiTerm.Price.ToString() + "]" } );
			//                        break;
			//                    }
			//                }
			//                else // Telesales
			//                {
			//                    if( ((decimal) accountContractRate.Rate.Value) != multiTerm.Price )
			//                    {
			//                        errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "The rate submitted by telesales [" + accountContractRate.Rate.ToString() + "] must be equal to the transfer rate [" + multiTerm.Price.ToString() + "]" } );
			//                        break;
			//                    }
			//                }
			//            }
			//        }
			//    }
			//}

			return !this.HasErrors;
		}

		private bool AreMultiTermTermsValid( CRMBAL.AccountContract accountContract )
		{
			foreach( CRMBAL.AccountContractRate accountContractRate in accountContract.AccountContractRates )
			{
				//Multiterm commented
				//if( accountContractRate.Price.ProductBrand.IsMultiTerm )
				//{
				//    if( accountContractRate.Term != accountContractRate.MultiTerm.Term )
				//    {
				//        errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Multi-term rates do not match AccountContractRates" } );
				//    }
				//}
			}
			return !this.HasErrors;
		}

		private bool AreMultiTermDatesFlushWithThemselves( CRMBAL.AccountContract accountContract )
		{
			// Sort ACRs by starting date
			List<CRMBAL.AccountContractRate> accountContractRatesSortedByStartDate = (accountContract.AccountContractRates).OrderBy( ohhhBilly => ohhhBilly.RateStart ).ToList();

			if( accountContractRatesSortedByStartDate.Count > 0 )
			{
				// Set a dummy valid match for the first previousEndingDate
				DateTime previousEndingDate = accountContractRatesSortedByStartDate[0].RateStart.AddDays( -1 ).Date;
				DateTime currentStartingDate;
				// commented multiterm
				//foreach( CRMBAL.AccountContractRate accountContractRate in accountContractRatesSortedByStartDate )
				//{
				//    if( accountContractRate.Price.ProductBrand.IsMultiTerm )
				//    {
				//        currentStartingDate = accountContractRate.RateStart.Date;

				//        if( currentStartingDate.AddDays( -1 ) != previousEndingDate )
				//        {
				//            errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Multi-term sub terms are not flush with each other" + "currentStartingDate: " + currentStartingDate.ToShortDateString() + " previousEndingDate" + previousEndingDate.ToShortDateString() } );
				//            break;
				//        }

				//        previousEndingDate = accountContractRate.RateEnd.Date;
				//    }
				//}

			}
			return !this.HasErrors;

		}

		private bool AreMultiTermDatesFlushWithContractDate( CRMBAL.AccountContract accountContract )
		{
			bool isMultiTerm = false;

			DateTime contractStartDate = accountContract.Contract.StartDate;
			DateTime contractEndDate = accountContract.Contract.EndDate;

			DateTime startOfFirstSubTerm = DateTime.MaxValue;
			DateTime endOfLastSubTerm = DateTime.MinValue;

			//foreach( CRMBAL.AccountContractRate accountContractRate in accountContract.AccountContractRates )
			//{
			//    if( accountContractRate.Price.ProductBrand.IsMultiTerm )
			//    {
			//        isMultiTerm = true;

			//        if( accountContractRate.RateStart < startOfFirstSubTerm )
			//        {
			//            startOfFirstSubTerm = accountContractRate.RateStart;
			//        }

			//        if( accountContractRate.RateEnd > endOfLastSubTerm )
			//        {
			//            endOfLastSubTerm = accountContractRate.RateEnd;
			//        }
			//    }
			//}

			if( isMultiTerm )
			{
				if( startOfFirstSubTerm.Date != contractStartDate.Date )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "The start date of the first sub term must equal the start of the contract" } );
				}

				if( endOfLastSubTerm.Date != contractEndDate.Date )
				{
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "The end date of the last sub term must equal the end of the contract" } );
				}
			}

			return !this.HasErrors;
		}

		#endregion Multi-Term Validation

		private bool ValidateUserRoles()
		{
			SalesChannelBAL.SalesChannel sc = contract.SalesChannel;
			if( sc == null )
			{
				sc = SalesChannelBAL.SalesChannelFactory.GetSalesChannel( contract.SalesChannelId.Value );
			}

			if( !AccountManagement.ContractValidation.CheckRole( user.Username, sc.ChannelName ) &&
				!AccountManagement.ContractValidation.CheckRole( user.Username, "LibertyPowerSales" ) )
			{
				string msg = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.AccountDal.SelectMessage( LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.LpMessageApplication.DEAL, "00000004" );
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = msg } );
			}
			return !this.HasErrors;
		}

		private bool ValidateSOHOTaxIdRequired( CRMBAL.AccountContract ac )
		{
			if( ac.Account.AccountType == CRMBAL.Enums.AccountType.SOHO && String.IsNullOrEmpty( this.customer.TaxId ) )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "TaxID is required for SOHO accounts" } );
			}
			return !this.HasErrors;
		}

        /// <summary>
        /// Checks if the rate start matches the month and year of the contract start date
        /// Since the calculation of the correct value for the rate start is being performed, we
        /// need to make sure it matches the contract start date
        /// Bug 36897
        /// </summary>
        /// <param name="ac"></param>
		private void CheckAccountEligibilityForContractStart( CRMBAL.AccountContract ac )
        {
			DateTime minStartDate = ac.AccountContractRates.Min( m => m.RateStart );

            //For now, we are allowing the rate start date to be either on the same month of the contract start,
            //1 month ahead or 1 month in the past.
            //This needs to be changed once the next readcycle is being correctly calculated
			DateTime minStartDateAdjustedForReadCycleFuture1 = minStartDate.AddMonths( 1 );
			DateTime minStartDateAdjustedForReadCyclePast1 = minStartDate.AddMonths( -1 );
			DateTime minStartDateAdjustedForReadCycleFuture2 = minStartDate.AddMonths( 2 );
			DateTime minStartDateAdjustedForReadCyclePast2 = minStartDate.AddMonths( -2 );

			if( !(ac.Contract.StartDate.Month == minStartDate.Month && ac.Contract.StartDate.Year == minStartDate.Year)
                && !(ac.Contract.StartDate.Month == minStartDateAdjustedForReadCycleFuture1.Month && ac.Contract.StartDate.Year == minStartDateAdjustedForReadCycleFuture1.Year)
                && !(ac.Contract.StartDate.Month == minStartDateAdjustedForReadCyclePast1.Month && ac.Contract.StartDate.Year == minStartDateAdjustedForReadCyclePast1.Year)
            && !(ac.Contract.StartDate.Month == minStartDateAdjustedForReadCycleFuture2.Month && ac.Contract.StartDate.Year == minStartDateAdjustedForReadCycleFuture2.Year)
				&& !(ac.Contract.StartDate.Month == minStartDateAdjustedForReadCyclePast2.Month && ac.Contract.StartDate.Year == minStartDateAdjustedForReadCyclePast2.Year) )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = string.Format( "Account {0} is eligible for renewals starting on {1}, contract start date given was {2}", ac.Account.AccountNumber, minStartDate, ac.Contract.StartDate ) } );
            }

			if( ac.AccountContractRates[0].PriceId != null )
			{
				PricingBAL.CrossProductPriceSalesChannel cppsc = PricingBAL.DailyPricingFactory.GetPrice( (long) ac.AccountContractRates[0].PriceId );

			if( !(cppsc.StartDate.Month == minStartDate.Month && cppsc.StartDate.Year == minStartDate.Year)
			   && !(cppsc.StartDate.Month == minStartDateAdjustedForReadCycleFuture1.Month && cppsc.StartDate.Year == minStartDateAdjustedForReadCycleFuture1.Year)
			   && !(cppsc.StartDate.Month == minStartDateAdjustedForReadCyclePast1.Month && cppsc.StartDate.Year == minStartDateAdjustedForReadCyclePast1.Year) 
				  && !(cppsc.StartDate.Month == minStartDateAdjustedForReadCycleFuture2.Month && cppsc.StartDate.Year == minStartDateAdjustedForReadCycleFuture2.Year)
			   && !(cppsc.StartDate.Month == minStartDateAdjustedForReadCyclePast2.Month && cppsc.StartDate.Year == minStartDateAdjustedForReadCyclePast2.Year) )
			{
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = string.Format( "Account {0} is eligible for renewals starting on {1}, Price start date given was {2}", ac.Account.AccountNumber, minStartDate, cppsc.StartDate ) } );
			}
			}
        }
		
		private bool CheckRenewalRateDates( CRMBAL.AccountContract acc )
		{
			DateTime minStartDate = acc.AccountContractRates.Min( m => m.RateStart );
			//DateTime minRenewalDate = acc.Account.GetMinimumAccountRenewalStartDate();
			DateTime minRenewalDate = acc.Account.GetMinimumAccountRenewalStartDate_NEW();

			//When its a new account , we cannot find the min renewal start date. So added validation
			//Dates are valid if they are either greated than the minimum renewal start date or
			// if they start on the same month and year of the minimum date
			if( minRenewalDate != DateTime.MinValue
				&& minStartDate < minRenewalDate
				//TODO: review line after diagrams for flow start date are validated
				//&& !(minStartDate.Month == minRenewalDate.Month && minStartDate.Year == minRenewalDate.Year )
				)
			{	
					this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = string.Format( "Renewal start date for account {0} should be {1}, date given was {2}", acc.Account.AccountNumber, minRenewalDate, minStartDate ) } );
			}

			return !this.HasErrors;
		}

        private bool AccountHasValidOrigin( CRMBAL.AccountContract ac )
        {
			if( !CRMBAL.AccountFactory.IsAccountNumberInTheSystem( ac.Account.AccountNumber, (int) ac.Account.UtilityId ) )
            {
				if( String.IsNullOrEmpty( ac.Account.Origin ) )
					errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Account #" + ac.Account.AccountNumber + ": origin cannot be empty" } );
				else if( ac.Contract.ClientApplicationType == CRMBAL.Enums.ClientApplicationType.PartnerPortal )
                {
					if( !ac.Account.Origin.Equals( CRMBAL.Enums.AccountOrigin.Online.ToString(), StringComparison.InvariantCultureIgnoreCase ) &&
							!ac.Account.Origin.Equals( CRMBAL.Enums.AccountOrigin.Excel.ToString(), StringComparison.InvariantCultureIgnoreCase ) )
						errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Account #" + ac.Account.AccountNumber + ": contract application type only accepts origin to be either ONLINE or EXCEL" } );
                }
            }
            return !this.HasErrors;
        }

		private bool IsCustomDealValid()
		{
			CRMBAL.GenericError[] errorArray = new CRMBAL.GenericError[50];

			if( System.Configuration.ConfigurationManager.AppSettings["CustomPriceSvcEndPt"] == null )
				errors.Add( new CRMBAL.GenericError() { Code = 1, Message = "Unable to validate custom deal. Please see System Administrator." } );

			var CPSvc = new CustomPriceServiceClient( System.Configuration.ConfigurationManager.AppSettings["CustomPriceSvcEndPt"] );
			List<long> priceIds = (from ac in contract.AccountContracts
								   from acr in ac.AccountContractRates
								   where acr.PriceId != null
								   select Convert.ToInt64( acr.PriceId )).ToList();

			List<CRMBusinessObjects.Account> accounts = (from ac in contract.AccountContracts
														 select ac.Account).ToList();


			if( !CPSvc.ValidateCustomDealContract( out errorArray, accounts, priceIds ) )
				errors.AddRange( errorArray );

			return !this.HasErrors;

		}

        private bool IsAccountInDoNotEnrollList(CRMBAL.AccountContract ac)
        {
            if ( CRMBusinessObjects.AccountFactory.IsAccountInDoNotEnrollList( ac.Account.AccountNumber ))
            {
                errors.Add(new CRMBAL.GenericError() { Code = 1, Message = "Account #" + ac.Account.AccountNumber + ": the customer has requested not to be enrolled with Liberty Power." });
            }
            return this.HasErrors;
		}

		#region Process Contract Amendment

		/// <summary>This method checks for the validatity of the current contract and the existing contract for Amendment
		/// The Sales Channel should be same for both the contracts. 
		/// Since, we are going to ignore the new contract and save the Accounts to the old existing contract.
		/// </summary>
		/// <returns>true or false based on the validation</returns>
		public bool IsContractAmendmentValuesValid()
		{
			//Bug 7839: 1-64232573 Contract Amendments
			//Amendment Added on June 17 2013
			if( this.contract.SalesChannelId != this.existingContract.SalesChannelId )
			{
				SalesChannelBAL.SalesChannel sc = SalesChannelBAL.SalesChannelFactory.GetSalesChannel( this.existingContract.SalesChannelId.Value );
				errors.Add( new CRMBAL.GenericError() { Code = 0, Message = "The sales channel for the new contract should be " + sc.ChannelDescription } );
				return false;
			}
			return true;
		}

		#endregion

		#endregion Validation Functions

		/// <summary>
		/// For NJ, the incomming minimum allowed rate is the transfer rate plus the State's tax of 7%
		/// So we just need to check that at least the minimum allowed rate is entered, this rate will be 
		/// </summary>
		/// <param name="ac"></param>
		/// <returns></returns>
		private bool ValidateNJMinimunRate( CRMBAL.AccountContract ac )
        {
			if( ac.Account.RetailMarket.Code.ToUpper().Equals( "NJ" ) )
            {
				LibertyPower.Business.MarketManagement.UtilityManagement.RetailMarketSalesTax salesTax = LibertyPower.Business.MarketManagement.UtilityManagement.MarketFactory.GetMarketSalesTax( ac.Account.RetailMarket, this.contract.SignedDate );

				foreach( var subTermRate in ac.AccountContractRates )
                {
                    //Skip Validation for Telesales and Variable products, since the transfer rate and contract rate are same.
					if( subTermRate.Price.ChannelType.Identity != 1 && subTermRate.Price.ProductType.Identity != 2 )
                    {

						double minimumCorrectedRate = double.Parse( subTermRate.Price.Price.ToString() );
						minimumCorrectedRate = Math.Round( TruncateDecimal( (minimumCorrectedRate * (salesTax.SalesTax + 1)), 5 ), 5 );
						double contractRate = Math.Round( double.Parse( subTermRate.Rate.ToString() ), 5 );
						if( contractRate < minimumCorrectedRate )
                        {
							this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = string.Format( "Rate {0} is lower than the allowed rate of {1}, for NJ accounts please make sure to add the State tax of {2}% ", subTermRate.Rate, minimumCorrectedRate, (salesTax.SalesTax * 100) ) } );
                        }
                    }
                    else
                    {
                        // Skip Validation for Telesales and Variable products
                    }
                }
            }

            return !this.HasErrors;

        }
		public double TruncateDecimal( double value, int precision )
        {
			double step = (double) Math.Pow( 10, precision );
			int tmp = (int) Math.Truncate( step * value );
            return tmp / step;
        }

		#endregion ADD VALIDATION RULES HERE

		#region " Validate promotion Codes"

		//Get the Qualifiers  for the give PromoCode and determinents
		public List<CRMBAL.Qualifier> GetTheQualifiersforGivenpromoCodeandDeterminents( string PromotionCode, CRMBAL.AccountContract ac )
		{
			//Sum of the terms
			var sumofterms = (from result in ac.AccountContractRates select (result.Term)).Sum();
			long PriceId = 0;

			if( ac.AccountContractRates[0].PriceId.HasValue )
				PriceId = (long) ac.AccountContractRates[0].PriceId;
			//28372: Change ProductType to Product Brand
			// int productTypeId = ProductBAL.ProductFactory.GetProductTypeID(PriceId);
			int productBrandId = ProductBAL.ProductFactory.GetProductBrandID( PriceId );
			//Should pass the product Account TypeId and not the AccountTypeID
			//June 27 2014 Bug 43313
            //Should pass the AccountTypeID not the ProductAccountTypeID
            int? prodaccTypeID = CRMBAL.AccountTypeFactory.GetProductAccountTypeId( ac.Account.AccountTypeId.Value );
            //int? prodaccTypeID = 0; //CRMBAL.AccountTypeFactory.GetProductAccountTypeId( ac.Account.AccountTypeId.Value );
            //if (ac.Account.AccountTypeId.HasValue)
            //{
            //    prodaccTypeID = ac.Account.AccountTypeId.Value;
            //}
			int PriceTierID = PricingBAL.DailyPricingFactory.GetPriceTierID( PriceId );

			DateTime minDate = ac.AccountContractRates.Min( m => m.RateStart );

            //1-1284384471(81528) -  Added AnnualUsage - 07/28/2015 - Andre Damasceno
            int accountAnnualUsage = 0;

            CRMBAL.AccountUsage usage = new CRMBAL.AccountUsage(); 
            if (ac.AccountId.HasValue)
            {
                usage = CRMBAL.AccountFactory.GetAccountUsageByAccountIdAndEffectiveDate(ac.AccountId.Value, ac.RequestedStartDate.Value);
            }

            if (usage != null && usage.AnnualUsage != null)
            {
                accountAnnualUsage = usage.AnnualUsage.Value;
            }

			List<CRMBAL.Qualifier> qualifierlist = new List<CRMBAL.Qualifier>();
			//Found a bug that The Qualifier validation should be done against the contract Signed Date and not contract start date
			//Nov 11 2013
			//28372: Change ProductType to Product Brand
            //1-1284384471(81528) -  Added AnnualUsage - 07/28/2015 - Andre Damasceno
			qualifierlist = CRMBAL.QualifierFactory.GetQualifiersByPromotionCodeandDeterminents( PromotionCode, this.contract.SignedDate,
                 this.contract.SalesChannelId, ac.Account.RetailMktId, ac.Account.UtilityId, prodaccTypeID, sumofterms, productBrandId, PriceTierID, minDate, accountAnnualUsage);

			return qualifierlist;
		}



		private bool ValidatePromotionCodes( CRMBAL.AccountContract ac )
		{

			List<string> promotionCodes = this.contract.PromotionCodes;
			if( promotionCodes != null )
			{

				foreach( string PromotionCode in this.contract.PromotionCodes )
				{
					List<CRMBAL.Qualifier> qualifierlist = new List<CRMBAL.Qualifier>();
					qualifierlist = GetTheQualifiersforGivenpromoCodeandDeterminents( PromotionCode, ac );
					if( qualifierlist == null )
					{
						this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = string.Format( "The PromotionCode {0}  is not valid", PromotionCode ) } );
					}
				}

			}
			return !this.HasErrors;

		}

		#endregion

		#region "Renewals- Sales Channel Validation"
		//Added march 12 2014-PBI: 35278:  Add Sales Channel Renewal validation to ContractAPI

		/// <summary>
		/// Function to find if the new contract sales Channel and the current contarct sales channels are same
		/// </summary>
		/// <param name="newSalesChannelID"> takes the new contract sales channelId</param>
		/// <param name="result"> out variable returns true or false</param>
		/// <returns>List of Contract, Account, SalesChannel and Account Contract Rate product  information</returns>
		private List<CRMBAL.ContractAccountDetails> AretheSalesChannelsSameforCurrentandNewDeal( int newSalesChannelID, out bool result )
		{
			result = true;
			List<CRMBAL.ContractAccountDetails> contractList = new List<CRMBAL.ContractAccountDetails>();
			foreach( CRMBAL.AccountContract acc in this.contract.AccountContracts )
			{
				CRMBAL.ContractAccountDetails currentContractAccountDetails = new CRMBAL.ContractAccountDetails();
				currentContractAccountDetails = CRMBAL.ContractFactory.GetCurrentContractforaGivenAccountNumber( acc.Account.AccountNumber );
				if( !contractList.Any( curContract => curContract.SalesChannelId == currentContractAccountDetails.SalesChannelId ) )
					contractList.Add( currentContractAccountDetails );
			}
			var distinctSalesChannels = contractList.Select( resContract => resContract.SalesChannelId ).Distinct();
			foreach( int salesChannelid in distinctSalesChannels )
				if( salesChannelid > 0 && newSalesChannelID != salesChannelid )
					result = false;

			return contractList;
		}
		/// <summary>
		/// method to determine if the user submitted the contract is an internal user or external user.
		/// </summary>
		/// <returns> true or False</returns>
		private bool IsExternaluser()
		{
			bool result = false;
			if( this.user.UserType.ToString().ToUpper() == "EXTERNAL" )
				result = true;
			return result;
		}
		/// <summary>
		/// method to determine if the current contract sales channel is active or not
		/// </summary>
		/// <returns>true or False</returns>
		private bool IsOriginalSalesChannelActive( int SalesChannelID )
		{
			bool result = true;
			SalesChannelBAL.SalesChannel sc = new SalesChannelBAL.SalesChannel();
			sc = SalesChannelBAL.SalesChannelFactory.GetSalesChannel( SalesChannelID );
			if( sc.IsInActive )
				result = false;
			return result;
		}
		/// <summary>
		/// method holds the business rule to find if the sales channel has the rights to renew the contract
		/// 1. Checks if the user is an external user
		/// 2. Checks if the Current contract sales channel and the new contract sales channels are different
		/// 3. Checks if the original sales channel is Active
		/// 4. Checks if the contract is in default variable and in 30 day period of the end date of the current contract
		/// </summary>
		/// <returns> true or false</returns>
		private bool UserHasSalesChannelAccessforRenewals()
		{
			//Validation is only for external users
			if( IsExternaluser() )
			{
				//Validation only when the sales channels are different for the current contract and the new contract 
				bool AreSalesChannelsSame;
				List<CRMBAL.ContractAccountDetails> contractList = new List<CRMBAL.ContractAccountDetails>();
				int newSalesChannelID = 0;
				if( this.contract.SalesChannelId.HasValue )
					newSalesChannelID = this.contract.SalesChannelId.Value;
				contractList = AretheSalesChannelsSameforCurrentandNewDeal( newSalesChannelID, out AreSalesChannelsSame );

				if( !AreSalesChannelsSame )
				{
					foreach( CRMBAL.ContractAccountDetails contrAccount in contractList )
					{
						if( contrAccount.SalesChannelId > 0 && contrAccount.SalesChannelId != newSalesChannelID )
						{
							//Validation only when the original salesChannel is still Active
							if( IsOriginalSalesChannelActive( contrAccount.SalesChannelId ) )
							{
								//Check if Contract is in Default variable or 30 day period of the endDate of current contract
								if( !(contrAccount.IsDefault == 1 || DateTime.Now >= contrAccount.EndDate.AddDays( -30 )) )
								{
									this.errors.Add( new CRMBAL.GenericError() { Code = 1, Message = string.Format( "The original contract is from another sales channel .The Account {0}  is not valid for renewal as the account is not in default variable or in the 30 day period of enddate", contrAccount.AccountNumber ) } );

								}
							}
						}
					}
				}
			}
			return !this.HasErrors;
		}
		#endregion
	}
}
