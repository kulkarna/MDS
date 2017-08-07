using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    partial class AccountStatus
    {
        public bool IsActive
        {
            get
            {
                string status = this.Status.Trim();
                if (status != "911000"
                    && status != "999999"
                    && status != "999998")
                    return true;

                else
                    return false;               
            }
        }
    }
}
