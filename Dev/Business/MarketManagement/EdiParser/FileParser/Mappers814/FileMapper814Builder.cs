namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	/// <summary>
	/// Responsible for building mappers for each utility
	/// </summary>
	public class FileMapper814Builder
	{
		private static FileMapper814Builder instance;

		static FileMapper814Builder()
		{
			instance = new FileMapper814Builder();
		}

		/// <summary>
		/// Singleton instance of the class
		/// </summary>
		public static FileMapper814Builder BuildMapperFor
		{
			get { return instance; }
		}

		/// <summary>
		/// Creates a file mapper for a file of Ace
		/// </summary>
		/// <returns>File mapper for a file of Ace</returns>
		public FileMapper814 Ace
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Ace ); }
		}
        /// <summary>
        /// Creates a file mapper for a file of BANGOR
        /// </summary>
        /// <returns>File mapper for a file of Bangor</returns>
        public FileMapper814 Bangor
        {
            get { return new FileMapper814(EdiAccountMap814Builder.BuildMapFor.Bangor); }
        }
		/// <summary>
		/// Creates a file mapper for a file of Allegheny
		/// </summary>
		/// <returns>File mapper for a file of Allegheny</returns>
		public FileMapper814 Allegmd
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Allegmd ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Bge
		/// </summary>
		/// <returns>File mapper for a file of Bge</returns>
		public FileMapper814 Bge
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Bge ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Cei
		/// </summary>
		/// <returns>File mapper for a file of Cei</returns>
		public FileMapper814 Cei
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Cei ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Coned
		/// </summary>
		/// <returns>File mapper for a file of Coned</returns>
		public FileMapper814 Coned
		{
			get
			{
				return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Coned );
			}
		}

		/// <summary>
		/// Creates a file mapper for a file of Clp
		/// </summary>
		/// <returns>File mapper for a file of Clp</returns>
		public FileMapper814 Clp
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Clp ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Csp
		/// </summary>
		/// <returns>File mapper for a file of Csp</returns>
		public FileMapper814 Csp
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Csp ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Cmp
		/// </summary>
		public FileMapper814 Cmp
		{
			get
			{
				return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Cmp );
			}
		}

		/// <summary>
		/// Creates a file mapper for a file of Dayton
		/// </summary>
		/// <returns>File mapper for a file of Dayton</returns>
		public FileMapper814 Dayton
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Dayton ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Delde
		/// </summary>
		/// <returns>File mapper for a file of Delde</returns>
		public FileMapper814 Delde
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Delde ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Delmd
		/// </summary>
		/// <returns>File mapper for a file of Delmd</returns>
		public FileMapper814 Delmd
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Delmd ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Duke
		/// </summary>
		/// <returns>File mapper for a file of Duke</returns>
		public FileMapper814 Duke
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Duke ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Duq
		/// </summary>
		/// <returns>File mapper for a file of Duq</returns>
		public FileMapper814 Duq
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Duq ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Jcpl
		/// </summary>
		/// <returns>File mapper for a file of Jcpl</returns>
		public FileMapper814 Jcpl
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Jcpl ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Meco
		/// </summary>
		/// <returns>File mapper for a file of Meco</returns>
		public FileMapper814 Meco
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Meco ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Neco
		/// </summary>
		/// <returns>File mapper for a file of Neco</returns>
		public FileMapper814 Neco
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Neco ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Nimo
		/// </summary>
		/// <returns>File mapper for a file of Nimo</returns>
		public FileMapper814 Nimo
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Nimo ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of NStarBos
		/// </summary>
		/// <returns>File mapper for a file of NStarBos</returns>
		public FileMapper814 NStarBos
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.NStarBos ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of NStarCamb
		/// </summary>
		/// <returns>File mapper for a file of Nimo</returns>
		public FileMapper814 NStarCamb
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.NStarCamb ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of NStarComm
		/// </summary>
		/// <returns>File mapper for a file of NStarComm</returns>
		public FileMapper814 NStarComm
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.NStarComm ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Ohed
		/// </summary>
		/// <returns>File mapper for a file of Ohed</returns>
		public FileMapper814 Ohed
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Ohed ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Ohp
		/// </summary>
		/// <returns>File mapper for a file of Ohp</returns>
		public FileMapper814 Ohp
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Ohp ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of PepcoDC
		/// </summary>
		/// <returns>File mapper for a file of PepcoDC</returns>
		public FileMapper814 PepcoDC
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.PepcoDC ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of PepcoMD
		/// </summary>
		/// <returns>File mapper for a file of PepcoMD</returns>
		public FileMapper814 PepcoMD
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.PepcoMD ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of PSeg
		/// </summary>
		/// <returns>File mapper for a file of PSeg</returns>
		public FileMapper814 PSeg
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.PSeg ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Sharyland
		/// </summary>
		/// <returns>File mapper for a file of Sharyland</returns>
		public FileMapper814 Sharyland
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Sharyland ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Toled
		/// </summary>
		/// <returns>File mapper for a file of Toled</returns>
		public FileMapper814 Toled
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Toled ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of UI
		/// </summary>
		/// <returns>File mapper for a file of UI</returns>
		public FileMapper814 UI
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Ui ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of WMECO
		/// </summary>
		/// <returns>File mapper for a file of WMECO</returns>
		public FileMapper814 WMeco
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.WMeco ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Ameren
		/// </summary>
		/// <returns>File mapper for a file of Ameren</returns>
		public FileMapper814 Ameren
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Ameren ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Aepce
		/// </summary>
		/// <returns>File mapper for a file of Aepce</returns>
		public FileMapper814 Aepce
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Aepce ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Aepno
		/// </summary>
		/// <returns>File mapper for a file of Aepno</returns>
		public FileMapper814 Aepno
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Aepno ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Cenhud
		/// </summary>
		/// <returns>File mapper for a file of Cenhud</returns>
		public FileMapper814 Cenhud
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Cenhud ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Comed
		/// </summary>
		/// <returns>File mapper for a file of Comed</returns>
		public FileMapper814 Comed
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Comed ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Ctpen
		/// </summary>
		/// <returns>File mapper for a file of Ctpen</returns>
		public FileMapper814 Ctpen
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Ctpen ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Nant
		/// </summary>
		/// <returns>File mapper for a file of Nant</returns>
		public FileMapper814 Nant
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Nant ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Nyseg
		/// </summary>
		/// <returns>File mapper for a file of Nyseg</returns>
		public FileMapper814 Nyseg
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Nyseg ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Oncor
		/// </summary>
		/// <returns>File mapper for a file of Oncor</returns>
		public FileMapper814 Oncor
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Oncor ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Or
		/// </summary>
		/// <returns>File mapper for a file of Or</returns>
		public FileMapper814 Or
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Or ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Pge
		/// </summary>
		/// <returns>File mapper for a file of Pge</returns>
		public FileMapper814 Pge
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Pge ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Ppl
		/// </summary>
		/// <returns>File mapper for a file of Ppl</returns>
		public FileMapper814 Ppl
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Ppl ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Sce
		/// </summary>
		/// <returns>File mapper for a file of Sce</returns>
		public FileMapper814 Sce
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Sce ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Sdge
		/// </summary>
		/// <returns>File mapper for a file of Sdge</returns>
		public FileMapper814 Sdge
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Sdge ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Txnmp
		/// </summary>
		/// <returns>File mapper for a file of Txnmp</returns>
		public FileMapper814 Txnmp
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Txnmp ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Ugi
		/// </summary>
		/// <returns>File mapper for a file of Ugi</returns>
		public FileMapper814 Ugi
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Ugi ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Unitil
		/// </summary>
		/// <returns>File mapper for a file of Unitil</returns>
		public FileMapper814 Unitil
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Unitil ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of Rge
		/// </summary>
		/// <returns>File mapper for a file of Rge</returns>
		public FileMapper814 Rge
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Rge ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of METED
		/// </summary>
		public FileMapper814 Meted
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Meted ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of PECO
		/// </summary>
		public FileMapper814 Peco
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Peco ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of PENELEC
		/// </summary>
		public FileMapper814 Penelec
		{
			get { return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Penelec ); }
		}

		/// <summary>
		/// Creates a file mapper for a file of WPP
		/// </summary>
		public FileMapper814 Wpp
		{
			get 
			{
				return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.Wpp );
			}
		}

		/// <summary>
		/// Creates a file mapper for a file of PENNPR
		/// </summary>
		public FileMapper814 PennPr
		{
			get
			{
				return new FileMapper814( EdiAccountMap814Builder.BuildMapFor.PennPr );
			}
		}

	}
}
