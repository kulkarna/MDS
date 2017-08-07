namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using System.Text;
    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using HtmlAgilityPack;
    // Changes to Bill Group type by ManojTFS-63739 -3/09/15
    public class ComedParser
    {
        XElement xmlDocument;

        public ComedParser(string htmlContent)
        {
            try
            {
                HtmlDocument doc = new HtmlDocument();
                doc.LoadHtml(htmlContent);
                doc.OptionFixNestedTags = true;
                doc.OptionAutoCloseOnEnd = true;

                htmlContent = doc.DocumentNode.OuterHtml;
                htmlContent = htmlContent.Replace("</select>", "</option></select>");
                htmlContent = htmlContent.Replace("<br>", string.Empty);
                htmlContent = htmlContent.Replace(htmlContent.Substring(0, htmlContent.IndexOf("<html")), string.Empty);

                xmlDocument = XElement.Parse(htmlContent);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Comed Parse()
        {
            Comed account = new Comed();

            account.BillGroup = GetBillGroup();
            account.CapacityPLC = GetCapacityPLC();
            account.NetworkServicePLC = GetNetworkServicePLC();
            account.CondoException = GetCondoException();
            account.CurrentSupplyGroup = GetCurrentSupplyGroup();
            account.PendingSupplyGroup = GetPendingSupplyGroup();
            account.MinimumStayDate = GetMinimumStayDate();
            account.WebUsageList = GetUsageHistory();
            account.RateClass = GetRate();
            return account;
        }

        private string GetBillGroup()
        {
            try
            {
                string sBillGroup = string.Empty;

                //the billing group number is saved within a span tag with id end with meterNo: 
                //<span id=\"ctl00_m_g_03ae09ae_2d4b_4772_9ba8_19520b739c8c_ctl00_meterNo\">7</span>  
                var paragraph = (from p in xmlDocument.Descendants("span")
                                 where p.Attribute("id") != null && p.Attribute("id").Value.Contains("meterNo")
                                 select p.Value);

                if (paragraph != null && paragraph.ToList().Count > 0)
                    sBillGroup = paragraph.ToList()[0];

                return sBillGroup;
            }
            catch
            { }

            return "-1";
        }

        private DateTime GetMinimumStayDate()
        {
            try
            {
                // First column of the second table body
                // -------------------------------------
                XElement element = xmlDocument
                                        .Descendants("tbody")
                                        .ToArray()[2]
                                            .Descendants("tr")
                                            .First()
                                                .Descendants("td")
                                                .First();

                if (!string.IsNullOrEmpty(element.Value.Trim()))
                    return Convert.ToDateTime(element.Value);
            }
            catch
            { }

            return DateTime.MinValue;
        }

        private string GetCondoException()
        {
            try
            {
                // Second column of the second table body
                // --------------------------------------
                XElement element = xmlDocument
                                        .Descendants("tbody")
                                        .ToArray()[2]
                                            .Descendants("tr")
                                            .First()
                                                .Descendants("td")
                                                .ToArray()[1];

                return element.Value.Trim();
            }
            catch
            { }

            return string.Empty;
        }

        private Comed.SupplyGroup GetCurrentSupplyGroup()
        {
            try
            {
                // First and second columns from the third table
                // ---------------------------------------------
                XElement[] supplyGroupElements = xmlDocument
                                                    .Descendants("tbody")
                                                    .ToArray()[4]
                                                        .Descendants("tr")
                                                        .First()
                                                            .Descendants("td")
                                                            .ToArray();

                Comed.SupplyGroup current = new Comed.SupplyGroup();

                current.Name = supplyGroupElements[0].Value;

                if (!supplyGroupElements[1].Value.Trim().Equals("N/A"))
                    current.EffectiveStartDate = Convert.ToDateTime(supplyGroupElements[1].Value);

                return current;
            }
            catch
            { }

            return null;
        }

        private Comed.SupplyGroup GetPendingSupplyGroup()
        {
            try
            {
                // Third and fourth columns from the third table
                // ---------------------------------------------
                XElement[] supplyGroupElements = xmlDocument
                                                    .Descendants("tbody")
                                                    .ToArray()[4]
                                                        .Descendants("tr")
                                                        .First()
                                                            .Descendants("td")
                                                            .ToArray();

                Comed.SupplyGroup pending = new Comed.SupplyGroup();

                pending.Name = supplyGroupElements[2].Value;

                if (!supplyGroupElements[3].Value.Trim().Equals("N/A"))
                    pending.EffectiveStartDate = Convert.ToDateTime(supplyGroupElements[3].Value);

                return pending;
            }
            catch
            { }

            return null;
        }

        private List<Comed.ComedPLCMeter> GetCapacityPLC()
        {
            try
            {
                XElement[] PLCMeters = xmlDocument
                                            .Descendants("tbody")
                                            .ElementAt(0)
                                            .Descendants("tr")
                                            .ToArray();

                List<Comed.ComedPLCMeter> capacityPLCList = new List<Comed.ComedPLCMeter>();

                foreach (XElement element in PLCMeters)
                {
                    if (element.Descendants("th").Count() > 0)
                        break;
                    dynamic comedplcELE = XmlToComedPLCMeter(element);
                    if (comedplcELE != null)
                        capacityPLCList.Add(comedplcELE);
                }

                return capacityPLCList;
            }
            catch
            { }

            return new List<Comed.ComedPLCMeter>();
        }

        private List<Comed.ComedPLCMeter> GetNetworkServicePLC()
        {
            try
            {
                XElement[] PLCMeters = xmlDocument
                                            .Descendants("tbody")
                                            .ElementAt(1)
                                                .Descendants("tr")
                                                .ToArray();

                List<Comed.ComedPLCMeter> networkServicePLCList = new List<Comed.ComedPLCMeter>();

                for (int i = PLCMeters.Count() - 1; i > -1; i--)
                {
                    if (PLCMeters[i].Descendants("th").Count() > 0)
                        break;
                    dynamic xmlelenetworkPLCMeter = XmlToComedPLCMeter(PLCMeters[i]);
                    if (xmlelenetworkPLCMeter != null)
                        networkServicePLCList.Add(xmlelenetworkPLCMeter);
                }

                return networkServicePLCList;
            }
            catch
            { }

            return new List<Comed.ComedPLCMeter>();
        }

        private Comed.ComedPLCMeter XmlToComedPLCMeter(XElement element)
        {
            try
            {
                XElement[] columns = element.Descendants("td").ToArray();
                Comed.ComedPLCMeter comedPLCMeter = new Comed.ComedPLCMeter();

                comedPLCMeter.Value = Convert.ToDecimal(columns[0].Value);
                comedPLCMeter.StartDate = Convert.ToDateTime(columns[1].Value);
                comedPLCMeter.EndDate = Convert.ToDateTime(columns[2].Value);

                return comedPLCMeter;
            }
            catch
            { }

            return null;
        }

        private WebUsageList GetUsageHistory()
        {
            WebUsageList usageHistory = new WebUsageList();

            try
            {
                XElement[] usageRows = xmlDocument
                                            .Descendants("tbody")
                                            .ToArray()[5]
                                                .Descendants("tr")
                                                .ToArray();

                foreach (XElement row in usageRows)
                    usageHistory.Add(XmlToWebUsage(row));
            }
            catch
            { }

            return usageHistory;
        }

        private string GetRate()
        {
            string rate = "";

            try
            {
                XElement[] usageRows = xmlDocument
                                            .Descendants("tbody")
                                            .ToArray()[5]
                                                .Descendants("tr")
                                                .ToArray();
                XElement[] columns = usageRows[0].Descendants("td").ToArray();
                rate = columns[0].Value;
            }
            catch
            { }

            return rate;
        }

        private WebUsage XmlToWebUsage(XElement usageHistoryRow)
        {
            try
            {
                XElement[] columns = usageHistoryRow.Descendants("td").ToArray();

                ComedUsage usage = new ComedUsage()
                {
                    Rate = columns[0].Value,
                    EndDate = Convert.ToDateTime(columns[1].Value),
                    Days = Convert.ToInt32(columns[2].Value),
                    TotalKwh = Convert.ToInt32(columns[3].Value),
                    OnPeakKwh = Convert.ToDecimal(columns[4].Value),
                    OffPeakKwh = Convert.ToDecimal(columns[5].Value),
                    BillingDemandKw = Convert.ToDecimal(columns[6].Value),
                    MonthlyPeakDemandKw = Convert.ToDecimal(columns[7].Value)
                };

                usage.BeginDate = usage.EndDate.AddDays(-1 * usage.Days);

                return usage;
            }
            catch
            { }

            return new WebUsage();
        }
    }
}