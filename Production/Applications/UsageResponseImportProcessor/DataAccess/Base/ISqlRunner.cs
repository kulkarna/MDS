using System;
using System.Collections.Generic;
using System.Dynamic;

namespace UsageResponseImportProcessor.DataAccess.Base
{
    public interface ISqlRunner
    {
        IEnumerable<dynamic> ExecuteProcedure(string procedureName, dynamic @params);
    }
}
