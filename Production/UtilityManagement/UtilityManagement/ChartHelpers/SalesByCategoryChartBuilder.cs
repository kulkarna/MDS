using System;
using System.Web.UI.DataVisualization.Charting;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UtilityManagement.Models;

namespace UtilityManagement.ChartHelpers
{
    public class SalesByCategoryChartBuilder : ChartBuilder
    {
        public SalesByCategoryChartBuilder(Chart chart) : base(chart, 1) { }

        public string CategoryName { get; set; }
        public int OrderYear { get; set; }

        protected override void CustomizeChartSeries(IList<Series> seriesList)
        {
            Series mySeries = seriesList.First();
            mySeries.Name = this.OrderYear.ToString();
            mySeries.ChartType = SeriesChartType.Column;
            mySeries.BorderWidth = 5;
            mySeries.Palette = ChartColorPalette.None;

            using (var context = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities())
            {
                var salesResults = context.usp_ChartOne();
                foreach (var result in salesResults)
                    mySeries.Points.AddXY(result.UtilCodeEnrolAndMode, result.UtilitysSlaIdrResponseInDays);
            }
        }

        protected override void CustomizeChartTitle(Title title)
        {
            title.Text = "Utility Response In Days";
        }

        protected override void CustomizeChartArea(ChartArea area)
        {
            area.Area3DStyle.Enable3D = false;
            area.BackGradientStyle = GradientStyle.None;
        }
    }
}