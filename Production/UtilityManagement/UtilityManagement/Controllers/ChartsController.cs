using System;
using System.IO;
using System.Collections.Generic;
using System.Web.UI.DataVisualization.Charting;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UtilityManagement.ChartHelpers;

namespace UtilityManagement.Controllers
{
    [ValidateInputAttribute(false)]
    public class ChartsController : ControllerBaseWithoutUtilDropDown
    {
        public override ActionResult Index()
        {
            try
            {
                // Create the Chart object and set some properties
                var salesChart = new Chart()
                {
                    Width = 600,
                    Height = 400
                };

                var builder = new SalesByCategoryChartBuilder(salesChart);
                builder.CategoryName = "Data";
                builder.OrderYear = 2013;
                builder.BuildChart();

                salesChart.Titles[0].Visible = false;

                // Save the chart to a MemoryStream
                var imgStream = new MemoryStream();
                salesChart.SaveImage(imgStream, ChartImageFormat.Png);
                imgStream.Seek(0, SeekOrigin.Begin);

                // Return the contents of the Stream to the client
                return File(imgStream, "image/png");
            }
            catch (Exception)
            {
                string s = string.Empty;
                return View();
            }
        }
        public ActionResult SalesByYear(string categoryName, int orderYear = 1995, bool showTitle = true)
        {
            // Create the Chart object and set some properties
            var salesChart = new Chart()
            {
                Width = 600,
                Height = 400
            };

            // Plot its data... here we use Scott Allen's ChartBuilder class, but you could
            // plot the data programmatically, via data binding, etc. For more info on the
            // various plotting techniques, see: http://www.4guysfromrolla.com/articles/072909-1.aspx
            var builder = new SalesByCategoryChartBuilder(salesChart);
            builder.CategoryName = categoryName;
            builder.OrderYear = orderYear;
            builder.BuildChart();

            if (!showTitle)
                salesChart.Titles[0].Visible = false;

            // Save the chart to a MemoryStream
            var imgStream = new MemoryStream();
            salesChart.SaveImage(imgStream, ChartImageFormat.Png);
            imgStream.Seek(0, SeekOrigin.Begin);

            // Return the contents of the Stream to the client
            return File(imgStream, "image/png");
        }
    }
}
