using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Utilities;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class AuditLpBillingTypeController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables
        private const string CLASS = "AuditLpBillingTypeController";
        #endregion


        #region public constructors
        public AuditLpBillingTypeController() : base()
        {
            ViewBag.PageName = "AuditLpBillingType";
            ViewBag.IndexPageName = "LpBillingType";
            ViewBag.PageDisplayName = "Audit Account Info Field Required";
        }
        #endregion


        #region actions
        //
        // GET: /AuditLpBillingTypeController/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ObtainResponse();

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<usp_zAuditLpBillingType_SELECT_Result>());
            }
        }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<usp_zAuditLpBillingType_SELECT_Result>());
        }
        //
        // GET: /AuditLoadProfileController/Details/5
        public ActionResult Details(Guid id)
        {
            usp_zAuditLpBillingType_SELECT_Result usp_zAuditLpBillingType_SELECT_Result = _db.usp_zAuditLpBillingType_SELECT().Where(x => x.Id == id).FirstOrDefault();
            if (usp_zAuditLpBillingType_SELECT_Result == null)
            {
                return HttpNotFound();
            }
            return View(usp_zAuditLpBillingType_SELECT_Result);
        }
        #endregion


        #region private methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<usp_zAuditLpBillingType_SELECT_Result> ObtainResponse()
        {
            var response = _db.usp_zAuditLpBillingType_SELECT().OrderBy(x => x.Id).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "Id";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "Id":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Id).ToList();
                    else
                        response = response.OrderBy(x => x.Id).ToList();
                    break;
                case "IdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.IdPrevious).ToList();
                    break;
                case "UtilityCompanyId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCompanyId).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCompanyIdPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCompanyIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCompanyIdPrevious).ToList();
                    break;
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCode).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCode).ToList();
                    break;
                case "UtilityCodePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilityCodePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.UtilityCodePrevious).ToList();
                    break;
                case "PorDriver":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.PorDriver).ToList();
                    else
                        response = response.OrderBy(x => x.PorDriver).ToList();
                    break;
                case "PorDriverPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.PorDriverPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.PorDriverPrevious).ToList();
                    break;
                case "RateClassCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RateClassCode).ToList();
                    else
                        response = response.OrderBy(x => x.RateClassCode).ToList();
                    break;
                case "RateClassCodePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RateClassCodePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RateClassCodePrevious).ToList();
                    break;
                case "LoadProfileCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LoadProfileCode).ToList();
                    else
                        response = response.OrderBy(x => x.LoadProfileCode).ToList();
                    break;
                case "LoadProfileCodePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LoadProfileCodePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LoadProfileCodePrevious).ToList();
                    break;
                case "TariffCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.TariffCode).ToList();
                    else
                        response = response.OrderBy(x => x.TariffCode).ToList();
                    break;
                case "TariffCodePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.TariffCodePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.TariffCodePrevious).ToList();
                    break;
                case "DefaultBillingType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.DefaultBillingType).ToList();
                    else
                        response = response.OrderBy(x => x.DefaultBillingType).ToList();
                    break;
                case "DefaultBillingTypePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.DefaultBillingTypePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.DefaultBillingTypePrevious).ToList();
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = response.OrderBy(x => x.Inactive).ToList();
                    break;
                case "InactivePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.InactivePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.InactivePrevious).ToList();
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedByPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedByPrevious).ToList();
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "CreatedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.CreatedDatePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.CreatedDatePrevious).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedByPrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedByPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedByPrevious).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedDate).ToList();
                    break;
                case "LastModifiedDatePrev":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LastModifiedDatePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LastModifiedDatePrevious).ToList();
                    break;
                case "ChangeVersion":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersion":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperation":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumns":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return response;
        }
        #endregion
    }
}