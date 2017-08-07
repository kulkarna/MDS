namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Linq;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.IO;
   
    using HtmlAgilityPack;
    //Changes for Bill Group by Manoj 3/09/2015
    public class AmerenParser
    {
        private List<XElement> meterNumbersTables;
        private List<XElement> usageHistoryTables;
        private List<XElement> servicePointTables;
        private XElement accInfoTable;
        private XElement xmlDoc;

        public AmerenParser( string content )
        {
            xmlDoc = XElement.Parse( GetHtmlBodyAsXml( content ) );

            accInfoTable = FindAccountInformationTable( xmlDoc );
            meterNumbersTables = FindMeterNumbersTables( xmlDoc );
            servicePointTables = FindServicePointTables( xmlDoc );
            usageHistoryTables = FindUsageHistoryTables( xmlDoc );
        }

        public XElement GetCurrentServicePointTable( string currentMeterNumber )
        {
            XElement match = servicePointTables.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                         td.Attribute( "id" ).Value.Trim().ToLower().Equals( "meternumber(s)" ) &&
                                                                         td.Value.Trim().ToLower().Contains( currentMeterNumber.ToLower().Trim() )
                                                                         ).First().Parent.Parent;

            return match;
        }

        public WebAccountList Parse()
        {
            WebAccountList accountList = new WebAccountList();

			XElement currentServicePointTable;
			if( servicePointTables.Count != 0 )
				currentServicePointTable = servicePointTables[0];

            for( int i = 0; i < meterNumbersTables.Count; i++ )
            {
                //if( i > 0 && servicePointTables.Count == meterNumbersTables.Count )
                //    currentServicePointTable = servicePointTables[i];
                Ameren account = new Ameren();
                account.Meter = GetMeterNumber( meterNumbersTables[i] );
                currentServicePointTable = GetCurrentServicePointTable( account.Meter );
                // Get Account information
                account.CustomerName = GetCustomerName();
                account.BillGroup = GetBillGroup();
                account.OperatingCompany = GetOperatingCompany();
                // service point info
                account.ServicePoint = GetServicePoint( currentServicePointTable );
                account.DeliveryVoltage = GetDeliveryVoltage( currentServicePointTable );
                account.SupplyVoltage = GetSupplyVoltage( currentServicePointTable );
                account.MeterVoltage = GetMeterVoltage( currentServicePointTable );
                account.LoadShapeId = GetProfileClass( currentServicePointTable );
                account.CurrentSupplyGoupAndType = GetCurretSupplyGroupAndType( currentServicePointTable );
				account.FutureSupplyGroupAndType = GetFutureSupplyGroupAndType( currentServicePointTable );
                account.ServiceClass = GetCurrentDeliveryServiceClass( currentServicePointTable );
                account.EligibleSwitchDate = GetEligibleSwitchDate( currentServicePointTable );
                account.TransformationCharge = GetTransformationCharge( currentServicePointTable );
                account.EffectivePLC = GetEffectivePLC( currentServicePointTable );
                // Account history info
                account.WebUsageList = GetUsageHistory( usageHistoryTables[i] );

                

                accountList.Add( account );
            }

            return accountList;
        }

        private string GetMeterNumber( XElement meterNumberTable )
        {
            string value;
            value = meterNumberTable.Descendants( "span" ).First().Value.Trim();
            return value;
        }

        private List<XElement> FindServicePointTables( XElement xmlDoc )
        {
            List<XElement> servicePointTables = new List<XElement>();
            servicePointTables = xmlDoc.Descendants( "table" ).Where( table => table.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                     td.Attribute( "id" ).Value.ToLower().Trim().Equals( "servicepoint" ) ).Count() > 0 ).ToList();

            return servicePointTables;
        }

        private List<XElement> FindUsageHistoryTables( XElement xmlDoc )
        {

            List<XElement> usageTables = new List<XElement>();
            usageTables = xmlDoc.Descendants( "table" ).Where( table => table.Attributes( "id" ).Count() > 0 &&
                                                                    table.Attribute( "id" ).Value.ToLower().Trim().Equals( "usagetable" ) ).Skip( 1 ).ToList();
            return usageTables;
        }

        private List<XElement> FindMeterNumbersTables( XElement xmlDoc )
        {
            List<XElement> meterTables = new List<XElement>();
            meterTables = xmlDoc.Descendants( "div" ).Where( div => div.Attributes( "class" ).Count() > 0 &&
                                                                div.Attribute( "class" ).Value.ToLower().Trim().Equals( "divstandardspacingabove" ) &&
                                                                div.Value.ToLower().Trim().Replace( " ", "" ).Contains( "meternumber" ) ).ToList();
            return meterTables;
        }

        private XElement FindAccountInformationTable( XElement xmlDoc )
        {
            XElement accInfo = null;
            accInfo = xmlDoc.Descendants( "table" )
                                .Where( x => x.Attributes( "id" ).Count() > 0 &&
                                             x.Attribute( "id" ).Value.Equals( "AccountInfoTable" ) ).FirstOrDefault();
            return accInfo;
        }

        private string GetHtmlBodyAsXml( string htmlContent )
        {
            int startIndex = htmlContent.ToLower().IndexOf( "<body" );
            int endIndex = htmlContent.ToLower().IndexOf( "</body>" ) + "</body>".Length;
            string htmlBody = htmlContent.Substring( startIndex, endIndex - startIndex );

            htmlBody = RemoveComments( htmlBody );
            htmlBody = RemoveInvalidContent( htmlBody );
            htmlBody = HtmlToXml( htmlBody );

            return htmlBody;
        }

        private string RemoveComments( string htmlContent )
        {
            Regex commentExp = new Regex( "<!--(.*?)-->" );

            return commentExp.Replace( htmlContent, "" );
        }

        private string RemoveInvalidContent( string htmlContent )
        {
            htmlContent = htmlContent.Replace("-3px", "");
            return htmlContent.Replace( "<< Previous Page", "" ).Replace( "&nbsp;", " " );
        }

        private string HtmlToXml( string htmlContent )
        {
            HtmlDocument htmlDocument = new HtmlDocument();
            string content = string.Empty;

            using( StringWriter xmlWriter = new StringWriter() )
            {
                htmlDocument.LoadHtml( htmlContent );
                htmlDocument.OptionFixNestedTags = true;
                htmlDocument.OptionOutputAsXml = true;
                htmlDocument.Save( xmlWriter );					// xml formatted document (from <?xml.. to /body>)..

                content = xmlWriter.ToString();
            }

            return content;
        }

        private decimal GetEffectivePLC( XElement serviceInfoTable )
        {
            decimal effectivePLC = -1;
            try
            {
                string value = serviceInfoTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                     td.Attribute( "id" ).Value.Trim().ToLower().Equals( "effectiveplc" ) ).First().Value;

                if( !decimal.TryParse( value, out effectivePLC ) )
                    effectivePLC = -1;
            }
            catch
            {
            }

            return effectivePLC;
        }

        private string GetTransformationCharge( XElement serviceInfoTable )
        {
            string transformationCharge = string.Empty;
            try
            {
                transformationCharge = serviceInfoTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                     td.Attribute( "id" ).Value.Trim().ToLower().Equals( "transformationcharge" ) ).First().Value;

            }
            catch
            {
            }

            return transformationCharge;
        }

        private string GetCurrentDeliveryServiceClass( XElement serviceInfoTable )
        {
            string serviceClass = string.Empty;
            try
            {
                serviceClass = serviceInfoTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                         td.Attribute( "id" ).Value.Trim().ToLower().Equals( "currentdeliveryservicesclass" ) ).First().Value;

            }
            catch
            {
            }

            return serviceClass;
        }

        private DateTime GetEligibleSwitchDate( XElement serviceInfoTable )
        {
            DateTime eligibleDate = DateTime.MinValue;
            try
            {
                string value = serviceInfoTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                        td.Attribute( "id" ).Value.Trim().ToLower().Equals( "eligibleswitchdate" ) ).First().Value;
                if( !DateTime.TryParse( value, out eligibleDate ) )
                    eligibleDate = DateTime.MinValue;
            }
            catch
            {
            }

            return eligibleDate;
        }

        private string GetCustomerName()
        {
            string customerName = string.Empty;
            try
            {
                customerName = accInfoTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                        td.Attribute( "id" ).Value.Trim().ToLower().Equals( "accountname" ) ).First().Value;
            }
            catch
            {
            }
            return customerName;
        }

        private string GetBillGroup()
        {
            string billGroup = "-1";
            //string value = string.Empty;
            billGroup = accInfoTable.Descendants("td").Where(td => td.Attributes("id").Count() > 0 &&
                                                                   td.Attribute( "id" ).Value.Trim().ToLower().Equals( "billgroup" ) ).First().Value;

            //if( !int.TryParse( value, out billGroup ) )
               // billGroup = -1;
            return billGroup;
        }

        private string GetOperatingCompany()
        {
            string operatingCompany = string.Empty;
            try
            {
                operatingCompany = accInfoTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                 td.Attribute( "id" ).Value.Trim().ToLower().Equals( "operatingcompany" ) ).First().Value;

            }
            catch
            {
            }

            return operatingCompany;
        }

        private string GetServicePoint( XElement servicePointTable )
        {
            string servicePoint = string.Empty;

            try
            {
                servicePoint = servicePointTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                              td.Attribute( "id" ).Value.Trim().ToLower().Equals( "servicepoint" ) ).First().Value.Trim();
            }
            catch
            {
            }

            return servicePoint;
        }

        private string GetDeliveryVoltage( XElement servicePointTable )
        {
            string deliveryVoltage = string.Empty;
            try
            {
                deliveryVoltage = servicePointTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                             td.Attribute( "id" ).Value.Trim().ToLower().Equals( "deliveryvoltage" ) ).First().Value.Trim();
            }
            catch
            {
            }

            return deliveryVoltage;
        }

        private string GetSupplyVoltage( XElement servicePointTable )
        {
            string supplyVoltage = string.Empty;
            try
            {
                supplyVoltage = servicePointTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                            td.Attribute( "id" ).Value.Trim().ToLower().Equals( "supplyvoltage" ) ).First().Value.Trim();
            }
            catch
            {
            }

            return supplyVoltage;
        }

        private string GetMeterVoltage( XElement servicePointTable )
        {
            string meterVoltage = string.Empty;
            try
            {
                meterVoltage = servicePointTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                            td.Attribute( "id" ).Value.Trim().ToLower().Equals( "metervoltage" ) ).First().Value.Trim();
            }
            catch
            {
            }

            return meterVoltage;
        }

        private string GetProfileClass( XElement servicePointTable )
        {
            string profileClass = string.Empty;

            try
            {
                profileClass = servicePointTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                              td.Attribute( "id" ).Value.Trim().ToLower().Equals( "profileclass" ) ).First().Value.Trim();

            }
            catch
            {
            }

            return profileClass;
        }

        private string GetCurretSupplyGroupAndType( XElement servicePointTable )
        {
            string currentSupply = string.Empty;
            try
            {
                currentSupply = servicePointTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                              td.Attribute( "id" ).Value.Trim().ToLower().Equals( "currentsupplygroupandtype" ) ).First().Value.Trim();

            }
            catch
            {
            }

            return currentSupply;
        }

        private string GetFutureSupplyGroupAndType( XElement servicePointTable )
        {
            string futureSupply = string.Empty;

            try
            {
                futureSupply = servicePointTable.Descendants( "td" ).Where( td => td.Attributes( "id" ).Count() > 0 &&
                                                                             td.Attribute( "id" ).Value.Trim().ToLower().Equals( "futuresupplygroupandtype" ) ).First().Value.Trim();

            }
            catch
            {
            }

            return futureSupply;
        }

        private WebUsageList GetUsageHistory( XElement usageHistoryTable )
        {
            AmerenUsageHistoryParser usageParser = new AmerenUsageHistoryParser( usageHistoryTable );
            WebUsageList usageHistory = usageParser.Parse();

            return usageHistory;
        }

        public class AmerenUsageHistoryParser
        {
            private XElement usageHistoryTable;

            public AmerenUsageHistoryParser( XElement table )
            {
                usageHistoryTable = table;
            }

            public WebUsageList Parse()
            {
                WebUsageList usageHistory = new WebUsageList();
                // skip first header row
                var rows = usageHistoryTable.Descendants( "tr" ).Skip( 1 ).ToArray();

                for( int currentRowIndex = 0; currentRowIndex < rows.Length; currentRowIndex++ )
                {
                    XElement currentRow = rows[currentRowIndex];

                    AmerenUsage usage = new AmerenUsage()
                    {
                        BeginDate = GetBeginDate( currentRow ),
                        EndDate = GetEndDate( currentRow ),
                        Days = GetDays( currentRow ),
                        TotalKwh = GetTotalKwh( currentRow ),
                        OnPeakKwh = GetOnPeakKwh( currentRow ),
                        OffPeakKwh = GetOffPeakKwh( currentRow ),
                        OnPeakDemandKw = GetOnPeakDemandKw( currentRow ),
                        OffPeakDemandKw = GetOffPeakDemandKw( currentRow ),
                        PeakReactivePowerKvar = GetPeakReactivePowerKvar( currentRow )
                    };

                    usageHistory.Add( usage );
                }

                return usageHistory;
            }

            private int GetTotalKwh( XElement row )
            {
                decimal totalKwh = -1;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[2];
                    string value = column.Value;

                    if( !decimal.TryParse( value, out totalKwh ) )
                        totalKwh = -1;
                }
                catch
                {
                }

                return (int) totalKwh;
            }

            private int GetDays( XElement row )
            {
                int days = -1;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[1];
                    string value = column.Value;

                    if( !int.TryParse( value, out days ) )
                        days = -1;
                }
                catch
                {
                }

                return days;
            }

            private DateTime GetBeginDate( XElement row )
            {
                DateTime beginDate = DateTime.MinValue;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[0];
                    string value = column.Value.Split( new string[] { " to " }, StringSplitOptions.None )[0];

                    if( !DateTime.TryParse( value, out beginDate ) )
                        beginDate = DateTime.MinValue;
                }
                catch
                {
                }

                return beginDate;
            }

            private DateTime GetEndDate( XElement row )
            {
                DateTime endDate = DateTime.MinValue;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[0];
                    string value = column.Value.Split( new string[] { " to " }, StringSplitOptions.None )[1];

                    if( !DateTime.TryParse( value, out endDate ) )
                        endDate = DateTime.MinValue;
                }
                catch
                {
                }

                return endDate;
            }

            private decimal GetOnPeakKwh( XElement row )
            {
                decimal onPeakKwh = -1;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[3];
                    string value = column.Value.Trim();

                    if( !decimal.TryParse( value, out onPeakKwh ) )
                        onPeakKwh = -1;
                }
                catch
                {
                }

                return onPeakKwh;
            }

            private decimal GetOffPeakKwh( XElement row )
            {
                decimal offPeakKwh = -1;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[4];
                    string value = column.Value.Trim();

                    if( !decimal.TryParse( value, out offPeakKwh ) )
                        offPeakKwh = -1;
                }
                catch
                {
                }

                return offPeakKwh;
            }

            private decimal GetOnPeakDemandKw( XElement row )
            {
                decimal onPeakDemandKw = -1;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[5];
                    string value = column.Value.Trim();

                    if( !decimal.TryParse( value, out onPeakDemandKw ) )
                        onPeakDemandKw = -1;
                }
                catch
                {
                }

                return onPeakDemandKw;
            }

            private decimal GetOffPeakDemandKw( XElement row )
            {
                decimal offPeakDemandKw = -1;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[6];
                    string value = column.Value.Trim();

                    if( !decimal.TryParse( value, out offPeakDemandKw ) )
                        offPeakDemandKw = -1;
                }
                catch
                {
                }

                return offPeakDemandKw;
            }

            private decimal GetPeakReactivePowerKvar( XElement row )
            {
                decimal peakReactivePower = -1;

                try
                {
                    var column = row.Descendants( "td" ).ToArray()[7];
                    string value = column.Value.Trim();

                    if( !decimal.TryParse( value, out peakReactivePower ) )
                        peakReactivePower = -1;
                }
                catch
                {
                }

                return peakReactivePower;
            }
        }
    }
}
