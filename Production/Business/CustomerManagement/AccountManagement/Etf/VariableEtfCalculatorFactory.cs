using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public static class VariableEtfCalculatorFactory
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
			VariableEtfCalculator variableEtfCalculator = new VariableEtfCalculator( companyAccount, deenrollmentDate, etfCalculationType );
			variableEtfCalculator.EtfCalculationID = Helper.ConvertFromDB<int?>( dr["EtfCalculationVariableID"] );
			variableEtfCalculator.AverageAnnualConsumption = Helper.ConvertFromDB<Int64>( dr["AverageAnnualConsumption"] );
			variableEtfCalculator.AccountCount = Helper.ConvertFromDB<int>( dr["AccountCount"] );
			variableEtfCalculator.CalculatedEtfAmount = Helper.ConvertFromDB<decimal?>( dr["EtfAmount"] );
			variableEtfCalculator.EtfFinalAmount = Helper.ConvertFromDB<decimal?>( dr["EtfFinalAmount"] );
			variableEtfCalculator.DateCalculated = Helper.ConvertFromDB<DateTime>( dr["CalculatedDate"] );
			//variableEtfCalculator.ErrorMessage = Helper.ConvertFromDB<decimal>( dr["AccountRate"] ); // TODO
			return variableEtfCalculator;
		}

		public static void Save( int etfID, VariableEtfCalculator variableEtfCalculator )
		{

			if ( variableEtfCalculator.EtfCalculationID.HasValue )
			{
				AccountEtfCalculationVariableSql.UpdateAccountEtfCalculationVariable( Convert.ToInt32( variableEtfCalculator.EtfCalculationID ), etfID, variableEtfCalculator.AccountCount, variableEtfCalculator.AverageAnnualConsumption );
			}
			else
			{
				//Insert
				AccountEtfCalculationVariableSql.InsertAccountEtfCalculationVariable( etfID, variableEtfCalculator.AccountCount, variableEtfCalculator.AverageAnnualConsumption );
			}


		}

	}
}
