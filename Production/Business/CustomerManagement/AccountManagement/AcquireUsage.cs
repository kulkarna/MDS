using System.Data;
using LibertyPower.Business.MarketManagement.EdiManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.DataAccess.SqlAccess.EnrollmentSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class AcquireUsage
	{
		public Utility Utility { get; set; }

		public string AccountNumber { get; set; }

		public string ProcessName { get; set; }

		public string ResultMessage { get; set; }

		public AcquireUsage( Utility utility, string actNumber, string processName )
		{
			Utility = utility;
			AccountNumber = actNumber;
			ProcessName = processName; //ENROLLMENT
		}

		public void Run( string contractNumber, string accountId, string userName )
		{
			//if( Utility.IsScrapable )
				GetAndProcessScrapableUsage( contractNumber, accountId, userName );
		}

		private void GetAndProcessScrapableUsage( string contractNumber, string accountId, string userName )
		{
			string strMsg = string.Empty;
			string errorMsg = string.Empty;
			bool isEXception = false;
			try
			{
				ScraperFactory.RunScraper( AccountNumber, Utility.Code, "", out strMsg );
			}
			catch
			{
				errorMsg = "Please manually check account " + AccountNumber + " on " + Utility.Code + "'s website <br>";
				isEXception = true;
			}

			if( !isEXception )
				errorMsg = HandleResponse( strMsg, contractNumber, accountId, userName );

			ResultMessage = errorMsg;
		}

		private string HandleResponse( string message, string contractNumber, string accountId, string userName )
		{
			string errorMsg = "";
			string value = "";

			if( message.Contains( "Missing data - Web Usage List Data" ) )
			{
				errorMsg = "Account " + AccountNumber + " is missing Historical Usage";
				RejectAccount( contractNumber );
				return string.Format( " {0}<br>", errorMsg );
			}
			
			value = UpdateSystem( accountId, userName );		//update annual usage..
			if( value.Length > 0 )
				errorMsg = string.Format( " {0}<br>", value );

			return errorMsg;
		}

		private string UpdateSystem( string accountId, string userName )
		{
			// calculate annual usage
			bool bSuccess = false;
			bSuccess = CompanyAccountFactory.CalculateAnnualUsage( AccountNumber, this.Utility.Code, userName, ProcessName, false, accountId );

			if( !bSuccess )
			{
				//Ticket 1-5903271
				string message;

				DataSet ds = UsageSql.CheckAuditUsageUsed( AccountNumber );
				if( CommonBusiness.CommonHelper.DataSetHelper.HasRow( ds ) && ds.Tables[0].Rows[0]["ErrorMessage"] != null )
					message = "There was an error while calculating " + AccountNumber + "'s annual usage, the error is described as: " + ds.Tables[0].Rows[0]["ErrorMessage"].ToString().Trim();
				else
					message = "There was an error while calculating " + AccountNumber + "'s annual usage; please have IT check the AuditUsageUsedLog log.";

				return message;
			}

			// update check_account status..
			MeterReadSql.AccountUsageUpdate( AccountNumber );

			// record usage event..
			AccountEventType aet = AccountEventType.UsageUpdate;
			AccountEventType eventAssociate = AccountEventType.DealSubmission;

			AccountEventProcessor.ProcessEvent( eventAssociate, aet, AccountNumber, this.Utility.Code, ResponseType.None, null );

			return string.Empty;
		}

		private void RejectAccount( string contractNumber )
		{
			EnrollmentSql.CheckAccountApprovalReject( "USAGE ACQUIRE SCRAPER", contractNumber, " ", "USAGE ACQUIRE", ProcessName,
			                                         "REJECTED", "New (no historical usage) or Invalid account");
		}
	}
}
