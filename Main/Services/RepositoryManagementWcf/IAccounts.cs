using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using LibertyPower.RepositoryManagement.Contracts;
using LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1;
using LibertyPower.RepositoryManagement.Contracts.Common.v1;
using LibertyPower.RepositoryManagement.Dto;

namespace LibertyPower.RepositoryManagement.v1
{
    [ServiceContract(Namespace = ContractNamespaces.AccountManagementV1)]
    public interface IAccounts
    {
        [FaultContractAttribute(typeof(DataStoreError))]
        [OperationContract(Name = "SubmitServiceAccountUpdate")]
        [FaultContractAttribute(typeof(BusinessProcessError))]
        [FaultContractAttribute(typeof(SystemError))]
        void Submit(ServiceAccountInfo value);


        [OperationContract(Name = "UpdateCrmIfAccountMeetsPropertiesRequirements", IsOneWay = true)]
        void UpdateCrmIfAccountMeetsPropertiesRequirements(int? utilityId, string account);

        [OperationContract]
        Dictionary<TrackedField, string> GetServiceAccountProperties(string messageId, string utilityCode, string accountNumber);

        [OperationContract]
        void UpdateServiceAccountProperties(string messageId, string utilityCode, string accountNumber, string updateSource, string updateUser, Dictionary<TrackedField, string> accountPropertiesNameValueList);
    }
}