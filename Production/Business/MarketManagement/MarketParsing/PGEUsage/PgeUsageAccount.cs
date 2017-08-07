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

    public class PgeUsageAccount
    {
        #region Fields

        private string accountNumber;
        private string currentRate;
        private string customerName;
        private string energy_service_provider;
        private string mailAddress;
        private string mailCity;
        private string mailPostal;
        private string mailState;
        private string mdma;
        private string meterNumber;
        private string meter_installer;
        private string meter_maintainer;
        private string meter_owner;
        private string serviceAddress;
        private string serviceCity;
        private string servicePostal;
        private string serviceState;
        private PgeUsageItemCollection usageItems;
        private string utility;
        private string voltage;
        private string excelSheet;
        private Int32 excelRow;
        private string lossFactorId;


        #endregion Fields

        #region Constructors

        public PgeUsageAccount(string utility, string accountNumber, string customerName,
            string serviceAddress, string serviceCity, string serviceState, string servicePostal,
            string mailAddress, string mailCity, string mailState, string mailPostal,
            string currentRate, string meterNumber, string voltage, string energy_service_provider, string mdma, string meter_installer, string meter_maintainer, string meter_owner)
        {
            this.utility = utility;
            this.accountNumber = accountNumber;
            this.customerName = customerName;
            this.serviceAddress = serviceAddress;
            this.serviceCity = serviceCity;
            this.serviceState = serviceState;
            this.servicePostal = servicePostal;
            this.mailAddress = mailAddress;
            this.mailCity = mailCity;
            this.mailPostal = mailPostal;
            this.mailState = mailState;
            this.currentRate = currentRate;
            this.meterNumber = meterNumber;
            this.voltage = voltage;
            this.energy_service_provider = energy_service_provider;
            this.mdma = mdma;
            this.meter_installer = meter_installer;
            this.meter_maintainer = meter_maintainer;
            this.meter_owner = meter_owner;
        }

        public PgeUsageAccount(string utility, string accountNumber, string customerName,
            string serviceAddress, string serviceCity, string serviceState, string servicePostal,
            string mailAddress, string mailCity, string mailState, string mailPostal,
            string currentRate, string meterNumber, string voltage, string energy_service_provider, string mdma, string meter_installer, string meter_maintainer, string meter_owner, PgeUsageItemCollection usageItems)
        {
            this.utility = utility;
            this.accountNumber = accountNumber;
            this.customerName = customerName;
            this.serviceAddress = serviceAddress;
            this.serviceCity = serviceCity;
            this.serviceState = serviceState;
            this.servicePostal = servicePostal;
            this.mailAddress = mailAddress;
            this.mailCity = mailCity;
            this.mailPostal = mailPostal;
            this.mailState = mailState;
            this.currentRate = currentRate;
            this.meterNumber = meterNumber;
            this.voltage = voltage;
            this.energy_service_provider = energy_service_provider;
            this.mdma = mdma;
            this.meter_installer = meter_installer;
            this.meter_maintainer = meter_maintainer;
            this.meter_owner = meter_owner;
            this.usageItems = usageItems;
        }

        public PgeUsageAccount(string utility, string accountNumber, string customerName, string serviceAddress, string serviceCity, string serviceState, string servicePostal, string mailAddress, string mailCity, string mailState, string mailPostal, string currentRate, string meterNumber, string voltage, string energy_service_provider, string mdma, string meter_installer, string meter_maintainer, string meter_owner, PgeUsageItemCollection usageItems, string lossFactorId)
        {
            // TODO: Complete member initialization
            this.utility = utility;
            this.accountNumber = accountNumber;
            this.customerName = customerName;
            this.serviceAddress = serviceAddress;
            this.serviceCity = serviceCity;
            this.serviceState = serviceState;
            this.servicePostal = servicePostal;
            this.mailAddress = mailAddress;
            this.mailCity = mailCity;
            this.mailState = mailState;
            this.mailPostal = mailPostal;
            this.currentRate = currentRate;
            this.meterNumber = meterNumber;
            this.voltage = voltage;
            this.energy_service_provider = energy_service_provider;
            this.mdma = mdma;
            this.meter_installer = meter_installer;
            this.meter_maintainer = meter_maintainer;
            this.meter_owner = meter_owner;
            this.usageItems = usageItems;
            this.lossFactorId = lossFactorId;
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

        public string AccountNumber
        {
            get { return accountNumber; }
        }

        public string CurrentRate
        {
            get { return currentRate; }
        }

        public string CustomerName
        {
            get { return customerName; }
        }

        public string Energy_service_provider
        {
            get { return energy_service_provider; }
        }

        public string MailAddress
        {
            get { return mailAddress; }
        }

        public string MailCity
        {
            get { return mailCity; }
        }

        public string MailPostal
        {
            get { return mailPostal; }
            set { mailPostal = value; }
        }

        public string MailState
        {
            get { return mailState; }
        }

        public string Mdma
        {
            get { return mdma; }
        }

        public string MeterNumber
        {
            get { return meterNumber; }
        }

        public string Meter_installer
        {
            get { return meter_installer; }
        }

        public string Meter_maintainer
        {
            get { return meter_maintainer; }
        }

        public string Meter_owner
        {
            get { return meter_owner; }
        }

        public string ServiceAddress
        {
            get { return serviceAddress; }
        }

        public string ServiceCity
        {
            get { return serviceCity; }
        }

        public string ServicePostal
        {
            get { return servicePostal; }
        }

        public string ServiceState
        {
            get { return serviceState; }
        }

        public PgeUsageItemCollection UsageItems
        {
            get { return usageItems; }
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

        public void AddUsageItem(PgeUsageItem item)
        {
            if (item != null)
            {
                if (usageItems == null)
                {
                    usageItems = new PgeUsageItemCollection();
                }
                usageItems.Add(item);
            }
        }

        #endregion Methods
    }
}