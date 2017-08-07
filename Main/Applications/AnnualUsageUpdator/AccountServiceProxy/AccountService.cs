﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34209
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace LibertyPower.MarketDataServices.AccountWcfServiceData
{
    using System.Runtime.Serialization;


    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name = "AccountServiceResponse", Namespace = "http://schemas.datacontract.org/2004/07/LibertyPower.MarketDataServices.AccountWc" +
        "fServiceData")]
    public partial class AccountServiceResponse : object, System.Runtime.Serialization.IExtensibleDataObject
    {

        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;

        private LibertyPower.MarketDataServices.AccountWcfServiceData.AnnualUsageTranRecord[] AccountResultListField;

        private string CodeField;

        private bool IsSuccessField;

        private string MessageField;

        private string MessageIdField;

        public System.Runtime.Serialization.ExtensionDataObject ExtensionData
        {
            get
            {
                return this.extensionDataField;
            }
            set
            {
                this.extensionDataField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public LibertyPower.MarketDataServices.AccountWcfServiceData.AnnualUsageTranRecord[] AccountResultList
        {
            get
            {
                return this.AccountResultListField;
            }
            set
            {
                this.AccountResultListField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Code
        {
            get
            {
                return this.CodeField;
            }
            set
            {
                this.CodeField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public bool IsSuccess
        {
            get
            {
                return this.IsSuccessField;
            }
            set
            {
                this.IsSuccessField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Message
        {
            get
            {
                return this.MessageField;
            }
            set
            {
                this.MessageField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public string MessageId
        {
            get
            {
                return this.MessageIdField;
            }
            set
            {
                this.MessageIdField = value;
            }
        }
    }

    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "4.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name = "AnnualUsageTranRecord", Namespace = "http://schemas.datacontract.org/2004/07/LibertyPower.MarketDataServices.AccountWc" +
        "fServiceData")]
    public partial class AnnualUsageTranRecord : object, System.Runtime.Serialization.IExtensibleDataObject
    {

        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;

        private int AccountIdField;

        private string AccountNumberField;

        private int AnnualUsageField;

        private int UtilityIdField;

        public System.Runtime.Serialization.ExtensionDataObject ExtensionData
        {
            get
            {
                return this.extensionDataField;
            }
            set
            {
                this.extensionDataField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public int AccountId
        {
            get
            {
                return this.AccountIdField;
            }
            set
            {
                this.AccountIdField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public string AccountNumber
        {
            get
            {
                return this.AccountNumberField;
            }
            set
            {
                this.AccountNumberField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public int AnnualUsage
        {
            get
            {
                return this.AnnualUsageField;
            }
            set
            {
                this.AnnualUsageField = value;
            }
        }

        [System.Runtime.Serialization.DataMemberAttribute()]
        public int UtilityId
        {
            get
            {
                return this.UtilityIdField;
            }
            set
            {
                this.UtilityIdField = value;
            }
        }
    }
}


[System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
[System.ServiceModel.ServiceContractAttribute(ConfigurationName = "IAccountWcfService")]
public interface IAccountWcfService
{

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/PopulateEnrolledAccounts", ReplyAction = "http://tempuri.org/IAccountWcfService/PopulateEnrolledAccountsResponse")]
    LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse PopulateEnrolledAccounts(string messageId);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/PopulateEnrolledAccounts", ReplyAction = "http://tempuri.org/IAccountWcfService/PopulateEnrolledAccountsResponse")]
    System.Threading.Tasks.Task<LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse> PopulateEnrolledAccountsAsync(string messageId);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/GetEnrolledAccountsToProcess", ReplyAction = "http://tempuri.org/IAccountWcfService/GetEnrolledAccountsToProcessResponse")]
    LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse GetEnrolledAccountsToProcess(string messageId, int numberOfAccounts);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/GetEnrolledAccountsToProcess", ReplyAction = "http://tempuri.org/IAccountWcfService/GetEnrolledAccountsToProcessResponse")]
    System.Threading.Tasks.Task<LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse> GetEnrolledAccountsToProcessAsync(string messageId, int numberOfAccounts);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/UpdateAnnualUsageBulk", ReplyAction = "http://tempuri.org/IAccountWcfService/UpdateAnnualUsageBulkResponse")]
    LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse UpdateAnnualUsageBulk(string messageId, LibertyPower.MarketDataServices.AccountWcfServiceData.AnnualUsageTranRecord[] anuualUsageList);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/UpdateAnnualUsageBulk", ReplyAction = "http://tempuri.org/IAccountWcfService/UpdateAnnualUsageBulkResponse")]
    System.Threading.Tasks.Task<LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse> UpdateAnnualUsageBulkAsync(string messageId, LibertyPower.MarketDataServices.AccountWcfServiceData.AnnualUsageTranRecord[] anuualUsageList);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/IsServiceRunning", ReplyAction = "http://tempuri.org/IAccountWcfService/IsServiceRunningResponse")]
    bool IsServiceRunning();

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/IsServiceRunning", ReplyAction = "http://tempuri.org/IAccountWcfService/IsServiceRunningResponse")]
    System.Threading.Tasks.Task<bool> IsServiceRunningAsync();

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/Version", ReplyAction = "http://tempuri.org/IAccountWcfService/VersionResponse")]
    string Version();

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAccountWcfService/Version", ReplyAction = "http://tempuri.org/IAccountWcfService/VersionResponse")]
    System.Threading.Tasks.Task<string> VersionAsync();
}

[System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
public interface IAccountWcfServiceChannel : IAccountWcfService, System.ServiceModel.IClientChannel
{
}

[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
public partial class AccountWcfServiceClient : System.ServiceModel.ClientBase<IAccountWcfService>, IAccountWcfService
{

    public AccountWcfServiceClient()
    {
    }

    public AccountWcfServiceClient(string endpointConfigurationName) :
        base(endpointConfigurationName)
    {
    }

    public AccountWcfServiceClient(string endpointConfigurationName, string remoteAddress) :
        base(endpointConfigurationName, remoteAddress)
    {
    }

    public AccountWcfServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) :
        base(endpointConfigurationName, remoteAddress)
    {
    }

    public AccountWcfServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) :
        base(binding, remoteAddress)
    {
    }

    public LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse PopulateEnrolledAccounts(string messageId)
    {
        return base.Channel.PopulateEnrolledAccounts(messageId);
    }

    public System.Threading.Tasks.Task<LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse> PopulateEnrolledAccountsAsync(string messageId)
    {
        return base.Channel.PopulateEnrolledAccountsAsync(messageId);
    }

    public LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse GetEnrolledAccountsToProcess(string messageId, int numberOfAccounts)
    {
        return base.Channel.GetEnrolledAccountsToProcess(messageId, numberOfAccounts);
    }

    public System.Threading.Tasks.Task<LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse> GetEnrolledAccountsToProcessAsync(string messageId, int numberOfAccounts)
    {
        return base.Channel.GetEnrolledAccountsToProcessAsync(messageId, numberOfAccounts);
    }

    public LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse UpdateAnnualUsageBulk(string messageId, LibertyPower.MarketDataServices.AccountWcfServiceData.AnnualUsageTranRecord[] anuualUsageList)
    {
        return base.Channel.UpdateAnnualUsageBulk(messageId, anuualUsageList);
    }

    public System.Threading.Tasks.Task<LibertyPower.MarketDataServices.AccountWcfServiceData.AccountServiceResponse> UpdateAnnualUsageBulkAsync(string messageId, LibertyPower.MarketDataServices.AccountWcfServiceData.AnnualUsageTranRecord[] anuualUsageList)
    {
        return base.Channel.UpdateAnnualUsageBulkAsync(messageId, anuualUsageList);
    }

    public bool IsServiceRunning()
    {
        return base.Channel.IsServiceRunning();
    }

    public System.Threading.Tasks.Task<bool> IsServiceRunningAsync()
    {
        return base.Channel.IsServiceRunningAsync();
    }

    public string Version()
    {
        return base.Channel.Version();
    }

    public System.Threading.Tasks.Task<string> VersionAsync()
    {
        return base.Channel.VersionAsync();
    }
}