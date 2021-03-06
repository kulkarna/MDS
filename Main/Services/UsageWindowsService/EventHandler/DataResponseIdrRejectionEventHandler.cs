﻿using System.Linq;
using Common.Logging;
using UsageEventAggregator;
using UsageEventAggregator.Events.DataResponse;
using UsageEventAggregator.Helpers;
using UsageWindowsService.Repository;

namespace UsageWindowsService.EventHandler
{
    public class DataResponseIdrRejectionEventHandler : IHandleEvents<DataResponseIdrRejection>
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();

        public void Handle(DataResponseIdrRejection e)
        {
            Log.Info(string.Format("Usage collect failed with transaction id {0} and error was {1}", e.TransactionId, e.Message));
            var repository = Locator.Current.GetInstance<IRepository>();
            repository.SetTransactionAsComplete(e.TransactionId, e.Message);

            var subscriptions = Locator.Current.GetInstances<ISubscriber<DataResponseIdrRejection>>();
            if (!subscriptions.Any())
                return;

            foreach (var subscription in subscriptions)
                subscription.Send(e);
        }
    }
}