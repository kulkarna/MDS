using System;
using UsageEventAggregator.Events;

namespace UsageEventAggregator.EventTransports
{
    public class TransportMessageReceivedEventArgs : EventArgs
    {
        /// <summary>
        /// Initializes a new TransportMessageReceivedEventArgs.
        /// </summary>
        /// <param name="m">The message that was received.</param>
        public TransportMessageReceivedEventArgs(EventTransportMessage m)
        {
            eventMessage = m;
        }

        private readonly EventTransportMessage eventMessage;

        /// <summary>
        /// Gets the message received.
        /// </summary>
        public EventTransportMessage EventMessage
        {
            get { return eventMessage; }
        }
    }
}