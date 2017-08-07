using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class AccountNotFoundException : ApplicationException
    {
        public AccountNotFoundException(string message) : base(message) { }
    }
}
