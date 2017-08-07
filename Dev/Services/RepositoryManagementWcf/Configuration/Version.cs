using System.Diagnostics;
using System.Reflection;

namespace LibertyPower.RepositoryManagement.Web
{
    public static class Version
    {
        private static string current = null;
        public static string Build
        {
            get
            {
                if (string.IsNullOrEmpty(current))
                {
                    Assembly assembly = Assembly.GetExecutingAssembly();
                    FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(assembly.Location);
                    current = fvi.FileVersion;
                }
                return current;
            }
        }
    }
}