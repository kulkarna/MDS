using System;
using System.ServiceModel.Configuration;

namespace LibertyPower.RepositoryManagement.Web
{
    public class ServiceCallTracerBehaviorExtension : BehaviorExtensionElement
    {
        //TODO: Revisit extension, didn't work with config, applied directly to the service for now
        protected override object CreateBehavior()
        {
            return new ServiceCallTracerBehavior();
        }
        public override Type BehaviorType
        {
            get { return typeof(ServiceCallTracerBehavior); }
        }
    }
}