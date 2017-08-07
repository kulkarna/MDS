using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.DataAccess.SqlAccess.CustomerManagementEF
{
    public partial class User
    {
        public string CompleteName
        {
            get
            {
                return string.Format( "{0} {1}", this.Firstname, this.Lastname );
            }
        }

        public string GridName
        {
            get
            {
                if( this.Firstname == this.Lastname )
                    return this.Firstname;
                else
                    return string.Format( "{0} {1}", this.Firstname, this.Lastname );
            }
        }

    }
}
