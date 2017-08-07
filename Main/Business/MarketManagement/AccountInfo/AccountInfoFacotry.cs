using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.ERCOTSql;
using LibertyPower.Business.CommonBusiness.CommonHelper;

namespace LibertyPower.Business.MarketManagement.AccountInfo
{
	/// <summary>
	/// factory class deal with the DAL
	/// </summary>
	public static class AccountInfoFacotry
	{
		public static List<string> Errors = new List<string>();

		#region Logs Related

		/// <summary>
		/// Logs the file progress/errors
		/// </summary>
		/// <param name="fileGuid"></param>
		/// <param name="zip"></param>
		/// <param name="file"></param>
		/// <param name="msg">message to log</param>
		/// <param name="status">0= FAIL, 1= SUCESS, 2= PROCESSING</param>
		/// <param name="insertDate">time stamp</param>
		/// <returns>id of the file</returns>
		public static int LogFileStatus( string fileGuid, string zip, string file, string msg, int status,
			DateTime insertDate )
		{
			int id = AccountInfoSql.GetID( fileGuid, zip );
			if (id==-1)
				id = AccountInfoSql.InsertFileLog( fileGuid, zip, file, msg, status, insertDate );
			else
				LogFileStatus( id, msg, status );
			return id;
		}

		/// <summary>
		/// Logs the file progress/errors
		/// </summary>
		/// <param name="id">id of the file</param>
		/// <param name="msg">message to log</param>
		/// <param name="status">0= FAIL, 1= SUCESS, 2= PROCESSING</param>
		/// <returns>true if database update was successfull</returns>
		public static bool LogFileStatus( int id, string msg, int status)
		{
			return AccountInfoSql.UpdateFileLog( id, msg, status );
		}

		/// <summary>
		/// Check if the file has been downloaded and processed successfully
		/// </summary>
		/// <param name="fileName">zipped file name</param>
		/// <returns>false if the file has not been downloaded or if it failed processing</returns>
		public static bool IsDownloadedAndProcessed( string fileName )
		{
			DataSet dsfileValues;
			dsfileValues = AccountInfoSql.AccountInfoFileSelect( fileName );

			if( !DataSetHelper.HasRow( dsfileValues ) )
				return false;

			DataRow drfileValues = dsfileValues.Tables[0].Rows[0];
			bool isProcessed = (drfileValues["Status"].ToString() == "1");
			return isProcessed;
		}

		/// <summary>
		/// insert the error message(account level)
		/// </summary>
		/// <param name="id">id of the file that has the error</param>
		/// <param name="msg">error message</param>
		public static void LogAccountStatus(int id, string msg)
		{
			AccountInfoSql.InsertAccountLog( id, msg );
		}

		#endregion

		#region Accounts related
		/// <summary>
		/// insert the accounts into the database
		/// </summary>
		/// <param name="dt">dataTable containing the accounts</param>
		/// <returns></returns>
		public static bool InsertSettlement( DataTable dt )
		{
			try
			{
				AccountInfoSql.InsertSettlement( dt );
				AccountInfoSql.InsertSettlementFromTemp();
				return true;
			}
			catch
			{
				return false;
			}
		}

        /// <summary>
        /// Get zone value from Substation EDI value
        /// </summary>
        /// <param name="dt">dataTable containing the accounts</param>
        /// <returns></returns>
        public static string GetZoneValueBySubstation(string substationValue)
        {
            try
            {
                return AccountInfoSql.GetZoneValueBySubstationEDIValue(substationValue);
            }
            catch
            {
                throw;
            }
        }

		/// <summary>
		/// insert the accounts into the database
		/// </summary>
		/// <param name="dt">dataTable containing the accounts</param>
		/// <returns></returns>
		public static bool InsertAccounts( DataTable dt, out string msg )
		{
			msg = string.Empty;
			try
			{
				AccountInfoSql.InsertAccounts( dt );
				AccountInfoSql.InsertAccountsFromTemp();
				return true;
			}
			catch (Exception ex)
			{
				msg = ex.Message;
				//make sure temp table is deleted
				AccountInfoSql.AccountsTempDelete();
				return false;
			}
		}
                
		/// <summary>
		/// get the data for a specific account number
		/// </summary>
		/// <param name="accountNumber">account number</param>
		/// <returns>AccountInfoProperties object</returns>
		public static AccountInfoProperties AccountsInfoSelect( string accountNumber )
		{
			DataSet dsAccount;
			dsAccount = AccountInfoSql.AccountsInfoSelect( accountNumber );

			if( !DataSetHelper.HasRow( dsAccount ) )
				return null;
			DataRow drAccount = dsAccount.Tables[0].Rows[0];
			return new AccountInfoProperties
			{
				FileLogID = int.Parse( drAccount["FileLogID"].ToString() ),
				ESIID = drAccount["ESIID"].ToString(),
				Address = drAccount["ADDRESS"].ToString(),
				AddressOverflow = (drAccount["ADDRESS_OVERFLOW"] != DBNull.Value) ? drAccount["ADDRESS_OVERFLOW"].ToString() : string.Empty,
				City = drAccount["CITY"].ToString(),
				State = drAccount["STATE"].ToString(),
				ZipCode = (drAccount["ZIPCODE"].ToString().Length.Equals( 9 )) ? drAccount["ZIPCODE"].ToString().Substring( 0, 5 ) : drAccount["ZIPCODE"].ToString(),
				ZipCode4 = (drAccount["ZIPCODE"].ToString().Length.Equals(9))?  drAccount["ZIPCODE"].ToString().Substring(5,4) : string.Empty,
				DUNS = drAccount["DUNS"].ToString(),
				MeterReadCycle = drAccount["METER_READ_CYCLE"].ToString(),
				Status = drAccount["STATUS"].ToString(),
				PremiseType = drAccount["PREMISE_TYPE"].ToString(),
				PowerRegion = drAccount["POWER_REGION"].ToString(),
				StationCode = drAccount["STATIONCODE"].ToString(),
				StationName = drAccount["STATIONNAME"].ToString(),
				Metered = drAccount["METERED"].ToString(),
				OpenServiceOrders = (drAccount["OPEN_SERVICE_ORDERS"]!= DBNull.Value)?drAccount["OPEN_SERVICE_ORDERS"].ToString(): string.Empty,
				PolrCustomerClass = drAccount["POLR_CUSTOMER_CLASS"].ToString(),
				AMSMeterFlag = drAccount["AMS_METER_FLAG"].ToString(),
				TdpAMS = drAccount["TDSP_AMS_INDICATOR"].ToString(),
				SwitchHoldFlag = drAccount["SWITCH_HOLD_INDICATOR"].ToString(),
				SettlementLoadZone = drAccount["DCZone"].ToString()
			};
		}


		#endregion

	}
}
