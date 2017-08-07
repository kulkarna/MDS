using System;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.Collector;
using UsageEventAggregator.Events.DataProcessed;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;
using System.Configuration;

namespace UsageWindowsService.EventHandler
{
    public class IstaUsageRequestedEventHandler : IHandleEvents<IstaUsageRequested>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        private string _type;
        private const string SOURCE = "EDI";
        private static string useESGForUsageRequest = ConfigurationManager.AppSettings["UseESGForUsageRequest"];

        public void Handle(IstaUsageRequested e)
        {
            
            if ((e.NameKey != null) && (e.NameKey.Trim() != ""))
                e.NameKey = e.NameKey.ToUpper();
            Log.Debug(string.Format("Ista request being sent out with account {0}, utility {1} transaction id {2} and NameKey {3} ", e.AccountNumber, e.UtilityCode, e.TransactionId, e.NameKey));
            try
            {
                
                if (string.IsNullOrWhiteSpace(e.UsageType))
                    _type = "HU";
                else if (e.UsageType.Trim().Equals("HU", StringComparison.InvariantCultureIgnoreCase) ||
                         e.UsageType.Trim().Equals("HI", StringComparison.InvariantCultureIgnoreCase))
                    _type = e.UsageType;
                else _type = "HU";

                var repository = Locator.Current.GetInstance<IRepository>();
                var lpcDuns =  repository.GetLpcDunsNumber(e.UtilityCode);

                 int iUseESGForUsageRequest = 0;
                 int.TryParse(useESGForUsageRequest, out iUseESGForUsageRequest);

                if (string.IsNullOrEmpty(lpcDuns) && iUseESGForUsageRequest==0)
                    return;

                LibertyPower.DataAccess.WebServiceAccess.IstaWebService.UsageService.SubmitHistoricalUsageRequestPreEnrollment(e.AccountNumber, "11", "11",
                                                             "11", "11", e.Zip, "11",
                                                             "11", "9999999999", "11", "11",
                                                             "11", lpcDuns,
                                                             e.DUNS, "11", "11", "11",
                                                             "11", e.Zip,
                                                             e.NameKey, e.MeterNumber,
                                                             e.BillingAccountNumber, "UsageServicesRequester",
                                                             "11",
                                                             e.UtilityCode, "UsageServicesIstaRequest", _type);

                Log.Debug(string.Format("Ista request sent out with account {0}, utility {1} and transaction id {2} and NameKey {3}", e.AccountNumber, e.UtilityCode, e.TransactionId, e.NameKey));
            }
            catch (Exception ex)
            {
                if (_type == "HI")
                    Aggregator.Publish(new DataProcessedIdrFailed
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        TransactionId = e.TransactionId,
                        Message = "Ista service call failed with " + ex.Message,
                        Source = SOURCE
                    });
                else
                    Aggregator.Publish(new DataProcessedHuFailed
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        TransactionId = e.TransactionId,
                        Message = "Ista service call failed with " + ex.Message,
                        Source = SOURCE
                    });
                Log.Error("Ista request failed with message " + ex.Message, ex);

            }

        }
    }
}