﻿namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Marker for SHARYLAND utility
	/// </summary>
	public class SharylandMarker814 : StandardMarker814
	{
		/// <summary>
		/// Default constructor
		/// </summary>
		public SharylandMarker814()
			: base( UtilitiesCodes.CodeOf.Sharyland )
		{
			this.AccountNumberCell = 3;
			this.AccountStatusCell = 3;
		}
	}
}
