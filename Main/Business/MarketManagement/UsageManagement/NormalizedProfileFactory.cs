using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
	/// <summary>
	/// Returns list of normalized profiles.
	/// </summary>
	/// <remarks>This is a Factory class used to
	/// retrieve lists of normalized profiles.</remarks>
	public static class NormalizedProfileFactory
	{
		/// <summary>
		/// Method that gets a dictionary of normalized profiles.
		/// </summary>
		/// <param name="peakProfileDictionary">Generic dictionary collection of peak profiles.</param> 
		/// <returns>Generic dictionary collection of normalized profiles.</returns>
		public static NormalizedProfileDictionary GetNormalizedProfileDictionary( PeakProfileDictionary peakProfileDictionary )
		{
			NormalizedProfileDictionary normalizedProfileDictionary = new NormalizedProfileDictionary();
			NormalizedProfile normalizedProfle;
			Decimal normalizedDailyProfileValue;
			Decimal dailyProfileValueTotal = 0m;

			// sum daily profile values
			foreach( PeakProfile pp in peakProfileDictionary.Values )
				dailyProfileValueTotal += pp.DailyValue;

			// build nomalized profiles, add to list
			foreach( PeakProfile pp in peakProfileDictionary.Values )
			{
				normalizedDailyProfileValue = pp.DailyValue / dailyProfileValueTotal;
				normalizedProfle = new NormalizedProfile( pp.ProfileDate, normalizedDailyProfileValue );
				normalizedProfileDictionary.Add( pp.ProfileDate, normalizedProfle );
			}

			return normalizedProfileDictionary;
		}
	}
}
