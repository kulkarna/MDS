using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;
using LibertyPower.RepositoryManagement.Core;
using LibertyPower.RepositoryManagement.Web;

namespace LibertyPower.RepositoryManagement.Contracts.Common.v1
{
    public class ExceptionToFaultMapper : IErrorHandler, IServiceBehavior
    {
        public void AddBindingParameters(
            ServiceDescription serviceDescription,
            ServiceHostBase serviceHostBase,
            Collection<ServiceEndpoint> endpoints,
            BindingParameterCollection bindingParameters)
        { }

        public void ApplyDispatchBehavior(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
        {
            IErrorHandler errorHandler = new ExceptionToFaultMapper();
            foreach (var channelDispatcherBase in serviceHostBase.ChannelDispatchers)
            {
                var channelDispatcher = channelDispatcherBase as ChannelDispatcher;
                if (channelDispatcher != null)
                    channelDispatcher.ErrorHandlers.Add(errorHandler);
            }
        }

        public bool HandleError(Exception error)
        {
            EventLogger.WriteEntry(error.ToString(), EventLogEntryType.Error);
            return true;
        }

        public void Validate(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
        { }

        public void ProvideFault(Exception error, MessageVersion version, ref Message fault)
        {
            if (error is BusinessProcessException)
                CreateFault<BusinessProcessError>(error, version, ref fault);
            else if (error is ValidationException)
                CreateFault<RequestValidationError>(error, version, ref fault);
            else if (error is DataStoreException)
                CreateFault<DataStoreError>(error, version, ref fault);
            else
                CreateFault<SystemError>(error, version, ref fault);
        }

        private void CreateFault<T>(Exception error, MessageVersion version, ref Message fault) where T : new()
        {
            CreateFault<T>(error.Message, version, ref fault);
        }

        private void CreateFault<T>(string message, MessageVersion version, ref Message fault) where T : new()
        {
            var serviceFault = new T();
            var faultException = new FaultException<T>(serviceFault, new FaultReason(message));
            var faultMessage = faultException.CreateMessageFault();
            fault = Message.CreateMessage(version, faultMessage, faultException.Action);
        }
    }
}