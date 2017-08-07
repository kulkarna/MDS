using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class IdrRuleModel
    {
        public Guid UtilityId { get; set; }
        public Guid PreEnrollmentRequestModeIdrId { get; set; }
        public Guid PostEnrollmentRequestModeIdrId { get; set; }
        public string UtilityCode { get; set; }
        public List<IdrRulePerEnrollmentTypeModel> PreEnrollmentIdrRules { get; set; }
        public List<IdrRulePerEnrollmentTypeModel> PostEnrollmentIdrRules { get; set; }
        public bool PreEnrollmentRequestModeIdrAlwaysRequest { get; set; }
        public bool PostEnrollmentRequestModeIdrAlwaysRequest { get; set; }
        public string SelectedUtilityCompanyId { get; set; }
    }
}