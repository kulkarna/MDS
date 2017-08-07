using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class IdrRuleEditListModel
    {
        public List<IdrRuleEditRowModel> IdrRuleEditRowList { get; set; }
        public bool PreEnrollmentRequestModeIdrAlwaysRequest { get; set; }
        public bool PostEnrollmentRequestModeIdrAlwaysRequest { get; set; }

    }
}