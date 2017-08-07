using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{

	public static class CRMLibertyPowerSql
	{
		#region Customer

		public static DataSet GetCustomer( int customerId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerSelect";
					cmd.Parameters.Add( new SqlParameter( "@CustomerId", customerId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetCustomers()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomersSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateCustomer( int? customerId, int? customerPreferenceId, int? addressId, int? businessActivityId, int? businessTypeId, int? contactId, int? creditAgencyId, string creditScoreEncrypted, int? nameId, string dba, string duns, string employerId, string externalNumber, int? ownerNameId, string ssnClear, string ssnEncrypted, string taxId, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerUpdate";

					cmd.Parameters.Add( new SqlParameter( "@CustomerId ", customerId ) );
					cmd.Parameters.Add( new SqlParameter( "@AddressId ", addressId ) );
					cmd.Parameters.Add( new SqlParameter( "@customerPreferenceId ", customerPreferenceId ) );
					cmd.Parameters.Add( new SqlParameter( "@BusinessActivityId", businessActivityId ) );
					cmd.Parameters.Add( new SqlParameter( "@BusinessTypeId", businessTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@ContactId", contactId ) );
					cmd.Parameters.Add( new SqlParameter( "@CreditAgencyId", creditAgencyId ) );
					cmd.Parameters.Add( new SqlParameter( "@CreditScoreEncrypted", creditScoreEncrypted ) );
					cmd.Parameters.Add( new SqlParameter( "@NameId", nameId ) );
					cmd.Parameters.Add( new SqlParameter( "@Dba", dba ) );
					cmd.Parameters.Add( new SqlParameter( "@Duns", duns ) );
					cmd.Parameters.Add( new SqlParameter( "@EmployerId", employerId ) );
					cmd.Parameters.Add( new SqlParameter( "@ExternalNumber", externalNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@OwnerNameId", ownerNameId ) );
					cmd.Parameters.Add( new SqlParameter( "@SsnClear", ssnClear ) );
					cmd.Parameters.Add( new SqlParameter( "@SsnEncrypted", ssnEncrypted ) );
					cmd.Parameters.Add( new SqlParameter( "@TaxId", taxId ) );
					cmd.Parameters.Add( new SqlParameter( "@IsSilent", 0 ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertCustomer( int? addressId, int? customerPreferenceId, int? businessActivityId, int? businessTypeId, int? contactId, int? creditAgencyId, string creditScoreEncrypted, int? nameId, string dba, string duns, string employerId, string externalNumber, int? ownerNameId, string ssnClear, string ssnEncrypted, string taxId, int createdBy, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerInsert";

					cmd.Parameters.Add( new SqlParameter( "@AddressId ", addressId ) );
					cmd.Parameters.Add( new SqlParameter( "@customerPreferenceId ", customerPreferenceId ) );
					cmd.Parameters.Add( new SqlParameter( "@BusinessActivityId", businessActivityId ) );
					cmd.Parameters.Add( new SqlParameter( "@BusinessTypeId", businessTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@ContactId", contactId ) );
					cmd.Parameters.Add( new SqlParameter( "@CreditAgencyId", creditAgencyId ) );
					cmd.Parameters.Add( new SqlParameter( "@CreditScoreEncrypted", creditScoreEncrypted ) );
					if( !nameId.HasValue )
					{
						cmd.Parameters.Add( new SqlParameter( "@NameId", DBNull.Value ) );
					}
					else
					{
						cmd.Parameters.Add( new SqlParameter( "@NameId", nameId ) );
					}
					cmd.Parameters.Add( new SqlParameter( "@Dba", dba ) );
					cmd.Parameters.Add( new SqlParameter( "@Duns", duns ) );
					cmd.Parameters.Add( new SqlParameter( "@EmployerId", employerId ) );
					cmd.Parameters.Add( new SqlParameter( "@ExternalNumber", externalNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@OwnerNameId", ownerNameId ) );
					cmd.Parameters.Add( new SqlParameter( "@SsnClear", ssnClear ) );
					cmd.Parameters.Add( new SqlParameter( "@SsnEncrypted", ssnEncrypted ) );
					cmd.Parameters.Add( new SqlParameter( "@TaxId", taxId ) );
					cmd.Parameters.Add( new SqlParameter( "@IsSilent", 0 ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}
		/// <summary>
		///Function to get the top 1 CustomerId for the supplied contract number.
		///This function joins the tables Contract,AccountContract and Accounts Table and gets the CustomerId from the Accounts table 
		/// </summary>
		/// <param name="contractNo">The existing contract number to Amend</param>
		/// <returns></returns>
		public static DataSet GetCustomerIdforContractNumber( string contractNo )
		{
			//Bug 7839: 1-64232573 Contract Amendments
			//Amendment Added on June 17 2013
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerIdfromContractNmbrSelect";
					cmd.Parameters.Add( new SqlParameter( "@Number", contractNo ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Customer Preference

		public static DataSet GetCustomerPreference( int customerPreferenceId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerPreferenceSelect";
					cmd.Parameters.Add( new SqlParameter( "@CustomerPreferenceId", customerPreferenceId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateCustomerPreference( int? customerPreferenceId, bool isGoGreen, bool optOutSpecialOffers, int? customerContactPreferenceID, int languageId, string pin, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerPreferenceUpdate";

					cmd.Parameters.Add( new SqlParameter( "@CustomerPreferenceId ", customerPreferenceId ) );
					cmd.Parameters.Add( new SqlParameter( "@IsGoGreen ", isGoGreen ) );
					cmd.Parameters.Add( new SqlParameter( "@OptOutSpecialOffers ", optOutSpecialOffers ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerContactPreferenceID ", customerContactPreferenceID ) );
					cmd.Parameters.Add( new SqlParameter( "@LanguageId ", languageId ) );
					cmd.Parameters.Add( new SqlParameter( "@Pin ", pin ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy ", modifiedBy ) );


					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertCustomerPreference( bool isGoGreen, bool optOutSpecialOffers, int? customerContactPreferenceID, int languageId, string pin, int createdBy, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerPreferenceInsert";

					cmd.Parameters.Add( new SqlParameter( "@IsGoGreen ", isGoGreen ) );
					cmd.Parameters.Add( new SqlParameter( "@OptOutSpecialOffers ", optOutSpecialOffers ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerContactPreferenceID ", customerContactPreferenceID ) );
					cmd.Parameters.Add( new SqlParameter( "@LanguageId ", languageId ) );
					cmd.Parameters.Add( new SqlParameter( "@Pin ", pin ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@createdBy ", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Name

		public static DataSet GetName( int nameId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NameSelect";
					cmd.Parameters.Add( new SqlParameter( "@nameId", nameId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateName( int nameId, string name, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NameUpdate";

					cmd.Parameters.Add( new SqlParameter( "@nameId ", nameId ) );
					cmd.Parameters.Add( new SqlParameter( "@name ", name ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy ", modifiedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertName( string name, int createdBy, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NameInsert";

					cmd.Parameters.Add( new SqlParameter( "@name ", name ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@createdBy ", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Address

		public static DataSet GetAddress( int addressId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AddressSelect";
					cmd.Parameters.Add( new SqlParameter( "@AddressId", addressId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAddressByCustomerId( int customerId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AddressByCustomerIdSelect";
					cmd.Parameters.Add( new SqlParameter( "@CustomerID", customerId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateAddress( int addressId, string address1, string address2, string city, string state, string stateFips, string zip, string county, string countyFips, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AddressUpdate";

					cmd.Parameters.Add( new SqlParameter( "@AddressId ", addressId ) );
					cmd.Parameters.Add( new SqlParameter( "@address1 ", address1 ) );
					cmd.Parameters.Add( new SqlParameter( "@address2 ", address2 ) );
					cmd.Parameters.Add( new SqlParameter( "@city ", city ) );
					cmd.Parameters.Add( new SqlParameter( "@state ", state ) );
					cmd.Parameters.Add( new SqlParameter( "@stateFips ", stateFips ) );
					cmd.Parameters.Add( new SqlParameter( "@zip ", zip ) );
					cmd.Parameters.Add( new SqlParameter( "@county ", county ) );
					cmd.Parameters.Add( new SqlParameter( "@countyFips ", countyFips ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertAddress( string address1, string address2, string city, string state, string stateFips, string zip, string county, string countyFips, int createdBy, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AddressInsert";

					cmd.Parameters.Add( new SqlParameter( "@Address1 ", address1 ) );
					cmd.Parameters.Add( new SqlParameter( "@Address2 ", address2 ) );
					cmd.Parameters.Add( new SqlParameter( "@City ", city ) );
					cmd.Parameters.Add( new SqlParameter( "@State ", state ) );
					cmd.Parameters.Add( new SqlParameter( "@StateFips ", stateFips ) );
					cmd.Parameters.Add( new SqlParameter( "@Zip ", zip ) );
					cmd.Parameters.Add( new SqlParameter( "@County ", county ) );
					cmd.Parameters.Add( new SqlParameter( "@CountyFips ", countyFips ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy ", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Contact

		public static DataSet GetContact( int contactId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ContactSelect";
					cmd.Parameters.Add( new SqlParameter( "@ContactId", contactId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateContact( int? contactId, string firstName, string lastName, string title, string phone, string fax, string email, DateTime birthdate, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ContactUpdate";

					cmd.Parameters.Add( new SqlParameter( "@ContactId ", contactId ) );
					cmd.Parameters.Add( new SqlParameter( "@firstName ", firstName ) );
					cmd.Parameters.Add( new SqlParameter( "@lastName ", lastName ) );
					cmd.Parameters.Add( new SqlParameter( "@title ", title ) );
					cmd.Parameters.Add( new SqlParameter( "@phone ", phone ) );
					cmd.Parameters.Add( new SqlParameter( "@fax ", fax ) );
					cmd.Parameters.Add( new SqlParameter( "@email ", email ) );
					cmd.Parameters.Add( new SqlParameter( "@birthdate ", birthdate ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertContact( string firstName, string lastName, string title, string phone, string fax, string email, DateTime birthdate, int createdBy, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ContactInsert";

					cmd.Parameters.Add( new SqlParameter( "@firstName ", firstName ) );
					cmd.Parameters.Add( new SqlParameter( "@lastName ", lastName ) );
					cmd.Parameters.Add( new SqlParameter( "@title ", title ) );
					cmd.Parameters.Add( new SqlParameter( "@phone ", phone ) );
					cmd.Parameters.Add( new SqlParameter( "@fax ", fax ) );
					cmd.Parameters.Add( new SqlParameter( "@email ", email ) );
					cmd.Parameters.Add( new SqlParameter( "@birthdate ", birthdate ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@createdBy ", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Account

		public static DataSet GetAccount( int accountId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAccount( string accountNumber, int utilityId )
		{
			return GetAccounts( accountNumber, null, utilityId, null, null );
		}

		public static DataSet GetAccounts( string accountNumber, string accountIdLegacy, int? utilityId, int? customerId, int? accountTypeID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountFilterSelect";


					cmd.Parameters.Add( new SqlParameter( "@AccountIdLegacy", accountIdLegacy ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeID", accountTypeID ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerId", customerId ) );
					cmd.Parameters.Add( new SqlParameter( "@utilityId", utilityId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAccountsByCustomerId( int customerId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountsByCustomerIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@CustomerId", customerId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateAccount( int? accountId, string accountIdLegacy, string accountNumber, int? accountTypeId, int? currentContractId, int? currentRenewalContractId, int? customerId, string customerIdLegacy, string entityId, int? retailMktId, int? utilityId, int? accountNameId, int? billingAddressId, int? billingContactId, int? serviceAddressId, string origin, int? taxStatusId, bool? porOption, int? billingTypeId, string zone, string serviceRateClass, string stratumVariable, string billingGroup, string icap, string tcap, string loadProfile, string lossCode, int? meterTypeId, int modifiedBy, int? deliveryLocationRefId = null, int? loadProfileRefId = null, int? serviceClassRefId = null )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountUpdate";

					cmd.Parameters.Add( new SqlParameter( "@accountId ", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountIdLegacy ", accountIdLegacy ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber ", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeId ", accountTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@CurrentContractId ", currentContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@CurrentRenewalContractId ", currentRenewalContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerId ", customerId ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerIdLegacy ", customerIdLegacy ) );
					cmd.Parameters.Add( new SqlParameter( "@EntityId ", entityId ) );
					cmd.Parameters.Add( new SqlParameter( "@RetailMktId ", retailMktId ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityId ", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNameId ", accountNameId ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingAddressId ", billingAddressId ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingContactId ", billingContactId ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceAddressId ", serviceAddressId ) );
					cmd.Parameters.Add( new SqlParameter( "@Origin ", origin ) );
					cmd.Parameters.Add( new SqlParameter( "@TaxStatusId ", taxStatusId ) );
					cmd.Parameters.Add( new SqlParameter( "@PorOption ", porOption ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingTypeId ", billingTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@Zone ", zone ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceRateClass ", serviceRateClass ) );
					cmd.Parameters.Add( new SqlParameter( "@StratumVariable ", stratumVariable ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingGroup ", billingGroup ) );
					cmd.Parameters.Add( new SqlParameter( "@Icap ", icap ) );
					cmd.Parameters.Add( new SqlParameter( "@Tcap ", tcap ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadProfile", loadProfile ) );
					cmd.Parameters.Add( new SqlParameter( "@LossCode", lossCode ) );
					cmd.Parameters.Add( new SqlParameter( "@MeterTypeId ", meterTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@DeliveryLocationRefId", deliveryLocationRefId ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadProfileRefId ", loadProfileRefId ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassRefId ", serviceClassRefId ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy ", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@Modified ", DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated ", DBNull.Value ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertAccount( string accountIdLegacy, string accountNumber, int? accountTypeId, int? currentContractId, int? currentRenewalContractId, int? customerId, string customerIdLegacy, string entityId, int? retailMktId, int? utilityId, int? accountNameId, int? billingAddressId, int? billingContactId, int? serviceAddressId, string origin, int? taxStatusId, bool? porOption, int? billingTypeId, string zone, string serviceRateClass, string stratumVariable, string billingGroup, string icap, string tcap, string loadProfile, string lossCode, int? meterTypeId, int modifiedBy, int createdBy, int? deliveryLocationRefId = null, int? loadProfileRefId = null, int? serviceClassRefId = null )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountInsert";

					cmd.Parameters.Add( new SqlParameter( "@AccountIdLegacy ", accountIdLegacy ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber ", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountTypeId ", accountTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@CurrentContractId ", currentContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@CurrentRenewalContractId ", currentRenewalContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerId ", customerId ) );
					cmd.Parameters.Add( new SqlParameter( "@CustomerIdLegacy ", customerIdLegacy ) );
					cmd.Parameters.Add( new SqlParameter( "@EntityId ", entityId ) );
					cmd.Parameters.Add( new SqlParameter( "@RetailMktId ", retailMktId ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityId ", utilityId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNameId ", accountNameId ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingAddressId ", billingAddressId ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingContactId ", billingContactId ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceAddressId ", serviceAddressId ) );
					cmd.Parameters.Add( new SqlParameter( "@Origin ", origin ) );
					cmd.Parameters.Add( new SqlParameter( "@TaxStatusId ", taxStatusId ) );
					cmd.Parameters.Add( new SqlParameter( "@PorOption ", porOption ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingTypeId ", billingTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@Zone ", zone ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceRateClass ", serviceRateClass ) );
					cmd.Parameters.Add( new SqlParameter( "@StratumVariable ", stratumVariable ) );
					cmd.Parameters.Add( new SqlParameter( "@BillingGroup ", billingGroup ) );
					cmd.Parameters.Add( new SqlParameter( "@Icap ", icap ) );
					cmd.Parameters.Add( new SqlParameter( "@Tcap ", tcap ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadProfile", loadProfile ) );
					cmd.Parameters.Add( new SqlParameter( "@LossCode", lossCode ) );
					cmd.Parameters.Add( new SqlParameter( "@MeterTypeId ", meterTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy ", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@Modified ", DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@DateCreated ", DBNull.Value ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy ", createdBy ) );

					cmd.Parameters.Add( new SqlParameter( "@DeliveryLocationRefId ", deliveryLocationRefId ) );
					cmd.Parameters.Add( new SqlParameter( "@LoadProfileRefId ", loadProfileRefId ) );
					cmd.Parameters.Add( new SqlParameter( "@ServiceClassRefID ", serviceClassRefId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}
		/// <summary>
		/// New Methods added for  PBI-81211
		/// </summary>Update  the  AccountPropertyHistory Data if missing
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static DataSet AccountPropertyHistoryWatchdogInsert( string accountNumber, string utilityCode, int insertFlag )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.CommandText = "usp_AccountPropertyHistoryInsertFromQuerys";

						cmd.Parameters.Add( new SqlParameter( "@p_AccountNumber", accountNumber ) );
						cmd.Parameters.Add( new SqlParameter( "@p_UtilityCode", utilityCode ) );
						cmd.Parameters.Add( new SqlParameter( "@p_FlagInsert", insertFlag ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}
		public static DataSet AccountPropertyHistoryWatchdogInsertFromQuerysV4( string accountNumber, string utilityCode, int insertFlag )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.CommandText = "usp_AccountPropertyHistoryInsertFromQuerysV4";

						cmd.Parameters.Add( new SqlParameter( "@p_AccountNumber", accountNumber ) );
						cmd.Parameters.Add( new SqlParameter( "@p_UtilityCode", utilityCode ) );
						cmd.Parameters.Add( new SqlParameter( "@p_FlagInsert", insertFlag ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}
		/// <summary>
		/// Update the  Profile Id from  EDI account Profile if  missing
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static DataSet AccountUpdateLoadProfileRefIdModifiedFromEdiAccountLoadProfile( string accountNumber )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						//cmd.CommandText = "usp_AccountUpdateLoadProfileRefIdModifiedFromEdiAccountLoadProfile";
						cmd.CommandText = "usp_AccountProfileUpdateEdi";

						cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}
		/// <summary>
		/// Update the Profile Id  for  CONED account  if Data missing
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static DataSet AccountUpdateLoadProfileRefIdModifiedFromConedAccountLoadProfile( string accountNumber )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.CommandText = "usp_AccountProfileUpdateConed";

						cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}
		/// <summary>
		/// Update the  LoadProfile Data for  UI account if missing
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static DataSet AccountUpdateProfileForUiaccounts( string accountNumber )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						// cmd.CommandText = "usp_AccountUpdateProfileForUiaccounts";
						cmd.CommandText = "usp_AccountProfileUpdateUI";

						cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}
		/// <summary>
		/// Update the  LoadProfile data for the  scraper Account if missing
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static DataSet AccountUpdateScraper( string accountNumber )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.CommandText = "usp_AccountProfileUpdateScraper";

						cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}
		/// <summary>
		/// Update the  DeliveryLocationRefID  data  if  missing for account
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static DataSet AccountUpdateDeliveryLocationRefId( string accountNumber )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.CommandText = "usp_AccountUpdateDeleveryLocationRefId";

						cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}
		/// <summary>
		/// Update the  ProfileRefId  data  for account if missing
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static DataSet AccountUpdateProfileRefId( string accountNumber )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.CommandText = "usp_AccountUpdateProfileRefId";

						cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}
		/// <summary>
		/// Update the  Zone field for One Zone Utilities if data mising
		/// </summary>
		/// <param name="accountNumber"></param>
		/// <returns></returns>
		public static DataSet AccountUpdateOneZoneUtilities( string accountNumber )
		{
			try
			{
				DataSet ds = new DataSet();

				using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
				{
					using( SqlCommand cmd = new SqlCommand() )
					{
						cmd.Connection = cn;
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.CommandText = "usp_AccountUpdateOneZoneUtilities";

						cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );

						using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						{
							da.Fill( ds );
						}
					}
				}
				return ds;
			}
			catch( Exception exc )
			{
				throw exc;
			}
		}

		public static DataSet IsAccountCurrentlyInRenewalUnderDifferentContract( string accountNumber, int utilityId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_account_renewal_account_sel";

					cmd.Parameters.Add( new SqlParameter( "@p_account_number ", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@p_utility_id ", utilityId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Account Detail

		public static DataSet GetAccountDetail( int accountDetailId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountDetailSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountDetailId", accountDetailId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAccountDetailByAccountId( int accountId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountDetailSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertAccountDetail( int? accountId, int? enrollmentTypeId, int? originalTaxDesignation, int modifiedBy, int createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountDetailInsert";

					cmd.Parameters.Add( new SqlParameter( "@accountId ", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@enrollmentTypeId ", enrollmentTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@originalTaxDesignation ", originalTaxDesignation ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@createdBy ", createdBy ) );


					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateAccountDetail( int? accountDetailId, int? accountId, int? enrollmentTypeId, int? originalTaxDesignation, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountDetailUpdate";

					if( !accountDetailId.HasValue )
					{
						cmd.Parameters.Add( new SqlParameter( "@accountDetailId ", DBNull.Value ) );
					}
					else
					{
						cmd.Parameters.Add( new SqlParameter( "@accountDetailId ", accountDetailId ) );
					}

					if( !accountId.HasValue )
					{
						cmd.Parameters.Add( new SqlParameter( "@accountId ", DBNull.Value ) );
					}
					else
					{
						cmd.Parameters.Add( new SqlParameter( "@accountId ", accountId ) );
					}
					cmd.Parameters.Add( new SqlParameter( "@enrollmentTypeId ", enrollmentTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "@originalTaxDesignation ", originalTaxDesignation ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );


					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Account Contract

		public static DataSet GetAccountContract( int accountContractId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		//Added to fetch the Account Contract Information by ContractID
		public static DataSet GetAccountContractByContractId( int ContractId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractByContractIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@ContractId", ContractId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}


		//Added 08/08/2013 to fetch the Account Contract Information by ContractID and Account Number
		public static DataSet GetAccountContractByContractIdandAccountNumber( int ContractId, string accountNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractByContractIdandAccountNoSelect";

					cmd.Parameters.Add( new SqlParameter( "@ContractId", ContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@accountNumber", accountNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateAccountContract( int? accountContractId, int? accountId, int? contractId, DateTime? requestedStartDate, DateTime? sendEnrollmentDate, int modifiedBy, decimal? LccCapacityFactor )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractUpdate";

					cmd.Parameters.Add( new SqlParameter( "@accountContractId ", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@accountId ", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@contractId ", contractId ) );
					cmd.Parameters.Add( new SqlParameter( "@requestedStartDate ", requestedStartDate ) );
					cmd.Parameters.Add( new SqlParameter( "@sendEnrollmentDate ", sendEnrollmentDate ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@LccCapacityFactor ", LccCapacityFactor ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		public static DataSet UpdateAccountContract( int? accountContractId, int? accountId, int? contractId, DateTime? requestedStartDate, DateTime? sendEnrollmentDate, int modifiedBy )
		{
			return UpdateAccountContract( accountContractId, accountId, contractId, requestedStartDate, sendEnrollmentDate, modifiedBy, null );
		}

		public static DataSet InsertAccountContract( int? accountId, int? contractId, DateTime? requestedStartDate, DateTime? sendEnrollmentDate, int? modifiedBy, int createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractInsert";

					cmd.Parameters.Add( new SqlParameter( "@accountId ", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@contractId ", contractId ) );
					if( requestedStartDate.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@requestedStartDate ", requestedStartDate ) );
					else
						cmd.Parameters.Add( new SqlParameter( "@requestedStartDate ", DBNull.Value ) );


					if( sendEnrollmentDate.HasValue )
						cmd.Parameters.Add( new SqlParameter( "@sendEnrollmentDate ", sendEnrollmentDate ) );
					else
						cmd.Parameters.Add( new SqlParameter( "@sendEnrollmentDate ", DBNull.Value ) );

					cmd.Parameters.Add( new SqlParameter( "@modifiedBy ", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Account Contract Commission

		public static DataSet GetAccountContractCommission( int accountContractCommissionId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractCommissionSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractCommissionId", accountContractCommissionId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateAccountContractCommission( int? accountContractCommissionId, int? accountContractId, int? evergreenOptionId, DateTime? evergreenCommissionEnd, Double? evergreenCommissionRate, int? residualOptionId, DateTime? residualCommissionEnd, int? initialPymtOptionId, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractCommissionUpdate";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractCommissionId", accountContractCommissionId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@EvergreenOptionId", evergreenOptionId ) );
					cmd.Parameters.Add( new SqlParameter( "@EvergreenCommissionEnd", evergreenCommissionEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@EvergreenCommissionRate", evergreenCommissionRate ) );
					cmd.Parameters.Add( new SqlParameter( "@ResidualOptionId", residualOptionId ) );
					cmd.Parameters.Add( new SqlParameter( "@ResidualCommissionEnd", residualCommissionEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@InitialPymtOptionId", initialPymtOptionId ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertAccountContractCommission( int? accountContractId, int? evergreenOptionId, DateTime? evergreenCommissionEnd, Double? evergreenCommissionRate, int? residualOptionId, DateTime? residualCommissionEnd, int? initialPymtOptionId, int modifiedBy, int createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractCommissionInsert";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@EvergreenOptionId", evergreenOptionId ) );
					cmd.Parameters.Add( new SqlParameter( "@EvergreenCommissionEnd", evergreenCommissionEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@EvergreenCommissionRate", evergreenCommissionRate ) );
					cmd.Parameters.Add( new SqlParameter( "@ResidualOptionId", residualOptionId ) );
					cmd.Parameters.Add( new SqlParameter( "@ResidualCommissionEnd", residualCommissionEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@InitialPymtOptionId", initialPymtOptionId ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Account Contract Rate

		public static DataSet GetAccountContractRate( int accountContractRateId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractRateId", accountContractRateId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAccountContractRatesByContractId( int contractId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateSelectByContractId";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractRateId", contractId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAccountContractRatesByAccountContractId( int accountContractId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetAccountContractRatesByAccountContractId";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAccountContractRateByAccountNumberUtilityID( string accountNumber, int utilityID, int isRenewal )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateByAcctNoUtilityIDSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@UtilityID", utilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsRenewal", isRenewal ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

        public static DataSet UpdateAccountContractRate(int? accountContractRateId, int? accountContractId, string legacyProductId, int? term, int? rateId, Double? rate, string rateCode, DateTime rateStart, DateTime rateEnd, bool isContractedRate, int? heatIndexSourceId, Decimal? heatRate, Double? transferRate, Double? grossMargin, Double? commissionRate, Double? additionalGrossMargin, Int64? priceId, Int64? productCrossPriceMultiID, int modifiedBy)
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateUpdate";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractRateId", accountContractRateId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@LegacyProductId", legacyProductId ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@RateId", rateId ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
					cmd.Parameters.Add( new SqlParameter( "@RateCode", rateCode ) );
					cmd.Parameters.Add( new SqlParameter( "@RateStart", rateStart ) );
					cmd.Parameters.Add( new SqlParameter( "@RateEnd", rateEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@IsContractedRate", isContractedRate ) );
					cmd.Parameters.Add( new SqlParameter( "@HeatIndexSourceId", heatIndexSourceId ) );
					cmd.Parameters.Add( new SqlParameter( "@HeatRate", heatRate ) );
					cmd.Parameters.Add( new SqlParameter( "@TransferRate", transferRate ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@CommissionRate", commissionRate ) );
					cmd.Parameters.Add( new SqlParameter( "@AdditionalGrossMargin", additionalGrossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceId", priceId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceMultiID", productCrossPriceMultiID ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

        public static DataSet UpdateAccountContractRate(int? accountContractRateId, int? accountContractId, string legacyProductId, int? term, int? rateId, Double? rate, Double? contractRate, string rateCode, DateTime rateStart, DateTime rateEnd, bool isContractedRate, int? heatIndexSourceId, Decimal? heatRate, Double? transferRate, Double? grossMargin, Double? commissionRate, Double? additionalGrossMargin, Int64? priceId, Int64? productCrossPriceMultiID, int modifiedBy)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = cn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AccountContractRateUpdate";

                    cmd.Parameters.Add(new SqlParameter("@AccountContractRateId", accountContractRateId));
                    cmd.Parameters.Add(new SqlParameter("@AccountContractId", accountContractId));
                    cmd.Parameters.Add(new SqlParameter("@LegacyProductId", legacyProductId));
                    cmd.Parameters.Add(new SqlParameter("@Term", term));
                    cmd.Parameters.Add(new SqlParameter("@RateId", rateId));

                    cmd.Parameters.Add(new SqlParameter("@Rate", rate));
                    if (contractRate != null)
                        cmd.Parameters.Add(new SqlParameter("@ContractRate", contractRate));

                    cmd.Parameters.Add(new SqlParameter("@RateCode", rateCode));
                    cmd.Parameters.Add(new SqlParameter("@RateStart", rateStart));
                    cmd.Parameters.Add(new SqlParameter("@RateEnd", rateEnd));
                    cmd.Parameters.Add(new SqlParameter("@IsContractedRate", isContractedRate));
                    cmd.Parameters.Add(new SqlParameter("@HeatIndexSourceId", heatIndexSourceId));
                    cmd.Parameters.Add(new SqlParameter("@HeatRate", heatRate));
                    cmd.Parameters.Add(new SqlParameter("@TransferRate", transferRate));
                    cmd.Parameters.Add(new SqlParameter("@GrossMargin", grossMargin));
                    cmd.Parameters.Add(new SqlParameter("@CommissionRate", commissionRate));
                    cmd.Parameters.Add(new SqlParameter("@AdditionalGrossMargin", additionalGrossMargin));
                    cmd.Parameters.Add(new SqlParameter("@PriceId", priceId));
                    cmd.Parameters.Add(new SqlParameter("@ProductCrossPriceMultiID", productCrossPriceMultiID));
                    cmd.Parameters.Add(new SqlParameter("@ModifiedBy", modifiedBy));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet InsertAccountContractRate(int? accountContractId, string legacyProductId, int? term, int? rateId, Double? rate, string rateCode, DateTime rateStart, DateTime rateEnd, bool isContractedRate, int? heatIndexSourceId, Decimal? heatRate, Double? transferRate, Double? grossMargin, Double? commissionRate, Double? additionalGrossMargin, Int64? priceId, Int64? productCrossPriceMultiID, bool isCustomEnd, int modifiedBy, int createdBy, Double? contractRate = null)
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateInsert";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@LegacyProductId", legacyProductId ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@RateId", rateId ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
					if( rateCode == null )
					{
						cmd.Parameters.Add( new SqlParameter( "@RateCode", DBNull.Value ) );
					}
					else
					{
						cmd.Parameters.Add( new SqlParameter( "@RateCode", rateCode ) );
					}
					cmd.Parameters.Add( new SqlParameter( "@RateStart", rateStart ) );
					cmd.Parameters.Add( new SqlParameter( "@RateEnd", rateEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@IsContractedRate", isContractedRate ) );
					cmd.Parameters.Add( new SqlParameter( "@HeatIndexSourceId", heatIndexSourceId ) );
					cmd.Parameters.Add( new SqlParameter( "@HeatRate", heatRate ) );
					cmd.Parameters.Add( new SqlParameter( "@TransferRate", transferRate ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@CommissionRate", commissionRate ) );
					cmd.Parameters.Add( new SqlParameter( "@AdditionalGrossMargin", additionalGrossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceId", priceId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceMultiID", productCrossPriceMultiID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsCustomEnd", isCustomEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
                    cmd.Parameters.Add(new SqlParameter("@ContractRate", contractRate));//PBI 142028 - Andre Damasceno - 10/10/2016 - Added new column

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAccountContractRatesByAccountContractNumber( string accountNumber, string contractNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateSelectByAccountContractNumber";

					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", accountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@ContractNumber", contractNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetAccountContractRateQueue()
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateQueueSelect";

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetAccountContractRateQueueByID( int queueID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateQueueSelectByID";

					cmd.Parameters.Add( new SqlParameter( "@QueueID", queueID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetAccountContractRateQueueBySendDateStatus( DateTime sendDate, DataTable status )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateQueueSelectBySendDateStatus";

					cmd.Parameters.Add( new SqlParameter( "@SendDate", sendDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet InsertAccountContractRateQueue( int? accountContractId, string legacyProductId, int? term, int? rateId, Double? rate, string rateCode,
			DateTime rateStart, DateTime rateEnd, bool isContractedRate, int? heatIndexSourceId, Decimal? heatRate, Double? transferRate, Double? grossMargin,
			Double? commissionRate, Double? additionalGrossMargin, Int64? priceId, Int64? productCrossPriceMultiID, bool isCustomEnd, int modifiedBy, int createdBy,
			int status, string statusNotes, DateTime sendDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateQueueInsert";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@LegacyProductId", legacyProductId ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@RateId", rateId ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
					if( rateCode == null )
					{
						cmd.Parameters.Add( new SqlParameter( "@RateCode", DBNull.Value ) );
					}
					else
					{
						cmd.Parameters.Add( new SqlParameter( "@RateCode", rateCode ) );
					}
					cmd.Parameters.Add( new SqlParameter( "@RateStart", rateStart ) );
					cmd.Parameters.Add( new SqlParameter( "@RateEnd", rateEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@IsContractedRate", isContractedRate ) );
					cmd.Parameters.Add( new SqlParameter( "@HeatIndexSourceId", heatIndexSourceId ) );
					cmd.Parameters.Add( new SqlParameter( "@HeatRate", heatRate ) );
					cmd.Parameters.Add( new SqlParameter( "@TransferRate", transferRate ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@CommissionRate", commissionRate ) );
					cmd.Parameters.Add( new SqlParameter( "@AdditionalGrossMargin", additionalGrossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceId", priceId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceMultiID", productCrossPriceMultiID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsCustomEnd", isCustomEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );
					cmd.Parameters.Add( new SqlParameter( "@StatusNotes", statusNotes ) );
					cmd.Parameters.Add( new SqlParameter( "@SendDate", sendDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet UpdateAccountContractRateQueue( int queueID, int? accountContractId, string legacyProductId, int? term, int? rateId, Double? rate, string rateCode,
			DateTime rateStart, DateTime rateEnd, bool isContractedRate, int? heatIndexSourceId, Decimal? heatRate, Double? transferRate, Double? grossMargin,
			Double? commissionRate, Double? additionalGrossMargin, Int64? priceId, Int64? productCrossPriceMultiID, bool isCustomEnd, int modifiedBy, int createdBy,
			int status, string statusNotes, DateTime sendDate )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateQueueUpdate";

					cmd.Parameters.Add( new SqlParameter( "@QueueID", queueID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@LegacyProductId", legacyProductId ) );
					cmd.Parameters.Add( new SqlParameter( "@Term", term ) );
					cmd.Parameters.Add( new SqlParameter( "@RateId", rateId ) );
					cmd.Parameters.Add( new SqlParameter( "@Rate", rate ) );
					if( rateCode == null )
					{
						cmd.Parameters.Add( new SqlParameter( "@RateCode", DBNull.Value ) );
					}
					else
					{
						cmd.Parameters.Add( new SqlParameter( "@RateCode", rateCode ) );
					}
					cmd.Parameters.Add( new SqlParameter( "@RateStart", rateStart ) );
					cmd.Parameters.Add( new SqlParameter( "@RateEnd", rateEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@IsContractedRate", isContractedRate ) );
					cmd.Parameters.Add( new SqlParameter( "@HeatIndexSourceId", heatIndexSourceId ) );
					cmd.Parameters.Add( new SqlParameter( "@HeatRate", heatRate ) );
					cmd.Parameters.Add( new SqlParameter( "@TransferRate", transferRate ) );
					cmd.Parameters.Add( new SqlParameter( "@GrossMargin", grossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@CommissionRate", commissionRate ) );
					cmd.Parameters.Add( new SqlParameter( "@AdditionalGrossMargin", additionalGrossMargin ) );
					cmd.Parameters.Add( new SqlParameter( "@PriceId", priceId ) );
					cmd.Parameters.Add( new SqlParameter( "@ProductCrossPriceMultiID", productCrossPriceMultiID ) );
					cmd.Parameters.Add( new SqlParameter( "@IsCustomEnd", isCustomEnd ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );
					cmd.Parameters.Add( new SqlParameter( "@StatusNotes", statusNotes ) );
					cmd.Parameters.Add( new SqlParameter( "@SendDate", sendDate ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet UpdateAccountContractRateQueueStatus( int queueID, int status, string statusNotes, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateQueueUpdateStatus";

					cmd.Parameters.Add( new SqlParameter( "@QueueID", queueID ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );
					cmd.Parameters.Add( new SqlParameter( "@StatusNotes", statusNotes ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet DeleteAccountContractRateQueue( int queueID )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateQueueDelete";

					cmd.Parameters.Add( new SqlParameter( "@QueueID", queueID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetAccountContractRateQueueForAcr( DateTime startDate, DataTable status )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountContractRateQueueForAcrSelect";

					cmd.Parameters.Add( new SqlParameter( "@RateStartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet GetExpiringAccountContractRates( int marketID, int daysInAdvanceLowerLimit, int daysInAdvanceUpperLimit, DateTime date )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandTimeout = 900;
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountsExpiringSelect";

					cmd.Parameters.Add( new SqlParameter( "@MarketID", marketID ) );
					cmd.Parameters.Add( new SqlParameter( "@DaysInAdvanceLowerLimit", daysInAdvanceLowerLimit ) );
					cmd.Parameters.Add( new SqlParameter( "@DaysInAdvanceUpperLimit", daysInAdvanceUpperLimit ) );
					cmd.Parameters.Add( new SqlParameter( "@Date", date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Account Status

		public static DataSet GetAccountStatus( int accountStatusId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountStatusSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountStatusId", accountStatusId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		//Added to get the Account Status By Account ContractId
		public static DataSet GetAccountStatusByAccountContractId( int accountContractId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountStatusByAccountContractIdSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateAccountStatus( int? accountStatusId, int? accountContractId, string status, string subStatus, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountStatusUpdate";

					cmd.Parameters.Add( new SqlParameter( "@AccountStatusId", accountStatusId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );
					cmd.Parameters.Add( new SqlParameter( "@SubStatus", subStatus ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertAccountStatus( int? accountContractId, string status, string subStatus, int modifiedBy, int createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountStatusInsert";

					cmd.Parameters.Add( new SqlParameter( "@AccountContractId", accountContractId ) );
					cmd.Parameters.Add( new SqlParameter( "@Status", status ) );
					cmd.Parameters.Add( new SqlParameter( "@SubStatus", subStatus ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Account Usage

		public static DataSet GetAccountUsage( int accountUsageId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountUsageSelect";

					cmd.Parameters.Add( new SqlParameter( "@AccountUsageId", accountUsageId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateAccountUsage( int? accountUsageId, int? accountId, int? annualUsage, int usageReqStatusId, DateTime effectiveDate, int? modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountUsageUpdate";

					cmd.Parameters.Add( new SqlParameter( "@AccountUsageId", accountUsageId ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@AnnualUsage", annualUsage ) );
					cmd.Parameters.Add( new SqlParameter( "@UsageReqStatusId", usageReqStatusId ) );
					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertAccountUsage( int? accountId, int? annualUsage, int usageReqStatusId, DateTime effectiveDate, int? modifiedBy, int? createdBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountUsageInsert";

					cmd.Parameters.Add( new SqlParameter( "@AccountId", accountId ) );
					cmd.Parameters.Add( new SqlParameter( "@AnnualUsage", annualUsage ) );
					cmd.Parameters.Add( new SqlParameter( "@UsageReqStatusId", usageReqStatusId ) );
					cmd.Parameters.Add( new SqlParameter( "@EffectiveDate", effectiveDate ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Account Type

		public static DataSet GetAccountType( int accountTypeId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountTypeSelect";

					cmd.Parameters.Add( new SqlParameter( "@Identity", accountTypeId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		#endregion

		#region Account Summary

        public static DataSet GetAccountsSummary(List<string> zipCodes, int? Channelid = 0)
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.CommandTimeout = 600;//10 minutes
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountsSummarySelect";

					var param1 = cmd.Parameters.Add( new SqlParameter( "@p_zipCodes", SqlDbType.Structured ) );
					param1.TypeName = "dbo.StringList";
                    param1.Value = ListToStringDataTableParam<string>(zipCodes);
                    cmd.Parameters.Add(new SqlParameter("@p_ChannelId", Channelid));
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataTable ListToStringDataTableParam<TIn>( List<TIn> list )
		{
			var table = new DataTable();
			table.Columns.Add( "Item", typeof( string ) );

			foreach( var itemValue in list )
				table.Rows.Add( itemValue.ToString() );

			return table;
		}

		#endregion

		#region Contract

		public static DataSet GetContract( int contractId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ContractSelect";

					cmd.Parameters.Add( new SqlParameter( "@ContractId", contractId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetContractByContractNumber( string contractNumber )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ContractByNumberRead";

					cmd.Parameters.Add( new SqlParameter( "@Number", contractNumber ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetEnrollmentApprovedContracts( string salesChannel, DateTime dateFrom, DateTime dateTo )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ReportsConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "RPT_SAL_ACT_Sales_Channel_Notification_Report_DC";

					cmd.Parameters.Add( new SqlParameter( "@prmSalesChannel", salesChannel ) );
					cmd.Parameters.Add( new SqlParameter( "@prmDateFrom", dateFrom ) );
					cmd.Parameters.Add( new SqlParameter( "@prmDateTo", dateTo ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetEnrollmentRejectedContracts( string salesChannel, DateTime dateFrom, DateTime dateTo )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ReportsConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "Rpt_SAL_ACT_SalesSupport_RejectedAccounts";

					cmd.Parameters.Add( new SqlParameter( "@prmSalesChannel", salesChannel ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet UpdateContract( int? contractId, string number, int? contractTypeId,
			int? contractDealTypeId, int? contractStatusId, int? contractTemplateId,
			DateTime? receiptDate, DateTime startDate, DateTime endDate,
			DateTime signedDate, DateTime submitDate, int? salesChannelId,
			string salesRep, int? salesManagerId, int? pricingTypeId, int? estimatedAnnualUsage, int modifiedBy, string affinityCode )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ContractUpdate";

					cmd.Parameters.Add( new SqlParameter( "ContractId", contractId ) );
					cmd.Parameters.Add( new SqlParameter( "Number", number ) );
					cmd.Parameters.Add( new SqlParameter( "ContractTypeId", contractTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "ContractDealTypeId", contractDealTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "ContractStatusId", contractStatusId ) );
					cmd.Parameters.Add( new SqlParameter( "ContractTemplateId", contractTemplateId ) );
					cmd.Parameters.Add( new SqlParameter( "ReceiptDate", receiptDate ) );
					cmd.Parameters.Add( new SqlParameter( "StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "EndDate", endDate ) );
					cmd.Parameters.Add( new SqlParameter( "SignedDate", signedDate ) );
					cmd.Parameters.Add( new SqlParameter( "SubmitDate", submitDate ) );
					cmd.Parameters.Add( new SqlParameter( "SalesChannelId", salesChannelId ) );
					cmd.Parameters.Add( new SqlParameter( "SalesRep", salesRep ) );
					cmd.Parameters.Add( new SqlParameter( "SalesManagerId", salesManagerId ) );
					cmd.Parameters.Add( new SqlParameter( "PricingTypeId", pricingTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "estimatedAnnualUsage", estimatedAnnualUsage ) );
					cmd.Parameters.Add( new SqlParameter( "ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "AffinityCode", affinityCode ) );
					//Added on Jan 30 2014 for identifying the Client Application that calls the submit contract
					//Commented on April 23 as this is not needed for Update.
					//Client SubmitApplication key Id is inserted only, we should not update the values 
					//cmd.Parameters.Add( new SqlParameter( "ClientSubmitApplicationKeyId", ClientSubmitApplicationKeyId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertContract( string number, int? contractTypeId, int? contractDealTypeId,
			int? contractStatusId, int? contractTemplateId, DateTime? receiptDate, DateTime startDate,
			DateTime endDate, DateTime signedDate, DateTime submitDate, int? salesChannelId,
			string salesRep, int? salesManagerId, int? pricingTypeId, int? estimatedAnnualUsage,
			int modifiedBy, int createdBy, string affinityCode, int? ClientSubmitApplicationKeyId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ContractInsert";

					cmd.Parameters.Add( new SqlParameter( "Number", number ) );
					cmd.Parameters.Add( new SqlParameter( "ContractTypeId", contractTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "ContractDealTypeId", contractDealTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "ContractStatusId", contractStatusId ) );
					cmd.Parameters.Add( new SqlParameter( "ContractTemplateId", contractTemplateId ) );


					if( !receiptDate.HasValue )
					{
						cmd.Parameters.Add( new SqlParameter( "ReceiptDate", DBNull.Value ) );
					}
					else
					{
						cmd.Parameters.Add( new SqlParameter( "ReceiptDate", receiptDate ) );
					}


					cmd.Parameters.Add( new SqlParameter( "StartDate", startDate ) );
					cmd.Parameters.Add( new SqlParameter( "EndDate", endDate ) );
					cmd.Parameters.Add( new SqlParameter( "SignedDate", signedDate ) );
					cmd.Parameters.Add( new SqlParameter( "SubmitDate", submitDate ) );
					cmd.Parameters.Add( new SqlParameter( "SalesChannelId", salesChannelId ) );
					cmd.Parameters.Add( new SqlParameter( "SalesRep", salesRep ) );
					cmd.Parameters.Add( new SqlParameter( "SalesManagerId", salesManagerId ) );
					cmd.Parameters.Add( new SqlParameter( "PricingTypeId", pricingTypeId ) );
					cmd.Parameters.Add( new SqlParameter( "estimatedAnnualUsage", estimatedAnnualUsage ) );
					cmd.Parameters.Add( new SqlParameter( "ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "CreatedBy", createdBy ) );
					cmd.Parameters.Add( new SqlParameter( "AffinityCode", affinityCode ) );
					//Added on Jan 30 2014 for identifying the Client Application that calls the submit contract
					cmd.Parameters.Add( new SqlParameter( "ClientSubmitApplicationKeyId", ClientSubmitApplicationKeyId ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetContractsCurrentStatus( int userId, int dayRange )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetContractCurrentStatus";

					cmd.Parameters.Add( new SqlParameter( "@p_userID", userId ) );
					cmd.Parameters.Add( new SqlParameter( "@p_dayRange", dayRange ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}

			return ds;
		}

		#endregion

		#region Customer Address

		public static DataSet GetCustomerAddress( int customerAddressId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerAddressSelect";
					cmd.Parameters.Add( new SqlParameter( "@CustomerAddressId", customerAddressId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetCustomerAddresses( int customerId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerAddressesSelect";
					cmd.Parameters.Add( new SqlParameter( "@customerId", customerId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertCustomerAddress( int? customerId, int? addressId, int createdBy, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerAddressInsert";

					cmd.Parameters.Add( new SqlParameter( "@customerId", customerId ) );
					cmd.Parameters.Add( new SqlParameter( "@addressId", addressId ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Customer Contact

		public static DataSet GetCustomerContact( int customerContactId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerContactSelect";
					cmd.Parameters.Add( new SqlParameter( "@CustomerContactId", customerContactId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetCustomerContacts( int customerId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerContactsSelect";
					cmd.Parameters.Add( new SqlParameter( "@customerId", customerId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertCustomerContact( int? customerId, int? contactId, int createdBy, int modifiedBy )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerContactInsert";

					cmd.Parameters.Add( new SqlParameter( "@customerId", customerId ) );
					cmd.Parameters.Add( new SqlParameter( "@contactId", contactId ) );
					cmd.Parameters.Add( new SqlParameter( "@modifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region Customer Name

		public static DataSet GetCustomerName( int customerNameId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerNameSelect";
					cmd.Parameters.Add( new SqlParameter( "@CustomerNameID", customerNameId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet GetCustomerNames( int customerId )
		{
			DataSet ds = new DataSet();

			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerNamesSelect";
					cmd.Parameters.Add( new SqlParameter( "@customerId", customerId ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		public static DataSet InsertCustomerName( int? customerId, int? nameId, int createdBy, int modifiedBy )
		{
			DataSet ds = new DataSet();
			using( SqlConnection cn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CustomerNameInsert";

					cmd.Parameters.Add( new SqlParameter( "@CustomerId", customerId ) );
					cmd.Parameters.Add( new SqlParameter( "@NameId", nameId ) );
					cmd.Parameters.Add( new SqlParameter( "@ModifiedBy", modifiedBy ) );
					cmd.Parameters.Add( new SqlParameter( "@CreatedBy", createdBy ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
					{
						da.Fill( ds );
					}
				}
			}
			return ds;
		}

		#endregion

		#region"Sales Channel"

		//Get contract for Renewal
		public static DataSet GetSalesChannelByUserName( string userName )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_SelectSalesChannelByUsername";
					cmd.Parameters.Add( new SqlParameter( "@p_username", userName ) );
					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		#endregion

		#region "Meter Read Calendar Details|"

		public static DataSet GetMeterReadBillingCycleAftertheGivenDate( string UtilityID, string ReadCycleId, DateTime GivenDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					conn.Open();
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetBillingCycleAfter";
					cmd.Parameters.Add( new SqlParameter( "@Utility_id", UtilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@read_cycle_id", ReadCycleId ) );
					cmd.Parameters.Add( new SqlParameter( "@given_date", GivenDate.Date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet GetMeterReadBillingCycleContainingtheGivenDate( string UtilityID, string ReadCycleId, DateTime GivenDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					conn.Open();
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetBillingCycleContaining";
					cmd.Parameters.Add( new SqlParameter( "@Utility_id", UtilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@read_cycle_id", ReadCycleId ) );
					cmd.Parameters.Add( new SqlParameter( "@given_date", GivenDate.Date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}


		public static DataSet GetMeterReadStartDateforagivenMonth( string UtilityID, string AccountNumber, DateTime GivenDate )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					conn.Open();
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetBillingCycleStartDate";
					cmd.Parameters.Add( new SqlParameter( "@Utility_id", UtilityID ) );
					cmd.Parameters.Add( new SqlParameter( "@AccountNumber", AccountNumber ) );
					cmd.Parameters.Add( new SqlParameter( "@given_date", GivenDate.Date ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet AccountIsRenewing( int accountID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					conn.Open();
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountIsRenewing";
					cmd.Parameters.Add( new SqlParameter( "@AccountID", accountID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		public static DataSet AccountIsActive( int accountID )
		{
			DataSet ds = new DataSet();
			using( SqlConnection conn = new SqlConnection( Helper.ConnectionString ) )
			{
				using( SqlCommand cmd = new SqlCommand() )
				{
					cmd.Connection = conn;
					conn.Open();
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AccountIsActive";
					cmd.Parameters.Add( new SqlParameter( "@AccountID", accountID ) );

					using( SqlDataAdapter da = new SqlDataAdapter( cmd ) )
						da.Fill( ds );
				}
			}
			return ds;
		}

		#endregion
	}
}
