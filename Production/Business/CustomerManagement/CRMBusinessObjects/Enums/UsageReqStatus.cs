using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects.Enums
{
    [Serializable]
    public enum UsageReqStatus
    {
        None = 1,		    // None
        WebService = 2,		// web-service
        Submitted = 3,		// Submitted
        InvalidAcct = 4,	// Invalid Acct
        Complete = 5,       // Complete
        Pending = 6         // Pending
    }
}
