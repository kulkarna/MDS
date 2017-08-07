using System;
using System.Xml.Serialization;
//using LibertyPower.RepositoryManagement.Core.AccountManagement;

namespace LibertyPower.RepositoryManagement.Dto
{
    public class ServiceAccountProperty
    {
        public string UpdateSource { get; set; }
        public string UpdateUser { get; set; }
        public string Value { get; set; }
        public DateTime EffectiveDate { get; set; }

        [XmlIgnore]
        public ServiceAccountLockStatus LockStatus { get; set; }
        [XmlElement("LockStatus")]
        public string LockStatusAsString
        {
            get { return LockStatus.ToString(); }
            set { LockStatus = string.IsNullOrEmpty(value) ? default(ServiceAccountLockStatus) : (ServiceAccountLockStatus)Enum.Parse(typeof(ServiceAccountLockStatus), value); }
        }

        [XmlIgnore]
        public TrackedField Name { get; set; }
        [XmlElement("Name")]
        public string NameAsString
        {
            get { return Name.ToString(); }
            set { Name = string.IsNullOrEmpty(value) ? default(TrackedField) : (TrackedField)Enum.Parse(typeof(TrackedField), value); }
        }
    }
}