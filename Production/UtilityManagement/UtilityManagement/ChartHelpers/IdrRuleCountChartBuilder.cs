using System;
using System.Web.UI.DataVisualization.Charting;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UtilityManagement.Models;

namespace UtilityManagement.ChartHelpers
{
    public class IdrRuleCountChartBuilder : ChartBuilder
    {
        public IdrRuleCountChartBuilder(Chart chart) : base(chart, 1) { }

        public string CategoryName { get; set; }
        public int OrderYear { get; set; }

        protected override void CustomizeChartSeries(IList<Series> seriesList)
        {
            Series mySeries = seriesList.First();
            mySeries.Name = this.OrderYear.ToString();
            mySeries.ChartType = SeriesChartType.Spline;
            mySeries.BorderWidth = 5;
            mySeries.Palette = ChartColorPalette.None;

            using (var context = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities())
            {
                var salesResults = context.usp_Chart_IdrRuleCount();
                foreach (var result in salesResults)
                    mySeries.Points.AddXY(result.UtilityCode, result.TotalRuleCount);
            }
        }

        protected override void CustomizeChartSeriesWithBias(IList<Series> seriesList)
        {
            Series mySeries = seriesList.First();
            mySeries.Name = "2014";
            mySeries.ChartType = SeriesChartType.Spline;
            mySeries.BorderWidth = 5;
            mySeries.Palette = ChartColorPalette.None;

            using (var context = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities())
            {
                var salesResults2 = context.usp_Chart_IdrRuleCount();
                foreach (var result in salesResults2)
                    mySeries.Points.AddXY(result.UtilityCode, result.RateClassRuleCount);
            }
        }

        protected override void CustomizeChartSeriesPorAvgFlatFee(IList<Series> seriesList)
        {
            Series mySeries = seriesList.First();
            mySeries.Name = "2015";
            mySeries.ChartType = SeriesChartType.Line;
            mySeries.BorderWidth = 5;
            mySeries.Palette = ChartColorPalette.None;

            using (var context = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities())
            {
                var salesResults2 = context.usp_Chart_IdrRuleCount();
                foreach (var result in salesResults2)
                    mySeries.Points.AddXY(result.UtilityCode, result.LoadProfileRuleCount);
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