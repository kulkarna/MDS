using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BALEntity = LibertyPower.Business.CustomerManagement.CRMBusinessObjects;
using DALEntity = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class CRMBaseFactory
    {
        public static System.Transactions.TransactionOptions GetStandardTransactionOptions( int transactionMinutes )
        {
            System.Transactions.TransactionOptions txOptions = new System.Transactions.TransactionOptions();
            txOptions.IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted;
            txOptions.Timeout = new TimeSpan( 0, transactionMinutes, 0 ); // transactionMinutes minute(s) to do the transaction
            return txOptions;
        }

        #region Business Activity

        public static List<BALEntity.BusinessActivity> GetActiveBusinessActivities()
        {
            return GetBusinessActivities( true );
        }

        public static List<BALEntity.BusinessActivity> GetBusinessActivities()
        {
            return GetBusinessActivities( null );
        }

        public static List<BALEntity.BusinessActivity> GetBusinessActivities( bool? active )
        {
            List<BALEntity.BusinessActivity> balBusinessActivities = null;
            List<DALEntity.BusinessActivity> dalBusinessActivities = DALEntity.CommonDal.GetBusinessActivities( active );
            balBusinessActivities = MapDALBusinessActivitiesToBAL( dalBusinessActivities );
            return balBusinessActivities;
        }

        internal static List<BALEntity.BusinessActivity> MapDALBusinessActivitiesToBAL( List<DALEntity.BusinessActivity> dalBusinessActivities )
        {
            List<BALEntity.BusinessActivity> balBusinessActivities = new List<BALEntity.BusinessActivity>();
            if( dalBusinessActivities != null )
            {
                foreach( DALEntity.BusinessActivity dalBusinessActivity in dalBusinessActivities )
                {
                    balBusinessActivities.Add( MapDALBusinessActivityToBAL( dalBusinessActivity ) );
                }
            }
            return balBusinessActivities;
        }

        internal static BALEntity.BusinessActivity MapDALBusinessActivityToBAL( DALEntity.BusinessActivity dalBusinessActivity )
        {
            BALEntity.BusinessActivity businessActivity = new BALEntity.BusinessActivity();

            businessActivity.BusinessActivityID = dalBusinessActivity.BusinessActivityID;
            businessActivity.Activity = dalBusinessActivity.Activity;
            businessActivity.Sequence = dalBusinessActivity.Sequence;
            businessActivity.Active = dalBusinessActivity.Active;
            businessActivity.DateCreated = dalBusinessActivity.DateCreated;

            return businessActivity;

        }

        #endregion

        #region Business Type

        public static List<BALEntity.BusinessType> GetActiveBusinessTypes()
        {
            return GetBusinessTypes( true );
        }

        public static List<BALEntity.BusinessType> GetBusinessTypes()
        {
            return GetBusinessTypes( null );
        }

        public static List<BALEntity.BusinessType> GetBusinessTypes( bool? active )
        {
            List<BALEntity.BusinessType> balBusinessTypes = null;
            List<DALEntity.BusinessType> dalBusinessTypes = DALEntity.CommonDal.GetBusinessTypes( active );
            balBusinessTypes = MapDALBusinessTypesToBAL( dalBusinessTypes );
            return balBusinessTypes;
        }

        public static List<BALEntity.BusinessType> MapDALBusinessTypesToBAL( List<DALEntity.BusinessType> dalBusinessTypes )
        {
            List<BALEntity.BusinessType> balBusinessTypes = new List<BALEntity.BusinessType>();
            if( dalBusinessTypes != null )
            {
                foreach( DALEntity.BusinessType dalBusinessType in dalBusinessTypes )
                {
                    balBusinessTypes.Add( MapDALBusinessTypeToBAL( dalBusinessType ) );
                }
            }
            return balBusinessTypes;
        }

        public static BALEntity.BusinessType MapDALBusinessTypeToBAL( DALEntity.BusinessType dalBusinessType )
        {
            BALEntity.BusinessType businessType = new BALEntity.BusinessType();

            businessType.BusinessTypeID = dalBusinessType.BusinessTypeID;
            businessType.Type = dalBusinessType.Type;
            businessType.Sequence = dalBusinessType.Sequence;
            businessType.Active = dalBusinessType.Active;
            businessType.DateCreated = dalBusinessType.DateCreated;

            return businessType;

        }

        #endregion

        #region Utility Required Fields

        public static List<UtilityRequiredData> GetUtilityRequiredData( string utilityCode )
        {
            DataSet ds = LibertyPower.DataAccess.SqlAccess.CommonSql.UtilityRequiredData.GetUtilityRequiredDataByUtility( utilityCode );
            List<UtilityRequiredData> list = new List<UtilityRequiredData>();
            if( ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 )
            {
                UtilityRequiredData ureq = new UtilityRequiredData();
                MapDataRowToUtilityRequiredData( ds.Tables[0].Rows[0], ureq );
                list.Add( ureq );
            }

            return list;
        }



        internal static void MapDataRowToUtilityRequiredData( DataRow dataRow, UtilityRequiredData datum )
        {
            datum.AccountInfoField = dataRow.Field<string>( "account_info_field" );
            string value = dataRow.Field<string>( "control_type" );
            if( !string.IsNullOrEmpty( value ) )
            {
                if( value == "TextBox" )
                    datum.ControlType = UtilityRequiredDataControlType.TextBox;
                else
                    datum.ControlType = UtilityRequiredDataControlType.DropDown;

            }
            short tmpStorage = 0;
            datum.Created = dataRow.Field<DateTime?>( "Created" );
            datum.CreatedBy = dataRow.Field<string>( "CreatedBy" );

            if( short.TryParse( dataRow.Field<string>( "field_data_length" ), out tmpStorage ) )
                datum.FieldDataLength = tmpStorage;
            else
                datum.FieldDataLength = 0;

            datum.FieldDataType = dataRow.Field<string>( "field_data_type" );
            datum.HasControlData = dataRow.Field<byte>( "has_control_data" );
            datum.LabelText = dataRow.Field<string>( "label_text" );
            datum.RequiredLength = dataRow.Field<int>( "required_length" );
            datum.StoredProcVal = dataRow.Field<string>( "stored_proc_val" );
            datum.UtilityCode = dataRow.Field<string>( "utility_id" );
            datum.UtilityRequiredDataID = dataRow.Field<int>( "urd_id" );
        }

        #endregion Utility Required Fields
    }
}
