using System;
using System.Collections.Generic;
using System.Linq;

namespace UtilityManagement.Models
{
    public class IdrRuleCreateModel
    {
        public Guid UtilityCompanyId { get; set; }
        public Guid EnrollmentTypeId { get; set; }
        public Guid RateClassId { get; set; }
        public Guid LoadProfileId { get; set; }
        public Guid TariffCodeId { get; set; }
        public Guid RequestModeIdrId { get; set; }
        public int? MinimumUsageMWh { get; set; }
        public int? MaximumUsageMWh { get; set; }
        public bool IsEligible { get; set; }
        public bool IsHia { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public bool AlwaysRequest { get; set; }

    }
}