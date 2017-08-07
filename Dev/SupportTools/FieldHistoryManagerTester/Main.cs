using System;
using System.Collections.Generic;
using LibertyPower.Business.CommonBusiness.FieldHistory;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace FieldHistoryManagerTester
{
	[TestClass]
	public class Main
	{
		[TestMethod]
		public void TestFieldHistoryBulkInsert()
		{
			List<AccountPropertyHistoryRecord> items = new List<AccountPropertyHistoryRecord>();
			AccountIdentifier aid = new AccountIdentifier()
			{
				AccountNumber = "08037910450006289981",
				UtilityCode = "METED"

			};
			DateTime curr = DateTime.Now;
			items.Add( new AccountPropertyHistoryRecord()
			{
				AccountNumber = aid.AccountNumber,
				Utility = aid.UtilityCode,
				FieldName = TrackedField.LoadProfile.ToString(),
				FieldValue = "GSCM",
				EffectiveDate = curr,
				FieldSource = FieldUpdateSources.EDIParser.ToString(),
				CreatedBy = ""
		
			} );
			items.Add( new AccountPropertyHistoryRecord()
			{
				AccountNumber = aid.AccountNumber,
				Utility = aid.UtilityCode,
				FieldName =  TrackedField.RateClass.ToString(),
				FieldValue = "ME-GSMD",
				EffectiveDate = curr,
				FieldSource = FieldUpdateSources.EDIParser.ToString(),
				CreatedBy = ""

			} );

			items.Add( new AccountPropertyHistoryRecord()
			{
				AccountNumber = aid.AccountNumber,
				Utility = aid.UtilityCode,
				FieldName =  TrackedField.Voltage.ToString(),
				FieldValue = "20/240 volt single phase",
				EffectiveDate = curr,
				FieldSource = FieldUpdateSources.EDIParser.ToString(),
				CreatedBy = ""
			} );
			items.Add( new AccountPropertyHistoryRecord()
			{
				AccountNumber = aid.AccountNumber,
				Utility = aid.UtilityCode,
				FieldName =  TrackedField.ICap.ToString(),
				FieldValue = "8.677800",
				EffectiveDate = curr,
				FieldSource = FieldUpdateSources.EDIParser.ToString(),
				CreatedBy = ""

				

			} );
			FieldHistoryManager.FieldValueBulkInsert( items);
		}
	}
}
