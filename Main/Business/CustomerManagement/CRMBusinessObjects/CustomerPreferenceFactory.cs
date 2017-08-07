using System;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using System.Collections.Generic;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
	public static class CustomerPreferenceFactory
	{
		public static CustomerPreference GetCustomerPreference( int customerPreferenceId )
		{
			DataSet ds = CRMLibertyPowerSql.GetCustomerPreference( customerPreferenceId );

			if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
			{
				CustomerPreference customerPreference = new CustomerPreference();
				MapDataRowToCustomerPreference( ds.Tables[0].Rows[0], customerPreference );
				return customerPreference;
			}

			return null;
		}

		public static bool InsertCustomerPreference( CustomerPreference customerPreference, out List<GenericError> errors )
		{
			errors = new List<GenericError>();

			errors = customerPreference.IsValidForInsert();

			if( errors.Count > 0 )
			{
				return false;
			}

			if( customerPreference.Pin == null )
			{
				customerPreference.Pin = "";
			}

			if( customerPreference.LanguageId == 0 )
			{
				customerPreference.LanguageId = 1;
			}

            int? customerContactPreferenceId = customerPreference.CustomerContactPreferenceId != 0 ? (int?) customerPreference.CustomerContactPreferenceId : null;

			DataSet ds = CRMLibertyPowerSql.InsertCustomerPreference( customerPreference.IsGoGreen, customerPreference.OptOutSpecialOffers,
                customerContactPreferenceId, customerPreference.LanguageId, customerPreference.Pin, customerPreference.CreatedBy, customerPreference.ModifiedBy);

			MapDataRowToCustomerPreference( ds.Tables[0].Rows[0], customerPreference );

			return true;
		}

		public static bool UpdateCustomerPreference( CustomerPreference customerPreference, out List<GenericError> errors )
		{
			errors = new List<GenericError>();

			errors = customerPreference.IsValidForUpdate();

			if( errors.Count > 0 )
			{
				return false;
			}

			if( customerPreference.Pin == null )
			{
				customerPreference.Pin = "";
			}

			if( customerPreference.LanguageId == 0 )
			{
				customerPreference.LanguageId = 1;
			}

            int? customerContactPreferenceId = customerPreference.CustomerContactPreferenceId != 0 ? (int?) customerPreference.CustomerContactPreferenceId : null;

            DataSet ds = CRMLibertyPowerSql.UpdateCustomerPreference(customerPreference.CustomerPreferenceId, customerPreference.IsGoGreen, customerPreference.OptOutSpecialOffers, customerContactPreferenceId, customerPreference.LanguageId, customerPreference.Pin, customerPreference.ModifiedBy);

			MapDataRowToCustomerPreference( ds.Tables[0].Rows[0], customerPreference );

			return true;
		}

		private static void MapDataRowToCustomerPreference( DataRow dataRow, CustomerPreference customerPreference )
		{
			customerPreference.CreatedBy = dataRow.Field<int>( "CreatedBy" );
			customerPreference.CustomerPreferenceId = dataRow.Field<int?>( "CustomerPreferenceId" );
			customerPreference.DateCreated = dataRow.Field<DateTime>( "DateCreated" );
            customerPreference.IsGoGreen = dataRow.Field<bool>("IsGoGreen");
            customerPreference.LanguageId = dataRow.Field<int>("LanguageId");
			customerPreference.Modified = dataRow.Field<DateTime>( "Modified" );
			customerPreference.ModifiedBy = dataRow.Field<int>( "ModifiedBy" );
			customerPreference.OptOutSpecialOffers = dataRow.Field<bool>( "OptOutSpecialOffers" );
			customerPreference.Pin = dataRow.Field<string>( "Pin" );

            int? customerContactPreferenceId = dataRow.Field<int?>("CustomerContactPreferenceId");
            customerPreference.CustomerContactPreferenceId = customerContactPreferenceId == null ? 0 : (int) customerContactPreferenceId;
        }
	}
}
