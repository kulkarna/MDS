using System;
using System.Collections.Generic;
using System.Text;

namespace LibertyPower.Business.CustomerAcquisition.ProductManagement
{
	[Serializable]
    public static class Helper
    {

        public static T ConvertFromDB<T>(object obj)
        {
            T returnValue;

            //Special Handling for Strings: dr["item"].ToString() will return String.Empty if value is null
            //if default(T) is used, string will be null
            if (typeof(T).Equals(typeof(string)))
            {
                returnValue = (T)Convert.ChangeType(obj, typeof(T));
            }
            //if (obj is DBNull) // returns false if types are incompatible

            else if (obj == DBNull.Value)
            {
                returnValue = default(T);
            }

            /* http://msdn.microsoft.com/en-us/library/system.type.getgenerictypedefinition.aspx
            Quote: Use IsGenericType to determine whether a type is generic before calling GetGenericTypeDefinition */
            // Handle Nullable Types
            else if (typeof(T).IsGenericType && typeof(T).GetGenericTypeDefinition().Equals(typeof(Nullable<>)))
            {
                returnValue = (T)Convert.ChangeType(obj, Nullable.GetUnderlyingType(typeof(T)));
            }
            // Handle Regular Types
            else
            {
                returnValue = (T)Convert.ChangeType(obj, typeof(T));
            }
            return returnValue;
        }
    }
}
