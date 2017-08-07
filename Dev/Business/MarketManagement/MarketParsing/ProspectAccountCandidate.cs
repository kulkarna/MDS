namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.Business.CommonBusiness.FieldHistory;

    // Adds attribute ExcelRow to UtilityAccount to support Validation logic
    // in parsing from Excel
    [Serializable]
    public class ProspectAccountCandidate : UtilityAccount
    {
        #region Fields

        private BrokenRuleException brokenRuleException;
        private int excelRow;
        private bool includeInPricingRequest;
        private string sheetName;
        private ValidationResult validationResult;
        
        private decimal? futureIcap;
        private DateTime? futureIcapEffectiveDate;
        private decimal? futureTcap;
        private DateTime? futureTcapEffectiveDate;
        private FieldLockStatus lockMeterType = FieldLockStatus.Unknown;
        private FieldLockStatus lockVoltage = FieldLockStatus.Unknown;
        private FieldLockStatus lockCongestionZone = FieldLockStatus.Unknown;
        private FieldLockStatus lockIcap = FieldLockStatus.Unknown;
        private FieldLockStatus lockFutureIcap = FieldLockStatus.Unknown;
        private FieldLockStatus lockTcap = FieldLockStatus.Unknown;
        private FieldLockStatus lockFutureTcap = FieldLockStatus.Unknown;
        private FieldLockStatus lockLossFactor = FieldLockStatus.Unknown;
        private FieldLockStatus lockLoadShapeID = FieldLockStatus.Unknown;
        private FieldLockStatus lockRateClass = FieldLockStatus.Unknown;
        private FieldLockStatus lockTariffCode = FieldLockStatus.Unknown;
        private FieldLockStatus lockProfile = FieldLockStatus.Unknown;
        private FieldLockStatus lockGrid = FieldLockStatus.Unknown;
        private FieldLockStatus lockLBMPZone = FieldLockStatus.Unknown;
        private FieldLockStatus lockServiceClass = FieldLockStatus.Unknown;
        

        #endregion Fields

        #region Constructors
        internal ProspectAccountCandidate(PgeUsageAccount pgeUsageAccount)
            : base()
        {
            //assign account data
            this.AccountNumber = pgeUsageAccount.AccountNumber;
            this.CustomerName = pgeUsageAccount.CustomerName;
            this.ServiceAddress = UsGeographicalAddressFactory.CreateUsAddress(pgeUsageAccount.ServiceAddress, pgeUsageAccount.ServiceCity, pgeUsageAccount.ServiceState, pgeUsageAccount.ServicePostal);
            this.BillingAddress = UsGeographicalAddressFactory.CreateUsAddress(pgeUsageAccount.MailAddress, pgeUsageAccount.MailCity, pgeUsageAccount.MailState, pgeUsageAccount.MailPostal);
            this.RateClass = pgeUsageAccount.CurrentRate;
            this.Voltage = pgeUsageAccount.Voltage;
            this.UtilityCode = "PGE";
            this.RetailMarketCode = "CA";
            this.excelRow = pgeUsageAccount.ExcelRow;
            this.EnergyServiceProvider = pgeUsageAccount.Energy_service_provider;
            this.MeterReader = pgeUsageAccount.Mdma;
            this.MeterInstaller = pgeUsageAccount.Meter_installer;
            this.MeterMaintainer = pgeUsageAccount.Meter_maintainer;
            this.MeterOwner = pgeUsageAccount.Meter_owner;

            if (this.Meters == null)
                this.Meters = new MeterList();
            //MeterType.Idr
            this.Meters.Add(new Meter(pgeUsageAccount.MeterNumber, UtilityManagement.MeterType.Unknown));

            //assign usage items
            if (pgeUsageAccount.UsageItems != null) //Ticket 16453
            {
                foreach (PgeUsageItem item in pgeUsageAccount.UsageItems)
                {
                    try
                    {
                        DateTime start = DateTime.Now;
                        DateTime end = DateTime.Now;
                        bool chk1 = OfferEngineUploadsParserFactory.ParseDate(item.ReadDate, out end);
                        bool chk2 = OfferEngineUploadsParserFactory.ParseDate(item.PreviousReadDate, out start);
                        int days = -1;
                        if (OfferEngineUploadsParserFactory.IsNumber(item.DaysRead))
                        {
                            days = Convert.ToInt16(item.DaysRead);
                        }

                        if (chk1 == true && chk2 == true)
                        {
                            Usage usage = new Usage(pgeUsageAccount.AccountNumber, "PGE", UsageSource.User, UsageType.File, start, end);

                            usage.TotalKwh = OfferEngineUploadsParserFactory.ConvertToInt32(item.Usage);

                            if (OfferEngineUploadsParserFactory.IsNumber(item.Demand))
                                usage.BillingDemandKw = Convert.ToInt32(item.Demand);

                            if (OfferEngineUploadsParserFactory.IsNumber(item.On_peak_kwh))
                                usage.OnPeakKwh = (decimal?)Convert.ToDecimal(item.On_peak_kwh);

                            if (OfferEngineUploadsParserFactory.IsNumber(item.Off_peak_kwh))
                                usage.OffPeakKwh = (decimal?)Convert.ToDecimal(item.Off_peak_kwh);

                            if (OfferEngineUploadsParserFactory.IsNumber(item.Part_peak_kwh))
                                usage.IntermediateKwh = (decimal?)Convert.ToDecimal(item.Part_peak_kwh);

                            usage.Days = days;

							Usage existingUsage;
							// if usage for start date exists, add total kwh to existing usage
							if( this.Usages.TryGetValue( start, out existingUsage ) )
							{
								this.Usages[start].TotalKwh += usage.TotalKwh;
							}
							else // otherwise, add usage to dictionary
							{
								this.Usages.Add( start, usage );
							}
                        }
                    }
                    catch (Exception exception)
                    {
                        throw new MarketParsingException("Error creating ProspectAccountCandidate()", exception);
                    }
                }
            }
        }

        internal ProspectAccountCandidate(SdgeUsageAccount sdgeUsageAccount)
            : base()
        {
            //assign account data
            this.AccountNumber = sdgeUsageAccount.Acct;
            this.CustomerName = sdgeUsageAccount.CustomerName;
            try
            {
                this.ServiceAddress = UsGeographicalAddressFactory.CreateUsAddress(sdgeUsageAccount.Address, sdgeUsageAccount.CityStateZip);
            }
            catch { }
            this.RateClass = sdgeUsageAccount.Rate;

            if(sdgeUsageAccount.ServiceVoltage == null)
                 this.Voltage = "Primary";
            else if (sdgeUsageAccount.ServiceVoltage.Equals("P"))
                this.Voltage = "Primary";
            else if (sdgeUsageAccount.ServiceVoltage.Trim().Equals("S") || string.IsNullOrEmpty(sdgeUsageAccount.ServiceVoltage.Trim()))
                this.Voltage = "Secondary";
            else
                this.Voltage = sdgeUsageAccount.ServiceVoltage;

            this.UtilityCode = "SDGE";
            this.RetailMarketCode = "CA";
            this.MeterOwner = sdgeUsageAccount.MeterOwner;
            this.MeterReader = sdgeUsageAccount.MeterReader;
            this.MeterInstaller = sdgeUsageAccount.MeterInstaller;
            this.MeterMaintainer = sdgeUsageAccount.MeterMaintainer;

            if (sdgeUsageAccount.MeterOption == null)
                this.MeterOption = "NON-IDR";
            else if (sdgeUsageAccount.MeterOption.Trim() == "IDR")
                this.MeterOption = "IDR";
            else
                this.MeterOption = "NON-IDR";
            
            this.Cycle = sdgeUsageAccount.Cycle;
            this.excelRow = sdgeUsageAccount.ExcelRow;

            if (this.Meters == null)
                this.Meters = new MeterList();

			this.Meters.Add( new Meter( sdgeUsageAccount.Meter, MeterOption.Equals( "IDR" ) ? UtilityManagement.MeterType.Idr : UtilityManagement.MeterType.NonIdr ) );

            //assign usage items
            if (sdgeUsageAccount.UsageItems != null) //Ticket 16453
            {
                foreach (SdgeUsageItem item in sdgeUsageAccount.UsageItems)
                {
                    try
                    {
                        DateTime start = DateTime.Now;
                        DateTime end = DateTime.Now;
                        bool chk1 = OfferEngineUploadsParserFactory.ParseDate(item.ConsEdDate, out end);
                        bool chk2 = false;
                        int days = -1;
                        if (OfferEngineUploadsParserFactory.IsNumber(item.DaysUsed))
                        {
                            days = Convert.ToInt16(item.DaysUsed);
                            start = end - TimeSpan.FromDays(days);
                            start = start + TimeSpan.FromDays(1); //dates are inclusive...this makes values line up for days and the Days property
                            chk2 = true;
                        }

                        if (chk1 == true && chk2 == true)
                        {
                            Usage usage = new Usage(sdgeUsageAccount.Acct, "SDGE", UsageSource.User, UsageType.File, start, end);

                            usage.TotalKwh = OfferEngineUploadsParserFactory.ConvertToInt32(item.TotalKwh);

                            if (OfferEngineUploadsParserFactory.IsNumber(item.MaxKw))
                            {
                                usage.MonthlyPeakDemandKw = (decimal?)Convert.ToDecimal(item.MaxKw);
                            }

                            usage.Days = days;

                            if (OfferEngineUploadsParserFactory.IsNumber(item.OffKwh))
                                usage.OffPeakKwh = (decimal?)Convert.ToDecimal(item.OffKwh);

                            if (OfferEngineUploadsParserFactory.IsNumber(item.OnKw))
                                usage.OnPeakKwh = (decimal?)Convert.ToDecimal(item.OnKwh);

                            if (OfferEngineUploadsParserFactory.IsNumber(item.OnKw))
                                usage.MonthlyPeakDemandKw = (decimal?)Convert.ToDecimal(item.OnKw);

                            if (OfferEngineUploadsParserFactory.IsNumber(item.OffKw))
                                usage.MonthlyOffPeakDemandKw = (decimal?)Convert.ToDecimal(item.OffKw);

							Usage existingUsage;
							// if usage for start date exists, add total kwh to existing usage
							if( this.Usages.TryGetValue( start, out existingUsage ) )
							{
								this.Usages[start].TotalKwh += usage.TotalKwh;
							}
							else // otherwise, add usage to dictionary
							{
								this.Usages.Add( start, usage );
							}
                        }
                    }
                    catch (Exception exception)
                    {
                        throw new MarketParsingException("Error creating ProspectAccountCandidate()", exception);
                    }
                }
            }
        }

        internal ProspectAccountCandidate(SceUsageAccount sceUsageAccount)
            : base()
        {
            //assign account data
            this.AccountNumber = "3" + sceUsageAccount.ServiceAccountNumber.Replace("-", "");  //HOTFIX 2 on 5/11/2010 per Douglas
            this.CustomerName = sceUsageAccount.CustomerName;
            this.ServiceAddress = sceUsageAccount.MainAddress;
            this.BillingAddress = sceUsageAccount.BillingAddress;
            this.RateClass = sceUsageAccount.CurrentRate;
            this.Voltage = sceUsageAccount.Voltage;
            this.UtilityCode = "SCE";
            this.RetailMarketCode = "CA";
            this.excelRow = sceUsageAccount.ExcelRow;
            this.LossFactorID = sceUsageAccount.LossFactorId;

            if (this.Meters == null)
                this.Meters = new MeterList();

			this.Meters.Add( new Meter( sceUsageAccount.MeterNumber, UtilityManagement.MeterType.Idr ) );

            //assign usage items
            if (sceUsageAccount.UsageItems != null) //Ticket 16453
            {
                foreach (SceUsageItem item in sceUsageAccount.UsageItems)
                {
                    try
                    {
                        Usage usage = new Usage(sceUsageAccount.CustomerAccountNumber, "SCE", UsageSource.User, UsageType.File, item.StartDate, item.ReadDate);

                        usage.TotalKwh = Convert.ToInt32(item.TotalKWh);
                        usage.MonthlyPeakDemandKw = (decimal?)item.MaximumKw;
                        usage.Days = item.Days;

						Usage existingUsage;
						// if usage for start date exists, add total kwh to existing usage
						if( this.Usages.TryGetValue( item.StartDate, out existingUsage ) )
						{
							this.Usages[item.StartDate].TotalKwh += usage.TotalKwh;
						}
						else // otherwise, add usage to dictionary
						{
							this.Usages.Add( item.StartDate, usage );
						}
                    }
                    catch (Exception exception)
                    {
                        throw new MarketParsingException("Error creating ProspectAccountCandidate()", exception);
                    }
                }
            }
        }

        //used exclusively to instantiate objects already validated by parser and stored (at the PricingRequest layer)
        internal ProspectAccountCandidate(long id, string accountNumber, string utilityCode)
            : base(id, accountNumber, utilityCode)
        {
        }

        internal ProspectAccountCandidate(int excelRow)
        {
            this.excelRow = excelRow;
            this.validationResult = ValidationResult.Untested;
            this.includeInPricingRequest = false;
        }

        internal ProspectAccountCandidate(int excelRow, string sheetName)
        {
            this.excelRow = excelRow;
            this.sheetName = sheetName;
            this.validationResult = ValidationResult.Untested;
            this.includeInPricingRequest = false;
        }

        #endregion Constructors

        #region Properties

        /// <summary>
        /// Identifies the row from the excel file that this ProspectAccountCandidate was parsed from
        /// </summary>
        public int ExcelRow
        {
            get
            {
                return excelRow;
            }
        }
        // Added By Vikas Sharma . PBI -119136.
        public FieldLockStatus LockLossFactorID { get; set; }

        /// <summary>
        /// contains any BrokenRuleExceptions triggered in this ProspectAccountCandidate
        /// </summary>
        public new BrokenRuleException Exception
        {
            get
            {
                return brokenRuleException;
            }
        }

        /// <summary>
        /// Marks a ProspectAccount for inclusion in a pricing request; this will be consumed by the gui with a checklist control to select/unselect accounts from a given upload file
        /// </summary>
        public bool IncludeInPricingRequest
        {
            get { return includeInPricingRequest; }
            set { includeInPricingRequest = value; }
        }

        /// <summary>
        /// specifies the sheetname, if more than one exists, of the excel upload file this ProspectAccount was parsed from
        /// </summary>
        public string SheetName
        {
            get { return sheetName; }
        }

        public ValidationResult ValidationStatus
        {
            get
            {
                return validationResult;
            }
            set
            {
                if (validationResult == ValidationResult.Untested)
                    validationResult = value;
            }
        }

        public decimal? FutureIcap
        {
            get { return futureIcap; }
            set { futureIcap = value; }
        }

        public DateTime? FutureIcapEffectiveDate
        {
            get { return futureIcapEffectiveDate; }
            set { futureIcapEffectiveDate = value; }
        }

        public decimal? FutureTcap
        {
            get { return futureTcap; }
            set { futureTcap = value; }
        }

        public DateTime? FutureTcapEffectiveDate
        {
            get { return futureTcapEffectiveDate; }
            set { futureTcapEffectiveDate = value; }
        }

        public FieldLockStatus LockMeterType
        {
            get { return lockMeterType; }
            set { lockMeterType = value; }
        }
        public FieldLockStatus LockVoltage
        {
            get { return lockVoltage; }
            set { lockVoltage = value; }
        }
        public FieldLockStatus LockCongestionZone
        {
            get { return lockCongestionZone; }
            set { lockCongestionZone = value; }
        }
        public FieldLockStatus LockIcap
        {
            get { return lockIcap; }
            set { lockIcap = value; }
        }
        public FieldLockStatus LockFutureIcap
        {
            get { return lockFutureIcap; }
            set { lockFutureIcap = value; }
        }
        public FieldLockStatus LockTcap
        {
            get { return lockTcap; }
            set { lockTcap = value; }
        }
        public FieldLockStatus LockFutureTcap
        {
            get { return lockFutureTcap; }
            set { lockFutureTcap = value; }
        }
        public FieldLockStatus LockLossFactor
        {
            get { return lockLossFactor; }
            set { lockLossFactor = value; }
        }
        public FieldLockStatus LockLoadShapeId
        {
            get { return lockLoadShapeID; }
            set { lockLoadShapeID = value; }
        }
        public FieldLockStatus LockRateClass
        {
            get { return lockRateClass; }
            set { lockRateClass = value; }
        }
        public FieldLockStatus LockTariffCode
        {
            get { return lockTariffCode; }
            set { lockTariffCode = value; }
        }
        public FieldLockStatus LockProfile
        {
            get { return lockProfile; }
            set { lockProfile = value; }
        }
        public FieldLockStatus LockGrid
        {
            get { return lockGrid; }
            set { lockGrid = value; }
        }
        public FieldLockStatus LockLbmpZone
        {
            get { return lockLBMPZone; }
            set { lockLBMPZone = value; }
        }
        public FieldLockStatus LockServiceClass
        {
            get { return lockServiceClass; }
            set { lockServiceClass = value; }
        }

        #endregion Properties

        #region Methods

        internal void AddUsage(UsageCandidate usage)
        {
            base.Usages.Add(usage.EndDate, usage);
        }

        internal bool Validate(UtilityStandIn utility)
        {
            //Validate this ProspectAccountCandidate and mark validationResultAccordingly
            bool result = false;
            ValidateUtilityAccountRule validateUtilityAccountRule = new ValidateUtilityAccountRule(this, utility);
            if (validateUtilityAccountRule.Validate() != true)
            {
                this.brokenRuleException = (BrokenRuleException)validateUtilityAccountRule.Exception;
                validationResult = ValidationResult.Invalid;
                return false;
            }
            else
            {
                validationResult = ValidationResult.Valid;
                result = true;
            }

            return result;
        }

        internal bool Validate()
        {
            //Validate this ProspectAccountCandidate and mark validationResultAccordingly
            bool result = false;
            CustomAccountCandidateValidationRule validateUtilityAccountRule = new CustomAccountCandidateValidationRule(this);
            if (validateUtilityAccountRule.Validate() != true)
            {
                this.brokenRuleException = (BrokenRuleException)validateUtilityAccountRule.Exception;
                validationResult = ValidationResult.Invalid;
                return false;
            }
            else
            {
                validationResult = ValidationResult.Valid;
                result = true;
            }

            return result;
        }
        #endregion Methods
    }
}