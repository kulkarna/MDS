namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Represents a mapping between edi files and EdiAccount class
	/// </summary>
	public class EdiAccountMap814 : ClassMap
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="marker">Marker containing the position of each data in the field</param>
		public EdiAccountMap814( MarkerBase marker )
			: base( marker )
		{
			AddFieldMap( "BGN", new StringParser( account => account.TransactionType, Marker.TransactionTypeCell ) );
            AddFieldMap("BGN", new NullableDateParser(account => account.TransactionCreatedDate, Marker.TransactionCreationDateCell));
			AddFieldMap( "N18R", new StringParser( account => account.CustomerName, Marker.CustomerNameCell ) );
			AddFieldMap( "N18S", new DunsNumberParser( account => account.DunsNumber, Marker.DunsNumberCell ) );
			AddFieldMap( "N1BT", new StringParser( account => account.BillTo, Marker.BillToCell ) );
			AddFieldMap( "N3", new AddressParser( account => account.BillingAddress.Street, Marker.AddressCell ) );
			AddFieldMap( "N4", new AddressParser( account => account.BillingAddress.CityName, Marker.CityCell ) );
			AddFieldMap( "N4", new AddressParser( account => account.BillingAddress.State, Marker.StateCell ) );
			AddFieldMap( "N4", new AddressParser( account => account.BillingAddress.PostalCode, Marker.ZipCell ) );
			AddFieldMap( "N3", new AddressParser( account => account.ServiceAddress.Street, Marker.AddressCell ) );
			AddFieldMap( "N4", new AddressParser( account => account.ServiceAddress.CityName, Marker.CityCell ) );
			AddFieldMap( "N4", new AddressParser( account => account.ServiceAddress.State, Marker.StateCell ) );
			AddFieldMap( "N4", new AddressParser( account => account.ServiceAddress.PostalCode, Marker.ZipCell ) );
			AddFieldMap( "PER", new ContactParser( account => account.Contact, Marker.ContactInfoCell ) );
			AddFieldMap( "LIN", new ServiceParser( account => account.ServiceType, Marker.ServiceTypeCell ) );
			AddFieldMap( "LIN", new ServiceParser( account => account.ProductType, Marker.ProductTypeCell ) );
			AddFieldMap( "LIN", new ServiceParser( account => account.ProductAltType, Marker.ProductAltTypeCell ) );
			AddFieldMap( "REF11", new StringParser( account => account.EspAccount, Marker.EspAccountCell ) );
			AddFieldMap( "REF12", new StringParser( account => account.AccountNumber, Marker.AccountNumberCell ) );
			AddFieldMap( "REF1P", new StringParser( account => account.AccountStatus, Marker.AccountStatusCell ) );
			AddFieldMap( "REF7G", new StringParser( account => account.AccountStatus, Marker.AccountStatusCell ) );
			AddFieldMap( "REF45", new StringParser( account => account.PreviousAccountNumber, Marker.PreviousAccountNumberCell ) );
			AddFieldMap( "REFMG", new StringParser( account => account.MeterNumber, Marker.MeterNumberCell ) );
			AddFieldMap( "REFMT", new StringParser( account => account.MeterType, Marker.MeterTypeCell ) );
			AddFieldMap( "REF4P", new MeterMultiplierParser( account => account.MeterMultiplier, Marker.MeterMultiplierCell ) );
			AddFieldMap( "REFNH", new StringParser( account => account.RateClass, Marker.RateClassCell ) );
            AddFieldMap("REFNH", new StringParser(account => account.RateClassNH, Marker.RateClassCell));
            AddFieldMap("REFPRT", new StringParser(account => account.RateClass, Marker.RateClassCell));
			AddFieldMap( "REFSPL", new StringParser( account => account.ZoneCode, Marker.ZoneCell ) );
			AddFieldMap( "REFBLT", new StringParser( account => account.BillingType, Marker.BillingTypeCell ) );
			AddFieldMap( "REFPC", new StringParser( account => account.BillCalculation, Marker.BillCalculationCell ) );
			AddFieldMap( "REFBF", new DynamicParser( account => account.BillGroup, Marker.BillGroupCell ) );
			AddFieldMap( "REFSV", new StringParser( account => account.Voltage, Marker.VoltageCell ) );
            AddFieldMap("REFTZ", new DynamicParser(account => account.BillGroup, Marker.BillGroupCell));
			AddFieldMap( "REFLO", new StringParser( account => account.LoadProfile, Marker.LoadProfileCell ) );
			AddFieldMap( "REFLU", new StringParser( account => account.ServiceDeliveryPoint, Marker.ServiceDeliveryPointCell ) );
			AddFieldMap( "AMTKC", new DecimalParser( account => account.Icap, Marker.IcapCell ) );
			AddFieldMap( "AMTKZ", new DecimalParser( account => account.Tcap, Marker.TcapCell ) );
			AddFieldMap( "AMTTA", new IntParser( account => account.AnnualUsage, Marker.AnuualUsageCell ) );
			AddFieldMap( "AMTLD", new ShortParser( account => account.MonthsToComputeKwh, Marker.MonthsToComputeKwhCell ) );
			AddFieldMap( "DTM150", new DateParser( account => account.ServicePeriodStart, Marker.ServicePeriodStartCell ) );
			AddFieldMap( "DTM151", new DateParser( account => account.ServicePeriodEnd, Marker.ServicePeriodEndCell ) );
			AddFieldMap( "DTM007", new DateParser( account => account.EffectiveDate, Marker.EffectiveDateCell ) );
			AddFieldMap( "REFKY", new StringParser( account => account.NetMeterType, Marker.NetMeterTypeCell ) );
            AddFieldMap("AMTPJ", new StringParser(account => account.DaysInArrear, Marker.DaysInArrearsCell));
            
//			AddFieldMap( "REFTD", new StringParser( account => account.WhatChanged, Marker.WhatChangedCell ) );			<- nobody asked for this - 09/16/2013
//			AddFieldMap( "REFPR", new StringParser( account => account., Marker.RateCodeCell ) );
//			AddFieldMap( "NM1MQ", new StringParser( account => account.MeterAttributes, Marker.MeterAttributesCell ) );
		}
	}
}
