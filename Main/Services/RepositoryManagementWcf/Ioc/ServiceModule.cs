using LibertyPower.RepositoryManagement.Contracts.AccountManagement.v1;
//using LibertyPower.RepositoryManagement.Contracts.Pricing.v1;
using LibertyPower.RepositoryManagement.Core.AccountValidation;
using LibertyPower.RepositoryManagement.Data;
using LibertyPower.RepositoryManagement.Services;
using LibertyPower.RepositoryManagement.Web.Crm;
using LibertyPower.RepositoryManagement.Web.NullImplementations;
using LibertyPower.RepositoryManagement.Web.AccountValidation;
using Ninject.Modules;

namespace LibertyPower.RepositoryManagement.Web
{
    public class ServiceModule : NinjectModule
    {
        public override void Load()
        {
            //Bind<LibertyPower.RepositoryManagement.Pricing.v1.Pricing>().ToSelf();
            //Bind<IPricingController>().To<PricingController>();
            Bind<IAccountsController>().To<AccountsController>();
            //Bind<IPricingService>().To<PricingService>();
            Bind<ITracingService>().To<TracingService>();
            Bind<IAccountManagementService>().To<AccountManagementService>();

            //Bind<IAccountMustHavePropertiesProvider>().To<CachingUtilityAccountMustHavePropertiesProvider>(); //actual
            //Bind<IAccountRequirementsProvider>().To<AccountRequirementsDummyProvider>(); //temp fake
            Bind<IAccountRequirementsProvider>().To<CachingAccountRequirementsProvider>();

            //Bind<IAccountValidationDataRequestUpdater>().To<NullAccountValidationDataRequestUpdater>(); //temp fake
            //string crmUrl, string user, string password
            Bind<IAccountValidationDataRequestUpdater>().To<AccountValidationDataRequestUpdater>()
                .WithConstructorArgument("crmUrl", Configuration.CrmUrl)
                .WithConstructorArgument("user", Configuration.CrmUser)
                .WithConstructorArgument("password", Configuration.CrmPassword);

            if (Configuration.BindToNullRepositories)
                BindToNullRepositories();
            else
                BindRepositories();
        }

        private void BindToNullRepositories()
        {
            //Bind<IPricingRepository>().To<NullPricingRepository>().WithConstructorArgument("connectionString", Connections.RepositoryManagement);
            Bind<ITracingRepository>().To<NullTracingRepository>().WithConstructorArgument("connectionString", Connections.RepositoryManagement);
            Bind<IAccountManagementRepository>().To<NullAccountManagementRepository>().WithConstructorArgument("connectionString", Connections.LibertyPower);
        }

        private void BindRepositories()
        {
            //Bind<IPricingRepository>().To<PricingRepository>().WithConstructorArgument("connectionString", Connections.RepositoryManagement);
            Bind<ITracingRepository>().To<TracingRepository>().WithConstructorArgument("connectionString", Connections.RepositoryManagement);
            Bind<IAccountManagementRepository>().To<AccountManagementRepository>().WithConstructorArgument("connectionString", Connections.LibertyPower);
        }
    }
}