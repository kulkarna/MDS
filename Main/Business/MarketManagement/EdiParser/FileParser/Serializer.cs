namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Configuration;
	using System.IO;

	/// <summary>
	/// Class for serializing objects
	/// </summary>
	public static class Serializer
	{
		/// <summary>
		/// 
		/// </summary>
		/// <param name="ediFile">Edi file object</param>
		/// <param name="fileSuffix">File name suffix</param>
		public static void SerializeEdiFile( EdiFile ediFile, string fileSuffix )
		{
			// boolean indicating whether to serialize
			bool serializeFile = Convert.ToBoolean( ConfigurationManager.AppSettings["SerializeEdiFile"] );
			if( serializeFile )
			{
				string fileGuid = ediFile.FileGuid;

				if( fileSuffix.Length.Equals( 0 ) )
					fileSuffix = fileGuid;

				// name and location of serialized file
				string file = ConfigurationManager.AppSettings["SerializedFile"].Replace( "**ID**", fileSuffix );

				CustomXmlSerializer serializer = new CustomXmlSerializer();
				System.Text.StringBuilder xml = serializer.WriteText( ediFile );

				string xmlString = xml.ToString();
				xmlString = xmlString.Replace( "\"", @"""" ).Replace( "`2", "" );

				TextWriter textWriter = new StreamWriter( file );
				textWriter.Write( xmlString );
				textWriter.Close();
			}
		}

		/// <summary>
		/// Serializes eid file list
		/// </summary>
		/// <param name="list">Edi file list</param>
		/// <param name="fileSuffix">File name suffix</param>
		public static void SerializeEdiFileList( EdiFileList list, string fileSuffix )
		{
			// boolean indicating whether to serialize
			bool serializeFile = Convert.ToBoolean( ConfigurationManager.AppSettings["SerializeEdiFile"] );
			if( serializeFile )
			{
				if( fileSuffix.Length.Equals( 0 ) )
					fileSuffix = "ALL";

				// name and location of serialized file
				string file = ConfigurationManager.AppSettings["SerializedFile"].Replace( "**ID**", fileSuffix );

				CustomXmlSerializer serializer = new CustomXmlSerializer();
				System.Text.StringBuilder xml = serializer.WriteText( list );

				string xmlString = xml.ToString();
				xmlString = xmlString.Replace( "\"", @"""" ).Replace( "`2", "" );

				TextWriter textWriter = new StreamWriter( file );
				textWriter.Write( xmlString );
				textWriter.Close();
			}
		}
	}
}
