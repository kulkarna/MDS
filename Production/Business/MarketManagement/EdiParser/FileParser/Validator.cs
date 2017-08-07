namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.CommonRules;

	/// <summary>
	/// Class that validates file configuration and data.
	/// </summary>
	public static class Validator
    {
        #region Fields

        private const string REFPRT = "REFPRT";

        #endregion

        #region Methods

        /// <summary>
		/// Validates file configuration
		/// </summary>
		/// <param name="dunsNumber">DUNS number</param>
		/// <param name="fileContents">Contents of utility file</param>
		/// <param name="delimiter">Character delimiter</param>
		/// <param name="config">Utility configuration object</param>
		/// <returns>Returns the file configuration data exists business rule.</returns>
		public static FileConfigDataExistsRule ValidateFileConfiguration( string dunsNumber,ref string fileContents, char delimiter, UtilityConfig config )
		{
			FileConfigDataExistsRule rule = new FileConfigDataExistsRule( dunsNumber, ref fileContents, delimiter, config );
			rule.Validate();

			return rule;
		}

		/// <summary>
		/// validates an account
		/// </summary>
		/// <param name="account">account object</param>
		/// <param name="fileType">file type</param>
		/// <returns>true if valid</returns>
		public static bool ValidateEdiFile( ref EdiAccount account, EdiFileType fileType )
		{
			bool isValid = true;

			EdiFileValidRule rule = new EdiFileValidRule(  );
			if( !rule.Validate( ref account, fileType ) )
				isValid = false;

			return isValid;
		}

        /// <summary>
        /// Makea sure the 814 file has a valid rate class field.
        /// </summary>
        /// 
        /// <param name="fieldName">Field name</param>
        /// <param name="account">Edi account</param>
        /// 
        /// <returns>True if the rate class value has been set or it doesn't appear in the file parsed. False otherwise</returns>
        public static bool Validate814RateClass(string fieldName, EdiAccount account)
        {
            if (fieldName == REFPRT && !string.IsNullOrEmpty(account.RateClassNH))
            {
                return true;
            }
            else if (fieldName == REFPRT && string.IsNullOrEmpty(account.RateClass))
            {
                return true;
            }

            return false;
        }

        #endregion
    }
}