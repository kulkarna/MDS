namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	/// <summary>
	/// Base class for utility markers that contain 
	/// the generic cell positions of property values.
	/// </summary>
	public class MarkerBase
	{
		/// <summary>
		/// Utility identifier
		/// </summary>
		public string UtilityCode
		{
			get;
			set;
		}
        public int RefJhCell
        {
            get;
            set;
        }
        public int UnitOfMeasurementNewCell
        {
            get;
            set;
        }
        
		/// <summary>
		/// Account number cell position
		/// </summary>
		public int AccountNumberCell
		{
			get;
			set;
		}


        /// <summary>
        /// transactionCreationDate cell position
		/// </summary>
        public int TransactionCreationDateCell
		{
			get;
			set;
		}
        
		/// <summary>
		/// Begin date cell position
		/// </summary>
		public int BeginDateCell
		{
			get;
			set;
		}
        /// <summary>
        /// Idr Meter Number cell position
        /// </summary>
        public int IdrMeterNumberCell
        {
            get;
            set;
        }
		public int EffectiveDateCell
		{
			get;
			set;
		}

		public int RateCodeCell
		{
			get;
			set;
		}

		public int NetMeterTypeCell
		{
			get;
			set;
		}

		/// <summary>
		/// Billing account number cell position
		/// </summary>
		public int BillingAccountNumberCell
		{
			get;
			set;
		}

		/// <summary>
		/// Customer name cell position
		/// </summary>
		public int CustomerNameCell
		{
			get;
			set;
		}

		/// <summary>
		/// DUNS number cell position
		/// </summary>
		public int DunsNumberCell
		{
			get;
			set;
		}

		/// <summary>
		/// End date cell position
		/// </summary>
		public int EndDateCell
		{
			get;
			set;
		}

		/// <summary>
		/// Icap cell position
		/// </summary>
		public int IcapCell
		{
			get;
			set;
		}

		/// <summary>
		///  Quantity cell position
		/// </summary>
		public int QuantityCell
		{
			get;
			set;
		}

		/// <summary>
		///  Alternate quantity cell position
		/// </summary>
		public int QuantityAltCell
		{
			get;
			set;
		}

		/// <summary>
		/// Measurement significance code cell position
		/// </summary>
		public int MeasurementSignificanceCodeCell
		{
			get;
			set;
		}
        /// <summary>
        /// IcapEffectiveDateCell identifier
        /// </summary>
        public int IcapEffectiveDateCell
        {
            get;
            set;
        }
        /// <summary>
        /// TcapEffectiveDateCell identifier
        /// </summary>
        public int TcapEffectiveDateCell
        {
            get;
            set;
        }

		/// <summary>
		/// Meter number cell position
		/// </summary>
		public int MeterNumberCell
		{
			get;
			set;
		}

        /// <summary>
        /// DaysInArrearCell  key cell position
        /// </summary>
        public int DaysInArrearsCell
        {
            get;
            set;
        }

		/// <summary>
		/// Meter Attributes Cell
		/// </summary>
		public int MeterAttributesCell { get; set; }

		/// <summary>
		/// Name key cell position
		/// </summary>
		public int NameKeyCell
		{
			get;
			set;
		}

        

		/// <summary>
		/// Previous account number cell position
		/// </summary>
		public int PreviousAccountNumberCell
		{
			get;
			set;
		}

		/// <summary>
		/// Rate class cell position
		/// </summary>
		public int RateClassCell
		{
			get;
			set;
		}

		/// <summary>
		/// Tcap cell position
		/// </summary>
		public int TcapCell
		{
			get;
			set;
		}

		/// <summary>
		/// Transaction set purpose code cell position
		/// </summary>
		public int TransactionSetPurposeCodeCell
		{
			get;
			set;
		}

		/// <summary>
		/// Unit of measurement cell position
		/// </summary>
		public int UnitOfMeasurementCell
		{
			get;
			set;
		}

		/// <summary>
		/// Alternate unit of measurement cell position
		/// </summary>
		public int UnitOfMeasurementAltCell
		{
			get;
			set;
		}

		/// <summary>
		/// Utility identifier cell position (for ORNJ)
		/// </summary>
		public Int16 UtilityIdentifierCell
		{
			get;
			set;
		}

		/// <summary>
		/// Zone cell position
		/// </summary>
		public int ZoneCell
		{
			get;
			set;
		}

		/// <summary>
		/// Load Profile position
		/// </summary>
		public int LoadProfileCell
		{
			get;
			set;
		}

		/// <summary>
		/// Bill Cycle, Trip Number, etc.. It's been called many things :)
		/// </summary>
		public int BillGroupCell
		{
			get;
			set;
		}

		/// <summary>
		/// BillingAddress cell position
		/// </summary>
		public int AddressCell
		{
			get;
			set;
		}

		/// <summary>
		/// CityCell cell position
		/// </summary>
		public int CityCell
		{
			get;
			set;
		}

		/// <summary>
		/// State cell position
		/// </summary>
		public int StateCell
		{
			get;
			set;
		}

		/// <summary>
		/// Zip code cell position
		/// </summary>
		public int ZipCell
		{
			get;
			set;
		}

		/// <summary>
		/// Usage type cell position
		/// </summary>
		public int UsageTypeCell
		{
			get;
			set;
		}

		/// <summary>
		/// Ptd loop cell position
		/// </summary>
		public int PtdLoopCell
		{
			get;
			set;
		}

		/// <summary>
		/// Usage multiplier cell position
		/// </summary>
		public int UsageMultiplierCell
		{
			get;
			set;
		}

		/// <summary>
		/// Account Status cell position
		/// </summary>
		public int AccountStatusCell
		{
			get;
			set;
		}

		/// <summary>
		/// Billing Type cell position
		/// </summary>
		public int BillingTypeCell
		{
			get;
			set;
		}

		/// <summary>
		/// Bill Calculation cell position
		/// </summary>
		public int BillCalculationCell
		{
			get;
			set;
		}

		/// <summary>
		/// Service Period Start cell position
		/// </summary>
		public int ServicePeriodStartCell
		{
			get;
			set;
		}

		/// <summary>
		/// Service Period End cell position
		/// </summary>
		public int ServicePeriodEndCell
		{
			get;
			set;
		}

		/// <summary>
		/// Anuual Usage cell position
		/// </summary>
		public int AnuualUsageCell
		{
			get;
			set;
		}

		/// <summary>
		/// Months to compute kwh cell position
		/// </summary>
		public int MonthsToComputeKwhCell
		{
			get;
			set;
		}

		/// <summary>
		/// Meter type cell position
		/// </summary>
		public int MeterTypeCell
		{
			get;
			set;
		}

		/// <summary>
		/// Meter multiplier cell position
		/// </summary>
		public int MeterMultiplierCell
		{
			get;
			set;
		}

		/// <summary>
		/// Transaction type cel position
		/// </summary>
		public int TransactionTypeCell
		{
			get;
			set;
		}

		/// <summary>
		/// Service type position
		/// </summary>
		public int ServiceTypeCell
		{
			get;
			set;
		}

		/// <summary>
		/// Product type position
		/// </summary>
		public int ProductTypeCell
		{
			get { return ServiceTypeCell + 2; }
		}

		/// <summary>
		/// Service type position
		/// </summary>
		public int ProductAltTypeCell
		{
			get { return ServiceTypeCell + 4; }
		}

		/// <summary>
		/// Bill To cell position
		/// </summary>
		public int BillToCell
		{
			get;
			set;
		}

		/// <summary>
		/// Esp account number cell position
		/// </summary>
		public int EspAccountCell
		{
			get;
			set;
		}

		/// <summary>
		/// Contact information cell position
		/// </summary>
		public int ContactInfoCell
		{
			get;
			set;
		}

		/// <summary>
		/// Voltage cell position
		/// </summary>
		public int VoltageCell
		{
			get;
			set;
		}

		/// <summary>
		/// Loss factor cell position
		/// </summary>
		public int LossFactorCell
		{
			get;
			set;
		}

		/// <summary>
		/// Idr date cell
		/// </summary>
		public int IdrDateCell
		{
			get;
			set;
		}

		/// <summary>
		/// Idr interval cell
		/// </summary>
		public int IdrIntervalCell
		{
			get;
			set;
		}

		/// <summary>
		/// Idr quantity cell
		/// </summary>
		public int IdrQuantityCell
		{
			get;
			set;
		}

		/// <summary>
		/// Idr unit of measurement cell
		/// </summary>
		public int IdrUnitOfMeasurementCell
		{
			get;
			set;
		}

		/// <summary>
		/// Service delivery point location
		/// </summary>
		public int ServiceDeliveryPointCell
		{
			get;
			set;
		}

		/// <summary>
		/// Date range of icap or tcap
		/// </summary>
		public int IcapTcapDateRangeCell
		{
			get;
			set;
		}
        public int UnmeteredMeter
        {
            get;
            set;
        }
	}
}
