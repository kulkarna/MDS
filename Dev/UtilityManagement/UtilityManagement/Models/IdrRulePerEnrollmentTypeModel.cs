using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class IdrRulePerEnrollmentTypeModel
    {
        public Guid IdrRuleId { get; set; }
        public Guid? RequestModeIdrId { get; set; }
        public string RequestModeEnrollmentTypeName { get; set; }
        public string RequestModeTypeName { get; set; }
        public string RateClass { get; set; }
        public Guid RateClassId { get; set; }
        public string LoadProfile { get; set; }
        public Guid LoadProfileId { get; set; }
        public string TariffCode { get; set; }
        public Guid TariffCodeId { get; set; }
        public int? MinUsageMWh { get; set; }
        public int? MaxUsageMWh { get; set; }
        public bool IsEligible { get; set; }
        public bool IsHia { get; set; }
        public string ErrorMessage { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public System.Web.Mvc.SelectList RateClassSelectList { get; set; }
        public System.Web.Mvc.SelectList LoadProfileSelectList { get; set; }
        public System.Web.Mvc.SelectList TariffCodeSelectList { get; set; }
    }
}