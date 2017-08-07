using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using System.ServiceModel;
using Utilities;

namespace UtilityManagementServiceData
{
    [DataContract]
    public class GetAllActiveUtilitiesDumpDataResponseItem
    {
        [DataMember]
        public Guid UtilityId { get; set; }
        [DataMember]
        public string UtilityCode { get; set; }
        [DataMember]
        public Guid IsoId { get; set; }
        [DataMember]
        public string IsoName { get; set; }
        [DataMember]
        public Guid MarketId { get; set; }
        [DataMember]
        public int? MarketIdInt { get; set; }
        [DataMember]
        public string MarketName { get; set; }
        [DataMember]
        public string PrimaryDunsNumber { get; set; }
        [DataMember]
        public string LpEntityId { get; set; }
        [DataMember]
        public string ServiceAccountPattern { get; set; }
        [DataMember]
        public string ServiceAccountPatternDesc { get; set; }
        [DataMember]
        public string BillingAccountPattern { get; set; }
        [DataMember]
        public string BillingAccountPatternDesc { get; set; }
        [DataMember]
        public string NameKeyPattern { get; set; }
        [DataMember]
        public string NameKeyPatternDesc { get; set; }
        [DataMember]
        public string HURequestModeType { get; set; }
        [DataMember]
        public string HURequestModeAddress { get; set; }
        [DataMember]
        public string HURequestModeEmailTemplate { get; set; }
        [DataMember]
        public string HURequestModeInstructions { get; set; }
        [DataMember]
        public bool HURequestModeIsLoaRequired { get; set; }
        [DataMember]
        public string HURequestModeEnrollmentType { get; set; }
        [DataMember]
        public string HIRequestModeType { get; set; }
        [DataMember]
        public string HIRequestModeAddress { get; set; }
        [DataMember]
        public string HIRequestModeEmailTemplate { get; set; }
        [DataMember]
        public string HIRequestModeInstructions { get; set; }
        [DataMember]
        public string HIRequestModeEnrollmentType { get; set; }
        [DataMember]
        public bool HIRequestModeIsLoaRequired { get; set; }
        [DataMember]
        public string ICapRequestModeType { get; set; }
        [DataMember]
        public string ICapRequestModeAddress { get; set; }
        [DataMember]
        public string ICapRequestModeEmailTemplate { get; set; }
        [DataMember]
        public string ICapRequestModeInstructions { get; set; }
        [DataMember]
        public string ICapRequestModeEnrollmentType { get; set; }
        [DataMember]
        public bool ICapRequestModeIsLoaRequired { get; set; }
        [DataMember]
        public int UtilityIdInt { get; set; }
        public override string ToString()
        {


            return string.Format("UtilityId,UtilityCode,IsoId , IsoName ,MarketId,MarketIdInt,MarketName,PrimaryDunsNumber,LpEntityId,ServiceAccountPattern,ServiceAccountPatternDesc,BillingAccountPattern ,BillingAccountPatternDesc,,NameKeyPattern , NameKeyPatternDesc,HURequestModeType,HURequestModeAddress,HURequestModeEmailTemplate,HURequestModeInstructions, HURequestModeIsLoaRequired,HIRequestModeType, HIRequestModeAddress ,HIRequestModeEmailTemplate,HIRequestModeInstructions,HIRequestModeIsLoaRequired,ICapRequestModeType ,ICapRequestModeAddress,ICapRequestModeEmailTemplate,ICapRequestModeInstructions,ICapRequestModeIsLoaRequired,UtilityIdInt",
              Common.NullSafeString(UtilityId), Utilities.Common.NullSafeString(UtilityCode), IsoId, IsoName, Utilities.Common.NullSafeString(MarketIdInt), Utilities.Common.NullSafeString(MarketName), PrimaryDunsNumber, LpEntityId, ServiceAccountPattern, ServiceAccountPatternDesc, BillingAccountPattern, BillingAccountPatternDesc
              ,Common.NullSafeString(NameKeyPattern), Common.NullSafeString(NameKeyPatternDesc), Common.NullSafeString(HURequestModeType), HURequestModeAddress
              ,HURequestModeEmailTemplate, HURequestModeInstructions
              ,Common.NullSafeString(HURequestModeIsLoaRequired)
              ,Common.NullSafeString(HIRequestModeType), Common.NullSafeString(HIRequestModeAddress), Common.NullSafeString(HIRequestModeEmailTemplate)
              , Common.NullSafeString(HIRequestModeInstructions), Common.NullSafeString(HIRequestModeIsLoaRequired), Common.NullSafeString(ICapRequestModeType)
              , Common.NullSafeString(ICapRequestModeAddress)
              , Common.NullSafeString(ICapRequestModeEmailTemplate)
              , Common.NullSafeString(ICapRequestModeInstructions), Common.NullSafeString(ICapRequestModeIsLoaRequired), Common.NullSafeString(UtilityIdInt));
        }
    }
}