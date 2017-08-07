namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	using LibertyPower.Business.MarketManagement.UtilityManagement;

	/// <summary>
	/// Class for mapping related methods
	/// </summary>
	public static class EdiMappingFactory
	{
        ///// <summary>
        ///// Gets mapped data for EDI raw data
        ///// </summary>
        ///// <param name="ediAccount">Edi account object</param>
        ///// <returns>Returns a utility account object with mapped data</returns>
        //public static UtilityAccount MapEdiRawData( EdiAccount ediAccount )
        //{
        //    string accountNumber = ediAccount.AccountNumber;
        //    string utilityCode = ediAccount.UtilityCode;
        //    string rateClass = ediAccount.RateClass;
        //    string loadProfile = ediAccount.LoadProfile;
        //    string loadShapeId = String.Empty;
        //    string serviceClass = String.Empty;
        //    string lbmpZone = String.Empty;
        //    string grid = String.Empty;
        //    string tariffCode = String.Empty;

        //    return UtilityMappingFactory.GetUtilityMapping( accountNumber, utilityCode,
        //        rateClass, loadProfile, loadShapeId, serviceClass, lbmpZone, grid, tariffCode );
        //}

        ///// <summary>
        ///// Updates all necessary databases with mapped data
        ///// </summary>
        ///// <param name="account">Utility account object</param>
        //internal static void UpdateDatabasesWithMappedData( UtilityAccount account )
        //{
        //    // Offer Engine
        //    UtilityMappingFactory.UpdateOfferEngineAccountWithMappedData( account );
        //}
	}
}
