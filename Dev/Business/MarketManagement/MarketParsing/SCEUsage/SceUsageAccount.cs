namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;

    public class SceUsageAccount
    {
        #region Fields

        private string currentRate;
        private string customerAccountNumber;
        private string customerAddress1A;
        private string customerAddress1B;
        private string customerAddress1C;
        private string customerAddress2A;
        private string customerAddress2B;
        private string customerAddress2C;
        private string customerName;
        private string lossfactorId;
        private string meterNumber;
        private string phase;
        private string serviceAccountNumber;
        private SceUsageItemCollection usageItems;

        private string excelSheet;
        private Int32 excelRow;

        public SceUsageItemCollection UsageItems
        {
            get { return usageItems; }
            set { usageItems = value; }
        }
        public string LossFactorId
        {
            get { return lossfactorId; }
            set { lossfactorId = value; }
        }
        private string utility;
        private string voltage;

        #endregion Fields

        #region Constructors

        public SceUsageAccount(string utility, string customerAccountNumber, string serviceAccountNumber, string customerName,
            string customerAddress1A, string customerAddress1B, string customerAddress1C,
            string customerAddress2A, string customerAddress2B, string customerAddress2C,
            string currentRate, string meterNumber, string phase, string voltage)
        {
            this.utility = utility;
            this.customerAccountNumber = customerAccountNumber;
            this.serviceAccountNumber = serviceAccountNumber;
            this.customerName = customerName;
            this.customerAddress1A = customerAddress1A;
            this.customerAddress1B = customerAddress1B;
            this.customerAddress1C = customerAddress1C;
            this.customerAddress2A = customerAddress2A;
            this.customerAddress2B = customerAddress2B;
            this.customerAddress2C = customerAddress2C;
            this.currentRate = currentRate;
            this.meterNumber = meterNumber;
            this.phase = phase;
            this.voltage = voltage;

        }
      

        public SceUsageAccount(string utility, string customerAccountNumber, string serviceAccountNumber, string customerName,
            string customerAddress1A, string customerAddress1B, string customerAddress1C,
            string customerAddress2A, string customerAddress2B, string customerAddress2C,
            string currentRate, string meterNumber, string phase, string voltage, SceUsageItemCollection usageItems)
        {
            this.utility = utility;
            this.customerAccountNumber = customerAccountNumber;
            this.serviceAccountNumber = serviceAccountNumber;
            this.customerName = customerName;
            this.customerAddress1A = customerAddress1A;
            this.customerAddress1B = customerAddress1B;
            this.customerAddress1C = customerAddress1C;
            this.customerAddress2A = customerAddress2A;
            this.customerAddress2B = customerAddress2B;
            this.customerAddress2C = customerAddress2C;
            this.currentRate = currentRate;
            this.meterNumber = meterNumber;
            this.phase = phase;
            this.voltage = voltage;
            this.usageItems = usageItems;
        }

        public SceUsageAccount(string utility, string customerAccountNumber, string serviceAccountNumber, string customerName, string customerAddress1A, string customerAddress1B, string customerAddress1C, string customerAddress2A, string customerAddress2B, string customerAddress2C, string currentRate, string meterNumber, string phase, string voltage, SceUsageItemCollection usageItems, string lossFactorId)
        {
            // TODO: Complete member initialization
            this.utility = utility;
            this.customerAccountNumber = customerAccountNumber;
            this.serviceAccountNumber = serviceAccountNumber;
            this.customerName = customerName;
            this.customerAddress1A = customerAddress1A;
            this.customerAddress1B = customerAddress1B;
            this.customerAddress1C = customerAddress1C;
            this.customerAddress2A = customerAddress2A;
            this.customerAddress2B = customerAddress2B;
            this.customerAddress2C = customerAddress2C;
            this.currentRate = currentRate;
            this.meterNumber = meterNumber;
            this.phase = phase;
            this.voltage = voltage;
            this.usageItems = usageItems;
            this.LossFactorId = lossFactorId;
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

        public UsGeographicalAddress BillingAddress
        {
            get 
            {
                try
                {
                    UsGeographicalAddress address = UsGeographicalAddressFactory.ParseCityStateZipCode(customerAddress2C);
                    address.Street = CustomerAddress2B;
                    return address;
                }
                catch { }
                return null;
            }
        }

        public UsGeographicalAddress MainAddress
        {
            get 
            {
                try
                {
                    UsGeographicalAddress address = UsGeographicalAddressFactory.ParseCityStateZipCode(customerAddress1C);
                    address.Street = CustomerAddress1B;
                    return address;
                }
                catch { }
                return null;
            }
        }

        public string CurrentRate
        {
            get { return currentRate; }
        }

        public string CustomerAccountNumber
        {
            get { return customerAccountNumber; }
        }

        public string CustomerAddress1A
        {
            get { return customerAddress1A; }
        }

        public string CustomerAddress1B
        {
            get { return customerAddress1B; }
        }

        public string CustomerAddress1C
        {
            get { return customerAddress1C; }
        }

        public string CustomerAddress2A
        {
            get { return customerAddress2A; }
        }

        public string CustomerAddress2B
        {
            get { return customerAddress2B; }
        }

        public string CustomerAddress2C
        {
            get { return customerAddress2C; }
        }

        public string CustomerName
        {
            get { return customerName; }
        }

        public string MeterNumber
        {
            get { return meterNumber; }
        }

        public string Phase
        {
            get { return phase; }
        }

        public string ServiceAccountNumber
        {
            get { return serviceAccountNumber; }
        }

        public string Utility
        {
            get { return utility; }
        }

        public string Voltage
        {
            get { return voltage; }
        }

        #endregion Properties

        #region Methods

        public void AddUsageItem(SceUsageItem item)
        {
            usageItems.Add(item);
        }

        #endregion Methods
    }
}