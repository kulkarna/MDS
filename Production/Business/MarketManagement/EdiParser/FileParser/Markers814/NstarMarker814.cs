namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for O and R utility
	/// </summary>
    public class NstarMarker814 : StandardMarker814
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public NstarMarker814(string utility)
            : base(utility)
        {
            EffectiveDateCell = 6;
        }
    }
}
