namespace LibertyPower.Business.MarketManagement.EdiParser.FileParser
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Linq;
    using System.Text;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.Business.MarketManagement.EdiParser.FormatParser;
    using LibertyPower.Business.CommonBusiness.CommonEntity;

    using System.Globalization;

    /// <summary>
    /// Base class for utility mappers.
    /// </summary>
    public abstract class MapperBase
    {
        #region Fields

        /// <summary>
        /// Edi account object
        /// </summary>
        protected EdiAccount account = new EdiAccount();

        /// <summary>
        /// Edi account list
        /// </summary>
        protected EdiAccountList accountList = new EdiAccountList();

        /// <summary>
        /// Edi usage object
        /// </summary>
        protected EdiUsage usage = new EdiUsage();

        /// <summary>
        /// Final idr usage list
        /// </summary>
        protected EdiIdrUsageList idrList = new EdiIdrUsageList();

        /// <summary>
        /// Temp idr usage list (SD22759)
        /// </summary>
        protected EdiIdrUsageList idrTempList = new EdiIdrUsageList();

        //protected HybridDictionary usageListH = new HybridDictionary();
        //protected HybridDictionary idrListH = new HybridDictionary();

        /// <summary>
        /// Temp edi usage list
        /// </summary>
        protected EdiUsageList usageListTemp = new EdiUsageList(); // to hold usages for different UOMs

        /// <summary>
        /// Utility identifier
        /// </summary>
        protected string utilityCode = "";

        /// <summary>
        /// Market identifier
        /// </summary>
        protected string marketCode = "";

        /// <summary>
        /// Account identifier
        /// </summary>
        protected string accountNumber = "";

        /// <summary>
        /// Begin date
        /// </summary>
        protected string beginDate = "";

        /// <summary>
        /// Billing account number
        /// </summary>
        protected string billingAccountNumber = "";

        /// <summary>
        /// Customer name
        /// </summary>
        protected string customerName = "";

        /// <summary>
        /// DUNS number
        /// </summary>
        protected string dunsNumber = "";

        /// <summary>
        /// End date
        /// </summary>
        protected string endDate = "";

        /// <summary>
        /// Icap
        /// </summary>
        protected string icap = "";

        /// <summary>
        /// Quantity
        /// </summary>
        protected string quantity = "";

        /// <summary>
        /// Measurement significance code
        /// </summary>
        protected string measurementSignificanceCode = "";

        /// <summary>
        /// Meter number
        /// </summary>
        protected string meterNumber = "";

        /// <summary>
        /// Name key
        /// </summary>
        protected string nameKey = "";

        /// <summary>
        /// Previous account number
        /// </summary>
        protected string previousAccountNumber = "";

        /// <summary>
        /// Rate class
        /// </summary>
        protected string rateClass = "";

        ///<summary>
        /// string rateClassNh 
        /// </summary>
        protected string  rateClassNh = string.Empty;
        /// <summary>
        /// Tcap
        /// </summary>
        protected string tcap = "";

        /// <summary>
        /// Transaction set purpose code
        /// </summary>
        protected string transactionSetPurposeCode = "";


        /// <summary>
        /// Transaction set purpose code
        /// </summary>
        protected string transactionCreationDate = null;

       
        /// <summary>
        /// Unit of measurement
        /// </summary>
        protected string unitOfMeasurement = "";

        /// <summary>
        /// Zone code
        /// </summary>
        protected string zone = "";

        /// <summary>
        /// Load Profile
        /// </summary>
        protected string loadProfile = "";

        /// <summary>
        /// Load shape id
        /// </summary>
        protected string loadShapeId = "";

        /// <summary>
        /// Ptd loop
        /// </summary>
        protected string ptdLoop;

        /// <summary>
        /// Bill Group
        /// </summary>
        protected string billGroup = "";

        /// <summary>
        /// Usage type
        /// </summary>
        protected string usageType = "";

        /// <summary>
        /// Usage multiplier
        /// </summary>
        protected string usageMultiplier = "";

        /// <summary>
        /// BillingAddress
        /// </summary>
        protected GeographicalAddress serviceAddress;

        /// <summary>
        /// Account's status (flowing, error's, etc)
        /// </summary>
        protected string accountStatus;

        /// <summary>
        /// SC, RR/BR or DUAL
        /// </summary>
        protected string billingType;

        /// <summary>
        /// Who calculates bill charges?
        /// 
        /// </summary>
        protected string billCalculation;

        /// <summary>
        /// Date that the service with the service provider will start.
        /// </summary>
        protected string servicePeriodStart;

        /// <summary>
        /// Date that the service with the service provider will end.
        /// </summary>
        protected string servicePeriodEnd;

        /// <summary>
        /// Date that the service with the service provider will end.
        /// </summary>
        protected string effectiveDate;

        /// <summary>
        /// Anuual usage
        /// </summary>
        protected string annualUsage;

        /// <summary>
        /// Number of months over which Total kWh are calculated.
        /// </summary>
        protected string monthsToComputeKwh;

        /// <summary>
        /// Meter type used to identify the type of consumption measured by this meter and the interval between measurements
        /// </summary>
        protected string meterType;

        /// <summary>
        /// Meter constant or meter multiplier. Billed Usage = (Ending Meter Reading - Beginning Meter Reading) * Meter Multiplier
        /// </summary>
        protected string meterMultiplier;

        /// <summary>
        /// Transaction Type (request/response)
        /// </summary>
        protected string transactionType;

        /// <summary>
        /// Service type (EL, GAS, etc.)
        /// </summary>
        protected string serviceType;

        /// <summary>
        /// Product type (SW, RRC, MVO, etc)
        /// </summary>
        protected string productType;

        /// <summary>
        /// Additional product type (BB, MI, etc.)
        /// </summary>
        protected string productAltType;

        /// <summary>
        /// Bill To (contact) person
        /// </summary>
        protected string billTo;

        /// <summary>
        /// Billing Address
        /// </summary>
        protected GeographicalAddress billingAddress;

        /// <summary>
        /// Esp Account #
        /// </summary>
        protected string espAccount;

        /// <summary>
        /// Loss factor
        /// </summary>
        protected string lossFactor;

        /// <summary>
        /// Voltage
        /// </summary>
        protected string voltage;

        /// <summary>
        /// Idr date
        /// </summary>
        protected string idrDate;

        /// <summary>
        /// Idr interval
        /// </summary>
        protected string idrInterval;

        /// <summary>
        /// Service delivery point
        /// </summary>
        protected string serviceDeliveryPoint;

        /// <summary>
        /// Historical section.
        /// For further information <see cref="T:LibertyPower.Business.MarketManagement.EdiParser.FileParser.HistoricalSection"/>.
        /// </summary>
        protected HistoricalSection historicalSection;

        protected IcapList icapList;

        protected TcapList tcapList;


        #endregion

        #region Methods

        /// <summary>
        /// Overloaded method that creates an edi usage object.
        /// It is used to distinguish between HU and HI data.
        /// </summary>
        /// 
        /// <param name="quantity">Quantity</param>
        /// <param name="unitOfMeasurement">Unit of measurement</param>
        /// <param name="measurementSignificanceCode">Measurement significance code</param>
        /// <param name="transactionSetPurposeCode">Transaction set purpose code</param>
        /// <param name="meterNumber">Meter number</param>
        /// <param name="fromDate">Begin date</param>
        /// <param name="toDate">End date</param>
        /// <param name="ptdValue">Product transfer code</param>
        /// <param name="historicalSection">Historical section</param>
        /// 
        /// <returns>EdiUsage instance</returns>
        protected EdiUsage CreateEdiUsage(
            string quantity,
            string unitOfMeasurement,
            string measurementSignificanceCode,
            string transactionSetPurposeCode,
            string meterNumber,
            string fromDate,
            string toDate,
            string ptdValue,
            HistoricalSection historicalSection)
        {
            EdiUsage usage = new EdiUsage
            {
                Quantity = quantity == "" ? Convert.ToDecimal(-1) : Convert.ToDecimal(quantity),
                UnitOfMeasurement = unitOfMeasurement == null ? "" : unitOfMeasurement,
                MeasurementSignificanceCode = measurementSignificanceCode == null ? "" : measurementSignificanceCode,
                TransactionSetPurposeCode = transactionSetPurposeCode == null ? "" : transactionSetPurposeCode,
                MeterNumber = meterNumber == null ? "" : meterNumber,
                BeginDate = DateHelper.ConvertDateString(fromDate),
                EndDate = DateHelper.ConvertDateString(toDate),
                PtdLoop = ptdValue == null ? "" : ptdValue,
                ServiceDeliveryPoint = "",
                HistoricalSection = historicalSection.ToString()
            };

            return usage;
        }

        // July 2010
        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Overloaded method that creates an edi usage object
        /// </summary>
        /// <param name="quantity"></param>
        /// <param name="unitOfMeasurement"></param>
        /// <param name="measurementSignificanceCode"></param>
        /// <param name="transactionSetPurposeCode"></param>
        /// <param name="meterNumber"></param>
        /// <param name="fromDate"></param>
        /// <param name="toDate"></param>
        /// <param name="ptdValue"></param>
        /// <returns>EdiUsage instance</returns>
        protected EdiUsage CreateEdiUsage(string quantity, string unitOfMeasurement, string measurementSignificanceCode,
            string transactionSetPurposeCode, string meterNumber, string fromDate, string toDate, string ptdValue)
        {
            EdiUsage usage = new EdiUsage();
            usage.Quantity = quantity == "" ? Convert.ToDecimal(-1) : Convert.ToDecimal(quantity);
            usage.UnitOfMeasurement = unitOfMeasurement == null ? "" : unitOfMeasurement;
            usage.MeasurementSignificanceCode = measurementSignificanceCode == null ? "" : measurementSignificanceCode;
            usage.TransactionSetPurposeCode = transactionSetPurposeCode == null ? "" : transactionSetPurposeCode;
            usage.MeterNumber = meterNumber == null ? "" : meterNumber;
            usage.BeginDate = DateHelper.ConvertDateString(fromDate);
            usage.EndDate = DateHelper.ConvertDateString(toDate);
            usage.PtdLoop = ptdValue == null ? "" : ptdValue;
            usage.ServiceDeliveryPoint = "";

            return usage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Provides the Functionality for Nullable DateTryParse
        /// </summary>
        /// <param name="text"></param>
        /// <returns>DateTime?</returns>



        public static DateTime? DateTryParse(string text)
        {
            DateTime date;
            return DateTime.TryParseExact(text, "yyyyMMdd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date) ? date : (DateTime?)null;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Overloaded method that creates an edi usage object
        /// </summary>
        /// <param name="quantity"></param>
        /// <param name="unitOfMeasurement"></param>
        /// <param name="measurementSignificanceCode"></param>
        /// <param name="transactionSetPurposeCode"></param>
        /// <param name="meterNumber"></param>
        /// <param name="fromDate"></param>
        /// <param name="toDate"></param>
        /// <param name="ptdValue"></param>
        /// <param name="serviceDeliveryPoint"></param>
        /// <returns>EdiUsage instance</returns>
        protected EdiUsage CreateEdiUsage(string quantity, string unitOfMeasurement, string measurementSignificanceCode,
            string transactionSetPurposeCode, string meterNumber, string fromDate, string toDate, string ptdValue, string serviceDeliveryPoint)
        {
            EdiUsage usage = new EdiUsage();
            usage.Quantity = quantity == "" ? Convert.ToDecimal(-1) : Convert.ToDecimal(quantity);
            usage.UnitOfMeasurement = unitOfMeasurement == null ? "" : unitOfMeasurement;
            usage.MeasurementSignificanceCode = measurementSignificanceCode == null ? "" : measurementSignificanceCode;
            usage.TransactionSetPurposeCode = transactionSetPurposeCode == null ? "" : transactionSetPurposeCode;
            usage.MeterNumber = meterNumber == null ? "" : meterNumber;
            usage.BeginDate = DateHelper.ConvertDateString(fromDate);
            usage.EndDate = DateHelper.ConvertDateString(toDate);
            usage.PtdLoop = ptdValue;
            usage.ServiceDeliveryPoint = serviceDeliveryPoint;

            return usage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Overloaded method that creates an edi usage object
        /// </summary>
        /// <param name="quantity"></param>
        /// <param name="unitOfMeasurement"></param>
        /// <param name="measurementSignificanceCode"></param>
        /// <param name="transactionSetPurposeCode"></param>
        /// <param name="meterNumber"></param>
        /// <param name="ptdValue"></param>
        /// <returns>EdiUsage instance</returns>
        protected EdiUsage CreateEdiUsage(string quantity, string unitOfMeasurement, string measurementSignificanceCode,
            string transactionSetPurposeCode, string meterNumber, string ptdValue)
        {
            // initialize with empty strings to avoid null value issues			
            EdiUsage usage = new EdiUsage();
            usage.Quantity = quantity == "" ? Convert.ToDecimal(-1) : Convert.ToDecimal(quantity);
            usage.UnitOfMeasurement = unitOfMeasurement == null ? "" : unitOfMeasurement;
            usage.MeasurementSignificanceCode = measurementSignificanceCode == null ? "" : measurementSignificanceCode;
            usage.TransactionSetPurposeCode = transactionSetPurposeCode == null ? "" : transactionSetPurposeCode;
            usage.MeterNumber = meterNumber == null ? "" : meterNumber;
            usage.PtdLoop = ptdValue;
            usage.ServiceDeliveryPoint = "";
            return usage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Creates an edi usage object
        /// </summary>
        /// <param name="quantity">Quantity</param>
        /// <param name="unitOfMeasurement">Unit of measurement</param>
        /// <param name="measurementSignificanceCode">Measurement significance code</param>
        /// <param name="transactionSetPurposeCode">Transaction set purpose code</param>
        /// <param name="meterNumber">Meter number</param>
        /// <returns>Returns an edi usage object.</returns>
        protected EdiUsage CreateEdiUsage(string quantity, string unitOfMeasurement, string measurementSignificanceCode,
            string transactionSetPurposeCode, string meterNumber)
        {
            // initialize with empty strings to avoid null value issues
            EdiUsage usage = new EdiUsage();
            usage.Quantity = quantity == "" ? Convert.ToDecimal(-1) : Convert.ToDecimal(quantity);
            usage.UnitOfMeasurement = unitOfMeasurement == null ? "" : unitOfMeasurement;
            usage.MeasurementSignificanceCode = measurementSignificanceCode == null ? "" : measurementSignificanceCode;
            usage.TransactionSetPurposeCode = transactionSetPurposeCode == null ? "" : transactionSetPurposeCode;
            usage.MeterNumber = meterNumber == null ? "" : meterNumber;
            usage.ServiceDeliveryPoint = "";
            usage.PtdLoop = "";

            return usage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Overloaded method that creates an idr usage object
        /// </summary>
        /// <param name="quantity"></param>
        /// <param name="unitOfMeasurement"></param>
        /// <param name="transactionSetPurposeCode"></param>
        /// <param name="ptdValue"></param>
        /// <returns></returns>
        protected EdiIdrUsage createIdrUsage(string quantity, string unitOfMeasurement, string transactionSetPurposeCode, string ptdValue)
        {
            EdiIdrUsage idrUsage = new EdiIdrUsage();
            idrUsage.Quantity = Convert.ToDecimal(quantity);
            idrUsage.UnitOfMeasurement = unitOfMeasurement == null ? "" : unitOfMeasurement;
            idrUsage.TransactionSetPurposeCode = transactionSetPurposeCode == null ? "" : transactionSetPurposeCode;
            idrUsage.PtdLoop = ptdValue;

            return idrUsage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Creates an idr usage object
        /// </summary>
        /// <param name="quantity"></param>
        /// <param name="unitOfMeasurement"></param>
        /// <param name="transactionSetPurposeCode"></param>
        /// <param name="interval"></param>
        /// <param name="Date"></param>
        /// <param name="ptdValue"></param>
        /// <returns>EdiUsage instance</returns>
        protected EdiIdrUsage createIdrUsage(string meterNumber, string quantity, string unitOfMeasurement, string transactionSetPurposeCode,
            string interval, string Date, string ptdValue)
        {
            EdiIdrUsage idrUsage = new EdiIdrUsage();
            idrUsage.MeterNumber = meterNumber;
            idrUsage.Date = DateHelper.ConvertDateString(Date);
            idrUsage.Interval = Convert.ToInt16(interval.Substring(0, 4));  //only get hour and minute
            idrUsage.Quantity = string.IsNullOrEmpty(quantity)?0: Convert.ToDecimal(quantity);
            idrUsage.UnitOfMeasurement = unitOfMeasurement == null ? "" : unitOfMeasurement;
            idrUsage.TransactionSetPurposeCode = transactionSetPurposeCode == null ? "" : transactionSetPurposeCode;
            idrUsage.PtdLoop = ptdValue;
            return idrUsage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Resets usage related variables.
        /// </summary>
        protected void ClearUsageVariables()
        {
            quantity = "";
            beginDate = "";
            endDate = "";
            unitOfMeasurement = "";
            measurementSignificanceCode = "";
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Resets idr related variables.
        /// </summary>
        protected void ClearIdrVariables()
        {
            idrDate = "";
            idrInterval = "";
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Adds the idr usages in temp idr edi usage list to the final idr usage list.
        /// </summary>
        /// <param name="idrTempList"></param>
        /// <param name="account"></param>
        /// <param name="date"></param>
        /// <param name="interval"></param>
        protected void AddIdrUsagesToList(EdiIdrUsageList idrTempList, EdiAccount account, string date, string interval)
        {
            foreach (EdiIdrUsage idr in idrTempList)
            {
                idr.Date = DateHelper.ConvertDateString(date);
                idr.Interval = Convert.ToInt16(interval.Substring(0, 4));  //only get hour and minute
                account.IdrUsageList[interval + "-" + date + "-" + idr.UnitOfMeasurement] = idr;
            }

            idrTempList.Clear();
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Adds the usages in temp edi usage list to the final edi usage list.
        /// </summary>
        /// <param name="usageListTemp">Temp edi usage list</param>
        /// <param name="usageList">Final edi usage list</param>
        /// <param name="beginDate">Usage begin date</param>
        /// <param name="endDate">Usage end date</param>
        protected void AddUsagesToList(EdiUsageList usageListTemp, EdiUsageList usageList,
            string beginDate, string endDate)
        {
            foreach (EdiUsage usageTemp in usageListTemp)
            {
                usageTemp.BeginDate = DateHelper.ConvertDateString(beginDate);
                usageTemp.EndDate = DateHelper.ConvertDateString(endDate);
                usageList.Add(usageTemp);
            }
            usageListTemp.Clear();
            ClearUsageVariables();												// Ticket 17219
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Overloaded method that adds the usages in temp edi usage list to the final edi usage list.
        /// </summary>
        /// <param name="usageListTemp">Temp edi usage list</param>
        /// <param name="usageList">Final edi usage list</param>
        /// <param name="beginDate">Usage begin date</param>
        /// <param name="endDate">Usage end date</param>
        /// <param name="ptdLoop">Ptd loop value</param>
        protected void AddUsagesToList(EdiUsageList usageListTemp, EdiUsageList usageList,
            string beginDate, string endDate, string ptdLoop)
        {
            foreach (EdiUsage usageTemp in usageListTemp)
            {
                usageTemp.PtdLoop = ptdLoop;
                usageTemp.BeginDate = DateHelper.ConvertDateString(beginDate);
                usageTemp.EndDate = DateHelper.ConvertDateString(endDate);
                usageList.Add(usageTemp);
            }
            usageListTemp.Clear();
            ClearUsageVariables();
        }
        //New method added to check whether USageList already contain an 'SU' loop
        protected int CheckSULoopAlreadyExist(EdiUsageList usageList)
        {
            foreach (EdiUsage usage in usageList)
            {
                string currentPTDLoop = usage.PtdLoop;
                if (currentPTDLoop == "SU")
                    return 1;
                break;
            }
            return 0;
        }
        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Resets variables in preparation for next iteration of generic collection.
        /// </summary>
        /// <param name="accountNumber">Account identifier</param>
        /// <param name="billingAccountNumber">Billing account number</param>
        /// <param name="customerName">Customer name</param>
        /// <param name="icap">Icap</param>
        /// <param name="nameKey">Name key</param>
        /// <param name="previousAccountNumber">Previous account number</param>
        /// <param name="rateClass">Rate class</param>
        /// <param name="tcap">Tcap</param>
        /// <param name="zone">Zone code</param>
        /// <param name="usageType">Usage type</param>
        protected void ResetAccountVariables(ref string accountNumber, ref string billingAccountNumber,
            ref string customerName, ref string icap, ref string nameKey, ref string previousAccountNumber,
            ref string rateClass, ref string tcap, ref string zone, ref string usageType)
        {
            accountNumber = "";
            billingAccountNumber = "";
            customerName = "";
            icap = "";
            nameKey = "";
            previousAccountNumber = "";
            rateClass = "";
            tcap = "";
            transactionSetPurposeCode = "";
            zone = "";
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Resets variables in preparation for next iteration of generic collection.
        /// </summary>
        protected void ResetAccountVariables()
        {
            accountNumber = "";
            billingAccountNumber = "";
            customerName = "";
            icap = "";
            nameKey = "";
            previousAccountNumber = "";
            rateClass = "";
            tcap = "";
            transactionSetPurposeCode = "";
            zone = "";
            accountStatus = "";
            annualUsage = "";
            billCalculation = "";
            billingType = "";
            meterMultiplier = "";
            meterType = "";
            monthsToComputeKwh = "";
            productAltType = "";
            productType = "";
            servicePeriodEnd = "";
            servicePeriodStart = "";
            serviceType = "";
            serviceDeliveryPoint = "";
            transactionType = "";
            billTo = "";
            espAccount = "";
            loadProfile = "";
            billGroup = "";
            idrInterval = "";
            //unitOfMeasurement = "";
            //meterNumber = "";
            //measurementSignificanceCode = "";
            //quantity = "";
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Determines whether to add a usage object to list
        /// </summary>
        /// <param name="quantity">Quantity</param>
        /// <param name="unitOfMeasurement">Unit of measurement</param>
        /// <param name="measurementSignificanceCode">Measurement significance code</param>
        /// <param name="transactionSetPurposeCode">Transaction set purpose code</param>
        /// <returns>Returns a boolean indicating whether to add a usage object to list</returns>
        protected bool DoAddToList(string quantity, string unitOfMeasurement,
            string measurementSignificanceCode, string transactionSetPurposeCode)
        {
            return (transactionSetPurposeCode.Equals("52") && (quantity.Length > 0 || unitOfMeasurement.Length > 0 || measurementSignificanceCode.Length > 0));
        }

        /// <summary>
        /// Calculates usage for certain types of file rows
        /// </summary>
        /// <param name="usageMultiplier"></param>
        /// <param name="usage1"></param>
        /// <param name="usage2"></param>
        /// <returns></returns>
        protected string CalculateUsage(string usageMultiplier, string usage1, string usage2)
        {
            string quantity = "";

            try
            {
                decimal multiplier = Convert.ToDecimal(usageMultiplier);
                decimal usg1 = Convert.ToDecimal(usage1);
                decimal usg2 = Convert.ToDecimal(usage2);

                quantity = Convert.ToString(((usg2 - usg1) * multiplier));
            }
            catch
            {
                // catch exception, method will return empty string
            }

            return quantity;
        }

        /// <summary>
        /// Map data to be overriden. Map data should define the rules for mapping the data for each file row
        /// </summary>
        /// <param name="fileRow">file row to be mapped to the EditAccount object</param>
        /// <param name="rowDelimiter">row delimiter</param>
        /// <param name="fieldDelimiter">field delimiter</param>
        /// <returns>EdiAccount intance</returns>
        public abstract EdiAccount MapData(FileRow fileRow, char rowDelimiter, char fieldDelimiter);

        protected string FormatDateString(string date)
        {
            if (date.Length >= 8)
                return String.Format("{0}/{1}/{2}", date.Substring(4, 2), date.Substring(6, 2), date.Substring(0, 4));
            else
                return date;
        }
        /// <summary>
        ///   Added Details to the HU Sections
        /// </summary>
        /// <param name="pepcodcMarker">Marker Variables for These</param>
        /// <param name="cells">Cells Details Here</param>
        protected void ProcessPhiHu(dynamic Marker, string[] cells)
        {
            string cellContents;

            if (ptdLoop != null & ptdLoop != "SU" & ptdLoop != "BQ" & ptdLoop != "BB")				// skip 1st record + no double dipping (since summary has only one ptd marker)..
                AddUsagesToList(usageListTemp, account.EdiUsageList, beginDate, endDate, ptdLoop);

            ClearUsageVariables();
            meterNumber = "";

            cellContents = cells[Marker.PtdLoopCell].Trim();
            ptdLoop = cellContents == null ? "" : cellContents;

            if (ptdLoop == "SU")
                measurementSignificanceCode = "51";

        }

        /// <summary>
        ///  ProcessPhiHi194 
        /// </summary>
        /// <param name="pepcodcMarker">Marker Variables for These</param>
        /// <param name="cells">Cells Details Here</param>
        protected void ProcessPhiHi194(dynamic Marker, string[] cells)
        {
            string cellContents;
            cellContents = cells[Marker.IdrDateCell].Trim();
            idrDate = cellContents == null ? "" : cellContents;

            cellContents = cells[Marker.IdrIntervalCell].Trim();
            idrInterval = cellContents == null ? "" : cellContents;

            account.IdrUsageList[idrInterval + idrDate + unitOfMeasurement+meterNumber] = createIdrUsage(meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop);

        }

        /// <summary>
        ///  ProcessPhiHi194 
        /// </summary>
        /// <param name="pepcodcMarker">Marker Variables for These</param>
        /// <param name="cells">Cells Details Here</param>
        protected void ProcessPhiHi582(dynamic Marker, string[] cells)
        {
            string cellContents;
            cellContents = cells[Marker.IdrDateCell].Trim();
            idrDate = cellContents == null ? "" : cellContents;

            cellContents = cells[Marker.IdrIntervalCell].Trim();
            idrInterval = cellContents == null ? "" : cellContents;

            account.IdrUsageList[idrInterval + idrDate + unitOfMeasurement+meterNumber] = createIdrUsage(meterNumber, quantity, unitOfMeasurement, transactionSetPurposeCode, idrInterval, idrDate, ptdLoop);

        }

        #endregion

    }
}