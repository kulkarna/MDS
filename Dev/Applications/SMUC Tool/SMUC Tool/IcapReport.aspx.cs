using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UtilityLogging;
using UtilityUnityLogging;
using Utilities;
using System.Data;
using SmucDataLayer;
using SmucBusinessLayer;

namespace SMUC_Tool
{
    public partial class IcapReport : System.Web.UI.Page
    {
        #region private variables


        private string _appName = "SMUC";
        private const string NAMESPACE = "SMUC_Tool";
        private const string CLASS = "IcapReport";
        private ILogger _logger = null;
        private IBusinessLayer _businessLayer = null;
        private IDal _dal = null;
        #endregion
        string messageId = Guid.NewGuid().ToString();


        protected void Page_Load(object sender, EventArgs e)
        {

            string method = "Page_Load()";
            try
            {
                _logger = UnityLoggerGenerator.GenerateLogger();
                _dal = new Dal(messageId, _logger);
                _businessLayer = new BusinessLayer(messageId, _logger, _dal);
                if (!IsPostBack)
                {
                    BindIso();
                    BindUtilityByIso();
                }
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }


        }

        private void BindUtilityByIso()
        {
            string method = "BindIso()";
            DateTime beginDate = DateTime.Now;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                string iso = ddlIso.SelectedItem.Text;
                ddlUtility.DataSource = _businessLayer.GetUtility(messageId, iso);
                ddlUtility.DataValueField = "Id";
                ddlUtility.DataTextField = "UtilityCode";
                ddlUtility.DataBind();
                ddlUtility.Items.Insert(0, "All");
                ddlUtility.SelectedIndex = 0;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
        }

        private void BindIso()
        {
            string method = "BindIso()";
            DateTime beginDate = DateTime.Now;

            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));
                ddlIso.DataSource = _businessLayer.GetIso(messageId);
                ddlIso.DataValueField = "ID";
                ddlIso.DataTextField = "ISO";
                ddlIso.DataBind();
                ddlIso.SelectedIndex = 0;
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} End", NAMESPACE, CLASS, method));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
        }

        

        protected void ddlIso_SelectedIndexChanged1(object sender, EventArgs e)
        {
            string method = "ddlIso_SelectedIndexChanged1()";
            DateTime beginDate = DateTime.Now;
            try
            {
                BindUtilityByIso();
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
        }

        protected void btnViewReport_Click(object sender, EventArgs e)
        {
            string method = "btnViewReport_Click()";
            DateTime beginDate = DateTime.Now;
            DataSet dsReportData = new DataSet();
            try
            {
                string accountNumber = (string.IsNullOrEmpty(txtAccountNumber.Text.Trim())) ? null : Common.NullSafeString(txtAccountNumber.Text.Trim());
                string isoId = Common.NullSafeString(ddlIso.SelectedItem.Text.Trim());
                string utilityCode = (ddlUtility.SelectedIndex != 0) ? Common.NullSafeString(ddlUtility.SelectedItem.Text.Trim()) : null;
                dsReportData = _businessLayer.GetResults(messageId, isoId, utilityCode,accountNumber);

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
            }
        }
    }
}