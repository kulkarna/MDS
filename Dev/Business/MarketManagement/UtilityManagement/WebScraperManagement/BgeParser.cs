using System.Data;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using System;
    using System.Linq;
    using System.Xml.Linq;
    //	using CommonBusiness.FieldHistory;
    using CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.FieldHistory;
    using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
    using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

    public class BgeParser
    {
        private static FieldHistoryManager.MapField _applyMapping = UtilityMappingFactory.ApplyMapping;

        private XElement xmlDocument;
        private XElement xmlAccount;

        public BgeParser(string xmlContent)
        {
            xmlDocument = XElement.Parse(xmlContent);
            xmlAccount = xmlDocument.Descendants("Account").First();
        }

        public Bge Parse()
        {
            Bge account = new Bge()
            {
                AccountNumber = GetAccountNumber(),
                CustomerName = GetCustomerName(),
                Address = GetAddress(),
                BillingAddress = GetBillingAddress(),
                CustomerSegment = GetCustomerSegment(),
                TariffCode = GetTariffCode(),
                CapPLC = GetICapPLC(),
                CapPlcEffectiveDate = GetICapffectiveDate(),
                CapPlcPrev = GetCapPlcPrev(),
                CapPlcPrevEffectiveDate = GetICapPrevEffectiveDate(),
                TransPLC = GetTCapPLC(),
                TransPlcEffectiveDate = GetTCapffectiveDate(),
                TransPlcPre = GetTCapPlcPrev(),
                TransPlcPrevEffectiveDate = GetTCapPrevEffectiveDate(),
                POLRType = GetPOLRType(),
                BillGroup = GetBillGroup(),
                SpecialBilling = GetSpecialBilling(),
                MultipleMeters = GetMultipleMeters(),
                WebUsageList = GetUsageHistory()
            };

            AcquireAndStoreDeterminantsHistory(account);

            return account;
        }

        private void AcquireAndStoreDeterminantsHistory(Bge account)
        {
            try
            {
                if (account.AccountNumber == null)
                    return;
                DataSet ds = OfferSql.AccountExistsInOfferEngine(account.AccountNumber, "BGE");

                if (ds.Tables[0].Rows[0]["Exists"].ToString() == "0" && !TransactionsSql.HasUsageTransaction(account.AccountNumber, "BGE"))
                    return;

                var CapPlcPrev = GetCapPlcPrev();
                var CapPlcEffectiveDate = GetCapPLCEffectiveDate();
                var CapPlcPrevEffectiveDate = GetCapPLCPrevEffectiveDate();
                var TransPlcEffectiveDate = GetTransPLCEffectiveDate();
                var TransPlcPrev = GetTransPLCPrev();
                var TransPlcPrevEffectiveDate = GetTransPLCPrevEffectiveDate();
                var aid = new AccountIdentifier("BGE", account.AccountNumber);
                var billGroup = account.BillGroup ?? string.Empty;

                if (!string.IsNullOrWhiteSpace(billGroup) && Convert.ToInt16(billGroup) > -1)
                {
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.BillGroup, billGroup, null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                }
                //if (CapPlcPrevEffectiveDate < CapPlcEffectiveDate - TimeSpan.FromDays(1))
                //{
                if ((CapPlcPrev >= 0) && (CapPlcPrevEffectiveDate != DateTime.MinValue))
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, CapPlcPrev.ToString(), CapPlcPrevEffectiveDate, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                //}

                if ((account.CapPLC >= 0) && (CapPlcEffectiveDate != DateTime.MinValue))
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, account.CapPLC.ToString(), CapPlcEffectiveDate, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);

                //if( TransPlcPrevEffectiveDate < TransPlcEffectiveDate - TimeSpan.FromDays( 1 ) )
                //{
                if ((TransPlcPrev >= 0) && (TransPlcPrevEffectiveDate != DateTime.MinValue))
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.TCap, TransPlcPrev.ToString(), TransPlcPrevEffectiveDate, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                //}

                if ((account.TransPLC >= 0) && (TransPlcEffectiveDate != DateTime.MinValue))
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.TCap, account.TransPLC.ToString(), TransPlcEffectiveDate, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);

                FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadProfile, account.CustomerSegment ?? "", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.TariffCode, account.TariffCode.ToString(), null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);                
            }
            catch
            {
            }
        }

        /*private decimal GetMostRecentICap()
        {
            decimal val;
            var CapPlcEffectiveDate = GetICapffectiveDate();
            var CapPlcPrevEffectiveDate = GetICapPrevEffectiveDate();

            int dif = Math.Abs( (CapPlcEffectiveDate - DateTime.Now).Days );
            int dif2 = Math.Abs( (DateTime.Now - CapPlcPrevEffectiveDate).Days );

            if (dif < dif2)
                val = GetCapPLC();
            else
                val = GetCapPLCPrev();

            return val;
        }

        private decimal GetMostRecentTCap()
        {
            decimal val;
            var TransPLCEffectiveDate = GetTCapffectiveDate();
            var TransPLCPrevEffectiveDate = GetTCapPrevEffectiveDate();

            int dif = Math.Abs( (TransPLCEffectiveDate - DateTime.Now).Days );
            int dif2 = Math.Abs( (DateTime.Now - TransPLCPrevEffectiveDate).Days );

            if( dif < dif2 )
                val = GetTCapPLC();
            else
                val = GetTCapPLCPrev();

            return val;
        }
        */

        private WebUsageList GetUsageHistory()
        {
            XElement[] usageHistoryData = xmlAccount.Descendants("DataDetail").ToArray();
            WebUsageList usageHistory = new WebUsageList();
            string meterNumber = GetMeterNumber();
            string meterType = GetMeterType();

            foreach (XElement row in usageHistoryData)
            {
                BgeUsage usage = (BgeUsage)XmlToUsage(row);

                usage.MeterNumber = meterNumber;
                usage.MeterType = meterType;

                usageHistory.Add(usage);
            }

            return usageHistory;
        }

        private string GetUsageElementValue(XElement usageElement, string elementName, Type valueType)
        {
            string value = usageElement.Descendants(elementName).First().Value.Trim();

            if (elementName != "FromDate" && elementName != "ToDate")
                value = value.Replace("-", "");

            if (value == string.Empty && valueType != typeof(string))
            {
                if (valueType == typeof(DateTime))
                {
                    value = DateTime.MinValue.ToString();
                }
                else if (valueType == typeof(int) || valueType == typeof(decimal))
                {
                    value = "-1";
                }
            }

            return value;
        }

        private WebUsage XmlToUsage(XElement usageRow)
        {
            BgeUsage usage = new BgeUsage();

            try
            {
                usage.BeginDate = DateTime.Parse(GetUsageElementValue(usageRow, "FromDate", typeof(DateTime)));
                usage.EndDate = DateTime.Parse(GetUsageElementValue(usageRow, "ToDate", typeof(DateTime)));
                usage.Days = int.Parse(GetUsageElementValue(usageRow, "DaysUsed", typeof(int)));
                usage.ReadingSource = GetUsageElementValue(usageRow, "ReadingSource", typeof(string));
                usage.TotalKwh = int.Parse(GetUsageElementValue(usageRow, "Total_kWh", typeof(int)));
                usage.OnPeakKwh = decimal.Parse(GetUsageElementValue(usageRow, "Peak_kWh", typeof(decimal)));
                usage.OffPeakKwh = decimal.Parse(GetUsageElementValue(usageRow, "OffPeak_kWh", typeof(decimal)));
                usage.IntermediatePeakKwh = decimal.Parse(GetUsageElementValue(usageRow, "Inter_kWh", typeof(decimal)));
                usage.SeasonalCrossover = GetUsageElementValue(usageRow, "Crossover", typeof(string));
                usage.DeliveryDemandKw = decimal.Parse(GetUsageElementValue(usageRow, "Del_Dem_kW_kVA", typeof(decimal)));
                usage.GenTransDemandKw = decimal.Parse(GetUsageElementValue(usageRow, "Gen_Trans_Dem_kW", typeof(decimal)));
                usage.UsageFactorNonTOU = decimal.Parse(GetUsageElementValue(usageRow, "UsageFactor_Non_TOU", typeof(decimal)));
                usage.UsageFactorOnPeak = decimal.Parse(GetUsageElementValue(usageRow, "Peak_UsageFactor", typeof(decimal)));
                usage.UsageFactorOffPeak = decimal.Parse(GetUsageElementValue(usageRow, "OffPeak_UsageFactor", typeof(decimal)));
                usage.UsageFactorIntermediate = decimal.Parse(GetUsageElementValue(usageRow, "Inter_UsageFactor", typeof(decimal)));
            }
            catch
            {
            }

            return usage;
        }

        private string GetAccountAttributeValue(string attributeName)
        {
            string value = xmlAccount.Attribute(attributeName).Value.Trim();

            if (value == "-")
                value = string.Empty;

            return value
                    .Replace("&lt;BR&gt;", "")
                    .Replace("<BR>", "");
        }

        private string GetAccountNumber()
        {
            try
            {
                return GetAccountAttributeValue("AccountNumber");
            }
            catch
            {
            }

            return string.Empty;
        }

        private string GetMeterNumber()
        {
            try
            {
                return GetAccountAttributeValue("MeterEquipNo");
            }
            catch
            {
            }

            return string.Empty;
        }

        private string GetMeterType()
        {
            try
            {
                return GetAccountAttributeValue("CdMptType");
            }
            catch
            {
            }

            return string.Empty;
        }

        private string GetCustomerName()
        {
            try
            {
                return GetAccountAttributeValue("AccountName");
            }
            catch
            {
            }

            return string.Empty;
        }

        private GeographicalAddress ParseAddress(string addressContent)
        {
            UsGeographicalAddress address = new UsGeographicalAddress();
            string[] addressValue;

            addressValue = addressContent
                                .Split(new string[] { " " }, StringSplitOptions.RemoveEmptyEntries);

            int i = 0;

            while (i < addressValue.Length - 3)
            {
                address.Street += addressValue[i] + " ";

                i++;
            }

            address.CityName = addressValue[addressValue.Length - 3];
            address.StateCode = addressValue[addressValue.Length - 2];
            address.ZipCode = addressValue[addressValue.Length - 1];

            return address;
        }

        private GeographicalAddress GetAddress()
        {
            GeographicalAddress address = new UsGeographicalAddress();

            try
            {
                string addressContent = GetAccountAttributeValue("AccountAddress");

                address = ParseAddress(addressContent);
            }
            catch
            {
            }

            return address;
        }

        private GeographicalAddress GetBillingAddress()
        {
            GeographicalAddress address = new UsGeographicalAddress();

            try
            {
                string addressContent = GetAccountAttributeValue("BillingAddress");

                address = ParseAddress(addressContent);
            }
            catch
            {
            }

            return address;
        }

        private string GetCustomerSegment()
        {
            try
            {
                return GetAccountAttributeValue("Segment");
            }
            catch
            {
            }

            return string.Empty;
        }

        private int GetTariffCode()
        {
            try
            {
                return int.Parse(GetAccountAttributeValue("TariffCode"));
            }
            catch
            {
            }

            return -1;
        }

        private decimal GetTCapPLC()
        {
            try
            {
                return decimal.Parse(GetAccountAttributeValue("TransPLC"));
            }
            catch
            {
            }

            return -1;
        }

        private decimal GetICapPLC()
        {
            try
            {
                return decimal.Parse(GetAccountAttributeValue("CapPLC"));
            }
            catch
            {
            }

            return -1;
        }

        private decimal GetTCapPlcPrev()
        {
            try
            {
                return decimal.Parse(GetAccountAttributeValue("TransPLCPrev"));
            }
            catch
            {
            }

            return -1;
        }

        private decimal GetCapPlcPrev()
        {
            try
            {
                return decimal.Parse(GetAccountAttributeValue("CapPLCPrev"));
            }
            catch
            {
            }

            return -1;
        }

        private DateTime GetICapffectiveDate()
        {
            var effectiveDate = DateTime.Now;
            try
            {
                DateTime.TryParse(GetAccountAttributeValue("CapPLCEffectiveDt"), out effectiveDate);
            }
            catch
            {
            }

            return effectiveDate;
        }

        private DateTime GetTCapffectiveDate()
        {
            var effectiveDate = DateTime.Now;
            try
            {
                DateTime.TryParse(GetAccountAttributeValue("TransPLCEffectiveDt"), out effectiveDate);
            }
            catch
            {
            }

            return effectiveDate;
        }

        private DateTime GetCapPLCEffectiveDate()
        {
            var effectiveDate = DateTime.Now;
            try
            {

                DateTime.TryParse(GetAccountAttributeValue("CapPLCEffectiveDt"), out effectiveDate);

                //if (effectiveDate < DateTime.Now)
                //    effectiveDate = DateTime.Now;
            }
            catch
            {
            }

            return effectiveDate;
        }

        private DateTime GetTCapPrevEffectiveDate()
        {
            DateTime effectiveDate;
            try
            {
                DateTime.TryParse(GetAccountAttributeValue("TransPLCPrevEffectiveDt"), out effectiveDate);
            }
            catch
            {
                effectiveDate = DateTime.MinValue;
            }

            return effectiveDate;
        }

        private DateTime GetICapPrevEffectiveDate()
        {
            DateTime effectiveDate;
            try
            {
                DateTime.TryParse(GetAccountAttributeValue("CapPLCPrevEffectiveDt"), out effectiveDate);
            }
            catch
            {
                effectiveDate = DateTime.MinValue;
            }

            return effectiveDate;
        }

        private DateTime GetCapPLCPrevEffectiveDate()
        {
            var effectiveDate = DateTime.Now;
            try
            {
                DateTime.TryParse(GetAccountAttributeValue("CapPLCPrevEffectiveDt"), out effectiveDate);

                //if (effectiveDate < DateTime.Now)
                //    effectiveDate = DateTime.Now;
            }
            catch
            {
            }

            return effectiveDate;
        }

        private decimal GetTransPLCPrev()
        {
            try
            {
                return decimal.Parse(GetAccountAttributeValue("TransPLCPrev"));
            }
            catch
            {
            }

            return -1;
        }

        private DateTime GetTransPLCEffectiveDate()
        {
            var effectiveDate = DateTime.Now;
            try
            {
                DateTime.TryParse(GetAccountAttributeValue("TransPLCEffectiveDt"), out effectiveDate);
                //if (effectiveDate < DateTime.Now)
                //    effectiveDate = DateTime.Now;
            }
            catch
            {
            }

            return effectiveDate;
        }

        private DateTime GetTransPLCPrevEffectiveDate()
        {
            var effectiveDate = DateTime.Now;
            try
            {
                DateTime.TryParse(GetAccountAttributeValue("TransPLCPrevEffectiveDt"), out effectiveDate);
                //if (effectiveDate < DateTime.Now)
                //    effectiveDate = DateTime.Now;
            }
            catch
            {
            }

            return effectiveDate;
        }

        private string GetPOLRType()
        {
            try
            {
                return GetAccountAttributeValue("POLRType");
            }
            catch
            {
            }

            return string.Empty;
        }

        private string GetBillGroup()
        {
            try
            {
                return GetAccountAttributeValue("BillGroup");
            }
            catch
            {
            }

            return "-1";
        }

        private string GetSpecialBilling()
        {
            try
            {
                return GetAccountAttributeValue("SpecialBilling");
            }
            catch
            {
            }

            return string.Empty;
        }

        private string GetMultipleMeters()
        {
            try
            {
                return GetAccountAttributeValue("MultiMeterInd");
            }
            catch
            {
            }

            return string.Empty;
        }
    }
}
