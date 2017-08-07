using System;
using System.Runtime.Serialization;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    [Serializable]
    [DataContract]
    public class TaxTemplate
    {
        public int TaxTemplateId { get; set; }
        public int TaxTypeId { get; set; }
        public string TypeOfTax { get; set; }
        public string Template { get; set; }
        public double PercentTaxable { get; set; }
        public int UtilityId;

        public TaxTemplate()
        {
            TaxTemplateId = -1;
            TaxTypeId = -1;
            TypeOfTax = "";
            Template = "";
            PercentTaxable = 0.0;
            UtilityId = -1;
        }
    }   
}
