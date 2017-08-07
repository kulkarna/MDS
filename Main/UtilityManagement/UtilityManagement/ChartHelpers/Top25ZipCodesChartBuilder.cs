using System;
using System.Web.UI.DataVisualization.Charting;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UtilityManagement.Models;

namespace UtilityManagement.ChartHelpers
{
    public class Top25ZipCodesChartBuilder : ChartBuilder
    {
        public Top25ZipCodesChartBuilder(Chart chart) : base(chart, 1) { }

        public string CategoryName { get; set; }
        public int OrderYear { get; set; }

        protected override void CustomizeChartSeries(IList<Series> seriesList)
        {
            Series mySeries = seriesList.First();
            mySeries.Name = "Hu Utility SLA";
            mySeries.ChartType = SeriesChartType.Column;
            mySeries.BorderWidth = 5;
            mySeries.Palette = ChartColorPalette.None;

            using (var context = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities())
            {
                mySeries.Points.AddXY("11226", "3360");
                mySeries.Points.AddXY("11373", "2638");
                mySeries.Points.AddXY("60016", "2125");
                mySeries.Points.AddXY("60085", "2633");
                mySeries.Points.AddXY("11220", "1985");
                mySeries.Points.AddXY("11372", "1845");
                mySeries.Points.AddXY("60623", "1746");
                mySeries.Points.AddXY("11213", "1689");
                mySeries.Points.AddXY("60649", "1629");
                mySeries.Points.AddXY("60115", "1605");
            }
        }

        protected override void CustomizeChartSeriesPorAvgFlatFee(IList<Series> seriesList)
        {
            Series mySeries = seriesList.First();
            mySeries.Name = "Top 25 Zip Codes";
            mySeries.ChartType = SeriesChartType.Column;
            mySeries.BorderWidth = 5;
            mySeries.Palette = ChartColorPalette.None;

            using (var context = new DataAccessLayerEntityFramework.Lp_UtilityManagementEntities())
            {
                mySeries.Points.AddXY("11226", "3360");
                mySeries.Points.AddXY("11373", "2638");
                mySeries.Points.AddXY("60016", "2125");
                mySeries.Points.AddXY("60085", "2633");
                mySeries.Points.AddXY("11220", "1985");
                mySeries.Points.AddXY("11372", "1845");
                mySeries.Points.AddXY("60623", "1746");
                mySeries.Points.AddXY("11213", "1689");
                mySeries.Points.AddXY("60649", "1629");
                mySeries.Points.AddXY("60115", "1605");
            }
        }

        protected override void CustomizeChartTitle(Title title)
        {
            title.Text = "Top 10 Zip Codes";
        }

        protected override void CustomizeChartArea(ChartArea area)
        {
            area.Area3DStyle.Enable3D = false;
            area.BackGradientStyle = GradientStyle.None;
        }
    }
}