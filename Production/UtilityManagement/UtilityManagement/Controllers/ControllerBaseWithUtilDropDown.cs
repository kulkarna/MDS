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

    public class ControllerBaseWithUtilDropDown : ControllerBase 
    {
        private const string CLASS = "ControllerBaseWithUtilDropDown";

        public ControllerBaseWithUtilDropDown() : base()
        {
        }

        public virtual ActionResult Index(string utilityCompanyId)
        {
            try
            {
                return GetBlankResponse();
            }
            catch (Exception)
            {
                return GetBlankResponse();
            }
        }
    }
}