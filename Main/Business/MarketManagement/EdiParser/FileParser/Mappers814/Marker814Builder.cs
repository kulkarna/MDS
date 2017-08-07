namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Responsible for the creation of the markers for each utility. It implements the singleton pattern.
	/// </summary>
	public class Marker814Builder
	{
		private static Marker814Builder instance;

		// default constructor which returns a single instance of the class
		static Marker814Builder()
		{
			instance = new Marker814Builder();
		}

		/// <summary>
		/// Singleton instance of the class
		/// </summary>
		public static Marker814Builder CreateMarkerFor
		{
			get { return instance; }
		}

		private Marker814Builder()
		{
		}

		/// <summary>
		/// Creates a class map for ace
		/// </summary>
		/// <returns>Class map for ace</returns>
		public StandardMarker814 Ace
		{
			get { return new AceMarker814(); }
		}

		/// <summary>
		/// Creates a class map for allegheny
		/// </summary>
		/// <returns>Class map for allegheny</returns>
		public StandardMarker814 Allegmd
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Allegmd ); }
		}

		/// <summary>
		/// Creates a class map for bge
		/// </summary>
		/// <returns>Class map for bge</returns>
		public StandardMarker814 Bge
		{
			get { return new BgeMarker814(); }
		}

		/// <summary>
		/// Creates a class map for Cei
		/// </summary>
		/// <returns>Class map for Cei</returns>
		public StandardMarker814 Cei
		{
			get { return new OHMarker814( UtilitiesCodes.CodeOf.Cei ); }
		}

		/// <summary>
		/// Creates a class map for Clp
		/// </summary>
		/// <returns>Class map for Clp</returns>
		public StandardMarker814 Clp
		{
			get { return new CLPMarker814( UtilitiesCodes.CodeOf.Clp ); }
		}

		/// <summary>
		/// Creates a class map for Csp
		/// </summary>
		/// <returns>Class map for Csp</returns>
		public StandardMarker814 Csp
		{
			get { return new OHMarker814( UtilitiesCodes.CodeOf.Csp ); }
		}


		/// <summary>
		/// Creates a class map for Cmp
		/// </summary>
		/// <returns>Class map for Cmp</returns>
		public StandardMarker814 Cmp
		{
			get
			{
				return new StandardMarker814( UtilitiesCodes.CodeOf.Cmp );
			}
		}

        /// <summary>
        /// Creates a class map for Bangor
        /// </summary>
        /// <returns>Class map for Banor</returns>
        public StandardMarker814 Bangor
        {
            get
            {
                return new StandardMarker814(UtilitiesCodes.CodeOf.Bangor);
            }
        }

		/// <summary>
		/// Creates a class map for Dayton
		/// </summary>
		/// <returns>Class map for Dayton</returns>
		public StandardMarker814 Dayton
		{
			get { return new OHMarker814( UtilitiesCodes.CodeOf.Dayton ); }
		}

		/// <summary>
		/// Creates a class map for Delde
		/// </summary>
		/// <returns>Class map for Delde</returns>
		public StandardMarker814 Delde
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Delde ); }
		}

		/// <summary>
		/// Creates a class map for Delmd
		/// </summary>
		/// <returns>Class map for Delmd</returns>
		public StandardMarker814 Delmd
		{
			get { return new DelmdMarker814(); }
		}

		/// <summary>
		/// Creates a class map for Duke
		/// </summary>
		/// <returns>Class map for Duke</returns>
		public StandardMarker814 Duke
		{
			get { return new OHMarker814( UtilitiesCodes.CodeOf.Duke ); }
		}

		/// <summary>
		/// Creates a class map for Duq
		/// </summary>
		/// <returns>Class map for Delde</returns>
		public StandardMarker814 Duq
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Duq ); }
		}

		/// <summary>
		/// Creates a class map for Jcpl
		/// </summary>
		/// <returns>Class map for Jcpl</returns>
		public StandardMarker814 Jcpl
		{
			get { return new JcplMarker814(); }
		}

		/// <summary>
		/// Creates a class map for Meco
		/// </summary>
		/// <returns>Class map for Meco</returns>
		public StandardMarker814 Meco
		{
			get { return new MecoMarker814(); }
		}

		/// <summary>
		/// Creates a class map for Neco
		/// </summary>
		/// <returns>Class map for Neco</returns>
		public StandardMarker814 Neco
		{
			get { return new NecoMarker814(); }
		}

		/// <summary>
		/// Creates a class map for Nimo
		/// </summary>
		/// <returns>Class map for Nimo</returns>
		public StandardMarker814 Nimo
		{
			get { return new NyMarker814( UtilitiesCodes.CodeOf.Nimo ); }
		}

		/// <summary>
		/// Creates a class map for NStarBos
		/// </summary>
		/// <returns>Class map for NStarBos</returns>
		public StandardMarker814 NStarBos
		{
			get { return new NstarMarker814( UtilitiesCodes.CodeOf.NStarBos ); }
		}

		/// <summary>
		/// Creates a class map for NStarCamb
		/// </summary>
		/// <returns>Class map for NStarCamp</returns>
		public StandardMarker814 NStarCamb
		{
            get { return new NstarMarker814(UtilitiesCodes.CodeOf.NStarCamb); }
		}

		/// <summary>
		/// Creates a class map for NStarComm
		/// </summary>
		/// <returns>Class map for NStarComm</returns>
		public StandardMarker814 NStarComm
		{
            get { return new NstarMarker814(UtilitiesCodes.CodeOf.NStarComm); }
		}

		/// <summary>
		/// Creates a class map for Ohed
		/// </summary>
		/// <returns>Class map for Ohed</returns>
		public StandardMarker814 Ohed
		{
			get { return new OHMarker814( UtilitiesCodes.CodeOf.Ohed ); }
		}

		/// <summary>
		/// Creates a class map for Ohp
		/// </summary>
		/// <returns>Class map for Ohp</returns>
		public StandardMarker814 Ohp
		{
			get { return new OHMarker814( UtilitiesCodes.CodeOf.Ohp ); }
		}

		/// <summary>
		/// Creates a class map for PepcoDC
		/// </summary>
		/// <returns>Class map for PepcoDC</returns>
		public StandardMarker814 PepcoDC
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.PepcoDC ); }
		}

		/// <summary>
		/// Creates a class map for PepcoMD
		/// </summary>
		/// <returns>Class map for PepcoMD</returns>
		public StandardMarker814 PepcoMD
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.PepcoMD ); }
		}

		/// <summary>
		/// Creates a class map for PSeg
		/// </summary>
		/// <returns>Class map for PSeg</returns>
		public StandardMarker814 PSeg
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.PSeg ); }
		}

		/// <summary>
		/// Creates a class map for Sharyland
		/// </summary>
		/// <returns>Class map for Sharyland</returns>
		public StandardMarker814 Sharyland
		{
			get { return new SharylandMarker814(); }
		}

		/// <summary>
		/// Creates a class map for Toled
		/// </summary>
		/// <returns>Class map for Toled</returns>
		public StandardMarker814 Toled
		{
			get { return new OHMarker814( UtilitiesCodes.CodeOf.Toled ); }
		}

		/// <summary>
		/// Creates a class map for UI
		/// </summary>
		/// <returns>Class map for UI</returns>
		public StandardMarker814 Ui
		{
            get { return new CLPMarker814(UtilitiesCodes.CodeOf.Ui); }
		}

		/// <summary>
		/// Creates a class map for WMECO
		/// </summary>
		/// <returns>Class map for WMECO</returns>
		public StandardMarker814 WMeco
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.WMeco ); }
		}

		/// <summary>
		/// Creates a class map for Ameren
		/// </summary>
		/// <returns>Class map for Ameren</returns>
		public StandardMarker814 Ameren
		{
			get { return new ILMarker814( UtilitiesCodes.CodeOf.Ameren ); }
		}

		/// <summary>
		/// Creates a class map for AEPCE
		/// </summary>
		/// <returns>Class map for AEPCE</returns>
		public StandardMarker814 Aepce
		{
			get { return new AepceMarker814(); }
		}

		/// <summary>
		/// Creates a class map for AEPNO
		/// </summary>
		/// <returns>Class map for AEPNO</returns>
		public StandardMarker814 Aepno
		{
			get { return new AepnoMarker814(); }
		}

		/// <summary>
		/// Creates a class map for CENHUD
		/// </summary>
		/// <returns>Class map for Cenhud</returns>
		public StandardMarker814 Cenhud
		{
			get { return new NyMarker814( UtilitiesCodes.CodeOf.Cenhud ); }
		}

		/// <summary>
		/// Creates a class map for Comed
		/// </summary>
		/// <returns>Class map for Comed</returns>
		public StandardMarker814 Comed
		{
			get { return new ILMarker814( UtilitiesCodes.CodeOf.Comed ); }
		}

		/// <summary>
		/// Creates a class map for Coned
		/// </summary>
		/// <returns>Class map for Coned</returns>
		public StandardMarker814 Coned
		{
			get { return new NyMarker814( UtilitiesCodes.CodeOf.Coned ); }
		}

		/// <summary>
		/// Creates a class map for Ctpen
		/// </summary>
		/// <returns>Class map for Ctpen</returns>
		public StandardMarker814 Ctpen
		{
			get { return new CtpenMarker814(); }
		}

		/// <summary>
		/// Creates a class map for Nant
		/// </summary>
		/// <returns>Class map for Nant</returns>
		public StandardMarker814 Nant
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Nant ); }
		}

		/// <summary>
		/// Creates a class map for Nyseg
		/// </summary>
		/// <returns>Class map for Nyseg</returns>
		public StandardMarker814 Nyseg
		{
			get { return new NysegMarker814(); }
		}

		/// <summary>
		/// Creates a class map for Oncor
		/// </summary>
		/// <returns>Class map for Oncor</returns>
		public StandardMarker814 Oncor
		{
			get { return new OncorMarker814(); }
		}

		/// <summary>
		/// Creates a class map for OR
		/// </summary>
		/// <returns>Class map for OR</returns>
		public StandardMarker814 Or
		{
			get { return new ORMarker814(); }
		}

		/// <summary>
		/// Creates a class map for PGE
		/// </summary>
		/// <returns>Class map for PGE</returns>
		public StandardMarker814 Pge
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Pge ); }
		}

		/// <summary>
		/// Creates a class map for Ppl
		/// </summary>
		/// <returns>Class map for Ppl</returns>
		public StandardMarker814 Ppl
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Ppl ); }
		}

		/// <summary>
		/// Creates a class map for SCE
		/// </summary>
		/// <returns>Class map for SCE</returns>
		public StandardMarker814 Sce
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Sce ); }
		}

		/// <summary>
		/// Creates a class map for SDGE
		/// </summary>
		/// <returns>Class map for SDGE</returns>
		public StandardMarker814 Sdge
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Sdge ); }
		}

		/// <summary>
		/// Creates a class map for TXNMP
		/// </summary>
		/// <returns>Class map for TXNMP</returns>
		public StandardMarker814 Txnmp
		{
			get { return new TxnmpMarker814(); }
		}

		/// <summary>
		/// Creates a class map for UGI
		/// </summary>
		/// <returns>Class map for UGI</returns>
		public StandardMarker814 Ugi
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Ugi ); }
		}

		/// <summary>
		/// Creates a class map for Unitil
		/// </summary>
		/// <returns>Class map for Unitil</returns>
		public StandardMarker814 Unitil
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Unitil ); }
		}

		/// <summary>
		/// Creates a class map for Rge
		/// </summary>
		/// <returns>Class map for Rge</returns>
		public StandardMarker814 Rge
		{
			get { return new RgeMarker814(); }
		}

		/// <summary>
		/// Creates a class map for METED
		/// </summary>
		public StandardMarker814 Meted
		{
			get
			{
				return new MetedMarker814();
			}
		}

		/// <summary>
		/// Creates a class map for PECO
		/// </summary>
		public StandardMarker814 Peco
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.Peco ); }
		}

		/// <summary>
		/// Creates a class map for PENELEC
		/// </summary>
		public StandardMarker814 Penelec
		{
			get { return new PenelecMarker814(); }
		}

		/// <summary>
		/// Creates a class map for WPP
		/// </summary>
		public StandardMarker814 Wpp
		{
			get
			{
				return new WppMarker814();
			}
		}

		/// <summary>
		/// Creates a class map for PENNPR
		/// </summary>
		public StandardMarker814 PennPr
		{
			get { return new StandardMarker814( UtilitiesCodes.CodeOf.PennPr ); }
		}

	}
}
