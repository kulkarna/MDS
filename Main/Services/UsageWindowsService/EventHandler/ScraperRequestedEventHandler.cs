using System;
using Common.Logging;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using UsageEventAggregator;
using UsageEventAggregator.Events.AccountPropertyHistory;
using UsageEventAggregator.Events.Collector;
using UsageEventAggregator.Events.Consolidation;
using UsageEventAggregator.Events.DataProcessed;
using UsageEventAggregator.Events.DataResponse;

namespace UsageWindowsService.EventHandler
{
    public class ScraperRequestedEventHandler : IHandleEvents<ScraperRequested>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        private const string SOURCE = "Scraper";

        public void Handle(ScraperRequested e)
        {
            var exceptions = string.Empty;
            
            Log.Debug(string.Format("Running scraper with account {0}, utility {1}", e.AccountNumber, e.UtilityCode));
            try
            {

               
                if (!(ScraperFactory.RunScraper(e.AccountNumber, e.UtilityCode, out exceptions)))
                {
                    Aggregator.Publish(new DataResponseHuRejection
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        Message = exceptions,
                        Source = SOURCE,
                        TransactionId = e.TransactionId
                    });
                }
                //If call success trigger the rest of the process.
                Aggregator.Publish(new UsageConsolidationRequested
                {
                    AccountNumber = e.AccountNumber,
                    UtilityCode = e.UtilityCode,
                    TransactionId = e.TransactionId,
                    Source = SOURCE
                });

                Aggregator.Publish(new DataSyncRequested
                {
                    AccountNumber = e.AccountNumber,
                    UtilityCode = e.UtilityCode,
                    TransactionId = e.TransactionId,
                    Source = SOURCE
                });
                
                /*PBI-93928- Since the  RunScraper method was false even for informational message, comment out the return value check. Exceptions will be handled within Try Block.
                //Ignoring exceptions since they are just informational.
                if(ScraperFactory.RunScraper(e.AccountNumber, e.UtilityCode, out exceptions))
                {
                    Aggregator.Publish(new UsageConsolidationRequested
                        {
                            AccountNumber = e.AccountNumber,
                            UtilityCode = e.UtilityCode,
                            TransactionId = e.TransactionId,
                            Source = SOURCE
                        });

                        Aggregator.Publish(new DataSyncRequested
                        {
                            AccountNumber = e.AccountNumber,
                            UtilityCode = e.UtilityCode,
                            TransactionId = e.TransactionId,
                            Source = SOURCE
                        });
                }
                else
                    Aggregator.Publish(new DataResponseHuRejection
                    {
                        AccountNumber = e.AccountNumber,
                        UtilityCode = e.UtilityCode,
                        Message = exceptions,
                        Source = SOURCE,
                        TransactionId = e.TransactionId
                    });
                 * */
            }
            catch (Exception ex)
            {

                Aggregator.Publish(new DataProcessedHuFailed
                {
                    Message = "Scraper service call failed with " + ex.Message,
                    AccountNumber = e.AccountNumber,
                    UtilityCode = e.UtilityCode,
                    TransactionId = e.TransactionId,
                    Source = SOURCE
                });
                Log.Error(string.Format("Scraper failed for transaction id of {0} with message: {1}", e.TransactionId, ex.Message), ex);
            }
      
            



        }
    }
}