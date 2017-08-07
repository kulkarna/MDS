using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace UsageFileProcessor.Entities
{
    public class ParserUtility : Utility
    {
                 #region Fields

        private int accountNumberLength;
        private string accountNumberPrefix;
        private ParserSchema parserSchema;
        private UtilityAccountList accountList;
        private string utilityCode;

        #endregion Fields

        #region Constructors

        internal ParserUtility(string utilityCode, ParserSchema parserSchema, UtilityAccountList accountList)
            : base(utilityCode)
        {
            this.utilityCode = utilityCode;
            this.parserSchema = parserSchema;
            this.accountList = accountList;
        }

        internal ParserUtility(string utilityCode, string accountNumberPrefix, int accountNumberLength)
            : base(utilityCode, accountNumberPrefix, accountNumberLength)
        {
            this.utilityCode = utilityCode;
            this.accountNumberLength = accountNumberLength;
            this.accountNumberPrefix = accountNumberPrefix;
        }

        internal ParserUtility(string utilityCode)
            : base(utilityCode)
        {
            this.utilityCode = utilityCode;
        }

        #endregion Constructors

        #region Properties

        /// <summary>
        /// Collection of prospect candidate accounts associated with the utility
        /// </summary>
        public UtilityAccountList AccountList
        {
            get
            {
                return accountList;

            }

            set
            {
                accountList = value;

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

        internal void AddUtilityAccount(ParserAccount utilityAccount)
        {
            utilityAccount.Validate(this);
            if (accountList == null)
                accountList = new UtilityAccountList();
            this.accountList.Add(utilityAccount);
        }

        #endregion Methods
    }
}