using System;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.DataResponse;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;

namespace UsageWindowsService.Subscriber
{
    public class DataResponseHuAcceptanceCrmSubscriber : ISubscriber<DataResponseHuAcceptance>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Send(DataResponseHuAcceptance eventMessage)
        {

            var repository = Locator.Current.GetInstance<IRepository>();

            try
            {
     
                var utilityId = repository.GetUtilityId(eventMessage.UtilityCode);

                var service = new CrmDataRequestService.DataRequestClient();
                if (Log.IsTraceEnabled)
                    Log.Trace(string.Format("Sending crm hu response for account {0} utility {1} message {2}", eventMessage.AccountNumber, utilityId, eventMessage.Message));

                service.HuResponse(eventMessage.AccountNumber, utilityId, false, eventMessage.Message, eventMessage.IdrDataAvailable);

                Log.Debug(string.Format("Sent CRM UsageResponseHuAcceptance. Account {0} Utility {1} Source {2} Message {3} HIA {4}",
                      new object[] { eventMessage.AccountNumber, eventMessage.UtilityCode, eventMessage.Source, eventMessage.Message, eventMessage.IdrDataAvailable }));

            }
            catch (Exception ex)
            {
                Log.Error(ex.Message, ex);
                
                repository.SetTransactionAsComplete(eventMessage.TransactionId, ex.ToString());
                
                throw;
            }

            
        }
    }
}