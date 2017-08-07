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
    public class RequestModeTypeGenreController : ControllerBase
    {
        #region private variables and constants
        private const string CLASS = "RequestModeTypeGenreController";
        #endregion

        #region public constructors
        public RequestModeTypeGenreController() : base()
        {
            ViewBag.PageName = "RequestModeTypeGenre";
            ViewBag.IndexPageName = "RequestModeTypeGenre";
            ViewBag.PageDisplayName = "Request Mode Type Genre";
        }
        #endregion

        #region public methods
        //
        // GET: /RequestModeTypeGenre/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                var response = _db.RequestModeTypeGenres.ToList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<RequestModeTypeGenre>());
            }
        }

        //
        // GET: /RequestModeTypeGenre/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                RequestModeTypeGenre requestmodetypegenre = _db.RequestModeTypeGenres.Find(id);
                if (requestmodetypegenre == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodetypegenre:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodetypegenre));
                return View(requestmodetypegenre);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeTypeGenre());
            }
        }

        //
        // GET: /RequestModeTypeGenre/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "false";
                RequestModeTypeGenre requestModeTypeGenre = new RequestModeTypeGenre()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestModeTypeGenre:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestModeTypeGenre));
                return View(requestModeTypeGenre);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeTypeGenre());
            }
        }

        //
        // POST: /RequestModeTypeGenre/Create
        [HttpPost]
        public ActionResult Create(RequestModeTypeGenre requestmodetypegenre)
        {
            string method = string.Format("Create(RequestModeTypeGenre requestmodetypegenre:{0})", requestmodetypegenre == null ? "NULL VALUE" : requestmodetypegenre.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    requestmodetypegenre.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodetypegenre.CreatedDate = DateTime.Now;
                    requestmodetypegenre.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodetypegenre.LastModifiedDate = DateTime.Now;
                    requestmodetypegenre.Id = Guid.NewGuid();
                    if (requestmodetypegenre.IsRequestModeTypeGenreValid())
                    {
                        _db.RequestModeTypeGenres.Add(requestmodetypegenre);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodetypegenre);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new RequestModeTypeGenre());
            }
        }

        //
        // GET: /RequestModeTypeGenre/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";
                RequestModeTypeGenre requestmodetypegenre = _db.RequestModeTypeGenres.Find(id);
                if (requestmodetypegenre == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = requestmodetypegenre.CreatedBy;
                Session[Common.CREATEDDATE] = requestmodetypegenre.CreatedDate;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} requestmodetypegenre:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, requestmodetypegenre));

                return View(requestmodetypegenre);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                RequestModeTypeGenre requestmodetypegenre = _db.RequestModeTypeGenres.Find(id);
                return View(requestmodetypegenre);
            }
        }

        //
        // POST: /RequestModeTypeGenre/Edit/5
        [HttpPost]
        public ActionResult Edit(RequestModeTypeGenre requestmodetypegenre)
        {
            string method = string.Format("Edit(RequestModeTypeGenre requestmodetypegenre:{0})", requestmodetypegenre == null ? "NULL VALUE" : requestmodetypegenre.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    requestmodetypegenre.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    requestmodetypegenre.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    requestmodetypegenre.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    requestmodetypegenre.LastModifiedDate = DateTime.Now;
                    if (requestmodetypegenre.IsRequestModeTypeGenreValid())
                    {
                        _db.Entry(requestmodetypegenre).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = requestmodetypegenre.CreatedBy;
                    Session[Common.CREATEDDATE] = requestmodetypegenre.CreatedDate;
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(requestmodetypegenre);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(requestmodetypegenre);
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