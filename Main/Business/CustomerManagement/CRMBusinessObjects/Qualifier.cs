using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract] 
    public class Qualifier : ICloneable, IValidator
    {
        #region Primary key(s)
        [DataMember]
        public System.Int32 QualifierId { get; set; }
        #endregion

        [DataMember]
        public System.Int32 CampaignId { get; set; }
        [DataMember]
        public System.Int32 PromotionCodeId { get; set; }
        [DataMember]
        public System.Int32? SalesChannelId { get; set; }
        [DataMember]
        public System.Int32? MarketId { get; set; }
        [DataMember]
        public System.Int32? UtilityId { get; set; }
        [DataMember]
        public System.Int32? AccountTypeId { get; set; }
        [DataMember]
        public System.Int32? Term { get; set; }
        [DataMember]
        //28372: Change ProductType to Product Brand
        public System.Int32? ProductBrandId { get; set; }
        [DataMember]
        public System.DateTime SignStartDate { get; set; }
        [DataMember]
        public System.DateTime SignEndDate { get; set; }
        [DataMember]
        public System.DateTime? ContractEffecStartPeriodStartDate { get; set; }
        [DataMember]
        public System.DateTime? ContractEffecStartPeriodLastDate { get; set; }
        [DataMember]
        public System.Int32? PriceTierId { get; set; }
        [DataMember]
        public System.Int32? CreatedBy { get; set; }
        [DataMember]
        public System.DateTime CreatedDate { get; set; }
        [DataMember]
        public System.Int32? GroupBy { get; set; }
        [DataMember]
        public PromotionCode PromotionCode { get; set; }
        //Code added by Manish Pandey-Added field IsDateOnlyChanged.
        [DataMember]
        public Int32 IsDateOnlyChanged { get; set; }
        [DataMember]
        public System.Int32? AccountAnnualUsage { get; set; } //1-1284384471(81528) -  Added AnnualUsage - 07/28/2015 - Andre Damasceno
        
        [DataMember]
		public System.Boolean? AutoApply {
			get
			{
				return this._AutoApply;
			}


			set{
				if( value.HasValue  )
                {
					this._AutoApply = value;
                }
				else
					this._AutoApply = false;
			}
			 }

		private System.Boolean? _AutoApply;
        public System.String SalesChannelIds { get; set; }
        public System.String MarketIds { get; set; }
        
        public Qualifier()
        {
            this.SetDefaultValues();
        }
        public void SetDefaultValues()
        {

            if (this.CreatedDate == DateTime.MinValue)
            {
                this.CreatedDate = DateTime.Now;
            }
			if( !this.AutoApply.HasValue )
			{
				this.AutoApply = false;
			}

        }
        #region IValidator Members

        public bool IsStructureValidForInsert()
        {
            return true;
        }

        public bool IsStructureValidForUpdate()
        {
            return true;
        }

        public List<GenericError> IsValidForInsert()
        {
            List<GenericError> errors = new List<GenericError>();

            errors = this.IsValid();

            return errors;
        }

        public List<GenericError> IsValidForUpdate()
        {
            return new List<GenericError>();
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            if (this.PromotionCodeId == -1)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Promotion Code is required" });
            }
            if (this.CreatedBy == 0)
            {
                errors.Add(new GenericError() { Code = 1, Message = "Qualifier CreatedBy must have a valid value" });
            }
            String OverlappingCampaign = "";
            if (QualifierFactory.HasPromoCodeOverlappingEffectivePeriod(this, out  OverlappingCampaign))
            {
                errors.Add(new GenericError() { Code = 2, Message = string.Format("Promotion Code is assigned to other Campaign ({0}) which has an overlapping effective period", OverlappingCampaign) });
            }
            if (!QualifierFactory.IsQualifierBetweenCampaignStartEndDate(this))
            {
               CampaignCode CampaignCode=new CampaignCode();
               CampaignCode = CampaignCodeFactory.GetCampaignCodeDetailsbyId(this.CampaignId);

               errors.Add(new GenericError() { Code = 3, Message = string.Format("Qualifier sign start and end date should be between campaign start date ({0}) and end date ({1})", String.Format("{0:MM/dd/yyyy}", CampaignCode.StartDate), String.Format("{0:MM/dd/yyyy}", CampaignCode.EndDate)) });
            }
            if (QualifierFactory.IsQualifierAlreadyUsed(this))
            {
                //Code added by Manish Pandey-Changed message.
                errors.Add(new GenericError() { Code = 4, Message = "The record you are trying to update has already been assigned to a Contract.You can only change the date(s). </br>If you want other changes, Please create a new Qualifier record to this campaign to reflect your desired updates" });
            }
            return errors;
        }
        #endregion
        #region " Clone Method"

        public Object Clone()
        {
            Qualifier _tmp = new Qualifier();
            _tmp.QualifierId = this.QualifierId;
            _tmp.CampaignId = this.CampaignId;
            _tmp.PromotionCodeId = this.PromotionCodeId;
            _tmp.SalesChannelId = this.SalesChannelId;
            _tmp.MarketId = this.MarketId;
            _tmp.UtilityId = this.UtilityId;
            _tmp.AccountTypeId = this.AccountTypeId;
            _tmp.Term = this.Term;
            _tmp.ProductBrandId = this.ProductBrandId;
            _tmp.SignStartDate = this.SignStartDate;
            _tmp.SignEndDate = this.SignEndDate;
            _tmp.SalesChannelId = this.SalesChannelId;
            _tmp.ContractEffecStartPeriodStartDate = this.ContractEffecStartPeriodStartDate;
            _tmp.ContractEffecStartPeriodLastDate = this.ContractEffecStartPeriodLastDate;
            _tmp.PriceTierId = this.PriceTierId;
            _tmp.CreatedBy = this.CreatedBy;
            _tmp.CreatedDate = this.CreatedDate;
            _tmp.PromotionCode = this.PromotionCode;
            _tmp.CreatedBy = this.CreatedBy;
            _tmp.CreatedDate = this.CreatedDate;
			_tmp.AutoApply = this.AutoApply;
            return _tmp;
        }
        #endregion Clone Method
    }
}

