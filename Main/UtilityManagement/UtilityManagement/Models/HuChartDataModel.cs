using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UtilityManagement.Models
{
    public class HuChartDataModel
    {
        public string CategoryName { get; set; }
        public int OrderYear { get; set; }

        public IEnumerable<SelectListItem> Categories { get; set; }
        public IEnumerable<SelectListItem> Years { get; set; }
    }
}