using System;
using System.Security.Principal;
using Common.Logging;
using LibertyPower.Business.MarketManagement.UsageManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using UsageEventAggregator;
using UsageEventAggregator.Events.Consolidation;

namespace UsageWindowsService.EventHandler
{
    public class ConsolidationRequestedEventHandler : IHandleEvents<UsageConsolidationRequested>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();


        public void Handle(UsageConsolidationRequested e)
        {
            Log.Debug(string.Format("Consolidation requested for account {0}, utility {1} and transaction {2}", e.AccountNumber, e.UtilityCode, e.TransactionId));
            try
            {
                _Consolidate(e.AccountNumber, e.UtilityCode, e.StartDate, e.EndDate);
                Aggregator.Publish(new UsageConsolidationCompleted
                {
                    AccountNumber = e.AccountNumber,
                    UtilityCode = e.UtilityCode,
                    TransactionId = e.TransactionId,
                    Source = e.Source
                }, e.TransactionId);
            }
            catch (Exception ex)
            {
                Aggregator.Publish(new UsageConsolidationFailed
                {
                    Message = ex.Message,
                    TransactionId = e.TransactionId,
                    AccountNumber = e.AccountNumber,
                    UtilityCode = e.UtilityCode,
                    Source = e.Source
                }, e.TransactionId);
                Log.Error(string.Format("Consolidation failed for transaction id of {0} with message: {1}", e.TransactionId, ex.Message), ex);
            }
            
            
        }

        private void _Consolidate(string accountNumber, string utilityCode, DateTime startDate, DateTime endDate )
        {
            string userName = string.Empty;
            var windowsIdentity = WindowsIdentity.GetCurrent();
            if (windowsIdentity != null)
            {
                userName = windowsIdentity.Name;
                userName = (string)userName.Split('\\').GetValue(1);
            }

            if (startDate == DateTime.MinValue)
                startDate = DateTime.Now.AddYears(-2);

            if (endDate == DateTime.MinValue)
                endDate = DateTime.Now;


            UsageList histList = UsageFactory.GetRawUsage(accountNumber, utilityCode, startDate, endDate, userName);

            UsageFiller.removeLingeringInactive(histList);

            if (UsageFactory.HasMultipleMeters(histList) && UsageFactory.RequiresCalendarization(histList))
                UsageFactory.CalendarizeUsage(histList);
            
        }
    }
}