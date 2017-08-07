using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace UsageWebService.Validation
{
    public class NullObjectValidator : IObjectValidator
    {
        public IEnumerable<ValidationResult> Validate(object input)
        {
            if (input == null)
            {
                yield return new ValidationResult("Input is null.");
            }
        }
    }
}