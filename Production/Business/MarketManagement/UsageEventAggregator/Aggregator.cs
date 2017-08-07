using System;
using System.Collections.Generic;
using Common.Logging;
using UsageEventAggregator.Helpers;

namespace UsageEventAggregator
{
    public class Aggregator
    {
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        private static readonly IEventAggregator EventAggregator = Locator.Current.GetAggregator();

        public static void Publish<T>(T message)
        {
           Publish(message, 0);
        }

        public static void Publish<T>(T message, long correlationId)
        {
            if (EventAggregator == null)
            {
                Log.Error(string.Format("Could not send message of type {0} and correlation id {1} because aggregator not found", typeof(T).Name, correlationId));
                return;
            }

            EventAggregator.Publish(message, correlationId);
        }

        public static List<Uri> GetSubscriptions<T>()
        {
            if (EventAggregator == null)
            {
                Log.Error(string.Format("Could not load subscriptions for {0} because aggregator not found", typeof(T).Name));
                return new List<Uri>();
            }

            return EventAggregator.GetSubscriptions<T>();

        }
    }
}