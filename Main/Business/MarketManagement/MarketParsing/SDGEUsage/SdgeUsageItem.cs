namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;

    public class SdgeUsageItem
    {
        #region Constructors

        public SdgeUsageItem(string consEdDate,string daysUsed,string maxKw,string maxKwNC,string offKw, string offKwh, string onKw, string onKwh, string totalKwh)
        {
            this.consEdDate = consEdDate;
            this.daysUsed = daysUsed;
            this.maxKw = maxKw;
            this.maxKwNC = maxKwNC;
            this.offKw = offKw;
            this.offKwh = offKwh;
            this.onKw = onKw;
            this.onKwh = onKwh;
            this.totalKwh = totalKwh;
        }
        
        #endregion

        #region Fields

        private string consEdDate;
        private string daysUsed;
        private string maxKw;
        private string maxKwNC;
        private string offKw;
        private string offKwh;
        private string onKw;
        private string onKwh;
        private string totalKwh;
        private string excelSheet;
        private Int32 excelRow;


        #endregion Fields

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

        public string ConsEdDate
        {
            get { return consEdDate; }
            set { consEdDate = value; }
        }

        public string DaysUsed
        {
            get { return daysUsed; }
            set { daysUsed = value; }
        }

        public string MaxKw
        {
            get { return maxKw; }
            set { maxKw = value; }
        }

        public string MaxKwNC
        {
            get { return maxKwNC; }
            set { maxKwNC = value; }
        }

        public string OffKw
        {
            get { return offKw; }
            set { offKw = value; }
        }

        public string OffKwh
        {
            get { return offKwh; }
            set { offKwh = value; }
        }

        public string OnKw
        {
            get { return onKw; }
            set { onKw = value; }
        }

        public string OnKwh
        {
            get { return onKwh; }
            set { onKwh = value; }
        }

        public string TotalKwh
        {
            get { return totalKwh; }
            set { totalKwh = value; }
        }

        #endregion Properties
    }
}