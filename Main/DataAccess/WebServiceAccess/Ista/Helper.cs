using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService
{
    internal sealed class Helper
    {

        private static string istaEnrollmentWebService = ConfigurationManager.AppSettings["IstaEnrollmentWebService"];
        public static string IstaEnrollmentWebService
        {
            get
            { return istaEnrollmentWebService; }
        }
        
        private static string istaCustomerWebService = ConfigurationManager.AppSettings["IstaCustomerWebService"];
        public static string IstaCustomerWebService
        {
            get
            { return istaCustomerWebService; }
        }



		private static string istaInvoiceWebService = ConfigurationManager.AppSettings["IstaInvoiceWebService"];
		public static string IstaInvoiceWebService
		{
			get
			{ return istaInvoiceWebService; }
		}


        private static string istaRateWebService = ConfigurationManager.AppSettings["IstaRateWebService"];
        public static string IstaRateWebService
        {
            get
            { return istaRateWebService; }
        }

        private static string istaClientGuid = ConfigurationManager.AppSettings["IstaClientGuid"];
        public static string IstaClientGuid
        {
            get
            { return istaClientGuid; }
        }

		private static string istaBillingWebService = ConfigurationManager.AppSettings["IstaBillingWebService"];
		public static string IstaBillingWebService
		{
			get
			{ return istaBillingWebService; }
		}
    
    }
}
