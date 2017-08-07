using System;
using System.Collections.Generic;

namespace UsageEventAggregator
{
    public interface IEventAggregator
    {
        void Subscribe<T>();
        void Unsubscribe<T>();
        void Publish<T>(T message);
        void Publish<T>(T message, long correlationId);

        List<Uri> GetSubscriptions<T>();
    }
}