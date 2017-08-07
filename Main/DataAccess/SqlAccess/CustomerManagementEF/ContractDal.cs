using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
	public static class ContractDal
	{
		public static bool IsContractNumberInTheSystem( string number )
		{
			bool exists = false;
			// If some wise guy wants to send empty stuff:
			if( string.IsNullOrEmpty( number ) )
			{
				throw new ArgumentOutOfRangeException( "Contract Number sent must be non empty or null" );
			}
			else
			{
				//TODO: Refactor into more efficient SP
				using( LibertyPowerEntities dal = new LibertyPowerEntities() )
				{
					var res = dal.Contracts.Where( w => w.Number == number ).FirstOrDefault();
					if( res != null )
					{
						// we found a record 
						exists = true;
					}
				}
			}
			return exists;
		}
		//PBI: 14201- Refactoring and cleanup of Deal Capture
		//July 2013
		public static DataTable GetContractInfo( string username, string contractNumber, string accountNumber )
		{
			DataTable dtContract = new DataTable();
			using( LpDealCaptureEntities ctx = new LpDealCaptureEntities() )
			{
				var query = ctx.usp_contract_sel( username, contractNumber, accountNumber ).ToList();
				if( query.Any() )
				{
					dtContract = query.CopyToDataTable();
				}

			}
			return dtContract;

		}
		public static bool IsAccountNumberInTheSystem( string number )
		{
			bool exists = false;
			// If some wise guy wants to send empty stuff:
			if( string.IsNullOrEmpty( number ) )
			{
				throw new ArgumentOutOfRangeException( "Account number sent must be non empty or null" );
			}
			else
			{
				//TODO: Refactor into more efficient SP
				using( LibertyPowerEntities dal = new LibertyPowerEntities() )
				{
					var res = dal.Accounts.Where( w => w.AccountNumber == number ).FirstOrDefault();
					if( res != null )
					{
						// we found a record 
						exists = true;
					}
				}
			}
			return exists;
		}

		public static bool IsContractNumberinDealCapture( string number )
		{
			bool exists = false;
			// If some wise guy wants to send empty stuff:
			if( string.IsNullOrEmpty( number ) )
			{
				throw new ArgumentOutOfRangeException( "Contract number sent must be non empty or null" );
			}
			else
			{
				//TODO: Refactor into more efficient SP
				using( LpDealCaptureEntities dal = new LpDealCaptureEntities() )
				{
					var res = dal.deal_contract.Where( w => w.contract_nbr == number ).FirstOrDefault();
					if( res != null )
					{
						// we found a record 
						exists = true;

					}
				}
			}
			return exists;
		}
		//GetContractNumberfromAccountNumber
		public static string GetContractNumberfromAccountNumber( string number, int? utilityId )
		{
			string contractNumber = "";
			// If some wise guy wants to send empty stuff:
			if( string.IsNullOrEmpty( number ) )
			{
				throw new ArgumentOutOfRangeException( "Contract number sent must be non empty or null" );
			}
			else
			{
				//TODO: Refactor into more efficient SP
				using( LibertyPowerEntities dal = new LibertyPowerEntities() )
				{

					var res = dal.Accounts
											.Join( dal.AccountContracts, (Acc => Acc.AccountID), (AccContr => AccContr.AccountID), (( Acc, AccContr ) => new { Acc, AccContr }) )
											.Join( dal.AccountContractRates, (AccAccContr => AccAccContr.AccContr.AccountContractID), (ACR => ACR.AccountContractID), (( AccAccContr, ACR ) => new { AccAccContr, ACR }) )
											.Join( dal.Contracts, (AccAccContrACR => AccAccContrACR.AccAccContr.AccContr.ContractID), (Contr => Contr.ContractID), (( AccAccContrACR, Contr ) => new { AccAccContrACR, Contr }) )
											.Join( dal.AccountStatuses, (ContrAccAccContrACR => ContrAccAccContrACR.AccAccContrACR.AccAccContr.AccContr.AccountContractID), (AccStatus => AccStatus.AccountContractID), (( ContrAccAccContrACR, AccStatus ) => new { ContrAccAccContrACR, AccStatus }) )
											.Where( Res => Res.ContrAccAccContrACR.AccAccContrACR.AccAccContr.Acc.AccountNumber == number
														  && ((Res.AccStatus.Status.Trim() == "905000" || Res.AccStatus.Status.Trim() == "906000") && Res.AccStatus.SubStatus.Trim() == "10")
														  && (utilityId == null ? Res.ContrAccAccContrACR.AccAccContrACR.AccAccContr.Acc.UtilityID : utilityId) == Res.ContrAccAccContrACR.AccAccContrACR.AccAccContr.Acc.UtilityID
														  && Res.ContrAccAccContrACR.Contr.ContractID == Res.ContrAccAccContrACR.AccAccContrACR.AccAccContr.Acc.CurrentContractID )
											.OrderByDescending( Ord => Ord.ContrAccAccContrACR.AccAccContrACR.ACR.RateStart );

					if( res != null && res.Count() > 0 )
					{
						if( res.Count() > 1 && utilityId == null )
							throw new DuplicatedAccountRecordException();

						var resObj = res.FirstOrDefault();
						contractNumber = resObj.ContrAccAccContrACR.Contr.Number.ToString();
					}
				}
			}
			return contractNumber;
		}

		public static bool IsAtleastOneAccountflowinginSystem( string number, bool isContractNo, int? utilityId )
		{
			bool exists = false;
			// If some wise guy wants to send empty stuff:
			if( string.IsNullOrEmpty( number ) )
			{
				throw new ArgumentOutOfRangeException( "Contract number sent must be non empty or null" );
			}
			else
			{
				//TODO: Refactor into more efficient SP
				using( LibertyPowerEntities dal = new LibertyPowerEntities() )
				{
					if( isContractNo )
					{
						var res = dal.Contracts
					   .Join( dal.AccountContracts, (Contr => Contr.ContractID), (AccContr => AccContr.ContractID), (( Contr, AccContr ) => new { Contr, AccContr }) )
					   .Join( dal.AccountStatuses, (CA => CA.AccContr.AccountContractID), (AccStat => AccStat.AccountContractID), (( CA, AccStat ) => new { CA, AccStat }) )
					   .Where( Res => Res.CA.Contr.Number == number && (Res.AccStat.Status.Trim() == "905000" || Res.AccStat.Status.Trim() == "906000") && Res.AccStat.SubStatus.Trim() == "10" ).FirstOrDefault();
						if( res != null )
							exists = true;
					}
					else
					{
						var res = dal.Accounts
											.Join( dal.AccountContracts, (Acc => Acc.AccountID), (AccContr => AccContr.AccountID), (( Acc, AccContr ) => new { Acc, AccContr }) )
											.Join( dal.AccountContractRates, (AccAccContr => AccAccContr.AccContr.AccountContractID), (ACR => ACR.AccountContractID), (( AccAccContr, ACR ) => new { AccAccContr, ACR }) )
											.Join( dal.Contracts, (AccAccContrACR => AccAccContrACR.AccAccContr.AccContr.ContractID), (Contr => Contr.ContractID), (( AccAccContrACR, Contr ) => new { AccAccContrACR, Contr }) )
											.Join( dal.AccountStatuses, (ContrAccAccContrACR => ContrAccAccContrACR.AccAccContrACR.AccAccContr.AccContr.AccountContractID), (AccStatus => AccStatus.AccountContractID), (( ContrAccAccContrACR, AccStatus ) => new { ContrAccAccContrACR, AccStatus }) )
											.Where( Res => Res.ContrAccAccContrACR.AccAccContrACR.AccAccContr.Acc.AccountNumber == number
														  && ((Res.AccStatus.Status.Trim() == "905000" || Res.AccStatus.Status.Trim() == "906000") && Res.AccStatus.SubStatus.Trim() == "10")
														  && (utilityId == null ? Res.ContrAccAccContrACR.AccAccContrACR.AccAccContr.Acc.UtilityID : utilityId) == Res.ContrAccAccContrACR.AccAccContrACR.AccAccContr.Acc.UtilityID
														  && Res.ContrAccAccContrACR.Contr.ContractID == Res.ContrAccAccContrACR.AccAccContrACR.AccAccContr.Acc.CurrentContractID )
											.OrderByDescending( Ord => Ord.ContrAccAccContrACR.AccAccContrACR.ACR.RateStart );

						if( res != null && res.Count() > 0 )
						{
							if( res.Count() > 1 && utilityId == null )
								throw new DuplicatedAccountRecordException();

							exists = true;
						}
					}
				}
			}
			return exists;
		}


		//GetContractNumberfromContractID Added Sept 03 2013
		public static string GetContractNumberfromContractID( int? contractID )
		{
			string contractNumber = "";
			if( contractID == null )
			{
				throw new ArgumentOutOfRangeException( "Contract ID sent must be non null" );
			}
			else
			{
				using( LibertyPowerEntities dal = new LibertyPowerEntities() )
				{
					var res = dal.Contracts.Where( w => w.ContractID == contractID ).FirstOrDefault();
					if( res != null )
						contractNumber = res.Number.ToString();
				}
			}

			return contractNumber;
		}

		//Added march 12 2014-PBI: 35278:  Add Sales Channel Renewal validation to ContractAPI
		public static DataTable GetCurrentContractAccountInformationforagivenAccountNumber( string accountNumber )
		{
			DataTable currentContract = new DataTable();

			using( LibertyPowerEntities dal = new LibertyPowerEntities() )
			{
				using( Lp_commonEntities dalCommon = new Lp_commonEntities() )
				{
					var resContracts1 = dal.Accounts
										.Join( dal.Contracts, (Acc => Acc.CurrentContractID), (Contr => Contr.ContractID), (( Acc, Contr ) => new { Acc, Contr }) )
										.Join( dal.AccountContracts, (AccContr => AccContr.Acc.AccountID), (AccContr1 => AccContr1.AccountID), (( AccContr, AccContr1 ) => new { AccContr, AccContr1 }) )
										.Join( dal.AccountContractRates, (RatesAccContr => RatesAccContr.AccContr1.AccountContractID), (ACR => ACR.AccountContractID), (( RatesAccContr, ACR ) => new { RatesAccContr, ACR }) )
													  .Where( Res => Res.RatesAccContr.AccContr.Acc.AccountNumber == accountNumber )
														  .Select( result => new
												  {
													  result.RatesAccContr.AccContr.Contr.ContractID,
													  result.RatesAccContr.AccContr.Contr.Number,
													  result.RatesAccContr.AccContr.Contr.StartDate,
													  result.RatesAccContr.AccContr.Contr.EndDate,
													  result.RatesAccContr.AccContr.Contr.SalesChannelID,
													  result.RatesAccContr.AccContr.Acc.AccountID,
													  result.RatesAccContr.AccContr.Acc.AccountIdLegacy,
													  result.RatesAccContr.AccContr.Acc.AccountNumber,
													  result.RatesAccContr.AccContr.Acc.CurrentContractID,
													  result.ACR.LegacyProductID,

												  } ).Distinct().ToList();

					var resContracts2 = dalCommon.common_product.Select( result => new { result.product_id, result.IsDefault } ).Distinct().ToList();

					var resContracts3 = resContracts1
					.Join( resContracts2, (CommonRatesAccContr => CommonRatesAccContr.LegacyProductID), (CommonProduct => CommonProduct.product_id), (( CommonRatesAccContr, CommonProduct ) => new { CommonRatesAccContr, CommonProduct }) )
												  .Where( Res => Res.CommonRatesAccContr.AccountNumber == accountNumber )
												  .Select( result => new
												  {
													  result.CommonRatesAccContr.ContractID,
													  result.CommonRatesAccContr.Number,
													  result.CommonRatesAccContr.StartDate,
													  result.CommonRatesAccContr.EndDate,
													  result.CommonRatesAccContr.SalesChannelID,
													  result.CommonRatesAccContr.AccountID,
													  result.CommonRatesAccContr.AccountIdLegacy,
													  result.CommonRatesAccContr.AccountNumber,
													  result.CommonRatesAccContr.CurrentContractID,
													  result.CommonRatesAccContr.LegacyProductID,
													  result.CommonProduct.IsDefault
												  } ).Distinct().CopyToDataTable();

					if( resContracts3 != null )
						currentContract = resContracts3;
				}
			}
			return currentContract;
		}
	}

	public class DuplicatedAccountRecordException : Exception
	{
		public DuplicatedAccountRecordException()
			: base( "There is more than one record for this account number in the system. Please, inform the utility." )
		{ }

	}

}
