using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using PricingBal = LibertyPower.Business.CustomerAcquisition.DailyPricing;
using ProductBal = LibertyPower.Business.CustomerAcquisition.ProductManagement;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class AccountContractRate : ICloneable, IValidator
    {
        #region Contructors

        public AccountContractRate()
        {
            SetDefaultValues();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="productCrossPriceMultiID">Multi-term record identifier</param>
        /// <param name="startDate">Start date</param>
        /// <param name="term">Term</param>
        /// <param name="grossMargin">Markup rate</param>
        /// <param name="rate">Price</param>
        public AccountContractRate( int productCrossPriceMultiID, DateTime startDate, int term, double? grossMargin, double? rate )
        {
            this.ProductCrossPriceMultiID = productCrossPriceMultiID;
            this.RateStart = startDate;
            this.Term = term;
            this.GrossMargin = grossMargin;
            this.Rate = rate;
            SetDefaultValues();
        }

        public void SetDefaultValues()
        {
            this.IsContractedRate = true;
            this.RateCode = "";
            this.IsVariable = false;
        }

        #endregion

        #region Properties

        #region Primary key(s)
        /// <summary>			
        /// AccountContractRateID : 
        /// </summary>
        /// <remarks>Member of the primary key of the underlying table "AccountContractRate"</remarks>
        public System.Int32? AccountContractRateId { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// AccountContractID : 
        /// </summary>
        public System.Int32? AccountContractId { get; set; }

        /// <summary>
        ///  Is Variable Rate Product:
        /// </summary>
        public System.Boolean IsVariable { get; set; }

        /// <summary>
        /// LegacyProductID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String LegacyProductId { get; set; }

        /// <summary>
        /// Term : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? Term { get; set; }

        /// <summary>
        /// RateID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? RateId { get; set; }

        /// <summary>
        /// Rate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Double? Rate { get; set; }

        /// <summary>
        /// ContractRate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Double? ContractRate { get; set; } //PBI 142028 - Andre Damasceno - 10/10/2016 - Added new column

        /// <summary>
        /// RateCode : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.String RateCode { get; set; }

        /// <summary>
        /// RateStart : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime RateStart { get; set; }

        /// <summary>
        /// RateEnd : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.DateTime RateEnd { get; set; }

        /// <summary>
        /// IsContractedRate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Boolean IsContractedRate { get; set; }

        /// <summary>
        /// HeatIndexSourceID : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? HeatIndexSourceId { get; set; }

        /// <summary>
        /// HeatRate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Decimal? HeatRate { get; set; }

        /// <summary>
        /// TransferRate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Double? TransferRate { get; set; }

        /// <summary>
        /// GrossMargin : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Double? GrossMargin { get; set; }

        /// <summary>
        /// CommissionRate : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Double? CommissionRate { get; set; }

        /// <summary>
        /// AdditionalGrossMargin : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Double? AdditionalGrossMargin { get; set; }

        [System.Runtime.Serialization.DataMember]
        public System.Int64? PriceId { get; set; }

        [System.Runtime.Serialization.DataMember]
        public System.Int64? ProductCrossPriceMultiID { get; set; }

        /// <summary>
        /// Modified : 
        /// </summary>
        public System.DateTime Modified { get; set; }

        /// <summary>
        /// ModifiedBy : 
        /// </summary>
        public System.Int32 ModifiedBy { get; set; }

        /// <summary>
        /// DateCreated : 
        /// </summary>
        public System.DateTime DateCreated { get; set; }

        /// <summary>
        /// CreatedBy : 
        /// </summary>
        public System.Int32 CreatedBy { get; set; }


        /// <summary>
        /// RateEnd : 
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Boolean IsCustomEnd { get; set; }
        #endregion

        #endregion

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            AccountContractRate _tmp = new AccountContractRate();
            _tmp.AccountContractRateId = this.AccountContractRateId;
            _tmp.AccountContractId = this.AccountContractId;
            _tmp.LegacyProductId = this.LegacyProductId;
            _tmp.Term = this.Term;
            _tmp.RateId = this.RateId;
            _tmp.Rate = this.Rate;
            _tmp.ContractRate = this.ContractRate;//PBI 142028 - Andre Damasceno - 10/10/2016 - Added new column           
            _tmp.RateCode = this.RateCode;
            _tmp.RateStart = this.RateStart;
            _tmp.RateEnd = this.RateEnd;
            _tmp.IsContractedRate = this.IsContractedRate;
            _tmp.HeatIndexSourceId = this.HeatIndexSourceId;
            _tmp.HeatRate = this.HeatRate;
            _tmp.TransferRate = this.TransferRate;
            _tmp.GrossMargin = this.GrossMargin;
            _tmp.CommissionRate = this.CommissionRate;
            _tmp.AdditionalGrossMargin = this.AdditionalGrossMargin;
            _tmp.PriceId = this.PriceId;
            _tmp.ProductCrossPriceMultiID = this.ProductCrossPriceMultiID;
            _tmp.Modified = this.Modified;
            _tmp.ModifiedBy = this.ModifiedBy;
            _tmp.DateCreated = this.DateCreated;
            _tmp.CreatedBy = this.CreatedBy;

            return _tmp;
        }


        #endregion Clone Method

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
            errors = IsValid();

            if( errors.Count > 0 )
                return errors;

            return errors;
        }

        public List<GenericError> IsValidForUpdate()
        {
            List<GenericError> errors = new List<GenericError>();
            errors = IsValid();

            if( string.IsNullOrEmpty( this.LegacyProductId ) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: LegacyProductId must have a valid value" } );
            }

            if( !this.RateId.HasValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: RateId must have a valid value" } );
            }


            if( errors.Count > 0 )
                return errors;

            return errors;
        }

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            // Uncommented since we will auto-populate this based on priceId
            //if( string.IsNullOrEmpty( this.LegacyProductId ) )
            //{
            //    errors.Add( new GenericError() { Code = 0, Message = "AccountRate: LegacyProductId must have a valid value" } );
            //}

            if( (!this.Rate.HasValue) || (this.Rate <= 0) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: Rate must have a valid value" } );
            }

            if( (!this.Term.HasValue) || (this.Term <= 0) )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: Term must have a valid value" } );
            }

            // Uncommented since we will auto-populate this based on priceId
            //if( !this.RateId.HasValue )
            //{
            //    errors.Add( new GenericError() { Code = 0, Message = "AccountRate: RateId must have a valid value" } );
            //}

            if( this.RateCode == null )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: RateCode must have a valid value" } );
            }

            if( this.RateStart == DateTime.MinValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: RateStart must have a valid value" } );
            }

            if( this.RateEnd == DateTime.MinValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: RateEnd must have a valid value" } );
            }

            if (!this.PriceId.HasValue && ! this.IsVariable)
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: PriceId must have a valid value" } );
            }

            if( this.ModifiedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: ModifiedBy must have a valid value" } );
            }

            if( this.CreatedBy == 0 )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: CreatedBy must have a valid value" } );
            }

            if( !this.Term.HasValue )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: Term must have a valid value" } );
            }

            if( this.RateStart > this.RateEnd )
            {
                errors.Add( new GenericError() { Code = 0, Message = "AccountRate: RateStart Date is higher than RateEnd" } );
            }

            return errors;
        }

        #endregion

        [OnDeserialized]
        private void SetValuesOnDeserialized( StreamingContext context )
        {
            SetDefaultValues();
        }

       
        public PricingBal.CrossProductPriceSalesChannel Price { set; get; }

        //public PricingBal.MultiTerm MultiTerm { set; get; }

        public bool IsInDefaultVariable
        {
            get
            {
                ProductBal.Product product = ProductBal.ProductFactory.CreateProduct( this.LegacyProductId, false );
                if( product.IsDefault )
                    return true;
                else
                    return false;
            }
        }

    }
}
