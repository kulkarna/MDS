using System;
using System.Runtime.InteropServices;
using LibertyPower.Business.CommonBusiness.CommonRules;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// Rule to ensure that load shape id exists
	/// </summary>
	[Guid( "6451F78A-8730-4c9b-97CA-85E2CB88A09C" )]
	public class LoadShapeIdExistsRule : BusinessRule
	{
		private string accountNumber;
		private string utilityCode;
		private string loadShapeId;

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="accountNumber">Identifier of account</param>
		/// <param name="loadShapeId">Load Shape ID</param>
		public LoadShapeIdExistsRule( string accountNumber, string loadShapeId )
			: base( "Load Shape Id Exists Rule", BrokenRuleSeverity.Error )
		{
			this.accountNumber = accountNumber;
			this.loadShapeId = loadShapeId;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="accountNumber">Identifier of account</param>
		/// <param name="utilityCode">Identifier of utility</param>
		/// <param name="loadShapeId">Load Shape ID</param>
		public LoadShapeIdExistsRule( string accountNumber, string utilityCode, string loadShapeId )
			: base( "Load Shape Id Exists Rule", BrokenRuleSeverity.Error )
		{
			this.accountNumber = accountNumber;
			this.utilityCode = utilityCode;
			this.loadShapeId = loadShapeId;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		public override bool Validate()
		{
			if( (this.loadShapeId == null) || (this.loadShapeId.Length == 0) )
			{
				string format;
				string reason;

				if( this.utilityCode != null )
				{
                    format = "Load Shape ID for account {0}/({1} is blank. Please specify and ensure profile exists.";
					reason = string.Format( format, this.accountNumber, this.utilityCode );
				}
				else
				{
                    format = "Load Shape ID for account {0} is blank. Please specify and ensure profile exists.";
					reason = string.Format( format, this.accountNumber );
				}

				this.SetException( reason );
			}

			return this.Exception == null;
		}
	}
}
