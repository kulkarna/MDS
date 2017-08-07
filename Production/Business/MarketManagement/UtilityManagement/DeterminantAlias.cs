using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.Business.CommonBusiness.FieldHistory;
namespace LibertyPower.Business.MarketManagement.UtilityManagement
{
    [Serializable]
    public class DeterminantAlias
    {
        public DeterminantAlias(int id, string utilityCode, TrackedField fieldName, string originalValue, string aliasValue, string userIdentity, DateTime? dateCreated, bool active )
        {
            _id = id;
            _utilityCode = utilityCode;
            _fieldName = fieldName;
            _originalValue = originalValue;
            _aliasValue = aliasValue;
            _userIdentity = userIdentity;
            _dateCreated = dateCreated;
            _active = active;
        }
        private int _id;
        private string _utilityCode;
       
        private TrackedField _fieldName;
        private string _originalValue;
        private string _aliasValue;
        private string _userIdentity;
        private DateTime? _dateCreated;
        private bool _active;

        public int ID{get { return _id; }}
        public string UtilityCode{ get { return _utilityCode; } }
        public TrackedField FieldName { get { return _fieldName; } }
        public string OriginalValue { get { return _originalValue; } }
        public string AliasValue { get { return _aliasValue; } }
        public string UserIdentity { get { return _userIdentity; } }
        public DateTime ?  DateCreated { get { return _dateCreated; } }
        public bool Active { get { return _active; } }

        public override string ToString()
        {
            return string.Format("{0}, {1}, {2}, {3}", _utilityCode, _fieldName, _originalValue, _aliasValue);
        }

    }
}
