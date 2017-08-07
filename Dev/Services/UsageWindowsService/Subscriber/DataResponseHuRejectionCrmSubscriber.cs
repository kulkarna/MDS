using System;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.DataResponse;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;

namespace UsageWindowsService.Subscriber
{
    public class DataResponseHuRejectionCrmSubscriber : ISubscriber<DataResponseHuRejection>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();


        public void Send(DataResponseHuRejection eventMessage)
        {
            var repository = Locator.Current.GetInstance<IRepository>();

            try
            {


                var utilityId = repository.GetUtilityId(eventMessage.UtilityCode);

                var service = new CrmDataRequestService.DataRequestClient();
                if (Log.IsTraceEnabled)
                    Log.Trace(string.Format("Sending crm hu response for account {0} utility {1} message {2}", eventMessage.AccountNumber, utilityId, eventMessage.Message));

                service.HuResponse(eventMessage.AccountNumber, utilityId, true, eventMessage.Message, false);
  
                repository.SetTransactionAsComplete(eventMessage.TransactionId, eventMessage.Message);
  
                Log.Debug(string.Format("Sent CRM UsageResponseHuRejection. Account {0} Utility {1} Source {2} Message {3}",
           new object[] { eventMessage.AccountNumber, eventMessage.UtilityCode, eventMessage.Source, eventMessage.Message }));

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