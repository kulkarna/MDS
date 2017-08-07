using System;

namespace UsageEventAggregator.EventTransports
{
    public interface ITransport
    {
        event EventHandler<TransportMessageReceivedEventArgs> TransportMessageReceived;

        void Start(string topic);
        
    }
}