namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;
	using System.ComponentModel;

	/// <summary>
	/// Account type
	/// </summary>
	[Serializable]
    public enum AccountType
    {
		/// <summary>
		/// Residential
		/// </summary>
		[Description( "Residential" )]
        Residential,

		/// <summary>
		/// Commercial
		/// </summary>
		[Description( "Commercial" )]
        Smb,

		/// <summary>
		/// Large Commercial Industrial
		/// </summary>
		[Description( "Large Commercial Industrial" )]
        Lci,

        /// <summary>
        /// Small Office Home Office
        /// </summary>
        [Description("Small Office Home Office")]
        Soho,
    }
}
