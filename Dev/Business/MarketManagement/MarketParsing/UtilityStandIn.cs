namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    using LibertyPower.Business.MarketManagement.UtilityManagement;

    public class UtilityStandIn : Utility
    {
        #region Fields

        private int accountNumberLength;
        private string accountNumberPrefix;
        private ParserSchema parserSchema;
        private UtilityAccountList prospectAccountCandidateList;
        private string utilityCode;

        #endregion Fields

        #region Constructors

        internal UtilityStandIn(string utilityCode, ParserSchema parserSchema, UtilityAccountList prospectAccountCandidateList)
            : base(utilityCode)
        {
            this.utilityCode = utilityCode;
            this.parserSchema = parserSchema;
            this.prospectAccountCandidateList = prospectAccountCandidateList;
        }

        internal UtilityStandIn(string utilityCode, string accountNumberPrefix, int accountNumberLength)
            : base(utilityCode, accountNumberPrefix, accountNumberLength)
        {
            this.utilityCode = utilityCode;
            this.accountNumberLength = accountNumberLength;
            this.accountNumberPrefix = accountNumberPrefix;
        }

        internal UtilityStandIn(string utilityCode)
            : base(utilityCode)
        {
            this.utilityCode = utilityCode;
        }

        #endregion Constructors

        #region Properties

        /// <summary>
        /// Collection of prospect candidate accounts associated with the utility
        /// </summary>
        public UtilityAccountList ProspectAccountCandidates
        {
            get
            {
                return prospectAccountCandidateList;

            }

            set
            {
                prospectAccountCandidateList = value;

            }
        }

        /// <summary>
        /// The excel schema for this UtilityAccount
        /// </summary>
        public ParserSchema Schema
        {
            get
            {
                return parserSchema;

            }

            set
            {
                parserSchema = value;

            }
        }

        #endregion Properties

        #region Methods

        internal void AddUtilityAccount(ProspectAccountCandidate utilityAccount)
        {
            utilityAccount.Validate(this);
            if (prospectAccountCandidateList == null)
                prospectAccountCandidateList = new UtilityAccountList();
            this.prospectAccountCandidateList.Add(utilityAccount);
        }

        #endregion Methods
    }
}