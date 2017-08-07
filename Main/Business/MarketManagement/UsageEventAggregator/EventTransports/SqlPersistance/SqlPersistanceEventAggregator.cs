using System;
using System.Collections.Generic;
using System.Reflection;
using Common.Logging;
using UsageEventAggregator.Events;
using UsageEventAggregator.Helpers;

namespace UsageEventAggregator.EventTransports.SqlPersistance
{
    public class SqlPersistanceEventAggregator : IEventAggregator
    {
        private readonly SqlPersistanceTransport _transport;
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        
        
        public SqlPersistanceEventAggregator()
        {
            var messageTypes = Locator.Current.GetAllMessageTypes();
            _transport = new SqlPersistanceTransport(messageTypes);
            _transport.TransportMessageReceived += (s, e) => _ProcessMessage(e.EventMessage);
        }

        public void Publish<T>(T message, long correlationId)
        {
            var body = string.Empty; 
            try
            {
                var eventMessage = message as IEventMessage;
                if (eventMessage != null)
                {
                    if (eventMessage.TransactionId != 0)
                        correlationId = eventMessage.TransactionId;
                    else eventMessage.TransactionId = correlationId;
                }

                body = Serializer.Serialize(message);
                var transportMessage = new EventTransportMessage
                {
                    Body = body,
                    CorrelationId = correlationId,
                    MessageType = typeof(T).Name
                };

                _transport.SendEventMessage(transportMessage);
                Log.Debug(string.Format("Published message of type: {0} and correlation id of: {1}", transportMessage.MessageType, transportMessage.CorrelationId));
            }
            catch (Exception ex)
            {
                Log.Error(string.Format("Could not publish message with correlation id of: {1} and body of: {1}. The Exception was {2}", correlationId, body, ex.Message), ex);
            }
            
        }

        public List<Uri> GetSubscriptions<T>()
        {
            throw new NotImplementedException();
        }

        public void Subscribe<T>()
        {
            throw new NotImplementedException();
        }

        public void Unsubscribe<T>()
        {
            throw new NotImplementedException();
        }

        public void Publish<T>(T message)
        {
            Publish(message, 0);
        }

        private void _ProcessMessage(EventTransportMessage eventTransportMessage)
        {
            try
            {
                Log.Debug(string.Format("Processing {0} event with transaction id {1} with message {2}", eventTransportMessage.MessageType, eventTransportMessage.CorrelationId, eventTransportMessage.Body));

                var messageType = eventTransportMessage.MessageType.Trim();
                var handler = Locator.Current.GetEventHandler(messageType);
                if (handler == null)
                {
                    Log.Debug("Could not find handler for message type of " + messageType);
                    return;
                }
                var handlerType = handler.GetType();
                var type = handlerType.GetInterfaces()[0].GenericTypeArguments[0];
            
                var message = Serializer.Deserialize(eventTransportMessage.Body, type);

                var eventMessage = message as IEventMessage;
                if (eventMessage != null && eventMessage.TransactionId == 0)
                    eventMessage.TransactionId = eventTransportMessage.CorrelationId;
            
                handlerType.InvokeMember("Handle", BindingFlags.InvokeMethod, null, handler, new[] { message });
       
                _transport.MarkMessageAsProcessedBySubscriber(eventTransportMessage.Id);
            }
            catch (Exception ex)
            {
                Log.Error("Error processing message id " + eventTransportMessage.Id + ". Error was " + ex.GetBaseException().Message, ex);
                _transport.MarkMessageAsProcessedBySubscriber(eventTransportMessage.Id, ex.ToString());
            }
            
        }

    }
}