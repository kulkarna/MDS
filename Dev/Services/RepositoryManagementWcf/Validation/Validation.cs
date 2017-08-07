using System;
using System.Linq;
using System.Text;
using FluentValidation.Results;

namespace LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1
{
    public static class Validation
    {
        public static bool NotBeNullEmptyOfWhiteSpace(string value)
        {
            if (string.IsNullOrEmpty(value))
                return false;

            if (string.IsNullOrWhiteSpace(value))
                return false;

            return true;
        }

        public static bool NotBeOutsideOfCurrentMillenium(DateTime value)
        {
            if (value < DateTime.Parse("12/31/1899"))
                return false;

            if (value > DateTime.Parse("01/01/3000"))
                return false;

            return true;
        }

        public static void ThrowValidationException(ValidationResult result)
        {
            if (result.IsValid)
                return;

            var es = new StringBuilder();
            result.Errors.ToList().ForEach(e => es.Append(e.ErrorMessage).Append(". "));
            throw new Core.ValidationException(es.ToString());
        }


    }
}