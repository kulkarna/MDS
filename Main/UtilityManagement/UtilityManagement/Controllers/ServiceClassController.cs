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
    public class ServiceClassController : Controller
    {
        #region private variables and constants
        private ILogger _logger;
        private const string ISPOSTBACK = "IsPostBack";
        private const string MESSAGEID = "MessageId";
        private const string NAMESPACE = "UtilityManagement.Controllers";
        private const string CLASS = "ServiceClassController";
        private const string CREATEDBY = "CreatedBy";
        private const string CREATEDDATE = "CreatedDate";
        private const string BEGIN = "BEGIN";
        private const string END = "END";
        private const string ERRORMESSAGE = "ErrorMessage";
        private const string SORTCOLUMNNAME = "SortColumnName";
        private const string SORTDIRECTION = "SortDirection";
        private const string ASC = "Asc";
        private const string DESC = "Desc";
        private Lp_UtilityManagementEntities db;
        #endregion

        #region public constructors
        public ServiceClassController()
        {
            db = new Lp_UtilityManagementEntities();
            _logger = UnityLoggerGenerator.GenerateLogger();
        }
        #endregion

        #region public methods
        //
        // GET: /ServiceClass/
        public ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ObtainResponse();

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<ServiceClass>());
            }
        }

        //
        // GET: /ServiceClass/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                ServiceClass serviceClass = db.ServiceClasses.Find(id);

                if (serviceClass == null)
                {
                    _logger.LogError(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", NAMESPACE, CLASS, method, END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceClass:{4} {3}", NAMESPACE, CLASS, method, END, serviceClass));
                return View(serviceClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceClass());
            }
        }

        [HttpPost]
        public ActionResult Details(ServiceClass serviceClass, string submitButton)
        {
            string method = string.Format(" Details(ServiceClass serviceClass:{0}, submitButton:{1})", serviceClass == null ? "NULL VALUE" : serviceClass.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, END));
                        return RedirectToAction("Edit", "ServiceClass", new { id = serviceClass.Id });
                }
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceClass());
            }
        }

        //
        // GET: /ServiceClass/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                Session[ISPOSTBACK] = "false";
                ServiceClass serviceClass = new ServiceClass()
                {
                    CreatedBy = "User", // Common.GetUserName(User.Identity.Name),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = "User", // Common.GetUserName(User.Identity.Name),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies.OrderBy(x => x.UtilityCode), "Id", "UtilityCode");
                ViewBag.AccountTypeId = new SelectList(db.AccountTypes.OrderBy(x => x.Name), "Id", "Name");
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceClass:{4} {3}", NAMESPACE, CLASS, method, END, serviceClass));
                return View(serviceClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceClass());
            }
        }

        //
        // POST: /ServiceClass/Create
        [HttpPost]
        public ActionResult Create(ServiceClass serviceClass, string submitButton)
        {
            string method = string.Format("Create(ServiceClass serviceClass:{0})", serviceClass == null ? "NULL VALUE" : serviceClass.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));
                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Index", NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, END));
                        return RedirectToAction("Index", "ServiceClass", new { id = serviceClass.Id });
                    case "Save":
                        Session[ISPOSTBACK] = "true";
                        if (ModelState.IsValid)
                        {
                            serviceClass.Id = Guid.NewGuid();
                            serviceClass.CreatedBy = "User"; // Common.GetUserName(User.Identity.Name);
                            serviceClass.CreatedDate = DateTime.Now;
                            serviceClass.LastModifiedBy = "User"; // Common.GetUserName(User.Identity.Name);
                            serviceClass.LastModifiedDate = DateTime.Now;
                            if (serviceClass.IsServiceClassValid())
                            {
                                db.ServiceClasses.Add(serviceClass);
                                db.SaveChanges();
                                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", NAMESPACE, CLASS, method, END));
                                return RedirectToAction("Index");
                            }
                        }
                        ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies.OrderBy(x => x.UtilityCode), "Id", "UtilityCode");
                        ViewBag.AccountTypeId = new SelectList(db.AccountTypes.OrderBy(x => x.Name), "Id", "Name");
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", NAMESPACE, CLASS, method, END));
                        return View(serviceClass);
                }
                ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies.OrderBy(x => x.UtilityCode), "Id", "UtilityCode");
                ViewBag.AccountTypeId = new SelectList(db.AccountTypes.OrderBy(x => x.Name), "Id", "Name");
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", NAMESPACE, CLASS, method, END));
                return View(serviceClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new ServiceClass());
            }
        }

        //
        // GET: /ServiceClass/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));
                Session[ISPOSTBACK] = "false";
                ServiceClass serviceClass = db.ServiceClasses.Find(id);
                if (serviceClass == null)
                {
                    _logger.LogError(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", NAMESPACE, CLASS, method, END));
                    return HttpNotFound();
                }
                Session[CREATEDBY] = serviceClass.CreatedBy;
                Session[CREATEDDATE] = serviceClass.CreatedDate;
                Session["UtilityCompanyId"] = serviceClass.UtilityCompanyId;
                Session["UtilityCompanyName"] = serviceClass.UtilityCompany.UtilityCode;
                Session["AccountTypeName"] = serviceClass.AccountType.Name;
                Session["AccountTypeId"] = serviceClass.AccountTypeId;

                ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies.OrderBy(x => x.UtilityCode), "Id", "UtilityCode", serviceClass.UtilityCompanyId);
                ViewBag.AccountTypeId = new SelectList(db.AccountTypes.OrderBy(x => x.Name), "Id", "Name", serviceClass.AccountTypeId);
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} serviceClass:{4} {3}", NAMESPACE, CLASS, method, END, serviceClass));

                return View(serviceClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                ServiceClass serviceClass = db.ServiceClasses.Find(id);
                return View(serviceClass);
            }
        }

        //
        // POST: /ServiceClass/Edit/5
        [HttpPost]
        public ActionResult Edit(ServiceClass serviceClass, string submitButton)
        {
            string method = string.Format("Edit(ServiceClass serviceClass:{0})", serviceClass == null ? "NULL VALUE" : serviceClass.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));
                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Index", NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, END));
                        return RedirectToAction("Index", "ServiceClass", new { id = serviceClass.Id });
                    case "Save":
                        Session[ISPOSTBACK] = "true";
                        if (ModelState.IsValid)
                        {
                            serviceClass.CreatedBy = Session[CREATEDBY] == null ? "NULL USER NAME" : Session[CREATEDBY].ToString();
                            serviceClass.CreatedDate = Session[CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[CREATEDDATE];
                            serviceClass.LastModifiedBy = "User"; // Common.GetUserName(User.Identity.Name);
                            serviceClass.LastModifiedDate = DateTime.Now;
                            serviceClass.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                            serviceClass.AccountTypeId = Common.NullSafeGuid(Session["AccountTypeId"]);
                            if (serviceClass.IsServiceClassValid())
                            {
                                db.Entry(serviceClass).State = EntityState.Modified;
                                db.SaveChanges();
                                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", NAMESPACE, CLASS, method, END));
                                return RedirectToAction("Index");
                            }
                        }
                        else
                        {
                            serviceClass.AccountTypeId = Common.NullSafeGuid(Session["AccountTypeId"]);
                            serviceClass.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                            serviceClass.CreatedBy = Common.NullSafeString(Session[CREATEDBY]);
                            serviceClass.CreatedDate = (DateTime)Session[CREATEDDATE];
                        }
                        Session[CREATEDBY] = serviceClass.CreatedBy;
                        Session[CREATEDDATE] = serviceClass.CreatedDate;
                        Session["UtilityCompanyId"] = serviceClass.UtilityCompanyId;
                        Session["AccountTypeId"] = serviceClass.AccountTypeId;

                        ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies.OrderBy(x => x.UtilityCode), "Id", "UtilityCode");
                        ViewBag.AccountTypeId = new SelectList(db.AccountTypes.OrderBy(x => x.Name), "Id", "Name");
                        serviceClass.UtilityCompany = db.RequestModeHistoricalUsages.Find(serviceClass.Id).UtilityCompany;
                        serviceClass.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                        serviceClass.AccountType = db.ServiceClasses.Find(serviceClass.Id).AccountType;
                        serviceClass.AccountType.Name = Session["AccountTypeName"] == null ? "NULL VALUE" : Session["AccountTypeName"].ToString();
                        _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", NAMESPACE, CLASS, method, END));
                        return View(serviceClass);
                }
                ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies.OrderBy(x => x.UtilityCode), "Id", "UtilityCode");
                ViewBag.AccountTypeId = new SelectList(db.AccountTypes.OrderBy(x => x.Name), "Id", "Name");
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", NAMESPACE, CLASS, method, END));
                return View(serviceClass);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                serviceClass = db.ServiceClasses.Find(serviceClass.Id);
                ViewBag.AccountTypeId = new SelectList(db.AccountTypes, "Id", "Name", serviceClass.AccountTypeId);
                ViewBag.UtilityCompanyId = new SelectList(db.UtilityCompanies, "Id", "UtilityCode", serviceClass.UtilityCompanyId);
                return View(serviceClass);
            }
        }

        public ActionResult UtilityCodeTitleClick()
        {
            string method = "UtilityCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("UtilityCode");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult ServiceClassCodeTitleClick()
        {
            string method = "ServiceClassCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("ServiceClassCode");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult DescriptionTitleClick()
        {
            string method = "DescriptionTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("Description");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult AccountTypeTitleClick()
        {
            string method = "AccountTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("AccountType");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LpStandardServiceClassTitleClick()
        {
            string method = "LpStandardServiceClassTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("LpStandardServiceClass");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult InactiveTitleClick()
        {
            string method = "InactiveTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("Inactive");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult CreatedByTitleClick()
        {
            string method = "CreatedByTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("CreatedBy");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult CreatedDateTitleClick()
        {
            string method = "CreatedDateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("CreatedDate");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LastModifiedByTitleClick()
        {
            string method = "LastModifiedByTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("LastModifiedBy");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LastModifiedDateTitleClick()
        {
            string method = "LastModifiedDateTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", NAMESPACE, CLASS, method, BEGIN));

                var response = ManageSortationSession("LastModifiedDate");

                _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", NAMESPACE, CLASS, method, END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }

        private void VerifyMessageIdAndErrorMessageSession()
        {
            Session[ERRORMESSAGE] = string.Empty;
            if (Session[MESSAGEID] == null || string.IsNullOrWhiteSpace(Session[MESSAGEID].ToString()))
                Session[MESSAGEID] = Guid.NewGuid().ToString();
        }

        private void ErrorHandler(Exception exc, string method)
        {
            _logger.LogError(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", NAMESPACE, CLASS, method, exc.Message), exc);
            _logger.LogInfo(Session[MESSAGEID].ToString(), string.Format("{0}.{1}.{2}  {3}", NAMESPACE, CLASS, method, END));
            Session[ERRORMESSAGE] = exc == null ? "NULL EXCEPTION OBJECT" : exc.Message;
        }

        private ActionResult ManageSortationSession(string sortColumn)
        {
            if (Session[SORTCOLUMNNAME].ToString() == sortColumn && Session[SORTDIRECTION].ToString() == ASC)
                Session[SORTDIRECTION] = DESC;
            else
                Session[SORTDIRECTION] = ASC;
            Session[SORTCOLUMNNAME] = sortColumn;
            return RedirectToAction("Index");
        }

        private List<ServiceClass> ObtainResponse()
        {
            var response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[SORTCOLUMNNAME] == null)
                Session[SORTCOLUMNNAME] = "UtilityCode";
            if (Session[SORTDIRECTION] == null)
                Session[SORTDIRECTION] = ASC;
            switch (Session[SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    break;
                case "ServiceClassCode":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.ServiceClassCode).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.ServiceClassCode).ToList();
                    break;
                case "Description":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Description).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Description).ToList();
                    break;
                case "AccountType":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.AccountType.Name).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.AccountType.Name).ToList();
                    break;
                case "LpStandardServiceClass":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LpStandardServiceClass).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LpStandardServiceClass).ToList();
                    break;
                case "Inactive":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.Inactive).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.Inactive).ToList();
                    break;
                case "CreatedBy":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedBy).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedBy).ToList();
                    break;
                case "CreatedDate":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.CreatedDate).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.CreatedDate).ToList();
                    break;
                case "LastModifiedBy":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedBy).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedBy).ToList();
                    break;
                case "LastModifiedDate":
                    if (Session[SORTDIRECTION].ToString() == DESC)
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderByDescending(x => x.LastModifiedDate).ToList();
                    else
                        response = db.ServiceClasses.Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.LastModifiedDate).ToList();
                    break;
            }
            return response;
        }
        #endregion
    }
}