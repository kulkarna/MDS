using System.Collections.Generic;
using UtilityLogging;

namespace LibertyPower.RepositoryManagement.Core.AccountValidation
{
    public class AccountRequirements
    {
        public int UtilityId { get; set; }
        public string UtilityCode { get; set; }
        public List<string> MustHaveProperties { get; set; }
        private ILogger _logger = new Logger();

        public override string ToString()
        {
            System.Text.StringBuilder stringValue = new System.Text.StringBuilder("AccountRequirements[");
            stringValue.Append(string.Format("UtilityId:{0},UtilityCode:{1},MustHaveProperties[", UtilityId, Utilities.Common.NullSafeString(UtilityCode)));
            if (MustHaveProperties == null)
                stringValue.Append("MustHaveProperties == NULL");
            else if (MustHaveProperties.Count == 0)
                stringValue.Append("MustHaveProperties.Count == 0");
            else
            {
                foreach (string property in MustHaveProperties)
                {
                    stringValue.Append(string.Format("property:{0} ", Utilities.Common.NullSafeString(property)));
                }
            }
            stringValue.Append("]]");
            return stringValue.ToString();
        }
    }
}