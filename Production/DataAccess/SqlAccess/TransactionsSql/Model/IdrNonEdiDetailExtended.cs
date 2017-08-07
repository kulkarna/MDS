using System;
using System.Collections.Generic;
using System.Linq;

namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
    public partial class IdrNonEdiDetail
    {
        public IList<decimal?> Values
        {
            get
            {
                return Intervals.Split(',').Select(v =>
                {
                    decimal d;
                    return Decimal.TryParse(v, out d) ? d : (decimal?)null;
                }).ToList();

            }
            set
            {
                Intervals = String.Join(",", value.Select(d => d.ToString()));
            }
        }

        public IdrNonEdiDetail Aggregate(IdrNonEdiDetail idrNonEdiDetail)
        {
            var v1 = Values;
            var v2 = idrNonEdiDetail.Values;
            var v3 = new List<decimal?>();
            var index = 0;

            //if( v1.Count > v2.Count )
            //    throw new Exception( "Data does not comply with the expected readings interval." );

            if( v1.Count == v2.Count || v1.Count > v2.Count )
                index = v2.Count;
            else
                index = v1.Count;

            for( var i = 0; i < index; i++ )
            {
                if (v1[i] != null)
                    if (v2[i] != null)
                        v3.Add(v1[i] + v2[i]);
                    else
                        v3.Add(v1[i]);
                else
                    v3.Add(v2[i]);
            }

            var d3 = new IdrNonEdiDetail
            {
                IdrDate = IdrDate,
                Values = v3
            };

            return d3;
        }
    }
}