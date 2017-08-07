namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    /// <summary>
    /// Responsible for creating maps for utilities files
    /// </summary>
    public class EdiAccountMap814Builder
    {
        private static EdiAccountMap814Builder instance;

        static EdiAccountMap814Builder()
        {
            instance = new EdiAccountMap814Builder();
        }

        /// <summary>
        /// Singleton instance of the class
        /// </summary>
        public static EdiAccountMap814Builder BuildMapFor
        {
            get { return instance; }
        }

        private Dictionary<string, EdiAccountMap814> ediAccountMapDictionary;

        private EdiAccountMap814Builder()
        {
            ediAccountMapDictionary = new Dictionary<string, EdiAccountMap814>();	// dictionary containing all the maps for all the utilities

            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Ace, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Ace));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Aepce, new EdiAccountTexasMap814(Marker814Builder.CreateMarkerFor.Aepce));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Aepno, new EdiAccountTexasMap814(Marker814Builder.CreateMarkerFor.Aepno));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Allegmd, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Allegmd));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Ameren, new Ameren814Mapper(Marker814Builder.CreateMarkerFor.Ameren));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Bge, new Bge814Mapper(Marker814Builder.CreateMarkerFor.Bge));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Cenhud, new NY814Mapper(Marker814Builder.CreateMarkerFor.Cenhud));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Cei, new OH814Mapper(Marker814Builder.CreateMarkerFor.Cei));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Clp, new Clp814Mapper(Marker814Builder.CreateMarkerFor.Clp));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Csp, new Ohio814Mapper(Marker814Builder.CreateMarkerFor.Csp));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Cmp, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Cmp));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Comed, new IL814Mapper(Marker814Builder.CreateMarkerFor.Comed));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Coned, new NY814Mapper(Marker814Builder.CreateMarkerFor.Coned));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Ctpen, new EdiAccountTexasMap814(Marker814Builder.CreateMarkerFor.Ctpen));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Dayton, new OH814Mapper(Marker814Builder.CreateMarkerFor.Dayton));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Delde, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Delde));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Delmd, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Delmd));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Duke, new OH814Mapper(Marker814Builder.CreateMarkerFor.Duke));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Duq, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Duq));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Jcpl, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Jcpl));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Meco, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Meco));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Meted, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Meted));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Nant, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Nant));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Neco, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Neco));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Nimo, new NY814Mapper(Marker814Builder.CreateMarkerFor.Nimo));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.NStarBos, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.NStarBos));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.NStarCamb, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.NStarCamb));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.NStarComm, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.NStarComm));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.NySeg, new NY814Mapper(Marker814Builder.CreateMarkerFor.Nyseg));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Ohed, new OH814Mapper(Marker814Builder.CreateMarkerFor.Ohed));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Ohp, new Ohio814Mapper(Marker814Builder.CreateMarkerFor.Ohp));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Oncor, new EdiAccountTexasMap814(Marker814Builder.CreateMarkerFor.Oncor));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Or, new Or814Mapper(Marker814Builder.CreateMarkerFor.Or));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Peco, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Peco));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Penelec, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Penelec));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.PepcoDC, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.PepcoDC));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.PepcoMD, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.PepcoMD));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Pge, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Pge));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Ppl, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Ppl));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.PSeg, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.PSeg));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Rge, new NY814Mapper(Marker814Builder.CreateMarkerFor.Rge));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Sce, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Sce));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Sdge, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Sdge));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Sharyland, new EdiAccountTexasMap814(Marker814Builder.CreateMarkerFor.Sharyland));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Toled, new OH814Mapper(Marker814Builder.CreateMarkerFor.Toled));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Txnmp, new EdiAccountTexasMap814(Marker814Builder.CreateMarkerFor.Txnmp));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Ugi, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Ugi));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Ui, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Ui));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Unitil, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Unitil));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.WMeco, new Wmeco814Mapper(Marker814Builder.CreateMarkerFor.WMeco));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Wpp, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Wpp));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.PennPr, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.PennPr));
            ediAccountMapDictionary.Add(UtilitiesCodes.CodeOf.Bangor, new EdiAccountMap814(Marker814Builder.CreateMarkerFor.Bangor));

        }

        /// <summary>
        /// Creates a class map for ace
        /// </summary>
        /// <returns>Class map for ace</returns>
        public EdiAccountMap814 Ace
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Ace]; }
        }

        /// <summary>
        /// Creates a class map for ace
        /// </summary>
        /// <returns>Class map for ace</returns>
        public EdiAccountMap814 Bangor
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Bangor]; }
        }

        /// <summary>
        /// Creates a class map for allegheny
        /// </summary>
        /// <returns>Class map for allegheny</returns>
        public EdiAccountMap814 Allegmd
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Allegmd]; }
        }

        /// <summary>
        /// Creates a class map for bge
        /// </summary>
        /// <returns>Class map for bge</returns>
        public EdiAccountMap814 Bge
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Bge]; }
        }

        /// <summary>
        /// Creates a class map for Cei
        /// </summary>
        /// <returns>Class map for Cei</returns>
        public EdiAccountMap814 Cei
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Cei]; }
        }

        /// <summary>
        /// Creates a class map for Clp
        /// </summary>
        /// <returns>Class map for Clp</returns>
        public EdiAccountMap814 Clp
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Clp]; }
        }

        /// <summary>
        /// Creates a class map for Csp
        /// </summary>
        /// <returns>Class map for Csp</returns>
        public EdiAccountMap814 Csp
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Csp]; }
        }

        /// <summary>
        /// Creates a class map for Cmp
        /// </summary>
        /// <returns>Class map for Cmp</returns>
        public EdiAccountMap814 Cmp
        {
            get
            {
                return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Cmp];
            }
        }

        /// <summary>
        /// Creates a class map for Dayton
        /// </summary>
        /// <returns>Class map for Dayton</returns>
        public EdiAccountMap814 Dayton
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Dayton]; }
        }

        /// <summary>
        /// Creates a class map for Delde
        /// </summary>
        /// <returns>Class map for Delde</returns>
        public EdiAccountMap814 Delde
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Delde]; }
        }

        /// <summary>
        /// Creates a class map for Delmd
        /// </summary>
        /// <returns>Class map for Delmd</returns>
        public EdiAccountMap814 Delmd
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Delmd]; }
        }

        /// <summary>
        /// Creates a class map for Duke
        /// </summary>
        /// <returns>Class map for Duke</returns>
        public EdiAccountMap814 Duke
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Duke]; }
        }

        /// <summary>
        /// Creates a class map for Duq
        /// </summary>
        /// <returns>Class map for Delde</returns>
        public EdiAccountMap814 Duq
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Duq]; }
        }

        /// <summary>
        /// Creates a class map for Jcpl
        /// </summary>
        /// <returns>Class map for Jcpl</returns>
        public EdiAccountMap814 Jcpl
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Jcpl]; }
        }

        /// <summary>
        /// Creates a class map for Meco
        /// </summary>
        /// <returns>Class map for Meco</returns>
        public EdiAccountMap814 Meco
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Meco]; }
        }

        /// <summary>
        /// Creates a class map for Neco
        /// </summary>
        /// <returns>Class map for Neco</returns>
        public EdiAccountMap814 Neco
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Neco]; }
        }

        /// <summary>
        /// Creates a class map for Nimo
        /// </summary>
        /// <returns>Class map for Nimo</returns>
        public EdiAccountMap814 Nimo
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Nimo]; }
        }

        /// <summary>
        /// Creates a class map for NStarBos
        /// </summary>
        /// <returns>Class map for NStarBos</returns>
        public EdiAccountMap814 NStarBos
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.NStarBos]; }
        }

        /// <summary>
        /// Creates a class map for NStarCamb
        /// </summary>
        /// <returns>Class map for NStarCamp</returns>
        public EdiAccountMap814 NStarCamb
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.NStarCamb]; }
        }

        /// <summary>
        /// Creates a class map for NStarComm
        /// </summary>
        /// <returns>Class map for NStarComm</returns>
        public EdiAccountMap814 NStarComm
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.NStarComm]; }
        }

        /// <summary>
        /// Creates a class map for Ohed
        /// </summary>
        /// <returns>Class map for Ohed</returns>
        public EdiAccountMap814 Ohed
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Ohed]; }
        }

        /// <summary>
        /// Creates a class map for Ohp
        /// </summary>
        /// <returns>Class map for Ohp</returns>
        public EdiAccountMap814 Ohp
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Ohp]; }
        }

        /// <summary>
        /// Creates a class map for PepcoDC
        /// </summary>
        /// <returns>Class map for PepcoDC</returns>
        public EdiAccountMap814 PepcoDC
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.PepcoDC]; }
        }

        /// <summary>
        /// Creates a class map for PepcoMD
        /// </summary>
        /// <returns>Class map for PepcoMD</returns>
        public EdiAccountMap814 PepcoMD
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.PepcoMD]; }
        }

        /// <summary>
        /// Creates a class map for PSeg
        /// </summary>
        /// <returns>Class map for PSeg</returns>
        public EdiAccountMap814 PSeg
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.PSeg]; }
        }

        /// <summary>
        /// Creates a class map for Sharyland
        /// </summary>
        /// <returns>Class map for Sharyland</returns>
        public EdiAccountMap814 Sharyland
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Sharyland]; }
        }

        /// <summary>
        /// Creates a class map for Toled
        /// </summary>
        /// <returns>Class map for Toled</returns>
        public EdiAccountMap814 Toled
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Toled]; }
        }

        /// <summary>
        /// Creates a class map for UI
        /// </summary>
        /// <returns>Class map for UI</returns>
        public EdiAccountMap814 Ui
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Ui]; }
        }

        /// <summary>
        /// Creates a class map for WMECO
        /// </summary>
        /// <returns>Class map for WMECO</returns>
        public EdiAccountMap814 WMeco
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.WMeco]; }
        }

        /// <summary>
        /// Creates a class map for Ameren
        /// </summary>
        /// <returns>Class map for Ameren</returns>
        public EdiAccountMap814 Ameren
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Ameren]; }
        }

        /// <summary>
        /// Creates a class map for AEPCE
        /// </summary>
        /// <returns>Class map for AEPCE</returns>
        public EdiAccountMap814 Aepce
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Aepce]; }
        }

        /// <summary>
        /// Creates a class map for AEPNO
        /// </summary>
        /// <returns>Class map for AEPNO</returns>
        public EdiAccountMap814 Aepno
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Aepno]; }
        }

        /// <summary>
        /// Creates a class map for CENHUD
        /// </summary>
        /// <returns>Class map for Cenhud</returns>
        public EdiAccountMap814 Cenhud
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Cenhud]; }
        }

        /// <summary>
        /// Creates a class map for Comed
        /// </summary>
        /// <returns>Class map for Comed</returns>
        public EdiAccountMap814 Comed
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Comed]; }
        }

        /// <summary>
        /// Creates a class map for Coned
        /// </summary>
        /// <returns>Class map for Coned</returns>
        public EdiAccountMap814 Coned
        {
            get
            {
                return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Coned];
            }
        }

        /// <summary>
        /// Creates a class map for Ctpen
        /// </summary>
        /// <returns>Class map for Ctpen</returns>
        public EdiAccountMap814 Ctpen
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Ctpen]; }
        }

        /// <summary>
        /// Creates a class map for Nant
        /// </summary>
        /// <returns>Class map for Nant</returns>
        public EdiAccountMap814 Nant
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Nant]; }
        }

        /// <summary>
        /// Creates a class map for Nyseg
        /// </summary>
        /// <returns>Class map for Nyseg</returns>
        public EdiAccountMap814 Nyseg
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.NySeg]; }
        }

        /// <summary>
        /// Creates a class map for Oncor
        /// </summary>
        /// <returns>Class map for Oncor</returns>
        public EdiAccountMap814 Oncor
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Oncor]; }
        }

        /// <summary>
        /// Creates a class map for OR
        /// </summary>
        /// <returns>Class map for OR</returns>
        public EdiAccountMap814 Or
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Or]; }
        }

        /// <summary>
        /// Creates a class map for PGE
        /// </summary>
        /// <returns>Class map for PGE</returns>
        public EdiAccountMap814 Pge
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Pge]; }
        }

        /// <summary>
        /// Creates a class map for Ppl
        /// </summary>
        /// <returns>Class map for Ppl</returns>
        public EdiAccountMap814 Ppl
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Ppl]; }
        }

        /// <summary>
        /// Creates a class map for SCE
        /// </summary>
        /// <returns>Class map for SCE</returns>
        public EdiAccountMap814 Sce
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Sce]; }
        }

        /// <summary>
        /// Creates a class map for SDGE
        /// </summary>
        /// <returns>Class map for SDGE</returns>
        public EdiAccountMap814 Sdge
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Sdge]; }
        }

        /// <summary>
        /// Creates a class map for TXNMP
        /// </summary>
        /// <returns>Class map for TXNMP</returns>
        public EdiAccountMap814 Txnmp
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Txnmp]; }
        }

        /// <summary>
        /// Creates a class map for UGI
        /// </summary>
        /// <returns>Class map for UGI</returns>
        public EdiAccountMap814 Ugi
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Ugi]; }
        }

        /// <summary>
        /// Creates a class map for Unitil
        /// </summary>
        /// <returns>Class map for Unitil</returns>
        public EdiAccountMap814 Unitil
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Unitil]; }
        }

        /// <summary>
        /// Creates a class map for Rge
        /// </summary>
        /// <returns>Class map for Rge</returns>
        public EdiAccountMap814 Rge
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Rge]; }
        }

        /// <summary>
        /// Creates a class map for METED
        /// </summary>
        public EdiAccountMap814 Meted
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Meted]; }
        }

        /// <summary>
        /// Creates a class map for PECO
        /// </summary>
        public EdiAccountMap814 Peco
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Peco]; }
        }

        /// <summary>
        /// Creates a class map for PENELEC
        /// </summary>
        public EdiAccountMap814 Penelec
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Penelec]; }
        }

        /// <summary>
        /// Creates a class map for WPP
        /// </summary>
        public EdiAccountMap814 Wpp
        {
            get
            {
                return ediAccountMapDictionary[UtilitiesCodes.CodeOf.Wpp];
            }
        }

        /// <summary>
        /// Creates a class map for PENNPR
        /// </summary>
        public EdiAccountMap814 PennPr
        {
            get { return ediAccountMapDictionary[UtilitiesCodes.CodeOf.PennPr]; }
        }

    }
}
