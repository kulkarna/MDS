using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using UtilityLogging;
using UtilityUnityLogging;
using Utilities;
using UtilityManagementRepository;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class AuditRequestModeIcapController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables
        private const string CLASS = "AuditRequestModeHistoricalUsageController";
        #endregion


        #region public constructors
        public AuditRequestModeIcapController() : base()
        {
            ViewBag.PageName = "AuditRequestModeIcap";
            ViewBag.IndexPageName = "AuditRequestModeIcap";
            ViewBag.PageDisplayName = "Audit Request Mode I-Cap";
        }
        #endregion


        #region actions
        //
        // GET: /AuditRequestModeIcap/
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
                return View(new List<usp_zAuditRequestModeIcap_SELECT1_Result>());
            }
        }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<usp_zAuditRequestModeIcap_SELECT1_Result>());
        }

        public ActionResult IdClick()
        {
            string method = "IdClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Id");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IdPrevClick()
        {
            string method = "IdPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IdPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult UtilityCompanyIdClick()
        {
            string method = "UtilityCompanyIdClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCompanyId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult UtilityCompanyIdPrevClick()
        {
            string method = "UtilityCompanyIdPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCompanyIdPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult UtilityCodeClick()
        {
            string method = "UtilityCodeClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCode");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult UtilityCodePrevClick()
        {
            string method = "UtilityCodePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilityCodePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult RequestModeEnrollmentTypeIdClick()
        {
            string method = "RequestModeEnrollmentTypeIdClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeEnrollmentTypeId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RequestModeEnrollmentTypeIdPrevClick()
        {
            string method = "RequestModeEnrollmentTypeIdPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeEnrollmentTypeIdPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult RequestModeEnrollmentTypeClick()
        {
            string method = "RequestModeEnrollmentTypeClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeEnrollmentType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RequestModeEnrollmentTypePrevClick()
        {
            string method = "RequestModeEnrollmentTypePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeEnrollmentTypePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult RequestModeTypeIdClick()
        {
            string method = "RequestModeTypeIdClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeTypeId");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RequestModeTypeIdPrevClick()
        {
            string method = "RequestModeTypeIdPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeTypeIdPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult RequestModeTypeClick()
        {
            string method = "RequestModeTypeClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult RequestModeTypePrevClick()
        {
            string method = "RequestModeTypePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("RequestModeTypePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult AddressForPreEnrollmentClick()
        {
            string method = "AddressForPreEnrollmentClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AddressForPreEnrollment");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult AddressForPreEnrollmentPrevClick()
        {
            string method = "AddressForPreEnrollmentPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AddressForPreEnrollmentPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult EmailTemplateClick()
        {
            string method = "EmailTemplateClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("EmailTemplate");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult EmailTemplatePrevClick()
        {
            string method = "EmailTemplatePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("EmailTemplatePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult InstructionsClick()
        {
            string method = "InstructionsClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Instructions");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult InstructionsPrevClick()
        {
            string method = "InstructionsPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("InstructionsPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult UtilitysSlaHistoricalUsageResponseInDaysClick()
        {
            string method = "UtilitysSlaHistoricalUsageResponseInDaysClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilitysSlaHistoricalUsageResponseInDays");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult UtilitysSlaHistoricalUsageResponseInDaysPrevClick()
        {
            string method = "UtilitysSlaHistoricalUsageResponseInDaysPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("UtilitysSlaHistoricalUsageResponseInDaysPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysClick()
        {
            string method = "LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LibertyPowersSlaFollowUpHistoricalUsageResponseInDays");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevClick()
        {
            string method = "LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }


        public ActionResult IsLoaRequiredClick()
        {
            string method = "IsLoaRequiredClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IsLoaRequired");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult IsLoaRequiredPrevClick()
        {
            string method = "IsLoaRequiredPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("IsLoaRequiredPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }



        //public ActionResult InactiveTitleClick()
        //{
        //    string method = "InactiveTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("Inactive");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult InactivePrevClick()
        {
            string method = "InactivePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("InactivePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult CreatedByTitleClick()
        //{
        //    string method = "CreatedByTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("CreatedBy");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult CreatedByPrevClick()
        {
            string method = "CreatedByPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CreatedByPrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult CreatedDateTitleClick()
        //{
        //    string method = "CreatedDateTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("CreatedDate");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult CreatedDatePrevClick()
        {
            string method = "CreatedDatePrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CreatedDatePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult LastModifiedByTitleClick()
        //{
        //    string method = "LastModifiedByTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("LastModifiedBy");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult LastModifiedByPrevClick()
        {
            string method = "LastModifiedByPrevClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LastModifiedPrevBy");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        //public ActionResult LastModifiedDateTitleClick()
        //{
        //    string method = "LastModifiedDateTitleClick()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ManageSortationSession("LastModifiedDate");

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

        //        return response;
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return RedirectToAction("Index");
        //    }
        //}

        public ActionResult LastModifiedDatePrevClick()
        {
            string method = "LastModifiedDateClickPrev()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LastModifiedDatePrev");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ChangeVersionClick()
        {
            string method = "ChangeVersionClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ChangeVersionClick");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult CreationVersionClick()
        {
            string method = "CreationVersionClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("CreationVersionClick");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ChangeOperationClick()
        {
            string method = "ChangeOperationClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ChangeOperationClick");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ChangeColumnsClick()
        {
            string method = "ChangeColumnsClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("ChangeColumnsClick");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }
        #endregion


        #region private methods
        public override ActionResult ObtainActionResult()
        {
            var response = _db.usp_zAuditRequestModeIcap_SELECT1().OrderBy(x => x.Id).ToList();
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
                case "RequestModeEnrollmentTypeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeEnrollmentTypeId).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeEnrollmentTypeId).ToList();
                    break;
                case "RequestModeEnrollmentTypeIdPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeEnrollmentTypeIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeEnrollmentTypeIdPrevious).ToList();
                    break;
                case "RequestModeEnrollmentType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeEnrollmentType).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeEnrollmentType).ToList();
                    break;
                case "RequestModeEnrollmentTypePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeEnrollmentTypePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeEnrollmentTypePrevious).ToList();
                    break;
                case "RequestModeTypeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeTypeId).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeTypeId).ToList();
                    break;
                case "RequestModeTypeIdPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeTypeIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeTypeIdPrevious).ToList();
                    break;
                case "RequestModeType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeType).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeType).ToList();
                    break;
                case "RequestModeTypePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeTypePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeTypePrevious).ToList();
                    break;
                case "AddressForPreEnrollment":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.AddressForPreEnrollment).ToList();
                    else
                        response = response.OrderBy(x => x.AddressForPreEnrollment).ToList();
                    break;
                case "AddressForPreEnrollmentPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.AddressForPreEnrollmentPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.AddressForPreEnrollmentPrevious).ToList();
                    break;
                case "EmailTemplate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.EmailTemplate).ToList();
                    else
                        response = response.OrderBy(x => x.EmailTemplate).ToList();
                    break;
                case "EmailTemplatePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.EmailTemplatePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.EmailTemplatePrevious).ToList();
                    break;
                case "Instructions":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Instructions).ToList();
                    else
                        response = response.OrderBy(x => x.Instructions).ToList();
                    break;
                case "InstructionsPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.InstructionsPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.InstructionsPrevious).ToList();
                    break;
                case "UtilitysSlaHistoricalUsageResponseInDays":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilitysSlaIcapResponseInDays).ToList();
                    else
                        response = response.OrderBy(x => x.UtilitysSlaIcapResponseInDays).ToList();
                    break;
                case "UtilitysSlaHistoricalUsageResponseInDaysPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilitysSlaIcapResponseInDaysPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.UtilitysSlaIcapResponseInDaysPrevious).ToList();
                    break;
                case "LibertyPowersSlaFollowUpHistoricalUsageResponseInDays":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LibertyPowersSlaFollowUpIcapResponseInDays).ToList();
                    else
                        response = response.OrderBy(x => x.LibertyPowersSlaFollowUpIcapResponseInDays).ToList();
                    break;
                case "LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LibertyPowersSlaFollowUpIcapResponseInDaysPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LibertyPowersSlaFollowUpIcapResponseInDaysPrevious).ToList();
                    break;
                case "IsLoaRequired":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IsLoaRequired).ToList();
                    else
                        response = response.OrderBy(x => x.IsLoaRequired).ToList();
                    break;
                case "IsLoaRequiredPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IsLoaRequiredPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.IsLoaRequiredPrevious).ToList();
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
                case "ChangeVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperationClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumnsClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return View(response);
        }

        
        private List<usp_zAuditRequestModeIcap_SELECT1_Result> ObtainResponse()
        {
            var response = _db.usp_zAuditRequestModeIcap_SELECT1().OrderBy(x => x.Id).ToList();
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
                case "RequestModeEnrollmentTypeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeEnrollmentTypeId).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeEnrollmentTypeId).ToList();
                    break;
                case "RequestModeEnrollmentTypeIdPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeEnrollmentTypeIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeEnrollmentTypeIdPrevious).ToList();
                    break;
                case "RequestModeEnrollmentType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeEnrollmentType).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeEnrollmentType).ToList();
                    break;
                case "RequestModeEnrollmentTypePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeEnrollmentTypePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeEnrollmentTypePrevious).ToList();
                    break;
                case "RequestModeTypeId":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeTypeId).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeTypeId).ToList();
                    break;
                case "RequestModeTypeIdPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeTypeIdPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeTypeIdPrevious).ToList();
                    break;
                case "RequestModeType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeType).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeType).ToList();
                    break;
                case "RequestModeTypePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.RequestModeTypePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.RequestModeTypePrevious).ToList();
                    break;
                case "AddressForPreEnrollment":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.AddressForPreEnrollment).ToList();
                    else
                        response = response.OrderBy(x => x.AddressForPreEnrollment).ToList();
                    break;
                case "AddressForPreEnrollmentPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.AddressForPreEnrollmentPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.AddressForPreEnrollmentPrevious).ToList();
                    break;
                case "EmailTemplate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.EmailTemplate).ToList();
                    else
                        response = response.OrderBy(x => x.EmailTemplate).ToList();
                    break;
                case "EmailTemplatePrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.EmailTemplatePrevious).ToList();
                    else
                        response = response.OrderBy(x => x.EmailTemplatePrevious).ToList();
                    break;
                case "Instructions":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.Instructions).ToList();
                    else
                        response = response.OrderBy(x => x.Instructions).ToList();
                    break;
                case "InstructionsPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.InstructionsPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.InstructionsPrevious).ToList();
                    break;
                case "UtilitysSlaHistoricalUsageResponseInDays":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilitysSlaIcapResponseInDays).ToList();
                    else
                        response = response.OrderBy(x => x.UtilitysSlaIcapResponseInDays).ToList();
                    break;
                case "UtilitysSlaHistoricalUsageResponseInDaysPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.UtilitysSlaIcapResponseInDaysPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.UtilitysSlaIcapResponseInDaysPrevious).ToList();
                    break;
                case "LibertyPowersSlaFollowUpHistoricalUsageResponseInDays":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LibertyPowersSlaFollowUpIcapResponseInDays).ToList();
                    else
                        response = response.OrderBy(x => x.LibertyPowersSlaFollowUpIcapResponseInDays).ToList();
                    break;
                case "LibertyPowersSlaFollowUpHistoricalUsageResponseInDaysPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.LibertyPowersSlaFollowUpIcapResponseInDaysPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.LibertyPowersSlaFollowUpIcapResponseInDaysPrevious).ToList();
                    break;
                case "IsLoaRequired":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IsLoaRequired).ToList();
                    else
                        response = response.OrderBy(x => x.IsLoaRequired).ToList();
                    break;
                case "IsLoaRequiredPrevious":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.IsLoaRequiredPrevious).ToList();
                    else
                        response = response.OrderBy(x => x.IsLoaRequiredPrevious).ToList();
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
                case "ChangeVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_VERSION).ToList();
                    break;
                case "CreationVersionClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_CREATION_VERSION).ToList();
                    break;
                case "ChangeOperationClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_OPERATION).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_OPERATION).ToList();
                    break;
                case "ChangeColumnsClick":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                        response = response.OrderByDescending(x => x.SYS_CHANGE_COLUMNS).ToList();
                    else
                        response = response.OrderBy(x => x.SYS_CHANGE_COLUMNS).ToList();
                    break;
            }
            return response;
        }
        #endregion


        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }
    }
}