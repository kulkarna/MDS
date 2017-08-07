namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;

    [Guid("E1E60C14-0122-4AFA-8A98-C8B513C5FA94")]
    public class MinimumDateRule : BusinessRule
    {

        private object _item;
        private string _fieldName;
        private int _excelRow;


        public MinimumDateRule(object item, string fieldName, int excelRow)
            :base("MinimumDateRule", BrokenRuleSeverity.Error)
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
                if (DateTime.TryParse(_item.ToString(), out item) == true)
                {
                    if (item < DateTime.Now + TimeSpan.FromDays(1))
                    {
                        var message = string.Format("'{0}' in Excel Row ({1}) must be a future date. ", _fieldName, _excelRow);
                        SetException(message);
                    }
                }
            }
            return Exception == null;
        }
    }
}
