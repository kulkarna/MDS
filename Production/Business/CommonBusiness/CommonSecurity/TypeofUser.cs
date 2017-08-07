using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    /// <summary>
    /// Enumeration used for deciding if a user is in active directory(internal) or not (external).
    /// </summary>
    public enum TypeofUser
    {
        INTERNAL = 1,
        EXTERNAL = 2,
    }
}
