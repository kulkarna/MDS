namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Data;

	using System.Linq;
	using System.Web;
	using LibertyPower.Business.CommonBusiness.FieldHistory;
	using LibertyPower.Business.CommonBusiness.CommonHelper;
	using LibertyPower.Business.CommonBusiness.CommonRules;
	using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
	using LibertyPower.DataAccess.SqlAccess.OfferEngineSql;
	using System.Runtime.InteropServices;
	using System.Runtime.Caching;
	using Aspose.Cells;
	using System.IO;

	/// <summary>
	/// Class for mapping utility account properties.
	/// </summary>
	public static class UtilityMappingFactory
	{
		public static MemoryCache Cache = MemoryCache.Default;

		public static int AccountCount
		{
			get;
			set;
		}

		public static List<string> AccountNumbers
		{
			get;
			set;
		}
		/// <summary>
		/// Gets a utility mapping list for specified utility id.
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <returns>Returns a utility mapping list for specified utility id.</returns>
		public static UtilityClassMappingList GetUtilityMapping(int utilityID)
		{
			DataSet ds;
			if(utilityID == 0) // get all utility mappings
				ds = UtilityMappingSql.SelectUtilityMapping();
			else // get utility mappings for specified utility
				ds = UtilityMappingSql.SelectUtilityMappingByUtility(utilityID);

			return BuildUtilityClassMappings(ds);
		}

		/// <summary>
		/// Gets a utility mapping list for specified utility code.
		/// </summary>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a utility mapping list for specified utility code.</returns>
		public static UtilityClassMappingList GetUtilityMapping(string utilityCode)
		{
			DataSet ds = UtilityMappingSql.SelectUtilityMappingByUtility(utilityCode);
			return BuildUtilityClassMappings(ds);
		}

		/// <summary>
		/// Gets all utility class mappings
		/// </summary>
		/// <returns>Returns a list of all utility class mappings.</returns>
		public static UtilityClassMappingList GetUtilityMapping()
		{
			DataSet ds = UtilityMappingSql.SelectUtilityMapping();
			return BuildUtilityClassMappings(ds);
		}

		/// <summary>
		/// Gets utility mappings filtered by specified parameters
		/// </summary>
		/// <param name="marketID">Market record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <param name="isActive">Active indicator</param>
		/// <returns>Returns utility mappings filtered by specified parameters.</returns>
		public static UtilityClassMappingList GetUtilityMapping(int marketID, int utilityID, int accountTypeID, int isActive)
		{
			var listComplete = new UtilityClassMappingList();
			var listFiltered = new UtilityClassMappingList();

			var ds = UtilityMappingSql.SelectUtilityMapping();
			listComplete = BuildUtilityClassMappings(ds);

			// for IDs that are 0, no filter
			var m =
			from p in listComplete
			where p.MarketID == (marketID == 0 ? p.MarketID : marketID)
			&& p.UtilityID == (utilityID == 0 ? p.UtilityID : utilityID)
			&& p.AccountTypeID == (accountTypeID == 0 ? p.AccountTypeID : accountTypeID)
			&& p.IsActive == (isActive == -1 ? p.IsActive : Convert.ToBoolean(isActive)) // -1 is all
			select p;

			foreach(UtilityClassMapping mapping in m)
				listFiltered.Add(mapping);

			return listFiltered;
		}

		public static void InsertUtilityClassMapping(int utilityID, int accountTypeID, int meterTypeID, int voltageID, string rateClassCode, string serviceClassCode, string loadProfileCode, string loadShapeCode, string tariffCode, decimal? losses, string zone, bool isActive)
		{
			InsertUtilityClassMapping(utilityID, accountTypeID, meterTypeID, voltageID, rateClassCode, serviceClassCode, loadProfileCode, loadShapeCode, tariffCode, losses, zone, isActive, MappingRuleType.ReplaceValueAlways);
		}

		/// <summary>
		/// Inserts new utility class mapping record
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <param name="meterTypeID">Meter type record identifier</param>
		/// <param name="voltageID">Voltage record identifier</param>
		/// <param name="rateClassCode">Rate class code</param>
		/// <param name="serviceClassCode">Service class code</param>
		/// <param name="loadProfileCode">Load profile code</param>
		/// <param name="loadShapeCode">Load shape code</param>
		/// <param name="tariffCode">Tariff code</param>
		/// <param name="losses">Losses</param>
		/// <param name="isActive">Active indicator</param>
		public static void InsertUtilityClassMapping(int utilityID, int accountTypeID, int meterTypeID, int voltageID, string rateClassCode, string serviceClassCode, string loadProfileCode, string loadShapeCode, string tariffCode, decimal? losses, string zone, bool isActive, MappingRuleType mappingRuleType, decimal? icap = null, decimal? tcap = null)
		{
			UtilityMappingSql.InsertUtilityClassMapping(utilityID, accountTypeID, meterTypeID, voltageID, rateClassCode, serviceClassCode, loadProfileCode, loadShapeCode, tariffCode, losses, zone, isActive, (int)mappingRuleType, icap, tcap);
		}

		public static void UpdateUtilityClassMapping(int identifier, int utilityId, int accountTypeID, int meterTypeID, int voltageID, string rateClassCode, string serviceClassCode, string loadProfileCode, string loadShapeCode, string tariffCode, decimal? losses, string zone, bool isActive, decimal? icap = null, decimal? tcap = null)
		{
			UpdateUtilityClassMapping(identifier, utilityId, accountTypeID, meterTypeID, voltageID, rateClassCode, serviceClassCode, loadProfileCode, loadShapeCode, tariffCode, losses, zone, isActive, MappingRuleType.ReplaceValueAlways, icap, tcap);
		}

		/// <summary>
		/// Updates utility class mapping record
		/// </summary>
		/// <param name="identifier">Utility class mapping record identifier</param>
		/// <param name="accountTypeID">Account type record identifier</param>
		/// <param name="utilityId"></param>
		/// <param name="meterTypeID">Meter type record identifier</param>
		/// <param name="voltageID">Voltage record identifier</param>
		/// <param name="rateClassCode">Rate class code</param>
		/// <param name="serviceClassCode">Service class code</param>
		/// <param name="loadProfileCode">Load profile code</param>
		/// <param name="loadShapeCode">Load shape code</param>
		/// <param name="tariffCode">Tariff code</param>
		/// <param name="losses">Losses</param>
		/// <param name="isActive">Active indicator</param>
		public static void UpdateUtilityClassMapping(int identifier, int utilityId, int accountTypeID, int meterTypeID, int voltageID, string rateClassCode, string serviceClassCode, string loadProfileCode, string loadShapeCode, string tariffCode, decimal? losses, string zone, bool isActive, MappingRuleType mappingRuleType, decimal? icap = null, decimal? tcap = null)
		{
			UtilityMappingSql.UpdateUtilityClassMapping(identifier, utilityId, accountTypeID, meterTypeID, voltageID, rateClassCode, serviceClassCode, loadProfileCode, loadShapeCode, tariffCode, losses, zone, isActive, (int)mappingRuleType, icap, tcap);
		}

		/// <summary>
		/// Gets all the UtilityID | UtilityCode pairs from the database
		/// </summary>
		/// <returns></returns>
		public static Dictionary<int, string> SelectUtilityIdUtilityCodeList()
		{
			Dictionary<int, string> utilityIdUtilityCodeDictionary = null;

			DataSet utilityIdUtilityCodeListDataSet = UtilityMappingSql.SelectUtilityIdUtilityCodeList();

			if(utilityIdUtilityCodeListDataSet != null && utilityIdUtilityCodeListDataSet.Tables.Count > 0 && utilityIdUtilityCodeListDataSet.Tables[0].Rows.Count > 0)
			{
				utilityIdUtilityCodeDictionary = utilityIdUtilityCodeListDataSet.Tables[0].Rows.Cast<DataRow>().ToDictionary(dr => (int)dr["ID"], dr => dr["UtilityCode"].ToString());
			}

			return utilityIdUtilityCodeDictionary;
		}

		/// <summary>
		/// Deletes utility class mapping record for specified identifier.
		/// </summary>
		/// <param name="identifier">Utility class mapping record identifier</param>
		public static void DeleteUtilityClassMapping(int identifier)
		{
			UtilityMappingSql.DeleteUtilityClassMapping(identifier);
		}

		private static UtilityClassMappingList BuildUtilityClassMappings(DataSet ds)
		{
			var list = new UtilityClassMappingList();

			if(DataSetHelper.HasRow(ds))
			{
				foreach(DataRow dr in ds.Tables[0].Rows)
					list.Add(BuildUtilityClassMapping(dr));
			}
			return list;
		}

		private static UtilityClassMapping BuildUtilityClassMapping(DataRow dr)
		{
			var mapping = new UtilityClassMapping();
			mapping.Identifier = Convert.ToInt32(dr["ID"]);
			mapping.AccountTypeDescription = dr["AccountTypeDesc"].ToString();
			mapping.AccountTypeID = dr["AccountTypeID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["AccountTypeID"]);
			mapping.IsActive = Convert.ToBoolean(dr["IsActive"]);
			mapping.LoadProfileCode = dr["LoadProfileCode"].ToString();
			mapping.LoadProfileID = dr["LoadProfileID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["LoadProfileID"]);
			mapping.LoadShapeCode = dr["LoadShapeCode"].ToString();
			mapping.LoadShapeID = dr["LoadShapeID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["LoadShapeID"]);
			mapping.LossFactor = dr["LossFactor"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(dr["LossFactor"]);
			mapping.MarketCode = dr["MarketCode"].ToString();
			mapping.MarketID = Convert.ToInt32(dr["MarketID"]);
			mapping.MeterTypeCode = dr["MeterTypeCode"].ToString();
			mapping.MeterTypeID = dr["MeterTypeID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["MeterTypeID"]);
			mapping.RateClassCode = dr["RateClassCode"].ToString();
			mapping.RateClassID = dr["RateClassID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["RateClassID"]);
			mapping.ServiceClassCode = dr["ServiceClassCode"].ToString();
			mapping.ServiceClassID = dr["ServiceClassID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["ServiceClassID"]);
			mapping.TariffCode = dr["TariffCode"].ToString();
			mapping.TariffCodeID = dr["TariffCodeID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["TariffCodeID"]);
			mapping.UtilityCode = dr["UtilityCode"].ToString();
			mapping.UtilityFullName = dr["UtilityFullName"].ToString();
			mapping.UtilityID = dr["UtilityID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["UtilityID"]);
			mapping.VoltageCode = dr["VoltageCode"].ToString();
			mapping.VoltageID = Convert.ToInt32(dr["VoltageID"]);
			mapping.ZoneCode = dr["ZoneCode"].ToString();
			mapping.ZoneId = Convert.ToInt32(dr["ZoneId"]);
			mapping.Icap = dr["Icap"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(dr["Icap"]);
			mapping.Tcap = dr["TCap"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(dr["TCap"]);
			var ruleType = 0;
			if(dr["RuleType"] == DBNull.Value)
				ruleType = 0;
			int.TryParse(dr["RuleType"].ToString(), out ruleType);
			if(ruleType < 0 || ruleType > 2)
				ruleType = 0;
			mapping.MappingStyle = (MappingRuleType)ruleType;

			return mapping;
		}

		/// <summary>
		/// Gets utility zone mapping for specified parameters.
		/// </summary>
		/// <param name="marketID">Market record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="isActive">Active indicator</param>
		/// <returns>Returns utility zone mapping for specified parameters.</returns>
		public static UtilityZoneMappingList GetUtilityZoneMapping(int marketID, int utilityID, int isActive)
		{
			UtilityZoneMappingList listComplete = new UtilityZoneMappingList();
			UtilityZoneMappingList listFiltered = new UtilityZoneMappingList();

			DataSet ds = UtilityMappingSql.SelectUtilityZoneMapping();
			listComplete = BuildUtilityZoneMappings(ds);

			// for IDs that are 0, no filter
			var m =
			from p in listComplete
			where p.MarketID == (marketID == 0 ? p.MarketID : marketID)
			&& p.UtilityID == (utilityID == 0 ? p.UtilityID : utilityID)
			&& p.IsActive == (isActive == -1 ? p.IsActive : Convert.ToBoolean(isActive)) // -1 is all
			orderby p.MarketCode, p.UtilityCode, p.ZoneCode
			select p;

			foreach(UtilityZoneMapping mapping in m)
				listFiltered.Add(mapping);

			return listFiltered;
		}

		/// <summary>
		/// Gets zone mapping for specified utility ID
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <returns>Returns a zone mapping list for specified utility ID.</returns>
		public static UtilityZoneMappingList GetUtilityZoneMapping(int utilityID)
		{
			DataSet ds = UtilityMappingSql.SelectUtilityZoneMappingByUtility(utilityID);
			return BuildUtilityZoneMappings(ds);
		}

		/// <summary>
		/// Gets zone mapping for specified utility code
		/// </summary>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a zone mapping list for specified utility code.</returns>
		public static UtilityZoneMappingList GetUtilityZoneMapping(string utilityCode)
		{
			DataSet ds = UtilityMappingSql.SelectUtilityZoneMappingByUtility(utilityCode);
			return BuildUtilityZoneMappings(ds);
		}

		/// <summary>
		/// Gets all utility zone mappings
		/// </summary>
		/// <returns>Returns a list of all utility zone mappings.</returns>
		public static UtilityZoneMappingList GetUtilityZoneMapping()
		{
			DataSet ds = UtilityMappingSql.SelectUtilityZoneMapping();
			return BuildUtilityZoneMappings(ds);
		}

		/// <summary>
		/// Inserts utility zone mapping record
		/// </summary>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="zoneID">Zone record identifier</param>
		/// <param name="grid">Grid</param>
		/// <param name="lbmpZone">LBMP zone</param>
		/// <param name="losses">Losses</param>
		/// <param name="isActive">Active indicator</param>
		public static void InsertUtilityZoneMapping(int utilityID, int zoneID, string grid, string lbmpZone, decimal? losses, bool isActive, MappingRuleType mappingRuleType = MappingRuleType.ReplaceValueAlways)
		{
			UtilityMappingSql.InsertUtilityZoneMapping(utilityID, zoneID, grid, lbmpZone, losses, isActive, (int)mappingRuleType);
		}

		/// <summary>
		/// Updates utility class mapping record
		/// </summary>
		/// <param name="identifier">Utility zone mapping record identifier</param>
		/// <param name="utilityID">Utility record identifier</param>
		/// <param name="zoneID">Zone record identifier</param>
		/// <param name="grid">Grid</param>
		/// <param name="lbmpZone">LBMP zone</param>
		/// <param name="losses">Losses</param>
		/// <param name="isActive">Active indicator</param>
		public static void UpdateUtilityZoneMapping(int identifier, int utilityID, int zoneID, string grid, string lbmpZone, decimal? losses, bool isActive, MappingRuleType mappingRuleType = MappingRuleType.ReplaceValueAlways)
		{
			UtilityMappingSql.UpdateUtilityZoneMapping(identifier, utilityID, zoneID, grid, lbmpZone, losses, isActive, (int)mappingRuleType);
		}

		/// <summary>
		/// Deletes utility zone mapping record for specified identifier.
		/// </summary>
		/// <param name="identifier">Utility zone mapping record identifier</param>
		public static void DeleteUtilityZoneMapping(int identifier)
		{
			UtilityMappingSql.DeleteUtilityZoneMapping(identifier);
		}

		private static UtilityZoneMappingList BuildUtilityZoneMappings(DataSet ds)
		{
			UtilityZoneMappingList list = new UtilityZoneMappingList();
			UtilityZoneMappingList listSorted = new UtilityZoneMappingList();

			if(DataSetHelper.HasRow(ds))
			{
				foreach(DataRow dr in ds.Tables[0].Rows)
					list.Add(BuildUtilityZoneMapping(dr));
			}

			var m =
			from p in list
			orderby p.UtilityCode, p.ZoneCode
			select p;

			foreach(UtilityZoneMapping mapping in m)
				listSorted.Add(mapping);

			return listSorted;
		}

		private static UtilityZoneMapping BuildUtilityZoneMapping(DataRow dr)
		{
			UtilityZoneMapping mapping = new UtilityZoneMapping();
			mapping.Identifier = Convert.ToInt32(dr["ID"]);
			mapping.Grid = dr["Grid"].ToString();
			mapping.IsActive = Convert.ToBoolean(dr["IsActive"]);
			mapping.LBMPZone = dr["LBMPZone"].ToString();
			mapping.LossFactor = dr["LossFactor"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(dr["LossFactor"]);
			mapping.MarketCode = dr["MarketCode"].ToString();
			mapping.MarketID = Convert.ToInt32(dr["MarketID"]);
			mapping.UtilityCode = dr["UtilityCode"].ToString();
			mapping.UtilityID = dr["UtilityID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["UtilityID"]);
			mapping.ZoneCode = dr["ZoneCode"].ToString();
			mapping.ZoneID = dr["ZoneID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["ZoneID"]);
			var ruleType = 0;
			if(dr["RuleType"] == DBNull.Value)
				ruleType = 0;
			int.TryParse(dr["RuleType"].ToString(), out ruleType);
			if(ruleType < 0 || ruleType > 2)
				ruleType = 0;
			mapping.MappingStyle = (MappingRuleType)ruleType;
			return mapping;
		}

		public static UtilityClassMappingDeterminantList GetUtilityClassMappingDeterminants(int utilityID)
		{
			DataSet ds = UtilityMappingSql.SelectUtilityClassMappingDeterminants(utilityID);
			return BuildUtilityClassMappingDeterminants(ds);
		}

		public static UtilityClassMappingDeterminantList GetUtilityClassMappingDeterminants()
		{
			DataSet ds = UtilityMappingSql.SelectUtilityClassMappingDeterminants();
			return BuildUtilityClassMappingDeterminants(ds);
		}

		public static UtilityClassMappingDeterminantList GetUtilityClassMappingDeterminants(string utilityCode)
		{
			DataSet ds = UtilityMappingSql.SelectUtilityClassMappingDeterminants(utilityCode);
			return BuildUtilityClassMappingDeterminants(ds);
		}

		public static int UtilityClassMappingExists(int utilityId, string driverFieldName, string driverValue)
		{
			return UtilityMappingSql.UtilityClassMappingExists(utilityId, driverFieldName, driverValue);
		}

		private static UtilityClassMappingDeterminantList BuildUtilityClassMappingDeterminants(DataSet ds)
		{
			UtilityClassMappingDeterminantList list = new UtilityClassMappingDeterminantList();

			if(DataSetHelper.HasRow(ds))
			{
				foreach(DataRow dr in ds.Tables[0].Rows)
					list.Add(BuildUtilityClassMappingDeterminant(dr));
			}
			return list;
		}

		private static UtilityClassMappingDeterminant BuildUtilityClassMappingDeterminant(DataRow dr)
		{
			int identifier = Convert.ToInt32(dr["ID"]);
			int utilityID = Convert.ToInt32(dr["UtilityID"]);
			string driver = dr["Driver"].ToString();
			return new UtilityClassMappingDeterminant(identifier, utilityID, driver);
		}

		/// <summary>
		/// Gets utility class mapping resultants for specified determinants id
		/// </summary>
		/// <param name="determinantsId">Determinants ID</param>
		/// <returns>Returns a list of utility class mapping resultants.</returns>
		public static UtilityClassMappingResultantList GetUtilityClassMappingResultants(int determinantsId)
		{
			DataSet ds = UtilityMappingSql.SelectUtilityClassMappingResultants(determinantsId);
			return BuildUtilityClassMappingResultants(ds);
		}

		private static UtilityClassMappingResultantList BuildUtilityClassMappingResultants(DataSet ds)
		{
			UtilityClassMappingResultantList list = new UtilityClassMappingResultantList();

			if(DataSetHelper.HasRow(ds))
			{
				foreach(DataRow dr in ds.Tables[0].Rows)
					list.Add(BuildUtilityClassMappingResultant(dr));
			}
			return list;
		}

		private static UtilityClassMappingResultant BuildUtilityClassMappingResultant(DataRow dr)
		{
			int identifier = Convert.ToInt32(dr["ID"]);
			int determinantsID = Convert.ToInt32(dr["DeterminantsID"]);
			string result = dr["Result"].ToString();
			return new UtilityClassMappingResultant(identifier, determinantsID, result);
		}

		public static int ApplyAliasing(DeterminantAlias alias)
		{
			var accountIdentifiers = FieldHistoryManager.GetAccountsByDeterminantValue(alias.UtilityCode, alias.FieldName, alias.OriginalValue);
			foreach(var aid in accountIdentifiers)
			{
				ApplyMapping(aid, alias.FieldName, alias.OriginalValue, alias.AliasValue);
			}
			return accountIdentifiers.Count;
		}

		///// <summary>
		///// Maps the associated resultants for the utility determinant
		///// </summary>
		///// <param name="utilityAccount">Utility account object</param>
		///// <returns>Returns a new utility account object with mapped properties.</returns>
		//public static UtilityAccount MapUtilityClassData(UtilityAccount utilityAccount)
		//{
		//    string errorDescriptions = "";
		//    return MapUtilityClassData(utilityAccount, out errorDescriptions);
		//}
		/// <summary>
		/// Needs to be merged with ApplyMapping eventually.
		/// </summary>
		/// <param name="aid"></param>
		/// <param name="fieldName"></param>
		/// <param name="fieldValue"></param>
		public static void ApplyMappingForUtilityMappingsUpload(AccountIdentifier aid, TrackedField fieldName, string fieldValue, FieldMap map)
		{

			#region apply all else maps for utility -- cannot be used to fill determinants
			if(fieldName == TrackedField.Utility)
			{
				foreach(var resultant in map.Resultants)
				{
					var item = FieldHistoryManager.GetItem(aid, resultant.ResultantField);
					if((item == null || !item.HasValue || item.ErrorStatus.Contains("not found in history")) && map.MappingStyle == MappingRuleType.FillIfNoHistory)
					{
						FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingAllElseFillDefaultValue, "System", FieldLockStatus.Unknown);
					}
				}
				foreach(var resultant in map.Resultants)
				{
					if(map.MappingStyle == MappingRuleType.ReplaceValueAlways)
					{
						FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingAllElseOverwriteAlways, "System", FieldLockStatus.Unknown);
					}
					else if(map.MappingStyle == MappingRuleType.ReplaceIfValueExists)
					{
						var item = FieldHistoryManager.GetItem(aid, resultant.ResultantField);
						if(item != null && item.HasValue && !item.ErrorStatus.Contains("not found in history"))
						{
							FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingAllElseOverwriteExisting, "System", FieldLockStatus.Unknown);
						}
					}
				}
				return;
			}
			#endregion


			#region Apply other mapping here -- cannot be used to fill determinants

			foreach(var resultant in map.Resultants)
			{
				var item = FieldHistoryManager.GetItem(aid, resultant.ResultantField);
				if((item == null || !item.HasValue || item.ErrorStatus.Contains("not found in history")) && map.MappingStyle == MappingRuleType.FillIfNoHistory)
				{
					FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingFillDefaultValue, "System", FieldLockStatus.Unknown);
				}
			}
			foreach(var resultant in map.Resultants)
			{
				if(map.MappingStyle == MappingRuleType.ReplaceValueAlways)
				{
					FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingOverwriteAlways, "System", FieldLockStatus.Unknown);
				}
				else if(map.MappingStyle == MappingRuleType.ReplaceIfValueExists)
				{
					var item = FieldHistoryManager.GetItem(aid, resultant.ResultantField);
					if(item != null && item.HasValue && !item.ErrorStatus.Contains("not found in history"))
					{
						FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingOverwriteExisting, "System", FieldLockStatus.Unknown);
					}
				}

			}
			#endregion
		}

		public static void ApplyMapping(AccountIdentifier aid, TrackedField fieldName, string fieldValue, string aliasValue = null)
		{

			#region Apply aliasing here (can be used to fill determinants, even from empty values)
			if(aliasValue == null)
			{
				var aliasCacheValue = "";
				var hasAlias = GetDeterminantAliasValueFromCache(aid.UtilityCode, fieldName, fieldValue, out aliasCacheValue);
				if(hasAlias == true)
				{
					FieldHistoryManager.FieldValueInsert(aid, fieldName, aliasCacheValue, null, FieldUpdateSources.MappingAliasing, "System", FieldLockStatus.Unknown);
					fieldValue = aliasCacheValue;  //continue and engage any mapping based on aliased value
				}
			}
			else
			{
				FieldHistoryManager.FieldValueInsert(aid, fieldName, aliasValue, null, FieldUpdateSources.MappingAliasing, "System", FieldLockStatus.Unknown);
				fieldValue = aliasValue;  //continue and engage any mapping based on aliased value
			}
			#endregion

			var fieldMaps = CreateFieldMaps();
			#region apply all else maps for utility -- cannot be used to fill determinants
			if(fieldName == TrackedField.Utility)
			{
				var allElseMaps = CreateAllElseMaps();
				var allElseMapsToApply = allElseMaps.Where(s => s.UtilityCode.Equals(aid.UtilityCode)).ToArray();
				foreach(var map in allElseMapsToApply)
				{
					foreach(var resultant in map.Resultants)
					{
						var item = FieldHistoryManager.GetItem(aid, resultant.ResultantField);
						if((item == null || !item.HasValue || item.ErrorStatus.Contains("not found in history")) && map.MappingStyle == MappingRuleType.FillIfNoHistory)
						{
							FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingAllElseFillDefaultValue, "System", FieldLockStatus.Unknown);
						}
					}
					foreach(var resultant in map.Resultants)
					{
						if(map.MappingStyle == MappingRuleType.ReplaceValueAlways)
						{
							FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingAllElseOverwriteAlways, "System", FieldLockStatus.Unknown);
						}
						else if(map.MappingStyle == MappingRuleType.ReplaceIfValueExists)
						{
							var item = FieldHistoryManager.GetItem(aid, resultant.ResultantField);
							if(item != null && item.HasValue && item.ErrorStatus.Contains("not found in history"))
							{
								FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingAllElseOverwriteExisting, "System", FieldLockStatus.Unknown);
							}
						}
					}
				}
				return;
			}
			#endregion


			#region Apply other mapping here -- cannot be used to fill determinants
			var mapToApply = fieldMaps.Where(s => s.UtilityCode.Equals(aid.UtilityCode) && s.DeterminantField == fieldName && s.DeterminantValue == fieldValue).ToArray();
			if(mapToApply != null && mapToApply.Length > 0)
			{
				FieldMap map = mapToApply[0];
				foreach(var resultant in map.Resultants)
				{
					var item = FieldHistoryManager.GetItem(aid, resultant.ResultantField);
					if((item == null || !item.HasValue || item.ErrorStatus.Contains("not found in history")) && map.MappingStyle == MappingRuleType.FillIfNoHistory)
					{
						FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingFillDefaultValue, "System", FieldLockStatus.Unknown);
					}
				}
				foreach(var resultant in map.Resultants)
				{
					if(map.MappingStyle == MappingRuleType.ReplaceValueAlways)
					{
						FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingOverwriteAlways, "System", FieldLockStatus.Unknown);
					}
					else if(map.MappingStyle == MappingRuleType.ReplaceIfValueExists)
					{
						var item = FieldHistoryManager.GetItem(aid, resultant.ResultantField);
						if(item != null && item.HasValue && !item.ErrorStatus.Contains("not found in history"))
						{
							FieldHistoryManager.FieldValueInsert(aid, resultant.ResultantField, resultant.ResultantValue, null, FieldUpdateSources.MappingOverwriteExisting, "System", FieldLockStatus.Unknown);
						}
					}

				}
			}
			#endregion
		}

		#region DeterminantAlias Support

		public static DeterminantAlias DeactivateDeterminantAlias(int id)
		{
			var ds = UtilityMappingSql.DeactivateDeterminantAlias(id);
			return BuildDeterminantAlias(ds);
		}

		public static DeterminantAlias InsertDeterminantAlias(string utilityCode, TrackedField fieldName, string originalValue, string aliasValue, string userIdentity)
		{
			var ds = UtilityMappingSql.InsertDeterminantAlias(utilityCode, fieldName.ToString(), originalValue, aliasValue, userIdentity);
			return BuildDeterminantAlias(ds);
		}

		public static bool GetDeterminantAliasValueFromCache(string utilityCode, TrackedField fieldName, string fieldValue, out string aliasValue)
		{
			aliasValue = "";

			List<DeterminantAlias> das = null;

			// Abhi Kulkarni (02/04/2014) - In case this library is used by a web application then make use of the HttpContext's cache, else use the System.Runtime.Cache
			if(System.Web.HttpContext.Current != null)
				das = System.Web.HttpContext.Current.Cache["DeterminantAliasCollection"] as List<DeterminantAlias>;

			else if(Cache.Contains("DeterminantAliasCollection"))
				das = Cache["DeterminantAliasCollection"] as List<DeterminantAlias>;

			if(das == null)
			{
				das = GetAllDeterminantAliases(DateTime.Now);

				// HttpContext's Cache
				if(System.Web.HttpContext.Current != null)
					System.Web.HttpContext.Current.Cache.Add("DeterminantAliasCollection", das, null, DateTime.Now + TimeSpan.FromSeconds(300), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Default, null);

				// System.Runtime.Cache
				else if(Cache.Contains("DeterminantAliasCollection") == false)
					Cache.Add("DeterminantAliasCollection", das, DateTime.Now + TimeSpan.FromSeconds(300));

			}
			var dasFiltered = das.Where(s => s.UtilityCode.Equals(utilityCode) && s.FieldName == fieldName && s.OriginalValue.Equals(fieldValue)).ToList();
			if(dasFiltered != null && dasFiltered.Count > 0)
			{
				aliasValue = dasFiltered[0].AliasValue;
				return true;
			}
			return false;

		}

		public static List<DeterminantAlias> GetAllDeterminantAliases(DateTime? contextDate = null)
		{
			if(!contextDate.HasValue)
				contextDate = DateTime.Now;
			var ds = UtilityMappingSql.DeterminantAliasSelectAll(contextDate.Value);
			var aliases = BuildDeterminantAliasCollection(ds);
			aliases = aliases.Where(s => s.Active == true).ToList();
			return aliases;

		}

		private static List<DeterminantAlias> BuildDeterminantAliasCollection(DataSet ds)
		{
			var aliases = new List<DeterminantAlias>();
			if(ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
			{
				foreach(DataRow row in ds.Tables[0].Rows)
				{

					var alias = BuildDeterminantAlias(row);
					aliases.Add(alias);
				}
			}
			return aliases;
		}

		private static DeterminantAlias BuildDeterminantAlias(DataSet ds)
		{
			if(ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
			{
				var row = ds.Tables[0].Rows[0];
				return BuildDeterminantAlias(row);
			}
			return null;
		}

		private static DeterminantAlias BuildDeterminantAlias(DataRow dr)
		{
			int id = -1;
			int.TryParse(dr["ID"].ToString(), out id);
			string utilityCode = dr["UtilityCode"].ToString();
			var fieldName = TrackedField.Unknown;
			Enum.TryParse(dr["FieldName"].ToString(), out fieldName);
			var originalValue = dr["OriginalValue"].ToString();
			var aliasValue = dr["AliasValue"].ToString();
			var userIdentity = dr["UserIdentity"].ToString();
			var dateCreated = (DateTime)dr["DateCreated"];
			var active = (bool)dr["Active"];
			return new DeterminantAlias(id, utilityCode, fieldName, originalValue, aliasValue, userIdentity, dateCreated, active);
		}

		#endregion

		#region obsolete
		//private static UtilityClassMappingDeterminant SetDeterminantTypeAndValue(UtilityClassMappingDeterminant[] determinants, UtilityClassMapping map, out TrackedField determinantType, out  string determinantValue)
		//{
		//    determinantType = TrackedField.Unknown;
		//    determinantValue = "";
		//    UtilityClassMappingDeterminant d = null;
		//    foreach (var item in determinants)
		//    {
		//        switch (item.Driver)
		//        {
		//            case "ServiceClassID":
		//                if (!string.IsNullOrEmpty(map.ServiceClassCode))
		//                {
		//                    determinantType = TrackedField.ServiceClass;
		//                    determinantValue = map.ServiceClassCode;
		//                    return item;
		//                }
		//                break;
		//            case "LoadShapeID":
		//                if (!string.IsNullOrEmpty(map.LoadShapeCode))
		//                {
		//                    determinantType = TrackedField.LoadShapeID;
		//                    determinantValue = map.LoadShapeCode;
		//                    return item;
		//                }
		//                break;
		//            case "VoltageID":
		//                if (!string.IsNullOrEmpty(map.VoltageCode))
		//                {
		//                    determinantType = TrackedField.Voltage;
		//                    determinantValue = map.VoltageCode;
		//                    return item;
		//                }
		//                break;
		//            case "Zone":
		//            case "ZoneID":
		//            case "ZoneCode":
		//                if (!string.IsNullOrEmpty(map.ZoneCode))
		//                {
		//                    determinantType = TrackedField.Zone;
		//                    determinantValue = map.ZoneCode;
		//                    return item;
		//                }
		//                break;
		//            case "LossFactor":
		//                if (map.LossFactor.HasValue)
		//                {
		//                    determinantType = TrackedField.LossFactor;
		//                    determinantValue = map.LossFactor.ToString();
		//                    return item;
		//                }
		//                break;
		//            case "LoadProfileID":
		//                if (!string.IsNullOrEmpty(map.LoadProfileCode))
		//                {
		//                    determinantType = TrackedField.LoadProfile;
		//                    determinantValue = map.LoadProfileCode;
		//                    return item;
		//                }
		//                break;
		//            case "MeterType":
		//                if (!string.IsNullOrEmpty(map.MeterTypeCode))
		//                {
		//                    determinantType = TrackedField.MeterType;
		//                    determinantValue = map.MeterTypeCode;
		//                    return item;
		//                }
		//                break;
		//            case "RateClassID":
		//                if (!string.IsNullOrEmpty(map.RateClassCode))
		//                {
		//                    determinantType = TrackedField.RateClass;
		//                    determinantValue = map.RateClassCode;
		//                    return item;
		//                }
		//                break;
		//            case "TariffCodeID":
		//                if (!string.IsNullOrEmpty(map.TariffCode))
		//                {
		//                    determinantType = TrackedField.TariffCode;
		//                    determinantValue = map.TariffCode;
		//                    return item;
		//                }
		//                break;
		//            case "CustomerType":
		//                if (!string.IsNullOrEmpty(map.AccountTypeDescription))
		//                {
		//                    determinantType = TrackedField.AccountType;
		//                    determinantValue = map.AccountTypeDescription;
		//                    return item;
		//                }
		//                break;
		//            default:
		//                d = item;
		//                break;

		//        }
		//    }
		//    //if no standard determinant is defined it is an all else map
		//    determinantType = TrackedField.Utility;
		//    determinantValue = map.UtilityCode;
		//    return d;

		//}
		#endregion

		#region obsolete
		//private static UtilityClassMappingDeterminant SetDeterminantTypeAndValue(UtilityClassMappingDeterminant[] determinants, UtilityZoneMapping map, out TrackedField determinantType, out  string determinantValue)
		//{
		//    determinantType = TrackedField.Unknown;
		//    determinantValue = "";
		//    foreach (var item in determinants)
		//    {
		//        switch (item.Driver)
		//        {
		//            case "LBMPZone":
		//                if (!string.IsNullOrEmpty(map.LBMPZone))
		//                {
		//                    determinantType = TrackedField.LBMPZone;
		//                    determinantValue = map.LBMPZone;
		//                    return item;
		//                }
		//                break;
		//            case "Zone":
		//            case "ZoneID":
		//            case "ZoneCode":
		//                if (!string.IsNullOrEmpty(map.ZoneCode))
		//                {
		//                    determinantType = TrackedField.Zone;
		//                    determinantValue = map.ZoneCode;
		//                    return item;
		//                }
		//                break;
		//            case "Grid":
		//                if (!string.IsNullOrEmpty(map.Grid))
		//                {
		//                    determinantType = TrackedField.Grid;
		//                    determinantValue = map.Grid;
		//                    return item;
		//                }
		//                break;
		//            default:
		//                return null;
		//                break;

		//        }
		//    }
		//    return null;

		//}
		#endregion

		#region obsolete
		//private static FieldMapResultant GetResultantFromMap(UtilityClassMappingResultant resultant, UtilityClassMapping map)
		//{

		//    switch (resultant.Result)
		//    {
		//        case "ServiceClassID":
		//            if (!string.IsNullOrEmpty(map.ServiceClassCode))
		//            {
		//                return new FieldMapResultant(TrackedField.ServiceClass, map.ServiceClassCode);

		//            }
		//            break;
		//        case "LoadShapeID":
		//            if (!string.IsNullOrEmpty(map.LoadShapeCode))
		//            {
		//                return new FieldMapResultant(TrackedField.LoadShapeID, map.LoadShapeCode);

		//            }
		//            break;
		//        case "VoltageID":
		//            if (!string.IsNullOrEmpty(map.VoltageCode))
		//            {
		//                return new FieldMapResultant(TrackedField.Voltage, map.VoltageCode);

		//            }
		//            break;
		//        case "Zone":
		//        case "ZoneID":
		//        case "ZoneCode":
		//            if (!string.IsNullOrEmpty(map.ZoneCode))
		//            {
		//                return new FieldMapResultant(TrackedField.Zone, map.ZoneCode);

		//            }
		//            break;
		//        case "LossFactor":
		//            if (map.LossFactor.HasValue)
		//            {
		//                return new FieldMapResultant(TrackedField.LossFactor, map.LossFactor.ToString());
		//            }
		//            break;
		//        case "LoadProfileID":
		//            if (!string.IsNullOrEmpty(map.LoadProfileCode))
		//            {
		//                return new FieldMapResultant(TrackedField.LoadProfile, map.LoadProfileCode);
		//            }
		//            break;
		//        case "MeterType":
		//            if (!string.IsNullOrEmpty(map.MeterTypeCode))
		//            {
		//                return new FieldMapResultant(TrackedField.MeterType, map.MeterTypeCode);
		//            }
		//            break;
		//        case "RateClassID":
		//            if (!string.IsNullOrEmpty(map.RateClassCode))
		//            {
		//                return new FieldMapResultant(TrackedField.RateClass, map.RateClassCode);
		//            }
		//            break;
		//        case "TariffCodeID":
		//            if (!string.IsNullOrEmpty(map.TariffCode))
		//            {
		//                return new FieldMapResultant(TrackedField.TariffCode, map.TariffCode);
		//            }
		//            break;
		//        case "CustomerType":
		//            if (!string.IsNullOrEmpty(map.AccountTypeDescription))
		//            {
		//                return new FieldMapResultant(TrackedField.AccountType, map.AccountTypeDescription);
		//            }
		//            break;
		//        default:
		//            return null;
		//            break;
		//    }
		//    return null;
		//}

		//private static FieldMapResultant GetResultantFromMap(UtilityClassMappingResultant resultant, UtilityZoneMapping map)
		//{

		//    switch (resultant.Result)
		//    {

		//        case "LBMPZone":
		//            if (!string.IsNullOrEmpty(map.LBMPZone))
		//            {
		//                return new FieldMapResultant(TrackedField.LBMPZone, map.LBMPZone);
		//            }
		//            break;
		//        case "Zone":
		//        case "ZoneID":
		//        case "ZoneCode":
		//            if (!string.IsNullOrEmpty(map.ZoneCode))
		//            {
		//                return new FieldMapResultant(TrackedField.Zone, map.ZoneCode);
		//            }
		//            break;
		//        case "Grid":
		//            if (!string.IsNullOrEmpty(map.Grid))
		//            {
		//                return new FieldMapResultant(TrackedField.Grid, map.Grid);
		//            }
		//            break;
		//        default:
		//            return null;
		//            break;
		//    }
		//    return null;
		//}
		#endregion obsolete

		public static UtilityClassMappingList RetrieveUtilityClassMappingFromCache()
		{
			UtilityClassMappingList utilityMapping = null;
			if(HttpContext.Current != null) //check if data is cached already
			{
				utilityMapping = System.Web.HttpContext.Current.Application["UtilityClassMappingList"] as UtilityClassMappingList;
				if(utilityMapping == null)
				{
					utilityMapping = GetUtilityMapping();
					HttpContext.Current.Cache.Add("UtilityClassMappingList", utilityMapping, null, DateTime.Now + TimeSpan.FromMinutes(10), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Default, null);
				}

			}
			return utilityMapping;
		}

		//public static UtilityZoneMappingList RetrieveUtilityZoneMappingFromCache()
		//{
		//    UtilityZoneMappingList utilityMapping = null;
		//    if (HttpContext.Current != null) //check if data is cached already
		//    {
		//        utilityMapping = System.Web.HttpContext.Current.Application["UtilityZoneMappingList"] as UtilityZoneMappingList;
		//        if (utilityMapping == null)
		//        {
		//            utilityMapping = GetUtilityZoneMapping();
		//            HttpContext.Current.Cache.Add("UtilityZoneMappingList", utilityMapping, null, DateTime.Now + TimeSpan.FromMinutes(10), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Default, null);
		//        }

		//    }
		//    return utilityMapping;
		//}

		public static List<FieldMap> CreateAllElseMaps(DateTime? contextDate = null)
		{
			List<FieldMap> allElseMaps = null;

			// Abhi Kulkarni (02/04/2014) - In case this library is used by a web application then make use of the HttpContext's cache, else use the System.Runtime.Cache			
			if(HttpContext.Current != null)
				allElseMaps = System.Web.HttpContext.Current.Cache["AllElseMapping"] as List<FieldMap>;

			else if(Cache.Contains("AllElseMapping"))
				allElseMaps = Cache["AllElseMapping"] as List<FieldMap>;

			if(allElseMaps == null || allElseMaps.Count == 0)
			{
				var maps = LoadFieldMaps(contextDate);

				allElseMaps = maps.Where(s => s.DeterminantField == TrackedField.Utility).ToList();

				// Abhi Kulkarni (02/04/2014) - In case this library is used by a web application then make use of the HttpContext's cache, else use the System.Runtime.Cache

				// HttpContext's Cache
				if(HttpContext.Current != null && allElseMaps != null && allElseMaps.Count != 0)
					HttpContext.Current.Cache.Add("AllElseMapping", allElseMaps, null, DateTime.Now + TimeSpan.FromMinutes(60), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Default, null);
				else if(HttpContext.Current != null)
				{
					if(allElseMaps == null || allElseMaps.Count == 0)
						HttpContext.Current.Cache.Remove("AllElseMapping");
				}

				// System.Runtime.Cache
				if(Cache.Contains("AllElseMapping") == false && allElseMaps != null && allElseMaps.Count != 0)
					Cache.Add("AllElseMapping", allElseMaps, DateTime.Now + TimeSpan.FromMinutes(60));
				else if(Cache != null)
				{
					if(allElseMaps == null || allElseMaps.Count == 0)
						Cache.Remove("AllElseMapping");
				}


			}
			return allElseMaps;
		}

		//public static UtilityClassMapping CreateOldUtilityClassMapFromFieldMap(FieldMap fieldMap)
		//{
		//    var map = new UtilityClassMapping();
		//    var buf = "";

		//    map.UtilityCode = fieldMap.UtilityCode;
		//    map.UtilityFullName = fieldMap.UtilityCode;
		//    //map.UtilityID = 0;
		//    map.MarketCode = "";
		//    //map.MarketID = 0;
		//    //map.AccountTypeDescription = "";
		//    //map.AccountTypeID = 2;


		//    map.Icap = null;
		//    if (fieldMap.TryGetValue(TrackedField.ICap, out buf))
		//    {
		//        decimal icap = 0M;
		//        if (decimal.TryParse(buf, out icap))
		//            map.Icap = icap;
		//    }

		//    map.Identifier = fieldMap.ID;
		//    map.IsActive = true;

		//    //map.LoadProfileID = 0;
		//    map.LoadProfileCode = "";
		//    if (fieldMap.TryGetValue(TrackedField.LoadProfile, out buf))
		//    {
		//        map.LoadProfileCode = buf;
		//    }

		//    map.LoadShapeID = null;
		//    map.LoadShapeCode = "";
		//    if (fieldMap.TryGetValue(TrackedField.LoadShapeID, out buf))
		//    {
		//        map.LoadShapeCode = buf;
		//    }


		//    map.LossFactor = null;
		//    if (fieldMap.TryGetValue(TrackedField.LossFactor, out buf))
		//    {
		//        decimal losses = 0M;
		//        if (decimal.TryParse(buf, out losses))
		//            map.LossFactor = losses;
		//    }

		//    map.MappingStyle = fieldMap.MappingStyle;

		//    if (fieldMap.TryGetValue(TrackedField.MeterType, out buf))
		//    {

		//        map.MeterTypeCode = buf;
		//        if (buf.ToUpper().Contains("NON"))
		//            map.MeterTypeID = 1;
		//        else
		//            map.MeterTypeID = 2;
		//    }


		//    //map.RateClassID = 0;
		//    map.RateClassCode = "";
		//    if (fieldMap.TryGetValue(TrackedField.RateClass, out buf))
		//    {
		//        map.RateClassCode = buf;
		//    }

		//    //map.ServiceClassID = 0;
		//    map.ServiceClassCode = "";
		//    if (fieldMap.TryGetValue(TrackedField.ServiceClass, out buf))
		//    {
		//        map.ServiceClassCode = buf;
		//    }

		//    //map.TariffCodeID = 0;
		//    map.TariffCode = "";
		//    if (fieldMap.TryGetValue(TrackedField.TariffCode, out buf))
		//    {
		//        map.TariffCode = buf;
		//    }

		//    map.Tcap = null;
		//    if (fieldMap.TryGetValue(TrackedField.TCap, out buf))
		//    {
		//        decimal tcap = 0M;
		//        if (decimal.TryParse(buf, out tcap))
		//            map.Icap = tcap;
		//    }

		//    map.VoltageCode = "";
		//    //map.VoltageID = 0;
		//    if (fieldMap.TryGetValue(TrackedField.Voltage, out buf))
		//    {
		//        map.VoltageCode = buf;
		//    }

		//    map.ZoneCode = "";
		//    //map.ZoneId = 0;
		//    if (fieldMap.TryGetValue(TrackedField.Zone, out buf))
		//    {
		//        map.ZoneCode = buf;
		//    }

		//    return map;
		//}

		public static List<FieldMap> CreateAllFieldMapsNoCache(DateTime? contextDate = null)
		{
			List<FieldMap> allMaps = LoadFieldMaps(contextDate);
			return allMaps;
		}

		public static List<FieldMap> CreateFieldMaps(DateTime? contextDate = null)
		{
			List<FieldMap> allMaps = null;

			// Abhi Kulkarni (02/04/2014) - In case this library is used by a web application then make use of the HttpContext's cache, else use the System.Runtime.Cache

			if(HttpContext.Current != null && contextDate == null)
				allMaps = System.Web.HttpContext.Current.Cache["Mapping"] as List<FieldMap>;

			else if(Cache.Contains("Mapping") && contextDate == null)
				allMaps = Cache["Mapping"] as List<FieldMap>;

			if(allMaps == null || allMaps.Count == 0)
			{
				var maps = LoadFieldMaps(contextDate);

				allMaps = maps.Where(s => s.DeterminantField != TrackedField.Utility).ToList();


				// HttpContext's cache
				if(HttpContext.Current != null && allMaps != null && allMaps.Count != 0)
					HttpContext.Current.Cache.Add("Mapping", allMaps, null, DateTime.Now + TimeSpan.FromMinutes(60), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Default, null);
				else if(HttpContext.Current != null)
				{
					if(HttpContext.Current.Cache["Mapping"] != null && allMaps == null || allMaps.Count == 0)
						HttpContext.Current.Cache.Remove("Mapping");
				}

				// System.Runtime.Cache 
				if(Cache.Contains("Mapping") == false && allMaps != null && allMaps.Count != 0)
					Cache.Add("Mapping", allMaps, DateTime.Now + TimeSpan.FromMinutes(60));
				else if(Cache != null)
				{
					if(Cache.Contains("Mapping") && allMaps == null || allMaps.Count == 0)
						Cache.Remove("Mapping");
				}

			}
			return allMaps;
		}

		public static FieldMap LoadFieldMap(int id)
		{
			var fieldMaps = new List<FieldMap>();
			FieldMap fieldMap = null;
			var ds = UtilityMappingSql.LoadFieldMap(id);
			if(ds != null && ds.Tables.Count > 0)
			{

				foreach(DataRow row in ds.Tables[0].Rows)
				{
					var id2 = (int)row["ID"];
					var utilityCode = row["UtilityCode"].ToString();
					var determinantBuffer = row["DeterminantFieldName"].ToString();
					var determinantFieldName = TrackedField.Unknown;
					Enum.TryParse(determinantBuffer, out determinantFieldName);
					var determinantFieldValue = row["DeterminantValue"].ToString();
					var mappingRuleTypeBuffer = row["MappingRuleType"].ToString();
					var mappingRuleType = MappingRuleType.ReplaceValueAlways;
					Enum.TryParse(mappingRuleTypeBuffer, out mappingRuleType);
					var createdBy = row["CreatedBy"].ToString();
					var resultantFieldNameBuffer = row["ResultantFieldName"].ToString();
					var resultantFieldName = TrackedField.Unknown;
					Enum.TryParse(resultantFieldNameBuffer, out resultantFieldName);
					var resultantFieldValue = row["ResultantFieldValue"].ToString();
					var isActive = (bool)row["IsActive"];
					string groupID = row["GroupID"].ToString();
					if(isActive)
						fieldMaps = EditOrAppendOrCreateFieldMap(fieldMaps, id2, utilityCode, determinantFieldName, determinantFieldValue, mappingRuleType, createdBy, resultantFieldName, resultantFieldValue, groupID);
				}

				if(fieldMaps.Count > 0)
					fieldMap = fieldMaps[0];
			}
			return fieldMap;
		}

		public static List<FieldMap> LoadFieldMaps(DateTime? contextDate = null)
		{
			if(contextDate.HasValue == false)
				contextDate = DateTime.Now;


			var ds = UtilityMappingSql.LoadFieldMaps(contextDate.Value);
			if(ds != null && ds.Tables.Count > 0)
			{
				var fieldMaps = new List<FieldMap>();
				foreach(DataRow row in ds.Tables[0].Rows)
				{
					var id = (int)row["ID"];
					var utilityCode = row["UtilityCode"].ToString();
					var determinantBuffer = row["DeterminantFieldName"].ToString();
					var determinantFieldName = TrackedField.Unknown;
					Enum.TryParse(determinantBuffer, out determinantFieldName);
					var determinantFieldValue = row["DeterminantValue"].ToString();
					var mappingRuleTypeBuffer = row["MappingRuleType"].ToString();
					var mappingRuleType = MappingRuleType.ReplaceValueAlways;
					Enum.TryParse(mappingRuleTypeBuffer, out mappingRuleType);
					var createdBy = row["CreatedBy"].ToString();
					var resultantFieldNameBuffer = row["ResultantFieldName"].ToString();
					var resultantFieldName = TrackedField.Unknown;
					Enum.TryParse(resultantFieldNameBuffer, out resultantFieldName);
					var resultantFieldValue = row["ResultantFieldValue"].ToString();
					string groupID = row["GroupID"].ToString();
					fieldMaps = EditOrAppendOrCreateFieldMap(fieldMaps, id, utilityCode, determinantFieldName, determinantFieldValue, mappingRuleType, createdBy, resultantFieldName, resultantFieldValue, groupID);
				}
				return fieldMaps;
			}
			return null;
		}

		private static List<FieldMap> EditOrAppendOrCreateFieldMap(List<FieldMap> fieldMaps, int id, string utilityCode, TrackedField determinantFieldName,
			string determinantFieldValue, MappingRuleType mappingRuleType, string createdBy, TrackedField resultantFieldName, string resultantFieldValue, string groupID)
		{
			if(fieldMaps == null || fieldMaps.Count == 0)
			{
				var fieldMap = new FieldMap(utilityCode, mappingRuleType, determinantFieldName, determinantFieldValue);
				fieldMap.ID = id;
				fieldMap.GroupID = groupID;
				fieldMap.CreatedBy = createdBy;
				fieldMap.AddResultant(resultantFieldName, resultantFieldValue);
				fieldMaps.Add(fieldMap);
				return fieldMaps;
			}
			FieldMap match = null;
			try
			{
				#region  multiple determinants ?

				var matchingDeterminants = (from m in fieldMaps
											from r in m.Resultants
											where m.GroupID == groupID
											&& m.DeterminantField != determinantFieldName
											&& r.ResultantField == resultantFieldName
											select m).ToList();

				if(CollectionHelper.HasItem(matchingDeterminants))
				{
					foreach(FieldMap map in matchingDeterminants)
					{
						map.SetDeterminant2(determinantFieldName, determinantFieldValue);
					}
					return fieldMaps;
				}

				#endregion  multiple determinants ?

				//try very last one first
				var matchTry = fieldMaps[fieldMaps.Count - 1];

				if(matchTry.ID == id)
				{
					matchTry.AddResultant(resultantFieldName, resultantFieldValue);
					return fieldMaps;
				}

				var matches = fieldMaps.Where(s => s.ID == id).ToArray();

				if(matches != null && matches.Length == 1)
				{
					match = ((FieldMap[])matches)[0];

					if(match != null)
					{
						match.AddResultant(resultantFieldName, resultantFieldValue);
						return fieldMaps;
					}
				}
			}
			catch { } //1st chance exception; ignore

			if(match == null)
			{
				match = new FieldMap(utilityCode, mappingRuleType, determinantFieldName, determinantFieldValue);
				match.ID = id;
				match.GroupID = groupID;
				match.CreatedBy = createdBy;
				match.AddResultant(resultantFieldName, resultantFieldValue);
				fieldMaps.Add(match);
			}
			return fieldMaps;
		}

		// David Davis is the greatest PM ever.


		public static FieldMap SaveFieldMap(FieldMap fieldMap, DateTime? effectiveDate = null)
		{
			FieldMap map = null;
			var ds = UtilityMappingSql.InsertFieldMapDeterminant(fieldMap.UtilityCode, fieldMap.DeterminantField.ToString(),
														fieldMap.DeterminantValue, fieldMap.MappingStyle.ToString(), fieldMap.CreatedBy, effectiveDate);
			if(ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count == 1)
			{

				var id = (int)ds.Tables[0].Rows[0]["ID"];
				foreach(var resultant in fieldMap.Resultants)
				{
					UtilityMappingSql.InsertFieldMapResultant(id, resultant.ResultantField.ToString(), resultant.ResultantValue.ToString());
				}
				map = LoadFieldMap(id);
			}
			return map;
		}

		/// <summary>
		/// Needs to get merged with ApplyFieldMapToAllTargetAccounts eventually
		/// </summary>
		/// <param name="fieldMap"></param>
		/// <returns></returns>
		public static int ApplyFieldMapToAllTargetAccountsForUtilityMappingsUpload(FieldMap fieldMap)
		{
			var accountIdentifiers = FieldHistoryManager.GetAccountsByDeterminantValue(fieldMap.UtilityCode, fieldMap.DeterminantField, fieldMap.DeterminantValue);
			AccountCount += accountIdentifiers.Count;
			foreach(var aid in accountIdentifiers)
			{
				if(!AccountNumbers.Contains(aid.AccountNumber))
					AccountNumbers.Add(aid.AccountNumber);
				ApplyMappingForUtilityMappingsUpload(aid, fieldMap.DeterminantField, fieldMap.DeterminantValue, fieldMap);
			}
			return accountIdentifiers.Count;
		}

		public static int ApplyFieldMapToAllTargetAccounts(FieldMap fieldMap)
		{
			var accountIdentifiers = FieldHistoryManager.GetAccountsByDeterminantValue(fieldMap.UtilityCode, fieldMap.DeterminantField, fieldMap.DeterminantValue);
			AccountCount += accountIdentifiers.Count;
			foreach(var aid in accountIdentifiers)
			{
				if(!AccountNumbers.Contains(aid.AccountNumber))
					AccountNumbers.Add(aid.AccountNumber);
				ApplyMapping(aid, fieldMap.DeterminantField, fieldMap.DeterminantValue);
			}
			return accountIdentifiers.Count;
		}

		public static void DeactivateFieldMap(int id)
		{
			UtilityMappingSql.DeactivateFieldMap(id);
			if(HttpContext.Current != null)
				System.Web.HttpContext.Current.Cache.Remove("Mapping");
		}

		#region obsolete
		///// <summary>
		///// Maps the associated resultants for the utility determinant
		///// </summary>
		///// <param name="utilityAccount">Utility account object</param>
		///// <returns>Returns a new utility account object with mapped properties.</returns>
		//public static UtilityAccount MapUtilityClassData(UtilityAccount utilityAccount, out string result)
		//{
		//    result = "";
		//    UtilityAccount account = CopyAccountProperties(utilityAccount);
		//    UtilityMapping mapping = account.UtilityMapping;
		//    UtilityClassMappingList classMappings = mapping.UtilityClassMappingList;
		//    UtilityZoneMappingList zoneMappings = mapping.UtilityZoneMappingList;
		//    UtilityClassMappingDeterminantList determinants = mapping.UtilityClassMappingDeterminantList;
		//    UtilityClassMapping ucm = null;
		//    UtilityZoneMapping uzm = null;

		//    foreach (UtilityClassMappingDeterminant d in determinants)
		//    {
		//        string driver = d.Driver;
		//        UtilityClassMappingResultantList resultants = d.UtilityClassMappingResultantList;
		//        bool determinantExists = false;
		//        if (resultants != null && resultants.Count > 0)
		//        {
		//            #region get map
		//            switch (driver)
		//            {
		//                case "Grid":
		//                    {
		//                        if (!string.IsNullOrEmpty(account.Grid))
		//                        {
		//                            determinantExists = true;
		//                            result += string.Format("\r\nDriver [Grid] has existing value [{0}]", account.Grid);
		//                            var m =
		//                                from p in zoneMappings
		//                                where p.Grid == account.Grid
		//                                      && p.IsActive == true
		//                                select p;

		//                            uzm = m.FirstOrDefault();

		//                            if (uzm == null)
		//                                result += " and NO map is available.";
		//                            else
		//                                result += " and a map is available.";

		//                        }
		//                        break;
		//                    }
		//                case "LBMPZone":
		//                    {
		//                        if (!string.IsNullOrEmpty(account.LBMPZone))
		//                        {
		//                            determinantExists = true;
		//                            result += string.Format("\r\nDriver [LBMPZone] has existing value [{0}]", account.LBMPZone);
		//                            var m =
		//                                from p in zoneMappings
		//                                where p.LBMPZone == account.LBMPZone
		//                                      && p.IsActive == true
		//                                select p;

		//                            uzm = m.FirstOrDefault();

		//                            if (uzm == null)
		//                                result += " and NO map is available.";
		//                            else
		//                                result += " and a map is available.";
		//                        }
		//                        break;
		//                    }
		//                case "LoadProfileID":
		//                    {
		//                        if (!string.IsNullOrEmpty(account.LoadProfile))
		//                        {
		//                            determinantExists = true;
		//                            result += string.Format("\r\nDriver [LoadProfile] has existing value [{0}]", account.LoadProfile);
		//                            var m =
		//                                from p in classMappings
		//                                where (p.LoadProfileCode == account.LoadProfile
		//                                       || p.LoadProfileCode.ToLower() == "all")
		//                                      && p.IsActive == true
		//                                select p;

		//                            ucm = m.FirstOrDefault();

		//                            if (ucm == null)
		//                                result += " and NO map is available.";
		//                            else
		//                                result += " and a map is available";
		//                        }
		//                        break;
		//                    }
		//                case "LoadShapeID":
		//                    {
		//                        if (!string.IsNullOrEmpty(account.LoadShapeId))
		//                        {
		//                            determinantExists = true;
		//                            result += string.Format("\r\nDriver [LoadShapeID] has existing value [{0}]", account.LoadShapeId);
		//                            var m =
		//                                from p in classMappings
		//                                where (p.LoadShapeCode == account.LoadShapeId
		//                                       || p.LoadShapeCode.ToLower() == "all")
		//                                      && p.IsActive == true
		//                                select p;

		//                            ucm = m.FirstOrDefault();
		//                            if (ucm == null)
		//                                result += " and NO map is available.";
		//                            else
		//                                result += " and a map is available.";
		//                        }
		//                        break;
		//                    }
		//                case "RateClassID":
		//                    {
		//                        if (!string.IsNullOrEmpty(account.RateClass))
		//                        {
		//                            determinantExists = true;
		//                            result += string.Format("\r\nDriver [RateClassID] has existing value [{0}]", account.RateClass);
		//                            var m =
		//                                from p in classMappings
		//                                where (p.RateClassCode == account.RateClass
		//                                       || p.RateClassCode.ToLower() == "all")
		//                                      && p.IsActive == true
		//                                select p;

		//                            ucm = m.FirstOrDefault();

		//                            if (ucm == null)
		//                                result += " and NO map is available.";
		//                            else
		//                                result += " and a map is available.";
		//                        }
		//                        break;
		//                    }
		//                case "ServiceClassID":
		//                    {
		//                        if (!string.IsNullOrEmpty(account.ServiceClass))
		//                        {
		//                            determinantExists = true;
		//                            result += string.Format("\r\nDriver [ServiceClass] has existing value [{0}]", account.ServiceClass);
		//                            var m =
		//                                from p in classMappings
		//                                where (p.ServiceClassCode == account.ServiceClass
		//                                       || p.ServiceClassCode.ToLower() == "all")
		//                                      && p.IsActive == true
		//                                select p;

		//                            ucm = m.FirstOrDefault();

		//                            if (ucm == null)
		//                                result += " and NO map is available.";
		//                            else
		//                                result += " and a map is available.";

		//                        }
		//                        break;
		//                    }
		//                case "TariffCodeID":
		//                    {
		//                        if (!string.IsNullOrEmpty(account.TariffCode))
		//                        {
		//                            determinantExists = true;
		//                            result += string.Format("\r\nDriver [TariffCode] has existing value [{0}]", account.TariffCode);
		//                            var m =
		//                                from p in classMappings
		//                                where (p.TariffCode == account.TariffCode
		//                                       || p.TariffCode.ToLower() == "all")
		//                                      && p.IsActive == true
		//                                select p;

		//                            ucm = m.FirstOrDefault();

		//                            if (ucm == null)
		//                                result += " and NO map is available.";
		//                            else
		//                                result += " and a map is available.";

		//                        }
		//                        break;
		//                    }
		//            }
		//            #endregion
		//        }
		//        // may have one zone for utility
		//        //if (uzm == null)
		//        //{
		//        //    var z =
		//        //        from p in zoneMappings
		//        //        where p.UtilityCode == account.UtilityCode
		//        //        && p.IsActive == true
		//        //        select p;

		//        //    uzm = z.FirstOrDefault();
		//        //}
		//        string moreResults = "";

		//        if (determinantExists)
		//            SetResultantValues(ref account, ucm, uzm, resultants, out moreResults);

		//        if (moreResults.Trim().Length > 0 && result.Trim().Length > 0)
		//            result += "\r\n";

		//        result += moreResults;
		//    }

		//    return account;
		//}

		//private static void SetResultantValues(ref UtilityAccount account, UtilityClassMapping ucm, UtilityZoneMapping uzm, UtilityClassMappingResultantList resultants, out string results)
		//{
		//    //only map resultants that do not have a value; with the exception of loss factor
		//    results = "";
		//    foreach (UtilityClassMappingResultant r in resultants)
		//    {
		//        switch (r.Result)
		//        {
		//            case "AccountTypeID":
		//                {
		//                    if (string.IsNullOrEmpty(account.AccountType) && ucm != null && !string.IsNullOrEmpty(ucm.AccountTypeDescription))
		//                    {
		//                        account.AccountType = ucm.AccountTypeDescription;
		//                        if (results.Length > 0)
		//                            results += "\r\n";
		//                        results += string.Format("[AccountType] mapped successfully to '{0}'", ucm.AccountTypeDescription);
		//                    }
		//                    break;
		//                }
		//            case "LoadShapeID":
		//                {
		//                    if (string.IsNullOrEmpty(account.LoadShapeId) && ucm != null && !string.IsNullOrEmpty(ucm.LoadShapeCode))
		//                    {
		//                        account.LoadShapeId = ucm.LoadShapeCode;
		//                        if (results.Length > 0)
		//                            results += "\r\n";
		//                        results += string.Format("[LoadShape] mapped successfully to '{0}'", ucm.LoadShapeCode);
		//                    }

		//                    break;
		//                }
		//            case "LossFactor":  //always map this even it it has a value
		//                {
		//                    bool mapped = false;
		//                    if (ucm != null && ucm.LossFactor.HasValue && ucm.LossFactor > 0M)
		//                    {
		//                        account.LossFactor = ucm.LossFactor;
		//                        if (results.Length > 0)
		//                            results += "\r\n";
		//                        results += string.Format("[LossFactor] mapped successfully to {0}", ucm.LossFactor);
		//                    }

		//                    if (uzm != null && !mapped && uzm.LossFactor.HasValue && uzm.LossFactor > 0M) // for some mappings, loss factor will be in zone mapping instead of utility mapping
		//                    {
		//                        account.LossFactor = uzm.LossFactor;
		//                        if (results.Length > 0)
		//                            results += "\r\n";

		//                        if (mapped == false)
		//                            results += string.Format("[LossFactor] mapped successfully to {0}", uzm.LossFactor);
		//                        else
		//                            results += string.Format("[LossFactor] remapped from zone mapping to {0}; duplicate mappings for loss factor exist!", uzm.LossFactor);
		//                    }

		//                    break;
		//                }
		//            case "MeterType":
		//                {
		//                    bool mapped = false;
		//                    if (ucm != null && !string.IsNullOrEmpty(ucm.MeterTypeCode))
		//                    {
		//                        if (account.Meters != null)
		//                        {
		//                            foreach (Meter meter in account.Meters)
		//                            {
		//                                if (meter.MeterType == MeterType.Unknown)
		//                                {
		//                                    meter.MeterType = (MeterType)Enum.Parse(typeof(MeterType), ucm.MeterTypeCode, true);
		//                                    mapped = true;
		//                                }
		//                            }
		//                        }
		//                        else if (ucm.MeterTypeCode.Length > 0) // add meter to collection to set meter type
		//                        {
		//                            account.AddMeter("", (MeterType)EnumHelper.GetEnumValueFromDescription(typeof(MeterType), ucm.MeterTypeCode));
		//                            mapped = true;
		//                        }

		//                        if (mapped)
		//                        {
		//                            if (results.Length > 0)
		//                                results += "\r\n"; results += string.Format("[MeterType] mapped successfully to '{0}'", ucm.MeterTypeCode);
		//                        }
		//                    }
		//                    break;
		//                }
		//            case "ServiceClassID":
		//                {
		//                    if (string.IsNullOrEmpty(account.ServiceClass) && ucm != null && !string.IsNullOrEmpty(ucm.ServiceClassCode))
		//                    {
		//                        account.ServiceClass = ucm.ServiceClassCode;
		//                        if (results.Length > 0)
		//                            results += "\r\n";
		//                        results += string.Format("[ServiceClass] mapped successfully to '{0}'", ucm.ServiceClassCode);
		//                    }
		//                    break;
		//                }
		//            case "VoltageID":
		//                {
		//                    if (string.IsNullOrEmpty(account.Voltage) && ucm != null && !string.IsNullOrEmpty(ucm.VoltageCode))
		//                    {
		//                        account.Voltage = ucm.VoltageCode;
		//                        if (results.Length > 0)
		//                            results += "\r\n";
		//                        results += string.Format("[Voltage] mapped successfully to '{0}'", ucm.VoltageCode);
		//                    }
		//                    break;
		//                }
		//            case "ZoneID":
		//                {
		//                    bool zoneMapped = false;
		//                    if (string.IsNullOrEmpty(account.ZoneCode) && ucm != null && !string.IsNullOrEmpty(ucm.ZoneCode))
		//                    {
		//                        account.ZoneCode = ucm.ZoneCode;
		//                        if (results.Length > 0)
		//                            results += "\r\n";
		//                        results += string.Format("[Zone] mapped successfully to '{0}'", ucm.ZoneCode);
		//                        zoneMapped = true;
		//                    }
		//                    if (string.IsNullOrEmpty(account.ZoneCode) && uzm != null && !string.IsNullOrEmpty(uzm.ZoneCode) && !zoneMapped)
		//                    {
		//                        account.ZoneCode = uzm.ZoneCode;
		//                        if (results.Length > 0)
		//                            results += "\r\n";
		//                        results += string.Format("[Zone] mapped successfully to '{0}'", uzm.ZoneCode);
		//                    }

		//                    break;
		//                }
		//        }
		//    }
		//}

		///// <summary>
		///// Creates a new utility account object, copying all properties from passed in utility account.
		///// </summary>
		///// <param name="accountCopyFrom">Utility account object to be copied.</param>
		///// <returns>Returns a new utility account object, copying all properties from passed in utility account.</returns>
		//public static UtilityAccount CopyAccountProperties(UtilityAccount accountCopyFrom)
		//{
		//    var accountCopyTo = new UtilityAccount(accountCopyFrom.AccountNumber);
		//    accountCopyTo = CommonBusiness.CommonShared.ObjectClone<UtilityAccount>.Clone(accountCopyTo, accountCopyFrom);

		//    #region obsolete
		//    //UtilityAccount accountCopyTo = new UtilityAccount( accountCopyFrom.AccountNumber );
		//    //accountCopyTo.AccountType = accountCopyFrom.AccountType;
		//    //accountCopyTo.BillGroup = accountCopyFrom.BillGroup;
		//    //accountCopyTo.BillingAccount = accountCopyFrom.BillingAccount;
		//    //accountCopyTo.BillingAddress = accountCopyFrom.BillingAddress;
		//    //accountCopyTo.CustomerName = accountCopyFrom.CustomerName;
		//    //accountCopyTo.Cycle = accountCopyFrom.Cycle;
		//    //accountCopyTo.EnergyServiceProvider = accountCopyFrom.EnergyServiceProvider;
		//    //accountCopyTo.Exception = accountCopyFrom.Exception;
		//    //accountCopyTo.Icap = accountCopyFrom.Icap;
		//    //accountCopyTo.Grid = accountCopyFrom.Grid;
		//    //accountCopyTo.LBMPZone = accountCopyFrom.LBMPZone;
		//    //accountCopyTo.LoadProfile = accountCopyFrom.LoadProfile;
		//    //accountCopyTo.LoadShapeId = accountCopyFrom.LoadShapeId;
		//    //accountCopyTo.LossFactor = accountCopyFrom.LossFactor;
		//    //accountCopyTo.MeterInstaller = accountCopyFrom.MeterInstaller;
		//    //accountCopyTo.MeterMaintainer = accountCopyFrom.MeterMaintainer;
		//    //accountCopyTo.MeterOption = accountCopyFrom.MeterOption;
		//    //accountCopyTo.MeterOwner = accountCopyFrom.MeterOwner;
		//    //accountCopyTo.MeterReadCycleId = accountCopyFrom.MeterReadCycleId;
		//    //accountCopyTo.MeterReader = accountCopyFrom.MeterReader;
		//    //accountCopyTo.Meters = accountCopyFrom.Meters;
		//    //accountCopyTo.NameKey = accountCopyFrom.NameKey;
		//    //accountCopyTo.RateClass = accountCopyFrom.RateClass;
		//    //accountCopyTo.RateCode = accountCopyFrom.RateCode;
		//    //accountCopyTo.RetailMarketCode = accountCopyFrom.RetailMarketCode;
		//    //accountCopyTo.ServiceAddress = accountCopyFrom.ServiceAddress;
		//    //accountCopyTo.ServiceClass = accountCopyFrom.ServiceClass;
		//    //accountCopyTo.StratumVariable = accountCopyFrom.StratumVariable;
		//    //accountCopyTo.SupplyGroup = accountCopyFrom.SupplyGroup;
		//    //accountCopyTo.TariffCode = accountCopyFrom.TariffCode;
		//    //accountCopyTo.Tcap = accountCopyFrom.Tcap;
		//    //accountCopyTo.Usages = accountCopyFrom.Usages;
		//    //accountCopyTo.UtilityCode = accountCopyFrom.UtilityCode;
		//    //accountCopyTo.UtilityMapping = accountCopyFrom.UtilityMapping;
		//    //accountCopyTo.Voltage = accountCopyFrom.Voltage;
		//    //accountCopyTo.ZoneCode = accountCopyFrom.ZoneCode;
		//    #endregion

		//    return accountCopyTo;
		//}
		#endregion

		public static int UtilityZoneMappingExists(int utilityId, string driverFieldName, string driverValue)
		{
			return UtilitySql.UtilityZoneMappingExists(utilityId, driverFieldName, driverValue);
		}

		public static int ZoneIDByZoneCodeAndUtilityId(int utilityId, string zoneCode)
		{
			return UtilitySql.ZoneIDByZoneCodeAndUtilityId(utilityId, zoneCode);
		}

		public static void UtilityClassLossFactorUpdate(int marketId, int utilityId, int accountType, string active, int voltageId, decimal lossFactor)
		{
			UtilityMappingSql.UtilityClassLossFactorUpdate(marketId, utilityId, accountType, active, voltageId, lossFactor);
		}

		public static void UtilityZoneLossFactorUpdate(int marketId, int utilityId, string active, decimal lossFactor)
		{
			UtilityMappingSql.UtilityZoneLossFactorUpdate(marketId, utilityId, active, lossFactor);
		}

		public static bool ZoneIdExistsForUtilityId(string utility, string zoneCode)
		{
			return UtilitySql.ZoneIdExistsForUtilityId(utility, zoneCode);
		}

		///// <summary>
		///// Updates offer engine account with mapped data
		///// </summary>
		///// <param name="account">Utility account object</param>
		//public static void UpdateOfferEngineAccountWithMappedData(UtilityAccount account)
		//{
		//    string accountNumber = account.AccountNumber;
		//    string utilityCode = account.UtilityCode;
		//    string grid = account.Grid;
		//    decimal icap = Convert.ToDecimal(account.Icap == null ? -1 : account.Icap);
		//    string lbmpZone = account.LBMPZone;
		//    string loadProfile = account.LoadProfile;
		//    string loadShapeId = account.LoadShapeId;
		//    decimal losses = Convert.ToDecimal(account.LossFactor == null ? 0 : account.LossFactor);
		//    string rateClass = account.RateClass;
		//    string rateCode = account.RateCode;
		//    string tariffCode = account.TariffCode;
		//    decimal tcap = Convert.ToDecimal(account.Tcap == null ? -1 : account.Tcap);
		//    string voltage = account.Voltage;
		//    string zone = account.ZoneCode;

		//    OfferSql.UpdateAccount(accountNumber, utilityCode, String.Empty, icap, tcap, losses, loadShapeId, voltage, rateClass, zone,
		//            String.Empty, String.Empty, tariffCode, loadProfile, grid, lbmpZone, rateCode);
		//}

		public static bool IsLossFactorMappedInUtilityZoneMappings(int utilityId)
		{
			return UtilityMappingSql.IsLossFactorMappedInUtilityZoneMappings(utilityId);
		}

		public static bool IsZoneMappedInUtilityZoneMappings(int utilityId)
		{
			return UtilityMappingSql.IsZoneMappedInUtilityZoneMappings(utilityId);
		}

		public static bool IsLossFactorMappedInUtilityClassMappings(int utilityId)
		{
			return UtilityMappingSql.IsLossFactorMappedInUtilityClassMappings(utilityId);
		}

		public static bool IsZoneMappedInUtilityClassMappings(int utilityId)
		{
			return UtilityMappingSql.IsZoneMappedInUtilityClassMappings(utilityId);
		}

		public static bool IsLossFactorMappedInUtilityZoneMappings(string utilityCode)
		{
			return UtilityMappingSql.IsLossFactorMappedInUtilityZoneMappings(utilityCode);
		}

		public static bool IsZoneMappedInUtilityZoneMappings(string utilityCode)
		{
			return UtilityMappingSql.IsZoneMappedInUtilityZoneMappings(utilityCode);
		}

		public static bool IsLossFactorMappedInUtilityClassMappings(string utilityCode)
		{
			return UtilityMappingSql.IsLossFactorMappedInUtilityClassMappings(utilityCode);
		}

		public static bool IsZoneMappedInUtilityClassMappings(string utilityCode)
		{
			return UtilityMappingSql.IsZoneMappedInUtilityClassMappings(utilityCode);
		}

		public static List<BindableFieldMap> BuildBindableFieldMaps(List<FieldMap> maps)
		{
			var bindableMaps = new List<BindableFieldMap>();

			if(maps != null)
			{
				bindableMaps.AddRange(maps.Select(map => new BindableFieldMap(map)));
			}

			var utilitiesAndMarkets = UtilitySql.GetUtilitiesAndMarkets().Tables[0];

			foreach(var map in bindableMaps)
			{
				map.MarketLabel = GetMarketCode(utilitiesAndMarkets, map.UtilityLabel);
			}

			return bindableMaps;
		}

		private static string GetMarketCode(DataTable utilitiesAndMarkets, string utilityCode)
		{

			var answer =
		   from row in utilitiesAndMarkets.AsEnumerable()
		   where row.Field<string>("UtilityCode") == utilityCode
		   select row;
			if(answer != null)
				return answer.ElementAt(0)["MarketCode"].ToString();
			return "0";
		}

		public static void DeActivateAllExistingFieldMaps()
		{
			UtilityMappingSql.DeActivateAllExistingFieldMaps();
		}

		public static MemoryStream ExportExcelFieldMaps(string templatePath)
		{
			Workbook excelWorkbook = new Workbook(templatePath);

			Worksheet excelSheet = excelWorkbook.Worksheets[0];

			try
			{
				List<FieldMap> fieldMaps = LoadFieldMaps();

				int rowOffset = 1;
				int i = 0;

				foreach(FieldMap fieldMap in fieldMaps)
				{
					int c = 0;

					string determinant2 = fieldMap.DeterminantField2.ToString().Equals(TrackedField.Unknown.ToString(), StringComparison.OrdinalIgnoreCase) ? String.Empty : fieldMap.DeterminantField2.ToString();

					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.MappingStyle.ToString());
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.DeterminantField.ToString());
					excelSheet.Cells[i + rowOffset, c++].PutValue(determinant2);
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.UtilityCode);
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.AccountType));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.Voltage));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.MeterType));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.RateClass));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.ServiceClass));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.LoadProfile));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.LoadShapeID));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.Zone));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.LBMPZone));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.Grid));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.TariffCode));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.LossFactor));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.ICap));
					excelSheet.Cells[i + rowOffset, c++].PutValue(fieldMap.GetValue(TrackedField.TCap));
					c++;

					i++;
				}

				MemoryStream excelStream = new MemoryStream();

				excelWorkbook.Save(excelStream, new OoxmlSaveOptions());

				return excelStream;
			}
			catch(Exception ex)
			{
				throw (ex);
			}
		}

	}
}
