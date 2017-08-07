using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace UsageWebService.Validation.Custom
{
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class RequiredWhenUtilityIs : DataTypeAttribute
    {
        private string _utilityCode;

        public RequiredWhenUtilityIs(string utilityCode)
            : base(DataType.Text)
        {
            _utilityCode = utilityCode;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            
            var utilityCodeProperty = validationContext.ObjectType.GetProperty("UtilityCode");

            if (utilityCodeProperty == null)
                throw new KeyNotFoundException("The utility code property could not be found.");

            var utilityCode = Convert.ToString(utilityCodeProperty.GetValue(validationContext.ObjectInstance, null));

            var isUtility = string.Equals(_utilityCode, utilityCode.Trim(), StringComparison.InvariantCultureIgnoreCase);

            if (isUtility && (value == null || string.IsNullOrWhiteSpace(value.ToString())))
                return new ValidationResult(string.Format("{0} is required when utility code is {1}", validationContext.DisplayName, _utilityCode));

            return null;
        }
    }
}