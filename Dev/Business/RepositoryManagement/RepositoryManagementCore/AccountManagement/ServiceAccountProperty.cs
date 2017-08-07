using System;
using LibertyPower.RepositoryManagement.Dto;

namespace LibertyPower.RepositoryManagement.Core.AccountManagement
{
    public class ServiceAccountProperty
    {
        public string UpdateSource { get; set; }
        public string UpdateUser { get; set; }
        public string Value { get; set; }
        public DateTime EffectiveDate { get; set; }
        public ServiceAccountLockStatus LockStatus { get; set; }
        public TrackedField Name { get; set; }

        public override string ToString()
        {
            string returnValue = string.Format("ServiceAccountProperty[UpdateSource:{0},UpdateUser:{1},Value:{2},EffectiveDate:{3},LockStatus:{4},Name:{5}]", UpdateSource, UpdateUser, Value, EffectiveDate, LockStatus, Name);
            return returnValue;
        }
    }
}