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
    public class AccountTypeController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "AccountTypeController";
        #endregion

        #region public constructors
        public AccountTypeController() : base()
        {
            ViewBag.PageName = "AccountType";
            ViewBag.IndexPageName = "AccountType";
            ViewBag.PageDisplayName = "Account Type";
        }
        #endregion

        #region public methods
        //
        // GET: /AccountType/
        public override ActionResult Index()
        {
            string method = "Index()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                var response = _db.AccountTypes.ToList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
                return View(response);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new List<AccountType>());
            }
        }

        //
        // GET: /AccountType/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                AccountType accountType = _db.AccountTypes.Find(id);

                if (accountType == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountType:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountType));
                return View(accountType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountType());
            }
        }

        //
        // GET: /AccountType/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "false";
                AccountType accountType = new AccountType()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    LastModifiedDate = DateTime.Now
                };
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountType:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountType));
                return View(accountType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountType());
            }
        }

        //
        // POST: /AccountType/Create
        [HttpPost]
        public ActionResult Create(AccountType accountType)
        {
            string method = string.Format("Create(AccountType accountType:{0})", accountType == null ? "NULL VALUE" : accountType.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    accountType.Id = Guid.NewGuid();
                    accountType.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    accountType.CreatedDate = DateTime.Now;
                    accountType.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    accountType.LastModifiedDate = DateTime.Now;
                    if (accountType.IsAccountTypeValid())
                    {
                        _db.AccountTypes.Add(accountType);
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(accountType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountType());
            }
        }

        //
        // GET: /AccountType/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";
                AccountType accountType = _db.AccountTypes.Find(id);
                if (accountType == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = accountType.CreatedBy;
                Session[Common.CREATEDDATE] = accountType.CreatedDate;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountType:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountType));

                return View(accountType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                AccountType accountType = _db.AccountTypes.Find(id);
                return View(accountType);
            }
        }

        //
        // POST: /AccountType/Edit/5
        [HttpPost]
        public ActionResult Edit(AccountType accountType)
        {
            string method = string.Format("Edit(AccountType accountType:{0})", accountType == null ? "NULL VALUE" : accountType.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    accountType.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    accountType.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    accountType.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; //Common.GetUserName(User.Identity.Name);
                    accountType.LastModifiedDate = DateTime.Now;
                    if (accountType.IsAccountTypeValid())
                    {
                        _db.Entry(accountType).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                    Session[Common.CREATEDBY] = accountType.CreatedBy;
                    Session[Common.CREATEDDATE] = accountType.CreatedDate;
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(accountType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(accountType);
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