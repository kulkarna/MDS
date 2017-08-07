using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public partial class Customer
    {
        public string FullName
        {
            get { return this.CustomerName.FullName; }
        }

    }
}
