using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
	public enum FormatType
	{
		Single = 0,
        Single15 = 5,
        Single30 = 6,
        Single60 = 7,
		Multiple = 1,
		Multiple15 = 2,
		Multiple30 = 3,
		Multiple60 = 4,
        Single_vertical60 = 8,
    }
}
