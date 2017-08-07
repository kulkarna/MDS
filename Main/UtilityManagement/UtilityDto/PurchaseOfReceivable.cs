using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityDto
{
    public class PurchaseOfReceivable
    {
        public Guid Id {get;set;}
        public Guid UtilityCompanyId {get;set;}
        public Guid PorDriverId {get;set;}
        public Guid? RateClassId {get;set;}
        public Guid? LoadProfileId {get;set;}
        public Guid? TariffCodeId {get;set;}
        public bool IsPorOffered {get;set;}
        public bool IsPorParticipated {get;set;}
        public Guid PorRecourseId {get;set;}
        public bool IsPorAssurance {get;set;}
        public decimal PorDiscountRate {get;set;}
        public decimal PorFlatFee {get;set;}
        public DateTime PorDiscountEffectiveDate {get;set;}
        public DateTime? PorDiscountExpirationDate {get;set;}
        public bool Inactive {get;set;}
        public string CreatedBy {get;set;}
        public DateTime CreatedDate {get;set;}
        public string LastModifiedBy {get;set;}
        public DateTime LastModifiedDate {get;set;}
    }
}