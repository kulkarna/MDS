using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class Zipcode
    {
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public string Zip { get; set; }
        [DataMember]
        public Nullable<double> Latitude { get; set; }
        [DataMember]
        public Nullable<double> Longitude { get; set; }
        [DataMember]
        public string State { get; set; }
        [DataMember]
        public string City { get; set; }
        [DataMember]
        public Nullable<int> MarketID { get; set; }
        [DataMember]
        public Nullable<int> UtilityID { get; set; }
        [DataMember]
        public Nullable<int> ZoneID { get; set; }
        [DataMember]
        public string County { get; set; }
        [DataMember]
        public string RetailMktDescp { get; set; }
        [DataMember]
        public string UtilityFullName { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public string ZoneCode { get; set; }
        [DataMember]
        public int? CreatedBy { get; set; }
        [DataMember]
        public DateTime? CreatedDate { get; set; }
        [DataMember]
        public int? ModifiedBy { get; set; }
        [DataMember]
        public DateTime? ModifiedDate { get; set; }
    }
}
