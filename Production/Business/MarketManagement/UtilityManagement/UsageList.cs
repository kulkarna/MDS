using System;
using System.Collections.Generic;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	/// <summary>
	/// The UsageList class inherits from the System.Collections.Generic.List&st;T&gt; 
	/// class. It holds a list of Usage objects.
	/// </summary>
	/// <remarks>
	/// Contrary to the UsageDictionary class, this collection 
	/// can hold duplicate usage for the same billing cycle. It is 
	/// mostly used to retrieve usage from legacy data.
	/// </remarks>
	public class UsageList : List<Usage>
	{
	}
}
