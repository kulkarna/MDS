﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.4952
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System.Xml.Serialization;

// 
// This source code was auto-generated by xsd, Version=2.0.50727.3038.
// 


/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.3038")]
[System.SerializableAttribute()]
[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.ComponentModel.DesignerCategoryAttribute("code")]
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, Namespace="http://www.ercot.com/schema/2007-06/nodal/ews")]
[System.Xml.Serialization.XmlRootAttribute(Namespace="http://www.ercot.com/schema/2007-06/nodal/ews", IsNullable=false)]
public partial class Reports {
    
    private Report[] reportField;
    
    /// <remarks/>
    [System.Xml.Serialization.XmlElementAttribute("Report")]
    public Report[] Report {
        get {
            return this.reportField;
        }
        set {
            this.reportField = value;
        }
    }
}

/// <remarks/>
[System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "2.0.50727.3038")]
[System.SerializableAttribute()]
[System.Diagnostics.DebuggerStepThroughAttribute()]
[System.ComponentModel.DesignerCategoryAttribute("code")]
[System.Xml.Serialization.XmlTypeAttribute(Namespace="http://www.ercot.com/schema/2007-06/nodal/ews")]
public partial class Report {
    
    private System.DateTime operatingDateField;
    
    private string reportGroupField;
    
    private string fileNameField;
    
    private System.DateTime createdField;
    
    private string sizeField;
    
    private string formatField;
    
    private string uRLField;
    
    /// <remarks/>
    [System.Xml.Serialization.XmlElementAttribute(DataType="date")]
    public System.DateTime operatingDate {
        get {
            return this.operatingDateField;
        }
        set {
            this.operatingDateField = value;
        }
    }
    
    /// <remarks/>
    public string reportGroup {
        get {
            return this.reportGroupField;
        }
        set {
            this.reportGroupField = value;
        }
    }
    
    /// <remarks/>
    public string fileName {
        get {
            return this.fileNameField;
        }
        set {
            this.fileNameField = value;
        }
    }
    
    /// <remarks/>
    public System.DateTime created {
        get {
            return this.createdField;
        }
        set {
            this.createdField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlElementAttribute(DataType="integer")]
    public string size {
        get {
            return this.sizeField;
        }
        set {
            this.sizeField = value;
        }
    }
    
    /// <remarks/>
    public string format {
        get {
            return this.formatField;
        }
        set {
            this.formatField = value;
        }
    }
    
    /// <remarks/>
    [System.Xml.Serialization.XmlElementAttribute(DataType="anyURI")]
    public string URL {
        get {
            return this.uRLField;
        }
        set {
            this.uRLField = value;
        }
    }
}
