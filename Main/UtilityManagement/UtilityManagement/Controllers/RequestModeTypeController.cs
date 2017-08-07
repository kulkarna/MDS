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
    public class RequestModeTypeController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "RequestModeTypeController";
        #endregion

        #region public constructors
        public RequestModeTypeController() : base()
        {
            ViewBag.PageName = "RequestModeType";
            ViewBag.IndexPageName = "RequestModeType";
            ViewBag.PageDisplayName = "Request Mode Type";
        }
        #endregion

        #region public methods
        //
        // GET: /RequestModeType/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                var response = _db.RequestModeTypes.ToList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<RequestModeType>());
            }
        }

        //
        // GET: /RequestModeType/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                RequestModeType requestmodetype = _db.RequestModeTypes.Find(id);

                if (requestmodetype == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodetype:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodetype));
                return View(requestmodetype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeType());
            }
        }

        //
        // GET: /RequestModeType/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "false";
                RequestModeType requestModeType = new RequestModeType()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeType:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeType));
                return View(requestModeType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeType());
            }
        }

        //
        // POST: /RequestModeType/Create
        [HttpPost]
        public ActionResult Create(RequestModeType requestmodetype)
        {
            string method = string.Format("Create(RequestModeType requestmodetype:{0})", requestmodetype == null ? "NULL VALUE" : requestmodetype.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    requestmodetype.Id = Guid.NewGuid();
                    requestmodetype.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodetype.CreatedDate = DateTime.Now;
                    requestmodetype.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodetype.LastModifiedDate = DateTime.Now;
                    if (requestmodetype.IsRequestModeTypeValid())
                    {
                        _db.RequestModeTypes.Add(requestmodetype);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodetype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeType());
            }
        }

        //
        // GET: /RequestModeType/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";
                RequestModeType requestmodetype = _db.RequestModeTypes.Find(id);
                if (requestmodetype == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = requestmodetype.CreatedBy;
                Session[Common.CREATEDDATE] = requestmodetype.CreatedDate;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodetype:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodetype));

                return View(requestmodetype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeType requestmodetype = _db.RequestModeTypes.Find(id);
                return View(requestmodetype);
            }
        }

        //
        // POST: /RequestModeType/Edit/5
        [HttpPost]
        public ActionResult Edit(RequestModeType requestmodetype)
        {
            string method = string.Format("Edit(RequestModeType requestmodetype:{0})", requestmodetype == null ? "NULL VALUE" : requestmodetype.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    requestmodetype.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    requestmodetype.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    requestmodetype.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodetype.LastModifiedDate = DateTime.Now;
                    if (requestmodetype.IsRequestModeTypeValid())
                    {
                        _db.Entry(requestmodetype).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = requestmodetype.CreatedBy;
                    Session[Common.CREATEDDATE] = requestmodetype.CreatedDate;
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodetype);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(requestmodetype);
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