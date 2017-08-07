using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DataAccessLayerEntityFramework;

namespace UtilityManagement.Models
{
    public class PurchaseOfReceivableModelList
    {

        #region public constructors
        public PurchaseOfReceivableModelList()
        {
        }

        public PurchaseOfReceivableModelList(PurchaseOfReceivable purchaseOfReceivable)
        {
            Id = purchaseOfReceivable.Id;
            UtilityCompanyId = purchaseOfReceivable.UtilityCompanyId;
            UtilityCompany = purchaseOfReceivable.UtilityCompany;
            PorDriverId = purchaseOfReceivable.PorDriverId;
            PorDriver = purchaseOfReceivable.PorDriver;
            RateClassId = purchaseOfReceivable.RateClassId;
            RateClass = purchaseOfReceivable.RateClass;
            LoadProfileId = purchaseOfReceivable.LoadProfileId;
            LoadProfile = purchaseOfReceivable.LoadProfile;
            TariffCodeId = purchaseOfReceivable.TariffCodeId;
            TariffCode = purchaseOfReceivable.TariffCode;
            IsPorOffered = purchaseOfReceivable.IsPorOffered;
            IsPorParticipated = purchaseOfReceivable.IsPorParticipated;
            PorRecourseId = purchaseOfReceivable.PorRecourseId;
            PorRecourse = purchaseOfReceivable.PorRecourse;
            IsPorAssurance = purchaseOfReceivable.IsPorAssurance;
            DiscountRate = purchaseOfReceivable.PorDiscountRate;
            FlatFee = purchaseOfReceivable.PorFlatFee;
            EffectiveDate = purchaseOfReceivable.PorDiscountEffectiveDate;
            ExpirationDate = purchaseOfReceivable.PorDiscountExpirationDate;
            Inactive = purchaseOfReceivable.Inactive;
            CreatedBy = purchaseOfReceivable.CreatedBy;
            CreatedDate = purchaseOfReceivable.CreatedDate;
            LastModifiedBy = purchaseOfReceivable.LastModifiedBy;
            LastModifiedDate = purchaseOfReceivable.LastModifiedDate;
        }
        #endregion


        #region public properties


        public System.Guid Id { get; set; }
        public System.Guid UtilityCompanyId { get; set; }
        public System.Guid PorDriverId { get; set; }
        public System.Guid? RateClassId { get; set; }
        public System.Guid? LoadProfileId { get; set; }
        public System.Guid? TariffCodeId { get; set; }
        public bool IsPorOffered { get; set; }
        public bool IsPorParticipated { get; set; }
        public System.Guid PorRecourseId { get; set; }
        public bool IsPorAssurance { get; set; }
        public decimal DiscountRate { get; set; }
        public decimal FlatFee { get; set; }
        public DateTime EffectiveDate { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public bool Inactive { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public string SelectedUtilityCompanyId { get; set; }
        public List<string> ResultData { get; set; }
       
        public virtual UtilityCompany UtilityCompany { get; set; }
        public virtual PorDriver PorDriver { get; set; }
        public virtual RateClass RateClass { get; set; }
        public virtual LoadProfile LoadProfile { get; set; }
        public virtual TariffCode TariffCode { get; set; }
        public virtual PorRecourse PorRecourse { get; set; }
        #endregion

    }
}
