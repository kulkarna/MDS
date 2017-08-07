using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using UtilityLogging;
using Utilities;

namespace SmucRunDto
{
    public class ResultData
    {
        #region private variables
        private const string NAMESPACE = "SmucRunDto";
        private const string CLASS = "ResultData";
        ILogger _logger = null;
        #endregion

        #region public constructors
        public ResultData(string messageId, ILogger logger)
        {
            DateTime beginDate = DateTime.Now;
            _logger = logger;
            string method = "ResultData(messageId,logger)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                UtilityCode = string.Empty;
                AccountNumber = string.Empty;

                ICap = string.Empty;
                ICapCreatedOn = DateTime.MinValue;
                NoICap = true;

                LoadProfile = string.Empty;
                LoadProfileCreatedOn = DateTime.MinValue;
                NoLoadProfile = true;

                RateClass = string.Empty;
                RateClassCreatedOn = DateTime.MinValue;
                NoRateClass = true;

                TCap = string.Empty;
                TCapCreatedOn = DateTime.MinValue;
                NoTCap = true;

                Zone = string.Empty;
                ZoneCreatedOn = DateTime.MinValue;
                NoZone = true;

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }
        #endregion



        #region public properties
        public string UtilityCode { get; set; }
        public string AccountNumber { get; set; }

        public string ICap { get; set; }
        public DateTime ICapCreatedOn { get; set; }
        public bool NoICap { get; set; }

        public string LoadProfile { get; set; }
        public DateTime LoadProfileCreatedOn { get; set; }
        public bool NoLoadProfile { get; set; }

        public string RateClass { get; set; }
        public DateTime RateClassCreatedOn { get; set; }
        public bool NoRateClass { get; set; }

        public string TCap { get; set; }
        public DateTime TCapCreatedOn { get; set; }
        public bool NoTCap { get; set; }

        public string Zone { get; set; }
        public DateTime ZoneCreatedOn { get; set; }
        public bool NoZone { get; set; }

        public bool AllValuesValid
        {
            get
            {
                return !NoICap && !NoTCap && !NoZone && !NoLoadProfile && !NoRateClass;// && !NoTariffCode;
            }
        }
        #endregion


        #region public methods
        public void PopulateDataRow(string messageId, DataRow dataRow, string fieldName)
        {
            DateTime beginDate = DateTime.Now;
            string method = string.Format("PopulateDataRow(messageId,dataRow,fieldName:{0})", Utilities.Common.NullSafeString(fieldName));
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                switch (fieldName)
                {
                    case "icap":
                        PopulateWithICapDataRow(messageId, dataRow);
                        break;
                    case "tcap":
                        PopulateWithTCapDataRow(messageId, dataRow);
                        break;
                    case "zone":
                        PopulateWithZoneDataRow(messageId, dataRow);
                        break;
                    case "loadprofile":
                        PopulateWithLoadProfileDataRow(messageId, dataRow);
                        break;
                    case "rateclass":
                        PopulateWithRateClassDataRow(messageId, dataRow);
                        break;
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));

            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void PopulateWithICapDataRow(string messageId, DataRow dataRow)
        {
            DateTime beginDate = DateTime.Now;
            string method = "PopulateWithICapDataRow(messageId,dataRow)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (dataRow != null)
                {
                    // initialize values
                    bool isValidICapValue = IsValidCapValue(messageId, dataRow["ICap"]);
                    DateTime newDate = DateTime.MinValue;
                    bool newerValuePresent = false;

                    if (dataRow["DateCreated"] != null)
                    {
                        newDate = DateTime.Parse(dataRow["DateCreated"].ToString());
                        newerValuePresent = true;
                    }
                    if (isValidICapValue && (string.IsNullOrWhiteSpace(ICap) || newerValuePresent))
                    {
                        ICap = dataRow["ICap"].ToString();
                        ICapCreatedOn = newDate;
                        NoICap = !isValidICapValue;
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void PopulateWithTCapDataRow(string messageId, DataRow dataRow)
        {
            DateTime beginDate = DateTime.Now;
            string method = "PopulateWithTCapDataRow(messageId,dataRow)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (dataRow != null)
                {
                    bool isValidTCapValue = IsValidCapValue(messageId, dataRow["TCap"]);
                    DateTime newDate = DateTime.MinValue;
                    bool newerValuePresent = false;

                    if (dataRow["DateCreated"] != null)
                    {
                        newDate = DateTime.Parse(dataRow["DateCreated"].ToString());
                        newerValuePresent = true;
                    }

                    if (isValidTCapValue && (string.IsNullOrWhiteSpace(TCap) || newerValuePresent))
                    {
                        TCap = dataRow["TCap"].ToString();
                        TCapCreatedOn = newDate;
                        NoTCap = !isValidTCapValue;
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void PopulateWithZoneDataRow(string messageId, DataRow dataRow)
        {
            DateTime beginDate = DateTime.Now;
            string method = "PopulateWithZoneDataRow(messageId,dataRow)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));


                if (dataRow != null)
                {
                    bool isValidValue = IsValidValue(messageId, dataRow["Zone"]);
                    DateTime newDate = DateTime.MinValue;
                    bool newerValuePresent = false;

                    if (dataRow["DateCreated"] != null)
                    {
                        newDate = DateTime.Parse(dataRow["DateCreated"].ToString());
                        newerValuePresent = true;
                    }

                    if (isValidValue && (string.IsNullOrWhiteSpace(Zone) || newerValuePresent))
                    {
                        Zone = dataRow["Zone"].ToString();
                        ZoneCreatedOn = newDate;
                        NoZone = !isValidValue;
                    }
                }


                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void PopulateWithLoadProfileDataRow(string messageId, DataRow dataRow)
        {
            DateTime beginDate = DateTime.Now;
            string method = "PopulateWithLoadProfileDataRow(messageId,dataRow)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (dataRow != null)
                {
                    if (dataRow["LoadProfile"] != null)
                    {
                        LoadProfile = dataRow["LoadProfile"].ToString();
                        NoLoadProfile = string.IsNullOrWhiteSpace(LoadProfile);
                    }
                    if (dataRow["DateCreated"] != null)
                    {
                        LoadProfileCreatedOn = DateTime.Parse(dataRow["DateCreated"].ToString());
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }

        public void PopulateWithRateClassDataRow(string messageId, DataRow dataRow)
        {
            DateTime beginDate = DateTime.Now;
            string method = "PopulateWithRateClassDataRow(messageId,dataRow)";
            try
            {
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} BEGIN", NAMESPACE, CLASS, method));

                if (dataRow != null)
                {
                    if (dataRow["RateClass"] != null)
                    {
                        RateClass = dataRow["RateClass"].ToString();
                        NoRateClass = string.IsNullOrWhiteSpace(RateClass);
                    }
                    if (dataRow["DateCreated"] != null)
                    {
                        RateClassCreatedOn = DateTime.Parse(dataRow["DateCreated"].ToString());
                    }
                }

                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END Time Elapsed:{3}", NAMESPACE, CLASS, method, DateTime.Now.Subtract(beginDate).Milliseconds.ToString()));
            }
            catch (Exception exc)
            {
                _logger.LogError(messageId, string.Format("{0}.{1}.{2} ERROR:{3}", NAMESPACE, CLASS, method, exc.Message), exc);
                _logger.LogInfo(messageId, string.Format("{0}.{1}.{2} END", NAMESPACE, CLASS, method));
                throw;
            }
        }


        public override string ToString()
        {
            return string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17}",
                UtilityCode, AccountNumber, AllValuesValid,
                ICap, ICapCreatedOn, NoICap,
                TCap, TCapCreatedOn, NoTCap,
                Zone, ZoneCreatedOn, NoZone,
                LoadProfile, LoadProfileCreatedOn, NoLoadProfile,
                RateClass, RateClassCreatedOn, NoRateClass);
        }
        #endregion



        #region private methods
        private bool IsValidCapValue(string messageId, object capValue)
        {
            return !(capValue == null || string.IsNullOrWhiteSpace(capValue.ToString()) || capValue.ToString().Substring(0, 3) == "-1.");
        }

        private bool IsValidValue(string messageId, object value)
        {
            return !(value == null || string.IsNullOrWhiteSpace(value.ToString()));
        }
        #endregion
    }
}