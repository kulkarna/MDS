namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using System.IO;
    using System.Net;
    using LibertyPower.DataAccess.WebAccess.WebScraperManagement;
    using LibertyPower.Business.CommonBusiness.FieldHistory;
    using System.Collections;
    using System.Collections.Generic;
    using System.Data;
    using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
    using LibertyPower.DataAccess.SqlAccess.TransactionsSql;
    using System;

    public static class AmerenFactory
    {
        private static FieldHistoryManager.MapField _applyMapping = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityMappingFactory.ApplyMapping;

        public static WebAccountList GetUsage(string accountNumber, out string message)
        {
            string htmlContent = AmerenScraper.GetUsageHtml(accountNumber);
            AmerenParser parser = new AmerenParser(htmlContent);
            WebAccountList account = parser.Parse();

            message = string.Empty;

            foreach (Ameren meter in account)
            {
                meter.AccountNumber = accountNumber;

                BusinessRule rule = new AmerenAccountDataExistsRule(meter);

                if (!rule.Validate())
                    ExceptionLogger.LogAccountExceptions(meter);

                MessageFormatter messageFormatter = new MessageFormatter(rule.Exception);

                message = messageFormatter.Format();
            }
            AcquireAndStoreDeterminantHistory(account);
            return account;
        }

        private static void AcquireAndStoreDeterminantHistory(WebAccountList meters)
        {

            if (meters.Count > 0)
            {
                DataSet ds = OfferSql.AccountExistsInOfferEngine(meters[0].AccountNumber, "AMEREN");
                if (ds.Tables[0].Rows[0]["Exists"].ToString() == "0" && !TransactionsSql.HasUsageTransaction(meters[0].AccountNumber, "AMEREN"))
                    return;
                var max_iCap_index = 0;
                var max_iCap = 0M;
                var iCapSum = 0M;
                List<string> servicePoints = new List<string>();
                for (var i = 0; i < meters.Count; i++)
                {
                    if (i == 0)
                    {
                        servicePoints.Add(((Ameren)meters[i]).ServicePoint);
                        max_iCap = ((Ameren)meters[i]).EffectivePLC;
                        max_iCap_index = 0;
                        iCapSum += ((Ameren)meters[i]).EffectivePLC;
                    }
                    else
                    {
                        var buf = ((Ameren)meters[i]).EffectivePLC;
                        if (!servicePoints.Contains(((Ameren)meters[i]).ServicePoint))
                        {
                            servicePoints.Add(((Ameren)meters[i]).ServicePoint);
                            iCapSum += buf;
                        }
                        max_iCap_index = buf > max_iCap ? i : max_iCap_index;
                        max_iCap = buf > max_iCap ? buf : max_iCap;
                    }
                }

                var aid = new AccountIdentifier("AMEREN", meters[0].AccountNumber);
                var billGroup = ((Ameren)meters[max_iCap_index]).BillGroup ?? string.Empty;

                if (!string.IsNullOrWhiteSpace(billGroup) && Convert.ToInt16(billGroup) > -1)
                {
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.BillGroup, billGroup , null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                }
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.Utility, "AMEREN", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);

                if (iCapSum >= 0)
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, iCapSum.ToString(), null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);

                FieldHistoryManager.FieldValueInsert(aid, TrackedField.Zone, ((Ameren)meters[0]).OperatingCompany ?? "", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.Voltage, ((Ameren)meters[max_iCap_index]).MeterVoltage ?? "", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadProfile, ((Ameren)meters[max_iCap_index]).LoadShapeId ?? "", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.RateClass, ((Ameren)meters[max_iCap_index]).ServiceClass ?? "", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
            }
        }
    }
}
