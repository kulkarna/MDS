using System;
using System.Web.UI.DataVisualization.Charting;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UtilityManagement.Models;

namespace UtilityManagement.ChartHelpers
{
    public class MeterReadCalendarCountChartBuilder : ChartBuilder
    {
        public MeterReadCalendarCountChartBuilder(Chart chart) : base(chart, 1) { }

        public string CategoryName { get; set; }
        public int OrderYear { get; set; }

        protected override void CustomizeChartSeries(IList<Series> seriesList)
        {
            Series mySeries = seriesList.First();
            mySeries.Name = this.OrderYear.ToString();
            mySeries.ChartType = SeriesChartType.Range;
            mySeries.BorderWidth = 5;
            mySeries.Palette = ChartColorPalette.None;

            using (var context = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities())
            {
                var salesResults = context.usp_Chart_MeterReadCalendarCount();
                foreach (var result in salesResults)
                    mySeries.Points.AddXY(result.UtilityCode, result.MeterReadCalendarCount);
            }
        }

        protected override void CustomizeChartTitle(Title title)
        {
            title.Text = "Utility Meter Read Calendar Count";
        }

        protected override void CustomizeChartArea(ChartArea area)
        {
            area.Area3DStyle.Enable3D = false;
            area.BackGradientStyle = GradientStyle.None;
        }
    }
}