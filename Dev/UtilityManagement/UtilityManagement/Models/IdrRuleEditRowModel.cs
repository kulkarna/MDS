using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class IdrRuleEditRowModel
    {
        public Guid IdrRuleId { get; set; }
        public Guid UtilityCompanyId { get; set; }
        public Guid? RequestModeIdrId { get; set; }
        public Guid? RateClassId { get; set; }
        public Guid? LoadProfileId { get; set; }
        public Guid? TariffCodeId { get; set; }
        public int? MinUsageMWh { get; set; }
        public int? MaxUsageMWh { get; set; }
        public bool IsEligible { get; set; }
        public bool IsHia { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public string ErrorMessage { get; set; }

        public int RateClassIdInt { get; set; }
        public string UtilityCode { get; set; }
        public string EnrollmentType { get; set; }
        public string RequestModeType { get; set; }
        public System.Web.Mvc.SelectList RateClassSelectList { get; set; }
        public System.Web.Mvc.SelectList LoadProfileSelectList { get; set; }
        public System.Web.Mvc.SelectList TariffCodeSelectList { get; set; }


    }
}