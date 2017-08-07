using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UserInterfaceValidationExtensions;
using Utilities;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class UserInterfaceFormControlController : Controller
    {
        private Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();

        //
        // GET: /UserInterfaceFormControl/
        public ActionResult Index()
        {
            var userinterfaceformcontrols = db.UserInterfaceFormControls.Include(u => u.UserInterfaceForm);
            return View(userinterfaceformcontrols.ToList());
        }

        //
        // GET: /UserInterfaceFormControl/Details/5
        public ActionResult Details(Guid id)
        {
            UserInterfaceFormControl userinterfaceformcontrol = db.UserInterfaceFormControls.Find(id);
            if (userinterfaceformcontrol == null)
            {
                return HttpNotFound();
            }
            return View(userinterfaceformcontrol);
        }

        //
        // GET: /UserInterfaceFormControl/Create
        public ActionResult Create()
        {
            Session["IsPostBack"] = "false";
            UserInterfaceFormControl userInterfaceFormControl = new UserInterfaceFormControl()
            {
                CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                CreatedDate = DateTime.Now,
                LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                LastModifiedDate = DateTime.Now
            };

            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName");
            return View(userInterfaceFormControl);
        }

        //
        // POST: /UserInterfaceFormControl/Create
        [HttpPost]
        public ActionResult Create(UserInterfaceFormControl userinterfaceformcontrol)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                userinterfaceformcontrol.Id = Guid.NewGuid();
                userinterfaceformcontrol.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                userinterfaceformcontrol.CreatedDate = DateTime.Now;
                userinterfaceformcontrol.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                userinterfaceformcontrol.LastModifiedDate = DateTime.Now;
                if (userinterfaceformcontrol.IsUserInterfaceFormControlValid())
                {
                    db.UserInterfaceFormControls.Add(userinterfaceformcontrol);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }

            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfaceformcontrol.UserInterfaceFormId);
            return View(userinterfaceformcontrol);
        }

        //
        // GET: /UserInterfaceFormControl/Edit/5
        public ActionResult Edit(Guid id)
        {
            Session["IsPostBack"] = "false";
            UserInterfaceFormControl userinterfaceformcontrol = db.UserInterfaceFormControls.Find(id);
            if (userinterfaceformcontrol == null)
            {
                return HttpNotFound();
            }
            Session["CreatedBy"] = userinterfaceformcontrol.CreatedBy;
            Session["CreatedDate"] = userinterfaceformcontrol.CreatedDate;

            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfaceformcontrol.UserInterfaceFormId);
            return View(userinterfaceformcontrol);
        }

        //
        // POST: /UserInterfaceFormControl/Edit/5
        [HttpPost]
        public ActionResult Edit(UserInterfaceFormControl userinterfaceformcontrol)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                userinterfaceformcontrol.CreatedBy = Session["CreatedBy"] == null ? "NULL USER NAME" : Session["CreatedBy"].ToString();
                userinterfaceformcontrol.CreatedDate = Session["CreatedDate"] == null ? DateTime.Now : (DateTime)Session["CreatedDate"];
                userinterfaceformcontrol.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                userinterfaceformcontrol.LastModifiedDate = DateTime.Now;
                if (userinterfaceformcontrol.IsUserInterfaceFormControlValid())
                {
                    db.Entry(userinterfaceformcontrol).State = EntityState.Modified;
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                Session["CreatedBy"] = userinterfaceformcontrol.CreatedBy;
                Session["CreatedDate"] = userinterfaceformcontrol.CreatedDate;
            }
            ViewBag.UserInterfaceFormId = new SelectList(db.UserInterfaceForms, "Id", "UserInterfaceFormName", userinterfaceformcontrol.UserInterfaceFormId);
            return View(userinterfaceformcontrol);
        }

        //
        // GET: /UserInterfaceFormControl/Delete/5

        public ActionResult Delete(Guid id)
        {
            UserInterfaceFormControl userinterfaceformcontrol = db.UserInterfaceFormControls.Find(id);
            if (userinterfaceformcontrol == null)
            {
                return HttpNotFound();
            }
            return View(userinterfaceformcontrol);
        }

        //
        // POST: /UserInterfaceFormControl/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(Guid id)
        {
            UserInterfaceFormControl userinterfaceformcontrol = db.UserInterfaceFormControls.Find(id);
            db.UserInterfaceFormControls.Remove(userinterfaceformcontrol);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}