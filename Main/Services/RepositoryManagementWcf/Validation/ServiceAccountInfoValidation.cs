using FluentValidation;
//using LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1;

namespace LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1
{
    public class ServiceAccountInfoValidator : AbstractValidator<ServiceAccountInfo>
    {
        public ServiceAccountInfoValidator()
        {
            var msg = "{PropertyName} value of service account cannot be null, empty or white space";
            RuleFor(r => r.AccountNumber).Must(Validation.NotBeNullEmptyOfWhiteSpace).WithMessage(msg);
            RuleFor(r => r.Utility).Must(Validation.NotBeNullEmptyOfWhiteSpace).WithMessage(msg);
            RuleFor(r => r.UpdateSource).Must(Validation.NotBeNullEmptyOfWhiteSpace).WithMessage(msg);
            RuleFor(r => r.UpdateUser).Must(Validation.NotBeNullEmptyOfWhiteSpace).WithMessage(msg);
        }
    }
}