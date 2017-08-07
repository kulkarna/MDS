using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;

namespace LibertyPower.DataAccess.SqlAccess.LibertyPowerSql
{
    public static class OpportunitySql
    {
        public static DataSet InsertUploadFile(int opportunityID, Guid fileGuid, bool fileAccepted)
        {

            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandText = "usp_MarketParsingUploadInsert";
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.Add(new SqlParameter("OpportunityID", opportunityID));
                    command.Parameters.Add(new SqlParameter("FileGuid", fileGuid));
                    command.Parameters.Add(new SqlParameter("Accepted", fileAccepted));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        DataSet ds = new DataSet();
                        int nRows = da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public static DataSet SelectUploadFiles(int opportunityID)
        {

            string connStr = Helper.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandText = "usp_MarketParsingUploadsSelectByOpportunityID";
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.Add(new SqlParameter("OpportunityID", opportunityID));


                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        DataSet ds = new DataSet();
                        int nRows = da.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public static DataSet InsertOpportunity(int agentID, int channelID, int prospectCustomerID, string opportunityName, DateTime requestedFlowStartDate,
            string status, string state, decimal customersTargetPrice, decimal feeDollarsPerKwH, int numberOfPremises, bool taxExempt,
            decimal totalEstimatedAnnualUsageKwH, string comments, int createdBy)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_OpportunityInsert";

                    command.Parameters.Add(new SqlParameter("AgentID", agentID));
                    command.Parameters.Add(new SqlParameter("ChannelID", channelID));
                    command.Parameters.Add(new SqlParameter("ProspectCustomerID", prospectCustomerID));
                    command.Parameters.Add(new SqlParameter("OpportunityName", opportunityName));
                    command.Parameters.Add(new SqlParameter("RequestedFlowStartDate", requestedFlowStartDate));
                    command.Parameters.Add(new SqlParameter("Status", status));
                    command.Parameters.Add(new SqlParameter("State", state));
                    command.Parameters.Add(new SqlParameter("CustomersTargetPricePerKwh", customersTargetPrice));
                    command.Parameters.Add(new SqlParameter("FeeDollarsPerKwH", feeDollarsPerKwH));
                    command.Parameters.Add(new SqlParameter("NumberOfPremises", numberOfPremises));
                    command.Parameters.Add(new SqlParameter("TaxExempt", taxExempt));
                    command.Parameters.Add(new SqlParameter("TotalEstimatedAnnualUsageKwH", totalEstimatedAnnualUsageKwH));
                    command.Parameters.Add(new SqlParameter("Comments", comments));
                    command.Parameters.Add(new SqlParameter("CreatedBy", createdBy));


                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }

            return ds;

        }


        public static DataSet UpdateOpportunityStatus(int opportunityID, string status)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_OpportunityUpdateStatus";
                    command.Parameters.Add(new SqlParameter("@OpportunityID", opportunityID));
                    command.Parameters.Add(new SqlParameter("@Status", status));


                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        
        public static DataSet UpdateOpportunity(int opportunityID, int agentID, int prospectCustomerID, string opportunityName, DateTime requestedFlowStartDate,
            string status, string state, decimal customersTargetPrice, decimal feeDollarsPerKwH, int numberOfPremises, bool taxExempt,
            decimal totalEstimatedAnnualUsageKwH, string comments, int modifiedBy)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_OpportunityUpdate";

                    command.Parameters.Add(new SqlParameter("ID", opportunityID));
                    command.Parameters.Add(new SqlParameter("AgentID", agentID));
                    command.Parameters.Add(new SqlParameter("ProspectCustomerID", prospectCustomerID));
                    command.Parameters.Add(new SqlParameter("OpportunityName", opportunityName));
                    command.Parameters.Add(new SqlParameter("RequestedFlowStartDate", requestedFlowStartDate));
                    command.Parameters.Add(new SqlParameter("Status", status));
                    command.Parameters.Add(new SqlParameter("State", state));
                    command.Parameters.Add(new SqlParameter("CustomersTargetPricePerKwH", customersTargetPrice));
                    command.Parameters.Add(new SqlParameter("FeeDollarsPerKwH", feeDollarsPerKwH));
                    command.Parameters.Add(new SqlParameter("NumberOfPremises", numberOfPremises));
                    command.Parameters.Add(new SqlParameter("TaxExempt", taxExempt));
                    command.Parameters.Add(new SqlParameter("TotalEstimatedAnnualUsageKwH", totalEstimatedAnnualUsageKwH));
                    command.Parameters.Add(new SqlParameter("Comments", comments));
                    command.Parameters.Add(new SqlParameter("ModifiedBy", modifiedBy));


                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }

            return ds;

        }

        public static DataSet SelectOpportunity(int opportunityID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_OpportunitySelect";

                    command.Parameters.Add(new SqlParameter("OpportunityID", opportunityID));


                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet SelectOpportunityByAgent(int agentID, int prospectCustomerID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_OpportunityByAgentID";

                    command.Parameters.Add(new SqlParameter("AgentID", agentID));
                    command.Parameters.Add(new SqlParameter("ProspectCustomerID", prospectCustomerID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet SelectOpportunityByAgent(int agentID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_OpportunityByAgentIDAllProspects";

                    command.Parameters.Add(new SqlParameter("AgentID", agentID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet SelectOpportunityByChannel(int channelID, int prospectCustomerID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_OpportunityByChannelID";

                    command.Parameters.Add(new SqlParameter("ChannelID", channelID));
                    command.Parameters.Add(new SqlParameter("ProspectCustomerID", prospectCustomerID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet SelectOpportunityByChannel(int channelID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_OpportunityByChannelIDAllProspects";

                    command.Parameters.Add(new SqlParameter("ChannelID", channelID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }


        public static DataSet SelectPricingRequestCandidate(int ID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateSelect";

                    command.Parameters.Add(new SqlParameter("ID", ID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet SelectPricingRequestCandidates()
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateSelectAll";

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet SelectPricingRequestCandidateByAgent(int agentID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateSelectByAgent";

                    command.Parameters.Add(new SqlParameter("OwnerAgentID", agentID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet SelectPricingRequestCandidateByChannel(int channelID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateSelectByChannel";

                    command.Parameters.Add(new SqlParameter("OwnerChannelID", channelID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet SelectPricingRequestCandidateAccounts(int ID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateAccountSelect";

                    command.Parameters.Add(new SqlParameter("ID", ID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;

        }

        public static DataSet SelectPricingRequestCandidateTerms(int ID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateTermSelect";

                    command.Parameters.Add(new SqlParameter("ID", ID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet SelectPricingRequestCandidateProducts(int ID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateProductSelect";

                    command.Parameters.Add(new SqlParameter("ID", ID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        public static DataSet SelectPricingRequestCandidateFlowDates(int ID)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateFlowDateSelect";

                    command.Parameters.Add(new SqlParameter("ID", ID));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }
        public static DataSet GetPricingRequestCandidateHistory(int pricingRequestRootID)
        {

            string SQL = "usp_PriceRequestCandidateHistoryGet";
            string cnnString = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@RootRequestID", pricingRequestRootID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }

            return ds;


        }



        public static DataSet GetPricingRequestCandidateHistoryByRefreshID(int pricingRequestRootID, int refreshID)
        {

            string SQL = "usp_PriceRequestCandidateHistoryByRefreshID";
            string cnnString = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@RootRequestID", pricingRequestRootID);
                SqlParameter p2 = new SqlParameter("@RefreshID", refreshID);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet GetPricingRequestCandidateHistoryList(int pricingRequestRootID)
        {

            string SQL = "usp_PriceRequestCandidateHistoryGetList";
            string cnnString = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@RootRequestID", pricingRequestRootID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }

            return ds;


        }

        public static DataSet GetChannelByPricingRequestID(string PricingRequestID)
        {

            string SQL = "usp_PriceRequestCandidateHistoryGetByRequest";
            string cnnString = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@RequestID", PricingRequestID);

                da.SelectCommand.Parameters.Add(p1);

                da.Fill(ds);
            }

            return ds;


        }

        public static DataSet GetPricingRequestCandidateOfferHistory(int rootRequestID, int refreshID)
        {

            string SQL = "usp_PriceRequestCandidateOfferHistoryGet";
            string cnnString = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@rootRequestID", rootRequestID);
                SqlParameter p2 = new SqlParameter("@refreshID", refreshID);
                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);

                da.Fill(ds);
            }

            return ds;


        }

        public static DataSet InsertPricingRequestCandidateOfferHistory(int requestHistoryID, string offerID,
                                                               int refreshID, int rootRequestID, int offerIDNumber)
        {

            string SQL = "usp_PriceRequestCandidateOfferHistoryInsert";
            string cnnString = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@requestHistoryID", requestHistoryID);
                SqlParameter p2 = new SqlParameter("@offerID", offerID);
                SqlParameter p3 = new SqlParameter("@RefreshID", refreshID);
                SqlParameter p4 = new SqlParameter("@RootRequestID", rootRequestID);
                SqlParameter p5 = new SqlParameter("@OfferIDNumber", offerIDNumber);


                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);
                da.SelectCommand.Parameters.Add(p5);
                da.Fill(ds);
            }

            return ds;


        }




        public static DataSet InsertPricingRequestCandidateHistory(int pricingRequestRootID,
                                int CreatedBy, decimal Commission, int refreshID)
        {

            string SQL = "usp_PriceRequestCandidateHistoryInsert";
            string cnnString = Helper.ConnectionString;
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@RootRequestID", pricingRequestRootID);
                SqlParameter p2 = new SqlParameter("@Commission", Commission);
                SqlParameter p3 = new SqlParameter("@CreatedBy", CreatedBy);
                SqlParameter p4 = new SqlParameter("@RefreshID", refreshID);


                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.SelectCommand.Parameters.Add(p3);
                da.SelectCommand.Parameters.Add(p4);


                da.Fill(ds);
            }

            return ds;


        }

        public static DataSet PricingRequestCandidateHistoryGetStatus(string pricingRequestCandidateID)
        {
            string SQL = "usp_offer_status_GetByRequestID";
            string cnnString = ConfigurationManager.ConnectionStrings["OfferEngine"].ConnectionString;

            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@Request_ID", pricingRequestCandidateID);
                da.SelectCommand.Parameters.Add(p1);
                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet UpdatePricingRequestCandidateHistory(string offerID, decimal Commission)
        {
            string SQL = "usp_PriceRequestCandidateHistoryCommissionUpdate";
            string cnnString = ConfigurationManager.ConnectionStrings["LibertyPower"].ConnectionString;
            //this needs to be modified to save the offerid and commission for each price/offer from offer engine.
            DataSet ds = new DataSet();
            using (SqlDataAdapter da = new SqlDataAdapter(SQL, cnnString))
            {
                da.SelectCommand.CommandType = CommandType.StoredProcedure;
                SqlParameter p1 = new SqlParameter("@Request_ID", offerID);
                SqlParameter p2 = new SqlParameter("@Commission", Commission);



                da.SelectCommand.Parameters.Add(p1);
                da.SelectCommand.Parameters.Add(p2);
                da.Fill(ds);
            }

            return ds;
        }

        public static DataSet InsertPricingRequestCandidate(int opportunityID, bool weightedAverage, DateTime pricingDueDate, int status, bool indicative, int createdBy, int ownerAgentID, int ownerChannelID, string notes)
        {

            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateInsert";

                    command.Parameters.Add(new SqlParameter("OpportunityID", opportunityID));
                    command.Parameters.Add(new SqlParameter("WeightedAveragePricing", weightedAverage));
                    command.Parameters.Add(new SqlParameter("PricingDueDate", pricingDueDate));
                    command.Parameters.Add(new SqlParameter("Status", status));
                    command.Parameters.Add(new SqlParameter("Indicative", indicative));
                    command.Parameters.Add(new SqlParameter("CreatedBy", createdBy));
                    command.Parameters.Add(new SqlParameter("OwnerAgentID", ownerAgentID));
                    command.Parameters.Add(new SqlParameter("OwnerChannelID", ownerChannelID));
                    if (notes == null || notes.Length == 0)
                        command.Parameters.Add(new SqlParameter("Notes", DBNull.Value));
                    else
                        command.Parameters.Add(new SqlParameter("Notes", notes));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static DataSet UpdatePricingRequestCandidate(int pricingRequestCandidateID, int status, DateTime pricingDueDate, int modifiedBy, int ownerAgentID, int ownerChannelID, string notes)
        {
            DataSet ds = null;

            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateUpdate";

                    command.Parameters.Add(new SqlParameter("PriceRequestID", pricingRequestCandidateID));
                    command.Parameters.Add(new SqlParameter("Status", status));
                    command.Parameters.Add(new SqlParameter("PricingDueDate", pricingDueDate));
                    command.Parameters.Add(new SqlParameter("ModifiedBy", modifiedBy));
                    command.Parameters.Add(new SqlParameter("OwnerAgentID", ownerAgentID));
                    command.Parameters.Add(new SqlParameter("OwnerChannelID", ownerChannelID));

                    if (notes == null || notes.Length == 0)
                        command.Parameters.Add(new SqlParameter("Notes", DBNull.Value));
                    else
                        command.Parameters.Add(new SqlParameter("Notes", notes));

                    using (SqlDataAdapter da = new SqlDataAdapter(command))
                    {
                        ds = new DataSet();
                        da.Fill(ds);
                    }
                }
            }

            return ds;
        }

        public static int InsertPricingRequestCandidateAccount(int pricingRequestCandidateID, int prospectAccountID)
        {
            int rows = 0;
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateAccountInsert";

                    command.Parameters.Add(new SqlParameter("PriceRequestID", pricingRequestCandidateID));
                    command.Parameters.Add(new SqlParameter("ProspectAccountID", prospectAccountID));
                    connection.Open();
                    rows = command.ExecuteNonQuery();
                }
            }
            return rows;
        }

        public static int InsertPricingRequestCandidateProduct(int pricingRequestCandidateID, string product)
        {
            int rows = 0;
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateProductInsert";

                    command.Parameters.Add(new SqlParameter("PriceRequestID", pricingRequestCandidateID));
                    command.Parameters.Add(new SqlParameter("ProductID", product));
                    connection.Open();
                    rows = command.ExecuteNonQuery();
                }
            }
            return rows;
        }

        public static int InsertPricingRequestCandidateTerm(int pricingRequestCandidateID, int termMonths)
        {
            int rows = 0;
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateTermInsert";

                    command.Parameters.Add(new SqlParameter("PriceRequestID", pricingRequestCandidateID));
                    command.Parameters.Add(new SqlParameter("TermMonths", termMonths));
                    connection.Open();
                    rows = command.ExecuteNonQuery();
                }
            }
            return rows;
        }

        public static int InsertPricingRequestCandidateFlowDate(int pricingRequestCandidateID, DateTime flowStartDate)
        {
            int rows = 0;
            using (SqlConnection connection = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "usp_PriceRequestCandidateFlowDateInsert";

                    command.Parameters.Add(new SqlParameter("PriceRequestID", pricingRequestCandidateID));
                    command.Parameters.Add(new SqlParameter("FlowStartDate", flowStartDate));
                    connection.Open();
                    rows = command.ExecuteNonQuery();
                }
            }
            return rows;
        }

    }
}
