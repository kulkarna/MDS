namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
    using System.Net;
    using System.IO;

    public static class AmerenScraper
    {
        public static string GetUsageHtml(string accountNumber)
        {

            //***************************
            var cookies = new CookieContainer();
            RequestLoginPage(cookies);
            string viewState;
            string eventValidation;
            int maxRetryCount = 10;
            int retryCount = 0;
            do
            {

                System.Threading.Thread.Sleep(1000);
                string response = RequestSummaryDataPage(accountNumber, cookies);
                HtmlElementValueSelector elementSelector = new HtmlElementValueSelector(response);
                viewState = elementSelector.SelectViewStateValue();
                eventValidation = elementSelector.SelectEventValidationValue();

                viewState = viewState.Replace("/", "%2f").Replace("=", "%3d").Replace("+", "%2b").Replace("$", "%24");
                eventValidation = eventValidation.Replace("/", "%2f").Replace("=", "%3d").Replace("+", "%2b").Replace("$", "%24");
                retryCount++;
            } while (string.IsNullOrEmpty(viewState) && retryCount <= maxRetryCount);

            //Debug.WriteLine(string.Format("Total Retries : {0}", retryCount - 1), "TestResults");
            //Debug.Flush();
            return RequestSummaryDataPage(accountNumber, viewState, eventValidation, cookies);
            //***************************


        }

        private static void RequestStartPage(CookieContainer cookies)
        {
            HttpWebRequest webRequest = WebRequest.Create(AmerenConfigurationValues.ValueOf.HomePage) as HttpWebRequest;
            StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());
            string responseData = responseReader.ReadToEnd();
            responseReader.Close();
        }

        private static void RequestLoginPage(CookieContainer cookies)
        {
            var webRequest = WebRequest.Create(AmerenConfigurationValues.ValueOf.LoginPage) as HttpWebRequest;

            if (webRequest == null)
                return;

            webRequest.Method = "POST";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.CookieContainer = cookies;
            webRequest.Timeout = 300000;
            //			webRequest.Referer = "https://login1.ameren.com/nidp/app/login?id=ecustAuth&sid=0&option=credential&sid=0";

            var requestWriter = new StreamWriter(webRequest.GetRequestStream());
            requestWriter.Write(AmerenConfigurationValues.ValueOf.LoginPageData);
            requestWriter.Close();
            webRequest.GetResponse().Close();
        }

        private static string RequestSummaryDataPage(string accountNumber, CookieContainer cookies)
        {
            HttpWebRequest webRequest = WebRequest.Create(AmerenConfigurationValues.ValueOf.HomePage) as HttpWebRequest;
            webRequest.Method = "POST";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.CookieContainer = cookies;
            webRequest.Timeout = 300000;

            StreamWriter requestWriter = new StreamWriter(webRequest.GetRequestStream());

            requestWriter.Write(AmerenConfigurationValues.ValueOf.SummaryPageDataFor(accountNumber));
            requestWriter.Close();

            StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());
            string responseData = responseReader.ReadToEnd();
            responseReader.Close();

            return responseData;
        }

        private static string RequestSummaryDataPage(string accountNumber, string viewState, string eventValidation, CookieContainer cookies)
        {
            HttpWebRequest webRequest = WebRequest.Create(AmerenConfigurationValues.ValueOf.HomePage) as HttpWebRequest;
            webRequest.Method = "POST";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.CookieContainer = cookies;
            webRequest.Timeout = 300000;
            webRequest.KeepAlive = true;

            StreamWriter requestWriter = new StreamWriter(webRequest.GetRequestStream());
            requestWriter.Write(AmerenConfigurationValues.ValueOf.SummaryPageDataFor(accountNumber, viewState, eventValidation));
            requestWriter.Close();

            StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());
            string responseData = responseReader.ReadToEnd();
            responseReader.Close();

            return responseData;
        }

        private static string RequestUsagePage(string accountNumber, CookieContainer cookies)
        {
            string AMERENUsagePage = AmerenConfigurationValues.ValueOf.BillHistoryPage + AmerenConfigurationValues.ValueOf.BillHistoryPageDataFor(accountNumber);

            HttpWebRequest webRequest = WebRequest.Create(AMERENUsagePage) as HttpWebRequest;
            webRequest.Method = "GET";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.CookieContainer = cookies;

            StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());

            string responseData = responseReader.ReadToEnd();
            responseReader.Close();

            return responseData;
        }

    }
}
