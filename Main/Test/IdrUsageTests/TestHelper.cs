using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace IdrUsageTests
{
	public static class TestHelper
	{
		public static DataRow CreateRow( DataTable content, string utilityName, string accountNumber, string meterNumber, DateTime dateTime )
		{
			var row = content.NewRow();

			//Utility name
			row[0] = utilityName;

			//Account
			row[1] = accountNumber;

			//Meter
			row[2] = meterNumber;

			//Recorder
			row[3] = "";

			//Unit of measurement
			row[4] = "kWh";

			//Date
			row[5] = dateTime;

			var rand = new Random();

			//Add random metering reads
			for( var i = 6; i < 30; i++ )
				row[i] = rand.Next( 2000, 10000 );

			return row;
		}

		public static DataTable CreateBaseDataTable()
		{
			var result = new DataTable();

			for( var i = 0; i < 30; i++ )
				result.Columns.Add( string.Format("Column{0}", i + 1) );

            var row = result.NewRow();

            //Utility name
            row[0] = "Utility";

            //Account
            row[1] = "Account";

            //Meter
            row[2] = "Meter";

            //Recorder
            row[3] = "Recorder";

            //Unit of measurement
            row[4] = "Unit";

            //Date
            row[5] = "Date";

			for( var i = 1; i < 25; i++ )
				row[5 + i] = string.Format("Hour {0:#00}", i);

			result.Rows.Add( row );

			return result;
		}
	}
}
