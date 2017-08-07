﻿namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for O and R utility
	/// </summary>
    public class OHMarker814 : StandardMarker814
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public OHMarker814(string utility)
            : base(utility)
        {
            IcapEffectiveDateCell = 2;
            TcapEffectiveDateCell = 2;
        }
    }
}
