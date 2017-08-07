using System;

namespace LibertyPower.RepositoryManagement.Web
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblBuild.Text = Version.Build;
        }

        private void TestEventLog()
        {
            EventLogger.WriteEntry(String.Format("Testing event log...{0}", DateTime.Now));
        }
    }
}