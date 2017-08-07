using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class GenericError
    {
        public int Code { get; set; }

        public string Message { get; set; }

        public override string ToString()
        {
            return string.Format( "{0} => {1}", this.Code, this.Message );
        }
    }
}
