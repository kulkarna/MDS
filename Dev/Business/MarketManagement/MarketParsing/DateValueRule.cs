namespace LibertyPower.Business.MarketManagement.MarketParsing
{

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;

    [Guid("DACFF185-6A29-4EC8-8DE3-8B4B87D02F59")]
    public class DateValueRule : BusinessRule
    {

        private object _item;
        private string _fieldName;
        private int _excelRow;


        public DateValueRule(object item, string fieldName, int excelRow)
            : base("DateValueRule", BrokenRuleSeverity.Error)
        {
            _item = item;
            _fieldName = fieldName;
            _excelRow = excelRow;
        }

        public override bool Validate()
        {
            if (_item != null)
            {
                DateTime item = DateTime.MinValue;
                if (DateTime.TryParse(_item.ToString(), out item) == false)
                {
                    var message = string.Format("'{0}' in Excel Row ({1}) must be a Date. ", _fieldName, _excelRow);
                    SetException(message);
                }
            }
            return Exception == null;
        }
    }
}
