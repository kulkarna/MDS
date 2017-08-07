namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    public class SceUsageItem
    {
        #region Fields

        private Int16 days;
        private decimal maximumKw;
        private DateTime readDate;
        private decimal totalKWh;
        private string excelSheet;
        private Int32 excelRow;

        #endregion Fields

        #region Constructors

        internal SceUsageItem(DateTime readDate, Int16 days, decimal totalKWh, decimal maximumKw)
        {
            this.readDate = readDate;
            this.days = days;
            this.totalKWh = totalKWh;
            this.maximumKw = maximumKw;
        }

        #endregion Constructors

        #region Properties

        public string ExcelSheet
        {
            get { return excelSheet; }
            set { excelSheet = value; }
        }

        public Int32 ExcelRow
        {
            get { return excelRow; }
            set { excelRow = value; }
        }

        public Int16 Days
        {
            get { return days; }
        }

        public decimal MaximumKw
        {
            get { return maximumKw; }
        }

        public DateTime ReadDate
        {
            get
            {
                return readDate;
            }
        }

        public DateTime StartDate
        {
            get
            {
                return readDate - TimeSpan.FromDays(days - 1);
            }
        }

        public decimal TotalKWh
        {
            get { return totalKWh; }
        }

        #endregion Properties
    }
}