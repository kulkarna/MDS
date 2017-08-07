using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// Contains codes of all utilities
	/// </summary>
	public class UtilitiesCodes
	{
		// variable of type utility-codes - fct
		private static UtilitiesCodes instance;

		// constructor which sets instance - fct
		static UtilitiesCodes()
		{
			instance = new UtilitiesCodes();
		}

		/// <summary>
		/// Singleton instance of the class
		/// </summary>
		public static UtilitiesCodes CodeOf
		{
			get { return instance; }
		}

		/// <summary>
		/// Gets ACE (ATLANTIC CITY ELECTRIC) utility code
		/// </summary>
		public string Ace { get { return "ACE"; } }

        /// <summary>
        /// Gets BANGOR Utility Code
        /// </summary>
        public string Bangor { get { return "BANGOR"; } }

		/// <summary>
		/// Gets AEP Texas Central (Corpus Christi Area) utility code
		/// </summary>
		public string Aepce { get { return "AEPCE"; } }

		/// <summary>
		/// Gets AEP Texas North (Abilene Area) utility code
		/// </summary>
		public string Aepno { get { return "AEPNO"; } }

		/// <summary>
		/// Gets ALLEGMD (ALLEGHENY POWER) utility code
		/// </summary>
		public string Allegmd { get { return "ALLEGMD"; } }

		/// <summary>
		/// Gets AMEREN ELECTRIC utility code
		/// </summary>
		public string Ameren { get { return "AMEREN"; } }

		/// <summary>
		/// Gets BGE (BALTIMORE GAS AND ELECTRIC) utility code
		/// </summary>
		public string Bge { get { return "BGE"; } }

		/// <summary>
		/// Gets CENHUD (CENTRAL HUDSON) utility code
		/// </summary>
		public string Cenhud { get { return "CENHUD"; } }

		/// <summary>
		/// Gets CEI (CLEVELAND ILLUMINATING) utility code
		/// </summary>
		public string Cei { get { return "CEI"; } }

		/// <summary>
		/// Gets CLP (CONNECTICUT LIGHT AND POWER) utility code
		/// </summary>
		public string Clp { get { return "CL&P"; } }

		/// <summary>
		/// Gets CSP (AEP COLUMBUS SOUTHERN POWER) utility code
		/// </summary>
		public string Csp { get { return "CSP"; } }

		/// <summary>
		/// Gets CMP (CENTRAL MAINE POWER) utility code
		/// </summary>
		public string Cmp
		{
			get { return "CMP"; }
		}

		/// <summary>
		/// Gets COMED (COMMONWEALTH EDISON) utility code
		/// </summary>
		public string Comed { get { return "COMED"; } }

		/// <summary>
		/// Gets CONED (CON EDISON COMPANY OF NEW YORK) utility code
		/// </summary>
		public string Coned
		{
			get { return "CONED"; }
		}

		/// <summary>
		/// Gets Centerpoint Energy (Houston Area) utility code
		/// </summary>
		public string Ctpen { get { return "CTPEN"; } }

		/// <summary>
		/// Gets DAYTON (DAYTON POWER & LIGHT) utility code
		/// </summary>
		public string Dayton { get { return "DAYTON"; } }

		/// <summary>
		/// Gets DELDE (DELMARVA POWER) utility code
		/// </summary>
		public string Delde { get { return "DELDE"; } }

		/// <summary>
		/// Gets DELMD (DELMARVA POWER) utility code
		/// </summary>
		public string Delmd { get { return "DELMD"; } }

		/// <summary>
		/// Gets DUKE (DUKE ENERGY) utility code
		/// </summary>
		public string Duke { get { return "DUKE"; } }

		/// <summary>
		/// Gets DUQ (DUQUESNE LIGHT AND POWER) utility code
		/// </summary>
		public string Duq { get { return "DUQ"; } }

		/// <summary>
		/// Gets JCPL (JERSEY CENTRAL POWER LIGHT) utility code
		/// </summary>
		public string Jcpl { get { return "JCP&L"; } }

		/// <summary>
		/// Gets MECO (MASSACHUSETTS ELECTRIC CO - NATIONAL GRID) utility code
		/// </summary>
		public string Meco { get { return "MECO"; } }

		/// <summary>
		/// Gets NANT (NANTUCKET ELECTRIC CO. - NATIONAL GRID) utility code
		/// </summary>
		public string Nant { get { return "NANT"; } }

		/// <summary>
		/// Gets NECO (NARRANGANSETT ELECTRIC CO. - NATIONAL GRID) utility code
		/// </summary>
		public string Neco { get { return "NECO"; } }

		/// <summary>
		/// Gets NIMO (NIAGRA MOHAK) utility code
		/// </summary>
		public string Nimo { get { return "NIMO"; } }

		/// <summary>
		/// Gets NSTAR-BOS (NSTAR BOSTON EDISON) utility code
		/// </summary>
		public string NStarBos { get { return "NSTAR-BOS"; } }

		/// <summary>
		/// Gets NSTAR-CAMB (NSTAR CAMBRIDGE) utility code
		/// </summary>
		public string NStarCamb { get { return "NSTAR-CAMB"; } }

		/// <summary>
		/// Gets NSTAR-COMM (NSTAR COMMONWEALTH) utility code
		/// </summary>
		public string NStarComm { get { return "NSTAR-COMM"; } }

		/// <summary>
		/// Gets NYSEG (NEW YORK STATE ELECTRIC AND GAS) utility code
		/// </summary>
		public string NySeg { get { return "NYSEG"; } }

		/// <summary>
		/// Gets OHED (OHIO EDISON) utility code
		/// </summary>
		public string Ohed { get { return "OHED"; } }

		/// <summary>
		/// Gets OHP (AEP OHIO POWER) utility code
		/// </summary>
		public string Ohp { get { return "OHP"; } }

		/// <summary>
		/// Gets Oncor Electric Delivery (DFW Area) utility code
		/// </summary>
		public string Oncor { get { return "ONCOR"; } }

		/// <summary>
		/// Gets ORANGE AND ROCKLAND utility code
		/// </summary>
		public string Or { get { return "O&R"; } }

		/// <summary>
		/// Gets PEPCO-DC (POTOMAC ELECTRIC POWER COMPANY DC) utility code
		/// </summary>
		public string PepcoDC { get { return "PEPCO-DC"; } }

		/// <summary>
		/// Gets PEPCO-MD (POTOMAC ELECTRIC POWER COMPANY MARYLAND) utility code
		/// </summary>
		public string PepcoMD { get { return "PEPCO-MD"; } }

		/// <summary>
		/// Gets PGE (PACIFIC GAS AND ELECTRIC COMPANY) utility code
		/// </summary>
		public string Pge { get { return "PGE"; } }

		/// <summary>
		/// Gets PPL (PENNSYLVANIA POWER AND LIGHT) utility code
		/// </summary>
		public string Ppl { get { return "PPL"; } }

		/// <summary>
		/// Gets PSEG (PUBLIC SERVICE ELECTRIC GAS) utility code
		/// </summary>
		public string PSeg { get { return "PSEG"; } }

		/// <summary>
		/// Gets RGE (ROCHESTER GAS ELECTRIC) utility code
		/// </summary>
		public string Rge { get { return "RGE"; } }

		/// <summary>
		/// Gets SCE (SOUTHERN CALIFORNIA EDISON) utility code
		/// </summary>
		public string Sce { get { return "SCE"; } }

		/// <summary>
		/// Gets SDGE (SAN DIEGO GAS AND ELECTRIC) utility code
		/// </summary>
		public string Sdge { get { return "SDGE"; } }

		/// <summary>
		/// Gets SHARYLAND UTILITIES utility code
		/// </summary>
		public string Sharyland { get { return "SHARYLAND"; } }

		/// <summary>
		/// Gets TOLED (TOLEDO EDISON) utility code
		/// </summary>
		public string Toled { get { return "TOLED"; } }

		/// <summary>
		/// Gets TNMP (Texas New Mexico Power Area) utility code
		/// </summary>
		public string Txnmp { get { return "TXNMP"; } }

		/// <summary>
		/// Gets UGI (UGI UTILITIES) utility code
		/// </summary>
		public string Ugi { get { return "UGI"; } }

		/// <summary>
		/// Gets UI (UNITED ILLUMINATING) utility code
		/// </summary>
		public string Ui { get { return "UI"; } }

		/// <summary>
		/// Gets UNITIL (FITCHBURG GAS ELECTRIC CO) utility code
		/// </summary>
		public string Unitil { get { return "UNITIL"; } }

		/// <summary>
		/// Gets WMECO (WESTERN MASSACHUSETTS CO) utility code
		/// </summary>
		public string WMeco { get { return "WMECO"; } }

		/// <summary>
		/// Gets METED (METED (METROPOLITAN EDISON COMPANY)) utility code
		/// </summary>
		public string Meted { get { return "METED"; } }

		/// <summary>
		/// Gets PECO (PECO ENERGY (EXCELON)) utility code
		/// </summary>
		public string Peco { get { return "PECO"; } }

		/// <summary>
		/// Gets PENELEC (PENNSYLVANIA ELECTRIC COMPANY) utility code
		/// </summary>
		public string Penelec { get { return "PENELEC"; } }

		/// <summary>
		/// Gets WEST PENN POWER (ALLEGHENY) utility code
		/// </summary>
		public string Wpp
		{
			get { return "WPP"; }
		}

		/// <summary>
		/// Gets PENNPR (PENN POWER) utility code
		/// </summary>
		public string PennPr
		{
			get { return "PENNPR"; }
		}

	}
}
