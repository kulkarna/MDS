using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace UserInterfaceValidationExtensions
{
    public class MeterReadCalendarValidation
    {
        #region public constructors
        public MeterReadCalendarValidation(MeterReadCalendar meterReadCalendar)
        {
            PopulateValidationProperties(meterReadCalendar);
            Message += GenerateMessage();
        }
        #endregion


        #region public properties
        bool IsMeterReadCalendarNotNull { get; set; }
        bool IsMeterReadCalendarCreatedByValid { get; set; }
        bool IsMeterReadCalendarCreatedDateValid { get; set; }
        bool IsMeterReadCalendarLastModifiedByValid { get; set; }
        bool IsMeterReadCalendarLastModifiedDateValid { get; set; }
        bool IsMeterReadCalendarYearIdValid { get; set; }
        bool IsMeterReadCalendarMonthIdValid { get; set; }
        public bool IsMeterReadCalendarReadCycleIdValid { get; set; }
        public bool IsMeterReadCalendarReadCycleIdLengthValid { get; set; }
        public bool IsMeterReadCalendarReadDateValid { get; set; }
        bool IsMeterReadCalendarUtilityCompanyIdValid { get; set; }

        public bool IsValid
        {
            get
            {
                return IsMeterReadCalendarNotNull &&
                    IsMeterReadCalendarCreatedByValid &&
                    IsMeterReadCalendarCreatedDateValid &&
                    IsMeterReadCalendarLastModifiedByValid &&
                    IsMeterReadCalendarLastModifiedDateValid &&
                    IsMeterReadCalendarYearIdValid &&
                    IsMeterReadCalendarMonthIdValid &&
                    IsMeterReadCalendarReadCycleIdValid &&
                    IsMeterReadCalendarReadCycleIdLengthValid &&
                    IsMeterReadCalendarReadDateValid &&
                    IsMeterReadCalendarUtilityCompanyIdValid &&
                    !HasErrors;
            }
        }
        public bool HasErrors { get; set; }
        public string Message { get; set; }
        #endregion


        #region private methods
        private void PopulateValidationProperties(MeterReadCalendar meterReadCalendar)
        {
            IsMeterReadCalendarNotNull = meterReadCalendar != null;
            IsMeterReadCalendarCreatedByValid = Common.IsValidString(meterReadCalendar.CreatedBy);
            IsMeterReadCalendarCreatedDateValid = Common.IsValidDate(meterReadCalendar.CreatedDate);
            IsMeterReadCalendarLastModifiedByValid = Common.IsValidString(meterReadCalendar.LastModifiedBy);
            IsMeterReadCalendarLastModifiedDateValid = Common.IsValidDate(meterReadCalendar.LastModifiedDate);
            IsMeterReadCalendarYearIdValid = Common.IsValidGuid(meterReadCalendar.YearId);
            IsMeterReadCalendarMonthIdValid = Common.IsValidGuid(meterReadCalendar.MonthId);
            IsMeterReadCalendarReadCycleIdValid = !string.IsNullOrWhiteSpace(meterReadCalendar.ReadCycleId) && !(meterReadCalendar.ReadCycleId.Any(ch=>!Char.IsLetterOrDigit(ch))) && meterReadCalendar.ReadCycleId.Length >= 1;
            IsMeterReadCalendarReadCycleIdLengthValid = (meterReadCalendar.ReadCycleId.Length <= 255);
            IsMeterReadCalendarReadDateValid = meterReadCalendar.ReadDate != null && (Common.IsValidDate((DateTime)meterReadCalendar.ReadDate) && DateTime.Compare(new DateTime(2004,1,1),(DateTime)meterReadCalendar.ReadDate)<0);
            IsMeterReadCalendarUtilityCompanyIdValid = Common.IsValidGuid(meterReadCalendar.UtilityId);
        }


        private string GenerateMessage()
        {
            StringBuilder message = new StringBuilder();
            if (!IsMeterReadCalendarNotNull)
                message.Append("Invalid Data Model! ");
            if (!IsMeterReadCalendarCreatedByValid)
                message.Append("Invalid Value For Created By! ");
            if (!IsMeterReadCalendarCreatedDateValid)
                message.Append("Invalid Value For Created Date! ");
            if (!IsMeterReadCalendarLastModifiedByValid)
                message.Append("Invalid Value For Last Modified By! ");
            if (!IsMeterReadCalendarLastModifiedDateValid)
                message.Append("Invalid Value For Last Modified Date! ");
            if (!IsMeterReadCalendarUtilityCompanyIdValid)
                message.Append("Invalid Value For Utility! ");
            if (!IsMeterReadCalendarYearIdValid)
                message.Append("Invalid Value For Year! ");
            if (!IsMeterReadCalendarMonthIdValid)
                message.Append("Invalid Value For Month Value! ");
            if (!IsMeterReadCalendarReadCycleIdValid)
                message.Append("Invalid Value For Read Cycle Id! ");
            if (!IsMeterReadCalendarReadCycleIdValid)
                message.Append("Meter Read Cycle ID Is Too Long. It Cannot Be Greater Than 255 characers! ");
            if (!IsMeterReadCalendarReadDateValid)
                message.Append("Invalid Value For Read Date! ");

            return message.ToString();
        }
        #endregion
    }
}