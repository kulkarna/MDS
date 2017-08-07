using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CommonBusiness.FieldHistory;

namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
	[Serializable()]
	public sealed class BindableFieldMap
	{
		public BindableFieldMap(FieldMap fieldMap)
		{
			_fieldMap = fieldMap;
		}

		public override string ToString()
		{
			return string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8}", _fieldMap.ID, MarketLabel, _fieldMap.UtilityCode, _fieldMap.DeterminantField, _fieldMap.ID2, _fieldMap.DeterminantValue, _fieldMap.DeterminantField2, _fieldMap.DeterminantValue2, _fieldMap.GroupID);
		}

		private FieldMap _fieldMap;

		public FieldMap Map
		{
			get { return _fieldMap; }
		}

		public Int32 Identifier
		{
			get { return _fieldMap.ID; }
		}

		public string MappingStyleLabel
		{
			get
			{
				return _fieldMap.MappingStyle.ToString();
			}
		}

		public string DeterminantNameLabel
		{
			get { return _fieldMap.DeterminantField.ToString(); }
		}

		public string DeterminantNameLabel2
		{
			get { return _fieldMap.DeterminantField2.ToString(); }
		}

		public string UtilityLabel
		{
			get
			{
				return _fieldMap.UtilityCode;
			}
		}

		private string marketLabel;
		public string MarketLabel
		{
			get
			{
				return marketLabel ?? "";
			}
			set { marketLabel = value; }
		}

		public string AccountTypeLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.AccountType, out field);
				return field;
			}
		}

		public string VoltageLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.Voltage, out field);
				return field;
			}
		}

		public string MeterTypeLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.MeterType, out field);
				return field;
			}
		}

		public string RateClassLabel
		{
			get
			{

				string field = "";
				_fieldMap.TryGetValue(TrackedField.RateClass, out field);
				return field;
			}
		}

		public string ServiceClassLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.ServiceClass, out field);
				return field;
			}
		}

		public string LoadShapeLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.LoadShapeID, out field);
				return field;
			}
		}

		public string LoadProfileLabel
		{
			get
			{

				string field = "";
				_fieldMap.TryGetValue(TrackedField.LoadProfile, out field);
				return field;
			}
		}

		public string TariffCodeLabel
		{
			get
			{

				string field = "";
				_fieldMap.TryGetValue(TrackedField.TariffCode, out field);
				return field;
			}
		}

		public string ZoneCodeLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.Zone, out field);
				return field;
			}
		}

		public string IcapLabel
		{
			get
			{

				string field = "";
				_fieldMap.TryGetValue(TrackedField.ICap, out field);
				return field;
			}
		}

		public string TcapLabel
		{
			get
			{

				string field = "";
				_fieldMap.TryGetValue(TrackedField.TCap, out field);
				return field;
			}
		}

		public string GridLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.Grid, out field);
				return field;
			}
		}

		public string LbmpZoneLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.LBMPZone, out field);
				return field;
			}
		}

		public string LossFactorLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.LossFactor, out field);
				return field;
			}
		}

		public string LossFactorIDLabel
		{
			get
			{
				string field = "";
				_fieldMap.TryGetValue(TrackedField.LossFactorID, out field);
				return field;
			}
		}

		public string MappingRuleLabel
		{
			get
			{
				return _fieldMap.MappingStyle.ToString();
			}
		}

		public string GroupID
		{
			get { return _fieldMap.GroupID; }
		}

		public string GroupIDLabel
		{
			get { return _fieldMap.GroupID == null || _fieldMap.GroupID.Length == 0 ? String.Empty : String.Format("...{0}", _fieldMap.GroupID.Substring(_fieldMap.GroupID.Length - 5)); }
		}
	}
}
