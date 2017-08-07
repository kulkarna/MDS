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
    public class RequestModeEnrollmentTypeController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "RequestModeEnrollmentTypeController";
        #endregion

        #region public constructors
        public RequestModeEnrollmentTypeController() : base()
        {
            ViewBag.PageName = "RequestModeEnrollmentType";
            ViewBag.IndexPageName = "RequestModeEnrollmentType";
            ViewBag.PageDisplayName = "Request Mode Enrollment Type";
        }
        #endregion

        #region public methods

        public override string ActivityGetIndex { get { return "Request Mode Enrollment Type"; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<RequestModeEnrollmentType>());
        }
        //
        // GET: /RequestModeEnrollmentType/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                RequestModeEnrollmentType requestmodeenrollmenttype = _db.RequestModeEnrollmentTypes.Find(id);

                if (requestmodeenrollmenttype == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodeenrollmenttype:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodeenrollmenttype));
                return View(requestmodeenrollmenttype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeEnrollmentType());
            }
        }

        //
        // GET: /RequestModeEnrollmentType/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "false";
                RequestModeEnrollmentType requestmodeenrollmenttype = new RequestModeEnrollmentType()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    LastModifiedDate = DateTime.Now
                };
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodeenrollmenttype:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodeenrollmenttype));
                return View(requestmodeenrollmenttype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeEnrollmentType());
            }
        }

        //
        // POST: /RequestModeEnrollmentType/Create
        [HttpPost]
        public ActionResult Create(RequestModeEnrollmentType requestmodeenrollmenttype)
        {
            string method = string.Format("Create(RequestModeEnrollmentType requestmodeenrollmenttype:{0})", requestmodeenrollmenttype == null ? "NULL VALUE" : requestmodeenrollmenttype.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    requestmodeenrollmenttype.Id = Guid.NewGuid();
                    requestmodeenrollmenttype.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodeenrollmenttype.CreatedDate = DateTime.Now;
                    requestmodeenrollmenttype.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodeenrollmenttype.LastModifiedDate = DateTime.Now;
                    if (requestmodeenrollmenttype.IsRequestModeEnrollmentTypeValid())
                    {
                        _db.RequestModeEnrollmentTypes.Add(requestmodeenrollmenttype);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }

                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodeenrollmenttype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeEnrollmentType());
            }
        }

        //
        // GET: /RequestModeEnrollmentType/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";
                RequestModeEnrollmentType requestmodeenrollmenttype = _db.RequestModeEnrollmentTypes.Find(id);
                if (requestmodeenrollmenttype == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = requestmodeenrollmenttype.CreatedBy;
                Session[Common.CREATEDDATE] = requestmodeenrollmenttype.CreatedDate;

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodeenrollmenttype:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodeenrollmenttype));
                return View(requestmodeenrollmenttype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeEnrollmentType());
            }
        }

        //
        // POST: /RequestModeEnrollmentType/Edit/5
        [HttpPost]
        public ActionResult Edit(RequestModeEnrollmentType requestmodeenrollmenttype)
        {
            string method = string.Format("Edit(RequestModeEnrollmentType requestmodeenrollmenttype:{0})", requestmodeenrollmenttype == null ? "NULL VALUE" : requestmodeenrollmenttype.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    requestmodeenrollmenttype.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    requestmodeenrollmenttype.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    requestmodeenrollmenttype.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodeenrollmenttype.LastModifiedDate = DateTime.Now;
                    if (requestmodeenrollmenttype.IsRequestModeEnrollmentTypeValid())
                    {
                        _db.Entry(requestmodeenrollmenttype).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = requestmodeenrollmenttype.CreatedBy;
                    Session[Common.CREATEDDATE] = requestmodeenrollmenttype.CreatedDate;
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodeenrollmenttype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeEnrollmentType());
            }
        }
        #endregion



        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }
        #endregion
    }
}