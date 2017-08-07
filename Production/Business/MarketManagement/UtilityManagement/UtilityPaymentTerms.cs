namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
using System;
using System.Runtime.Serialization;
using System.Collections.Generic;
using System.Text;
using LibertyPower.Business.CommonBusiness.CommonEntity;

    [Serializable]
    [DataContract]
    public class UtilityPaymentTerms
    {
        public int rowID { get; set; }
        public int utilityID { get; set; }
        public int marketID { get; set; }
        public int AccountTypeID { get; set; }
        public int BillTypeID { get; set; }
        public int ArTerm{ get; set; }

        public UtilityPaymentTerms()
        {
            rowID = -1;
            utilityID = -1;
            marketID = -1;
            AccountTypeID = -1;
            BillTypeID = -1;
            ArTerm = -1;
        }
    }            
}
