using DataAccessLayerEntityFramework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace UtilityManagement.Models
{
    public class LibertyPowerBillingTypeListModel
    {
        public const string NAMESPACE = "UtilityManagement.Models";
        public const string CLASS = "LibertyPowerBillingTypeListModel";

        public string SelectedUtilityCompanyId { get; set; }
        public string UtilityCode { get; set; }
        public System.Guid PorDriverId { get; set; }
        public string PorDriverName { get; set; }
        public System.Guid LoadProfileId { get; set; }
        public string LoadProfileCode { get; set; }
        public System.Guid RateClassId { get; set; }
        public string RateClassCode { get; set; }
        public System.Guid TariffCodeId { get; set; }
        public string TariffCode { get; set; }
        public System.Guid DefaultBillingTypeId { get; set; }
        public string DefaultBillingTypeName { get; set; }
        public bool LibertyPowerApprovedBillingTypeId { get; set; }
        public System.Guid? LpApprovedBillingTypeId { get; set; }
        public string LpApprovedBillingTypeName { get; set; }
        public System.Guid UtilityOfferedBillingTypeId { get; set; }
        public string UtilityOfferedBillingTypeName { get; set; }
        public int? Terms { get; set; }
        public System.Guid? AccountTypeId { get; set; }
        public string AccountTypeName { get; set; }
        public System.Guid Id {get; set;}
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedDate { get; set; }


        public LibertyPowerBillingTypeListModel()
        { }

        public LibertyPowerBillingTypeListModel(DataAccessLayerEntityFramework.LpBillingType lpBillingType, Guid utilityOfferedBillingTypeId,
            string utilityOfferedBillingTypeName, Guid? lpApprovedBillingTypeId, string lpApprovedBillingTypeName, int? terms, string accountTypeName)
        {
            Id = lpBillingType.Id;
            CreatedBy = lpBillingType.CreatedBy;
            CreatedDate = lpBillingType.CreatedDate;
            DefaultBillingTypeName = lpBillingType.BillingType.Name;
            DefaultBillingTypeId = lpBillingType.DefaultBillingTypeId;
            LastModifiedBy = lpBillingType.LastModifiedBy;
            LastModifiedDate = lpBillingType.LastModifiedDate;
            LoadProfileCode = lpBillingType == null || lpBillingType.LoadProfile == null ? null : lpBillingType.LoadProfile.LoadProfileCode;
            LoadProfileId = lpBillingType == null || lpBillingType.LoadProfileId == null ? Guid.Empty : (Guid)lpBillingType.LoadProfileId;
            LpApprovedBillingTypeId = lpApprovedBillingTypeId;
            LpApprovedBillingTypeName = lpApprovedBillingTypeName;
            PorDriverId = lpBillingType.PorDriverId;
            PorDriverName = lpBillingType.PorDriver.Name;
            RateClassCode = lpBillingType == null || lpBillingType.RateClass == null ? null : lpBillingType.RateClass.RateClassCode;
            RateClassId = lpBillingType == null || lpBillingType.RateClassId == null ? Guid.Empty : (Guid)lpBillingType.RateClassId;
            SelectedUtilityCompanyId = lpBillingType.UtilityCompanyId.ToString();
            TariffCode = lpBillingType == null || lpBillingType.TariffCode == null ? null : lpBillingType.TariffCode.TariffCodeCode;
            TariffCodeId = lpBillingType == null || lpBillingType.TariffCodeId == null ? Guid.Empty : (Guid)lpBillingType.TariffCodeId;
            UtilityCode = lpBillingType.UtilityCompany.UtilityCode;
            UtilityOfferedBillingTypeId = utilityOfferedBillingTypeId;
            UtilityOfferedBillingTypeName = utilityOfferedBillingTypeName;
            Terms = terms;
            AccountTypeName = accountTypeName;
            LibertyPowerApprovedBillingTypeId = LpApprovedBillingTypeId != null && LpApprovedBillingTypeId == UtilityOfferedBillingTypeId;
        }

        //public override string ToString()
        //{
        //    string returnValue = string.Format("{0}.{1}[SelectedUtilityCompanyId:{2},UtilityCode:{3},PorDriverId:{4},PorDriverName:{5},LoadProfileId:{6},LoadProfileCode:{7},RateClassId:{8},RateClassCode:{9},TariffCodeId:{10},TariffCode:{11},DefaultBillingTypeId:{12},DefaultBillingTypeName:{13},LibertyPowerApprovedBillingTypeId:{14},LpApprovedBillingTypeId:{15},LpApprovedBillingTypeName:{16},UtilityOfferedBillingTypeId:{17},UtilityOfferedBillingTypeName:{18},Terms:{19},AccountTypeId:{20},AccountTypeName:{21},Id:{22},Inactive:{23},CreatedBy:{24},CreatedDate:{25},LastModifiedBy:{26},LastModifiedDate:{27}]",
        //    NAMESPACE,CLASS,Utilities.Common.NullSafeGuid(SelectedUtilityCompanyId),Utilities.Common.NullSafeString(UtilityCode),Utilities.Common.NullSafeGuid(PorDriverId),
        //    Utilities.Common.NullSafeString(PorDriverName),Utilities.Common.NullSafeGuid(LoadProfileId),Utilities.Common.NullSafeString(LoadProfileCode),
        //    Utilities.Common.NullSafeGuid(RateClassId),Utilities.Common.NullSafeString(RateClassCode),Utilities.Common.NullSafeGuid(TariffCodeId),Utilities.Common.NullSafeString(TariffCode),
        //    Utilities.Common.NullSafeGuid(DefaultBillingTypeId),Utilities.Common.NullSafeString(DefaultBillingTypeName),
        //    Utilities.Common.NullSafeGuid(LibertyPowerApprovedBillingTypeId),Utilities.Common.NullSafeGuid(LpApprovedBillingTypeId),Utilities.Common.NullSafeString(LpApprovedBillingTypeName),
        //    Utilities.Common.NullSafeGuid(UtilityOfferedBillingTypeId),Utilities.Common.NullSafeString(UtilityOfferedBillingTypeName),Utilities.Common.NullSafeString(Terms),
        //    Utilities.Common.NullSafeGuid(AccountTypeId),Utilities.Common.NullSafeString(AccountTypeName),Utilities.Common.NullSafeGuid(Id),
        //    Utilities.Common.NullSafeString(Inactive),Utilities.Common.NullSafeString(CreatedBy),Utilities.Common.NullSafeDateToString(CreatedDate),
        //    Utilities.Common.NullSafeString(LastModifiedBy),Utilities.Common.NullSafeDateToString(LastModifiedDate));
        //    return base.ToString();
        //}
    }
}