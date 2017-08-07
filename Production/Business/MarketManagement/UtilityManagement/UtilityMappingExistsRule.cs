namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Runtime.InteropServices;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.Business.CommonBusiness.CommonHelper;

	/// <summary>
	/// Class that ensures that all mapping data exists
	/// </summary>
	[Guid( "3B1E8F63-B398-4608-9BF4-FFD42D3B1AFF" )]
	public class UtilityMappingExistsRule : BusinessRule
	{
		private UtilityAccount account;

		/// <summary>
		/// Constructor that takes a utility account object.
		/// </summary>
		/// <param name="account">Utility account object</param>
		public UtilityMappingExistsRule( UtilityAccount account )
			: base( "Utility Mapping Exists Rule", BrokenRuleSeverity.Error )
		{
			this.account = account;
		}

		/// <summary>
		/// Validates data returning success or not as a boolean value.
		/// </summary>
		/// <returns>Returns success or not of data validation as a boolean value.</returns>
		public override bool Validate()
		{
			string format = "";

			if( account.UtilityMapping == null )
			{
				format = "Utility mapping class not found for account {0}.";
				AddException( new BrokenRuleException( this, String.Format( format, account.AccountNumber ), BrokenRuleSeverity.Error ) );
			}
			else
			{
				UtilityMapping mapping = account.UtilityMapping;
				UtilityClassMappingList utilityClassMappings = mapping.UtilityClassMappingList;
				UtilityZoneMappingList utilityZoneMappings = mapping.UtilityZoneMappingList;
				UtilityClassMappingDeterminantList utilityClassDeterminants = mapping.UtilityClassMappingDeterminantList;

				if( (utilityClassMappings == null || utilityClassMappings.Count == 0) && (utilityZoneMappings == null || utilityZoneMappings.Count == 0) )
				{
					format = "Utility mappings not found for account {0}.";
					AddException( new BrokenRuleException( new UtilityMappingExistsRule( account ), String.Format( format, account.AccountNumber ), BrokenRuleSeverity.Error ) );
				}
				if( utilityClassDeterminants == null || utilityClassDeterminants.Count == 0 )
				{
					format = "Utility class determinant(s) not found for account {0}.";
					AddException( new BrokenRuleException( new UtilityMappingExistsRule( account ), String.Format( format, account.AccountNumber ), BrokenRuleSeverity.Error ) );
				}
				else
				{
					foreach( UtilityClassMappingDeterminant determinant in utilityClassDeterminants )
					{
						UtilityClassMappingResultantList results = determinant.UtilityClassMappingResultantList;
						if( results == null || results.Count == 0 )
						{
							format = "Utility class resultant(s) not found for account {0}, determinant {1}.";
							AddException( new BrokenRuleException( new UtilityMappingExistsRule( account ), String.Format( format, account.AccountNumber, determinant.Driver ), BrokenRuleSeverity.Error ) );
						}
					}
				}
			}
			return this.Exception == null;
		}

		private void AddException( BrokenRuleException exception )
		{
			if( this.Exception == null )
				this.SetException( "Utility mapping data is missing." );

			this.DefaultSeverity = BrokenRuleSeverity.Error;

			this.AddDependentException( exception );
		}
	}
}
