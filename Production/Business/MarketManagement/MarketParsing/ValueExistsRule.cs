namespace LibertyPower.Business.MarketManagement.MarketParsing
{

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Data;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonRules;

    [Guid("E0D3F38B-9ED2-471F-ACE2-5830881E87C1")]
    public class ValueExistsRule : BusinessRule
    {

        private object _item;
        private string _fieldName;
        private int _excelRow;

        public ValueExistsRule(object item, string fieldName, int excelRow)
            : base("ValueExistsRule", BrokenRuleSeverity.Error)
        {
            _item = item;
            _fieldName = fieldName;
            _excelRow = excelRow;
        }

        public override bool Validate()
        {


            if (_item == null || _item.ToString().Trim().Length == 0)
            {
                var message = string.Format("'{0}' in Excel Row ({1}) must not be empty. ", _fieldName, _excelRow);
                SetException(message);
            }

            return Exception == null;
        }
    }
}
