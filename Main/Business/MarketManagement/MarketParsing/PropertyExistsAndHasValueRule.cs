namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Data;
    using System.IO;
    using System.Reflection;
    using System.Runtime.InteropServices;

    using LibertyPower.Business.CommonBusiness.CommonExcel;
    using LibertyPower.Business.CommonBusiness.CommonRules;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.DataAccess.ExcelAccess;



    /// <summary>
    /// Given an object, this rule determines if that object has a property with the provided name;
    /// and further, if that property has a non-null value.  In the case of string types, an empty 
    /// string is considered a null value.
    /// </summary>
    /// 
    [Guid("52EE089B-5FFE-41b6-8816-1EB565A8FEF2")]
    public class PropertyExistsAndHasValueRule : BusinessRule
    {
        
        string propertyName;
        object o;
        Type objectType;

        public PropertyExistsAndHasValueRule(object o, string propertyName)
            : base("PropertyExistsAndHasValueRule", BrokenRuleSeverity.Warning)
        {
            this.o = o;
            this.objectType = o.GetType();
            this.propertyName = propertyName;

        }

        public override bool Validate()
        {
            try
            {
                object buf = objectType.InvokeMember(propertyName, BindingFlags.GetProperty, null, o, null);

                if (buf != null)
                {
                    if(buf.ToString().Length == 0)
                    {
                        //Property exists but value is empty
                        SetException("Value not set for [" + propertyName + "]");
                    }
                    else
                        return true;
                }
                else
                {
                    //property exists but value is null
                    SetException("Value not set for [" + propertyName + "]");
                }
            }
            catch(Exception) 
            {
                //property does not exist in object
                SetException("Property [" + propertyName + "] does not exist");
            }
            return false;
        }
    }
}