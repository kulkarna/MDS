using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    public enum EmailType
    {
        Price = 1,
        EnrollmentAcceptanceNotification = 2,
        ECM = 3,
        Error = 4,
        ProcessingNotification = 5,
        EnrollmentRejectionNotification = 6,
        TabletContractAcceptance = 7,
        TabletContractException = 8,
        GasContract = 9,
        Troubleshooting = 10
    }
}
