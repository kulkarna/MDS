using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
	public enum ProductSubCategory
	{
		[Description( "Custom" )]
		Custom,
		[Description( "Portfolio" )]
		Portfolio,
		[Description( "Block Indexed" )]
		BlockIndexed,
		[Description( "Indexed" )]
		Indexed,
		[Description( "Fixed" )]
		Fixed,
		[Description( "Fixed Adder" )]
		FixedAdder,
		[Description( "Hybrid" )]
		Hybrid
	}
}
