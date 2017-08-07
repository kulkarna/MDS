using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class DoNotKnock
    {
        public int DoNotKnockID { get; set; }
        public int AccountID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string StreetAddress { get; set; }
        public string AptOrUnitNumber { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
        public string PhoneNumber { get; set; }
        public string NameofAptComplex { get; set; }
        public string Company { get; set; }
        public string RegulatoryComplaint { get; set; }
        public string ActiveOrInactive { get; set; }
        public string Comments { get; set; }
        public int EditedBy { get; set; }
        public DateTime? EditedDate { get; set; }

    }
}
