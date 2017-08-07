using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UtilityManagementService
{
    public interface IResult
    {
        string Message { get; set; }
        bool IsSuccess { get; set; }
        string Code { get; set; }
    }
}
