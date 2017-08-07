﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.261
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// 
// This source code was auto-generated by Microsoft.VSDesigner, Version 4.0.30319.261.
// 
#pragma warning disable 1591

namespace LibertyPower.DataAccess.WebServiceAccess.IstaWebService.IstaRateService
{
	using System;
	using System.Web.Services;
	using System.Diagnostics;
	using System.Web.Services.Protocols;
	using System.ComponentModel;
	using System.Xml.Serialization;


	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	[System.Web.Services.WebServiceBindingAttribute( Name = "RateServiceSoap", Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public partial class RateService : Microsoft.Web.Services2.WebServicesClientProtocol
	{

		private System.Threading.SendOrPostCallback GetRateTemplateInfoListOperationCompleted;

		private System.Threading.SendOrPostCallback GetRateTemplateInfoListByPlanTypeOperationCompleted;

		private System.Threading.SendOrPostCallback UpdateCustomerRateOperationCompleted;

		private System.Threading.SendOrPostCallback UpdateCustomerRateWith814OptionOperationCompleted;

		private System.Threading.SendOrPostCallback SearchRateRolloverListOperationCompleted;

		private System.Threading.SendOrPostCallback InactivateRateRolloverOperationCompleted;

		private System.Threading.SendOrPostCallback ActivateRateRolloverOperationCompleted;

		private bool useDefaultCredentialsSetExplicitly;

		/// <remarks/>
		public RateService()
		{
			this.Url = global::LibertyPower.DataAccess.WebServiceAccess.IstaWebService.Properties.Settings.Default.IstaWebService_com_libertypowerbilling_ws_uat_RateService;
			if( (this.IsLocalFileSystemWebService( this.Url ) == true) )
			{
				this.UseDefaultCredentials = true;
				this.useDefaultCredentialsSetExplicitly = false;
			}
			else
			{
				this.useDefaultCredentialsSetExplicitly = true;
			}
		}

		public new string Url
		{
			get
			{
				return base.Url;
			}
			set
			{
				if( (((this.IsLocalFileSystemWebService( base.Url ) == true)
							&& (this.useDefaultCredentialsSetExplicitly == false))
							&& (this.IsLocalFileSystemWebService( value ) == false)) )
				{
					base.UseDefaultCredentials = false;
				}
				base.Url = value;
			}
		}

		public new bool UseDefaultCredentials
		{
			get
			{
				return base.UseDefaultCredentials;
			}
			set
			{
				base.UseDefaultCredentials = value;
				this.useDefaultCredentialsSetExplicitly = true;
			}
		}

		/// <remarks/>
		public event GetRateTemplateInfoListCompletedEventHandler GetRateTemplateInfoListCompleted;

		/// <remarks/>
		public event GetRateTemplateInfoListByPlanTypeCompletedEventHandler GetRateTemplateInfoListByPlanTypeCompleted;

		/// <remarks/>
		public event UpdateCustomerRateCompletedEventHandler UpdateCustomerRateCompleted;

		/// <remarks/>
		public event UpdateCustomerRateWith814OptionCompletedEventHandler UpdateCustomerRateWith814OptionCompleted;

		/// <remarks/>
		public event SearchRateRolloverListCompletedEventHandler SearchRateRolloverListCompleted;

		/// <remarks/>
		public event InactivateRateRolloverCompletedEventHandler InactivateRateRolloverCompleted;

		/// <remarks/>
		public event ActivateRateRolloverCompletedEventHandler ActivateRateRolloverCompleted;

		/// <remarks/>
		[System.Web.Services.Protocols.SoapDocumentMethodAttribute( "https://ws.libertypowerbilling.com/RateService/GetRateTemplateInfoList", RequestNamespace = "https://ws.libertypowerbilling.com/RateService", ResponseNamespace = "https://ws.libertypowerbilling.com/RateService", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Wrapped )]
		public RateTemplateInfo[] GetRateTemplateInfoList()
		{
			object[] results = this.Invoke( "GetRateTemplateInfoList", new object[0] );
			return ((RateTemplateInfo[]) (results[0]));
		}

		/// <remarks/>
		public void GetRateTemplateInfoListAsync()
		{
			this.GetRateTemplateInfoListAsync( null );
		}

		/// <remarks/>
		public void GetRateTemplateInfoListAsync( object userState )
		{
			if( (this.GetRateTemplateInfoListOperationCompleted == null) )
			{
				this.GetRateTemplateInfoListOperationCompleted = new System.Threading.SendOrPostCallback( this.OnGetRateTemplateInfoListOperationCompleted );
			}
			this.InvokeAsync( "GetRateTemplateInfoList", new object[0], this.GetRateTemplateInfoListOperationCompleted, userState );
		}

		private void OnGetRateTemplateInfoListOperationCompleted( object arg )
		{
			if( (this.GetRateTemplateInfoListCompleted != null) )
			{
				System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs) (arg));
				this.GetRateTemplateInfoListCompleted( this, new GetRateTemplateInfoListCompletedEventArgs( invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState ) );
			}
		}

		/// <remarks/>
		[System.Web.Services.Protocols.SoapDocumentMethodAttribute( "https://ws.libertypowerbilling.com/RateService/GetRateTemplateInfoListByPlanType", RequestNamespace = "https://ws.libertypowerbilling.com/RateService", ResponseNamespace = "https://ws.libertypowerbilling.com/RateService", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Wrapped )]
		public RateTemplateInfo[] GetRateTemplateInfoListByPlanType( PlanTypeOptions planType )
		{
			object[] results = this.Invoke( "GetRateTemplateInfoListByPlanType", new object[] {
                        planType} );
			return ((RateTemplateInfo[]) (results[0]));
		}

		/// <remarks/>
		public void GetRateTemplateInfoListByPlanTypeAsync( PlanTypeOptions planType )
		{
			this.GetRateTemplateInfoListByPlanTypeAsync( planType, null );
		}

		/// <remarks/>
		public void GetRateTemplateInfoListByPlanTypeAsync( PlanTypeOptions planType, object userState )
		{
			if( (this.GetRateTemplateInfoListByPlanTypeOperationCompleted == null) )
			{
				this.GetRateTemplateInfoListByPlanTypeOperationCompleted = new System.Threading.SendOrPostCallback( this.OnGetRateTemplateInfoListByPlanTypeOperationCompleted );
			}
			this.InvokeAsync( "GetRateTemplateInfoListByPlanType", new object[] {
                        planType}, this.GetRateTemplateInfoListByPlanTypeOperationCompleted, userState );
		}

		private void OnGetRateTemplateInfoListByPlanTypeOperationCompleted( object arg )
		{
			if( (this.GetRateTemplateInfoListByPlanTypeCompleted != null) )
			{
				System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs) (arg));
				this.GetRateTemplateInfoListByPlanTypeCompleted( this, new GetRateTemplateInfoListByPlanTypeCompletedEventArgs( invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState ) );
			}
		}

		/// <remarks/>
		[System.Web.Services.Protocols.SoapDocumentMethodAttribute( "https://ws.libertypowerbilling.com/RateService/UpdateCustomerRate", RequestNamespace = "https://ws.libertypowerbilling.com/RateService", ResponseNamespace = "https://ws.libertypowerbilling.com/RateService", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Wrapped )]
		public bool UpdateCustomerRate( [System.Xml.Serialization.XmlElementAttribute( IsNullable = true )] RateRollover RateRollover )
		{
			object[] results = this.Invoke( "UpdateCustomerRate", new object[] {
                        RateRollover} );
			return ((bool) (results[0]));
		}

		/// <remarks/>
		public void UpdateCustomerRateAsync( RateRollover RateRollover )
		{
			this.UpdateCustomerRateAsync( RateRollover, null );
		}

		/// <remarks/>
		public void UpdateCustomerRateAsync( RateRollover RateRollover, object userState )
		{
			if( (this.UpdateCustomerRateOperationCompleted == null) )
			{
				this.UpdateCustomerRateOperationCompleted = new System.Threading.SendOrPostCallback( this.OnUpdateCustomerRateOperationCompleted );
			}
			this.InvokeAsync( "UpdateCustomerRate", new object[] {
                        RateRollover}, this.UpdateCustomerRateOperationCompleted, userState );
		}

		private void OnUpdateCustomerRateOperationCompleted( object arg )
		{
			if( (this.UpdateCustomerRateCompleted != null) )
			{
				System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs) (arg));
				this.UpdateCustomerRateCompleted( this, new UpdateCustomerRateCompletedEventArgs( invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState ) );
			}
		}

		/// <remarks/>
		[System.Web.Services.Protocols.SoapDocumentMethodAttribute( "https://ws.libertypowerbilling.com/RateService/UpdateCustomerRateWith814Option", RequestNamespace = "https://ws.libertypowerbilling.com/RateService", ResponseNamespace = "https://ws.libertypowerbilling.com/RateService", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Wrapped )]
		public bool UpdateCustomerRateWith814Option( [System.Xml.Serialization.XmlElementAttribute( IsNullable = true )] RateRollover RateRollover, bool send814Flag )
		{
			object[] results = this.Invoke( "UpdateCustomerRateWith814Option", new object[] {
                        RateRollover,
                        send814Flag} );
			return ((bool) (results[0]));
		}

		/// <remarks/>
		public void UpdateCustomerRateWith814OptionAsync( RateRollover RateRollover, bool send814Flag )
		{
			this.UpdateCustomerRateWith814OptionAsync( RateRollover, send814Flag, null );
		}

		/// <remarks/>
		public void UpdateCustomerRateWith814OptionAsync( RateRollover RateRollover, bool send814Flag, object userState )
		{
			if( (this.UpdateCustomerRateWith814OptionOperationCompleted == null) )
			{
				this.UpdateCustomerRateWith814OptionOperationCompleted = new System.Threading.SendOrPostCallback( this.OnUpdateCustomerRateWith814OptionOperationCompleted );
			}
			this.InvokeAsync( "UpdateCustomerRateWith814Option", new object[] {
                        RateRollover,
                        send814Flag}, this.UpdateCustomerRateWith814OptionOperationCompleted, userState );
		}

		private void OnUpdateCustomerRateWith814OptionOperationCompleted( object arg )
		{
			if( (this.UpdateCustomerRateWith814OptionCompleted != null) )
			{
				System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs) (arg));
				this.UpdateCustomerRateWith814OptionCompleted( this, new UpdateCustomerRateWith814OptionCompletedEventArgs( invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState ) );
			}
		}

		/// <remarks/>
		[System.Web.Services.Protocols.SoapDocumentMethodAttribute( "https://ws.libertypowerbilling.com/RateService/SearchRateRolloverList", RequestNamespace = "https://ws.libertypowerbilling.com/RateService", ResponseNamespace = "https://ws.libertypowerbilling.com/RateService", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Wrapped )]
		public RateRolloverInfo[] SearchRateRolloverList( [System.Xml.Serialization.XmlElementAttribute( IsNullable = true )] RateRolloverListSearch RateRolloverListSearch )
		{
			object[] results = this.Invoke( "SearchRateRolloverList", new object[] {
                        RateRolloverListSearch} );
			return ((RateRolloverInfo[]) (results[0]));
		}

		/// <remarks/>
		public void SearchRateRolloverListAsync( RateRolloverListSearch RateRolloverListSearch )
		{
			this.SearchRateRolloverListAsync( RateRolloverListSearch, null );
		}

		/// <remarks/>
		public void SearchRateRolloverListAsync( RateRolloverListSearch RateRolloverListSearch, object userState )
		{
			if( (this.SearchRateRolloverListOperationCompleted == null) )
			{
				this.SearchRateRolloverListOperationCompleted = new System.Threading.SendOrPostCallback( this.OnSearchRateRolloverListOperationCompleted );
			}
			this.InvokeAsync( "SearchRateRolloverList", new object[] {
                        RateRolloverListSearch}, this.SearchRateRolloverListOperationCompleted, userState );
		}

		private void OnSearchRateRolloverListOperationCompleted( object arg )
		{
			if( (this.SearchRateRolloverListCompleted != null) )
			{
				System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs) (arg));
				this.SearchRateRolloverListCompleted( this, new SearchRateRolloverListCompletedEventArgs( invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState ) );
			}
		}

		/// <remarks/>
		[System.Web.Services.Protocols.SoapDocumentMethodAttribute( "https://ws.libertypowerbilling.com/RateService/InactivateRateRollover", RequestNamespace = "https://ws.libertypowerbilling.com/RateService", ResponseNamespace = "https://ws.libertypowerbilling.com/RateService", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Wrapped )]
		public bool InactivateRateRollover( int rateRolloverId )
		{
			object[] results = this.Invoke( "InactivateRateRollover", new object[] {
                        rateRolloverId} );
			return ((bool) (results[0]));
		}

		/// <remarks/>
		public void InactivateRateRolloverAsync( int rateRolloverId )
		{
			this.InactivateRateRolloverAsync( rateRolloverId, null );
		}

		/// <remarks/>
		public void InactivateRateRolloverAsync( int rateRolloverId, object userState )
		{
			if( (this.InactivateRateRolloverOperationCompleted == null) )
			{
				this.InactivateRateRolloverOperationCompleted = new System.Threading.SendOrPostCallback( this.OnInactivateRateRolloverOperationCompleted );
			}
			this.InvokeAsync( "InactivateRateRollover", new object[] {
                        rateRolloverId}, this.InactivateRateRolloverOperationCompleted, userState );
		}

		private void OnInactivateRateRolloverOperationCompleted( object arg )
		{
			if( (this.InactivateRateRolloverCompleted != null) )
			{
				System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs) (arg));
				this.InactivateRateRolloverCompleted( this, new InactivateRateRolloverCompletedEventArgs( invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState ) );
			}
		}

		/// <remarks/>
		[System.Web.Services.Protocols.SoapDocumentMethodAttribute( "https://ws.libertypowerbilling.com/RateService/ActivateRateRollover", RequestNamespace = "https://ws.libertypowerbilling.com/RateService", ResponseNamespace = "https://ws.libertypowerbilling.com/RateService", Use = System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle = System.Web.Services.Protocols.SoapParameterStyle.Wrapped )]
		public bool ActivateRateRollover( int rateRolloverId )
		{
			object[] results = this.Invoke( "ActivateRateRollover", new object[] {
                        rateRolloverId} );
			return ((bool) (results[0]));
		}

		/// <remarks/>
		public void ActivateRateRolloverAsync( int rateRolloverId )
		{
			this.ActivateRateRolloverAsync( rateRolloverId, null );
		}

		/// <remarks/>
		public void ActivateRateRolloverAsync( int rateRolloverId, object userState )
		{
			if( (this.ActivateRateRolloverOperationCompleted == null) )
			{
				this.ActivateRateRolloverOperationCompleted = new System.Threading.SendOrPostCallback( this.OnActivateRateRolloverOperationCompleted );
			}
			this.InvokeAsync( "ActivateRateRollover", new object[] {
                        rateRolloverId}, this.ActivateRateRolloverOperationCompleted, userState );
		}

		private void OnActivateRateRolloverOperationCompleted( object arg )
		{
			if( (this.ActivateRateRolloverCompleted != null) )
			{
				System.Web.Services.Protocols.InvokeCompletedEventArgs invokeArgs = ((System.Web.Services.Protocols.InvokeCompletedEventArgs) (arg));
				this.ActivateRateRolloverCompleted( this, new ActivateRateRolloverCompletedEventArgs( invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState ) );
			}
		}

		/// <remarks/>
		public new void CancelAsync( object userState )
		{
			base.CancelAsync( userState );
		}

		private bool IsLocalFileSystemWebService( string url )
		{
			if( ((url == null)
						|| (url == string.Empty)) )
			{
				return false;
			}
			System.Uri wsUri = new System.Uri( url );
			if( ((wsUri.Port >= 1024)
						&& (string.Compare( wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase ) == 0)) )
			{
				return true;
			}
			return false;
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public partial class RateTemplateInfo
	{

		private int rateTemplateIDField;

		private PlanTypeOptions planTypeField;

		private RateTypeOptions rateTypeField;

		private RateDescriptionOptions rateDescriptionField;

		private bool isRequiredField;

		/// <remarks/>
		public int RateTemplateID
		{
			get
			{
				return this.rateTemplateIDField;
			}
			set
			{
				this.rateTemplateIDField = value;
			}
		}

		/// <remarks/>
		public PlanTypeOptions PlanType
		{
			get
			{
				return this.planTypeField;
			}
			set
			{
				this.planTypeField = value;
			}
		}

		/// <remarks/>
		public RateTypeOptions RateType
		{
			get
			{
				return this.rateTypeField;
			}
			set
			{
				this.rateTypeField = value;
			}
		}

		/// <remarks/>
		public RateDescriptionOptions RateDescription
		{
			get
			{
				return this.rateDescriptionField;
			}
			set
			{
				this.rateDescriptionField = value;
			}
		}

		/// <remarks/>
		public bool IsRequired
		{
			get
			{
				return this.isRequiredField;
			}
			set
			{
				this.isRequiredField = value;
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public enum PlanTypeOptions
	{

		/// <remarks/>
		Fixed,

		/// <remarks/>
		PortfolioVariable,

		/// <remarks/>
		CustomVariable,

		/// <remarks/>
		HeatRate,

		/// <remarks/>
		MCPE,

		/// <remarks/>
		CustomBilling,

		/// <remarks/>
		Ruc,

		/// <remarks/>
		CustomIndex,
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public enum RateTypeOptions
	{

		/// <remarks/>
		Not_Defined,

		/// <remarks/>
		Energy_Charge_Percent_Of_Consumption,

		/// <remarks/>
		Flat_Charge_Per_Esi_Id,

		/// <remarks/>
		Flat_Charge_Per_Meter,

		/// <remarks/>
		MCPE_Interval_Consumption_Rate,

		/// <remarks/>
		Heat_Rate_Standard,

		/// <remarks/>
		Index_Price_Calculation,
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public enum RateDescriptionOptions
	{

		/// <remarks/>
		NonTiered,

		/// <remarks/>
		MeterCharge,

		/// <remarks/>
		MeteredEnergyCharges,

		/// <remarks/>
		MeteredIntervalCharge,

		/// <remarks/>
		LossFactorPassThru,

		/// <remarks/>
		FixedAdder,
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public partial class RateRolloverExceptionInfo
	{

		private int rateRolloverIDField;

		private string messageField;

		private System.DateTime createDateField;

		/// <remarks/>
		public int RateRolloverID
		{
			get
			{
				return this.rateRolloverIDField;
			}
			set
			{
				this.rateRolloverIDField = value;
			}
		}

		/// <remarks/>
		public string Message
		{
			get
			{
				return this.messageField;
			}
			set
			{
				this.messageField = value;
			}
		}

		/// <remarks/>
		public System.DateTime CreateDate
		{
			get
			{
				return this.createDateField;
			}
			set
			{
				this.createDateField = value;
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public partial class RateRolloverDetailInfo
	{

		private int rateRolloverDetailIDField;

		private int rateTemplateIDField;

		private System.DateTime rateEffectiveDateField;

		private System.DateTime rateExpirationDateField;

		private decimal rateAmountField;

		private System.Nullable<int> usageClassIDField;

		private System.Nullable<int> rateVariableTypeIDField;

		/// <remarks/>
		public int RateRolloverDetailID
		{
			get
			{
				return this.rateRolloverDetailIDField;
			}
			set
			{
				this.rateRolloverDetailIDField = value;
			}
		}

		/// <remarks/>
		public int RateTemplateID
		{
			get
			{
				return this.rateTemplateIDField;
			}
			set
			{
				this.rateTemplateIDField = value;
			}
		}

		/// <remarks/>
		public System.DateTime RateEffectiveDate
		{
			get
			{
				return this.rateEffectiveDateField;
			}
			set
			{
				this.rateEffectiveDateField = value;
			}
		}

		/// <remarks/>
		public System.DateTime RateExpirationDate
		{
			get
			{
				return this.rateExpirationDateField;
			}
			set
			{
				this.rateExpirationDateField = value;
			}
		}

		/// <remarks/>
		public decimal RateAmount
		{
			get
			{
				return this.rateAmountField;
			}
			set
			{
				this.rateAmountField = value;
			}
		}

		/// <remarks/>
		[System.Xml.Serialization.XmlElementAttribute( IsNullable = true )]
		public System.Nullable<int> UsageClassID
		{
			get
			{
				return this.usageClassIDField;
			}
			set
			{
				this.usageClassIDField = value;
			}
		}

		/// <remarks/>
		[System.Xml.Serialization.XmlElementAttribute( IsNullable = true )]
		public System.Nullable<int> RateVariableTypeID
		{
			get
			{
				return this.rateVariableTypeIDField;
			}
			set
			{
				this.rateVariableTypeIDField = value;
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public partial class RateRolloverInfo
	{

		private int rateRolloverIDField;

		private int customerIDField;

		private string eSIIDField;

		private PlanTypeOptions planTypeField;

		private string lDCRateCodeField;

		private System.DateTime switchDateField;

		private bool isEnrollmentField;

		private bool isActiveField;

		private System.DateTime createDateField;

		private RateRolloverDetailInfo[] rateRolloverDetailInfoListField;

		private RateRolloverExceptionInfo[] rateRolloverExceptionInfoListField;

		/// <remarks/>
		public int RateRolloverID
		{
			get
			{
				return this.rateRolloverIDField;
			}
			set
			{
				this.rateRolloverIDField = value;
			}
		}

		/// <remarks/>
		public int CustomerID
		{
			get
			{
				return this.customerIDField;
			}
			set
			{
				this.customerIDField = value;
			}
		}

		/// <remarks/>
		public string ESIID
		{
			get
			{
				return this.eSIIDField;
			}
			set
			{
				this.eSIIDField = value;
			}
		}

		/// <remarks/>
		public PlanTypeOptions PlanType
		{
			get
			{
				return this.planTypeField;
			}
			set
			{
				this.planTypeField = value;
			}
		}

		/// <remarks/>
		public string LDCRateCode
		{
			get
			{
				return this.lDCRateCodeField;
			}
			set
			{
				this.lDCRateCodeField = value;
			}
		}

		/// <remarks/>
		public System.DateTime SwitchDate
		{
			get
			{
				return this.switchDateField;
			}
			set
			{
				this.switchDateField = value;
			}
		}

		/// <remarks/>
		public bool IsEnrollment
		{
			get
			{
				return this.isEnrollmentField;
			}
			set
			{
				this.isEnrollmentField = value;
			}
		}

		/// <remarks/>
		public bool IsActive
		{
			get
			{
				return this.isActiveField;
			}
			set
			{
				this.isActiveField = value;
			}
		}

		/// <remarks/>
		public System.DateTime CreateDate
		{
			get
			{
				return this.createDateField;
			}
			set
			{
				this.createDateField = value;
			}
		}

		/// <remarks/>
		public RateRolloverDetailInfo[] RateRolloverDetailInfoList
		{
			get
			{
				return this.rateRolloverDetailInfoListField;
			}
			set
			{
				this.rateRolloverDetailInfoListField = value;
			}
		}

		/// <remarks/>
		public RateRolloverExceptionInfo[] RateRolloverExceptionInfoList
		{
			get
			{
				return this.rateRolloverExceptionInfoListField;
			}
			set
			{
				this.rateRolloverExceptionInfoListField = value;
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public partial class RateRolloverListSearch
	{

		private RateRolloverStatusOptions statusField;

		private System.DateTime startDateField;

		private System.DateTime endDateField;

		private bool isActiveField;

		/// <remarks/>
		public RateRolloverStatusOptions Status
		{
			get
			{
				return this.statusField;
			}
			set
			{
				this.statusField = value;
			}
		}

		/// <remarks/>
		public System.DateTime StartDate
		{
			get
			{
				return this.startDateField;
			}
			set
			{
				this.startDateField = value;
			}
		}

		/// <remarks/>
		public System.DateTime EndDate
		{
			get
			{
				return this.endDateField;
			}
			set
			{
				this.endDateField = value;
			}
		}

		/// <remarks/>
		public bool IsActive
		{
			get
			{
				return this.isActiveField;
			}
			set
			{
				this.isActiveField = value;
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public enum RateRolloverStatusOptions
	{

		/// <remarks/>
		New,

		/// <remarks/>
		PendingMarketApproval,

		/// <remarks/>
		Failed,

		/// <remarks/>
		MarketRejected,

		/// <remarks/>
		MarketApproved,

		/// <remarks/>
		Complete,
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public partial class RateRolloverDetail
	{

		private int rateTemplateIDField;

		private System.DateTime rateEffectiveDateField;

		private System.DateTime rateExpirationDateField;

		private decimal rateAmountField;

		private System.Nullable<int> usageClassIDField;

		private System.Nullable<int> rateVariableTypeIDField;

		/// <remarks/>
		public int RateTemplateID
		{
			get
			{
				return this.rateTemplateIDField;
			}
			set
			{
				this.rateTemplateIDField = value;
			}
		}

		/// <remarks/>
		public System.DateTime RateEffectiveDate
		{
			get
			{
				return this.rateEffectiveDateField;
			}
			set
			{
				this.rateEffectiveDateField = value;
			}
		}

		/// <remarks/>
		public System.DateTime RateExpirationDate
		{
			get
			{
				return this.rateExpirationDateField;
			}
			set
			{
				this.rateExpirationDateField = value;
			}
		}

		/// <remarks/>
		public decimal RateAmount
		{
			get
			{
				return this.rateAmountField;
			}
			set
			{
				this.rateAmountField = value;
			}
		}

		/// <remarks/>
		[System.Xml.Serialization.XmlElementAttribute( IsNullable = true )]
		public System.Nullable<int> UsageClassID
		{
			get
			{
				return this.usageClassIDField;
			}
			set
			{
				this.usageClassIDField = value;
			}
		}

		/// <remarks/>
		[System.Xml.Serialization.XmlElementAttribute( IsNullable = true )]
		public System.Nullable<int> RateVariableTypeID
		{
			get
			{
				return this.rateVariableTypeIDField;
			}
			set
			{
				this.rateVariableTypeIDField = value;
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Xml", "4.0.30319.233" )]
	[System.SerializableAttribute()]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	[System.Xml.Serialization.XmlTypeAttribute( Namespace = "https://ws.libertypowerbilling.com/RateService" )]
	public partial class RateRollover
	{

		private int customerIDField;

		private string eSIIDField;

		private PlanTypeOptions planTypeField;

		private string lDCRateCodeField;

		private System.DateTime switchDateField;

		private RateRolloverDetail[] rateRolloverDetailListField;

		private System.DateTime contractStartDateField;

		private System.DateTime contractStopDateField;

		/// <remarks/>
		public int CustomerID
		{
			get
			{
				return this.customerIDField;
			}
			set
			{
				this.customerIDField = value;
			}
		}

		/// <remarks/>
		public string ESIID
		{
			get
			{
				return this.eSIIDField;
			}
			set
			{
				this.eSIIDField = value;
			}
		}

		/// <remarks/>
		public PlanTypeOptions PlanType
		{
			get
			{
				return this.planTypeField;
			}
			set
			{
				this.planTypeField = value;
			}
		}

		/// <remarks/>
		public string LDCRateCode
		{
			get
			{
				return this.lDCRateCodeField;
			}
			set
			{
				this.lDCRateCodeField = value;
			}
		}

		/// <remarks/>
		public System.DateTime SwitchDate
		{
			get
			{
				return this.switchDateField;
			}
			set
			{
				this.switchDateField = value;
			}
		}

		/// <remarks/>
		public RateRolloverDetail[] RateRolloverDetailList
		{
			get
			{
				return this.rateRolloverDetailListField;
			}
			set
			{
				this.rateRolloverDetailListField = value;
			}
		}

		/// <remarks/>
		public System.DateTime ContractStartDate
		{
			get
			{
				return this.contractStartDateField;
			}
			set
			{
				this.contractStartDateField = value;
			}
		}

		/// <remarks/>
		public System.DateTime ContractStopDate
		{
			get
			{
				return this.contractStopDateField;
			}
			set
			{
				this.contractStopDateField = value;
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	public delegate void GetRateTemplateInfoListCompletedEventHandler( object sender, GetRateTemplateInfoListCompletedEventArgs e );

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	public partial class GetRateTemplateInfoListCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
	{

		private object[] results;

		internal GetRateTemplateInfoListCompletedEventArgs( object[] results, System.Exception exception, bool cancelled, object userState ) :
			base( exception, cancelled, userState )
		{
			this.results = results;
		}

		/// <remarks/>
		public RateTemplateInfo[] Result
		{
			get
			{
				this.RaiseExceptionIfNecessary();
				return ((RateTemplateInfo[]) (this.results[0]));
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	public delegate void GetRateTemplateInfoListByPlanTypeCompletedEventHandler( object sender, GetRateTemplateInfoListByPlanTypeCompletedEventArgs e );

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	public partial class GetRateTemplateInfoListByPlanTypeCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
	{

		private object[] results;

		internal GetRateTemplateInfoListByPlanTypeCompletedEventArgs( object[] results, System.Exception exception, bool cancelled, object userState ) :
			base( exception, cancelled, userState )
		{
			this.results = results;
		}

		/// <remarks/>
		public RateTemplateInfo[] Result
		{
			get
			{
				this.RaiseExceptionIfNecessary();
				return ((RateTemplateInfo[]) (this.results[0]));
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	public delegate void UpdateCustomerRateCompletedEventHandler( object sender, UpdateCustomerRateCompletedEventArgs e );

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	public partial class UpdateCustomerRateCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
	{

		private object[] results;

		internal UpdateCustomerRateCompletedEventArgs( object[] results, System.Exception exception, bool cancelled, object userState ) :
			base( exception, cancelled, userState )
		{
			this.results = results;
		}

		/// <remarks/>
		public bool Result
		{
			get
			{
				this.RaiseExceptionIfNecessary();
				return ((bool) (this.results[0]));
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	public delegate void UpdateCustomerRateWith814OptionCompletedEventHandler( object sender, UpdateCustomerRateWith814OptionCompletedEventArgs e );

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	public partial class UpdateCustomerRateWith814OptionCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
	{

		private object[] results;

		internal UpdateCustomerRateWith814OptionCompletedEventArgs( object[] results, System.Exception exception, bool cancelled, object userState ) :
			base( exception, cancelled, userState )
		{
			this.results = results;
		}

		/// <remarks/>
		public bool Result
		{
			get
			{
				this.RaiseExceptionIfNecessary();
				return ((bool) (this.results[0]));
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	public delegate void SearchRateRolloverListCompletedEventHandler( object sender, SearchRateRolloverListCompletedEventArgs e );

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	public partial class SearchRateRolloverListCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
	{

		private object[] results;

		internal SearchRateRolloverListCompletedEventArgs( object[] results, System.Exception exception, bool cancelled, object userState ) :
			base( exception, cancelled, userState )
		{
			this.results = results;
		}

		/// <remarks/>
		public RateRolloverInfo[] Result
		{
			get
			{
				this.RaiseExceptionIfNecessary();
				return ((RateRolloverInfo[]) (this.results[0]));
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	public delegate void InactivateRateRolloverCompletedEventHandler( object sender, InactivateRateRolloverCompletedEventArgs e );

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	public partial class InactivateRateRolloverCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
	{

		private object[] results;

		internal InactivateRateRolloverCompletedEventArgs( object[] results, System.Exception exception, bool cancelled, object userState ) :
			base( exception, cancelled, userState )
		{
			this.results = results;
		}

		/// <remarks/>
		public bool Result
		{
			get
			{
				this.RaiseExceptionIfNecessary();
				return ((bool) (this.results[0]));
			}
		}
	}

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	public delegate void ActivateRateRolloverCompletedEventHandler( object sender, ActivateRateRolloverCompletedEventArgs e );

	/// <remarks/>
	[System.CodeDom.Compiler.GeneratedCodeAttribute( "System.Web.Services", "4.0.30319.1" )]
	[System.Diagnostics.DebuggerStepThroughAttribute()]
	[System.ComponentModel.DesignerCategoryAttribute( "code" )]
	public partial class ActivateRateRolloverCompletedEventArgs : System.ComponentModel.AsyncCompletedEventArgs
	{

		private object[] results;

		internal ActivateRateRolloverCompletedEventArgs( object[] results, System.Exception exception, bool cancelled, object userState ) :
			base( exception, cancelled, userState )
		{
			this.results = results;
		}

		/// <remarks/>
		public bool Result
		{
			get
			{
				this.RaiseExceptionIfNecessary();
				return ((bool) (this.results[0]));
			}
		}
	}
}

#pragma warning restore 1591