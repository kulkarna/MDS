namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.Business.CommonBusiness.FileManager;

    public class SdgeUsageAccount
    {
        #region Constructors

        public SdgeUsageAccount( string accountName,string acct, string address, string cityStateZip, string customerName, string cycle, string meter, 
            string meterMaintainer, string meterOption, string meterOwner, string meterReader, string meterInstaller, string rate, string serviceVoltage, SdgeUsageItemCollection usageItems) 
        {
            this.accountName = accountName;
            this.acct = acct;
            this.address = address;
            this.cityStateZip = cityStateZip;
            this.customerName = customerName;
            this.cycle = cycle;
            this.meter = meter;
            this.rate = rate;
            this.serviceVoltage = serviceVoltage;
            this.meterInstaller = meterInstaller;
            this.meterMaintainer = meterMaintainer;
            this.meterOption = meterOption;
            this.meterOwner = meterOwner;
            this.meterReader = meterReader;
            this.usageItems = usageItems;
        }

        public SdgeUsageAccount(string accountName, string acct, string address, string cityStateZip, string customerName, string cycle, string meter, 
            string meterMaintainer, string meterOption, string meterOwner, string meterReader, string meterInstaller, string rate, string serviceVoltage)
        {
            this.accountName = accountName;
            this.acct = acct;
            this.address = address;
            this.cityStateZip = cityStateZip;
            this.customerName = customerName;
            this.cycle = cycle;
            this.meter = meter;
            this.rate = rate;
            this.serviceVoltage = serviceVoltage;
            this.meterInstaller = meterInstaller;
            this.meterMaintainer = meterMaintainer;
            this.meterOption = meterOption;
            this.meterOwner = meterOwner;
            this.meterReader = meterReader;
        }

        public SdgeUsageAccount(string accountName, string acct, string address, string cityStateZip, string customerName, string cycle, string meter, string meterMaintainer, string meterOption, string meterOwner, string meterReader, string meterInstaller, string rate, string serviceVoltage, string lossFactorId)
        {
            // TODO: Complete member initialization
            this.accountName = accountName;
            this.acct = acct;
            this.address = address;
            this.cityStateZip = cityStateZip;
            this.customerName = customerName;
            this.cycle = cycle;
            this.meter = meter;
            this.meterMaintainer = meterMaintainer;
            this.meterOption = meterOption;
            this.meterOwner = meterOwner;
            this.meterReader = meterReader;
            this.meterInstaller = meterInstaller;
            this.rate = rate;
            this.serviceVoltage = serviceVoltage;
            this.lossFactorId = lossFactorId;
        }

        #endregion

        #region Fields

        private string accountName;
        private string acct;
        private string address;
        private string cityStateZip;
        private string customerName;
        private string cycle;
        private string meter;
        private string meterMaintainer;
        private string meterOption;
        private string meterOwner;
        private string meterReader;
        private string meterInstaller;
        private string rate;
        private string serviceVoltage;
        private SdgeUsageItemCollection usageItems;
        
        private string  excelSheet;
        private Int32 excelRow;
        private string lossFactorId;


        #endregion Fields

        #region Properties

        public string ExcelSheet
        {
            get{ return excelSheet; }
            set{ excelSheet = value; }
        }

        public Int32 ExcelRow
        {
            get{ return excelRow; }
            set{ excelRow = value; }
        }

        public string AccountName
        {
            get { return accountName; }
            set { accountName = value; }
        }

        public string Acct
        {
            get { return acct; }
            set { acct = value; }
        }

        public string Address
        {
            get { return address; }
            set { address = value; }
        }

        public string CityStateZip
        {
            get { return cityStateZip; }
            set { cityStateZip = value; }
        }

        public string CustomerName
        {
            get { return customerName; }
            set { customerName = value; }
        }

        public string Cycle
        {
            get { return cycle; }
            set { cycle = value; }
        }

        public string Meter
        {
            get { return meter; }
            set { meter = value; }
        }

        public string MeterMaintainer
        {
            get { return meterMaintainer; }
            set { meterMaintainer = value; }
        }

        public string MeterInstaller
        {
            get { return meterInstaller; }
            set { meterInstaller = value; }
        }

        public string MeterOption
        {
            get { return meterOption; }
            set { meterOption = value; }
        }

        public string MeterOwner
        {
            get { return meterOwner; }
            set { meterOwner = value; }
        }

        public string MeterReader
        {
            get { return meterReader; }
            set { meterReader = value; }
        }

        public string Rate
        {
            get { return rate; }
            set { rate = value; }
        }

        public string ServiceVoltage
        {
            get { return serviceVoltage; }
            set { serviceVoltage = value; }
        }

        internal SdgeUsageItemCollection UsageItems
        {
            get { return usageItems; }
            set { usageItems = value; }
        }

        #endregion Properties

        #region Methods

        public void AddUsageItem(SdgeUsageItem item)
        {
            if (item != null)
            {
                if (usageItems == null)
                {
                    usageItems = new SdgeUsageItemCollection();
                }
                usageItems.Add(item);
            }
        }

        #endregion Methods
    }
}