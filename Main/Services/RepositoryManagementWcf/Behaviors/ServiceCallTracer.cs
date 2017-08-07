using System;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Dispatcher;
using LibertyPower.RepositoryManagement.Contracts;
using LibertyPower.RepositoryManagement.Contracts.Common.v1;
using LibertyPower.RepositoryManagement.Core.Instrumentation;
using LibertyPower.RepositoryManagement.Data;
using LibertyPower.RepositoryManagement.Services;

namespace LibertyPower.RepositoryManagement.Web
{
    public class ServiceCallTracer : IDispatchMessageInspector, IClientMessageInspector
    {
        private string GetClientIp()
        {
            var endpointProperty = OperationContext.Current.IncomingMessageProperties[RemoteEndpointMessageProperty.Name] as RemoteEndpointMessageProperty;
            return (endpointProperty != null) ? endpointProperty.Address : string.Empty;
        }

        private void Log(Guid messageId, ref Message input)
        {
            var buffer = input.CreateBufferedCopy(int.MaxValue);
            var message = buffer.CreateMessage();
            var content = message.ToString();

            using (var reader = message.GetReaderAtBodyContents())
                if (content != null) content = content.Replace("... stream ...", reader.ReadOuterXml());

            var trace = new ServiceCallTrace() { Action = OperationContext.Current.IncomingMessageHeaders.Action, Ip = GetClientIp(), Guid = messageId, Timestamp = DateTime.Now, Message = content };
            //TODO: This needs to be Ninjected!
            var tracer = new TracingService(new TracingRepository(Connections.RepositoryManagement));
            tracer.Log(trace);

            input = buffer.CreateMessage();
        }

        #region IDispatchMessageInspector Members
        public object AfterReceiveRequest(ref Message request, IClientChannel channel, InstanceContext instanceContext)
        {
            var id = Guid.NewGuid();
            Log(id, ref request);
            return id;
        }

        public void BeforeSendReply(ref Message reply, object correlationState)
        {
            var id = (correlationState == null) ? Guid.NewGuid() : (Guid)correlationState;
            if (reply == null)
                return;

            reply.Headers.Add(MessageHeader.CreateHeader("Trace", ContractNamespaces.CommonV1, new Trace() { Id = id, Build = Version.Build }));
            Log(id, ref reply);
        }
        #endregion

        #region IClientMessageInspector Members
        public void AfterReceiveReply(ref Message reply, object correlationState)
        { }

        public object BeforeSendRequest(ref Message request, IClientChannel channel)
        {
            return null;
        }
        #endregion
    }
}