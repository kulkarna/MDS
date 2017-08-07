using System;
using System.Web.UI.DataVisualization.Charting;
using System.Drawing;
using System.Collections.Generic;

namespace UtilityManagement.ChartHelpers
{
    public abstract class ChartBuilder
    {
        public ChartBuilder(Chart chart) : this(chart, 0) { }

        public ChartBuilder(Chart chart, int numberOfSeries)
        {
            _chart = chart;
            this.NumberOfSeries = numberOfSeries;
        }

        public void BuildChart()
        {
            _chart.ChartAreas.Add(BuildChartArea());
            _chart.Titles.Add(BuildChartTitle());
            if (this.NumberOfSeries > 1)
            {
                _chart.Legends.Add(BuildChartLegend());
            }
            foreach (var series in BuildChartSeries())
            {
                _chart.Series.Add(series);
            }
        }

        public void BuildRenkoChart()
        {
            _chart.ChartAreas.Add(BuildChartArea());
            _chart.Titles.Add(BuildChartTitle());
            _chart.Legends.Add(BuildChartLegend());
            foreach (var series in BuildChartSeries())
            {
                _chart.Series.Add(series);
            }
        }

        public void BuildFunnelChart()
        {
            _chart.ChartAreas.Add(BuildChartArea());
            _chart.Titles.Add(BuildChartTitle());
            _chart.Legends.Add(BuildChartLegend());
            foreach (var series in BuildChartSeries())
            {
                _chart.Series.Add(series);
            }
        }

        protected virtual void CustomizeChartArea(ChartArea area)
        {

        }

        protected virtual void CustomizeChartLegend(Legend legend)
        {

        }

        protected virtual void CustomizeChartSeries(IList<Series> seriesList)
        {

        }

        protected virtual void CustomizeChartSeriesPorAvgFlatFee(IList<Series> seriesList)
        {

        }

        protected virtual void CustomizeChartSeriesWithBias(IList<Series> seriesList)
        {

        }

        protected virtual void CustomizeChartTitleWithBias(Title title)
        {

        }

        protected virtual void CustomizeChartTitle(Title title)
        {

        }

        private Legend BuildChartLegend()
        {
            Legend legend = new Legend()
            {
                Alignment = StringAlignment.Near,
                Docking = Docking.Right
            };
            CustomizeChartLegend(legend);
            return legend;
        }

        private Title BuildChartTitle()
        {
            Title title = new Title()
            {
                Docking = Docking.Top,
                Font = new Font("Trebuchet MS", 18.0f, FontStyle.Bold),
            };
            CustomizeChartTitle(title);
            return title;
        }

        private IList<Series> BuildChartSeries()
        {
            var seriesList = new List<Series>();
            for (int i = 0; i < this.NumberOfSeries; i++)
            {
                Series series = new Series()
                {
                    ChartType = SeriesChartType.Column,
                    Palette = ChartColorPalette.Pastel,
                    MarkerSize = 10
                };
                seriesList.Add(series);
            }
            CustomizeChartSeries(seriesList);
            return seriesList;
        }

        private IList<Series> BuildChartSeriesWithBias()
        {
            var seriesList = new List<Series>();
            for (int i = 0; i < this.NumberOfSeries; i++)
            {
                Series series = new Series()
                {
                    ChartType = SeriesChartType.Column,
                    Palette = ChartColorPalette.Pastel,
                    MarkerSize = 10
                };
                seriesList.Add(series);
            }
            CustomizeChartSeriesWithBias(seriesList);
            return seriesList;
        }

        private IList<Series> BuildChartSeriesPorAvgFlatFee()
        {
            var seriesList = new List<Series>();
            for (int i = 0; i < this.NumberOfSeries; i++)
            {
                Series series = new Series()
                {
                    ChartType = SeriesChartType.Column,
                    Palette = ChartColorPalette.Pastel,
                    MarkerSize = 10
                };
                seriesList.Add(series);
            }
            CustomizeChartSeriesPorAvgFlatFee(seriesList);
            return seriesList;
        }

        private ChartArea BuildChartArea()
        {
            ChartArea area = new ChartArea()
            {
                BackColor = Color.BlanchedAlmond,
                BackSecondaryColor = Color.Black,
                BackGradientStyle = GradientStyle.TopBottom
            };
            area.Area3DStyle.Enable3D = true;
            area.Area3DStyle.LightStyle = LightStyle.Realistic;
            CustomizeChartArea(area);
            return area;
        }


        protected Chart _chart;
        public int NumberOfSeries { get; set; }
    }
}