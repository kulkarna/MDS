namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.WebAccess.WebScraperManagement;
    using LibertyPower.Business.CommonBusiness.FieldHistory;
	using System.Data;
	using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
    using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
	using System;

	public static class ComedFactory
	{
		private static FieldHistoryManager.MapField _applyMapping = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityMappingFactory.ApplyMapping;

		public static Comed GetUsage( string accountNumber, string meterNumber, out string message )
		{
			Comed        account;
			string       htmlContent = ComedScraper.GetUsageHtml( accountNumber, meterNumber );

			if( htmlContent == "Account number is not valid." | htmlContent == "Account has been blocked per customer request." )
			{
				message = htmlContent;
				return account = null;
			}

			ComedParser  parser      = new ComedParser( htmlContent );
				         account     = parser.Parse();
			BusinessRule rule        = new ComedAccountDataExistsRule( account );

			account.AccountNumber = accountNumber;

			if( !rule.Validate() && rule.Exception.Severity.Equals( BrokenRuleSeverity.Error ) )
				ExceptionLogger.LogAccountExceptions( account );

			MessageFormatter messageFormatter = new MessageFormatter( rule.Exception );

			message = messageFormatter.Format();
			AcquireAndStoreDeterminantHistory( account );

			return account;
		}

        private static void AcquireAndStoreDeterminantHistory(Comed account)
        {
            if (account!=null && account.AccountNumber.Length > 0)
            {
				DataSet ds = OfferSql.AccountExistsInOfferEngine( account.AccountNumber, "COMED" );
                if (ds.Tables[0].Rows[0]["Exists"].ToString() == "0" && !TransactionsSql.HasUsageTransaction(account.AccountNumber, "COMED"))
					return;
                var aid = new AccountIdentifier("COMED", account.AccountNumber);
                var billGroup = account.BillGroup ?? string.Empty;
                
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.Utility, "COMED", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                
                if (account.CapacityPLC.Count > 0)
                {
                    var startDate = account.CapacityPLC[0].StartDate;
                    if (startDate < DateTime.Now)
                        startDate = DateTime.Now;
					if(account.CapacityPLC[0].Value >=0)
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, account.CapacityPLC[0].Value.ToString(), startDate, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);

                    // Issue #28616 - Future ICap - Per Jikku, get only if second record (Future Icap) is present.
                    if (account.CapacityPLC.Count > 1)
                    {
                        startDate = account.CapacityPLC[1].StartDate;
                        if (startDate < DateTime.Now)
                            startDate = DateTime.Now;
                        if (account.CapacityPLC[1].Value >= 0)
                            FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap,
                                                                 account.CapacityPLC[1].Value.ToString(), startDate,
                                                                 FieldUpdateSources.WebScraping, "",
                                                                 FieldLockStatus.Unknown, _applyMapping);
                    }
                }
                

                if (account.NetworkServicePLC.Count > 0)
                {
                    var startDate = account.NetworkServicePLC[0].StartDate;
                    if (startDate < DateTime.Now)
                        startDate = DateTime.Now;
					if(account.NetworkServicePLC[0].Value >=0)
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.TCap, account.NetworkServicePLC[0].Value.ToString(), startDate, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);

                    // Issue #28616 - Future TCap - Per Jikku, get only if second record (Future Tcap) is present.
                    if (account.NetworkServicePLC.Count > 1)
                    {
                        startDate = account.NetworkServicePLC[1].StartDate;
                        if (startDate < DateTime.Now)
                            startDate = DateTime.Now;
                        if (account.NetworkServicePLC[1].Value >= 0)
                            FieldHistoryManager.FieldValueInsert(aid, TrackedField.TCap, account.NetworkServicePLC[1].Value.ToString(), startDate, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                    }                
                }

                FieldHistoryManager.FieldValueInsert(aid, TrackedField.RateClass, account.Rate ?? "", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                if (!string.IsNullOrWhiteSpace(billGroup) && Convert.ToInt16(billGroup) > -1)
                {
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.BillGroup, billGroup, null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                }
            }
        }

	}
}
