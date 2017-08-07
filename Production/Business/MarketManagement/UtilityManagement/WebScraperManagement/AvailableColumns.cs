namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;

	internal struct AvailableColumns
	{
            private int index;
            private string name;

            public int Index
            {
                get { return index; }
            }

            public string Name
            {
                get { return name; }
            }

			public AvailableColumns( int index, string name )
            {
                this.index = index;
                this.name = name;
            }
}
}
