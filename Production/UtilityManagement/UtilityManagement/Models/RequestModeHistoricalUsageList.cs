using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DataAccessLayerEntityFramework;

namespace UtilityManagement.Models
{
    public class RequestModeHistoricalUsageList
    {

        #region public constructors
        public RequestModeHistoricalUsageList()
        {
        }

        public RequestModeHistoricalUsageList(RequestModeHistoricalUsage requestModeHistoricalUsage)
        {
            Id = requestModeHistoricalUsage.Id;
            UtilityCompanyId = requestModeHistoricalUsage.UtilityCompanyId;
            RequestModeEnrollmentTypeId = requestModeHistoricalUsage.RequestModeEnrollmentTypeId;
            RequestModeTypeId = requestModeHistoricalUsage.RequestModeTypeId;
            AddressForPreEnrollment = requestModeHistoricalUsage.AddressForPreEnrollment;
            EmailTemplate = requestModeHistoricalUsage.EmailTemplate;
            Instructions = requestModeHistoricalUsage.Instructions;
            UtilitysSlaHistoricalUsageResponseInDays = requestModeHistoricalUsage.UtilitysSlaHistoricalUsageResponseInDays;
            LibertyPowersSlaFollowUpHistoricalUsageResponseInDays = requestModeHistoricalUsage.LibertyPowersSlaFollowUpHistoricalUsageResponseInDays;
            IsLoaRequired = requestModeHistoricalUsage.IsLoaRequired;
            Inactive = requestModeHistoricalUsage.Inactive;
            CreatedBy = requestModeHistoricalUsage.CreatedBy;
            CreatedDate = requestModeHistoricalUsage.CreatedDate;
            LastModifiedBy = requestModeHistoricalUsage.LastModifiedBy;
            LastModifiedDate = requestModeHistoricalUsage.LastModifiedDate;
            RequestModeEnrollmentType = requestModeHistoricalUsage.RequestModeEnrollmentType;
            RequestModeType = requestModeHistoricalUsage.RequestModeType;
            UtilityCompany = requestModeHistoricalUsage.UtilityCompany;
            UtilityCompany = requestModeHistoricalUsage.UtilityCompany;
            //SelectedUtilityCompanyId = requestModeHistoricalUsage.SelectedUtilityCompanyId;
        }


        #endregion


        #region public properties

        public System.Guid Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public System.Guid RequestModeEnrollmentTypeId { get; set; }
        public System.Guid RequestModeTypeId { get; set; }
        public string AddressForPreEnrollment { get; set; }
        public string EmailTemplate { get; set; }
        public string Instructions { get; set; }
        public int UtilitysSlaHistoricalUsageResponseInDays { get; set; }
        public int LibertyPowersSlaFollowUpHistoricalUsageResponseInDays { get; set; }
        public bool IsLoaRequired { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }

        public virtual RequestModeEnrollmentType RequestModeEnrollmentType { get; set; }
        public virtual RequestModeType RequestModeType { get; set; }
        public virtual UtilityCompany UtilityCompany { get; set; }
        public string SelectedUtilityCompanyId { get; set; }

        #endregion

    }
}
