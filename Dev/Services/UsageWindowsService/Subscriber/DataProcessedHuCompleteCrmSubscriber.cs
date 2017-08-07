using System;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.DataProcessed;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;

namespace UsageWindowsService.Subscriber
{
    public class DataProcessedHuCompleteCrmSubscriber : ISubscriber<DataProcessedHuComplete>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Send(DataProcessedHuComplete eventMessage)
        {
            var repository = Locator.Current.GetInstance<IRepository>();

            try
            {
                var utilityId = repository.GetUtilityId(eventMessage.UtilityCode);

                var crm = new CrmDataRequestService.DataRequestClient();
                if(Log.IsTraceEnabled)
                    Log.Trace(string.Format("Sending crm hu complete for account {0} utility {1} source {2}", eventMessage.AccountNumber, utilityId, eventMessage.Source));

                crm.HuComplete(eventMessage.AccountNumber, utilityId, true, string.Empty, eventMessage.Source);

                repository.SetTransactionAsComplete(eventMessage.TransactionId);
          
                Log.Debug(string.Format("Sent CRM UsageProcessedHuComplete. Account {0} Utility {1} Source {2}",
                                   new object[] { eventMessage.AccountNumber, utilityId, eventMessage.Source }));

                var repoMan = new OfferEngineAccountsService.AccountsClient();
                repoMan.UpdateCrmIfAccountMeetsPropertiesRequirements(utilityId, eventMessage.AccountNumber);

                Log.Debug(string.Format("Repo man update account request sent. Account {0} Utility {1} Source {2}",
                                    new object[] { eventMessage.AccountNumber, utilityId, eventMessage.Source }));

            }
            catch (Exception ex)
            {
                repository.SetTransactionAsComplete(eventMessage.TransactionId, ex.ToString());
                Log.Error(ex.Message, ex);
                throw;
            }
        }
    }
}