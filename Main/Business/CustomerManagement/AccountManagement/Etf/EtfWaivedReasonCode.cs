using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class EtfWaivedReasonCode
    {

        public EtfWaivedReasonCode(int reasonID, string reasonCode)
        {
            this.reasonID = reasonID;
            this.reasonCode = reasonCode;

        }

        private int reasonID;
        public int ReasonID
        {
            get
            {
                return this.reasonID;
            }
        }

        private string reasonCode;
        public string ReasonCode
        {
            get
            { return this.reasonCode; }
        }

    }
}
