﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18408
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RepositoryManagementCommon.DataRequest {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="DataRequest.IDataRequest")]
    public interface IDataRequest {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/AiComplete", ReplyAction="http://tempuri.org/IDataRequest/AiCompleteResponse")]
        void AiComplete(string accountNumber, int utilityId, bool successful, string message, string source);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/AiComplete", ReplyAction="http://tempuri.org/IDataRequest/AiCompleteResponse")]
        System.Threading.Tasks.Task AiCompleteAsync(string accountNumber, int utilityId, bool successful, string message, string source);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/AiResponse", ReplyAction="http://tempuri.org/IDataRequest/AiResponseResponse")]
        void AiResponse(string accountNumber, int utilityId, bool rejection, string message);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/AiResponse", ReplyAction="http://tempuri.org/IDataRequest/AiResponseResponse")]
        System.Threading.Tasks.Task AiResponseAsync(string accountNumber, int utilityId, bool rejection, string message);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/HuComplete", ReplyAction="http://tempuri.org/IDataRequest/HuCompleteResponse")]
        void HuComplete(string accountNumber, int utilityId, bool successful, string message, string source);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/HuComplete", ReplyAction="http://tempuri.org/IDataRequest/HuCompleteResponse")]
        System.Threading.Tasks.Task HuCompleteAsync(string accountNumber, int utilityId, bool successful, string message, string source);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/HuResponse", ReplyAction="http://tempuri.org/IDataRequest/HuResponseResponse")]
        void HuResponse(string accountNumber, int utilityId, bool rejection, string message, bool isHia);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/HuResponse", ReplyAction="http://tempuri.org/IDataRequest/HuResponseResponse")]
        System.Threading.Tasks.Task HuResponseAsync(string accountNumber, int utilityId, bool rejection, string message, bool isHia);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/IdrComplete", ReplyAction="http://tempuri.org/IDataRequest/IdrCompleteResponse")]
        void IdrComplete(string accountNumber, int utilityId, bool successful, string message, string source);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/IdrComplete", ReplyAction="http://tempuri.org/IDataRequest/IdrCompleteResponse")]
        System.Threading.Tasks.Task IdrCompleteAsync(string accountNumber, int utilityId, bool successful, string message, string source);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/IdrResponse", ReplyAction="http://tempuri.org/IDataRequest/IdrResponseResponse")]
        void IdrResponse(string accountNumber, int utilityId, bool rejection, string message);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDataRequest/IdrResponse", ReplyAction="http://tempuri.org/IDataRequest/IdrResponseResponse")]
        System.Threading.Tasks.Task IdrResponseAsync(string accountNumber, int utilityId, bool rejection, string message);
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface IDataRequestChannel : RepositoryManagementCommon.DataRequest.IDataRequest, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class DataRequestClient : System.ServiceModel.ClientBase<RepositoryManagementCommon.DataRequest.IDataRequest>, RepositoryManagementCommon.DataRequest.IDataRequest {
        
        public DataRequestClient() {
        }
        
        public DataRequestClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public DataRequestClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public DataRequestClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public DataRequestClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public void AiComplete(string accountNumber, int utilityId, bool successful, string message, string source) {
            base.Channel.AiComplete(accountNumber, utilityId, successful, message, source);
        }
        
        public System.Threading.Tasks.Task AiCompleteAsync(string accountNumber, int utilityId, bool successful, string message, string source) {
            return base.Channel.AiCompleteAsync(accountNumber, utilityId, successful, message, source);
        }
        
        public void AiResponse(string accountNumber, int utilityId, bool rejection, string message) {
            base.Channel.AiResponse(accountNumber, utilityId, rejection, message);
        }
        
        public System.Threading.Tasks.Task AiResponseAsync(string accountNumber, int utilityId, bool rejection, string message) {
            return base.Channel.AiResponseAsync(accountNumber, utilityId, rejection, message);
        }
        
        public void HuComplete(string accountNumber, int utilityId, bool successful, string message, string source) {
            base.Channel.HuComplete(accountNumber, utilityId, successful, message, source);
        }
        
        public System.Threading.Tasks.Task HuCompleteAsync(string accountNumber, int utilityId, bool successful, string message, string source) {
            return base.Channel.HuCompleteAsync(accountNumber, utilityId, successful, message, source);
        }
        
        public void HuResponse(string accountNumber, int utilityId, bool rejection, string message, bool isHia) {
            base.Channel.HuResponse(accountNumber, utilityId, rejection, message, isHia);
        }
        
        public System.Threading.Tasks.Task HuResponseAsync(string accountNumber, int utilityId, bool rejection, string message, bool isHia) {
            return base.Channel.HuResponseAsync(accountNumber, utilityId, rejection, message, isHia);
        }
        
        public void IdrComplete(string accountNumber, int utilityId, bool successful, string message, string source) {
            base.Channel.IdrComplete(accountNumber, utilityId, successful, message, source);
        }
        
        public System.Threading.Tasks.Task IdrCompleteAsync(string accountNumber, int utilityId, bool successful, string message, string source) {
            return base.Channel.IdrCompleteAsync(accountNumber, utilityId, successful, message, source);
        }
        
        public void IdrResponse(string accountNumber, int utilityId, bool rejection, string message) {
            base.Channel.IdrResponse(accountNumber, utilityId, rejection, message);
        }
        
        public System.Threading.Tasks.Task IdrResponseAsync(string accountNumber, int utilityId, bool rejection, string message) {
            return base.Channel.IdrResponseAsync(accountNumber, utilityId, rejection, message);
        }
    }
}
