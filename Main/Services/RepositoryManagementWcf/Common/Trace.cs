using System;
using System.Runtime.Serialization;

namespace LibertyPower.RepositoryManagement.Contracts.Common.v1
{
    [DataContract(Namespace = ContractNamespaces.CommonV1)]
    public class Trace
    {
        [DataMember]
        public Guid Id { get; set; }
        [DataMember]
        public string Build { get; set; }
    }
}