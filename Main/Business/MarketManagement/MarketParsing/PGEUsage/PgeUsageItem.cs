namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;

    public class PgeUsageItem
    {
        #region Fields

        private string daysRead;
        private string demand;
        private string off_peak_kwh;
        private string on_peak_kwh;
        private string part_peak_kwh;
        private string previousReadDate;
        private string readDate;
        private string usage;
        private string excelSheet;
        private Int32 excelRow;


        #endregion Fields

        #region Constructors

        internal PgeUsageItem(string readDate, string previousReadDate, string days, string usage, string demand, string off_peak_kwh, string  part_peak_kwh, string on_peak_kwh)
        {
            this.readDate = readDate;
            this.previousReadDate = previousReadDate;
            this.daysRead = days;
            this.usage = usage;
            this.demand = demand;
            this.off_peak_kwh = off_peak_kwh;
            this.part_peak_kwh = part_peak_kwh;
            this.on_peak_kwh = on_peak_kwh;

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

        public string DaysRead
        {
            get { return daysRead; }
        }

        public string Demand
        {
            get { return demand; }
        }

        public string Off_peak_kwh
        {
            get { return off_peak_kwh; }
        }

        public string On_peak_kwh
        {
            get { return on_peak_kwh; }
        }

        public string Part_peak_kwh
        {
            get { return part_peak_kwh; }
        }

        public string PreviousReadDate
        {
            get
            {
                return previousReadDate;
            }
        }

        public string ReadDate
        {
            get
            {
                return readDate;
            }
        }

        public string Usage
        {
            get { return usage; }
        }

        #endregion Properties
    }
}