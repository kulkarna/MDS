using System;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.DataProcessed;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;

namespace UsageWindowsService.Subscriber
{
    public class DataProcessedIdrCompleteCrmSubscriber : ISubscriber<DataProcessedIdrComplete>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Send(DataProcessedIdrComplete eventMessage)
        {
            var repository = Locator.Current.GetInstance<IRepository>();

            try
            {

                var utilityId = repository.GetUtilityId(eventMessage.UtilityCode);

                var service = new CrmDataRequestService.DataRequestClient();
                if (Log.IsTraceEnabled)
                    Log.Trace(string.Format("Sending crm idr complete for account {0} utility {1} source {2}", eventMessage.AccountNumber, utilityId, eventMessage.Source));

                service.IdrComplete(eventMessage.AccountNumber, utilityId, true, string.Empty, eventMessage.Source);

                repository.SetTransactionAsComplete(eventMessage.TransactionId);
              
                Log.Debug(string.Format("Sent CRM UsageProcessedIdrComplete. Account {0} Utility {1} Source {2}",
                        new object[] { eventMessage.AccountNumber, eventMessage.UtilityCode, eventMessage.Source }));

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