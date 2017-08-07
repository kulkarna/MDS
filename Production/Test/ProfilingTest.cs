using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using LibertyPower.Business.CustomerAcquisition.Offers;
using CORE;
using DATA;
using LibertyPower.Business.CommonBusiness.CommonRules;
using LibertyPower.Business.CustomerAcquisition.Prospects;
using LibertyPower.Business.MarketManagement.UsageManagement;
using LibertyPower.Business.MarketManagement.UtilityManagement;
using VOHBMSQLSERVER;
using LibertyPower.DataAccess.WorkbookAccess;

namespace FrameworkTest
{
    [TestClass()]
    public class ProfilingTest
    {
        [TestMethod]
        public void CreateLoadFile()
        {
            var items = ProfileQueueFactory.RetrieveProfilingQueue();
            if (items != null && items.Count > 0)
            {
                var item = items.Where(s => s.Status == ProfileQueueStatus.Queued).OrderBy(id => id.ID).FirstOrDefault();
                if (item != null)
                {
                   ProfileQueueFactory.UpdateProfilingQueueStatus(item.ID, (int)ProfileQueueStatus.Running, "service");
                   CreateLoadFile(item);
                }
            }
        }

        private void CreateLoadFile(ProfileQueueItem profileQueueItem)
        {
            var offerHDAO = new OfferHDAO();


            var offerVo = offerHDAO.searchOffer(profileQueueItem.OfferID); //load specific offer here
            if (offerVo == null)
            {
                return;
            }

            // store in archive location until MatPrice is ready to use file(s)
            string filePath = string.Concat(@"c:\test\", profileQueueItem.OfferID); // String.Concat(ConfigurationManager.AppSettings["MAT_PRICE_HEDGE_BLOCK_ARCHIVE_PATH"], @"\",offerVO.OfferId);
            var offer = new Offer();
            var errorMessage = "";

            try
            {
                // get offer details
                offer = OfferFactory.GetOfferDetails(profileQueueItem.OfferID, "", false);
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("item with the same key"))
                {
                    profileQueueItem.ResultOutput += ex.Message + " Duplicate dates exist in usage upload; please create a new offer for this deal and add a mock account to allow you to re-upload the corrected historical usage.";
                    
                }
                else
                {
                    profileQueueItem.ResultOutput += ex.Message;
                   
                }

                //litResults.ForeColor = Color.Red;
                return;
            }

            // validate meter type (must be non-idr), load shape id exists, and zone exists
            string ValidationMessage = ValidateAccountDataForProfiling(profileQueueItem.OfferID);
            if (ValidationMessage.Length > 0)
            {
                profileQueueItem.ResultOutput += ValidationMessage;
                return;
            }

            // get any warning messages
            string warningMessages = GetWarningMessages(offer);
            if (warningMessages.Length > 0)
            {
                warningMessages = "<br/><font style=color:#FF0000>" + warningMessages + "</font><br/><br/>";
            }

            // create load file for MatPrice
            try
            {
                MatPriceFactory.CreateMonthlyUsageFiles(offer, filePath, offer.MarketCode);
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
            }

            InsertAggregates(offerVo);

            if (errorMessage.Length > 0)
            {
                profileQueueItem.ResultOutput = errorMessage + "<br/><br/>" + warningMessages;
            }
            else
            {
                var commonFacade = new CommonFacade();
                commonFacade.updateOfferStatus(profileQueueItem.OfferID, "Ready for Pricing");
                profileQueueItem.ResultOutput += warningMessages + "<br/>Forecast load successfully created.";
                
            }
        }

        private string GetWarningMessages(Offer offer)
        {
            var sb = new StringBuilder();

            var rule = new OfferNoWarningsRule(offer);
            if (!(rule.Validate()))
            {
                sb.Append("<br />");
                sb.Append(rule.Exception.Message);
                foreach (var ex in rule.Exception.DependentExceptions)
                {
                    sb.Append("<br /><br />");
                    sb.Append(ex.Message);
                }
            }

            return sb.ToString();
        }

        private void InsertAggregates(OfferVO offerVO)
        {
            var aggregatedICAPTCAPLossesList = new ArrayList();
            var commonFacade = new CommonFacade();
            var helper = new PricingHelper();
            aggregatedICAPTCAPLossesList = (ArrayList)helper.aggregateICAPTCAPLosses(offerVO);
            commonFacade.insertOfferAggregates(offerVO.OfferId, aggregatedICAPTCAPLossesList);
        }

        private string ValidateAccountDataForProfiling(string offerId)
        {
            var sb = new StringBuilder();

            UtilityAccountList accountList = ProspectAccountFactory.GetOfferAccountsWithMappedUsage(offerId);
            var rule = new ValidAccountsDataForProfilingRule(accountList);
            if (!(rule.Validate()))
            {
                foreach (var ex in rule.Exception.DependentExceptions)
                {
                    sb.Append("<br />");
                    sb.Append(ex.Message);
                }
            }

            return sb.ToString();
        }


    }
}
