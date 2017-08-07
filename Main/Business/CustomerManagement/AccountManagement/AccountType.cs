using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class AccountType
    {
        public int Id { get; set; }
        public string Description { get; set; }
		public string DisplayDescription { get; set; }

        public override string ToString()
        {
            return this.Description;
        }
    }
}
