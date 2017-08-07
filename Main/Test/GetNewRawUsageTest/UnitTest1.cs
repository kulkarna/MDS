using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.Business.MarketManagement.UsageManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace GetNewRawUsageTest
{
    [TestClass]
    public class UnitTest1
    {

        UsageList _usageListDatabase = new UsageList();
        UsageList _usageListNew = new UsageList();

        private void GetUsageListsFromFile()
        {
            string databaseUsageFilePath = ConfigurationManager.AppSettings["DatabaseUsageFilePath"];
            string newUsageFilePath = ConfigurationManager.AppSettings["NewUsageFilePath"];
            _usageListDatabase = GetFromFile(databaseUsageFilePath);
            _usageListNew = GetFromFile(newUsageFilePath);
        }

        private int ParseInt(string value)
        {
            int result = 0;
            int.TryParse(value, out result);
            return result;
        }

        private DateTime ParseDateTime(string value)
        {
            DateTime result = DateTime.MinValue;
            DateTime.TryParse(value, out result);
            return result;
        }

        private decimal? ParseDecimal(string value)
        {
            decimal? result = null;
            decimal newResult = 0M;
            decimal.TryParse(value, out newResult);
            result = newResult;
            return result;
        }

        private bool ParseBool(string value)
        {
            bool result = false;
            bool.TryParse(value, out result);
            return result;
        }

        private ReasonCode ParseReasonCode(string value)
        { 
            switch (value)
            {
            	case "AggregatedKwhFromOverlaps":
                    return ReasonCode.AggregatedKwhFromOverlaps;
            		break;
            	case "BeginDateEqualEndDate":
                    return ReasonCode.BeginDateEqualEndDate;
            		break;
            	case "ConflictInUsage":
                    return ReasonCode.ConflictInUsage;
            		break;
            	case "EndDateGreaterThanPreviousBegin":
            		return ReasonCode.EndDateGreaterThanPreviousBegin;
            		break;
            	case "EndDateLessThanBeginDate":
            		return ReasonCode.EndDateLessThanBeginDate;
            		break;
            	case "ExceptionBetweenDifferentMeterReads":
                    return ReasonCode.ExceptionBetweenDifferentMeterReads;
            		break;
            	case "HierarchicalConflictAfterInitialLoad":
                    return ReasonCode.HierarchicalConflictAfterInitialLoad;
            		break;
            	case "HierarchicalConflictBetweenDifferentSources":
                    return ReasonCode.HierarchicalConflictBetweenDifferentSources;
            		break;
            	case "InitialLoad":
                    return ReasonCode.InitialLoad;
            		break;
            	case "InsertedFromFramework":
                    return ReasonCode.InsertedFromFramework;
            		break;
            	case "NegativeUsage":
            		return ReasonCode.NegativeUsage;
            		break;
            	case "ReceivedCancel":
            		return ReasonCode.ReceivedCancel;
            		break;
            	case "ReceivedEdiFile":
                    return ReasonCode.ReceivedEdiFile;
            		break;
            	case "SameBeginBetweenDifferentMeterReads":
            		return ReasonCode.SameBeginBetweenDifferentMeterReads;
            		break;
            	case "SameEndBetweenDifferentMeterReads":
            		return ReasonCode.SameEndBetweenDifferentMeterReads;
            		break;
            	case "UpdatedAccountNumberFromEdi":
            		return ReasonCode.UpdatedAccountNumberFromEdi;
            		break;
            	case "UpdatedMeterNumber":
            		return ReasonCode.UpdatedMeterNumber;
            		break;
            	case "UpdatedSourceTypeFromRaw":
            		return ReasonCode.UpdatedSourceTypeFromRaw;
            		break;
            }
            return ReasonCode.ReceivedEdiFile;
        }

        private UsageSource ParseUsageSource(string usageSource)
        {
            switch (usageSource)
            {
                case "AccountBilling":
                    return UsageSource.AccountBilling;
                case "Edi":
                    return UsageSource.Edi;
                case "Ista":
                    return UsageSource.Ista;
                case "ProspectAccountBilling":
                    return UsageSource.ProspectAccountBilling;
                case "Scraper":
                    return UsageSource.Scraper;
                case "User":
                    return UsageSource.User;
                case "WebBilling":
                    return UsageSource.WebBilling;
            }
            return UsageSource.Edi;
        }

        private UsageType ParseUsageType(string usageType)
        {
            switch (usageType)
            {
                case "Billed":
                    return UsageType.Billed;
                case "Calendarized":
                    return UsageType.Calendarized;
                case "Canceled":
                    return UsageType.Canceled;
                case "Estimated":
                    return UsageType.Estimated;
                case "File":
                    return UsageType.File;
                case "Historical":
                    return UsageType.Historical;
                case "Manual":
                    return UsageType.Manual;
                case "Profiled":
                    return UsageType.Profiled;
                case "UtilityEstimate":
                    return UsageType.UtilityEstimate;
            }
            return UsageType.Estimated; 
        }




        private UsageList GetFromFile(string filePath)
        {
            StreamReader sr = new StreamReader(filePath);
            string fileContents = sr.ReadToEnd();
            string[] separator = new string[1];
            separator[0] = "\r\n";
            string[] fileLines = fileContents.Split(separator, StringSplitOptions.RemoveEmptyEntries);
            bool isFirstTime = true;
            UsageList usageList = new UsageList();

            foreach (string line in fileLines)
            {
                if (!isFirstTime)
                { 
                    string[] values = line.Split(',');
                    int days = 0;
                    int.TryParse(values[1], out days);
                    Usage usage = new Usage()
                    {
                        AccountNumber = values[0],
                        BeginDate = ParseDateTime(values[1]),
                        BillingDemandKw = ParseDecimal(values[2]),
                        CreatedBy = values[3],
                        DateCreated = ParseDateTime(values[4]),
                        DateModified = ParseDateTime(values[5]),
                        Days = ParseInt(values[6]),
                        EndDate = ParseDateTime(values[7]),
                        ID = ParseInt(values[8]),
                        IntermediateKwh = ParseDecimal(values[9]),
                        IsActive = (short)ParseInt(values[10]),
                        IsConsolidated = ParseBool(values[11]),
                        ISO = values[12],
                        MeterNumber = values[13],
                        ModifiedBy = values[14],
                        MonthlyOffPeakDemandKw = ParseDecimal(values[15]),
                        MonthlyPeakDemandKw = ParseDecimal(values[16]),
                        OffPeakKwh = ParseDecimal(values[17]),
                        OnPeakKwh = ParseDecimal(values[18]),
                        ReasonCode = ParseReasonCode(values[19]),
                        TotalKwh = ParseInt(values[20]),
                        UsageSource = ParseUsageSource(values[21]),
                        UsageType = ParseUsageType(values[22]),
                        UtilityCode = values[23]
                    };
                    usageList.Add(usage);
                }
                isFirstTime = false;
            }

            return usageList;
        }


        private Usage GenerateUsage(string accountNumber, DateTime beginDate, decimal? billingDemandKw,
                string createdBy, DateTime dateCreated, DateTime dateModified, int days, DateTime endDate,
                long iD, decimal? intermediateKwh, short isActive, bool isConsolidated, string iSO, string meterNumber,
                string modifiedBy, decimal? monthlyOffPeakDemandKw, decimal? monthlyPeakDemandKw, decimal? offPeakKwh,
                decimal? onPeakKwh, ReasonCode reasonCode, int totalKwh, UsageSource usageSource,
                UsageType usageType, string utilityCode)
        {
            return new Usage()
            {
                AccountNumber = accountNumber,
                BeginDate = beginDate,
                BillingDemandKw = billingDemandKw,
                CreatedBy = createdBy,
                DateCreated = dateCreated,
                DateModified = dateModified,
                Days = days,
                EndDate = endDate,
                ID = iD,
                IntermediateKwh = intermediateKwh,
                IsActive = isActive,
                IsConsolidated = isConsolidated,
                ISO = iSO,
                MeterNumber = meterNumber,
                ModifiedBy = modifiedBy,
                MonthlyOffPeakDemandKw = monthlyOffPeakDemandKw,
                MonthlyPeakDemandKw = monthlyPeakDemandKw,
                OffPeakKwh = offPeakKwh,
                OnPeakKwh = onPeakKwh,
                ReasonCode = reasonCode,
                TotalKwh = totalKwh,
                UsageSource = usageSource,
                UsageType = usageType,
                UtilityCode = utilityCode
            };
        }

        private Usage GenerateUsage1_1()
        {
            return GenerateUsage(
                "12345",
                new DateTime(2015, 1, 1),
                1001,
                "test",
                new DateTime(2015, 1, 1),
                new DateTime(2015, 1, 1),
                30,
                new DateTime(2015, 2, 1),
                11234,
                1001,
                1,
                true,
                "NYISO",
                "Meter1",
                "test",
                1001,
                1001,
                1001,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
            }

        private Usage GenerateUsage1_2()
        {
            return GenerateUsage(
                "12345",
                new DateTime(2015, 2, 1),
                1001,
                "test",
                new DateTime(2015, 2, 1),
                new DateTime(2015, 2, 1),
                30,
                new DateTime(2015, 3, 1),
                11234,
                1001,
                1,
                true,
                "NYISO",
                "Meter1",
                "test",
                1001,
                1001,
                1001,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }

        private Usage GenerateUsage1_3()
        {
            return GenerateUsage(
                "12345",
                new DateTime(2015, 3, 1),
                1001,
                "test",
                new DateTime(2015, 3, 1),
                new DateTime(2015, 3, 1),
                30,
                new DateTime(2015, 4, 1),
                11234,
                1001,
                1,
                true,
                "NYISO",
                "Meter1",
                "test",
                1001,
                1001,
                1001,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }

        private Usage GenerateUsage1_4()
        {
            return GenerateUsage(
                "12345",
                new DateTime(2015, 4, 1),
                1001,
                "test",
                new DateTime(2015, 4, 1),
                new DateTime(2015, 4, 1),
                30,
                new DateTime(2015, 5, 1),
                11234,
                1001,
                1,
                true,
                "NYISO",
                "Meter1",
                "test",
                1001,
                1001,
                1001,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }

        private Usage GenerateUsage1_5()
        {
            return GenerateUsage(
                "12345",
                new DateTime(2015, 5, 1),
                1001,
                "test",
                new DateTime(2015, 5, 1),
                new DateTime(2015, 5, 1),
                30,
                new DateTime(2015, 6, 1),
                11234,
                1001,
                1,
                true,
                "NYISO",
                "Meter1",
                "test",
                1001,
                1001,
                1001,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1001,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }

        private Usage GenerateUsage2()
        {
            return GenerateUsage(
                "123456",
                new DateTime(2015, 8, 1),
                1000,
                "test",
                new DateTime(2015, 8, 1),
                new DateTime(2015, 8, 1),
                30,
                new DateTime(2015, 9, 1),
                112345,
                1000,
                1,
                true,
                "NYISO",
                "Meter2",
                "test",
                1000,
                1000,
                1000,
                1000,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1000,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }


        private Usage GenerateUsage3()
        {
            return GenerateUsage(
                "1234536",
                new DateTime(2015, 7, 1),
                1002,
                "test",
                new DateTime(2015, 7, 1),
                new DateTime(2015, 7, 1),
                30,
                new DateTime(2015, 8, 1),
                1123454,
                1002,
                1,
                true,
                "NYISO",
                "Meter3",
                "test",
                1002,
                1002,
                1002,
                1002,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1002,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }


        private Usage GenerateUsage4()
        {
            return GenerateUsage(
                "1234536",
                new DateTime(2015, 7, 1),
                1003,
                "test",
                new DateTime(2015, 7, 1),
                new DateTime(2015, 7, 1),
                30,
                new DateTime(2015, 8, 1),
                1123454,
                1003,
                1,
                true,
                "NYISO",
                "Meter4",
                "test",
                1003,
                1003,
                1003,
                1003,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1003,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }


        private Usage GenerateUsage5_1()
        {
            return GenerateUsage(
                "1234536",
                new DateTime(2015, 1, 1),
                1004,
                "test",
                new DateTime(2015, 1, 1),
                new DateTime(2015, 1, 1),
                30,
                new DateTime(2015, 2, 1),
                1123454,
                1004,
                1,
                false,
                "NYISO",
                "",
                "test",
                1004,
                1004,
                1004,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }


        private Usage GenerateUsage5_2()
        {
            return GenerateUsage(
                "1234536",
                new DateTime(2015, 2, 1),
                1004,
                "test",
                new DateTime(2015, 2, 1),
                new DateTime(2015, 2, 1),
                30,
                new DateTime(2015, 3, 1),
                1123454,
                1004,
                1,
                false,
                "NYISO",
                "",
                "test",
                1004,
                1004,
                1004,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }


        private Usage GenerateUsage5_3()
        {
            return GenerateUsage(
                "1234536",
                new DateTime(2015, 3, 1),
                1004,
                "test",
                new DateTime(2015, 3, 1),
                new DateTime(2015, 3, 1),
                30,
                new DateTime(2015, 4, 1),
                1123454,
                1004,
                1,
                false,
                "NYISO",
                "",
                "test",
                1004,
                1004,
                1004,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }


        private Usage GenerateUsage5_4()
        {
            return GenerateUsage(
                "1234536",
                new DateTime(2015, 4, 1),
                1004,
                "test",
                new DateTime(2015, 4, 1),
                new DateTime(2015, 4, 1),
                30,
                new DateTime(2015, 5, 1),
                1123454,
                1004,
                1,
                false,
                "NYISO",
                "",
                "test",
                1004,
                1004,
                1004,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }


        private Usage GenerateUsage5_5()
        {
            return GenerateUsage(
                "1234536",
                new DateTime(2015, 5, 1),
                1004,
                "test",
                new DateTime(2015, 5, 1),
                new DateTime(2015, 5, 1),
                30,
                new DateTime(2015, 6, 1),
                1123454,
                1004,
                1,
                false,
                "NYISO",
                "",
                "test",
                1004,
                1004,
                1004,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.ReasonCode.AggregatedKwhFromOverlaps,
                1004,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageSource.Edi,
                LibertyPower.Business.MarketManagement.UtilityManagement.UsageType.Historical,
                "ACE");
        }

        [TestMethod]
        public void TestMethodFiles()
        {
            GetUsageListsFromFile();
            UsageList result = UsageFiller.GetNewRawUsage(_usageListDatabase, _usageListNew);
            UsageList resultAdd = UsageFiller.AddLists(_usageListDatabase, result);
            double value = UsageFiller.ComputeAnnualUsage(resultAdd, true);
            UsageList sort = UsageFactory.SortMeterForAnuualUsage(resultAdd, true);
            var mathResult = UsageFiller.DoTheMath(resultAdd);
            string s = string.Empty;

        }

        [TestMethod]
        public void TestMethod1()
        {

            UsageList usageList = new UsageList();
            Usage usage1_1 = GenerateUsage1_1();
            usageList.Add(usage1_1);
            Usage usage1_2 = GenerateUsage1_2();
            usageList.Add(usage1_2);
            Usage usage1_3 = GenerateUsage1_3();
            usageList.Add(usage1_3);
            Usage usage1_4 = GenerateUsage1_4();
            usageList.Add(usage1_4);
            Usage usage1_5 = GenerateUsage1_5();
            usageList.Add(usage1_5);
            Usage usage2 = GenerateUsage2();
            usageList.Add(usage2);
            //Usage usage3 = GenerateUsage3();
            //usageList.Add(usage3);
            //Usage usage4 = GenerateUsage4();
            //usageList.Add(usage4);
            //Usage usage4 = GenerateUsage5();
            //usageList.Add(usage5);

            UsageList usageListNew = new UsageList();
            //Usage usageNew = GenerateUsage1();
            //usageListNew.Add(usageNew);
            //Usage usageNew2 = GenerateUsage2();
            //usageListNew.Add(usageNew2);
            Usage usageNew3 = GenerateUsage3();
            usageListNew.Add(usageNew3);
            Usage usage4 = GenerateUsage4();
            usageListNew.Add(usage4);
            Usage usage5_1 = GenerateUsage5_1();
            usageListNew.Add(usage5_1);
            Usage usage5_2 = GenerateUsage5_2();
            usageListNew.Add(usage5_2);
            Usage usage5_3 = GenerateUsage5_3();
            usageListNew.Add(usage5_3);
            Usage usage5_4 = GenerateUsage5_4();
            usageListNew.Add(usage5_4);
            Usage usage5_5 = GenerateUsage5_5();
            usageListNew.Add(usage5_5);
            UsageList result = UsageFiller.GetNewRawUsage(usageList, usageListNew);
            UsageList resultAdd = UsageFiller.AddLists(usageList, result);
            double value = UsageFiller.ComputeAnnualUsage(resultAdd, true);
            UsageList sort = UsageFactory.SortMeterForAnuualUsage(resultAdd, true);
            var mathResult = UsageFiller.DoTheMath(resultAdd);
            string s = string.Empty;

        }
    }
}
