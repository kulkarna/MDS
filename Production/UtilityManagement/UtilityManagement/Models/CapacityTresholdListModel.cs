using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Utilities;

namespace UtilityManagement.Models
{
    public class CapacityTresholdListModel
    {
        public const string NAMESPACE = "UtilityManagement.Models";
        public const string CLASS = "CapacityTresholdList";

        public string SelectedUtilityCompanyId { get; set; }
        public string UtilityCode { get; set; }
        public int CustomerAccountTypeId { get; set; }
        public bool IgnoreCapacityFactor { get; set; }
        public Int32 CapacityTresholdMin { get; set; }
        public Int32 CapacityTresholdMax { get; set; }
        public bool UseTreshold { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public double Id { get; set; }
        public string AccountType { get; set; }
        
        
        public CapacityTresholdListModel()
        { }

       
        public CapacityTresholdListModel(DataAccessLayerEntityFramework.usp_CapacityThresholdRuleGetByUtilityCode_Result capacityThresholdRule)
        {
            Id = capacityThresholdRule.Id;
            CreatedBy = capacityThresholdRule.CreatedBy;
            CreatedDate = capacityThresholdRule.CreatedDate;
            LastModifiedBy = capacityThresholdRule.LastModifiedBy;
            LastModifiedDate = capacityThresholdRule.LastModifiedDate;
            Inactive = capacityThresholdRule.Inactive;
            UtilityCode = capacityThresholdRule.UtilityCode;
            SelectedUtilityCompanyId = capacityThresholdRule.UtilityCompanyId.ToString();
            CapacityTresholdMin = capacityThresholdRule.CapacityThreshold;
            CapacityTresholdMax =  Common.NullSafeInteger(capacityThresholdRule.CapacityThresholdMax);
            UseTreshold = !capacityThresholdRule.IgnoreCapacityFactor;
            AccountType = capacityThresholdRule.AccountType;

        }
    
    }
}