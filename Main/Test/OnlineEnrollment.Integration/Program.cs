using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OnlineEnrollment.Integration
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Document Test Application Starting...");
            OnlineEnrollmentDocumentRetrievalTest test
                = new OnlineEnrollmentDocumentRetrievalTest();
            test.ContractAPI_Returns_ContractDocument();
            Console.ReadLine();

        }
    }
}
