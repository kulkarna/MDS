using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using System.Data.Objects;
//using WMPLib;//windows media player
//using Microsoft.WindowsAPICodePack.Shell;

//using DAL = LibertyPower.DataAccess.SqlAccess.ProspectManagementSqlDal;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class TabletIncompleteContractFactory
    {
        /// <summary>
        /// Returns an unique incomplete contract number via the usp_get_key stored procedure.
        /// </summary>
        /// <param name="username">We should pass a valid username in the format domainname\username.</param>
        /// <returns>The generated unique contract number for incomplete contracts</returns>
        public static string GetNewIncompleteContractNumber(string username)
        {
            //DAL.ProspectManagementSqlDal.GenerateContractNumber(username);

            //const string ProcessId = "PRINT CONTRACTS"; // Different process ID's have different ways to generate an unique identifier
            const string ProcessId = "INCOMPLETECONTRACTS"; // Different process ID's have different ways to generate an unique identifier
            using (LpDealCaptureEntities entities = new LpDealCaptureEntities())
            {

                System.Data.Objects.ObjectParameter p_unickey = new System.Data.Objects.ObjectParameter("p_unickey", " ");
                var result = entities.usp_get_key(username, ProcessId, p_unickey, "Y");
                return result.ElementAt(0);
            }
        }

        /// <summary>
        /// Saves an incomplete  contract metadata into the database.
        /// Incomplete contracts are saved in a different table than complete ones.
        /// </summary>
        /// <param name="entity">The contract entity to save via EF</param>
        /// <param name="userId">ID of the user with permissions and that author the unfinished contract</param>
        public static void SaveIncompleteContractMetadata(TabletIncompleteContract entity, int userId)
        {
            var createdDate = entity.CreatedDate == DateTime.MinValue ? // If a creation date is omitted (is min date) we need to set one to avoid a required field exception
                DateTime.Now : entity.CreatedDate;

            using (LpDealCaptureEntities entities = new LpDealCaptureEntities())
            {
                entities.TabletIncompleteContracts.AddObject(new DataAccess.SqlAccess.CustomerManagementEF.TabletIncompleteContract
                {
                    ContractNumber = entity.ContractNumber,
                    SalesChannelID = entity.SalesChannelID,
                    AgentId = entity.AgentId,
                    CreatedDate = createdDate,
                    AdditionalNotes = entity.AdditionalNotes,
                    AccountNumber = entity.AccountNumber,
                    RetailMarketId = entity.RetailMarketId,
                    UtilityId = entity.UtilityId,
                    Zone = entity.Zone,
                    AccountTypeId = entity.AccountTypeId,
                    ProductBrandId = entity.ProductBrandId,
                    ContractStartDate = entity.ContractStartDate,
                    Term = entity.Term,
                    ServiceClassId = entity.ServiceClassId,
                    TierId = entity.TierId,
                    PriceId = entity.PriceId,
                    BACity = entity.BACity,
                    BAStreet = entity.BAStreet,
                    BAZip = entity.BAZip,
                    BCEmail = entity.BCEmail,
                    BCFax = entity.BCFax,
                    BCFirstName = entity.BCFirstName,
                    BCLastName = entity.BCLastName,
                    BCPhone = entity.BCPhone,
                    BCTitle = entity.BCTitle,
                    BAState = entity.BAState,
                    SACity = entity.SACity,
                    SAState = entity.SAState,
                    SAStreet = entity.SAStreet,
                    SAZip = entity.SAZip,
                    CISSN = entity.CISSN,
                    CIEmail = entity.CIEmail,
                    CIFax = entity.CIFax,
                    CIFirstName = entity.CIFirstName,
                    CILastName = entity.CILastName,
                    CIPhone = entity.CIPhone,
                    CITitle = entity.CITitle,
                    CACity = entity.CACity,
                    CAState = entity.CAState,
                    CAStreet = entity.CAStreet,
                    CASuite = entity.CASuite,
                    CAZip = entity.CAZip,
                    BusinessName = entity.BusinessName,
                    DBA = entity.DBA,
                    BusinessType = entity.BusinessType,
                    DUNS = entity.DUNS,
                    ContractTypeId = entity.ContractTypeId,
                    TaxId = entity.TaxId,
                    Language = entity.Language,
                    PromoCode = entity.PromoCode,
                    Origin = entity.Origin,
                    ClientSubmitApplicationKey = entity.ClientSubmitApplicationKey,
                    Review = entity.Review,
                    OutCome = entity.OutCome,
                    ModifiedBy = userId,
                    ModifiedDate = DateTime.Now
                });

                entities.SaveChanges();
            }
        }
        /// <summary>
        /// Gets all the matching incomplete contracts withe additional details.
        /// </summary>
        /// <param name="startDate"> contract startdate</param>
        /// <param name="endDate">contract end date</param>
        /// <param name="channelId">Sales channel ID</param>
        /// <param name="AgentId">Agent ID</param>
        /// <param name="reasonCode">Reason code for incomplete contract</param>
        /// <param name="isGasProduct">is this a Gas product </param>
        /// <param name="actionStep">action step</param>
        /// <param name="actionStep">Market ID</param>
        /// <param name="actionStep">Zip Code</param>
        /// <param name="actionStep">Minimum Audio Length</param>
        /// <param name="actionStep">Maximum Audio Length</param>
        /// <returns></returns>
        public static List<TabletIncompleteContractWithReasons> GetFilteredIncompleteContracts
            (DateTime? startDate, DateTime? endDate, int? channelId, int? AgentId, string reasonCode, bool? isGasProduct, int? actionStep, int? marketID,
            string zipCode, System.Int64? audioLengthMin, System.Int64? audioLengthMax)
        {

            List<TabletIncompleteContractWithReasons> retVal = new List<TabletIncompleteContractWithReasons>();

            using (LpDealCaptureEntities lpentities = new LpDealCaptureEntities())
            {
                int? actionStepToUse = actionStep == -2 ? (int?)null : actionStep;
                var groupedDetails
                    = lpentities.usp_GetFilteredIncompleteContractsWithAudio
                    (startDate, endDate, channelId, AgentId, actionStepToUse, marketID, zipCode, audioLengthMin, audioLengthMax).
                    GroupBy(item => item.TabletIncompleteContractID).ToList();


                groupedDetails.ForEach(item =>
                {
                    //Each item is a Tablet Incomplete Contract with the Cancellation details.
                    //Each item in this group will have same Incomplete contract Details.
                    var itemToConsider = item.FirstOrDefault();
                    if (itemToConsider != null)
                    {
                        retVal.Add(new TabletIncompleteContractWithReasons()
                        {
                            AccountNumber = itemToConsider.AccountNumber,
                            AccountTypeId = itemToConsider.AccountTypeId,
                            AdditionalNotes = itemToConsider.AdditionalNotes,
                            AgentId = itemToConsider.AgentId,
                            BACity = itemToConsider.BACity,
                            BAState = itemToConsider.BAState,
                            BAStreet = itemToConsider.BAStreet,
                            BAZip = itemToConsider.BAZip,
                            BCEmail = itemToConsider.BCEmail,
                            BCFax = itemToConsider.BCFax,
                            BCFirstName = itemToConsider.BCFirstName,
                            BCLastName = itemToConsider.BCLastName,
                            BCPhone = itemToConsider.BCPhone,
                            BCTitle = itemToConsider.BCTitle,
                            BusinessName = itemToConsider.BusinessName,
                            BusinessType = itemToConsider.BusinessType,
                            CACity = itemToConsider.CACity,
                            CAState = itemToConsider.CAState,
                            CAStreet = itemToConsider.CAStreet,
                            CASuite = itemToConsider.CASuite,
                            CAZip = itemToConsider.CAZip,
                            CIEmail = itemToConsider.CIEmail,
                            CIFax = itemToConsider.CIFax,
                            CIFirstName = itemToConsider.CIFirstName,
                            CILastName = itemToConsider.CILastName,
                            CIPhone = itemToConsider.CIPhone,
                            CISSN = itemToConsider.CISSN,
                            CITitle = itemToConsider.CITitle,
                            ClientSubmitApplicationKey = itemToConsider.ClientSubmitApplicationKey,
                            ContractNumber = itemToConsider.ContractNumber,
                            ContractStartDate = itemToConsider.ContractStartDate,
                            ContractTypeId = itemToConsider.ContractTypeId,
                            CreatedDate = itemToConsider.CreatedDate,
                            DBA = itemToConsider.DBA,
                            DUNS = itemToConsider.DUNS,
                            Language = itemToConsider.Language,
                            ModifiedBy = itemToConsider.ModifiedBy,
                            ModifiedDate = itemToConsider.ModifiedDate,
                            Origin = itemToConsider.Origin,
                            OutCome = itemToConsider.OutCome,
                            PriceId = itemToConsider.PriceId,
                            ProductBrandId = itemToConsider.ProductBrandId,
                            PromoCode = itemToConsider.PromoCode,
                            RetailMarketId = itemToConsider.RetailMarketId,
                            Review = itemToConsider.Review,
                            SACity = itemToConsider.SACity,
                            SalesChannelID = itemToConsider.SalesChannelID,
                            SAState = itemToConsider.SAState,
                            SAStreet = itemToConsider.SAStreet,
                            SAZip = itemToConsider.SAZip,
                            ServiceClassId = itemToConsider.ServiceClassId,
                            TabletIncompleteContractID = itemToConsider.TabletIncompleteContractID,
                            TaxId = itemToConsider.TaxId,
                            Term = itemToConsider.Term,
                            TierId = itemToConsider.TierId,
                            UtilityId = itemToConsider.UtilityId,
                            Zone = itemToConsider.Zone,
                            AudioFileName = itemToConsider.document_name,
                            AudiofilePath = itemToConsider.document_path,
                            AgentFirstName = itemToConsider.AgentFirstName,
                            AgentLastName = itemToConsider.AgentLastName,
                            ChannelName = itemToConsider.ChannelName,
                            MarketCode = itemToConsider.MarketCode,
                            IsGas = itemToConsider.IsGas.HasValue ? itemToConsider.IsGas.Value : false,
                            ProductName = itemToConsider.ProductBrandName,
                            CancellationReasons =
                            item.Select(incompleteItem => new CancelContractReason()
                            {
                                Code = incompleteItem.Code,
                                Description = incompleteItem.Description
                            }).ToList(),

                            AudioLength = itemToConsider.AudioLength

                        });
                    }


                });
                //apply reason code filter
                //ProductType G=1 , E=0
                if (reasonCode != null)
                {
                    retVal = retVal.Where(item => item.CancellationReasons.Any(reason => reason.Code == reasonCode)).ToList();

                }
                if (isGasProduct.HasValue)
                {
                    retVal = retVal.Where(item => item.IsGas == isGasProduct.Value).ToList();

                }
                if (actionStep == null)
                {
                    retVal = retVal.Where(item => !item.OutCome.HasValue).ToList();
                }
            }

            return retVal;
        }
        /// <summary>
        /// Gets all agents from the database 
        /// </summary>    /// <returns></returns>
        public static List<SalesAgent> GetAllSalesAgents()
        {
            using (LibertyPowerEntities lpentities = new LibertyPowerEntities())
            {

                return lpentities.SalesChannelUsers.Join
                    (lpentities.SalesChannels, x => x.ChannelID, y => y.ChannelID, (x, y) => new { SalesChannelUser = x, SalesChannel = y })
                    .Select(item => new SalesAgent()
                    {
                        AgentId = item.SalesChannelUser.UserID,
                        AgentFirstName = item.SalesChannelUser.User.Firstname,
                        AgentLastName = item.SalesChannelUser.User.Lastname,
                        UserName = item.SalesChannelUser.User.UserName
                    }).ToList();

            }
        }

        /// <summary>
        /// Gets all agents from the database for the channelID 
        /// </summary>
        /// <param name="channelID"> Channel ID </param>
        /// <returns></returns>
        public static List<SalesAgent> GetAllSalesAgentsByChannelID(int channelID)
        {
            using (LibertyPowerEntities lpentities = new LibertyPowerEntities())
            {
                return lpentities.SalesChannelUsers.Join
                    (lpentities.SalesChannels,
                    x => x.ChannelID,
                    y => y.ChannelID,
                    (x, y) => new { SalesChannelUser = x, SalesChannel = y })
                   .Where(c => c.SalesChannel.ChannelID == channelID)//filter by Channel ID;
                    .Select(item => new SalesAgent()
                    {
                        AgentId = item.SalesChannelUser.UserID,
                        AgentFirstName = item.SalesChannelUser.User.Firstname,
                        AgentLastName = item.SalesChannelUser.User.Lastname,
                        UserName = item.SalesChannelUser.User.UserName
                    }).ToList();


            }
        }

        /// <summary>
        /// Gets all active markets from the database 
        /// </summary>    
        /// <returns>List of active markets</returns>
        public static List<Market> GetAllActiveMarkets()
        {
            using (LibertyPowerEntities lpentities = new LibertyPowerEntities())
            {
                //filtering by inactive indicator to get active markets
                return lpentities.Markets.Where(m => m.InactiveInd == "0")
                     .Select(item => new Market()
                     {
                         MarketID = item.ID,
                         MarketCode = item.MarketCode,
                         RetailMarketDescription = item.RetailMktDescp
                     }).ToList();

            }
        }

        /// <summary>
        /// Updates the review details Action and the comments.
        /// The tuple contains RowID,Action and Comment
        /// </summary>
        /// <param name="reviewDetails"></param>
        /// <returns></returns>
        public static bool UpdateReviewDetails(List<Tuple<int, bool?, string>> reviewDetails)
        {
            bool retVal = false;
            using (LpDealCaptureEntities lpentities = new LpDealCaptureEntities())
            {
                reviewDetails.ForEach(review =>
                {
                    int tabletIncompleteContractID = review.Item1;
                    bool? outcome = review.Item2;
                    string reviewComments = review.Item3;
                    LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.TabletIncompleteContract itemToUpdate =
                        lpentities.TabletIncompleteContracts.FirstOrDefault(item => item.TabletIncompleteContractID == tabletIncompleteContractID);
                    if (itemToUpdate != null)
                    {
                        itemToUpdate.OutCome = outcome.HasValue ? outcome.Value : (bool?)null;
                        itemToUpdate.Review = reviewComments;
                    }
                });
                lpentities.SaveChanges();
                retVal = true;
            }
            return retVal;
        }

        #region Audio Length for incomplete contracts

        ///// Returns the Length of the audio file in timespan.
        ///// </summary>
        ///// <param name="filePath">full path of the file.</param>
        ///// <returns></returns>
        //public static TimeSpan? GetAudioFileLength(string filePath)
        //{
        //    TimeSpan? duration = null;

        //    try
        //    {
        //        if (!string.IsNullOrEmpty(filePath) && System.IO.File.Exists(filePath))
        //        {
        //            ShellFile sf = ShellFile.FromFilePath(filePath);
        //            if (sf.Properties.System.Media.Duration.Value.HasValue)
        //            {
        //                duration = TimeSpan.FromMilliseconds(sf.Properties.System.Media.Duration.Value.Value * 0.0001);
        //            }


        //            //another approach
        //            //WindowsMediaPlayer wmpPlayer = new WindowsMediaPlayer();
        //            //IWMPMedia mediaInfo = wmpPlayer.newMedia(audioFilePath);
        //            //return Convert.ToInt64(mediaInfo.duration);  //seconds


        //        }
        //    }
        //    catch
        //    {
        //        duration = null;
        //    }

        //    return duration;
        //}


        /// <summary>
        /// To GetIncompleteContract
        /// </summary>
        /// <param name="contractNumber">Incomplete contract number </param>
        /// <returns>TabletIncompleteContract EF object</returns>
        public static TabletIncompleteContract GetIncompleteContract(string contractNumber)
        {
            using (LpDealCaptureEntities lpEntities = new LpDealCaptureEntities())
            {

                return lpEntities.TabletIncompleteContracts
                          .Where(c => c.ContractNumber == contractNumber)
                          .Select(item => new TabletIncompleteContract()
                            {
                                AccountTypeId = item.AccountTypeId,
                                AccountNumber = item.AccountNumber,
                                AdditionalNotes = item.AdditionalNotes,
                                AgentId = item.AgentId,
                                AudioLength = item.AudioLength,
                                BACity = item.BACity,
                                BAState = item.BAState,
                                BAStreet = item.BAStreet,
                                BAZip = item.BAZip,
                                BCEmail = item.BCEmail,
                                BCFax = item.BCFax,
                                BCFirstName = item.BCFirstName,
                                BCLastName = item.BCLastName,
                                BCPhone = item.BCPhone,
                                BCTitle = item.BCTitle,
                                BusinessName = item.BusinessName,
                                BusinessType = item.BusinessType,
                                CACity = item.CACity,
                                CAState = item.CAState,
                                CAStreet = item.CAStreet,
                                CASuite = item.CASuite,
                                CAZip = item.CAZip,
                                CIEmail = item.CIEmail,
                                CIFax = item.CIFax,
                                CIFirstName = item.CIFirstName,
                                CILastName = item.CILastName,
                                CIPhone = item.CIPhone,
                                CISSN = item.CISSN,
                                CITitle = item.CITitle,
                                ClientSubmitApplicationKey = item.ClientSubmitApplicationKey,
                                ContractNumber = item.ContractNumber,
                                ContractStartDate = item.ContractStartDate,
                                ContractTypeId = item.ContractTypeId,
                                CreatedDate = item.CreatedDate,
                                DBA = item.DBA,
                                DUNS = item.DUNS,
                                Language = item.Language,
                                ModifiedBy = item.ModifiedBy,
                                ModifiedDate = item.ModifiedDate,
                                Origin = item.Origin,
                                OutCome = item.OutCome,
                                PriceId = item.PriceId,
                                ProductBrandId = item.ProductBrandId,
                                PromoCode = item.PromoCode,
                                RetailMarketId = item.RetailMarketId,
                                Review = item.Review,
                                SACity = item.SACity,
                                SalesChannelID = item.SalesChannelID,
                                SAState = item.SAState,
                                SAStreet = item.SAStreet,
                                SAZip = item.SAZip,
                                ServiceClassId = item.ServiceClassId,
                                TabletIncompleteContractID = item.TabletIncompleteContractID,
                                TaxId = item.TaxId,
                                Term = item.Term,
                                TierId = item.TierId,
                                UtilityId = item.UtilityId,
                                Zone = item.Zone
                            }).FirstOrDefault();
            }
        }


        /// <summary>
        /// To determine if Contract is incomplete
        /// </summary>
        /// <param name="contractNumber"> contract number</param>
        /// <returns> true if its incomplete contract</returns>
        public static bool isIncompleteContract(string contractNumber)
        {
            //if contract number exists in TabletIncompleteTable then its an Incomplete contract           
            try
            {

                using (LpDealCaptureEntities lpEntities = new LpDealCaptureEntities())
                {
                    if (lpEntities.TabletIncompleteContracts.Where(c => c.ContractNumber.ToUpper() == contractNumber.ToUpper()).ToList().Count > 0)
                        return true;
                    else
                        return false;

                }

            }
            catch (Exception ex)
            {
                return false;
            }


        }


        /// <summary>
        /// Gets audio length in seconds
        /// </summary>
        /// <param name="audioFilePath">full qualified path of Sales Audio File</param>
        /// <remarks> This methods calculate approximate duration based on the file size(* 0.638). 
        /// The other approaches requires desktop feature to be enabled on the server 
        /// </remarks>
        /// <returns>duration in seconds</returns>
        private static System.Int64? GetAudioLength(string audioFilePath)
        {
            Int64? duration = null;
            try
            {
                if (!string.IsNullOrEmpty(audioFilePath))
                {
                    if (System.IO.File.Exists(audioFilePath))
                    {
                        long fileSizeInBytes = new System.IO.FileInfo(audioFilePath).Length; //in bytes
                        float fileSizeInKB = fileSizeInBytes / 1024f;//in KB
                        duration = Convert.ToInt64(Math.Round(fileSizeInKB * 0.638));//duration in seconds


                    }
                }

            }
            catch{ }


            return duration;
        }


        /// <summary>
        /// Save Audio length of the sales audio file TabletIncompleteContract table
        /// </summary>
        /// <param name="contractNumber">Incomplete Contract Number</param>
        /// <returns>true if saved successfuly</returns>
        public static bool SaveAudioLengthForIncompleteContract(string contractNumber)
        {
            try
            {
                //get incomplete contract
                // TabletIncompleteContract contract = new TabletIncompleteContract();
                //contract = GetIncompleteContract(contractNumber);


                using (LpDealCaptureEntities lpEntities = new LpDealCaptureEntities())
                {
                    //get incomplete contract
                    LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.TabletIncompleteContract contract = lpEntities.TabletIncompleteContracts
                             .Where(c => c.ContractNumber == contractNumber)
                             .FirstOrDefault();


                    if (contract.TabletIncompleteContractID > 0)
                    {

                        //get Audio file
                        CommonBusiness.DocumentManager.Document tabletDoc = CommonBusiness.DocumentManager.DocumentManager.GetDocumentsByContractNumber(contractNumber)
                                                    .Where(item => item.DocumentTypeId == 60) //note: document type if for sales audio type is 60.            
                                                    .FirstOrDefault();//should have only one



                        if (!string.IsNullOrEmpty(tabletDoc.Path))
                        {
                            //Get audio length
                            System.Int64? audioLength = GetAudioLength(tabletDoc.Path);

                            //save audio length
                            if (audioLength != null)
                            {
                                //update audio length
                                contract.AudioLength = audioLength;


                                //save TabletIncompleteContracts Entity
                                lpEntities.SaveChanges();

                                return true;//saved successfully


                            }

                        }
                    }

                }

            }
            catch (Exception ex)
            {
                return false;


            }

            return false;

        }
        #endregion
    }

}
