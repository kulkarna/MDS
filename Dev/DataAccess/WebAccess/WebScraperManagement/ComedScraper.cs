namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
    using System.Net;
    using System.IO;
    using System.Web;

    public static class ComedScraper
    {
        private static string RemoveInvalidContent(string htmlContent)
        {
            int currentIndex = 0;
            string validContent = string.Empty;

            //disregard the last 6 closing table tags
            for (int i = 0; i < 6; i++)
            {
                currentIndex = htmlContent.IndexOf("</table>", currentIndex);
                currentIndex += "</table>".Length;
            }
            validContent = htmlContent.Substring(0, currentIndex);

            //append closing tags for body and html`
            validContent += "</body></html>";

            //remove some special characters
            validContent = validContent.Replace("&nbsp;", "");
            validContent = validContent.Replace("\t", "");
            validContent = validContent.Replace("\r", "");
            validContent = validContent.Replace("\n", "");

            // remove additional chatter
            validContent = validContent.Replace("<thead>", "");
            validContent = validContent.Replace("</thead>", "");
            //validContent = validContent.Replace( "<tbody>", "" );
            //validContent = validContent.Replace( "</tbody>", "" );
            validContent = validContent.Replace(" class=\"noborder\"", "");
            validContent = validContent.Replace(" align=\"center\"", "");
            validContent = validContent.Replace(" class=\"basic blue\"", "");
            validContent = validContent.Replace(" id=\"ctl00_Head1\"", "");
            validContent = validContent.Replace(" onload=\"javascript:_spBodyOnLoadWrapper();\"", "");
            validContent = validContent.Replace("class=\"formFields\"\"", "");
            validContent = validContent.Replace("class=\"formFields\"", "");

            //some of the <meta> tags don't have a closing tags, which fails the XML parser, therefore
            //remove all the content from the <head> tag
            int startHeadIndex = validContent.IndexOf("<head>");
            int endHeadIndex = validContent.IndexOf("</head>");
            if (startHeadIndex > -1 && endHeadIndex > -1)
                validContent = validContent.Remove(startHeadIndex + "<head>".Length, endHeadIndex - (startHeadIndex + "<head>".Length));

            //the body tag also include some unecessary data
            //please note that the ending ">" needs to be added to the <body tag
            int startBodyIndex = validContent.IndexOf("<body");
            int endBodyIndex = startBodyIndex;
            //for (int i = 0; i < 1; i++)
            //{
            //    endBodyIndex = validContent.IndexOf("<table", endBodyIndex);
            //    endBodyIndex += "<table".Length;
            //}
            //if (startBodyIndex > -1 && endBodyIndex > -1)
            //{
            //    validContent = validContent.Remove(startBodyIndex + "<body".Length, endBodyIndex - (startBodyIndex + "<body".Length + "<table".Length));
            //    validContent = validContent.Insert(startBodyIndex + 5, ">");
            //}
            endBodyIndex = validContent.IndexOf("<div class=\" exc-vertical-space-md\">", endBodyIndex);
            validContent = validContent.Remove(startBodyIndex + "<body".Length, endBodyIndex - (startBodyIndex + "<body".Length + "<div class=\" exc-vertical-space-md\">".Length));
            validContent = validContent.Insert(startBodyIndex + 5, ">");

            //remove remaining 2 closing div tags that don't have any opening tags.
            int divIndex = validContent.IndexOf("</div></div>", startBodyIndex);
            if (divIndex > -1)
                validContent = validContent.Remove(divIndex, "</div></div>".Length);
            else
                divIndex = validContent.IndexOf("</div> </div>", startBodyIndex);

            if (divIndex > -1)
                validContent = validContent.Remove(divIndex, "</div> </div>".Length);
            else
                divIndex = validContent.IndexOf("</div>    </div>", startBodyIndex);

            if (divIndex > -1)
                validContent = validContent.Remove(divIndex, "</div>    </div>".Length);

            return validContent;
        }

        public static string GetUsageHtml(string accountNumber, string meterNumber)
        {
            CookieContainer cookies = new CookieContainer();
            string responseData = RequestHomePage(ref  cookies);

            string viewState = ExtractKey("__VIEWSTATE", responseData);
            string requestDigest = ExtractKey("__REQUESTDIGEST", responseData);
            string eventValidation = ExtractKey("__EVENTVALIDATION", responseData);

            //update the View Usage Data radion button
            //string eventTarget = "ctl00$ctl72$g_86daaf10_fb31_4f6d_adf3_d7c384f128a3$ctl00$RequestOption";
            //string eventTarget = "ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_RequestOption_0";
            //string eventTarget = "ctl00$SPWebPartManager1$g_1bb6dc86_55ab_4ea9_a4db_4747922a8202$ctl00$RequestOption";
            string eventTarget = "ctl00$ctl76$g_86daaf10_fb31_4f6d_adf3_d7c384f128a3$ctl00$RequestOption$0";

            responseData = RequestHomePageEvents(viewState, requestDigest, eventValidation, eventTarget, string.Empty, ref cookies);

            //update the keys
            viewState = ExtractKey("__VIEWSTATE", responseData);
            requestDigest = ExtractKey("__REQUESTDIGEST", responseData);
            eventValidation = ExtractKey("__EVENTVALIDATION", responseData);

            //Add the account number to the list
            eventTarget = "ctl00$ctl76$g_86daaf10_fb31_4f6d_adf3_d7c384f128a3$ctl00$Addbtn";
            //eventTarget = "ctl00_ctl73_g_86daaf10_fb31_4f6d_adf3_d7c384f128a3_ctl00_Addbtn";
            //   eventTarget = "ctl00$ctl72$g_86daaf10_fb31_4f6d_adf3_d7c384f128a3$ctl00$Addbtn"; = "ctl00_SPWebPartManager1_g_1bb6dc86_55ab_4ea9_a4db_4747922a8202_ctl00_Addbtn";
            //eventTarget = "ctl00$SPWebPartManager1$g_1bb6dc86_55ab_4ea9_a4db_4747922a8202$ctl00$Addbtn";
            // eventTarget = "ctl00_ctl72_g_86daaf10_fb31_4f6d_adf3_d7c384f128a3_ctl00_Addbtn";

            responseData = RequestHomePageEvents(viewState, requestDigest, eventValidation, eventTarget, accountNumber, ref cookies);

            if (responseData.Contains("Account number is not valid."))
                return "Account number is not valid.";
            if (responseData.Contains("Account has been blocked per customer request."))
                return "Account has been blocked per customer request.";

            //update the keys
            viewState = ExtractKey("__VIEWSTATE", responseData);
            requestDigest = ExtractKey("__REQUESTDIGEST", responseData);
            eventValidation = ExtractKey("__EVENTVALIDATION", responseData);

            //Send the request to view the usage

            // eventTarget = "ctl00$m$g_c35a2b17_4f08_4239_8771_715a3e14ad86$ctl00$ViewUsagebtn";
            // eventTarget = "ctl00_ctl72_g_86daaf10_fb31_4f6d_adf3_d7c384f128a3_ctl00_ViewUsagebtn";
            //responseData = RequestHomePageEvents( viewState, requestDigest, eventValidation, eventTarget, accountNumber, ref cookies );

            //Send the request to GET the usage report
            responseData = RequestBillHistoryPage(cookies);

            return RemoveInvalidContent(responseData);
        }

        private static string RequestHomePage(ref CookieContainer cookies)
        {
            HttpWebRequest webRequest = WebRequest.Create(ComedConfigurationValues.ValueOf.HomePage) as HttpWebRequest;

            webRequest.Method = "GET";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.CookieContainer = cookies;
            webRequest.Timeout = 300000;
            webRequest.KeepAlive = true;
            webRequest.AllowAutoRedirect = true;
            System.Net.ServicePointManager.SecurityProtocol = (SecurityProtocolType)192 | (SecurityProtocolType)768 | (SecurityProtocolType)3072;
            StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());
            string resp = responseReader.ReadToEnd();

            responseReader.Close();
            return resp;
        }

        /// <summary>
        /// Gets the responses from comed homepage depending on which button or radion button was clicked
        /// </summary>
        /// <param name="viewState">_VIEWSTATE to be passed from the previous request</param>
        /// <param name="requestDigest">_REQUESTDIGEST to be passed from the previous request</param>
        /// <param name="eventValidation">_EVENTVALIDATION to be passed from the previous request</param>
        /// <param name="eventTarget">_EVENTTARGET which specifies which button or radion button was clicked</param>
        /// <param name="accountNumber">Customer account number</param>
        /// <param name="cookies">The cookie container. Should be passed throughout the requests</param>
        /// <returns>response</returns>
        private static string RequestHomePageEvents(string viewState, string requestDigest, string eventValidation, string eventTarget, string accountNumber, ref CookieContainer cookies)
        {
            //create the request and set up its properties
            HttpWebRequest webRequest = WebRequest.Create(ComedConfigurationValues.ValueOf.HomePage) as HttpWebRequest;
            webRequest.Method = "POST";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.CookieContainer = cookies;
            webRequest.Timeout = 300000;
            webRequest.KeepAlive = true;
            webRequest.AllowAutoRedirect = true;

            //pass all the variables to the request
            StreamWriter requestWriter = new StreamWriter(webRequest.GetRequestStream());

            if (accountNumber == string.Empty)
                requestWriter.Write(ComedConfigurationValues.ValueOf.HomePageData2For(viewState, requestDigest, eventValidation, eventTarget));
            else
                requestWriter.Write(ComedConfigurationValues.ValueOf.HomePageData3For(viewState, requestDigest, eventValidation, eventTarget, accountNumber));

            requestWriter.Close();

            //get the response
            StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());
            string responseData = responseReader.ReadToEnd();
            responseReader.Close();

            return responseData;
        }

        private static string RequestBillHistoryPage(CookieContainer cookies)
        {
            HttpWebRequest webRequest = WebRequest.Create(ComedConfigurationValues.ValueOf.BillHistoryPage) as HttpWebRequest;

            webRequest.Method = "GET";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.CookieContainer = cookies;

            try
            {
                StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());

                string responseData = responseReader.ReadToEnd();

                responseReader.Close();

                return responseData;
            }
            catch
            {
                return string.Empty;
            }
        }

        private static string GetHtmlElementValue(string textboxID, string htmlContent)
        {
            string valueToken = "value=\"";

            int textboxIDPosition = htmlContent.IndexOf(textboxID);

            if (textboxIDPosition < 0)
                return null;

            int valueTokenPosition = htmlContent.IndexOf(valueToken, textboxIDPosition);
            int valueStartPosition = valueTokenPosition + valueToken.Length;
            int valueEndPosition = htmlContent.IndexOf("\"", valueStartPosition);

            string textboxData = htmlContent.Substring(valueStartPosition, valueEndPosition - valueStartPosition);

            return HttpUtility.UrlEncodeUnicode(textboxData);
        }

        private static string ExtractKey(string key, string htmlContent)
        {
            return GetHtmlElementValue(key, htmlContent);
        }
    }
}
