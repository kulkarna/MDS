using System;
using System.Data;
using System.Linq;
using System.Threading;
using System.Configuration;
using System.Collections.Generic;
using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;
using LibertyPower.DataAccess.SqlAccess.AccountSql;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using LibertyPower.Business.CommonBusiness.CommonHelper;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CommonBusiness.CommonExceptions;
using LibertyPower.Business.CommonBusiness.TimeSeries;

namespace LibertyPower.Business.MarketManagement.UsageManagement
{
    public static class UsageFactory
    {
        delegate UsageList consolidatedUsageDelegate(string accountNumber, string utility, DateTime From, DateTime To);
        delegate UsageList ediUsageDelegate(string accountNumber, string utility, DateTime From, DateTime To);
        delegate UsageList ediUsageDelegateConsolidation(string accountNumber, string utility, DateTime From, DateTime To, bool forUsageConsolidation);
        delegate UsageList scrapedUsageDelegate(string accountNumber, string utility, DateTime From, DateTime To, bool accountIsEnrolled);
        delegate UsageList scrapedUsageDelegateConsolidation(string accountNumber, string utility, DateTime From, DateTime To, bool accountIsEnrolled, bool forUsageConsolidation);
        delegate UsageList istaUsageDelegate(string accountNumber, string utility, DateTime From, DateTime To);
        delegate UsageList fileUsageDelegate(string accountNumber, string utility, DateTime From, DateTime To);


        // 3/17/2014 3:03 pm Jikku
        //On encountering two overlapping intervals, it removes the smaller interval
        public static void RemoveEdiConflicts(UsageList ediUsage, bool multipleMeters)
        {
            SortMeterReadsforEdi(ediUsage, multipleMeters);
            if (ediUsage.Count == 0)
                return;// no conflicts to resolve
            Usage prev = ediUsage[0];
            Usage next;
            List<int> indexesToRemove = new List<int>();
            for (int i = 1; i < ediUsage.Count; i++)
            {
                next = ediUsage[i];
                if (next.UsageType == UsageType.Canceled)
                {
                    indexesToRemove.Add(i);
                }
                else if ((!multipleMeters || (prev.MeterNumber == next.MeterNumber)) && UsageOverlaps(prev, next))
                {
                    if (prev.EndDate - prev.BeginDate > next.EndDate - next.BeginDate)
                        indexesToRemove.Add(i);//next's index
                    else
                        indexesToRemove.Add(i - 1);//prev's index
                }
                prev = next;
            }

            indexesToRemove.Sort();
            for (int i = indexesToRemove.Count - 1; i >= 0; i--)
            {
                ediUsage.RemoveAt(indexesToRemove[i]);
            }
        }

        // 4/02/2014 4:03 pm CGHAZAL
        //On encountering two overlapping intervals, it removes the oldest one
        public static void RemoveScrapedConflicts(UsageList scrapedUsage, bool multipleMeters)
        {
            SortMeterReads(scrapedUsage, multipleMeters);
            if (scrapedUsage.Count == 0)
                return;// no conflicts to resolve

            Usage prev = scrapedUsage[0];
            Usage next;
            List<int> indexesToRemove = new List<int>();
            for (int i = 1; i < scrapedUsage.Count; i++)
            {
                next = scrapedUsage[i];
                if ((!multipleMeters || (prev.MeterNumber == next.MeterNumber)) && UsageOverlaps(prev, next))
                {
                    DateTime prevDate = (prev.DateCreated == null) ? DateTime.MinValue : DateTime.Parse(prev.DateCreated.ToString());
                    DateTime nextDate = (next.DateCreated == null) ? DateTime.MinValue : DateTime.Parse(next.DateCreated.ToString());

                    //if next date is at least one day older than prev date, then it will disregarded and we will use the latest value scraped
                    if (prevDate > nextDate.AddDays(1))
                    {
                        if (!indexesToRemove.Contains(i))
                            indexesToRemove.Add(i); //next's index
                    }
                    //if prev date is at least one day older than next date, then it will disregarded and we will use the latest value scraped
                    else if (nextDate > prevDate.AddDays(1))
                    {
                        if (!indexesToRemove.Contains(i - 1))
                            indexesToRemove.Add(i - 1); //prev's index
                    }
                    //if both next and prev date are parsed on the same day (wihtin the same 24 hour), we will pick the one with the greater KWH value
                    else
                    {
                        if (prev.TotalKwh > next.TotalKwh)
                        {
                            if (!indexesToRemove.Contains(i))
                                indexesToRemove.Add(i); //next's index
                        }
                        else
                        {
                            if (!indexesToRemove.Contains(i - 1))
                                indexesToRemove.Add(i - 1); //prev's index
                        }
                    }
                }
                prev = next;
            }

            indexesToRemove.Sort();
            for (int i = indexesToRemove.Count - 1; i >= 0; i--)
            {
                scrapedUsage.RemoveAt(indexesToRemove[i]);
            }
        }


        // 3/6/2014 4:25 pm Jikku
        // This function tells you whether usage1 and usage2 overlap in any way
        public static bool UsageOverlaps(Usage usage1, Usage usage2)
        {
            //the usageList is expected to be

            if ((usage1.BeginDate == usage2.BeginDate && usage1.EndDate == usage2.EndDate) ||  // if the date range for both usages is the same
                (usage1.EndDate < usage2.EndDate && usage1.EndDate > usage2.BeginDate) ||//if usage1's enddate lies in between the data range of usage2
                (usage1.BeginDate > usage2.BeginDate && usage1.BeginDate < usage2.EndDate) || //if usage1's begindate lies in between the data range of usage2
                (usage2.EndDate < usage1.EndDate && usage2.EndDate > usage1.BeginDate) || //if usage2's enddate lies in between the data range of usage1
                (usage2.BeginDate > usage1.BeginDate && usage2.BeginDate < usage1.EndDate))//if usage2's begindate lies in between the data range of usage1
                return true;
            return false;
        }

        //3/6/2014 4:25 pm Jikku
        //Given a list of usages, it aggregates those usages which overlap so that the output list doesnt have any overlapping intervals
        public static UsageList AggregateOverlappingUsageIntervals(UsageList usageList, bool multipleMeters)
        {
            SortMeterReads(usageList, multipleMeters);//sort in descendin order by meter number, begin date, end date,usagesource, usagetype and kwh
            int count = usageList.Count;
            UsageList overlaps = new UsageList();
            UsageList nonOverlaps = new UsageList();
            if (count == 0)
                return nonOverlaps;
            overlaps.Add(usageList[0]);
            for (int i = 1; i < count; i++)
            {
                int overlapCount = overlaps.Count;
                Usage lastUsage = overlaps[overlapCount - 1];
                if (usageList[i].MeterNumber == lastUsage.MeterNumber && UsageOverlaps(usageList[i], lastUsage))//overlapping meter read
                {

                }
                else// if the current meter read doesnt overlap with the overlap set
                {
                    if (overlapCount == 1)
                    {

                    }
                    else
                    {
                        //sum up the kwh
                        //get the begin date for the last usage in overlaps and the max enddate for the first usage in the overlaps
                        //update the first element in the list
                        //insert the first element into nonoverlaps
                        overlaps[0].EndDate = overlaps.Select(o => o.EndDate).Max();
                        overlaps[0].BeginDate = overlaps[overlapCount - 1].BeginDate;
                        overlaps[0].TotalKwh = overlaps.Select(o => o.TotalKwh).Sum();
                        overlaps[0].ReasonCode = ReasonCode.AggregatedKwhFromOverlaps;
                    }

                    nonOverlaps.Add(overlaps[0]);
                    overlaps = new UsageList();
                }
                overlaps.Add(usageList[i]);
            }

            //take care of the last set of overlaps
            if (overlaps.Count == 1)
            {
                //Do nothing

            }
            else
            {
                //sum up the kwh
                //get the begin date for the last usage in overlaps and the enddate for the first usage in the overlaps
                //update the first element in the list
                //insert the first element into nonoverlaps
                overlaps[0].EndDate = overlaps.Select(o => o.EndDate).Max();
                overlaps[0].BeginDate = overlaps[overlaps.Count - 1].BeginDate;
                overlaps[0].TotalKwh = overlaps.Select(o => o.TotalKwh).Sum();
                overlaps[0].ReasonCode = ReasonCode.AggregatedKwhFromOverlaps;
            }
            nonOverlaps.Add(overlaps[0]);
            return nonOverlaps;
        }

        /// <summary>
        /// Added By : Vikas Sharma
        /// PBI-88315
        /// This Method Removes the Problem Which Occurs Due to the Sorting Order.
        /// </summary>
        /// <param name="cleanList"></param>
        /// <returns></returns>
        public static double GetAnnualUsage(UsageList cleanList)
        {
            double usage = 0.00;
            try
            {
                DataTable dtUsageList = new DataTable();
                dtUsageList = ListConverter.ToDataTable(cleanList);
                DataSet UsageResult = UsageSql.Usp_GetAnnualUsage(dtUsageList);
                if (UsageResult != null && UsageResult.Tables.Count > 0)
                    usage = !string.IsNullOrEmpty(Convert.ToString(UsageResult.Tables[0].Rows[0][0])) ? Convert.ToDouble(UsageResult.Tables[0].Rows[0][0]) : 0.00;
            }
            catch (Exception ex) { throw; }
            return usage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Method that fills in the internal and extenal gaps
        /// </summary>
        /// <param name="list"></param>
        /// <returns>Returns a clean list consisting of valid records only (i.e. no invalid/overlapping records, no gaps, etc.)</returns>
        public static UsageList GetSnapshot(UsageList usageList, string account, string utility, string user, string zone, string profile)
        {
            // collect all broken rules with this rule (SD 19231)
            ValidDataForUsageConsolidationRule ucRule = new ValidDataForUsageConsolidationRule();
            UsageList finalList = new UsageList();
            UsageList cleanList = new UsageList();

            if (usageList != null && usageList.Count != 0)
            {
                bool multipleMeters = UtilityFactory.GetUtilityByCode(utility).MultipleMeters;

                //remove any lingering bad records (from raw-usage)..
                cleanList = UsageFiller.removeLingeringInactive(usageList);
                cleanList = SortMeterReads(cleanList, multipleMeters);

                LoadShapeIdExistsRule rule1 = new LoadShapeIdExistsRule(account, utility, profile);
                if (!rule1.Validate())
                    AddUsageConsolidationException(ref ucRule, new BrokenRuleException(rule1, rule1.Exception.Message));

                ZoneExistsRule rule2 = new ZoneExistsRule(account, utility, zone);
                if (!rule2.Validate())
                    AddUsageConsolidationException(ref ucRule, new BrokenRuleException(rule2, rule2.Exception.Message));

                // check for any broken rules, throw exception to prevent further execution
                if (ucRule.Exception != null)
                {
                    string err = ucRule.Exception.DependentExceptions[0].Message == null ? ucRule.Exception.Message : ucRule.Exception.DependentExceptions[0].Message;
                    throw new BrokenRuleException(ucRule, err);
                }

                // break up usage list for utilities with multiple meter numbers before filling in the gaps
                if (multipleMeters)
                {
                    UsageList newList = new UsageList();
                    string previousM = "xxx";

                    foreach (Usage meterRead in cleanList)
                    {
                        if (meterRead.MeterNumber != previousM && previousM != "xxx")	//new meter-number
                        {
                            // fill gaps (execute code only if there's an internal or external gap)..
                            if (UsageFiller.IsThereAnInternalGap(newList) | UsageFiller.IsThereAnExternalGap(newList))
                            {
                                finalList.AddRange(FillInTheGaps(newList, profile, zone, ref ucRule, user, multipleMeters));

                                newList = new UsageList();
                                newList.Add(meterRead);						//first record for this meter-number
                            }

                        }
                        else
                            newList.Add(meterRead);							//add record to temporary list

                        previousM = meterRead.MeterNumber;
                    }

                    if (newList != null && newList.Count != 0)
                        finalList.AddRange(FillInTheGaps(newList, profile, zone, ref ucRule, user, multipleMeters));

                    finalList = SortMeterReads(finalList, multipleMeters);
                }
                else
                {
                    // fill gaps (execute code only if there's an internal or external gap)..
                    if (UsageFiller.IsThereAnInternalGap(cleanList) | UsageFiller.IsThereAnExternalGap(cleanList))
                        finalList = FillInTheGaps(cleanList, profile, zone, ref ucRule, user, multipleMeters);

                }

            }

            return (finalList.Count == 0 ? cleanList : finalList);
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Overloaded method which does not fill in the gaps (raw)
        /// </summary>
        /// <param name="usageList"></param>
        /// <param name="account"></param>
        /// <param name="utility"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public static UsageList GetSnapshot(UsageList usageList, string account, string utility, string user)
        {
            UsageList cleanList = new UsageList();

            if (usageList != null && usageList.Count != 0)
            {
                bool multipleMeters = UtilityFactory.GetUtilityByCode(utility).MultipleMeters;

                //remove any lingering bad records (from raw-usage)..
                cleanList = UsageFiller.removeLingeringInactive(usageList);
                cleanList = SortMeterReads(cleanList, multipleMeters);
            }

            return (cleanList.Count == 0 ? usageList : cleanList);
        }

        // ------------------------------------------------------------------------------------
        private static void AddUsageConsolidationException(ref ValidDataForUsageConsolidationRule ucRule,
            BrokenRuleException exception)
        {
            if (ucRule.Exception == null)
            {
                ucRule.SetParentException("Insufficient data for usage consolidation.");
            }

            ucRule.AddParentDependantException(exception);
        }

        // ------------------------------------------------------------------------------------
        public static bool CheckValidProfileRangeRule(UsageList usageList, string profile, string zone, ref ValidDataForUsageConsolidationRule ucRule,
            string user, bool multipleMeters)
        {
            string utility = usageList[0].UtilityCode;
            string account = usageList[0].AccountNumber;


            //get 364 date range (in order to fill in gaps)..
            CommonBusiness.CommonHelper.DateRange range1 = UsageFiller.Get364DateRange(usageList);

            //get profiled data..
            PeakProfileDictionary profiles1 = ProfileFactory.SelectDailyProfiles(utility, profile, zone, range1);

            //check if we have enough profiled data
            VaildProfileRangeRule rule3 = new VaildProfileRangeRule(account, utility, profiles1.Count - 1, range1, profile);
            if (!rule3.Validate())
                AddUsageConsolidationException(ref ucRule, new BrokenRuleException(rule3, rule3.Exception.Message));

            // check for any broken rules, throw exception to prevent further execution
            if (ucRule.Exception != null)
            {
                string err = ucRule.Exception.DependentExceptions[0].Message == null ? ucRule.Exception.Message : ucRule.Exception.DependentExceptions[0].Message;
                throw new BrokenRuleException(ucRule, err);
            }

            //now we need to get the daily profiles of the entire usage object (need it in order to fill gaps outside the 364 date range)..
            CommonBusiness.CommonHelper.DateRange range2 = UsageFiller.GetDateRange(usageList);
            PeakProfileDictionary profiles2 = ProfileFactory.SelectDailyProfiles(utility, profile, zone, range2);

            rule3 = new VaildProfileRangeRule(account, utility, profiles2.Count - 1, range2, profile);
            if (!rule3.Validate())
                AddUsageConsolidationException(ref ucRule, new BrokenRuleException(rule3, rule3.Exception.Message));

            // check for any broken rules, throw exception to prevent further execution
            if (ucRule.Exception != null)
            {
                throw new BrokenRuleException(ucRule, ucRule.Exception.Message);
            }
            return true;
        }


        // ------------------------------------------------------------------------------------
        private static UsageList FillInTheGaps(UsageList usageList, string profile, string zone, ref ValidDataForUsageConsolidationRule ucRule,
            string user, bool multipleMeters)
        {
            string utility = usageList[0].UtilityCode;
            string account = usageList[0].AccountNumber;
            UsageList finalList = new UsageList();

            //get 364 date range (in order to fill in gaps)..
            CommonBusiness.CommonHelper.DateRange range1 = UsageFiller.Get364DateRange(usageList);

            //get profiled data..
            PeakProfileDictionary profiles1 = ProfileFactory.SelectDailyProfiles(utility, profile, zone, range1);

            //check if we have enough profiled data
            VaildProfileRangeRule rule3 = new VaildProfileRangeRule(account, utility, profiles1.Count - 1, range1, profile);
            if (!rule3.Validate())
                AddUsageConsolidationException(ref ucRule, new BrokenRuleException(rule3, rule3.Exception.Message));

            // check for any broken rules, throw exception to prevent further execution
            if (ucRule.Exception != null)
            {
                string err = ucRule.Exception.DependentExceptions[0].Message == null ? ucRule.Exception.Message : ucRule.Exception.DependentExceptions[0].Message;
                throw new BrokenRuleException(ucRule, err);
            }

            //now we need to get the daily profiles of the entire usage object (need it in order to fill gaps outside the 364 date range)..
            CommonBusiness.CommonHelper.DateRange range2 = UsageFiller.GetDateRange(usageList);
            PeakProfileDictionary profiles2 = ProfileFactory.SelectDailyProfiles(utility, profile, zone, range2);

            rule3 = new VaildProfileRangeRule(account, utility, profiles2.Count - 1, range2, profile);
            if (!rule3.Validate())
                AddUsageConsolidationException(ref ucRule, new BrokenRuleException(rule3, rule3.Exception.Message));

            // check for any broken rules, throw exception to prevent further execution
            if (ucRule.Exception != null)
            {
                throw new BrokenRuleException(ucRule, ucRule.Exception.Message);
            }

            //determine ratio..
            decimal ratio = UsageFiller.GetRatio(usageList, profiles1, range1);

            //fill in the gap(s)..
            UsageList estimatedList = UsageFiller.EstimateInternalGap(usageList, user, ratio, profiles2);
            //			estimatedList = CleanTheList( estimatedList, user, multipleMeters );

            UsageList intermediateList = new UsageList();

            foreach (Usage item in usageList)
                intermediateList.Add(item);

            foreach (Usage item in estimatedList)
                intermediateList.Add(item);

            intermediateList.Sort(SortUsage);

            estimatedList.AddRange(UsageFiller.EstimateExternalGap(intermediateList, user, ratio, profile, zone));

            //insert estimated records into the database..
            finalList = InsertEstimatedUsageListIntoDatabase(estimatedList, user);

            //build new list (without gaps/cancels) which will be passed on to the consumer..
            foreach (Usage item in usageList)
            {
                if (item.UsageType != UsageType.Canceled)
                    finalList.Add(item);
            }

            finalList.Sort(SortUsage);

            return finalList;
        }

        // ------------------------------------------------------------------------------------
        // 12/30/2008
        /// <summary>
        /// Retrieves usage from the consolidated table
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="dateFrom"></param>
        /// <param name="dateTo"></param>
        /// <returns></returns>
        public static UsageList GetListByOffer(string offerID, string utility, DateTime dateFrom, DateTime dateTo)
        {
            DataSet ds = UsageSql.GetConsolidatedUsageByOffer(offerID, utility, dateFrom, dateTo);
            return GetList(ds);
        }

        // ------------------------------------------------------------------------------------
        // 12/30/2008
        /// <summary>
        /// Retrieves usage from the consolidated table
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="dateFrom"></param>
        /// <param name="dateTo"></param>
        /// <returns></returns>
        public static UsageList GetList(string accountNumber, string utility, DateTime dateFrom, DateTime dateTo)
        {
            DataSet ds = UsageSql.GetConsolidatedUsage(accountNumber, utility, dateFrom, dateTo);
           
            return GetList(ds);

        }


        /*
                public static UsageList GetCompleteList( string accountNumber )
                {
                    DataSet ds = UsageSql.GetConsolidatedUsageComplete( accountNumber );
                    return GetList( ds );
                }
        */

        // ------------------------------------------------------------------------------------
        // 12/30/2008
        private static UsageList GetList(DataSet ds1)
        {
            UsageList usages = new UsageList();

            if (ds1 != null && ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow row in ds1.Tables[0].Rows)
                    usages.Add(GetList(row));

            }

            return usages;
        }

        // ------------------------------------------------------------------------------------
        private static Usage GetEstimatedList(DataRow row)
        {
            Usage newUsage = null;

            if (row != null)
            {
                newUsage = new Usage((long?)row["id"]);
                newUsage.UtilityCode = (string)row["utilityCode"];
                if (row.Table.Columns.Contains("WholeSaleMktID"))
                    newUsage.ISO = (string)row["WholeSaleMktID"];
                newUsage.AccountNumber = (string)row["accountNumber"];
                //				newUsage.UsageType = UsageType.Estimated;
                newUsage.UsageType = (UsageType)row["UsageType"];
                newUsage.UsageSource = UsageSource.User;
                newUsage.BeginDate = (DateTime)(row["fromDate"]);
                newUsage.EndDate = (DateTime)(row["toDate"]);
                newUsage.TotalKwh = (int)(row["totalKwh"]);
                newUsage.IsActive = (Int16)1;
                newUsage.ReasonCode = ReasonCode.InsertedFromFramework;
                newUsage.MeterNumber = row["MeterNumber"] == DBNull.Value ? "" : (string)row["MeterNumber"];
                newUsage.IsConsolidated = false;
            }

            return newUsage;
        }

        // ------------------------------------------------------------------------------------
        private static Usage GetList(DataRow row)
        {
            Usage newUsage = null;

            if (row != null)
            {
                newUsage = new Usage((long?)row["id"]);
                newUsage.UtilityCode = (string)row["utilityCode"];
                newUsage.AccountNumber = (string)row["accountNumber"];
                newUsage.UsageType = (UsageType)Convert.ToInt32(row["usageType"]);
                newUsage.UsageSource = (UsageSource)Convert.ToInt32(row["UsageSource"]);
                newUsage.BeginDate = (DateTime)(row["fromDate"]);
                newUsage.EndDate = (DateTime)(row["toDate"]);
                newUsage.TotalKwh = (int)(row["totalKwh"]);
                newUsage.IsActive = (Int16)row["Active"];
                newUsage.ReasonCode = (ReasonCode)Convert.ToInt32(row["ReasonCode"]);
                newUsage.MeterNumber = row["MeterNumber"] == DBNull.Value ? "" : (string)row["MeterNumber"];
                newUsage.IsConsolidated = true;
            }

            return newUsage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Checks whether an account is currently enrolled with us or not
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="UtilityCode"></param>
        /// <returns></returns>
        public static bool IsEnrolled(string accountNumber, string UtilityCode)
        {
            DataSet ds = AccountSql.IsAccountEnrolled(accountNumber, UtilityCode);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                return true;
            else
                return false;
        }

        public static UsageList GetConsolidatedUsage(string accountNumber, string utilityCode, DateTime dateFrom, DateTime dateTo, string userId)
        {
            UsageList usageList;
            try
            {
                usageList = GetRawUsage(accountNumber, utilityCode.ToUpper(), dateFrom, dateTo, "Forecasting: " + userId);
                usageList = GetSnapshot(usageList, accountNumber, utilityCode.ToUpper(), userId);
            }
            catch (Exception ex)
            {
                usageList = new UsageList();
            }

            return usageList;
        }

        //( accountNumbersString, utilityCode,
        //			startDateUsage, endDateUsage, userName ));
        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Retrieves consolidated usage from all available sources (starting with the "consolidated" table)
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <returns></returns>
        /// <remarks>This procedure saves to the database and may return some duplicate records (i.e. same begin/end dates, same kwh yet different usage types)</remarks>
        public static void GetRawUsageOptimized(string offerID, string utilityCode, DateTime dateFrom, DateTime dateTo, string userId, ref UsageList ediUsage, ref UsageList scrapedUsage, ref UsageList fileUsage, ref UsageList istaUsage, ref UsageList consolidatedUsage)
        {

            utilityCode = utilityCode.ToUpper().Trim();


            //05-11-2011 - per Douglas, turn this "crazy" logic off.. 8-|
            //bool isEnrolled = IsEnrolled( accountNumber, utilityCode );
            bool isEnrolled = false;

            if ((dateTo - dateFrom).Days < 365)
                throw new InvalidDateRange("An invalid date range (" + String.Format("{0:yyyy/MM/dd}", dateFrom) + "-" + String.Format("{0:yyyy/MM/dd}", dateTo) + ") was used. A date range of at least 364 days must be used.");

            //first check in the consolidated table..
            //http://support.microsoft.com/kb/315582
            //consolidatedUsage = GetList( accountNumber, utilityCode, dateFrom, dateTo, true );
            consolidatedUsageDelegate consDlgt = new consolidatedUsageDelegate(GetListByOffer);
            IAsyncResult cAsynchResult = consDlgt.BeginInvoke(offerID, utilityCode, dateFrom, dateTo, null, null);

            istaUsageDelegate iDlgt = null;
            IAsyncResult iAsynchResult = null;

            // 1-33626971 - per Douglas, get billed usage for NEISO from ISTA
            UtilityList list = UtilityFactory.GetUtilitiesByWholesaleMarketId(4);

            if (list.Where(i => i.FullName == utilityCode).SingleOrDefault() != null)
            {
                iDlgt = new istaUsageDelegate(UsageFiller.GetIstaBilledUsageByOffer);
                iAsynchResult = iDlgt.BeginInvoke(offerID, utilityCode, dateFrom, dateTo, null, null);
            }

            //now start checking in the legacy tables..
            scrapedUsageDelegate scpDlgt = new scrapedUsageDelegate(UsageFiller.GetScrapedUsageByOffer);
            IAsyncResult scrAsynchResult = scpDlgt.BeginInvoke(offerID, utilityCode, dateFrom, dateTo, isEnrolled, null, null);

            ediUsageDelegate eDlgt = new ediUsageDelegate(UsageFiller.GetEdiUsageByOffer);
            IAsyncResult eAsynchResult = eDlgt.BeginInvoke(offerID, utilityCode, dateFrom, dateTo, null, null);

            fileUsageDelegate fileDlgt = new fileUsageDelegate(UsageFiller.GetFileUsageByOffer);
            IAsyncResult fileAsynchResult = fileDlgt.BeginInvoke(offerID, utilityCode, dateFrom, dateTo, null, null);

            //finish calling methods asynchronously
            consolidatedUsage = consDlgt.EndInvoke(cAsynchResult);
            scrapedUsage = scpDlgt.EndInvoke(scrAsynchResult);
            ediUsage = eDlgt.EndInvoke(eAsynchResult);
            if (list.Where(i => i.FullName == utilityCode).SingleOrDefault() != null)
                istaUsage = iDlgt.EndInvoke(iAsynchResult);

            fileUsage = fileDlgt.EndInvoke(fileAsynchResult);
        }

        public static UsageList GetRawUsageByAccountPart2(string accountNumber, string utilityCode, DateTime dateFrom, DateTime dateTo, string userId, UsageList ediUsage, UsageList scrapedUsage, UsageList istaUsage, UsageList fileUsage, UsageList consolidatedUsage, bool multipleMeters)
        {

            UsageList rawUsage = new UsageList();
            //todo: fix the scraper which is putting meter number at the summary level..
            if (multipleMeters && scrapedUsage != null)
                UpdateRawMeterInformation(ediUsage, scrapedUsage);

            //add up raw usage
            rawUsage = UsageFiller.AddLists(rawUsage, scrapedUsage);
            rawUsage = UsageFiller.AddLists(rawUsage, ediUsage);
            rawUsage = UsageFiller.AddLists(rawUsage, istaUsage);
            rawUsage = UsageFiller.AddLists(rawUsage, fileUsage);

            SufficientUsageRule rule = new SufficientUsageRule(accountNumber, utilityCode, rawUsage, consolidatedUsage);
            if (!rule.Validate())
                throw new BrokenRuleException(rule, rule.Exception.Message);

            UsageList cleanList = null;

            if (rawUsage == null)
            {
                // initial load needs to be cleaned, even if there are no more new "raw" meter reads..
                cleanList = CleanTheList(consolidatedUsage, userId, multipleMeters);
                return cleanList;
            }

            //for utilities that have multiple meters, update in consolidated records with valid meter numbers
            if (multipleMeters)
                UpdateMeterInformation(consolidatedUsage, rawUsage, userId);

            //sort depending on whether it has multiple meters or not..
            rawUsage = SortMeterReads(rawUsage, multipleMeters);

            UsageList rawListWithoutDuplicates = UsageFiller.HandleDuplicates(rawUsage, multipleMeters);

            //due to the new table structure, need to check if new cancel invalidates an already 
            //consolidated one so i can inactivate it before inserting the new cancel..
            //			if( newUsage != null && newUsage.Count != 0 )
            //				UsageFiller.UpdateConsolidatedCancels( consolidatedUsage, newUsage, userId );

            //add new usage to existing usage..
            UsageList semiConsolidatedUsage = UsageFiller.ConsolidateLists(consolidatedUsage, rawListWithoutDuplicates);

            //clean + validate the usage..
            cleanList = CleanTheList(semiConsolidatedUsage, userId, multipleMeters);

            //retrieve new (raw) records..
            UsageList newUsage = UsageFiller.NotConsolidated(cleanList);

            //insert new records into the database..
            if (newUsage != null && newUsage.Count != 0)
            {
                //get me the id's of the consolidated records we updated from raw + of the new inserted ones..
                UsageList newInsertedUsage = InsertUsageListIntoDatabase(newUsage, userId);

                //append to consolidated only new records (since updated records didn't have id's)
                UsageList StillNew = UsageFiller.GetNewRawUsage(consolidatedUsage, newInsertedUsage);

                //add new usage to existing usage..
                consolidatedUsage = UsageFiller.AddLists(consolidatedUsage, StillNew);
            }

            return consolidatedUsage;
        }



        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Retrieves consolidated usage from all available sources (starting with the "consolidated" table)
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <returns></returns>
        /// <remarks>This procedure saves to the database and may return some duplicate records (i.e. same begin/end dates, same kwh yet different usage types)</remarks>
        public static UsageList GetRawUsage(string accountNumber, string utilityCode, DateTime dateFrom, DateTime dateTo, string userId)
        {
            utilityCode = utilityCode.ToUpper().Trim();
            bool multipleMeters = UtilityFactory.GetUtilityByCode(utilityCode).MultipleMeters;

            //05-11-2011 - per Douglas, turn this "crazy" logic off.. 8-|
            //bool isEnrolled = IsEnrolled( accountNumber, utilityCode );
            bool isEnrolled = false;

            if ((dateTo - dateFrom).Days < 365)
                throw new InvalidDateRange("An invalid date range (" + String.Format("{0:yyyy/MM/dd}", dateFrom) + "-" + String.Format("{0:yyyy/MM/dd}", dateTo) + ") was used. A date range of at least 364 days must be used.");

            //first check in the consolidated table..
            UsageList consolidatedUsage = new UsageList();
            //http://support.microsoft.com/kb/315582
            //consolidatedUsage = GetList( accountNumber, utilityCode, dateFrom, dateTo, true );
            consolidatedUsageDelegate consDlgt = new consolidatedUsageDelegate(GetList);
            IAsyncResult cAsynchResult = consDlgt.BeginInvoke(accountNumber, utilityCode, dateFrom, dateTo, null, null);

            UsageList istaUsage = new UsageList();
            istaUsageDelegate iDlgt = null;
            IAsyncResult iAsynchResult = null;

            // 1-33626971 - per Douglas, get billed usage for NEISO from ISTA
            UtilityList list = UtilityFactory.GetUtilitiesByWholesaleMarketId(4);

            if (list.Where(i => i.FullName == utilityCode).SingleOrDefault() != null)
            {
                iDlgt = new istaUsageDelegate(UsageFiller.GetIstaBilledUsage);
                iAsynchResult = iDlgt.BeginInvoke(accountNumber, utilityCode, dateFrom, dateTo, null, null);
            }

            UsageList rawUsage = new UsageList();

            //now start checking in the legacy tables..
            UsageList scrapedUsage = new UsageList();
            scrapedUsageDelegateConsolidation scpDlgt = UsageFiller.GetScrapedUsage;
            IAsyncResult scrAsynchResult = scpDlgt.BeginInvoke(accountNumber, utilityCode, dateFrom, dateTo, isEnrolled, true, null, null);

            UsageList ediUsage = new UsageList();
            ediUsageDelegateConsolidation eDlgt = UsageFiller.GetEdiUsage;
            IAsyncResult eAsynchResult = eDlgt.BeginInvoke(accountNumber, utilityCode, dateFrom, dateTo, true, null, null);
            UsageList fileUsage = new UsageList();
            fileUsageDelegate fileDlgt = new fileUsageDelegate(UsageFiller.GetFileUsage);
            IAsyncResult fileAsynchResult = fileDlgt.BeginInvoke(accountNumber, utilityCode, dateFrom, dateTo, null, null);

            //finish calling methods asynchronously
            consolidatedUsage = consDlgt.EndInvoke(cAsynchResult);
            scrapedUsage = scpDlgt.EndInvoke(scrAsynchResult);
            ediUsage = eDlgt.EndInvoke(eAsynchResult);

            if (list.Where(i => i.FullName == utilityCode).SingleOrDefault() != null)
                istaUsage = iDlgt.EndInvoke(iAsynchResult);

            fileUsage = fileDlgt.EndInvoke(fileAsynchResult);

            //todo: fix the scraper which is putting meter number at the summary level..
            if (multipleMeters && scrapedUsage != null)
                UpdateRawMeterInformation(ediUsage, scrapedUsage);

            //update the meter number in the ISTA list with the meter numbers from eDI (since we dont get the meter number from the ISTA source)
            if (multipleMeters && istaUsage != null)
                UpdateRawMeterInformation(istaUsage, ediUsage);

            //update the meter number in the ISTA list with the meter numbers from eDI (since we dont get the meter number from the ISTA source)
            if (multipleMeters && fileUsage != null)
                UpdateRawMeterInformation(fileUsage, ediUsage);

            //3/6/2014 3:18pm  Jikku John: consolidate overlapping intervals by source
            if (istaUsage != null)
                istaUsage = AggregateOverlappingUsageIntervals(istaUsage, multipleMeters);

            if (ediUsage != null)
                RemoveEdiConflicts(ediUsage, multipleMeters);

            if (scrapedUsage != null)
                RemoveScrapedConflicts(scrapedUsage, multipleMeters);
            ///MTJ++
            //For Records have difference in Quanty, update the consolidated with the billed Quantity
            if (ediUsage != null && consolidatedUsage != null)
                UpdateQuantityFromEDI(consolidatedUsage, ediUsage, userId);

            //add up raw usage
            rawUsage = UsageFiller.AddLists(rawUsage, scrapedUsage);
            rawUsage = UsageFiller.AddLists(rawUsage, ediUsage);
            rawUsage = UsageFiller.AddLists(rawUsage, istaUsage);
            rawUsage = UsageFiller.AddLists(rawUsage, fileUsage);

            SufficientUsageRule rule = new SufficientUsageRule(accountNumber, utilityCode, rawUsage, consolidatedUsage);
            if (!rule.Validate())
                throw new BrokenRuleException(rule, rule.Exception.Message);

            UsageList cleanList = null;

            if (rawUsage == null)
            {
                // initial load needs to be cleaned, even if there are no more new "raw" meter reads..
                cleanList = CleanTheList(consolidatedUsage, userId, multipleMeters);
                return cleanList;
            }

            //for utilities that have multiple meters, update in consolidated records with valid meter numbers
            if (multipleMeters)
                UpdateMeterInformation(consolidatedUsage, rawUsage, userId);

            //sort depending on whether it has multiple meters or not..
            rawUsage = SortMeterReads(rawUsage, multipleMeters);

            //UsageList rawListWithoutDuplicates = UsageFiller.HandleDuplicates( rawUsage, multipleMeters );

            //3/6/2014 4:56 pm Jikku : Remove overlapping entries across the different sources based on the priority of the usage source - keeping higher priority entries and removing lower priority
            UsageFiller.RemoveConflictsBasedOnPriority(rawUsage, multipleMeters);

            if (rawUsage != null && consolidatedUsage != null)
                UpdateQuantityFromEDI(consolidatedUsage, rawUsage, userId);
            //due to the new table structure, need to check if new cancel invalidates an already 
            //consolidated one so i can inactivate it before inserting the new cancel..
            //			if( newUsage != null && newUsage.Count != 0 )
            //				UsageFiller.UpdateConsolidatedCancels( consolidatedUsage, newUsage, userId );
            UsageFiller.RemoveConflictingEntriesFromConsolidatedusage(rawUsage, consolidatedUsage, multipleMeters);

            //add new usage to existing usage..
            UsageList semiConsolidatedUsage = UsageFiller.ConsolidateLists(consolidatedUsage, rawUsage);

            //clean + validate the usage..
            cleanList = CleanTheList(semiConsolidatedUsage, userId, multipleMeters);

            //retrieve new (raw) records..
            UsageList newUsage = UsageFiller.NotConsolidated(cleanList);

            //insert new records into the database..
            if (newUsage != null && newUsage.Count != 0)
            {
                //get me the id's of the consolidated records we updated from raw + of the new inserted ones..
                UsageList newInsertedUsage = InsertUsageListIntoDatabase(newUsage, userId);

                //append to consolidated only new records (since updated records didn't have id's)
                UsageList StillNew = UsageFiller.GetNewRawUsage(consolidatedUsage, newInsertedUsage);

                //add new usage to existing usage..
                consolidatedUsage = UsageFiller.AddLists(consolidatedUsage, StillNew);
            }
         
            consolidatedUsage = UsageFactory.GetList(accountNumber, utilityCode, dateFrom, dateTo);
            return consolidatedUsage;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Given a usage list, this methods checks for duplicates/overlapping meters
        /// </summary>
        /// <param name="metersList"></param>
        /// <returns>True if list needs to be calendarized, false otherwise; also returns false if an empty usage list is given</returns>
        public static bool RequiresCalendarization(UsageList metersList)
        {
            // return false for empty usage lists..
            if (metersList == null || metersList.Count == 0)
                return false;

            // if utility is set up as having multiple meters, verify that the account indeed has more than 1 meter..
            if (UtilityFactory.GetUtilityByCode(metersList[0].UtilityCode).MultipleMeters && HasMultipleMeters(metersList))
                return true;

            metersList = UsageFiller.removeLingeringInactive(metersList);
            metersList = SortMeterReads(metersList, false);

            DateTime previousEnd = DateTime.MinValue;
            DateTime previousBegin = default(System.DateTime);

            foreach (Usage meter in metersList)
            {
                if (!(previousEnd == DateTime.MinValue))		//skip record
                {
                    //current start period > last end period
                    if (meter.BeginDate > previousEnd)
                        return true;

                    //new end date < current start period
                    if (meter.EndDate < meter.BeginDate)
                        return true;

                    //new end date > last start period
                    if (meter.EndDate > previousBegin)
                        return true;

                    //current start period = current end period
                    if (meter.EndDate == meter.BeginDate)
                        return true;

                    //same end date (different periods)
                    if (previousEnd == meter.EndDate)
                        return true;

                    //same begin date (different periods)
                    if (previousBegin == meter.BeginDate)
                        return true;

                }

                previousEnd = meter.EndDate;
                previousBegin = meter.BeginDate;
            }

            return false;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Inserts an estimated usage list into the database
        /// </summary>
        /// <param name="usageList"></param>
        /// <param name="userName"></param>
        /// <returns></returns>
        public static UsageList InsertEstimatedUsageListIntoDatabase(UsageList usageList, string userName)
        {
            UsageList cleanList = new UsageList();

            foreach (Usage item in usageList)
            {
                Usage fromDb = new Usage();

                fromDb = InsertEstimatedUsageRecordIntoDatabase(item, userName);

                cleanList.Add(fromDb);
            }

            return cleanList;
        }

        /// <summary>
        /// Inserts the estimated usage record into database.
        /// </summary>
        /// <param name="period">The period.</param>
        /// <param name="usageType">Type of the usage.</param>
        /// <param name="userName">Name of the user.</param>
        /// <returns></returns>
        public static Usage InsertEstimatedUsageRecordIntoDatabase(Usage period, UsageType usageType, string userName)
        {
            DataSet ds1 = new DataSet();
            Usage usg = null;

            ds1 = UsageSql.InsertEstimatedUsage(period.AccountNumber, period.UtilityCode, period.BeginDate, period.EndDate,
                period.TotalKwh, period.Days, period.MeterNumber, (int)usageType, userName);

            if (ds1 != null && ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0)
                usg = GetEstimatedList(ds1.Tables[0].Rows[0]);

            return usg;
        }
        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Inserts a usage list into the database
        /// </summary>
        /// <param name="usageList"></param>
        /// <param name="userName"></param>
        public static UsageList InsertUsageListIntoDatabase(UsageList usageList, string userName)
        {
            UsageList cleanList = new UsageList();

            foreach (Usage item in usageList)
            {
                Usage fromDb = new Usage();

                fromDb = InsertUsageRecordIntoDatabase(item, userName);

                // new methodology does not allow two active records with the same begin-end dates (
                // i.e. a cancel that does not find a matching record due to inconsistent kwh)
                if (fromDb != null)
                    cleanList.Add(fromDb);
            }

            return cleanList;
        }

        // ------------------------------------------------------------------------------------
        public static Usage InsertEstimatedUsageRecordIntoDatabase(Usage period, string userName)
        {
            DataSet ds1 = new DataSet();
            Usage usg = null;

            ds1 = UsageSql.InsertEstimatedUsage(period.AccountNumber, period.UtilityCode, period.BeginDate, period.EndDate,
                period.TotalKwh, period.Days, period.MeterNumber, userName);

            if (ds1 != null && ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0)
                usg = GetEstimatedList(ds1.Tables[0].Rows[0]);

            return usg;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Inserts records into the (new) consolidated usage table
        /// </summary>
        /// <param name="period"></param>
        /// <param name="meterNumber"></param>
        /// <param name="userName"></param>
        /// <returns></returns>
        /// <remarks>Returns a clean list of historical/billed usage (i.e. no invalid periods, no gaps, etc.)</remarks>
        public static Usage InsertUsageRecordIntoDatabase(Usage period, string userName)
        {
            DataSet ds1 = new DataSet();
            Usage usg = null;

            ds1 = UsageSql.InsertConsolidatedUsage(period.AccountNumber, period.UtilityCode, period.BeginDate, period.EndDate,
                period.TotalKwh, period.Days, period.MeterNumber, period.OnPeakKwh, period.OffPeakKwh, period.BillingDemandKw,
                period.MonthlyPeakDemandKw, period.IntermediateKwh, userName, (int)period.UsageSource, (int)period.UsageType, period.DateModified,
                period.MonthlyOffPeakDemandKw, period.IsActive, (Int16)period.ReasonCode);

            if (ds1 != null && ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0)
                usg = GetList(ds1.Tables[0].Rows[0]);

            return usg;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Updates records in the consolidated usage table
        /// </summary>
        /// <param name="period"></param>
        /// <param name="meterNumber"></param>
        /// 
        /// <returns></returns>
        /// <remarks>Returns an upadted "consolidated" usage record</remarks>
        public static Usage UpdateUsageRecord(Usage period)
        {
            DataSet ds1 = new DataSet();
            Usage usg = null;

            ds1 = UsageSql.UpdateConsolidatedUsage(period.AccountNumber, period.UtilityCode, period.BeginDate, period.EndDate,
                period.TotalKwh, period.Days, period.MeterNumber, period.OnPeakKwh, period.OffPeakKwh, period.BillingDemandKw,
                period.MonthlyPeakDemandKw, period.IntermediateKwh, (int)period.UsageSource, (int)period.UsageType, period.DateModified,
                period.ID, period.MonthlyOffPeakDemandKw, period.IsActive, (Int16)period.ReasonCode);

            if (ds1 != null && ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0)
                usg = GetList(ds1.Tables[0].Rows[0]);

            return usg;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Overloaded method that updates records in the consolidated usage table
        /// </summary>
        /// <param name="period"></param>
        /// <param name="meterNumber"></param>
        /// <param name="userName"></param>
        /// <returns></returns>
        /// <remarks>Returns an upadted "consolidated" usage record </remarks>
        public static Usage UpdateUsageRecord(Usage period, long? Id)
        {
            DataSet ds1 = new DataSet();
            Usage usg = null;

            ds1 = UsageSql.UpdateConsolidatedUsage(period.AccountNumber, period.UtilityCode, period.BeginDate, period.EndDate,
                period.TotalKwh, period.Days, period.MeterNumber, period.OnPeakKwh, period.OffPeakKwh, period.BillingDemandKw,
                period.MonthlyPeakDemandKw, period.IntermediateKwh, (int)period.UsageSource, (int)period.UsageType, period.DateModified,
                Id, period.MonthlyOffPeakDemandKw, period.IsActive, (Int16)period.ReasonCode);

            if (ds1 != null && ds1.Tables.Count > 0 && ds1.Tables[0].Rows.Count > 0)
                usg = GetList(ds1.Tables[0].Rows[0]);

            return usg;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Normalizes usage by getting rid off overlapping and other invalid records (as defined by the business rules)
        /// </summary>
        /// <param name="list"></param>
        /// <param name="account"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        // also need to remove those usage consolidated entries that match with entries
        public static UsageList CleanTheList(UsageList list, string user, bool multipleMeters)
        {
            UsageList cleanList = new UsageList();

            if (list != null)
            {
                //list is out of whack; sort it..
                list = SortMeterReads(list, multipleMeters);

                //get rid off the canceled meter reads' counterparts that have already made it to the consolidated table
                UsageList cancelsHandled = UsageFiller.HandleCancels(list, user);

                //3/6/2014 3:14 pm Jikku
                //instead of a naiive removal of duplicate, we will deactivate those usage consolidated entries which have the  same start, end and meternumber as the ones in the rawusage. This is done before CleanTheList function is invoked
                //UsageList listWithoutDuplicates = UsageFiller.HandleDuplicates( cancelsHandled, multipleMeters );



                //check for invalid meter reads..
                cleanList = UsageFiller.ValidateUsage(cancelsHandled, user, multipleMeters);
            }

            return cleanList;
        }

        // February 2011
        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Sorts meter reads depending on whether one account can have one or multiple meter reads..
        /// In descending order of begin dates,end dates,usagesource, usagetype and kwh
        /// 
        /// </summary>
        /// <param name="list"></param>
        /// <param name="listHasMultipleMeters"></param>
        /// <returns></returns>
        public static UsageList SortMeterReads(UsageList list, bool listHasMultipleMeters)
        {
            if (listHasMultipleMeters == true)
                list.Sort(SortUsageWithMultipleMeters);
            else
                list.Sort(SortUsage);

            return list;
        }

        // ------------------------------------------------------------------------------------
        // -1 means usage2 < usage1; 1 means usage2 > usage1; 0 means usage2 = usage1
        /// <summary>
        /// Sorts Usage ignoring meter numbers
        /// </summary>
        /// <param name="usage1"></param>
        /// <param name="usage2"></param>
        /// <returns></returns>
        public static int SortUsage(Usage usage1, Usage usage2)
        {
            //start off by comparing begin dates..
            if (usage2.BeginDate < usage1.BeginDate)
                return -1;
            else if (usage2.BeginDate > usage1.BeginDate)
                return 1;
            else
            {
                //if they are equal then continue checking end dates..
                if (usage2.EndDate < usage1.EndDate)
                    return -1;
                else if (usage2.EndDate > usage1.EndDate)
                    return 1;
                else
                {
                    //order by usage source..
                    if (usage2.UsageSource < usage1.UsageSource)
                        return 1;
                    else if (usage2.UsageSource > usage1.UsageSource)
                        return -1;
                    //order by usage type..
                    else if (usage2.UsageType < usage1.UsageType)
                        return 1;
                    else if (usage2.UsageType > usage1.UsageType)
                        return -1;
                    //if begin and end dates are the same then check the kwh..
                    else if (usage2.TotalKwh < usage1.TotalKwh)
                        return -1;
                    else if (usage2.TotalKwh > usage1.TotalKwh)
                        return 1;
                }
            }
            return 0;
        }

        // ------------------------------------------------------------------------------------
        // -1 means usage2 < usage1; 1 means usage2 > usage1; 0 means usage2 = usage1
        /// <summary>
        /// Sort Usage
        /// </summary>
        /// <param name="usage1"></param>
        /// <param name="usage2"></param>
        /// <returns></returns>
        public static int SortUsageWithMultipleMeters(Usage usage1, Usage usage2)
        {
            int meter = string.Compare(usage2.MeterNumber, usage1.MeterNumber);

            //start off by comparing meter-numbers, then begin-dates..
            if (meter < 0)
                return -1;
            else if (meter > 0)
                return 1;
            else if (usage2.BeginDate < usage1.BeginDate)
                return -1;
            else if (usage2.BeginDate > usage1.BeginDate)
                return 1;
            else
            {
                //if they are equal then continue checking end dates..
                if (usage2.EndDate < usage1.EndDate)
                    return -1;
                else if (usage2.EndDate > usage1.EndDate)
                    return 1;
                else
                {
                    //order by usage source..
                    if (usage2.UsageSource < usage1.UsageSource)
                        return 1;
                    else if (usage2.UsageSource > usage1.UsageSource)
                        return -1;
                    //order by usage type..
                    else if (usage2.UsageType < usage1.UsageType)
                        return 1;
                    else if (usage2.UsageType > usage1.UsageType)
                        return -1;
                    //if begin and end dates are the same then check the kwh..
                    else if (usage2.TotalKwh < usage1.TotalKwh)
                        return -1;
                    else if (usage2.TotalKwh > usage1.TotalKwh)
                        return 1;
                }
            }
            return 0;
        }

        // ------------------------------------------------------------------------------------
        // -1 means usage2 < usage1; 1 means usage2 > usage1; 0 means usage2 = usage1
        /// <summary>
        /// Sort Usage
        /// </summary>
        /// <param name="usage1"></param>
        /// <param name="usage2"></param>
        /// <returns></returns>
        public static int SortUsageWithMultipleMetersEndDate(Usage usage1, Usage usage2)
        {
            int meter = string.Compare(usage2.MeterNumber, usage1.MeterNumber);

            //start off by comparing meter-numbers, then begin-dates..
            if (usage2.EndDate < usage1.EndDate)
                return -1;
            else if (usage2.EndDate > usage1.EndDate)
                return 1;
            if (usage2.BeginDate < usage1.BeginDate)
                return -1;
            else if (usage2.BeginDate > usage1.BeginDate)
                return 1;
            if (meter < 0)
                return -1;
            else if (meter > 0)
                return 1;

            else
            {
                //if they are equal then continue checking end dates..


                //order by usage source..
                if (usage2.UsageSource < usage1.UsageSource)
                    return 1;
                else if (usage2.UsageSource > usage1.UsageSource)
                    return -1;
                //order by usage type..
                else if (usage2.UsageType < usage1.UsageType)
                    return 1;
                else if (usage2.UsageType > usage1.UsageType)
                    return -1;
                //if begin and end dates are the same then check the kwh..
                else if (usage2.TotalKwh < usage1.TotalKwh)
                    return -1;
                else if (usage2.TotalKwh > usage1.TotalKwh)
                    return 1;

            }
            return 0;
        }


        // Feb 2016
        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Sorts meter reads depending on whether one account can have one or multiple meter reads..
        /// In descending order of begin dates,end dates,usagesource, usagetype and kwh
        /// 
        /// </summary>
        /// <param name="list"></param>
        /// <param name="listHasMultipleMeters"></param>
        /// <returns></returns>
        public static UsageList SortMeterReadsEndDate(UsageList list, bool listHasMultipleMeters)
        {
            if (listHasMultipleMeters == true)
                list.Sort(SortUsageWithMultipleMetersEndDate);
            else
                list.Sort(SortUsage);

            return list;
        }
        /// <summary>
        /// New sorting  for  Annula Usage Calculation ...PBI-86703
        /// </summary>
        /// <param name="list"></param>
        /// <param name="listHasMultipleMeters"></param>
        /// <returns></returns>
        public static UsageList SortMeterForAnuualUsage(UsageList list, bool listHasMultipleMeters)
        {
            if (listHasMultipleMeters == true)
                list.Sort(SortUsageForAnuualUsage);
            else
                list.Sort(SortUsage);

            return list;
        }
        // ------------------------------------------------------------------------------------
        // -1 means usage2 < usage1; 1 means usage2 > usage1; 0 means usage2 = usage1
        /// <summary>
        /// Sort Usage
        /// </summary>
        /// <param name="usage1"></param>
        /// <param name="usage2"></param>
        /// <returns></returns>
        public static int SortUsageForAnuualUsage(Usage usage1, Usage usage2)
        {
            int meter = string.Compare(usage2.MeterNumber, usage1.MeterNumber);

            //start off by comparing meter-numbers, then begin-dates..
            if (meter < 0)
                return -1;
            else if (meter > 0)
                return 1;
            else if (usage2.BeginDate < usage1.BeginDate)
                return -1;
            else if (usage2.BeginDate > usage1.BeginDate)
                return 1;
            else
            {
                //if they are equal then continue checking end dates..
                if (usage2.EndDate < usage1.EndDate)
                    return -1;
                else if (usage2.EndDate > usage1.EndDate)
                    return 1;
                else
                {
                    //order by usage source..
                    if (usage2.UsageSource < usage1.UsageSource)
                        return 1;
                    else if (usage2.UsageSource > usage1.UsageSource)
                        return -1;
                    //order by usage type..
                    else if (usage2.UsageType < usage1.UsageType)
                        return 1;
                    else if (usage2.UsageType > usage1.UsageType)
                        return -1;
                    //if begin and end dates are the same then check the kwh..
                    else if (usage2.TotalKwh < usage1.TotalKwh)
                        return -1;
                    else if (usage2.TotalKwh > usage1.TotalKwh)
                        return 1;
                }
            }
            return 0;
        }

        public static bool CompareUsageForQuantity(Usage oldUsage, Usage newUsage)
        {
            if (DateRangeFactory.IsSameDate(oldUsage.EndDate, newUsage.EndDate) && DateRangeFactory.IsSameDate(oldUsage.BeginDate, newUsage.BeginDate) && (oldUsage.MeterNumber == newUsage.MeterNumber))
                return true;
            else
                return false;
        }

        public static bool CompareUsageForCancelRebil(Usage oldUsage, Usage newUsage)
        {
            //Identify whether the new  Rebill record is for the Overlap date periods,
            if  
               ((oldUsage.EndDate < newUsage.EndDate && oldUsage.EndDate > newUsage.BeginDate) ||
               (oldUsage.BeginDate > newUsage.BeginDate && oldUsage.BeginDate < newUsage.EndDate) ||
               (newUsage.EndDate < oldUsage.EndDate && newUsage.EndDate > oldUsage.BeginDate) ||
               (newUsage.BeginDate > oldUsage.BeginDate && newUsage.BeginDate < oldUsage.EndDate))
                return true;
            else
                return false;
        }

        private static void UpdateQuantityFromEDI(UsageList consolidated, UsageList ediUsage, string userName)
        {
            consolidated.Sort(SortUsage);
            ediUsage.Sort(SortUsage);

            if (consolidated != null && consolidated.Count != 0)
            {
                if (ediUsage != null && ediUsage.Count != 0)
                {
                    foreach (Usage newU in ediUsage)
                    {
                        foreach (Usage oldU in consolidated)
                        {
                            if ((oldU.BeginDate >= newU.BeginDate) && (oldU.UsageType != UsageType.Canceled))
                            {
                                if (CompareUsageForQuantity(oldU, newU) && oldU.TotalKwh != newU.TotalKwh)
                                {
                                    oldU.TotalKwh = newU.TotalKwh;
                                    oldU.ReasonCode = ReasonCode.AggregatedKwhFromOverlaps;
                                    UsageFactory.UpdateUsageRecord(oldU);
                                }
                                else if (CompareUsageForCancelRebil(oldU, newU) && (oldU.MeterNumber == newU.MeterNumber))
                                {   //PBI-88374 If the RebillRecords are for overlaped periods,  cancel the old individual reads from consolidated
                                    oldU.IsActive = 0;
                                    oldU.UsageType = UsageType.Canceled;
                                    oldU.ReasonCode = ReasonCode.AggregatedKwhFromOverlaps;
                                    UsageFactory.UpdateUsageRecord(oldU);
                                }
                                else
                                    continue;
                            }
                            else
                            {
                                break;
                            }
                        }
                    }
                    RemoveCanceledConsolidated(consolidated);
                }
            }
        }
        public static void RemoveCanceledConsolidated(UsageList ConsolidatedUsage)
        {
            if (ConsolidatedUsage.Count == 0)
                return;
            Usage prev = ConsolidatedUsage[0];
            Usage next;
            List<int> indexesToRemove = new List<int>();
            for (int i = 1; i < ConsolidatedUsage.Count; i++)
            {
                next = ConsolidatedUsage[i];
                if (next.UsageType == UsageType.Canceled)
                {
                    indexesToRemove.Add(i);
                }
                prev = next;
            }

            indexesToRemove.Sort();
            for (int i = indexesToRemove.Count - 1; i >= 0; i--)
            {
                ConsolidatedUsage.RemoveAt(indexesToRemove[i]);
            }
        }


        public static UsageList SortMeterReadsforEdi(UsageList list, bool listHasMultipleMeters)
        {
            list.Sort(SortUsageForEDI);
            return list;
        }
        // ------------------------------------------------------------------------------------
        // -1 means usage2 < usage1; 1 means usage2 > usage1; 0 means usage2 = usage1
        /// <summary>
        /// Sort Usage
        /// </summary>
        /// <param name="usage1"></param>
        /// <param name="usage2"></param>
        /// <returns></returns>
        public static int SortUsageForEDI(Usage usage1, Usage usage2)
        {
            int meter = string.Compare(usage2.MeterNumber, usage1.MeterNumber);

            //start off by comparing meter-numbers, then begin-dates..
            if (meter < 0)
                return -1;
            else if (meter > 0)
                return 1;
            else if (usage2.BeginDate < usage1.BeginDate)
                return -1;
            else if (usage2.BeginDate > usage1.BeginDate)
                return 1;
            else
            {
                //if they are equal then continue checking end dates..
                if (usage2.EndDate < usage1.EndDate)
                    return -1;
                else if (usage2.EndDate > usage1.EndDate)
                    return 1;
                else
                {
                    //order by usage type..
                    if (usage2.UsageType > usage1.UsageType)
                        return 1;
                    else if (usage2.UsageType < usage1.UsageType)
                        return -1;
                    //order by usage source..
                    else if (usage2.UsageSource < usage1.UsageSource)
                        return 1;
                    else if (usage2.UsageSource > usage1.UsageSource)
                        return -1;
                    //if begin and end dates are the same then check the kwh..
                    else if (usage2.TotalKwh < usage1.TotalKwh)
                        return -1;
                    else if (usage2.TotalKwh > usage1.TotalKwh)
                        return 1;
                }
            }
            return 0;
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// For utilities that have multiple meters, update consolidated records with actual meter-numbers
        /// </summary>
        /// <param name="consolidated"></param>
        /// <param name="rawUsage"></param>
        /// <param name="userName"></param>
        /// <returns></returns>
        private static void UpdateMeterInformation(UsageList consolidated, UsageList rawUsage, string userName)
        {
            // assume consolidated usage does not have meter numbers..
            consolidated.Sort(SortUsage);
            rawUsage.Sort(SortUsage);

            if (consolidated != null && consolidated.Count != 0)
            {
                if (rawUsage != null && rawUsage.Count != 0)
                {
                    foreach (Usage newU in rawUsage)							//for each new meter read check if it already exists..
                    {
                        foreach (Usage oldU in consolidated)
                        {
                            if (oldU.BeginDate >= newU.BeginDate)
                            {
                                if (UsageFiller.CompareUsage(oldU, newU) && oldU.MeterNumber != newU.MeterNumber)
                                {
                                    //record already exists with difference in meter number..
                                    ///MTJ-Code -Do not overwrite if the Meter number is null
                                    if ((newU.MeterNumber != null) && (newU.MeterNumber.ToString().Length > 0))
                                    {
                                        oldU.UsageSource = newU.UsageSource;
                                        oldU.UsageType = newU.UsageType;
                                        oldU.MeterNumber = newU.MeterNumber;
                                        oldU.ReasonCode = ReasonCode.UpdatedMeterNumber;
                                        UsageFactory.UpdateUsageRecord(oldU);
                                        break;	//keep going..
                                    }
                                    else if ((oldU.MeterNumber != null) && (oldU.MeterNumber.ToString().Length > 0))
                                    {
                                        newU.MeterNumber = oldU.MeterNumber;
                                        newU.UsageSource = oldU.UsageSource;
                                        newU.UsageType = oldU.UsageType;
                                        newU.ReasonCode = oldU.ReasonCode;///Updating the meter number on memory so that one will eliminate as dup later
                                    }

                                }
                                else
                                    continue;									//keep going..
                            }
                            else
                            {
                                //since we are expecting a sorted list then i can assume that this record was not found..
                                break;											//next..
                            }
                        }
                    }
                }
            }
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// For utilities that have multiple meters, update edi records with scraped meter-numbers
        /// </summary>
        /// <param name="edi"></param>
        /// <param name="scraped"></param>
        private static void UpdateRawMeterInformation(UsageList edi, UsageList scraped)
        {
            if (edi != null && edi.Count != 0)
            {
                // assume edi usage does not have (correct) meter numbers..
                edi.Sort(SortUsage);

                if (scraped != null && scraped.Count != 0)
                {
                    scraped.Sort(SortUsage);

                    foreach (Usage goodU in scraped)							//for each new meter read check if it already exists..
                    {
                        foreach (Usage badU in edi)
                        {
                            if (badU.BeginDate >= goodU.BeginDate)
                            {
                                if (UsageFiller.CompareUsage(badU, goodU) && badU.MeterNumber != goodU.MeterNumber)
                                {
                                    //record already exists with difference in meter number..
                                    if ((goodU.MeterNumber != null) && (goodU.MeterNumber.ToString().Length > 0))
                                    {
                                        badU.MeterNumber = goodU.MeterNumber;
                                        badU.ReasonCode = ReasonCode.UpdatedMeterNumber;
                                        //break;										//keep going..
                                    }
                                    else if ((badU.MeterNumber != null) && (badU.MeterNumber.ToString().Length > 0))
                                    {
                                        goodU.MeterNumber = badU.MeterNumber;
                                        goodU.ReasonCode = badU.ReasonCode;///Updating the meter number on memory so that one will eliminate as dup later
                                    }
                                }
                                else
                                    continue;									//keep going..
                            }
                            else
                            {
                                //since we are expecting a sorted list then i can assume that this record was not found..
                                break;											//next..
                            }
                        }
                    }
                }
            }
        }

        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Converts a usage list to a usage dictionary.
        /// If dictionary already contains an item that is attempting to be added, item is ignored.
        /// </summary>
        /// <param name="list">Usage list</param>
        /// <returns>Returns a usage dictionary</returns>
        public static UsageDictionary ConvertUsageListToDictionary(UsageList list)
        {
            UsageDictionary dict = new UsageDictionary();

            foreach (Usage usage in list)
                if (!dict.ContainsKey(usage.BeginDate))
                    dict.Add(usage.BeginDate, usage);

            return dict;
        }

        /// <summary>
        /// Determines whether [has multiple meters] [the specified usage list].
        /// </summary>
        /// <param name="usageList">The usage list.</param>
        /// <returns>
        /// <c>true</c> if [has multiple meters] [the specified usage list]; otherwise, <c>false</c>.
        /// </returns>
        public static bool HasMultipleMeters(UsageList usageList)
        {
            if (usageList == null || usageList.Count < 2)
                return false;

            var meterNumbers = new List<string>();

            foreach (var item in usageList.Where(
                                    item => meterNumbers.Contains(item.MeterNumber) == false))
            {
                meterNumbers.Add(item.MeterNumber);
            }

            return meterNumbers.Count > 1;
        }

        /// <summary>
        /// Splits the multiple meters.
        /// </summary>
        /// <param name="usageList">The usage list.</param>
        /// <returns></returns>
        public static List<UsageList> SplitMultipleMeters(UsageList usageList)
        {
            var answer = new List<UsageList>();

            if (HasMultipleMeters(usageList) == false)
            {
                answer.Add(usageList);
            }
            else
            {
                var meterNumbers = new List<string>();

                foreach (var item in
                    usageList.Where(
                                        item => meterNumbers.Contains(item.MeterNumber.Trim()) == false)
                                    )
                {
                    meterNumbers.Add(item.MeterNumber.Trim());
                }

                foreach (var meterNumber in meterNumbers)
                {
                    var meterNumberBuf = meterNumber;
                    var subListItems = usageList.Where(item => string.Compare(item.MeterNumber, meterNumberBuf) == 0).ToList();
                    var subList = new UsageList();
                    subList.AddRange(subListItems);
                    answer.Add(subList);
                }
            }
            return answer;
        }

        /// <summary>
        /// Usages the list to time series.
        /// </summary>
        /// <param name="usageList">The usage list.</param>
        /// <returns></returns>
        public static TimeSeries UsageListToTimeSeries(UsageList usageList)
        {

            TimeSeries timeSeries = new TimeSeries("Usage", TimeSeriesInterval.Daily);

            foreach (var item in usageList)
            {
                TimeSeries timeSeriesBuffer = new TimeSeries("UsageBuffer", TimeSeriesInterval.Daily);
                int numberOfDays = (item.EndDate - item.BeginDate).Days;
                if (numberOfDays == 0)
                    numberOfDays = 1;
                decimal averageDailyUsage = item.TotalKwh / (decimal)numberOfDays;
                //DateTime normalizedBeginDate = new DateTime(item.BeginDate.Year, item.BeginDate.Month, 1);
                //DateTime normalizedEndDate = DateRangeFactory.FirstOfNextMonth(item.EndDate) - TimeSpan.FromDays(1);

                for (DateTime d = item.BeginDate; d < item.EndDate; d += TimeSpan.FromDays(1))
                {
                    timeSeriesBuffer.Add(d, averageDailyUsage);
                }

                timeSeries = TimeSeries.Aggregate(timeSeries, timeSeriesBuffer);

            }
            return timeSeries;
        }

        public static UsageList CalendarizeUsage(UsageList usageList)
        {

            var usageLists = UsageFactory.SplitMultipleMeters(usageList);

            var timeSeriesCollection = new List<TimeSeries>();

            foreach (var list in usageLists)
            {
                var timeSeries = UsageListToTimeSeries(list);

                timeSeriesCollection.Add(timeSeries);
            }
            //DateTime start = usageList[0].BeginDate;
            var calendarizedTimeSeries = TimeSeries.Aggregate(timeSeriesCollection);
            if (calendarizedTimeSeries.Count == 0)
                return new UsageList();
            DateTime start = calendarizedTimeSeries[0].Date;

            var monthlyCalendarizedUsage = TimeSeries.SampleDailyToMonthly(calendarizedTimeSeries);

            var calendarizedUsage = new UsageList();


            foreach (var item in monthlyCalendarizedUsage)
            {
                int year = item.Date.Year;
                int month = item.Date.Month;

                var usage = new Usage();

                usage.UtilityCode = usageList[0].UtilityCode;
                usage.AccountNumber = usageList[0].AccountNumber;
                //Change for IUM
                //usage.MeterNumber = "Multiple";
                usage.MeterNumber = usageList[0].MeterNumber;

                if (calendarizedUsage.Count == 0)
                {
                    int lastDayOfMonth = DateRangeFactory.CalendarDaysInMonth(year, month);
                    int startDay = start.Day > lastDayOfMonth ? lastDayOfMonth : start.Day;

                    usage.BeginDate = new DateTime(year, month, startDay);
                }
                else
                    usage.BeginDate = new DateTime(year, month, 1);

                usage.EndDate = new DateTime(year, month, item.Date.Day);
                usage.TotalKwh = Convert.ToInt32(item.ItemValue);
                usage.IsActive = 1;
                usage.IntermediateKwh = 0M;
                usage.OffPeakKwh = 0M;
                usage.OnPeakKwh = 0M;

                calendarizedUsage.Add(usage);
            }

            //Add back 1 day to last calendarized usage item to make presentation consistent
            var lastIndex = calendarizedUsage.Count - 1;

            if (lastIndex >= 0)
                calendarizedUsage[lastIndex].EndDate += TimeSpan.FromDays(1);

            //Store calendarized usage in the estimated usage table
            var indexedCalendarizedUsage = new UsageList();

            foreach (var item in calendarizedUsage)
            {
                item.UsageType = UsageType.Calendarized;
                Usage indexedUsage = InsertEstimatedUsageRecordIntoDatabase(item, UsageType.Calendarized, "CalendarizationProcess");
                indexedCalendarizedUsage.Add(indexedUsage);
            }

            return indexedCalendarizedUsage;
        }

        /// <summary>
        /// Gets the ending date of the most recent EDI usage, if any, for a specified account
        /// </summary>
        /// <param name="utilityCode"></param>
        /// <param name="accountNumber"></param>
        /// <returns></returns>
        public static DateTime? GetDateOfMostRecentEdiUsage(string utilityCode, string accountNumber)
        {
            DateTime? answer = null;
            var ds = UsageSql.GetEdiUsageMostRecentDate(utilityCode, accountNumber);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                answer = (DateTime?)ds.Tables[0].Rows[0]["EndDate"];
            }
            return answer;

        }

        /// <summary>
        /// Get the sum and count of all the historical metered reads per account, per year
        /// </summary>
        /// <param name="Utility">Utility code value</param>
        /// <param name="AccountTypeId"></param>
        /// <param name="isCustom">0= non custom deals, 1= custom deals</param>
        /// <param name="UsageTypeBilled">1= Billed Usage</param>
        /// <param name="UsageTypeHist">2= Historical Usage</param>
        /// <param name="Category">FIXED</param>
        /// <param name="UsageStartDate">min date of the usage we need to include in the proxy calculation</param>
        /// <param name="UsageEndDate">max date of the usage we need to include in the proxy calculation</param>
        /// <returns>ProxyUsage list object</returns>
        public static List<ProxyUsage> GetUsageByUtility(int UtilityID, int AccountTypeId,
            Int16 isCustom, int UsageTypeBilled, int UsageTypeHist, string Category, DateTime UsageStartDate, DateTime UsageEndDate)
        {
            DataSet ds = UsageSql.GetUsageByUtility(UtilityID, AccountTypeId, isCustom, UsageTypeBilled, UsageTypeHist, Category, UsageStartDate, UsageEndDate);

            List<ProxyUsage> pul = new List<ProxyUsage>();

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    pul.Add(new ProxyUsage
                    {
                        AccountNumber = dr["AccountNumber"].ToString(),
                        CountUsage = Int32.Parse(dr["CountUsage"].ToString()),
                        TotalKwh = Int32.Parse(dr["TotalKwh"].ToString())
                    });
                }
            }
            return pul;
        }



        // ------------------------------------------------------------------------------------
        /// <summary>
        /// Summarize the Current Idr Data
        /// </summary>
        /// <param name="list">accountNumber</param>
        /// /// <param name="list">utilityCode</param>
        /// <param name="list">From</param>
        /// /// <param name="list">To</param>
        /// <returns></returns>
        public static double GetIdrAnnualUsage(string accountNumber, string utilityCode, DateTime from, DateTime to, out bool isIdrResults)
        {
            double annualUsage = 0.00;
            isIdrResults = false;
            try
            {
                DataSet dsIdrResults = UsageSql.PerformSummarization(accountNumber, utilityCode, from, to);
                if (dsIdrResults != null && dsIdrResults.Tables.Count > 0)
                {
                    if (dsIdrResults.Tables[0].Rows.Count > 0)
                    {
                        annualUsage = (dsIdrResults.Tables[0].Rows.Count > 0) ? Convert.ToDouble(dsIdrResults.Tables[0].Rows[0]["AnnualUsage"]) : 0.00;
                        isIdrResults = (dsIdrResults.Tables[0].Rows.Count > 0) ? Convert.ToBoolean(dsIdrResults.Tables[0].Rows[0]["IsIdrResults"]) : false;
                    }
                    else
                    {
                        annualUsage = 0.00;
                        isIdrResults = false;
                    }
                }
                return annualUsage;
            }
            catch
            {
                return annualUsage;
                throw;
            }
        }


        public static DateTime GetIdrUsageDate(string accountNumber, string utilityCode, DateTime from, DateTime to)
        {
            DateTime IdrUsageDate = DateTime.MinValue;
            try
            {
                DataSet dsIdrResults = UsageSql.PerformSummarization(accountNumber, utilityCode, from, to);
                if (dsIdrResults != null && dsIdrResults.Tables.Count > 1)
                {
                    if (dsIdrResults.Tables[1].Rows.Count > 0)
                    {
                        IdrUsageDate = (dsIdrResults.Tables[1].Rows.Count > 0) ? Convert.ToDateTime(dsIdrResults.Tables[1].Rows[0]["SummarizeDate"]) : DateTime.MinValue;
                    }
                }
                if (IdrUsageDate == DateTime.MinValue)
                {
                    throw new Exception("UsageDate is Not Valid");
                }
                return IdrUsageDate;
            }
            catch
            {
                throw;
            }
        }




    }

}
