using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace UsageWebService.Validation
{
    public interface IObjectValidator
    {
        IEnumerable<ValidationResult> Validate(object input);
    }
}