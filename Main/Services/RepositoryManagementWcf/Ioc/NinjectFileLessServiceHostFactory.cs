using System.ServiceModel;
using Ninject;
using Ninject.Extensions.Wcf;

namespace LibertyPower.RepositoryManagement.Web
{
    public class NinjectFileLessServiceHostFactory : NinjectServiceHostFactory
    {
        public NinjectFileLessServiceHostFactory()
        {
            var kernel = new StandardKernel(new ServiceModule());
            kernel.Bind<ServiceHost>().To<NinjectServiceHost>();
            SetKernel(kernel);
        }
    }
}