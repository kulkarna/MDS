namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// The schwarzenegger object.
	///  Class for removing bad data.
	/// </summary>
	public static class Terminator
	{
		/// <summary>
		/// Removes accounts that have errors
		/// </summary>
		/// <param name="ediFile">Edi file object</param>
		/// <returns>Returns an edi account list that has no errors.</returns>
		public static EdiAccountList RemoveBadAccounts( EdiFile ediFile )
		{
			EdiAccountList accountListToProcess = new EdiAccountList();
			EdiAccountList accountList = ediFile.EdiAccountList;

			// iterate through accounts, adding only accounts that have no "error" flag
			foreach( EdiAccount account in accountList )
			{
				// add to list for processing
				if( !account.AccountDataExistsRule.DefaultSeverity.Equals( BrokenRuleSeverity.Error ) )
					accountListToProcess.Add( account );
				else // set edi file flag to "error", file is not fully processed
					ediFile.EdiFileValidRule.DefaultSeverity = BrokenRuleSeverity.Error;
			}
			return accountListToProcess;
		}
	}
}
