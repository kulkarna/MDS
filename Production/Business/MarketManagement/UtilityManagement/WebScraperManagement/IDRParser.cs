using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	public abstract class IDRParser
	{
		string utility;
		string list_Start_Point;
		string content;
		char delimiter;
		IList<IDRAccount> accountstList = new List<IDRAccount>();

		public DateTime uploadDate;

		string user = string.Empty;
        public enum eTypes { IDR_PECO };

		//static Dictionary<string, IDRParser> dicParsers = new Dictionary<string, IDRParser>();

		/// <summary>
		/// Get the parser instance depending on the type passed
		/// </summary>
		/// <param name="type">type: IDR_PECO</param>
		/// <param name="content">Text file content</param>
		/// <returns></returns>
		public static IDRParser GetParser( string type, string content )
		{
            if (type.Equals(eTypes.IDR_PECO.ToString()))
                return new IDRPecoParser(content);

            return null;

			/*if( !dicParsers.ContainsKey( "IDR_PECO" ) )
				dicParsers.Add( "IDR_PECO", IDRPecoParser.GetInstance( content ) );

			if( !dicParsers.Keys.Contains( type ) )
				return null;
			return dicParsers[type];*/
		}

		/// <summary>
		/// Constructor of the IDRParser class: assign the class its properties
		/// </summary>
		/// <param name="utility">utility/type: IDR_PECO</param>
		/// <param name="list_Start_Point">List starting point within the content</param>
		/// <param name="content">text file content</param>
		/// <param name="delimiter">column delimiter</param>
		public IDRParser( string utilityType, string listStartPoint, string contentList, char delimiterList )
		{
			utility = utilityType;
			list_Start_Point = listStartPoint;
			content = contentList;
			delimiter = delimiterList;
		}

		/// <summary>
		/// Parse the content and save it into the IDRAccount then in the DB and return a message indicating explaining the status of the process
		/// </summary>
		/// <param name="message">message indicating a status of the process</param>
		/// <returns>False: issue parsing the file, True: file was parsed successfully</returns>
		public bool Parse( out string message )
		{
			message = string.Empty;
			int iAccounts = 0;
			user = (string) System.Security.Principal.WindowsIdentity.GetCurrent().Name.Split( '\\' ).GetValue( 1 );
			IDRUtility idrUility = new IDRUtility( utility );

			using( StringReader accountReader = new StringReader( content ) )
			{
				//Read till the end of the file is encountered
				string str = accountReader.ReadLine();
				bool listStarted = false;

				//get upload date: it is saved in the first line of the text file: PECO Interval Metered Accounts as of 1/14/2011
				GetUploadDate( str );

				//if the file is already uploaded, retrun an error
				if( FileAlreadyUploaded( idrUility ) )
				{
					accountReader.Close();
					message= "The current file has been already saved to the database. The file's upload date is: " + uploadDate.ToString() + ".\r\nThis is the latest version of the file, the database update will be aborted";
					return false;
				}

				if( idrUility.MoveAccountsToTempLocation() )
				{
					if( !idrUility.DeleteAllAccounts() )
					{
						accountReader.Close();
						message = "Error deleting the existing accounts. Database update will be aborted.";
						return false;
					}
				}
				else
				{
					accountReader.Close();
					message = "Error moving the existing accounts to the temp location. Database update will be aborted.";
					return false;
				}

				//loop through the file to get the list of accounts
				while( str != null )
				{
					if( listStarted )
					{
						iAccounts++;
						retrieveData( str );
					}
					else if( str.StartsWith( list_Start_Point ) )
						listStarted = true;

					str = accountReader.ReadLine();
				}
				//Close the reader
				accountReader.Close();
			}
			//check the number of accounts found against the number the accounts saved to the DB
			if( iAccounts != accountstList.Count() )
			{
				message = "Number of accounts in the file does not match the number of accounts saved to the database";
				return false;
			}

			idrUility.DeleteTempData();
			message = "All accounts ( " + iAccounts.ToString() + " ) have been saved to the database";
			return true;
			
		}

		/// <summary>
		/// For each line in the list, retrieve the data and save to the db
		/// </summary>
		/// <param name="str">line in the list</param>
		private void retrieveData( string str )
		{
			string[] line;

			line = str.Split( delimiter );
			if( line == null || line.Count() < 2 )
				return;

			IDRAccount account = new IDRAccount();

			//assign the utility ID
			account.UtilityID = utility;

			//get the account number
			account.AccountNumber = line[0].ToString();

			//get the IDR start date
			DateTime dt;
			DateTime.TryParse( line[1], out dt );
			account.IDRStartDate = dt;

			//assign the upload date
			account.SiteUploadDate = uploadDate;

			//assign the Create date
			account.CreateDate = DateTime.Now;

			//set the user
			account.User = user;

			//update the database
			if( updateDB( account ) )
				accountstList.Add( account );
		}

		/// <summary>
		/// Check if the current file has been uploaded to the DB already
		/// </summary>
		/// <returns>True if the file is uploaded already. False if the file is not uploaded</returns>
		private bool FileAlreadyUploaded( IDRUtility idrUtility )
		{
			DateTime lastUploadDate = idrUtility.GetLatestUploadedDate();
			if( uploadDate > lastUploadDate )
				return false;
			return true;
		}

		/// <summary>
		/// get the upload date from the text content, the location might vary for each utiltiy. this method will be overriden by each child parser
		/// </summary>
		/// <param name="str">line item that includes the date</param>
		public abstract void GetUploadDate(string str);

		/// <summary>
		/// Send the command to update the account in the DB
		/// </summary>
		/// <returns>true if database update was successful</returns>
		private bool updateDB(IDRAccount act)
		{
			int i = IDRSQL.IDRAccountsUpdate( act.UtilityID, act.AccountNumber, act.IDRStartDate, act.SiteUploadDate, act.CreateDate, act.User );
			if( i < 1 )
				return false;
			return true;
		}

	}
}
