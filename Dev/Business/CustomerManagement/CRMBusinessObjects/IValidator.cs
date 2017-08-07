using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public interface IValidator
    {

        /// <summary>
        /// Checks that any dependend mappings are set before creating the object in permanent storage
        /// </summary>
        /// <returns></returns>
        bool IsStructureValidForInsert();

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        bool IsStructureValidForUpdate();

        /// <summary>
        /// Check the object for any business requirements at the base class level and any other requirement that is whithin the reach of the class
        /// </summary>
        /// <returns></returns>
        List<GenericError> IsValidForInsert();

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        List<GenericError> IsValidForUpdate();

        /// <summary>
        /// Checks for common/ shared business rules, makes sure that the object data is a valid
        /// </summary>
        /// <returns></returns>
        List<GenericError> IsValid();


    }
}
