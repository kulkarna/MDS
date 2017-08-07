namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;

    [Guid("D1B634B3-4648-4048-AB5E-90F12B6ABDB5")]
    public class NumericValueRule : BusinessRule
    {
        private object _item;
        private string _fieldName;
        private int _excelRow;

        public NumericValueRule(object item, string fieldName, int excelRow)
            : base("NumericValueRule", BrokenRuleSeverity.Error)
        {
            _item = item;
            _fieldName = fieldName;
            _excelRow = excelRow;
        }

        public override bool Validate()
        {
            if (_item != null)
            {
                decimal item = decimal.MinValue;
                if (decimal.TryParse(_item.ToString(), out item) == false)
                {
                    var message = string.Format("'{0}' in Excel Row ({1}) must be a numeric value. ", _fieldName, _excelRow);
                    SetException(message);
                }
            }
            return Exception == null;
        }

 
    }
}
