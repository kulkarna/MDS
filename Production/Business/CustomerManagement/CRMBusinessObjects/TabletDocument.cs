using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    [Serializable]
    [System.Runtime.Serialization.DataContract]
    public class TabletDocument : ICloneable, IValidator
    {
        #region Fields

        #endregion

        #region Constructors

        #endregion

        #region Properties

        #region Primary key(s)

        /// <summary>			
        /// TabletDocumentSubmissionID : 
        /// </summary>
        /// <remarks>Member of the primary key of the table "TabletDocumentSubmission"</remarks>
        public System.Int32? TabletDocumentSubmissionID { get; set; }

        #endregion

        #region Non Primary key(s)

        /// <summary>
        /// ContractNumber : 
        /// </summary>
        /// <remarks>Number of the contract that the document refers to</remarks>
        [System.Runtime.Serialization.DataMember]
        public System.String ContractNumber { get; set; }

        /// <summary>
        /// FileName : 
        /// </summary>
        /// <remarks>Name of the document file</remarks>
        [System.Runtime.Serialization.DataMember]
        public System.String FileName { get; set; }

        /// <summary>
        /// DocumentTypeID : 
        /// </summary>
        /// <remarks>ID that represents the document type</remarks>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? DocumentTypeID { get; set; }

        /// <summary>
        /// DocumentTypeName : 
        /// </summary>
        /// <remarks>Name of the document type</remarks>
        [System.Runtime.Serialization.DataMember]
        public System.String DocumentTypeName { get; set; }

        /// <summary>
        /// SalesAgentID : 
        /// </summary>
        /// <remarks>Sales Agent that created the contract on the tablet - maps to a User record</remarks>
        [System.Runtime.Serialization.DataMember]
        public System.Int32? SalesAgentID { get; set; }

        /// <summary>
        /// ModifiedDate : 
        /// </summary>
        public System.DateTime ModifiedDate { get; set; }

        /// <summary>
        /// CreatedDate : 
        /// </summary>
        public System.DateTime CreatedDate { get; set; }

        /// <summary>
        /// Sets whether the file belongs to a natural gas contract
        /// </summary>
        [System.Runtime.Serialization.DataMember]
        public System.Boolean IsGasFile { get; set; }


        #endregion

        #endregion

        #region Clone Method

        /// <summary>
        /// Creates a new object that is a copy of the current instance.
        /// </summary>
        /// <returns>A new object that is a copy of this instance.</returns>
        public Object Clone()
        {
            TabletDocument _tmp = new TabletDocument();
            _tmp.ContractNumber = this.ContractNumber;
            _tmp.FileName = this.FileName;
            _tmp.DocumentTypeID = this.DocumentTypeID;
            _tmp.DocumentTypeName = this.DocumentTypeName;
            _tmp.SalesAgentID = this.SalesAgentID;
            _tmp.ModifiedDate = this.ModifiedDate;
            _tmp.CreatedDate = this.CreatedDate;
            return _tmp;
        }
        #endregion Clone Method

        #region IValidator Members

        public List<GenericError> IsValid()
        {
            List<GenericError> errors = new List<GenericError>();

            if (String.IsNullOrEmpty(this.ContractNumber))
            {
                errors.Add(new GenericError() { Code = 0, Message = "Contract Number is a required field" });
            }

            if (String.IsNullOrEmpty(this.FileName))
            {
                errors.Add(new GenericError() { Code = 0, Message = "File Name is a required field" });
            }

            if (this.DocumentTypeID == null)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Document Type ID is a required field" });
            }

            if (this.SalesAgentID == null)
            {
                errors.Add(new GenericError() { Code = 0, Message = "Sales Agent ID is a required field" });
            }

            return errors;
        }

        public List<GenericError> IsValidForInsert()
        {
            List<GenericError> errors = new List<GenericError>();

            errors = this.IsValid();

            return errors;
        }

        public List<GenericError> IsValidForUpdate()
        {
            List<GenericError> errors = new List<GenericError>();

            errors = this.IsValid();

            return errors;
        }

        public bool IsStructureValidForInsert()
        {
            return this.IsValid().Count() == 0;
        }

        public bool IsStructureValidForUpdate()
        {
            return this.IsValid().Count() == 0;
        }

        #endregion
    }
}
