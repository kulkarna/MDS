﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18444
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------



[System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
[System.ServiceModel.ServiceContractAttribute(ConfigurationName = "IAuthorizationService")]
public interface IAuthorizationService
{

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAuthorizationService/GetData", ReplyAction = "http://tempuri.org/IAuthorizationService/GetDataResponse")]
    string GetData(int value);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAuthorizationService/GetData", ReplyAction = "http://tempuri.org/IAuthorizationService/GetDataResponse")]
    System.Threading.Tasks.Task<string> GetDataAsync(int value);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAuthorizationService/AuthorizeUserActivity", ReplyAction = "http://tempuri.org/IAuthorizationService/AuthorizeUserActivityResponse")]
    bool AuthorizeUserActivity(string MessageId, string Username, string ActivityName);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAuthorizationService/AuthorizeUserActivity", ReplyAction = "http://tempuri.org/IAuthorizationService/AuthorizeUserActivityResponse")]
    System.Threading.Tasks.Task<bool> AuthorizeUserActivityAsync(string MessageId, string Username, string ActivityName);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAuthorizationService/GetUserActivities", ReplyAction = "http://tempuri.org/IAuthorizationService/GetUserActivitiesResponse")]
    System.Collections.Generic.Dictionary<string, bool> GetUserActivities(string messageId, string userName);

    [System.ServiceModel.OperationContractAttribute(Action = "http://tempuri.org/IAuthorizationService/GetUserActivities", ReplyAction = "http://tempuri.org/IAuthorizationService/GetUserActivitiesResponse")]
    System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<string, bool>> GetUserActivitiesAsync(string messageId, string userName);
}

[System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
public interface IAuthorizationServiceChannel : IAuthorizationService, System.ServiceModel.IClientChannel
{
}

[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
public partial class AuthorizationServiceClient : System.ServiceModel.ClientBase<IAuthorizationService>, IAuthorizationService
{

    public AuthorizationServiceClient()
    {
    }

    public AuthorizationServiceClient(string endpointConfigurationName) :
        base(endpointConfigurationName)
    {
    }

    public AuthorizationServiceClient(string endpointConfigurationName, string remoteAddress) :
        base(endpointConfigurationName, remoteAddress)
    {
    }

    public AuthorizationServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) :
        base(endpointConfigurationName, remoteAddress)
    {
    }

    public AuthorizationServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) :
        base(binding, remoteAddress)
    {
    }

    public string GetData(int value)
    {
        return base.Channel.GetData(value);
    }

    public System.Threading.Tasks.Task<string> GetDataAsync(int value)
    {
        return base.Channel.GetDataAsync(value);
    }

    public bool AuthorizeUserActivity(string MessageId, string Username, string ActivityName)
    {
        return base.Channel.AuthorizeUserActivity(MessageId, Username, ActivityName);
    }

    public System.Threading.Tasks.Task<bool> AuthorizeUserActivityAsync(string MessageId, string Username, string ActivityName)
    {
        return base.Channel.AuthorizeUserActivityAsync(MessageId, Username, ActivityName);
    }

    public System.Collections.Generic.Dictionary<string, bool> GetUserActivities(string messageId, string userName)
    {
        return base.Channel.GetUserActivities(messageId, userName);
    }

    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<string, bool>> GetUserActivitiesAsync(string messageId, string userName)
    {
        return base.Channel.GetUserActivitiesAsync(messageId, userName);
    }
}