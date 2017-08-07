using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public enum EtfInvoiceStatus
    {
        Pending = 1,
        Invoiced = 2,
		Cancelled = 3,
        Waived = 4,
        Paid = 5
    }
}
