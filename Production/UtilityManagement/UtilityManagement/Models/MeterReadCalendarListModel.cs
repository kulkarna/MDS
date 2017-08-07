using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class MeterReadCalendarListModel
    {
        public const string NAMESPACE = "UtilityManagement.Models";
        public const string CLASS = "MeterReadCalendarListModel";

        public string SelectedUtilityCompanyId { get; set; }
        public string UtilityCode { get; set; }
        public System.Guid YearId { get; set; }
        public int Year { get; set; }
        public System.Guid MonthId { get; set; }
        public int Month { get; set; }
        public string ReadCycleId { get; set; }
        public DateTime? ReadDate { get; set; }
        public System.Guid Id { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public bool IsAmr { get; set; }

        public MeterReadCalendarListModel()
        { }

        public MeterReadCalendarListModel(DataAccessLayerEntityFramework.MeterReadCalendar meterReadCalendar)
        {
            Id = meterReadCalendar.Id;
            CreatedBy = meterReadCalendar.CreatedBy;
            CreatedDate = meterReadCalendar.CreatedDate;
            LastModifiedBy = meterReadCalendar.LastModifiedBy;
            LastModifiedDate = meterReadCalendar.LastModifiedDate;
            Inactive = meterReadCalendar.Inactive;
            UtilityCode = meterReadCalendar.UtilityCompany.UtilityCode;
            SelectedUtilityCompanyId = meterReadCalendar.UtilityId.ToString();
            YearId = meterReadCalendar.YearId;
            Year = meterReadCalendar.Year.Year1;
            MonthId = meterReadCalendar.MonthId;
            Month = meterReadCalendar.Month.Month1;
            ReadCycleId = meterReadCalendar.ReadCycleId;
            ReadDate = meterReadCalendar.ReadDate;
            IsAmr = meterReadCalendar.IsAmr;
        }
    
    }
}