using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using System.ServiceModel;

namespace UtilityManagementServiceData
{
    [DataContract]
    public class GetAllUtilitiesDataResponseItem
    {
        [DataMember]
        public Guid UtilityId { get; set; }
        [DataMember]
        public int LegacyUtilityId { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public string FullName { get; set; }
        //[DataMember]
        //public Guid IsoId { get; set; }
        //[DataMember]
        //public string IsoName { get; set; }
        [DataMember]
        public Guid MarketId { get; set; }
        [DataMember]
        public int? MarketIdInt { get; set; }
        [DataMember]
        public string MarketName { get; set; }
        //[DataMember]
        //public string PrimaryDunsNumber { get; set; }
        //[DataMember]
        //public string LpEntityId { get; set; }
        //[DataMember]
        //public string SalesForceId { get; set; }
        //[DataMember]
        //public string ParentCompany { get; set; }
        //[DataMember]
        //public string UtilityStatus { get; set; }
        //[DataMember]
        //public int? EnrollmentLeadDays { get; set; }
        //[DataMember]
        //public int? AccountLength { get; set; }
        //[DataMember]
        //public string AccountNumberPrefix { get; set; }
        //[DataMember]
        //public bool PorOption { get; set; }
        //[DataMember]
        //public bool MeterNumberRequired { get; set; }
        //[DataMember]
        //public short? MeterNumberLength { get; set; }
        //[DataMember]
        //public bool EdiCapable { get; set; }
        //[DataMember]
        //public string UtilityPhoneNumber { get; set; }
        //[DataMember]
        //public string BillingTypeName { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        public override string ToString()
        {
            //return string.Format("UtilityId:{0};LegacyUtilityId:{1};UtilityCode:{2};UtilityIdInt:{3},FullName:{3},IsoName:{4},MarketName:{5},PrimaryDunsNumber:{6},LpEntityId:{7},SalesForceId:{8},ParentCompany:{9},UtilityStatus:{10},EnrollmentLeadDays:{11},AccountLength:{12},AccountNumberPrefix:{13},PorOption:{14},MeterNumberRequired:{15},MeterNumberLength:{16},EdiCapable:{17},UtilityPhoneNumber:{18},BillingTypeName:{19}", 
            //    UtilityId, LegacyUtilityId, Utilities.Common.NullSafeString(UtilityCode), UtilityIdInt,
            //    Utilities.Common.NullSafeString(FullName), Utilities.Common.NullSafeString(IsoName), Utilities.Common.NullSafeString(MarketName), Utilities.Common.NullSafeString(PrimaryDunsNumber),
            //    Utilities.Common.NullSafeString(LpEntityId),Utilities.Common.NullSafeString(SalesForceId),Utilities.Common.NullSafeString(ParentCompany),Utilities.Common.NullSafeString(UtilityStatus),
            //    Utilities.Common.NullSafeString(EnrollmentLeadDays),Utilities.Common.NullSafeString(AccountLength),Utilities.Common.NullSafeString(AccountNumberPrefix),
            //    Utilities.Common.NullSafeString(PorOption),Utilities.Common.NullSafeString(MeterNumberRequired),Utilities.Common.NullSafeString(MeterNumberLength),
            //    Utilities.Common.NullSafeString(EdiCapable),Utilities.Common.NullSafeString(UtilityPhoneNumber),Utilities.Common.NullSafeString(BillingTypeName));
            return string.Format("UtilityId:{0};LegacyUtilityId:{1};UtilityCode:{2};UtilityIdInt:{3},FullName:{4},MarketName:{5},MarketId:{6},MarketIdInt:{7}",
                UtilityId,LegacyUtilityId,Utilities.Common.NullSafeString(UtilityCode),UtilityIdInt,
                Utilities.Common.NullSafeString(FullName),Utilities.Common.NullSafeString(MarketName), 
                Utilities.Common.NullSafeString(MarketId), Utilities.Common.NullSafeString(MarketIdInt));
        }
    }

    [DataContract]
    public class GetAllUtilitiesAcceleratedSwitchResponseItem
    {
        [DataMember]
        public Guid UtilityId { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        [DataMember]
        public int AcceleratedSwitch { get; set; }
        public override string ToString()
        {

            return string.Format("UtilityId:{0};UtilityCode:{2};UtilityIdInt:{3};AcceleratedSwitchInt:{3}",
                UtilityId, Utilities.Common.NullSafeString(UtilityCode), UtilityIdInt, AcceleratedSwitch);
        }
    }

    [DataContract]
    public class GetEnrollmentLeadTimesResponseItem
    {
        [DataMember]
        public int UtilityId { get; set; }
        //[DataMember]
        //public string UtilityCode { get; set; }
        [DataMember]
        public int EnrollmentleadTime { get; set; }
        [DataMember]
        public string AccountType { get; set; }
        [DataMember]
       public  bool IsBusinessDay { get; set; }
        //[DataMember]
        //public bool IsEnrollmentLeadTimeDefault { get; set; }
        //public override string ToString()
        //{

        //    return string.Format("UtilityId:{0};UtilityCode:{1};EnrollmentleadTime:{2};AccountType{3},IsBusinessDay{4},IsEnrollmentLeadTImeDefault{5]",
        //        UtilityId, Utilities.Common.NullSafeString(UtilityCode), Utilities.Common.NullSafeString(EnrollmentleadTime), AccountType
        //        , Utilities.Common.NullSafeString(IsBusinessDay),
        //         Utilities.Common.NullSafeString(IsEnrollmentLeadTimeDefault));
                
        //}

        public override string ToString()
        {

            return string.Format("UtilityId:{0};EnrollmentleadTime:{1};AccountType{2},IsBusinessDay{3}",
                UtilityId, Utilities.Common.NullSafeString(EnrollmentleadTime), AccountType
                , Utilities.Common.NullSafeString(IsBusinessDay));

        }
    }

}