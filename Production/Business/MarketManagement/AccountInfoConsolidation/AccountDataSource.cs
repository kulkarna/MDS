using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.MarketManagement.AccountInfoConsolidation
{
	public class AccountDataSource
	{
		public enum ESource { Unknown, Ameren, Bge, Cenhud, Cmp, Comed, Coned, Nyseg, Rge, Peco, Nimo, Edi };

		static readonly Dictionary<string, AccountData> DicAccountData = new Dictionary<string, AccountData>();

		public AccountDataSource( string accountNumber, string utilityCode, ESource source )
		{
			if( String.IsNullOrEmpty( accountNumber ) || String.IsNullOrEmpty( utilityCode ) )
				return;
			DicAccountData[ESource.Ameren.ToString()] = new AccountDataAmeren( accountNumber, utilityCode );
			DicAccountData[ESource.Bge.ToString()] = new AccountDataBge( accountNumber, utilityCode );
			DicAccountData[ESource.Cenhud.ToString()] = new AccountDataCenhud( accountNumber, utilityCode );
			DicAccountData[ESource.Cmp.ToString()] = new AccountDataCmp( accountNumber, utilityCode );
			DicAccountData[ESource.Comed.ToString()] = new AccountDataComed( accountNumber, utilityCode );
			DicAccountData[ESource.Coned.ToString()] = new AccountDataConed( accountNumber, utilityCode );
			DicAccountData[ESource.Nyseg.ToString()] = new AccountDataNyseg( accountNumber, utilityCode );
			DicAccountData[ESource.Rge.ToString()] = new AccountDataRge( accountNumber, utilityCode );
			DicAccountData[ESource.Peco.ToString()] = new AccountDataPeco( accountNumber, utilityCode );
			DicAccountData[ESource.Nimo.ToString()] = new AccountDataNimo( accountNumber, utilityCode );

			DicAccountData[ESource.Edi.ToString()] = new AccountDataEdi( accountNumber, utilityCode, source );
		}

		public AccountData GetAccountDataSource( ESource source )
		{
			return DicAccountData.ContainsKey( source.ToString() ) ? DicAccountData[source.ToString()] : null;
		}
	}
}
