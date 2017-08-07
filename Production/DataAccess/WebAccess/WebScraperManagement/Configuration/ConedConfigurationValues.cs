namespace LibertyPower.DataAccess.WebAccess.WebScraperManagement
{
	using System;
	using System.Collections.Generic;
	using System.Text;

	public class ConedConfigurationValues : ConfigurationValues
	{
		private string leftPage;
		private string mainPage;
		private string frameControlPage;
		private string accountInfoHeaderPage;
		private string accounttInfoMenuPage;
		private string alternateBillHistoryPage;

		/// <summary>
		/// Coned's left pane
		/// </summary>
		public string LeftPage
		{
			get { return leftPage; }
			set { leftPage = value; }
		}

		/// <summary>
		/// Coned's main pane
		/// </summary>
		public string MainPage
		{
			get { return mainPage; }
			set { mainPage = value; }
		}

		public string FrameControlPage
		{
			get { return frameControlPage; }
			set { frameControlPage = value; }
		}

		public string AccountInfoHeaderPage
		{
			get { return accountInfoHeaderPage; }
			set { accountInfoHeaderPage = value; }
		}

		public string AccounttInfoMenuPage
		{
			get { return accounttInfoMenuPage; }
			set { accounttInfoMenuPage = value; }
		}

		public string AlternateBillHistoryPage
		{
			get { return alternateBillHistoryPage; }
			set { alternateBillHistoryPage = value; }
		}

	}
}
