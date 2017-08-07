using System;
using System.ComponentModel.DataAnnotations;

namespace UsageWebService.Validation.Custom
{
      [AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
    public class IsAny : DataTypeAttribute
      {
          private string[] _valuesToCheckAgainst;

          public IsAny(string commaDilimitedValuesToCheckAgainst) : base(DataType.Text)
          {
              if (string.IsNullOrWhiteSpace(commaDilimitedValuesToCheckAgainst))
                  _valuesToCheckAgainst = new string[0];
              else if (!commaDilimitedValuesToCheckAgainst.Contains(","))
                  _valuesToCheckAgainst = new[] {commaDilimitedValuesToCheckAgainst};
              else
                  _valuesToCheckAgainst = commaDilimitedValuesToCheckAgainst.Split(new[] {','},
                                                                           StringSplitOptions.RemoveEmptyEntries);
          }

          protected override ValidationResult IsValid(object value, ValidationContext validationContext)
          {
              if (value == null || string.IsNullOrWhiteSpace(value.ToString()))
                  return null;

              var cleanValue = value.ToString().Trim();

              foreach (var v in _valuesToCheckAgainst)
              {
                  if (v.Equals(cleanValue, StringComparison.InvariantCultureIgnoreCase))
                      return null;
              }
             
              return new ValidationResult(string.Format("{0} is not valid. Valid values are: {1}", validationContext.DisplayName, string.Join(",", _valuesToCheckAgainst)));

              
          }
    }
}