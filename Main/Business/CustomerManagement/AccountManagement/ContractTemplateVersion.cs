using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public class ContractTemplateVersion
    {
        private string code;
        private int etfFormulaId;

        public string Code 
        { 
            get { return code; }
            set { this.code = value; }
        }

        public int ETFFormulaId
        { 
            get { return etfFormulaId; }
            set { this.etfFormulaId = value; }
        }
    }
}
