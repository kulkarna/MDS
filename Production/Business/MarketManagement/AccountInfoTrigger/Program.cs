using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Text;
using System.Security.Principal;
using LibertyPower.Business.MarketManagement.AccountInfo;

namespace AccountInfoTrigger
{
	class Program
	{
		static void Main( string[] args )
		{
			string msg = string.Empty;

			bool bSuccess = ProcessFiles.Run( out msg );

			if( bSuccess )
				Console.WriteLine( "Files processed successfully" );
			else
				Console.WriteLine( "Error processing files: " + msg );

			Console.ReadLine();


		}



	}
}
