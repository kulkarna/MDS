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

        #region ISTA/ESG Switch

        private static string useESGForUsageRequest = ConfigurationManager.AppSettings["UseESGForUsageRequest"];
        private static string useEsgForDeEnrollmentRequest = ConfigurationManager.AppSettings["UseEsgForDeEnrollmentRequest"];
        private static string useEsgForReEnrollmentRequest = ConfigurationManager.AppSettings["UseEsgForReEnrollmentRequest"];
        private static string useEsgForEnrollmentRequest = ConfigurationManager.AppSettings["UseEsgForEnrollmentRequest"];

        // USAGE REQUEST

        /// <summary>
        /// Returns whether an usage request should be sent to ESG instead of ISTA.
        /// </summary>
        public static string UseESGForUsageRequest
        {
            get
            {
                return useESGForUsageRequest;
            }
        }

        // DE-ENROLLMENT REQUEST

        /// <summary>
        /// Returns whether a de-enrolmment request should be sent to ESG instead of ISTA.
        /// </summary>
        public static bool UseEsgForDeEnrollmentRequest
        {
            get
            {
                if (useEsgForDeEnrollmentRequest != null)
                    useEsgForDeEnrollmentRequest = useEsgForDeEnrollmentRequest.Trim();

                return "1".Equals(useEsgForDeEnrollmentRequest);
            }
        }

        // RE-ENROLLMENT REQUEST

        /// <summary>
        /// Returns whether a re-enrollment request should be sent to ESG instead of ISTA.
        /// </summary>
        public static bool UseEsgForReEnrollmentRequest
        {
            get
            {
                if (useEsgForReEnrollmentRequest != null)
                    useEsgForReEnrollmentRequest = useEsgForReEnrollmentRequest.Trim();

                return "1".Equals(useEsgForReEnrollmentRequest);
            }
        }

        // ENROLLMENT REQUEST

        /// <summary>
        /// Returns whether an enrollment request should be sent to ESG instead of ISTA.
        /// </summary>
        public static bool UseEsgForEnrollmentRequest
        {
            get
            {
                if (useEsgForEnrollmentRequest != null)
                    useEsgForEnrollmentRequest = useEsgForEnrollmentRequest.Trim();

                return "1".Equals(useEsgForEnrollmentRequest);
            }
        }

        #endregion
    }
}
