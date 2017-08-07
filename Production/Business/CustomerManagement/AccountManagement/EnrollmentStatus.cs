using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
    public static class EnrollmentStatus
    {

        public enum Status
        {
            DealCapture,
            PendingDealScreening,
            PendingTPV,
            PendingContract,
            PendingEnrollment,
            /// <summary>
            /// Obsolete Status that should be phased out in the future, only very few accounts are still in this status
            /// </summary>
            PendingEnrollmentLegacy,
            PendingRenewal,
            PendingHistory,
            PendingCreditCheck,
            PendingDeposit,
            PendingDeenrollment,
            EnrollmentCancellation,
            PendingReenrollment,
            Enrolled,
            /// <summary>
            /// Obsolete Status that should be phased out in the future, however, a lot of accounts are still in this status
            /// </summary>
            EnrolledLegacy,
            Deenrolled,
            EnrollmentCancelled,
            NotEnrolled
        }

        public static string GetValue(Status status)
        {

            switch (status)
            {
                case Status.DealCapture:
                    return "00000";
                case Status.PendingDealScreening:
                    return "01000";
                case Status.PendingTPV:
                    return "03000";
                case Status.PendingContract:
                    return "04000";
                case Status.PendingEnrollment:
                    return "05000";
                case Status.PendingEnrollmentLegacy:
                    return "06000";
                case Status.PendingRenewal:
                    return "07000";
                case Status.PendingHistory:
                    return "08000";
                case Status.PendingCreditCheck:
                    return "09000";
                case Status.PendingDeposit:
                    return "10000";
                case Status.PendingDeenrollment:
                    return "11000";
                case Status.EnrollmentCancellation:
                    return "12000";
                case Status.PendingReenrollment:
                    return "13000";
                case Status.Enrolled:
                    return "905000";
                case Status.EnrolledLegacy:
                    return "906000";
                case Status.Deenrolled:
                    return "911000";
                case Status.EnrollmentCancelled:
                    return "999998";
                case Status.NotEnrolled:
                    return "999999";
                default:
                    throw new Exception("Unhandled Status found.");
            }
        }
    }
}
