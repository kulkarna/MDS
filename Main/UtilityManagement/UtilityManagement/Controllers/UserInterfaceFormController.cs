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
    public class UserInterfaceFormController : Controller
    {
        private Lp_UtilityManagementEntities db = new Lp_UtilityManagementEntities();

        //
        // GET: /UserInterfaceForm/
        public ActionResult Index()
        {
            return View(db.UserInterfaceForms.ToList());
        }

        //
        // GET: /UserInterfaceForm/Details/5
        public ActionResult Details(Guid id)
        {
            UserInterfaceForm userinterfaceform = db.UserInterfaceForms.Find(id);
            if (userinterfaceform == null)
            {
                return HttpNotFound();
            }
            return View(userinterfaceform);
        }

        //
        // GET: /UserInterfaceForm/Create
        public ActionResult Create()
        {
            Session["IsPostBack"] = "false";
            UserInterfaceForm userInterfaceForm = new UserInterfaceForm()
            {
                CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                CreatedDate = DateTime.Now,
                LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID])),
                LastModifiedDate = DateTime.Now
            };
            return View(userInterfaceForm);
        }

        //
        // POST: /UserInterfaceForm/Create
        [HttpPost]
        public ActionResult Create(UserInterfaceForm userinterfaceform)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                userinterfaceform.Id = Guid.NewGuid();
                userinterfaceform.CreatedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                userinterfaceform.CreatedDate = DateTime.Now;
                userinterfaceform.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));
                userinterfaceform.LastModifiedDate = DateTime.Now;
                if (userinterfaceform.IsUserInterfaceFormValid())
                {
                    db.UserInterfaceForms.Add(userinterfaceform);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }

            return View(userinterfaceform);
        }

        //
        // GET: /UserInterfaceForm/Edit/5
        public ActionResult Edit(Guid id)
        {
            Session["IsPostBack"] = "false";
            UserInterfaceForm userinterfaceform = db.UserInterfaceForms.Find(id);
            if (userinterfaceform == null)
            {
                return HttpNotFound();
            }
            Session["CreatedBy"] = userinterfaceform.CreatedBy;
            Session["CreatedDate"] = userinterfaceform.CreatedDate;

            return View(userinterfaceform);
        }

        //
        // POST: /UserInterfaceForm/Edit/5
        [HttpPost]
        public ActionResult Edit(UserInterfaceForm userinterfaceform)
        {
            Session["IsPostBack"] = "true";
            if (ModelState.IsValid)
            {
                userinterfaceform.CreatedBy = Session["CreatedBy"] == null ? "NULL USER NAME" : Session["CreatedBy"].ToString();
                userinterfaceform.CreatedDate = Session["CreatedDate"] == null ? DateTime.Now : (DateTime)Session["CreatedDate"];
                userinterfaceform.LastModifiedBy = GetUserName(Common.NullSafeString(Session[Common.MESSAGEID]));; // Common.GetUserName(User.Identity.Name);
                userinterfaceform.LastModifiedDate = DateTime.Now;
                if (userinterfaceform.IsUserInterfaceFormValid())
                {
                    db.Entry(userinterfaceform).State = EntityState.Modified;
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                Session["CreatedBy"] = userinterfaceform.CreatedBy;
                Session["CreatedDate"] = userinterfaceform.CreatedDate;
            }
            return View(userinterfaceform);
        }

        //
        // GET: /UserInterfaceForm/Delete/5
        public ActionResult Delete(Guid id)
        {
            UserInterfaceForm userinterfaceform = db.UserInterfaceForms.Find(id);
            if (userinterfaceform == null)
            {
                return HttpNotFound();
            }
            return View(userinterfaceform);
        }

        //
        // POST: /UserInterfaceForm/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(Guid id)
        {
            UserInterfaceForm userinterfaceform = db.UserInterfaceForms.Find(id);
            db.UserInterfaceForms.Remove(userinterfaceform);
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