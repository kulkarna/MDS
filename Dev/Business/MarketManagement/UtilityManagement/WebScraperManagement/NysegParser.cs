namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.IO;
    using HtmlAgilityPack;
    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.DataAccess.WebAccess.WebScraperManagement;
    using LibertyPower.Business.CommonBusiness.FieldHistory;
    using System.Data;
    using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
    using LibertyPower.DataAccess.SqlAccess.TransactionsSql;

    public class NysegParser
    {
        private static FieldHistoryManager.MapField _applyMapping = LibertyPower.Business.MarketManagement.UtilityManagement.UtilityMappingFactory.ApplyMapping;

        private readonly string ID_ACCOUNT_NUMBER = "lblPoD";
        private readonly string ID_CURRENT_RATE_CATEGORY = "EscoUsageHist1_repUsageHist__ctl1_lblCurrentSupply";
        private readonly string ID_FUTURE_RATE_CATEGORY = "EscoUsageHist1_repUsageHist__ctl1_lblFutureSupply";
        private readonly string ID_DISTRICT = "EscoUsageHist1_repUsageHist__ctl1_lblTaxDistrict2";
        private readonly string ID_GRID = "EscoUsageHist1_repUsageHist__ctl1_lblSubzone";
        private readonly string ID_ICAP = "EscoUsageHist1_repUsageHist__ctl1_lblIcap";
        private readonly string ID_PROFILE = "EscoUsageHist1_repUsageHist__ctl1_lblProfile";
        private readonly string ID_REVENUE_CLASS = "EscoUsageHist1_repUsageHist__ctl1_lblRevenueClass";
        private readonly string ID_BILLING_GROUP = "EscoUsageHist1_repUsageHist__ctl1_lblReadCycle";
        private readonly string ID_TAX_JURISDICTION = "EscoUsageHist1_repUsageHist__ctl1_lblTaxDistrict";
        private readonly string ID_USAGE_HISTORY = "EscoUsageHist1_repUsageHist__ctl1_datMeterHist";
        private readonly string ID_METER_NUMBER = "lblMeter";
        private readonly string ID_SERVICE_ADDRESS = "lblServiceAddress";
        private readonly string ID_MAILING_ADDRESS = "lblMailingAddress";

        private HtmlDocument htmlDocument;
        private string htmlContent;
        // ------------------------------------------------------------------------------------
        private void CalculateBillingPeriod(WebUsageList usageList)
        {
            for (int i = 0; i < usageList.Count; i++)
            {
                if (i + 1 < usageList.Count)
                    usageList[i].BeginDate = usageList[i + 1].EndDate.AddDays(1);		// SD24256
                else
                    usageList[i].BeginDate = usageList[i].EndDate.AddMonths(-1);

                usageList[i].Days = usageList[i].EndDate.Subtract(usageList[i].BeginDate).Days;
            }
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Returns the list of available columns per account
        /// </summary>
        /// <param name="tableHeader"></param>
        /// <returns></returns>
        private List<AvailableColumns> GetAvaliableInfo(HtmlNode tableHeader)
        {
            List<AvailableColumns> avaliableInfo = new List<AvailableColumns>();

            if (tableHeader.ChildNodes != null)
            {
                for (int i = 0; i < tableHeader.ChildNodes.Count; i++)
                {
                    HtmlNode column = tableHeader.ChildNodes[i];

                    if (column.NodeType != HtmlNodeType.Element)
                        continue;

                    avaliableInfo.Add(new AvailableColumns(i, column.InnerText.Trim()));
                }
            }

            return avaliableInfo;
        }

        // ------------------------------------------------------------------------------------
        private string GetCustomerName()
        {
            HtmlNode addressNode = htmlDocument.GetElementbyId(ID_SERVICE_ADDRESS);
            string name = string.Empty;

            try
            {
                name = addressNode.InnerHtml.ToUpper().Split(new string[] { "<BR>" }, StringSplitOptions.None)[1];
            }
            catch
            { }

            return name.Trim();
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// extract the actual data contained within the table cell
        /// </summary>
        /// <param name="info"></param>
        /// <param name="row"></param>
        /// <returns></returns>
        private string GetInformationValue(AvailableColumns info, HtmlNode row)
        {
            string value;

            value = row.ChildNodes[info.Index].InnerText.Replace("$", "");
            value = value.Replace("&nbsp;", "");

            // Condition added to convert negative decimal values
            if (value.IndexOf('(') != -1 && value.IndexOf(')') != -1)
            {
                value = value.Replace("(", "");
                value = value.Replace(")", "");
                value = "-" + value;
            }

            return value;
        }

        // ------------------------------------------------------------------------------------
        private GeographicalAddress GetMailingAddress()
        {
            HtmlNode mailingAddressNode = htmlDocument.GetElementbyId(ID_MAILING_ADDRESS);

            return ParseAddress(mailingAddressNode.InnerHtml);
        }

        // ------------------------------------------------------------------------------------
        private GeographicalAddress GetServiceAddress()
        {
            HtmlNode serviceAddressNode = htmlDocument.GetElementbyId(ID_SERVICE_ADDRESS);

            return ParseAddress(serviceAddressNode.InnerHtml);
        }

        // ------------------------------------------------------------------------------------
        private string GetMeterNumber()
        {
            return GetValue(ID_METER_NUMBER);
        }

        // ------------------------------------------------------------------------------------
        private WebUsageList GetUsageHistory()
        {
            HtmlNode usageTable = htmlDocument.GetElementbyId(ID_USAGE_HISTORY);
            WebUsageList usages = new WebUsageList();
            List<AvailableColumns> columns = null;
            HtmlNode currentRow = null;
            string meterNumber = GetMeterNumber();

            if (usageTable != null)
            {
                /*
                 * Looking for the avaliable usage information
                 * */
                currentRow = usageTable.FirstChild;

                while (currentRow != null && currentRow.NodeType != HtmlNodeType.Element)
                    currentRow = currentRow.NextSibling;

                if (currentRow != null)
                {
                    columns = GetAvaliableInfo(currentRow);

                    // move cursor to next row..
                    currentRow = currentRow.NextSibling;
                }

                while (currentRow != null && currentRow.Name == "tr")
                {
                    if (currentRow.NodeType != HtmlNodeType.Element)
                        continue;

                    WebUsage currentUsage;

                    currentUsage = HtmlRowToNysegUsage(currentRow, columns);
                    currentUsage.MeterNumber = meterNumber;

                    usages.Add(currentUsage);

                    currentRow = currentRow.NextSibling;
                }
            }

            CalculateBillingPeriod(usages);

            return usages;
        }

        // ------------------------------------------------------------------------------------
        private string GetValue(string elementId)
        {
            HtmlNode node = htmlDocument.GetElementbyId(elementId);

            try
            {
                return node.InnerText.Split(new char[] { ':' })[1].Trim();
            }
            catch
            { }

            return null;
        }

        // ------------------------------------------------------------------------------------
        private NysegUsage HtmlRowToNysegUsage(HtmlNode htmlRow, List<AvailableColumns> availableInfo)
        {
            NysegUsage usage = new NysegUsage();

            foreach (AvailableColumns column in availableInfo)
            {
                string value = GetInformationValue(column, htmlRow);

                switch (column.Name.ToLower())
                {
                    case "readdate":
                        usage.EndDate = Convert.ToDateTime(value);
                        break;

                    case "readtype":
                        usage.ReadType = value;
                        break;

                    case "kw":
                        usage.Kw = Convert.ToDecimal(value);
                        break;

                    case "kwh":
                        usage.Kwh = Convert.ToDecimal(value);
                        break;

                    case "kwh on":
                        usage.KwhOn = Convert.ToDecimal(value);
                        break;

                    case "kwh off":
                        usage.KwhOff = Convert.ToDecimal(value);
                        break;

                    case "kwh mid":
                        usage.KwhMid = Convert.ToDecimal(value);
                        break;

                    case "kw on":
                        usage.KwOn = Convert.ToDecimal(value);
                        break;

                    case "kw off":
                        usage.KwOff = Convert.ToDecimal(value);
                        break;

                    case "rkvah":
                        usage.Rkvah = Convert.ToDecimal(value);
                        break;

                    case "total":
                        usage.Total = Convert.ToDecimal(value);
                        break;

                    case "total tax":
                        usage.TotalTax = Convert.ToDecimal(value);
                        break;
                }
            }

            return usage;
        }

        // ------------------------------------------------------------------------------------
        public NysegParser(string htmlContent)
        {
            byte[] rawData;
            MemoryStream memory;

            rawData = Encoding.UTF8.GetBytes(htmlContent);
            memory = new MemoryStream(rawData);

            htmlDocument = new HtmlDocument();
            htmlDocument.Load(memory);
        }

        // ------------------------------------------------------------------------------------
        public Nyseg Parse()
        {
            Nyseg account = new Nyseg();

            account.AccountNumber = GetValue(ID_ACCOUNT_NUMBER);
            account.CustomerName = GetCustomerName();
            account.CurrentRateCategory = GetValue(ID_CURRENT_RATE_CATEGORY);
            account.FutureRateCategory = GetValue(ID_FUTURE_RATE_CATEGORY);
            account.RevenueClass = GetValue(ID_REVENUE_CLASS);
            account.LoadShapeId = GetValue(ID_PROFILE);
            account.Grid = GetValue(ID_GRID);
            account.BillGroup = GetValue(ID_BILLING_GROUP);
            string icap = GetValue(ID_ICAP);
            account.Icap = String.IsNullOrEmpty(icap) ? -1m : Convert.ToDecimal(icap);
            account.TaxJurisdiction = GetValue(ID_TAX_JURISDICTION);
            account.TaxDistrict = GetValue(ID_DISTRICT);
            account.Address = GetMailingAddress();
            account.ServiceAddress = GetServiceAddress();
            account.WebUsageList = GetUsageHistory();
            AcquireAndStoreDeterminantHistory(account);

            return account;

        }

        private void AcquireAndStoreDeterminantHistory(Nyseg account)
        {
            try
            {
                if (account.AccountNumber == null)
                    return;
                DataSet ds = OfferSql.AccountExistsInOfferEngine(account.AccountNumber, "NYSEG");
                if (ds.Tables[0].Rows[0]["Exists"].ToString() == "0" && !TransactionsSql.HasUsageTransaction(account.AccountNumber, "NYSEG"))
                    return;
                var aid = new AccountIdentifier("NYSEG", account.AccountNumber);
                var billGroup = account.BillGroup ?? string.Empty;

                FieldHistoryManager.FieldValueInsert(aid, TrackedField.Utility, "NYSEG", null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                if (account.Icap >= 0)
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.ICap, account.Icap.ToString(), null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.Grid, account.Grid.ToString(), null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                FieldHistoryManager.FieldValueInsert(aid, TrackedField.LoadProfile, account.LoadShapeId.ToString(), null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                //PBI-68806 -MTJ- Adding RateClass into APH table
                if (account.CurrentRateCategory != null)
                {
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.RateClass, account.CurrentRateCategory.ToString(), null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                }
                if (!string.IsNullOrWhiteSpace(billGroup) && Convert.ToInt16(billGroup) > -1)
                {
                    FieldHistoryManager.FieldValueInsert(aid, TrackedField.BillGroup, account.BillGroup, null, FieldUpdateSources.WebScraping, "", FieldLockStatus.Unknown, _applyMapping);
                }
            }
            catch { };
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Count occurrences of strings.
        /// </summary>
        public int CountStringOccurrences(string text, string pattern)
        {
            // Loop through all instances of the string 'text'.
            int count = 0;
            int i = 0;
            while ((i = text.IndexOf(pattern, i)) != -1)
            {
                i += pattern.Length;
                count++;
            }
            return count;
        }

        // ------------------------------------------------------------------------------------
        private GeographicalAddress ParseAddress(string htmlContent)
        {
            string[] address;
            UsGeographicalAddress newAddress = new UsGeographicalAddress();
            int number, i = 0;

            try
            {
                address = htmlContent.ToUpper().Split(new string[] { "<BR>" }, StringSplitOptions.None);
                number = CountStringOccurrences(address[3].Trim(), " ");

                newAddress.Street = address[2].Trim();

                if (number == 2)
                    newAddress.CityName = address[3].Split(new char[] { ' ' })[i++];
                else // city contains 2 words
                    newAddress.CityName = address[3].Split(new char[] { ' ' })[i++] + ' ' + address[3].Split(new char[] { ' ' })[i++];

                newAddress.StateCode = address[3].Split(new char[] { ' ' })[i++];
                newAddress.ZipCode = address[3].Split(new char[] { ' ' })[i];
            }
            catch
            { }

            return newAddress;
        }

    }
}
