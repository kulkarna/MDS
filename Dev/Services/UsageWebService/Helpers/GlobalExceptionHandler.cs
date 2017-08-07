using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Dispatcher;
using System.Web;
using Common.Logging;

namespace UsageWebService.Helpers
{
    public class GlobalExceptionHandler : IErrorHandler
    {
        private static readonly ILog Log = LogManager.GetLogger("GlobalExceptionHandler");

        #region IErrorHandler Members

        public bool HandleError(Exception ex)
        {
            return true;
        }

        public void ProvideFault(Exception ex, MessageVersion version,
                                 ref Message msg)
        {
            var baseEx = ex.GetBaseException(); 
            Log.Error(baseEx.ToString(), ex);

            var newEx = new FaultException(
                string.Format("Usage service exception: {0}",
                              baseEx.Message));

            MessageFault msgFault = newEx.CreateMessageFault();
            msg = Message.CreateMessage(version, msgFault, newEx.Action);
        }

        #endregion
    }
}