namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for O and R utility
	/// </summary>
    public class CLPMarker814 : StandardMarker814
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public CLPMarker814(string utility)
            : base(utility)
        {
            EffectiveDateCell = 6;
        }
    }
}
