namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Runtime.InteropServices;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.CommonHelper;

    [Guid("5BFC77A2-B87B-4d2d-AE7A-647A257FF596")]
    public class UtilityMappingValidMappingSchemaRule : BusinessRule
    {
        public UtilityMappingValidMappingSchemaRule()
            : base("Utility Mapping Schema Valid Rule", BrokenRuleSeverity.Error)
        {
        }
        public override bool Validate()
        {
            this.SetException( " Rule not yet implemented ...");
            return false;
        }
    }
}
