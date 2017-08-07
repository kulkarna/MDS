using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class FixedEtfCalculatorFactory
	{

		public static EtfCalculator BuildObject( CompanyAccount companyAccount, DataRow dr )
		{

			DateTime deenrollmentDate = Helper.ConvertFromDB<DateTime>( dr["DeenrollmentDate"] );
			bool isEstimated = Helper.ConvertFromDB<bool>( dr["IsEstimated"] );
			EtfCalculationType etfCalculationType = EtfCalculationType.Actual;
			if ( isEstimated )
			{
				etfCalculationType = EtfCalculationType.Estimated;
			}
			FixedEtfCalculator fixedEtfCalculator = new FixedEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType );
			fixedEtfCalculator.EtfCalculationID = Helper.ConvertFromDB<int?>( dr["EtfCalculationFixedID"] );
			fixedEtfCalculator.AccountRate = Helper.ConvertFromDB<decimal>( dr["AccountRate"] );
			fixedEtfCalculator.AnnualUsage = Helper.ConvertFromDB<int>( dr["AnnualUsage"] );
			fixedEtfCalculator.CalculatedEtfAmount = Helper.ConvertFromDB<decimal?>( dr["EtfAmount"] );
			fixedEtfCalculator.EtfFinalAmount = Helper.ConvertFromDB<decimal?>( dr["EtfFinalAmount"] );
			fixedEtfCalculator.DateCalculated = Helper.ConvertFromDB<DateTime>( dr["CalculatedDate"] );
			fixedEtfCalculator.DropMonthIndicator = Helper.ConvertFromDB<int>( dr["DropMonthIndicator"] );
			//fixedEtfCalculator.ErrorMessage = Helper.ConvertFromDB<decimal>( dr["AccountRate"] ); // TODO
			fixedEtfCalculator.ContractEffectiveDate = Helper.ConvertFromDB<DateTime>( dr["FlowStartDate"] );
			fixedEtfCalculator.LostTermDays = Helper.ConvertFromDB<int>( dr["LostTermDays"] );
			fixedEtfCalculator.LostTermMonths = Helper.ConvertFromDB<int>( dr["LostTermMonths"] );
			fixedEtfCalculator.MarketRate = Helper.ConvertFromDB<decimal>( dr["MarketRate"] );
			fixedEtfCalculator.Term = Helper.ConvertFromDB<int>( dr["Term"] );

			return fixedEtfCalculator;

		}

		public static void Save( int etfID, FixedEtfCalculator fixedEtfCalculator )
		{

			if ( fixedEtfCalculator.EtfCalculationID.HasValue )
			{
				AccountEtfCalculationFixedSql.UpdateAccountEtfCalculationFixed( Convert.ToInt32( fixedEtfCalculator.EtfCalculationID), etfID, fixedEtfCalculator.LostTermDays, fixedEtfCalculator.LostTermMonths, Convert.ToSingle( fixedEtfCalculator.AccountRate ), Convert.ToSingle( fixedEtfCalculator.MarketRate ), fixedEtfCalculator.AnnualUsage, fixedEtfCalculator.Term, fixedEtfCalculator.ContractEffectiveDate, fixedEtfCalculator.DropMonthIndicator );
			}
			else
			{
				//Insert
				AccountEtfCalculationFixedSql.InsertAccountEtfCalculationFixed( etfID, fixedEtfCalculator.LostTermDays, fixedEtfCalculator.LostTermMonths, Convert.ToSingle( fixedEtfCalculator.AccountRate ), Convert.ToSingle( fixedEtfCalculator.MarketRate ), fixedEtfCalculator.AnnualUsage, fixedEtfCalculator.Term, fixedEtfCalculator.ContractEffectiveDate, fixedEtfCalculator.DropMonthIndicator );
			}


		}

	}
}
