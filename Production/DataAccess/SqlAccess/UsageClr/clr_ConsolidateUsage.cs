using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
using System.Net;

public partial class StoredProcedures
{
	[Microsoft.SqlServer.Server.SqlProcedure]
	public static void clr_ConsolidateUsage( string url, string accountNumber, string utilityCode )
	{
		string format = "account={0}&utility={1}";

		utilityCode = utilityCode.Replace( '&', '~' );

		HttpWebRequest request = (HttpWebRequest) WebRequest.Create( url );
		request.Method = "POST";
		request.ContentType = "application/x-www-form-urlencoded";
		request.Timeout = 3600000;

		StreamWriter writer = new StreamWriter( request.GetRequestStream() );
		writer.Write( String.Format( format, accountNumber, utilityCode ) );
		writer.Close();

		//SqlContext.Pipe.Send( url );	//test
		//SqlContext.Pipe.Send( String.Format( format, accountNumber, utilityCode, processId, isRenewal ) );	//test

		StreamReader reader = new StreamReader( request.GetResponse().GetResponseStream() );
		string data = reader.ReadToEnd();
		reader.Close();

		if( data.Contains( "true" ) )
			data = "Success";
		else
			data = "Failure";

		SqlContext.Pipe.Send( data );
	}
};
