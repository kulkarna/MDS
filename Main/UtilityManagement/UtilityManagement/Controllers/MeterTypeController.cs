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
    public class MeterTypeController : ControllerBaseWithoutUtilDropDown
    {
        #region private variables and constants
        private const string CLASS = "MeterTypeController";
        #endregion

        #region public constructors
        public MeterTypeController()
            : base()
        {
            ViewBag.PageName = "MeterType";
            ViewBag.IndexPageName = "MeterType";
            ViewBag.PageDisplayName = "Meter Type";
        }
        #endregion

        #region public methods
        ////
        //// GET: /MeterType/
        //public ActionResult Index()
        //{
        //    string method = "Index()";
        //    try
        //    {
        //        VerifyMessageIdAndErrorMessageSession();
        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

        //        var response = ObtainResponse();

        //        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));
        //        return View(response);
        //    }
        //    catch (Exception exc)
        //    {
        //        ErrorHandler(exc, method);
        //        return View(new List<MeterType>());
        //    }
        //}

        public override string ActivityGetIndex { get { return "Meter Type"; } }

        public override ActionResult GetBlankResponse()
        {
            return View(new List<MeterType>());
        }

        //
        // GET: /MeterType/Details/5
        public ActionResult Details(Guid id)
        {
            string method = string.Format("Details(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                MeterType meterType = _db.MeterTypes.Find(id);

                if (meterType == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterType:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterType));
                return View(meterType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new MeterType());
            }
        }

        [HttpPost]
        public ActionResult Details(MeterType meterType, string submitButton)
        {
            string method = string.Format(" Details(MeterType meterType:{0}, submitButton:{1})", meterType == null ? "NULL VALUE" : meterType.ToString(), Common.NullSafeString(submitButton));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                switch (submitButton)
                {
                    case "Edit":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Edit", "MeterType", new { id = meterType.Id });
                }
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Back to List", Common.NAMESPACE, CLASS, method));
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return RedirectToAction("Index");
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new MeterType());
            }
        }

        //
        // GET: /MeterType/Create
        public ActionResult Create()
        {
            string method = "Create()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                Session[Common.ISPOSTBACK] = "false";
                MeterType meterType = new MeterType()
                {
                    CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    CreatedDate = DateTime.Now,
                    LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                    LastModifiedDate = DateTime.Now
                };
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterType:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterType));
                return View(meterType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new MeterType());
            }
        }

        //
        // POST: /MeterType/Create
        [HttpPost]
        public ActionResult Create(MeterType meterType, string submitButton)
        {
            string method = string.Format("Create(MeterType meterType:{0})", meterType == null ? "NULL VALUE" : meterType.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                switch (submitButton)
                {
                    case "Back to List":
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} Redirecting to Index", Common.NAMESPACE, CLASS, method));
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index", "MeterType", new { id = meterType.Id });
                    case "Save":
                        Session[Common.ISPOSTBACK] = "true";
                        if (ModelState.IsValid)
                        {
                            meterType.Id = Guid.NewGuid();
                            meterType.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                            meterType.CreatedDate = DateTime.Now;
                            meterType.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                            meterType.LastModifiedDate = DateTime.Now;
                            var nonDuplicateResult = _db.usp_MeterType_GetCountOfUtilityCompanyIdAndMeterTypeCode(meterType.UtilityCompanyId.ToString(), meterType.MeterTypeCode);
                            if (nonDuplicateResult != null)
                            {
                                var nonDuplicatedResultList = nonDuplicateResult.ToList();
                                if (meterType.IsMeterTypeValid() && (nonDuplicatedResultList == null || nonDuplicatedResultList.Count < 1 || nonDuplicatedResultList[0] == null || 
                                    //nonDuplicatedResultList[0].Value == null || 
                                    nonDuplicatedResultList[0].Value == 0))
                                {
                                    _db.MeterTypes.Add(meterType);
                                    _db.SaveChanges();
                                    _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                                    return RedirectToAction("Index");
                                }
                            }
                        }
                        ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                        ViewBag.AccountTypeId = GetAccountTypeSelectList();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return View(meterType);
                }
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT CREATED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(meterType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return View(new MeterType());
            }
        }

        //
        // GET: /MeterType/Edit/5
        public ActionResult Edit(Guid id)
        {
            string method = string.Format("Edit(Guid id:{0})", Common.NullSafeGuid(id));
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "false";
                MeterType meterType = _db.MeterTypes.Find(id);
                if (meterType == null)
                {
                    _logger.LogError(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} HttpNotFound() {3}", Common.NAMESPACE, CLASS, method, Common.END));
                    return HttpNotFound();
                }
                Session[Common.CREATEDBY] = meterType.CreatedBy;
                Session[Common.CREATEDDATE] = meterType.CreatedDate;
                Session["UtilityCompanyId"] = meterType.UtilityCompanyId;
                Session["UtilityCompanyName"] = meterType.UtilityCompany.UtilityCode;
                Session["AccountTypeName"] = meterType.AccountType.Name;
                Session["AccountTypeId"] = meterType.AccountTypeId;
                Session["MeterTypeCode"] = meterType.MeterTypeCode;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(meterType.UtilityCompanyId.ToString());
                ViewBag.AccountTypeId = GetAccountTypeSelectList(meterType.AccountTypeId);
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} meterType:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, meterType));

                return View(meterType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                MeterType meterType = _db.MeterTypes.Find(id);
                return View(meterType);
            }
        }

        //
        // POST: /MeterType/Edit/5
        [HttpPost]
        public ActionResult Edit(MeterType meterType, string submitButton)
        {
            string method = string.Format("Edit(MeterType meterType:{0})", meterType == null ? "NULL VALUE" : meterType.ToString());
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));
                Session[Common.ISPOSTBACK] = "true";
                if (ModelState.IsValid)
                {
                    meterType.CreatedBy = Session[Common.CREATEDBY] == null ? "NULL USER NAME" : Session[Common.CREATEDBY].ToString();
                    meterType.CreatedDate = Session[Common.CREATEDDATE] == null ? DateTime.Now : (DateTime)Session[Common.CREATEDDATE];
                    meterType.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                    meterType.LastModifiedDate = DateTime.Now;
                    meterType.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    var nonDuplicateResult = _db.usp_MeterType_GetCountOfUtilityCompanyIdAndMeterTypeCode(meterType.UtilityCompanyId.ToString(), meterType.MeterTypeCode);
                    var nonDuplicatedResultList = nonDuplicateResult.ToList();
                    if (meterType.IsMeterTypeValid() && (nonDuplicatedResultList == null || nonDuplicatedResultList.Count < 1 || nonDuplicatedResultList[0] == null
                        || nonDuplicatedResultList[0].Value == 0 || (nonDuplicatedResultList[0].Value == 1 && Session["MeterTypeCode"].ToString() == meterType.MeterTypeCode)))
                    {
                        _db.Entry(meterType).State = EntityState.Modified;
                        _db.SaveChanges();
                        _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} SUCCESS {3}", Common.NAMESPACE, CLASS, method, Common.END));
                        return RedirectToAction("Index");
                    }
                }
                else
                {
                    meterType.AccountTypeId = Common.NullSafeGuid(Session["AccountTypeId"]);
                    meterType.UtilityCompanyId = Common.NullSafeGuid(Session["UtilityCompanyId"]);
                    meterType.CreatedBy = Common.NullSafeString(Session[Common.CREATEDBY]);
                    meterType.CreatedDate = (DateTime)Session[Common.CREATEDDATE];
                }
                Session["AccountTypeId"] = meterType.AccountTypeId;

                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList();
                ViewBag.AccountTypeId = GetAccountTypeSelectList();
                meterType.UtilityCompany = _db.MeterTypes.Find(meterType.Id).UtilityCompany;
                meterType.UtilityCompany.UtilityCode = Session["UtilityCompanyName"] == null ? "NULL VALUE" : Session["UtilityCompanyName"].ToString();
                meterType.AccountType = _db.MeterTypes.Find(meterType.Id).AccountType;
                meterType.AccountType.Name = Session["AccountTypeName"] == null ? "NULL VALUE" : Session["AccountTypeName"].ToString();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} NOT EDITED {3}", Common.NAMESPACE, CLASS, method, Common.END));
                return View(meterType);
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                meterType = _db.MeterTypes.Find(meterType.Id);
                ViewBag.AccountTypeId = GetAccountTypeSelectList(meterType.AccountTypeId);
                ViewBag.UtilityCompanyId = GetUtilityCompanyIdSelectList(meterType.UtilityCompanyId.ToString());
                return View(meterType);
            }
        }

        public ActionResult UtilityCodeTitleClick()
        {
            string method = "UtilityCodeTitleClick()";
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

        public ActionResult MeterTypeCodeTitleClick()
        {
            string method = "MeterTypeCodeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("MeterTypeCode");

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

        public ActionResult AccountTypeTitleClick()
        {
            string method = "AccountTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("AccountType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult LpStandardMeterTypeTitleClick()
        {
            string method = "LpStandardMeterTypeTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("LpStandardMeterType");

                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} response:{4} {3}", Common.NAMESPACE, CLASS, method, Common.END, response));

                return response;
            }
            catch (Exception exc)
            {
                ErrorHandler(exc, method);
                return RedirectToAction("Index");
            }
        }

        public ActionResult SequenceTitleClick()
        {
            string method = "SequenceTitleClick()";
            try
            {
                VerifyMessageIdAndErrorMessageSession();
                _logger.LogInfo(Session[Common.MESSAGEID].ToString(), string.Format("{0}.{1}.{2} {3}", Common.NAMESPACE, CLASS, method, Common.BEGIN));

                var response = ManageSortationSession("Sequence");

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

        private IQueryable<MeterType> GetBaseData()
        {
            return _db.MeterTypes.Where(x => x.UtilityCompany.Inactive == false).Include(r => r.AccountType).Include(r => r.UtilityCompany);
        }

        public override ActionResult ObtainActionResult()
        {
            var response = _db.MeterTypes.Where(x => x.UtilityCompany.Inactive == false).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilityCodeImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    break;
                case "MeterTypeCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterTypeCodeImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.MeterTypeCode).ToList();
                    }
                    else
                    {
                        ViewBag.MeterTypeCodeImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.MeterTypeCode).ToList();
                    }
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DescriptionImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.Description).ToList();
                    }
                    else
                    {
                        ViewBag.DescriptionImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.Description).ToList();
                    }
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AccountTypeImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.AccountType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.AccountTypeImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.AccountType.Name).ToList();
                    }
                    break;
                case "LpStandardMeterType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LpStandardMeterTypeImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.LpStandardMeterType).ToList();
                    }
                    else
                    {
                        ViewBag.LpStandardMeterTypeImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.LpStandardMeterType).ToList();
                    }
                    break;
                case "Sequence":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.SequenceImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.Sequence).ToList();
                    }
                    else
                    {
                        ViewBag.SequenceImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.Sequence).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            return View(response);
        }

        private List<MeterType> ObtainResponse()
        {
            var response = _db.MeterTypes.Where(x => x.UtilityCompany.Inactive == false).Include(r => r.AccountType).Include(r => r.UtilityCompany).OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
            if (Session[Common.SORTCOLUMNNAME] == null)
                Session[Common.SORTCOLUMNNAME] = "UtilityCode";
            if (Session[Common.SORTDIRECTION] == null)
                Session[Common.SORTDIRECTION] = Common.ASC;
            switch (Session[Common.SORTCOLUMNNAME].ToString())
            {
                case "UtilityCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.UtilityCodeImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    else
                    {
                        ViewBag.UtilityCodeImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.UtilityCompany.UtilityCode).ToList();
                    }
                    break;
                case "MeterTypeCode":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.MeterTypeCodeImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.MeterTypeCode).ToList();
                    }
                    else
                    {
                        ViewBag.MeterTypeCodeImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.MeterTypeCode).ToList();
                    }
                    break;
                case "Description":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.DescriptionImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.Description).ToList();
                    }
                    else
                    {
                        ViewBag.DescriptionImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.Description).ToList();
                    }
                    break;
                case "AccountType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.AccountTypeImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.AccountType.Name).ToList();
                    }
                    else
                    {
                        ViewBag.AccountTypeImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.AccountType.Name).ToList();
                    }
                    break;
                case "LpStandardMeterType":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LpStandardMeterTypeImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.LpStandardMeterType).ToList();
                    }
                    else
                    {
                        ViewBag.LpStandardMeterTypeImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.LpStandardMeterType).ToList();
                    }
                    break;
                case "Sequence":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.SequenceImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.Sequence).ToList();
                    }
                    else
                    {
                        ViewBag.SequenceImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.Sequence).ToList();
                    }
                    break;
                case "Inactive":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.InactiveImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.Inactive).ToList();
                    }
                    else
                    {
                        ViewBag.InactiveImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.Inactive).ToList();
                    }
                    break;
                case "CreatedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedByImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.CreatedBy).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedByImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.CreatedBy).ToList();
                    }
                    break;
                case "CreatedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.CreatedDateImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.CreatedDate).ToList();
                    }
                    else
                    {
                        ViewBag.CreatedDateImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.CreatedDate).ToList();
                    }
                    break;
                case "LastModifiedBy":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedByImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.LastModifiedBy).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedByImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.LastModifiedBy).ToList();
                    }
                    break;
                case "LastModifiedDate":
                    if (Session[Common.SORTDIRECTION].ToString() == Common.DESC)
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.DOWNARROW;
                        response = GetBaseData().OrderByDescending(x => x.LastModifiedDate).ToList();
                    }
                    else
                    {
                        ViewBag.LastModifiedDateImageUrl = Common.UPARROW;
                        response = GetBaseData().OrderBy(x => x.LastModifiedDate).ToList();
                    }
                    break;
            }
            return response;
        }
        #endregion
    }
}