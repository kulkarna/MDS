namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.MarketManagement.UtilityManagement;
	using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;

	/// <summary>
	/// Mapper class determines specific utility mapper to use.
	/// </summary>
	public static class Mapper
	{

		/// <summary>
		/// Get the mapper depending on the utility code and market code
		/// </summary>
		/// <param name="utilityCode">the utility code</param>
		/// <param name="marketCode">the mapper code</param>
		/// <returns>Mapper instances</returns>
		public static MapperBase GetMapper( string utilityCode, string marketCode )
		{
			utilityCode = utilityCode.ToUpper();
			MapperBase mapper = null;
			switch( utilityCode )
			{
				case "ACE":
					{
                        // Abhi Kulkarni (1/23/2015): Per Suzanne, DelDE, DelMD and ACE use the same format as PEPCO
                        //mapper = new AceMapper867(utilityCode, marketCode);
                        mapper = new PepcodcMapper867(utilityCode, marketCode);
                        break;
					}
				case "AEPCE":
					{
						mapper = new AepceMapper867( utilityCode, marketCode );
						break;
					}
				case "AEPNO":
					{
						mapper = new AepnoMapper867( utilityCode, marketCode );
						break;
					}
				case "ALLEGMD":
					{
						mapper = new AlleghenyMapper867( utilityCode, marketCode );
						break;
					}
				case "AMEREN":
					{
						mapper = new AmerenMapper867( utilityCode, marketCode );
						break;
					}
				case "BGE":
					{
						mapper = new BgeMapper867( utilityCode, marketCode );
						break;
					}
				case "CEI":
					{
						mapper = new OhioGeneric( utilityCode, marketCode );
						break;
					}
				case "CENHUD":
					{
						mapper = new CenhudMapper867( utilityCode, marketCode );
						break;
					}
				case "CL&P":
					{
						mapper = new ClpMapper867( utilityCode, marketCode );
						break;
					}
                case "BANGOR":
                    {
                        mapper = new BangorMapper867(utilityCode, marketCode);
                        break;
                    }
				case "CMP":
					{
						mapper = new CmpMapper867( utilityCode, marketCode );
						break;
					}
				case "COMED":
					{
						mapper = new ComedMapper867( utilityCode, marketCode );
						break;
					}
				case "CONED":
					{
						mapper = new ConedMapper867(utilityCode, marketCode);
						break;
					}
				case "CSP":
					{
						mapper = new CspMapper867( utilityCode, marketCode );
						break;
					}
				case "CTPEN":
					{
						mapper = new CtpenMapper867( utilityCode, marketCode );
						break;
					}
				case "DAYTON":
					{
						mapper = new DaytonMapper867( utilityCode, marketCode );
						break;
					}
				case "DELMD":
				case "DELDE":
					{
                        // Abhi Kulkarni (1/23/2015): Per Suzanne, DelDE, DelMD and ACE use the same format as PEPCO
						//mapper = new DelmarvaMapper867( utilityCode, marketCode );
                        mapper = new PepcodcMapper867(utilityCode, marketCode);
						break;
					}
				case "DUKE":
					{
						mapper = new DukeMapper867( utilityCode, marketCode );
						break;
					}
				case "DUQ":
					{
						mapper = new DuqMapper867( utilityCode, marketCode );
						break;
					}
				case "JCP&L":
					{
						mapper = new JcplMapper867( utilityCode, marketCode );
						break;
					}
				case "MECO":
					{
						mapper = new MecoMapper867( utilityCode, marketCode );
						break;
					}
				case "METED":
					{
						mapper = new MetedPenelec867( utilityCode, marketCode );
						break;
					}
				case "NANT":
					{
						mapper = new NantMapper867( utilityCode, marketCode );
						break;
					}
				case "NECO":
					{
						mapper = new NecoMapper867( utilityCode, marketCode );
						break;
					}
				case "NIMO":
					{
						mapper = new NimoMapper867( utilityCode, marketCode );
						break;
					}
				case "NSTAR-BOS":
				case "NSTAR-CAMB":
				case "NSTAR-COMM":
					{
						mapper = new NstarMapper867( utilityCode, marketCode );
						break;
					}
				case "NYSEG":
					{
						mapper = new NysegMapper867( utilityCode, marketCode );
						break;
					}
				case "O&R":
				case "ORNJ":
					{
						mapper = new OrMapper867( utilityCode, marketCode );
						break;
					}
				case "OHED":
					{
						mapper = new OhioGeneric( utilityCode, marketCode );
						break;
					}
				case "OHP":
					{
						mapper = new OhpMapper867( utilityCode, marketCode );
						break;
					}
				case "ONCOR":
					{
						mapper = new OncorMapper867( utilityCode, marketCode );
						break;
					}
				case "PECO":
					{
						mapper = new PecoMapper867( utilityCode, marketCode );
						break;
					}
				case "PENELEC":
					{
						mapper = new MetedPenelec867( utilityCode, marketCode );
						break;
					}
				case "PENNPR":
					{
						mapper = new PennPrMapper867( utilityCode, marketCode );
						break;
					}
				case "PEPCO-DC":
					{
						mapper = new PepcodcMapper867( utilityCode, marketCode );
						break;
					}
				case "PEPCO-MD":
					{
						mapper = new PepcomdMapper867( utilityCode, marketCode );
						break;
					}
				case "PGE":
					{
						mapper = new PgeMapper867(utilityCode, marketCode);
						break;
					}
				case "PPL":
					{
						mapper = new PplMapper867( utilityCode, marketCode );
						break;
					}
				case "PSEG":
					{
						mapper = new PsegMapper867( utilityCode, marketCode );
						break;
					}
				case "RGE":
					{
						mapper = new RgeMapper867( utilityCode, marketCode );
						break;
					}
				case "SCE":
					{
						mapper = new SceMapper867( utilityCode, marketCode );
						break;
					}
				case "SDGE":
					{
						mapper = new SdgeMapper867( utilityCode, marketCode );
						break;
					}
				case "SHARYLAND":
					{
						mapper = new SharylandMapper867( utilityCode, marketCode );
						break;
					}
				case "TOLED":
					{
						mapper = new OhioGeneric( utilityCode, marketCode );
						break;
					}
				case "TXNMP":
					{
						mapper = new TxnmpMapper867( utilityCode, marketCode );
						break;
					}
				case "UGI":
					{
						mapper = new UgiMapper867( utilityCode, marketCode );
						break;
					}
				case "UI":
					{
						mapper = new UiMapper867( utilityCode, marketCode );
						break;
					}
				case "UNITIL":
					{
						mapper = new UnitilMapper867( utilityCode, marketCode );
						break;
					}
				case "WMECO":
					{
						mapper = new WmecoMapper867( utilityCode, marketCode );
						break;
					}
				case "WPP":
					{
						mapper = new WppMapper867( utilityCode, marketCode );
						break;
					}
			}
			return mapper;
		}

		/// <summary>
		/// Get the mapper instance depending on the utility code and market code
		/// </summary>
		/// <param name="utilityCode">the utility code</param>
		/// <param name="marketCode">the market code</param>
		/// <returns>FileMapper814 instance</returns>
		public static FileMapper814 Get814Mapper( string utilityCode, string marketCode )
		{
			utilityCode = utilityCode.ToUpper();
			FileMapper814 mapper = null;
			switch( utilityCode )
			{
				case "ACE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Ace.WithMarketCode( marketCode );
						break;
					}
				case "AEPCE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Aepce.WithMarketCode( marketCode );
						break;
					}
				case "AEPNO":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Aepno.WithMarketCode( marketCode );
						break;
					}
				case "ALLEGMD":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Allegmd.WithMarketCode( marketCode );
						break;
					}
				case "AMEREN":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Ameren.WithMarketCode( marketCode );
						break;
					}
				case "BGE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Bge.WithMarketCode( marketCode );
						break;
					}
				case "CENHUD":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Cenhud.WithMarketCode( marketCode );
						break;
					}
				case "CEI":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Cei.WithMarketCode( marketCode );
						break;
					}
				case "CL&P":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Clp.WithMarketCode( marketCode );
						break;
					}
				case "CSP":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Csp.WithMarketCode( marketCode );
						break;
					}
				case "CMP":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Cmp.WithMarketCode( marketCode );
						break;
					}
                case "BANGOR":
                    {
                        mapper = FileMapper814Builder.BuildMapperFor.Bangor.WithMarketCode(marketCode);
                        break;
                    }
				case "COMED":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Comed.WithMarketCode( marketCode );
						break;
					}
				case "CONED":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Coned.WithMarketCode(marketCode);
						break;
					}
				case "CTPEN":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Ctpen.WithMarketCode( marketCode );
						break;
					}
				case "DAYTON":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Dayton.WithMarketCode( marketCode );
						break;
					}
				case "DELDE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Delde.WithMarketCode( marketCode );
						break;
					}
				case "DELMD":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Delmd.WithMarketCode( marketCode );
						break;
					}
				case "DUKE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Duke.WithMarketCode( marketCode );
						break;
					}
				case "DUQ":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Duq.WithMarketCode( marketCode );
						break;
					}
				case "JCP&L":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Jcpl.WithMarketCode( marketCode );
						break;
					}
				case "MECO":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Meco.WithMarketCode( marketCode );
						break;
					}
				case "METED":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Meted.WithMarketCode( marketCode );
						break;
					}
				case "NANT":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Nant.WithMarketCode( marketCode );
						break;
					}
				case "NECO":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Neco.WithMarketCode( marketCode );
						break;
					}
				case "NIMO":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Nimo.WithMarketCode( marketCode );
						break;
					}
				case "NSTAR-BOS":
					{
						mapper = FileMapper814Builder.BuildMapperFor.NStarBos.WithMarketCode( marketCode );
						break;
					}
				case "NSTAR-CAMB":
					{
						mapper = FileMapper814Builder.BuildMapperFor.NStarCamb.WithMarketCode( marketCode );
						break;
					}
				case "NSTAR-COMM":
					{
						mapper = FileMapper814Builder.BuildMapperFor.NStarComm.WithMarketCode( marketCode );
						break;
					}
				case "NYSEG":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Nyseg.WithMarketCode( marketCode );
						break;
					}
				case "OHED":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Ohed.WithMarketCode( marketCode );
						break;
					}
				case "OHP":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Ohp.WithMarketCode( marketCode );
						break;
					}
				case "O&R":
				case "ORNJ":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Or.WithMarketCode( marketCode );
						break;
					}
				case "ONCOR":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Oncor.WithMarketCode( marketCode );
						break;
					}
				case "PECO":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Peco.WithMarketCode( marketCode );
						break;
					}
				case "PENELEC":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Penelec.WithMarketCode( marketCode );
						break;
					}
				case "PENNPR":
					{
						mapper = FileMapper814Builder.BuildMapperFor.PennPr.WithMarketCode( marketCode );
						break;
					}
				case "PEPCO-DC":
					{
						mapper = FileMapper814Builder.BuildMapperFor.PepcoDC.WithMarketCode( marketCode );
						break;
					}
				case "PEPCO-MD":
					{
						mapper = FileMapper814Builder.BuildMapperFor.PepcoMD.WithMarketCode( marketCode );
						break;
					}
				case "PGE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Pge.WithMarketCode( marketCode );
						break;
					}
				case "PPL":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Ppl.WithMarketCode( marketCode );
						break;
					}
				case "PSEG":
					{
						mapper = FileMapper814Builder.BuildMapperFor.PSeg.WithMarketCode( marketCode );
						break;
					}
				case "RGE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Rge.WithMarketCode( marketCode );
						break;
					}
				case "SCE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Sce.WithMarketCode( marketCode );
						break;
					}
				case "SDGE":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Sdge.WithMarketCode( marketCode );
						break;
					}
				case "SHARYLAND":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Sharyland.WithMarketCode( marketCode );
						break;
					}
				case "TOLED":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Toled.WithMarketCode( marketCode );
						break;
					}
				case "TXNMP":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Txnmp.WithMarketCode( marketCode );
						break;
					}
				case "UGI":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Ugi.WithMarketCode( marketCode );
						break;
					}
				case "UI":
					{
						mapper = FileMapper814Builder.BuildMapperFor.UI.WithMarketCode( marketCode );
						break;
					}
				case "UNITIL":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Unitil.WithMarketCode( marketCode );
						break;
					}
				case "WMECO":
					{
						mapper = FileMapper814Builder.BuildMapperFor.WMeco.WithMarketCode( marketCode );
						break;
					}
				case "WPP":
					{
						mapper = FileMapper814Builder.BuildMapperFor.Wpp.WithMarketCode( marketCode );
						break;
					}
			}
			return mapper;
		}


	}
}
