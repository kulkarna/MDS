using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;

namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
    public partial class IdrAccountDetail
    {
        public IList<IdrValueExtended> Values { get; set; }

        public IdrAccountDetail() { }

        public IdrAccountDetail(int intervals)
        {
            var values = new List<IdrValueExtended>();

            for (var i = 0; i < intervals; i++)
                values.Add(new IdrValueExtended());

            Values = values;
        }

        public bool IsBlank()
        {
            return Values.All(v => v.OorE == null);
        }

        public void OnIntervalsChanged()
        {
            var serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new[] { new IdrJsonConverter() });
            Values = (List<IdrValueExtended>)serializer.Deserialize(Intervals, typeof(List<IdrValueExtended>));
        }

        public void OnValuesChanged()
        {
            var serializer = new JavaScriptSerializer();
            serializer.RegisterConverters(new[] { new IdrJsonConverter() });
            Intervals = serializer.Serialize(Values);
        }
    }
}