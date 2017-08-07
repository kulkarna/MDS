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
    public class AccountInfoFieldController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "AccountInfoFieldController";
        #endregion

        #region public constructors
        public AccountInfoFieldController() : base()
        {
            ViewBag.PageName = "AccountInfoField";
            ViewBag.IndexPageName = "AccountInfoField";
            ViewBag.PageDisplayName = "Account Info Fields";
        }
        #endregion

        #region public methods
        //
        // GET: /AccountInfoField/
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
                return View(new List<AccountInfoField>());
            }
        }


        public override ActionResult GetBlankResponse()
        {
            return View(new List<AccountInfoField>());
        }

        //
        // GET: /AccountInfoField/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                AccountInfoField accountInfoField = _db.AccountInfoFields.Find(id);

                if (accountInfoField == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountInfoField:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountInfoField));
                return View(accountInfoField);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountInfoField());
            }
        }

        [HttpPost]
        public ActionResult Details(AccountInfoField accountInfoField, string submitButton)
        {
            string method = string.Format(" Details(AccountInfoField accountInfoField:{0}, submitButton:{1})", accountInfoField == null ? "NULL VALUE" : accountInfoField.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "AccountInfoField", new { id = accountInfoField.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountInfoField());
            }
        }

        //
        // GET: /AccountInfoField/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "false";
                AccountInfoField accountInfoField = new AccountInfoField()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])), 
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountInfoField:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountInfoField));
                return View(accountInfoField);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountInfoField());
            }
        }

        //
        // POST: /AccountInfoField/Create
        [HttpPost]
        public ActionResult Create(AccountInfoField accountInfoField, string submitButton)
        {
            string method = string.Format("Create(AccountInfoField accountInfoField:{0})", accountInfoField == null ? "NULL VALUE" : accountInfoField.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Index", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index", "AccountInfoField", new { id = accountInfoField.Id });
                    case "Save":
                        Session[Common.ISPOSTBACK] = "true";
                        if (ModelState.IsValid)
                        {
                            accountInfoField.Id = Guid.NewGuid();
                            accountInfoField.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                            accountInfoField.CreatedDate = DateTime.Now;
                            accountInfoField.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                            accountInfoField.LastModifiedDate = DateTime.Now;
                                if (accountInfoField.IsAccountInfoFieldValid())
                                {
                                    _db.AccountInfoFields.Add(accountInfoField);
                                    _db.SaveChanges();
                                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                                    return RedirectToAction("Index");
                                }
                        }
                        ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                        ViewBag.AccountTypeId = GetAccountTypeSelectList();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return View(accountInfoField);
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(accountInfoField);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new AccountInfoField());
            }
        }

        //
        // GET: /AccountInfoField/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";
                AccountInfoField accountInfoField = _db.AccountInfoFields.Find(id);
                if (accountInfoField == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = accountInfoField.CreatedBy;
                Session[Common.CREATEDDATE] = accountInfoField.CreatedDate;
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} accountInfoField:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, accountInfoField));

                return View(accountInfoField);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                AccountInfoField accountInfoField = _db.AccountInfoFields.Find(id);
                return View(accountInfoField);
            }
        }

        //
        // POST: /AccountInfoField/Edit/5
        [HttpPost]
        public ActionResult Edit(AccountInfoField accountInfoField, string submitButton)
        {
            string method = string.Format("Edit(AccountInfoField accountInfoField:{0})", accountInfoField == null ? "NULL VALUE" : accountInfoField.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Index", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index", "AccountInfoField", new { id = accountInfoField.Id });
                    case "Save":
                        Session[Common.ISPOSTBACK] = "true";
                        if (ModelState.IsValid)
                        {
                            accountInfoField.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                            accountInfoField.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                            accountInfoField.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                            accountInfoField.LastModifiedDate = DateTime.Now;
                            if (accountInfoField.IsAccountInfoFieldValid())
                            {
                                _db.Entry(accountInfoField).State = EntityState.Modified;
                                _db.SaveChanges();
                                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                                return RedirectToAction("Index");
                            }
                        }
                        else
                        {
                            accountInfoField.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                            accountInfoField.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                        }
                        Session[Common.CREATEDBY] = accountInfoField.CreatedBy;
                        Session[Common.CREATEDDATE] = accountInfoField.CreatedDate;

                        ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                        ViewBag.AccountTypeId = GetAccountTypeSelectList();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return View(accountInfoField);
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(accountInfoField);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                accountInfoField = _db.AccountInfoFields.Find(accountInfoField.Id);
                return View(accountInfoField);
            }
        }

        public ActionResult NameUserFriendlyTitleClick()
        {
            string method = "NameUserFriendlyTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("NameUserFriendly");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult NameMachineUnfriendlyTitleClick()
        {
            string method = "NameMachineUnfriendlyTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("NameMachineUnfriendly");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

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
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Description");

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
        #endregion


        #region private and protected methods
        protected override void Dispose(bool disposing)
        {
            _db.Dispose();
            base.Dispose(disposing);
        }

        private List<AccountInfoField> ObtainResponse()
        {
            var response = _db.AccountInfoFields.OrderBy(x => x.NameUserFriendly).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "NameUserFriendly":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameUserFriendlyImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.NameUserFriendly).ToList();
                    }
                    else
                    {
                        ViewBag.NameUserFriendlyImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.NameUserFriendly).ToList();
                    }
                    break;
                case "NameMachineUnfriendly":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameMachineUnfriendlyImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.NameMachineUnfriendly).ToList();
                    }
                    else
                    {
                        ViewBag.NameMachineUnfriendlyImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.NameMachineUnfriendly).ToList();
                    }
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DescriptionImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.Description).ToList();
                    }
                    else
                    {
                        ViewBag.DescriptionImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.Description).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            return response;
        }


        public override ActionResult ObtainActionResult()
        {
            var response = _db.AccountInfoFields.OrderBy(x => x.NameUserFriendly).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "NameUserFriendly":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameUserFriendlyImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.NameUserFriendly).ToList();
                    }
                    else
                    {
                        ViewBag.NameUserFriendlyImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.NameUserFriendly).ToList();
                    }
                    break;
                case "NameMachineUnfriendly":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.NameMachineUnfriendlyImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.NameMachineUnfriendly).ToList();
                    }
                    else
                    {
                        ViewBag.NameMachineUnfriendlyImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.NameMachineUnfriendly).ToList();
                    }
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DescriptionImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.Description).ToList();
                    }
                    else
                    {
                        ViewBag.DescriptionImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.Description).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response = _db.AccountInfoFields.OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response = _db.AccountInfoFields.OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            return View(response);
        }
        #endregion
    }
}