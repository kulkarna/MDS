﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.4062
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// 
// This source code was auto-generated by Microsoft.VSDesigner, Version 2.0.50727.4062.
// 
#pragma warning disable 1591

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaInvoiceService {
    using System.Diagnostics;
    using System.Web.Services;
    using System.ComponentModel;
    using System.Web.Services.Protocols;
    using System;
    using System.Xml.Serialization;
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "2.0.50727.3053")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Web.Services.WebServiceBindingAttribute(Name="InvoiceServiceSoap", Namespace="https://ws.libertypowerbilling.com/InvoiceService")]
    public partial class InvoiceService : Microsoft.Web.Services2.WebServicesClientProtocol
    {
        
        private System.Threading.SendOrPostCallback CreateETFSpecialChargeOperationCompleted;
        
        private bool useDefaultCredentialsSetExplicitly;
        
        /// <remarks/>
        public InvoiceService() {
            this.Url = global::LibertyPower.DataAccess.WebServiceAccess.IstaWebService.Properties.Settings.Default.IstaWebService_IstaInvoiceService_InvoiceService;
            if ((this.IsLocalFileSystemWebService(this.Url) == true)) {
                this.UseDefaultCredentials = true;
                this.useDefaultCredentialsSetExplicitly = false;
            }
            else {
                this.useDefaultCredentialsSetExplicitly = true;
            }
        }
        
        public new string Url {
            get {
                return base.Url;
            }
            set {
                if ((((this.IsLocalFileSystemWebService(base.Url) == true) 
                            && (this.useDefaultCredentialsSetExplicitly == false)) 
                            && (this.IsLocalFileSystemWebService(value) == false))) {
                    base.UseDefaultCredentials = false;
                }
                base.Url = value;
            }
        }
        
        public new bool UseDefaultCredentials {
            get {
                return base.UseDefaultCredentials;
            }
            set {
                base.UseDefaultCredentials = value;
                this.useDefaultCredentialsSetExplicitly = true;
            }
        }
        
        /// <remarks/>
        public event CreateETFSpecialChargeCompletedEventHandler CreateETFSpecialChargeCompleted;
        
        /// <remarks/>
        [System.Web.Services.Protocols.SoapDocumentMethodAttribute("https://ws.libertypowerbilling.com/InvoiceService/CreateETFSpecialCharge", RequestNamespace="https://ws.libertypowerbilling.com/InvoiceService", ResponseNamespace="https://ws.libertypowerbilling.com/InvoiceService", Use=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)]
        public void CreateETFSpecialCharge(ref ETFSpecialCharge[] ETFSpecialChargeList) {
            object[] results = this.Invoke("CreateETFSpecialCharge", new object[] {
                        ETFSpecialChargeList});
            ETFSpecialChargeList = ((ETFSpecialCharge[])(results[0]));
        }
        
        /// <remarks/>
        public void CreateETFSpecialChargeAsync(ETFSpecialCharge[] ETFSpecialChargeList) {
            this.CreateETFSpecialChargeAsync(ETFSpecialChargeList, null);
        }
        
        /// <remarks/>
        public void CreateETFSpecialChargeAsync(ETFSpecialCharge[] ETFSpecialChargeList, object userState) {
            if ((this.CreateETFSpecialChargeOperationCompleted == null)) {
                this.CreateETFSpecialChargeOperationCompleted = new System.Threading.SendOrPostCallback(this.OnCreateETFSpecialChargeOperationCompleted);
            }
            this.InvokeAsync("CreateETFSpecialCharge", new object[] {
                        ETFSpecialChargeList}, this.CreateETFSpecialChargeOperationCompleted, userState);
        }
        
        private void OnCreateETFSpecialChargeOperationCompleted(object arg) {
            if ((this.CreateETFSpecialChargeCompleted != null)) {
                System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs)(arg));
                this.CreateETFSpecialChargeCompleted(this, new CreateETFSpecialChargeCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState));
            }
        }
        
        /// <remarks/>
        public new void CancelAsync(object userState) {
            base.CancelAsync(userState);
        }
        
        private bool IsLocalFileSystemWebService(string url) {
            if (((url == null) 
                        || (url == string.Empty))) {
                return false;
            }
            System.Uri wsUri = new System.Uri(url);
            if (((wsUri.Port >= 1024) 
                        && (string.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) == 0))) {
                return true;
            }
            return false;
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3074")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="https://ws.libertypowerbilling.com/InvoiceService")]
    public partial class ETFSpecialCharge {
        
        private int customerIDField;
        
        private string eSIIDField;
        
        private decimal amountField;
        
        private bool doNotPrintField;
        
        private System.Nullable<int> invoiceIDField;
        
        /// <remarks/>
        public int CustomerID {
            get {
                return this.customerIDField;
            }
            set {
                this.customerIDField = value;
            }
        }
        
        /// <remarks/>
        public string ESIID {
            get {
                return this.eSIIDField;
            }
            set {
                this.eSIIDField = value;
            }
        }
        
        /// <remarks/>
        public decimal Amount {
            get {
                return this.amountField;
            }
            set {
                this.amountField = value;
            }
        }
        
        /// <remarks/>
        public bool DoNotPrint {
            get {
                return this.doNotPrintField;
            }
            set {
                this.doNotPrintField = value;
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(IsNullable=true)]
        public System.Nullable<int> InvoiceID {
            get {
                return this.invoiceIDField;
            }
            set {
                this.invoiceIDField = value;
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "2.0.50727.3053")]
    public delegate void CreateETFSpecialChargeCompletedEventHandler(object sender, CreateETFSpecialChargeCompletedEventArgs e);
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "2.0.50727.3053")]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class CreateETFSpecialChargeCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs {
        
        private object[] results;
        
        internal CreateETFSpecialChargeCompletedEventArgs(object[] results, System.Exception exception, bool cancelled, object userState) : 
                base(exception, cancelled, userState) {
            this.results = results;
        }
        
        /// <remarks/>
        public ETFSpecialCharge[] ETFSpecialChargeList {
            get {
                this.RaiseExceptionIfNecessary();
                return ((ETFSpecialCharge[])(this.results[0]));
            }
        }
    }
}

#pragma warning restore 1591