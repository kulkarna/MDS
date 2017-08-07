using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Collections.ObjectModel;

namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
    public class IdrJsonConverter : JavaScriptConverter
    {

        public override IEnumerable<Type> SupportedTypes
        {
            //Define the ListItemCollection as a supported type.
            get { return new ReadOnlyCollection<Type>(new List<Type>(new Type[] { typeof(IdrValueExtended) })); }
        }

        public override IDictionary<string, object> Serialize(object obj, JavaScriptSerializer serializer)
        {
            IdrValueExtended value = obj as IdrValueExtended;

            if (value == null) return new Dictionary<string, object>();

            // Create the representation.
            Dictionary<string, object> result = new Dictionary<string, object>();
            if (value.O != null)
            {
                result.Add("O", value.O);
            }
            if (value.E != null)
            {
                result.Add("E", value.E);
            }
            if (value.A != null)
            {
                result.Add("A", value.A);
            }
            if( value.M != null )
            {
                result.Add( "M", value.M );
            }

            return result;
        }

        public override object Deserialize(IDictionary<string, object> dictionary, Type type, JavaScriptSerializer serializer)
        {
            if (dictionary == null)
                throw new ArgumentNullException("dictionary");

            if (type != typeof(IdrValueExtended)) return null;

            // Create the instance to deserialize into.
            var result = new IdrValueExtended(
                dictionary.ContainsKey("O") ? Convert.ToDecimal(dictionary["O"]) : (decimal?)null,
                dictionary.ContainsKey("E") ? Convert.ToDecimal(dictionary["E"]) : (decimal?)null,
                dictionary.ContainsKey("A") ? Convert.ToDecimal(dictionary["A"]) : (decimal?)null,
                dictionary.ContainsKey("M") ? Convert.ToDecimal(dictionary["M"]) : (decimal?)null
            );
            return result;
        }
    }
}
