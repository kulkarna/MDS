

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using LibertyPower.Business.CommonBusiness.FieldHistory;

	[Serializable()]
	public class FieldMap
	{
		public FieldMap()
		{
		}
		public FieldMap(string utilityCode, MappingRuleType mappingRuleType)
		{
			_utilityCode = utilityCode;
			_mappingRuleType = mappingRuleType;
		}
		public FieldMap(string utilityCode, MappingRuleType mappingRuleType, TrackedField determinantField, string determinantValue)
		{
			_utilityCode = utilityCode;
			_mappingRuleType = mappingRuleType;
			_determinantField = determinantField;
			_determinantValue = determinantValue;
		}

		public FieldMap(string utilityCode, MappingRuleType mappingRuleType, TrackedField determinantField, string determinantValue,
			TrackedField determinantField2, string determinantValue2, string groupID)
		{
			_utilityCode = utilityCode;
			_mappingRuleType = mappingRuleType;
			_determinantField = determinantField;
			_determinantValue = determinantValue;
			_determinantField2 = determinantField2;
			_determinantValue2 = determinantValue2;
			GroupID = groupID;
		}

		public void SetDeterminant(TrackedField determinantField, string determinantValue)
		{
			_determinantField = determinantField;
			_determinantValue = determinantValue;
		}

		public void SetDeterminant(TrackedField determinantField, string determinantValue, string groupID)
		{
			_determinantField = determinantField;
			_determinantValue = determinantValue;
			GroupID = groupID;
		}

		public void SetDeterminant2(TrackedField determinantField2, string determinantValue2)
		{
			_determinantField2 = determinantField2;
			_determinantValue2 = determinantValue2;
		}

		public void AddResultant(TrackedField resultantField, string resultantValue)
		{
			if(resultantFields == null)
				resultantFields = new List<FieldMapResultant>();
			resultantFields.Add(new FieldMapResultant(resultantField, resultantValue));
		}

		public void AddResultant(TrackedField resultantField, string resultantValue, string groupID)
		{
			if(resultantFields == null)
				resultantFields = new List<FieldMapResultant>();
			resultantFields.Add(new FieldMapResultant(resultantField, resultantValue, groupID));
		}

		private MappingRuleType _mappingRuleType = MappingRuleType.ReplaceValueAlways;
		private string _utilityCode = "";
		private TrackedField _determinantField = TrackedField.Unknown;
		private string _determinantValue = "";
		private TrackedField _determinantField2 = TrackedField.Unknown;
		private string _determinantValue2 = "";
		private List<FieldMapResultant> resultantFields;

		public MappingRuleType MappingStyle
		{
			get
			{
				return _mappingRuleType;
			}
		}

		public string UtilityCode
		{
			get
			{
				return _utilityCode;
			}
		}

		public List<FieldMapResultant> Resultants
		{
			get
			{
				if(resultantFields == null)
					resultantFields = new List<FieldMapResultant>();
				return resultantFields;
			}
		}
		public TrackedField DeterminantField
		{
			get
			{
				return _determinantField;
			}
		}
		public string DeterminantValue
		{
			get
			{
				return _determinantValue;
			}
		}

		public TrackedField DeterminantField2
		{
			get
			{
				return _determinantField2;
			}
		}

		public string DeterminantValue2
		{
			get
			{
				return _determinantValue2;
			}
		}

		private DateTime? _dateCreated;
		public int ExcelSourceRow
		{
			get;
			set;
		}

		public Int32 ID
		{
			get;
			set;
		}

		public Int32 ID2
		{
			get;
			set;
		}

		public string Delete
		{
			get;
			set;
		}

		public DateTime? DateCreated
		{
			get { return _dateCreated; }

			set
			{
				if(_dateCreated.HasValue == false)
					_dateCreated = value;
			}
		}

		private string _createdBy;

		public string CreatedBy
		{
			get { return _createdBy; }

			set
			{
				_createdBy = value;
			}
		}

		public string GroupID
		{
			get;
			set;
		}

		public bool TryGetValue(TrackedField fieldName, out string fieldValue)
		{
			fieldValue = "";
			string field = fieldName.ToString();

			if(field.Equals(DeterminantField.ToString()))
			{
				fieldValue = DeterminantValue;
				return true;
			}
			else if(field.Equals(DeterminantField2.ToString()))
			{
				fieldValue = DeterminantValue2;
				return true;
			}

			if(Resultants == null)
				return false;

			var item = Resultants.Where(s => s.ResultantField == fieldName).ToArray();

			if(item == null || item.Length < 1)
				return false;

			fieldValue = ((FieldMapResultant)item[0]).ResultantValue;
			return true;

		}

		public string GetValue(TrackedField fieldName)
		{
			var fieldValue = "";
			string field = fieldName.ToString();

			if(field.Equals(DeterminantField.ToString()))
			{
				fieldValue = DeterminantValue;
				return fieldValue;
			}
			else if(field.Equals(DeterminantField2.ToString()))
			{
				fieldValue = DeterminantValue2;
				return fieldValue;
			}

			if(Resultants == null)
				return fieldValue;

			var item = Resultants.Where(s => s.ResultantField == fieldName).ToArray();

			if(item == null || item.Length < 1)
				return fieldValue;

			fieldValue = ((FieldMapResultant)item[0]).ResultantValue;
			return fieldValue;

		}

		public bool HasMultipleDeterminants
		{
			get { return DeterminantField2 != TrackedField.Unknown; }
		}

		public override string ToString()
		{
			var label = string.Format("{0}; {1}; {2}; {3}; {4}; {5}", ID, UtilityCode, DeterminantField.ToString(), DeterminantValue, DeterminantField2.ToString(), DeterminantValue2);
			return label;
		}

	}

	[Serializable()]
	public class FieldMapResultant
	{
		public FieldMapResultant(TrackedField resultantField, string resultantValue)
		{
			_resultantField = resultantField;
			_resultantValue = resultantValue;
		}

		public FieldMapResultant(TrackedField resultantField, string resultantValue, string groupID)
		{
			_resultantField = resultantField;
			_resultantValue = resultantValue;
			this.groupID = groupID;
		}

		private TrackedField _resultantField = TrackedField.Unknown;
		private string _resultantValue = "";
		private string groupID;

		public TrackedField ResultantField
		{
			get { return _resultantField; }
		}

		public string ResultantValue
		{
			get { return _resultantValue; }
		}

		public string GroupID
		{
			get { return groupID; }
		}

		public override string ToString()
		{
			return string.Format("{0}; {1}", _resultantField.ToString(), _resultantValue);
		}

	}
}
