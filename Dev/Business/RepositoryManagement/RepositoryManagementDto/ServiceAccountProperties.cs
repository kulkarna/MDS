using System.Collections.Generic;

namespace LibertyPower.RepositoryManagement.Dto
{
    public class ServiceAccountProperties
    {
        public ServiceAccountProperties()
        {
            Properties = new List<ServiceAccountProperty>();
        }

        public string Utility { get; set; }
        public string AccountNumber { get; set; }
        public List<ServiceAccountProperty> Properties { get; set; }
    }
}