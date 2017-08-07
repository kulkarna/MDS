namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model
{
    public class IdrValueExtended
    {
        // Original
        public decimal? O { get; set; } 

        // Estimated
        public decimal? E { get; set; }

        // Adjusted
        public decimal? A { get; set; }

        // Manually adjusted
        public decimal? M { get; set; }

        public decimal? OorE 
        { 
            //Return Original if not null, else return Estimated.
            get { return O ?? E; } 
        }

        public decimal? Adjusted
        {
            //Return adjusted.
            get { return A; }
        }

        public decimal? Estimated
        {
            //Return Estimated.
            get { return E; }
        }

        public decimal? Value
        {
            get { return M ?? A ?? E ?? O; }
        }

        public decimal? ValueExcludingManual
        {
            get { return A ?? E ?? O; }
        }

        public bool IsZero
        {
            get { return ((O == null) || (O == 0)); }
        }

        public static IdrValueExtended operator +(IdrValueExtended v1, IdrValueExtended v2)
        {
            if ((v1 != null) && (v2 != null))
                return new IdrValueExtended(v1.O + v2.O, v1.E + v2.E, v1.A + v2.A, v1.M + v2.M);
            return v1 ?? v2;
        }

        public IdrValueExtended() { }

        public IdrValueExtended(decimal? o, decimal? e, decimal? a, decimal? m)
        {
            O = o;
            E = e;
            A = a;
            M = m;
        }
    }
}
