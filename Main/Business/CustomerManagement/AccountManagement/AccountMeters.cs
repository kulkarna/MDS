using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class AccountMeters
    {
        public AccountMeters(string Account_ID, string Meter_Number)
        {
            this.Account_ID = Account_ID;
            this.Meter_Number = Meter_Number;
        }
        public string Account_ID { get; set; }
        public string Meter_Number { get; set; }

    }
}
