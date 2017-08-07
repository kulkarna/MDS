namespace LibertyPower.DataAccess.SqlAccess.TransactionsSql
{
	using System;
	using System.Data;
	using System.Data.SqlClient;

	/// <summary>
	/// Class for handling lp_transactions database data
	/// </summary>
	public static class TransactionsSql
	{
		/// <summary>
		/// Gets AMEREN scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing AMEREN scraped account data.</returns>
        public static DataSet GetAmerenScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AmerenScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Ameren Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="meterNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetAmerenScrapedMeterReadsByOffer(string offerID, string meterNumber, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AmerenScrapedUsageSelectByOffer";
					cmd.Connection = conn;
					cmd.CommandTimeout = 180;

                    cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("meterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Ameren Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="meterNumber"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetAmerenScrapedMeterReads(string account, string meterNumber, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_AmerenScrapedUsageSelect";
					cmd.Connection = conn;
					cmd.CommandTimeout = 180;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("meterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);
				}
			}

			return ds1;
		}
        public static DataSet GetAmerenScrapedMeterReadsMostRecent(string account, string meterNumber, DateTime from, DateTime to)
        {
            DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AmerenScrapedUsageSelectMostRecent";
                    cmd.Connection = conn;
                    cmd.CommandTimeout = 180;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);
                }
            }

            return ds1;
        }

		/// <summary>
		/// Gets BGE scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing BGE scraped account data.</returns>
        public static DataSet GetBgeScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BgeScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves BGE Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetBgeScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BgeScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves BGE Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetBgeScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BgeScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}

		/// <summary>
		/// Gets CENHUD scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing CENHUD scraped account data.</returns>
        public static DataSet GetCenhudScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CenhudScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Cenhud Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetCenhudScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CenhudScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}


		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Cenhud Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetCenhudScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CenhudScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Gets the configuration values (i.e. password, web pages, etc) per UtilityCode
		/// </summary>
		/// <param name="UtilityCode"></param>
		/// <returns></returns>
        public static DataSet GetConfigurationValues(string utilityCode)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WebConfigurationSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("utilityCode", utilityCode));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}

		/// <summary>
		/// Gets CMP scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing CMP scraped account data.</returns>
        public static DataSet GetCmpScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CmpScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Cmp Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetCmpScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CmpScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Cmp Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetCmpScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CmpScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		/// <summary>
		/// Gets COMED scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing COMED scraped account data.</returns>
        public static DataSet GetComedScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ComedScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Comed Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetComedScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ComedScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("offerID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Comed Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetComedScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ComedScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		/// <summary>
		/// Gets CONED scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing CONED scraped account data.</returns>
        public static DataSet GetConedScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ConedScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Coned Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetConedScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ConedScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Coned Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetConedScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ConedScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		/// <summary>
		/// Gets NIMO scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing NIMO scraped account data.</returns>
        public static DataSet GetNimoScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NimoScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Nimo Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetNimoScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NimoScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Nimo Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetNimoScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NimoScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}

		/// <summary>
		/// Gets NYSEG scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing NYSEG scraped account data.</returns>
        public static DataSet GetNysegScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NysegScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Nyseg Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="offerID"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetNysegScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NysegScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Nyseg Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetNysegScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NysegScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                        da1.Fill(ds1);

				}
			}

			return ds1;
		}

		/// <summary>
		/// Gets PECO scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing PECO scraped account data.</returns>
        public static DataSet GetPecoScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PecoScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Peco Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="offerid"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetPecoScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PecoScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Peco Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetPecoScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PecoScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		/// <summary>
		/// Gets RGE scraped account data 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing RGE scraped account data.</returns>
        public static DataSet GetRgeScrapedAccount(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_RgeScrapedAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Rge Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="offerID"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetRgeScrapedMeterReadsByOffer(string offerID, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_RgeScrapedUsageSelectByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("offerID", offerID));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Rge Scraped usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetRgeScrapedMeterReads(string account, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_RgeScrapedUsageSelect";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Inserts an EDI file log record.
		/// </summary>
		/// <param name="info">Log record ID</param>
		/// <param name="fileGuid">GUID identifying file in managed storage</param>
		/// <param name="fileName">Original file name</param>
		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="attempts">Attempts at processing</param>
		/// <param name="info">Log information</param>
		/// <param name="isProcessed">Flag indicating if file has been processed successfully</param>
		/// <param name="fileType">Enumerated file type</param>
		/// <returns>Returns a dataset containing the EDI file log record.</returns>
        public static DataSet InsertEdiFileLog(int ediFileLogID, string fileGuid, string fileName,
            string utilityCode, int attempts, string info, int isProcessed, int fileType)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiFileLogInsert";

                    cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@FileGuid", fileGuid));
                    cmd.Parameters.Add(new SqlParameter("@FileName", fileName));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@Attempts", attempts));
                    cmd.Parameters.Add(new SqlParameter("@Information", info));
                    cmd.Parameters.Add(new SqlParameter("@IsProcessed", isProcessed));
                    cmd.Parameters.Add(new SqlParameter("@FileType", fileType));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts an IDR file log record.
		/// </summary>
		/// <param name="info">Log record ID</param>
		/// <param name="fileGuid">GUID identifying file in managed storage</param>
		/// <param name="fileName">Original file name</param>

		/// <param name="utilityCode">Utility identifier</param>
		/// <param name="info">Log information</param>
		/// <param name="isProcessed">Flag indicating if file has been processed successfully</param>
		/// <param name="fileType">Enumerated file type</param>

		/// <returns>Returns a dataset containing the IDR file log record.</returns>
        public static DataSet InsertIdrFileLog(int idrFileLogID, string fileGuid, string fileName,
            string utilityCode, string info, int isProcessed, int fileType)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IdrFileLogInsert";

                    cmd.Parameters.Add(new SqlParameter("@IdrFileLogID", idrFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@FileGuid", fileGuid));
                    cmd.Parameters.Add(new SqlParameter("@FileName", fileName));

                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@Information", info));
                    cmd.Parameters.Add(new SqlParameter("@IsProcessed", isProcessed));
                    cmd.Parameters.Add(new SqlParameter("@FileType", fileType));


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Insert an edi process log record.
		/// </summary>
		/// <param name="ediProcessLogID">Process log record ID</param>
		/// <param name="ediFileLogID">File log record ID</param>
		/// <param name="info">Log information</param>
		/// <param name="isProcessed">Flag indicating if file has been processed successfully</param>
		/// <returns>Returns a dataset containing the EDI process log record.</returns>
        public static DataSet InsertEdiProcessLog(int ediProcessLogID, int ediFileLogID,
             string info, int isProcessed)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiProcessLogInsert";

                    cmd.Parameters.Add(new SqlParameter("@EdiProcessLogID", ediProcessLogID));
                    cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@Information", info));
                    cmd.Parameters.Add(new SqlParameter("@IsProcessed", isProcessed));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Insert an idr process log record.
		/// </summary>
		/// <param name="idrProcessLogID">Process log record ID</param>
		/// <param name="idrFileLogID">File log record ID</param>
		/// <param name="info">Log information</param>
		/// <param name="isProcessed">Flag indicating if file has been processed successfully</param>
		/// <returns>Returns a dataset containing the IDR process log record.</returns>
        public static DataSet InsertIdrProcessLog(int idrProcessLogID, int idrFileLogID,
             string info, int isProcessed)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IdrProcessLogInsert";

                    cmd.Parameters.Add(new SqlParameter("@IdrProcessLogID", idrProcessLogID));
                    cmd.Parameters.Add(new SqlParameter("@IdrFileLogID", idrFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@Information", info));
                    cmd.Parameters.Add(new SqlParameter("@IsProcessed", isProcessed));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts an EDI account log record
		/// </summary>
		/// <param name="ediProcessLogID">Process log record ID</param>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="dunsNumber">DUNS number which identifies utility</param>
		/// <param name="info">Log information</param>
		/// <param name="severityLevel">Severity of an exception</param>
		/// <returns>Returns a dataset containing the EDI account log record.</returns>
        public static DataSet InsertEdiAccountLog(int ediProcessLogID, string accountNumber,
            string dunsNumber, string info, int severityLevel)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiAccountLogInsert";

                    cmd.Parameters.Add(new SqlParameter("@EdiProcessLogID", ediProcessLogID));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@DunsNumber", dunsNumber));
                    cmd.Parameters.Add(new SqlParameter("@Information", info));
                    cmd.Parameters.Add(new SqlParameter("@Severity", severityLevel));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Inserts an IDR account log record
		/// </summary>
		/// <param name="idrProcessLogID">Process log record ID</param>
		/// <param name="accountNumber">Account identifier</param>
		/// <param name="dunsNumber">DUNS number which identifies utility</param>
		/// <param name="info">Log information</param>
		/// <param name="severityLevel">Severity of an exception</param>
		/// <returns>Returns a dataset containing the IDR account log record.</returns>
        public static DataSet InsertIdrAccountLog(int idrProcessLogID, string accountNumber,
            string dunsNumber, string info, int severityLevel)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IdrAccountLogInsert";

                    cmd.Parameters.Add(new SqlParameter("@IdrProcessLogID", idrProcessLogID));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@DunsNumber", dunsNumber));
                    cmd.Parameters.Add(new SqlParameter("@Information", info));
                    cmd.Parameters.Add(new SqlParameter("@Severity", severityLevel));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
        public static DataSet InsertWebAccountLog(string account, string utility, string info, int severityLevel)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_WebAccountLogInsert";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("utilityCode", utility));
                    cmd.Parameters.Add(new SqlParameter("information", info));
                    cmd.Parameters.Add(new SqlParameter("severity", severityLevel));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Selects file log records greater than or equal to date parameter.
		/// </summary>
		/// <param name="date">Date to filter on</param>
		/// <param name="logType">Log type to filter on (errors, warnins, all)</param>
		/// <param name="fileType">File type to filter on (814, 867, status update files)</param>
		/// <returns>Returnns a dataset containing file log records greater than or equal to date parameter.</returns>
        public static DataSet SelectEdiFileLogs(DateTime date, string logType, string fileType)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiFileLogsSelect";

                    cmd.Parameters.Add(new SqlParameter("@Date", date));
                    cmd.Parameters.Add(new SqlParameter("@LogType", logType));
                    cmd.Parameters.Add(new SqlParameter("@FileType", fileType));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Searches file log records on specified field
		/// </summary>
		/// <param name="field">Field in table to search on</param>
		/// <param name="searchText">Search text</param>
		/// <returns>Returns a dataset containing the records found that matched criteria.</returns>
        public static DataSet SearchEdiFileLogs(string field, string searchText)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiFileLogsSearch";

                    cmd.Parameters.Add(new SqlParameter("@Field", field));
                    cmd.Parameters.Add(new SqlParameter("@SearchText", searchText));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets edi account logs for specified file identifier.
		/// </summary>
		/// <param name="fileGuid">File identifier in managed storage</param>
		/// <param name="severity">Severity level of logs</param>
		/// <returns>Returns a dataset containing edi account logs for specified file identifier.</returns>
        public static DataSet SelectEdiAccountLogs(string fileGuid, string severity)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiAccountLogsSelect";

                    cmd.Parameters.Add(new SqlParameter("@FileGuid", fileGuid));
                    cmd.Parameters.Add(new SqlParameter("@Severity", severity));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

        /// <summary>
        /// Is there an open transaction for specified account and utility for a usage request 
        /// </summary>
        /// <param name="accountNumber">Account number</param>
        /// <param name="utilityCode">Utility code</param>
        /// <returns>Returns transaction id matching account and utility code of usage request.</returns>
        public static bool HasUsageTransaction(string accountNumber, string utilityCode)
        {
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UsageEvents_GetTransactionId";
                    cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Connection.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                        return dr.Read();
                }
            }
        }

		/// <summary>
		/// Saves Events for the "Phoenix-Bus"
		/// </summary>
		/// <param name="message"></param>
		/// <param name="messageType"></param>
        public static void SaveEvent(object message, string messageType)
		{
            using (var con = new SqlConnection(Helper.ConnectionString))
			    {
                using (var cmd = new SqlCommand("usp_UsageEvents_SendEventMessage", con))
				    {
                    cmd.Parameters.Add(new SqlParameter("TimeSent", DateTime.Now));
                    cmd.Parameters.Add(new SqlParameter("MessageType", messageType));
                    cmd.Parameters.Add(new SqlParameter("CorrelationId", DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("Body", message));

					    cmd.CommandType = CommandType.StoredProcedure;

					    con.Open();
					    cmd.ExecuteNonQuery();
					    con.Close();
				    }
			    }
		    }

		/// <summary>
		/// Inserts an edi exception
		/// </summary>
		/// <param name="fileGuid">File identifier in managed storage</param>
		/// <param name="fileName">File name</param>
		/// <param name="info">Log information</param>
		/// <returns>Returns a dataset containing the exception message.</returns>
        public static DataSet InsertEdiException(string fileGuid, string fileName, string info)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiExceptionInsert";

                    cmd.Parameters.Add(new SqlParameter("@FileGuid", fileGuid));
                    cmd.Parameters.Add(new SqlParameter("@FileName", fileName));
                    cmd.Parameters.Add(new SqlParameter("@Information", info));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

        /// <summary>
        /// Inserts edi account data
        /// </summary>
        /// <param name="ediFileLogID">Edi file log record identifier</param>
        /// <param name="accountNumber">Account identifier</param>
        /// <param name="billingAccountNumber">Billing account number</param>
        /// <param name="espAccountNumber">Esp account number</param>
        /// <param name="customerName">Customer name</param>
        /// <param name="dunsNumber">DUNS number</param>
        /// <param name="icap">Icap</param>
        /// <param name="nameKey">Name key</param>
        /// <param name="previousAccountNumber">Previous account number</param>
        /// <param name="rateClass">Rate class</param>
        /// <param name="loadProfile">Load profile</param>
        /// <param name="billGroup">Bill group</param>
        /// <param name="retailMarketCode">Market identifier</param>
        /// <param name="tcap">Tcap</param>
        /// <param name="utilityCode">Utility identifier</param>
        /// <param name="zone">Zone code</param>
        /// <param name="accountStatus">Account status</param>
        /// <param name="billingType">Billing type</param>
        /// <param name="billCalculation">Bill calculation</param>
        /// <param name="servicePeriodStart">Service period start</param>
        /// <param name="servicePeriodEnd">Service period end</param>
        /// <param name="anuualUsage">Anuual usage</param>
        /// <param name="monthsToComputeKwh">Months to compute Kwh</param>
        /// <param name="meterType"></param>
        /// <param name="transactionType">Transaction type</param>
        /// <param name="serviceType">Service type</param>
        /// <param name="productType">Product type</param>
        /// <param name="productAltType">Product alt type</param>
        /// <param name="contactName">Contact name</param>
        /// <param name="emailAddress">email address</param>
        /// <param name="fax">Fax</param>
        /// <param name="telephone">Telephone</param>
        /// <param name="workPhone">Work phone</param>
        /// <param name="homePhone">Home phone</param>
        /// <param name="MeterNumber">Meter number</param>
        /// <param name="ServiceDeliveryPoint">Service delivery point</param>
        /// <param name="meterMultiplier"></param>
        /// <param name="lossFactor">Loss factor</param>
        /// <param name="voltage">Voltage</param>
        /// <param name="effectiveDate">Effective date</param>
        /// <param name="netMeterType">Net meter type</param>
        /// <param name="meterAttributes">Meter attributes</param>
        /// <param name="icapEffectiveDate">ICAP effective date</param>
        /// <param name="tcapEffectiveDate">TCAP effective date</param>
        /// <param name="transactionCreatedDate">TransactionCreatedDate</param>
        /// <returns>Returns a dataset containing the edi account data with record ID.</returns>
        public static DataSet InsertEdiAccount(int ediFileLogID, string accountNumber, string billingAccountNumber, string espAccountNumber,
            string customerName, string dunsNumber, decimal? icap, string nameKey, string previousAccountNumber,
            string rateClass, string loadProfile, string billGroup, string retailMarketCode, decimal? tcap,
            string utilityCode, string zone, string accountStatus, string billingType, string billCalculation,
            DateTime servicePeriodStart, DateTime servicePeriodEnd, int anuualUsage, Int16 monthsToComputeKwh,
            string meterType, Int16 meterMultiplier, string transactionType, string serviceType, string productType,
            string productAltType, string contactName, string emailAddress, string fax, string telephone,
            string workPhone, string homePhone, string MeterNumber, string ServiceDeliveryPoint, decimal? lossFactor,
            string voltage, DateTime effectiveDate, string netMeterType, DateTime? icapEffectiveDate, DateTime? tcapEffectiveDate, int? DaysInArrear,
            DateTime? transactionCreatedDate)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.CommandText = "usp_EdiAccountInsert";

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@accountStatus", accountStatus));
                    cmd.Parameters.Add(new SqlParameter("@anuualUsage", anuualUsage));
                    cmd.Parameters.Add(new SqlParameter("@billCalculation", billCalculation));
                    cmd.Parameters.Add(new SqlParameter("@BillGroup", billGroup));
                    cmd.Parameters.Add(new SqlParameter("@BillingAccountNumber", billingAccountNumber));
                    cmd.Parameters.Add(new SqlParameter("@billingType", billingType));
                    cmd.Parameters.Add(new SqlParameter("@contactName", contactName));
                    cmd.Parameters.Add(new SqlParameter("@CustomerName", customerName));
                    cmd.Parameters.Add(new SqlParameter("@DunsNumber", dunsNumber));
                    cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@emailAddress", emailAddress));
                    cmd.Parameters.Add(new SqlParameter("@EspAccountNumber", espAccountNumber));
                    cmd.Parameters.Add(new SqlParameter("@fax", fax));
                    cmd.Parameters.Add(new SqlParameter("@homePhone", homePhone));
                    cmd.Parameters.Add(new SqlParameter("@Icap", icap));
                    cmd.Parameters.Add(new SqlParameter("@LoadProfile", loadProfile));
                    cmd.Parameters.Add(new SqlParameter("@LossFactor", lossFactor));
                    cmd.Parameters.Add(new SqlParameter("@meterMultiplier", meterMultiplier));
                    cmd.Parameters.Add(new SqlParameter("@meterNumber", MeterNumber == null ? "" : MeterNumber));
                    cmd.Parameters.Add(new SqlParameter("@meterType", meterType));
                    cmd.Parameters.Add(new SqlParameter("@monthsToComputeKwh", monthsToComputeKwh));
                    cmd.Parameters.Add(new SqlParameter("@NameKey", nameKey));
                    cmd.Parameters.Add(new SqlParameter("@PreviousAccountNumber", previousAccountNumber));
                    cmd.Parameters.Add(new SqlParameter("@productAltType", productAltType));
                    cmd.Parameters.Add(new SqlParameter("@productType", productType));
                    cmd.Parameters.Add(new SqlParameter("@RateClass", rateClass));
                    cmd.Parameters.Add(new SqlParameter("@RetailMarketCode", retailMarketCode));
                    cmd.Parameters.Add(new SqlParameter("@serviceDeliveryPoint", ServiceDeliveryPoint));
                    cmd.Parameters.Add(new SqlParameter("@servicePeriodEnd", servicePeriodEnd));
                    cmd.Parameters.Add(new SqlParameter("@servicePeriodStart", servicePeriodStart));
                    cmd.Parameters.Add(new SqlParameter("@serviceType", serviceType));
                    cmd.Parameters.Add(new SqlParameter("@Tcap", tcap));
                    cmd.Parameters.Add(new SqlParameter("@telephone", telephone));
                    cmd.Parameters.Add(new SqlParameter("@transactionType", transactionType));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@voltage", voltage));
                    cmd.Parameters.Add(new SqlParameter("@workPhone", workPhone));
                    cmd.Parameters.Add(new SqlParameter("@ZoneCode", zone));
                    cmd.Parameters.Add(new SqlParameter("@effectiveDate", effectiveDate));
                    cmd.Parameters.Add(new SqlParameter("@netMeterType", netMeterType));
                    cmd.Parameters.Add(new SqlParameter("@IcapEffectiveDate", icapEffectiveDate));
                    cmd.Parameters.Add(new SqlParameter("@TcapEffectiveDate", tcapEffectiveDate));
                    cmd.Parameters.Add(new SqlParameter("@DaysInArrears", DaysInArrear));
                    cmd.Parameters.Add(new SqlParameter("@TransactionCreationDate", transactionCreatedDate));
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        public static DataSet InsertEdiAddress(int ediAccountID, Int16 addressType, string address1, string address2,
            string city, string state, string postalCode)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_EdiAddressInsert";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    cmd.Parameters.Add(new SqlParameter("@addressType", addressType));
                    cmd.Parameters.Add(new SqlParameter("@Address1", address1));
                    cmd.Parameters.Add(new SqlParameter("@Address2", address2));
                    cmd.Parameters.Add(new SqlParameter("@City", city));
                    cmd.Parameters.Add(new SqlParameter("@State", state));
                    cmd.Parameters.Add(new SqlParameter("@PostalCode", postalCode));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Inserts edi usage detail record into the database
		/// </summary>
		/// <param name="ediAccountID"></param>
		/// <param name="beginDate"></param>
		/// <param name="endDate"></param>
		/// <param name="quantity"></param>
		/// <param name="meterNumber"></param>
		/// <param name="measurementSignificanceCode"></param>
		/// <param name="ptdLoop"></param>
		/// <param name="transactionSetPurposeCode"></param>
		/// <param name="unitOfMeasurement"></param>
		/// <returns></returns>
        public static DataSet InsertEdiUsageDetail(int ediAccountID, DateTime beginDate, DateTime endDate,
            decimal quantity, string meterNumber, string measurementSignificanceCode, string ptdLoop,
            string transactionSetPurposeCode, string unitOfMeasurement, int ediFileLogID)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.CommandText = "usp_EdiUsageDetailInsert";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    cmd.Parameters.Add(new SqlParameter("@ptdLoop", ptdLoop));
                    cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@Quantity", quantity));
                    cmd.Parameters.Add(new SqlParameter("@MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("@MeasurementSignificanceCode", measurementSignificanceCode));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));
                    cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Inserts usage from EDI.
		/// </summary>
        /// 
		/// <param name="ediAccountID">Edi account record identifier</param>
		/// <param name="beginDate">Begin date</param>
		/// <param name="endDate">End date</param>
		/// <param name="quantity">Quantity</param>
		/// <param name="meterNumber">Meter number</param>
		/// <param name="measurementSignificanceCode">Measurement significance code</param>
		/// <param name="transactionSetPurposeCode">Transaction set purpose code</param>
		/// <param name="unitOfMeasurement">Unit of measurement</param>
        /// <param name="historicalSection">Historical section</param>
        /// 
		/// <returns>Returns a dataset containing the edi usage data with record ID.</returns>
        public static DataSet InsertEdiUsage(
            int ediAccountID, 
            DateTime beginDate, 
            DateTime endDate,
			decimal quantity,
            string meterNumber,
            string measurementSignificanceCode,
			string transactionSetPurposeCode,
            string unitOfMeasurement, 
            string ServiceDeliveryPoint,
            int ediFileLogID, 
            string historicalSection = null)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_EdiUsageInsert";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@Quantity", quantity));
                    cmd.Parameters.Add(new SqlParameter("@MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("@MeasurementSignificanceCode", measurementSignificanceCode));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));
                    cmd.Parameters.Add(new SqlParameter("@ServiceDeliveryPoint", ServiceDeliveryPoint));
                    cmd.Parameters.Add(new SqlParameter("@HistoricalSection", historicalSection == null ? string.Empty : historicalSection));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Inserts IDR usage from EDI
		/// </summary>
		/// <param name="ediAccountID"></param>
		/// <param name="date"></param>
		/// <param name="interval"></param>
		/// <param name="kw"></param>
		/// <param name="ptdLoop"></param>
		/// <param name="transactionSetPurposeCode"></param>
		/// <param name="unitOfMeasurement"></param>
		/// <returns></returns>
        public static DataSet InsertIdrUsage(int ediAccountID, DateTime date, Int16 interval, decimal kw, string ptdLoop,
            string transactionSetPurposeCode, string unitOfMeasurement)
		{
			DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = conn;
					cmd.CommandText = "usp_IdrUsageInsert";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    cmd.Parameters.Add(new SqlParameter("@Date", date));
                    cmd.Parameters.Add(new SqlParameter("@Kw", kw));
                    cmd.Parameters.Add(new SqlParameter("@Interval", interval));
                    cmd.Parameters.Add(new SqlParameter("@PtdLoop", ptdLoop));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}

			return ds;
		}

        public static void Insert8760IdrBulk(DataTable dt)
		{
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				conn.Open();
                using (SqlBulkCopy copy = new SqlBulkCopy(conn))
				{
                    copy.ColumnMappings.Add("IdrFileLogId", "idrFileLogId");
                    copy.ColumnMappings.Add("UtilityCode", "utilityCode");
                    copy.ColumnMappings.Add("AccountNumber", "accountNumber");
                    copy.ColumnMappings.Add("MeterNumber", "meterNumber");
                    copy.ColumnMappings.Add("RecorderNumber", "recorderNumber");
                    copy.ColumnMappings.Add("UsageSource", "usageSource");
                    copy.ColumnMappings.Add("UsageType", "usageType");
                    copy.ColumnMappings.Add("CreatedBy", "createdBy");
                    copy.ColumnMappings.Add("IdrDate", "idrDate");
                    copy.ColumnMappings.Add("Intervals", "intervals");
                    copy.ColumnMappings.Add("Uom", "unitOfMeasurement");

					copy.DestinationTableName = "dbo.Idr8760FileTemp";
					copy.BatchSize = 10000;
                    copy.WriteToServer(dt);
				}
			}
		}

        public static void InsertIdrUsageBulk(DataTable dt)
		{
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				conn.Open();
                using (SqlBulkCopy copy = new SqlBulkCopy(conn))
				{
                    copy.ColumnMappings.Add("accountID", "EdiAccountId");
                    copy.ColumnMappings.Add("meterNumber", "MeterNumber");
                    copy.ColumnMappings.Add("ptdLookup", "PtdLoop");
                    copy.ColumnMappings.Add("date", "Date");
                    copy.ColumnMappings.Add("interval", "Interval");
                    copy.ColumnMappings.Add("quantity", "Quantity");
                    copy.ColumnMappings.Add("code", "TransactionSetPurposeCode");
                    copy.ColumnMappings.Add("unit", "UnitOfMeasurement");
                    copy.ColumnMappings.Add("dateInsert", "TimeStampInsert");
                    copy.ColumnMappings.Add("dateUpdate", "TimeStampUpdate");
					copy.DestinationTableName = "dbo.IdrUsageTemp";
					copy.BatchSize = 10000;
                    copy.WriteToServer(dt);
				}
			}
		}

        public static void Insert8760IdrFromTemp(int idrFileLogId, string accountNumber, string utilityCode)
		{
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				conn.Open();
                using (SqlCommand cmd = new SqlCommand())
				{
                    cmd.Parameters.Add(new SqlParameter("@idrFileLogId", idrFileLogId));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@accountNumber", accountNumber));

					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "k";
					cmd.Connection = conn;
					cmd.ExecuteNonQuery();
				}
			}
		}

		public static void InsertIdrUsageFromTemp()
		{
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				conn.Open();
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IdrUsageInsertFromTemp";
					cmd.Connection = conn;
					cmd.ExecuteNonQuery();
				}
			}
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// insert all the IDR usage for one account number.
		/// </summary>
		/// <param name="dt">dataTable containing all the usage for an account</param>
        public static void InsertIdrUsage(DataTable dt)
		{
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				conn.Open();
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_IdrUsageInsertTable";
					cmd.Connection = conn;

                    SqlParameter sParam = new SqlParameter("@IdrDATA", SqlDbType.Structured);
					sParam.Value = dt;
                    cmd.Parameters.Add(sParam);
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets latest EDI account data that has usage data associated with it. 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a dataset containing the latest EDI account data that has usage data associated with it.</returns>
        public static DataSet GetEdiAccount(string accountNumber, string utilityCode)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiAccountSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets all EDI account data for specified account that has usage data associated with it. 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <returns>Returns a dataset containing the latest EDI account data that has usage data associated with it.</returns>
        public static DataSet GetEdiAccountAll(string accountNumber, string utilityCode)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiAccountSelectAll";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets all EDI account data for specified account and file log id. 
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">Utility code</param>
		/// <param name="fileLogId">Edi file log id</param>
		/// <returns>Returns a dataset containing the latest EDI account data that has usage data associated with it.</returns>
        public static DataSet GetEdiAccountsUsingEdiLogId(string accountNumber, string utilityCode, int fileLogId)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_EdiAccountsByFileLogId";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@FileLogId", fileLogId));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}
		/// <summary>
		/// Gets EDI usage data for specified EDI account ID.
		/// </summary>
		/// <param name="ediAccountId">EDI account record identifier</param>
		/// <returns>Returns a dataset containing EDI usage data for specified EDI account ID.</returns>
        public static DataSet GetEdiUsage(int ediAccountId)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiUsageSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountId));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Historical EDI usage from the 'transactions' database
		/// </summary>
		/// <param name="offerid"></param>
		/// <param name="utility"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetEdiMeterReadsByOffer(string offerID, string utility, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetEdiMeterReadsByOffer";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("offerID", offerID));
                    cmd.Parameters.Add(new SqlParameter("utilityCode", utility));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Historical EDI usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="utility"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetEdiMeterReads(string account, string utility, DateTime from, DateTime to)
		{
			DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_GetEdiMeterReads";
					cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("utilityCode", utility));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds1);
					}
				}
			}

			return ds1;
		}
        public static DataSet GetEdiMeterReadsMostRecent(string account, string utility, DateTime from, DateTime to)
        {
            DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetEdiMeterReadsMostRecent";
                    cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("accountNumber", account.Trim()));
                    cmd.Parameters.Add(new SqlParameter("utilityCode", utility));
                    cmd.Parameters.Add(new SqlParameter("beginDate", from));
                    cmd.Parameters.Add(new SqlParameter("endDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                    {
                        da1.Fill(ds1);
                    }
                }
            }

            return ds1;
        }

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Historical EDI usage from the 'transactions' database
		/// </summary>
		/// <param name="offerID"></param>
		/// <param name="utility"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetFileMeterReadsByOffer(string offerID, string utilityCode, DateTime fromDate, DateTime toDate)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_FileUsageSelectByOffer";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@OfferID", offerID));
                    cmd.Parameters.Add(new SqlParameter("@FromDate", fromDate));
                    cmd.Parameters.Add(new SqlParameter("@ToDate", toDate));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds);
					}
				}
			}
			return ds;
		}

		// ------------------------------------------------------------------------------------
		/// <summary>
		/// Retrieves Historical EDI usage from the 'transactions' database
		/// </summary>
		/// <param name="account"></param>
		/// <param name="utility"></param>
		/// <param name="from"></param>
		/// <param name="to"></param>
		/// <returns></returns>
        public static DataSet GetFileMeterReads(string accountNumber, string utilityCode, DateTime fromDate, DateTime toDate)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_FileUsageSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@FromDate", fromDate));
                    cmd.Parameters.Add(new SqlParameter("@ToDate", toDate));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
					{
                        da1.Fill(ds);
					}
				}
			}
			return ds;
		}

		/// <summary>
		/// insert an edi daily transaction log record.
		/// </summary>
		public static void InsertEdiDailyTransaction()
		{
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiDailyTransactionInsert";

					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Insert an edi daily transaction log record.
		/// </summary>
		/// <param name="dtEdiDailyTransaction">DataTable with EdiDailyTransaction structure</param>
		/// <returns>Returns a dataset containing the EDI process log record.</returns>
        public static void InsertEdiDailyTransactionBulkCopy(DataTable dtEdiDailyTransaction)
		{
            SqlBulkCopy ediBulkCopy = new SqlBulkCopy(Helper.ConnectionString, SqlBulkCopyOptions.TableLock);
			ediBulkCopy.DestinationTableName = "dbo.EdiDailyTransactionTemp";

            ediBulkCopy.ColumnMappings.Add("Edifilelogid", "Edifilelogid");
            ediBulkCopy.ColumnMappings.Add("DunsNumber", "DunsNumber");
            ediBulkCopy.ColumnMappings.Add("AccountNumber", "AccountNumber");
            ediBulkCopy.ColumnMappings.Add("TransactionNumber", "TransactionNumber");
            ediBulkCopy.ColumnMappings.Add("TransactionDate", "TransactionDate");
            ediBulkCopy.ColumnMappings.Add("RequestType", "RequestType");
            ediBulkCopy.ColumnMappings.Add("TransactionReferenceNumber", "TransactionReferenceNumber");
            ediBulkCopy.ColumnMappings.Add("Direction", "Direction");
            ediBulkCopy.ColumnMappings.Add("Tstatus", "Tstatus");
            ediBulkCopy.ColumnMappings.Add("FileName", "FileName");

            ediBulkCopy.WriteToServer(dtEdiDailyTransaction);
		}


		//public static void CallbackHandler(IAsyncResult result)
		//{
		//    SqlCommand cmd = result.AsyncState as SqlCommand;
		//    try
		//    {
		//        {
		//            //SqlDataReader sdr = cmd.EndExecuteReader(result);
		//            int i = cmd.EndExecuteNonQuery(result);
		//        }
		//    }
		//    catch(Exception ex)
		//    {
		//        Console.WriteLine(ex.InnerException + " " + ex.Message);
		//        throw;
		//    }
		//    finally
		//    {
		//        //#region Cleanup

		//        //cmd.Connection.Close();
		//        //cmd.Connection.Dispose();
		//        //cmd.Dispose();

		//        //#endregion

		//    }
		//}

		/// <summary>
		/// Invoked procedure to consolidate values
		/// </summary>
        public static void ConsolidateMissingValuesfromScraperSrcs(string sourceTable, string sourceType)
		{
			string storedProcedureName = string.Empty;

			//SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(Helper.ConnectionString);
			//builder.AsynchronousProcessing = true;
			//builder.ConnectTimeout = 0;


            switch (sourceTable.ToUpper())
			{
				case "AMEREN":
					storedProcedureName = "usp_ConsolidateIcapAmeren";
					break;

				case "BGE":
                    if (sourceType.ToUpper() == "ICAP")
					{
						storedProcedureName = "usp_ConsolidateIcapBGE";
					}
                    else if (sourceType.ToUpper() == "TCAP")
					{
						storedProcedureName = "usp_ConsolidateTcapBGE";
					}
					break;

				case "COMED":
                    if (sourceType.ToUpper() == "ICAP")
					{
						storedProcedureName = "usp_ConsolidateIcapComed";
					}
                    else if (sourceType.ToUpper() == "TCAP")
					{
						storedProcedureName = "usp_ConsolidateTcapComed";
					}
					break;

				case "CONED":
                    if (sourceType.ToUpper() == "ICAP")
					{
						storedProcedureName = "usp_ConsolidateIcapConed";
					}
					break;

				case "NYSEG":
                    if (sourceType.ToUpper() == "ICAP")
					{
						storedProcedureName = "usp_ConsolidateIcapNySeg";
					}
					break;

				case "PECO":
                    if (sourceType.ToUpper() == "ICAP")
					{
						storedProcedureName = "usp_ConsolidateIcapPeco";
					}
					break;

				case "RGE":
                    if (sourceType.ToUpper() == "ICAP")
					{
						storedProcedureName = "usp_ConsolidateIcapRGE";
					}
					break;
			}

            ExecuteNonQuery(storedProcedureName);
		}

		public static void ConsolidateMissingICapfromEDI()
		{
			string storedProcedureName = "usp_ConsolidateICapEDI";
            ExecuteNonQuery(storedProcedureName);
		}

		public static void ConsolidateMissingTCapfromEDI()
		{
			string storedProcedureName = "usp_ConsolidateTCapEDI";
            ExecuteNonQuery(storedProcedureName);
		}

		public static void ConsolidateMissingDeliveryPointsfromEDI()
		{
			string storedProcedureName = "usp_AccountContractDeliveryPointUpdate";
            ExecuteNonQuery(storedProcedureName);
		}

		public static void ConsolidateMissingLoadProfileValuesfromEDI()
		{
			string storedProcedureName = "usp_AccountLoadProfileUpdate";
            ExecuteNonQuery(storedProcedureName);
		}

        private static void ExecuteNonQuery(string storedProcedureName)
		{  //SqlConnection conn = new SqlConnection(builder.ConnectionString);
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					conn.Open();
					cmd.Connection = conn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = storedProcedureName;
					cmd.CommandTimeout = 0;

					//IAsyncResult result = cmd.BeginExecuteNonQuery(new AsyncCallback(CallbackHandler), cmd);
					//IAsyncResult result = cmd.BeginExecuteReader(new AsyncCallback(CallbackHandler), cmd);
					//IAsyncResult result = cmd.BeginExecuteNonQuery();                      
					cmd.ExecuteNonQuery();
				}
			}
		}

		/// <summary>
		/// Gets AMEREN scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing AMEREN scraped account data.</returns>
        public static DataSet GetAmerenAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AmerenAccountGetLatestReads";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

        /// <summary>
        /// Gets AMEREN scraped account data (most recent)
        /// </summary>
        /// <param name="accountNumber">Account number</param>
        /// <returns>Returns a dataset containing AMEREN scraped account data.</returns>
        public static DataSet GetAmerenAccountLatestWithServicePoint(string accountNumber)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AmerenAccountGetLatestReadsServicePoint";
                    cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

        /// <summary>
        /// Gets AMEREN scraped account data (most recent)
        /// </summary>
        /// <param name="accountNumber">Account number</param>
        /// <returns>Returns a dataset containing AMEREN scraped account data.</returns>
        public static DataSet GetAmerenAccountMeterChangeStatus(string accountNumber)
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_AmerenAccountGetLatestReads";
                    cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }

		/// <summary>
		/// Gets Bge scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Bge scraped account data.</returns>
        public static DataSet GetBgeAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_BgeAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets Cenhud scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Cenhud scraped account data.</returns>
        public static DataSet GetCenhudAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CenhudAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets Cmp scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Cmp scraped account data.</returns>
        public static DataSet GetCmpAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_CmpAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets Comed scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Comed scraped account data.</returns>
        public static DataSet GetComedAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ComedAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets Coned scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Coned scraped account data.</returns>
        public static DataSet GetConedAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_ConedAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets Coned scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Coned scraped account data.</returns>
        public static DataSet GetNysegAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NysegAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets Coned scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Coned scraped account data.</returns>
        public static DataSet GetRgeAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_RgeAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets Coned scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Coned scraped account data.</returns>
        public static DataSet GetPecoAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_PecoAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

		/// <summary>
		/// Gets Coned scraped account data (most recent)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <returns>Returns a dataset containing Coned scraped account data.</returns>
        public static DataSet GetNimoAccountLatest(string accountNumber)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_NimoAccountGet";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}
		/// <summary>
		/// Gets Edi account data (most recent zone, load profile, service class, bill cycle)
		/// </summary>
		/// <param name="accountNumber">Account number</param>
		/// <param name="utilityCode">utility code</param>
		/// <returns>Returns a dataset containing Coned scraped account data.</returns>
        public static DataSet GetEdiAccountLatest(string accountNumber, string utilityCode)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiAccountGetLatest";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

        public static DataSet GetEdiAccounts(DateTime dtProcessTime)
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_EdiAccountsSelect";
					cmd.Connection = cn;

                    cmd.Parameters.Add(new SqlParameter("@ProcessTime", dtProcessTime));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}
        /// <summary>
        /// TFS68346- MTJ-06/29/2015- Invoke the new StoredProcedure to Get the USage Record Data
        /// </summary>
        /// <param name="dtProcessTime"></param>
        /// <returns></returns>
        public static DataSet GetEdiUsageRecord(int ediAccountID, DateTime beginDate, DateTime endDate,
                                                 string meterNumber, string measurementSignificanceCode,
                                                string transactionSetPurposeCode, string unitOfMeasurement, string ServiceDeliveryPoint)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.CommandText = "usp_GetEdiUsageRecord";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    //cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    //cmd.Parameters.Add(new SqlParameter("@Quantity", quantity));
                    cmd.Parameters.Add(new SqlParameter("@MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("@MeasurementSignificanceCode", measurementSignificanceCode));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));
                    cmd.Parameters.Add(new SqlParameter("@ServiceDeliveryPoint", ServiceDeliveryPoint));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        /// <summary>
        /// TFS68346- MTJ-06/29/2015- Invoke the new StoredProcedure to Get  the USage NullMeter Record
        /// </summary>
        /// <param name="dtProcessTime"></param>
        /// <returns></returns>
        public static DataSet GetEdiUsageRecordNullMeter(int ediAccountID, DateTime beginDate, DateTime endDate,
                                               decimal quantity, string measurementSignificanceCode,
                                               string transactionSetPurposeCode, string unitOfMeasurement, string ServiceDeliveryPoint)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.CommandText = "usp_GetEdiUsageNullMeter";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    //cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@Quantity", quantity));
                    //cmd.Parameters.Add(new SqlParameter("@MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("@MeasurementSignificanceCode", measurementSignificanceCode));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));
                    cmd.Parameters.Add(new SqlParameter("@ServiceDeliveryPoint", ServiceDeliveryPoint));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        /// <summary>
        /// TFS68346- MTJ-06/29/2015- Invoke the new StoredProcedure to Get the  the USageDetail Record for a specific usage read.
        /// </summary>
        /// <param name="dtProcessTime"></param>
        /// <returns></returns>
        public static DataSet GetEdiUsageDupNullMeter(int ediAccountID, DateTime beginDate, DateTime endDate,
                                             decimal quantity, string measurementSignificanceCode,
                                             string transactionSetPurposeCode, string unitOfMeasurement, int ediFileLogId,
                                             string ServiceDeliveryPoint, string PTDLoop, int usageType)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.CommandText = "usp_GetEdiUsageDupNullMeter";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    //cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@Quantity", quantity));
                    //cmd.Parameters.Add(new SqlParameter("@MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("@MeasurementSignificanceCode", measurementSignificanceCode));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));
                    cmd.Parameters.Add(new SqlParameter("@edifileLogId", ediFileLogId));
                    cmd.Parameters.Add(new SqlParameter("@ServiceDeliveryPoint", ServiceDeliveryPoint));
                    cmd.Parameters.Add(new SqlParameter("@PTDLoop", PTDLoop));
                    cmd.Parameters.Add(new SqlParameter("@UsageType", usageType));


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        /// <summary>
        /// TFS68346- MTJ-06/29/2015- Invoke the new StoredProcedure to Get the  the USageDetail Record for a specific usage read.
        /// </summary>
        /// <param name="dtProcessTime"></param>
        /// <returns></returns>
        public static DataSet GetEdiUsageDetailRecord(int ediAccountID, DateTime beginDate, DateTime endDate,
                                         string meterNumber, string measurementSignificanceCode,
                                        string transactionSetPurposeCode, string unitOfMeasurement, string ptdLoop)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.CommandText = "usp_GetEdiUsageDetailRecord";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    //cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    //cmd.Parameters.Add(new SqlParameter("@Quantity", quantity));
                    cmd.Parameters.Add(new SqlParameter("@MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("@MeasurementSignificanceCode", measurementSignificanceCode));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));
                    cmd.Parameters.Add(new SqlParameter("@ptdLoop", ptdLoop));


                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        /// <summary>
        /// TFS68346- MTJ-06/29/2015- Invoke the new StoredProcedure to Get the the USageDetail NullMeter records
        /// </summary>
        /// <param name="dtProcessTime"></param>
        /// <returns></returns>
        public static DataSet GetEdiUsageDetailNullMeter(int ediAccountID, DateTime beginDate, DateTime endDate,
                                               decimal quantity, string measurementSignificanceCode,
                                               string transactionSetPurposeCode, string unitOfMeasurement, string ptdLoop)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.CommandText = "usp_GetEdiUsageDetailNullMeter";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    //cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@Quantity", quantity));
                    //cmd.Parameters.Add(new SqlParameter("@MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("@MeasurementSignificanceCode", measurementSignificanceCode));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));
                    cmd.Parameters.Add(new SqlParameter("@ptdLoop", ptdLoop));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        /// <summary>
        /// TFS68346- MTJ-06/29/2015- Invoke the new StoredProcedure to Insert the duplicate USage Quantities from parser.
        /// </summary>
        /// 
        /// <param name="ediAccountID">Edi account record identifier</param>
        /// <param name="beginDate">Begin date</param>
        /// <param name="endDate">End date</param>
        /// <param name="quantity">Quantity</param>
        /// <param name="meterNumber">Meter number</param>
        /// <param name="measurementSignificanceCode">Measurement significance code</param>
        /// <param name="transactionSetPurposeCode">Transaction set purpose code</param>
        /// <param name="unitOfMeasurement">Unit of measurement</param>
        /// <param name="ServiceDeliveryPoint">Service delivery point</param>
        /// <param name="ediFileLogID">Edi file log identifier</param>
        /// <param name="PTDLoop"></param>
        /// <param name="usageType">Usage type</param>
        /// <param name="historicalSection">Historical section</param>
        /// 
        /// <returns>Returns a dataset containing the edi usage data with record ID</returns>
        public static DataSet EdiUsageDuplicateInsert(
            int ediAccountID, 
            DateTime beginDate, 
            DateTime endDate,
            decimal quantity,
            string meterNumber,
            string measurementSignificanceCode,
            string transactionSetPurposeCode,
            string unitOfMeasurement, 
            string ServiceDeliveryPoint,
            int ediFileLogID, 
            string PTDLoop, 
            int usageType,
            string historicalSection = null)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.CommandText = "usp_EdiUsageDuplicateInsert";

                    cmd.Parameters.Add(new SqlParameter("@EdiAccountID", ediAccountID));
                    cmd.Parameters.Add(new SqlParameter("@EdiFileLogID", ediFileLogID));
                    cmd.Parameters.Add(new SqlParameter("@BeginDate", beginDate));
                    cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                    cmd.Parameters.Add(new SqlParameter("@Quantity", quantity));
                    cmd.Parameters.Add(new SqlParameter("@MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("@MeasurementSignificanceCode", measurementSignificanceCode));
                    cmd.Parameters.Add(new SqlParameter("@TransactionSetPurposeCode", transactionSetPurposeCode));
                    cmd.Parameters.Add(new SqlParameter("@UnitOfMeasurement", unitOfMeasurement));
                    cmd.Parameters.Add(new SqlParameter("@ServiceDeliveryPoint", ServiceDeliveryPoint));
                    cmd.Parameters.Add(new SqlParameter("@PTDLoop", PTDLoop));
                    cmd.Parameters.Add(new SqlParameter("@UsageType", usageType));
                    cmd.Parameters.Add(new SqlParameter("@HistoricalSection", historicalSection == null ? string.Empty : historicalSection));

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
                }
            }
            return ds;
        }
        /// <summary>
        /// TFS68346- MTJ-06/29/2015- Invoke the new StoredProcedure to Update the USage Quantities after the parsing process
        /// </summary>
        /// <param name="dtProcessTime"></param>
        /// <returns></returns>
        public static void UpdateUsageQuantity(int ediFilelogId)
        {

            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_EdiUsageQuantityUpdate";
                    cmd.Connection = con;

                    cmd.Parameters.Add(new SqlParameter("EdiFileLogID", ediFilelogId));

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                }
            }

        }
        /// <summary>
        /// TFS68346- Manoj-6/29/2015-Invoke the new StoredProcedure to Update Meter number for Specific USage record
        /// </summary>
        /// <param name="dtProcessTime"></param>
        /// <returns></returns>
        public static void EdiUsageUpdateMeterNumber(int Id, string meterNumber, int usageType, int ediFileLogId)
        {

            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_EdiUsageUpdateMeterNumber";
                    cmd.Connection = con;

                    cmd.Parameters.Add(new SqlParameter("ID", Id));
                    cmd.Parameters.Add(new SqlParameter("MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("UsageType", usageType));
                    cmd.Parameters.Add(new SqlParameter("EdiFileLogId", ediFileLogId));

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                }
            }

        }
        /// <summary>
        /// TFS68346- Manoj-6/29/2015-Invoke the new StoredProcedure to Update Meter number for Specific USage record
        /// </summary>
        /// <param name="dtProcessTime"></param>
        /// <returns></returns>
        public static void EdiUsageDupUpdateMeterNumber(int Id, string meterNumber, int usageType, int ediFileLogId)
        {

            using (SqlConnection con = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_EdiUsageDupUpdateMeterNumber";
                    cmd.Connection = con;

                    cmd.Parameters.Add(new SqlParameter("ID", Id));
                    cmd.Parameters.Add(new SqlParameter("MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("UsageType", usageType));
                    cmd.Parameters.Add(new SqlParameter("EdiFileLogId", ediFileLogId));

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                }
            }

            }

        /// <summary>
        /// PBI-82454- Manoj-8/01/2015-Invoke the new StoredProcedure to update the APH records
        /// </summary>
        /// <param name="accountNumber"></param>
        /// <param name="utilityCode"></param>
        /// <param name="insertFlag"></param>
        /// <returns></returns>
        public static DataSet AccountPropertyHistoryWatchdogInsertFromQuerysV4(string accountNumber, string utilityCode, int insertFlag)
        {
            try
            {
                DataSet ds = new DataSet();

                using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = cn;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "usp_AccountPropertyHistoryInsertFromQuerysV4";

                        cmd.Parameters.Add(new SqlParameter("@p_AccountNumber", accountNumber));
                        cmd.Parameters.Add(new SqlParameter("@p_UtilityCode", utilityCode));
                        cmd.Parameters.Add(new SqlParameter("@p_FlagInsert", insertFlag));

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            da.Fill(ds);
                        }
                    }
                }
                return ds;
            }
            catch (Exception exc)
            {
                throw exc;
            }
        }

        public static void InsertEdiAccountLog(DataTable dt)
		{
            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
			{
				conn.Open();
                using (SqlBulkCopy copy = new SqlBulkCopy(conn))
				{
                    copy.ColumnMappings.Add("EdiProcessLogID", "EdiProcessLogID");
                    copy.ColumnMappings.Add("AccountNumber", "AccountNumber");
                    copy.ColumnMappings.Add("DunsNumber", "DunsNumber");
                    copy.ColumnMappings.Add("Information", "Information");
                    copy.ColumnMappings.Add("Severity", "Severity");
                    copy.ColumnMappings.Add("TimeStamp", "TimeStamp");

					copy.DestinationTableName = "dbo.EdiAccountLog";
					copy.BatchSize = 100000;
                    copy.WriteToServer(dt);
                }
            }
        }
        /// <summary>
        /// GetIUM Users
        /// Changed by : Mudit Vajpayee
        /// Changed Date : 07/01/2015
        /// PBI # : 77878
        /// </summary>

        public static DataSet GetUsers()
        {
            DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_UsersGet";
                    cmd.Connection = cn;



                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
            return ds;
		}

		public static DataSet GetzAuditIdrAccountStageInfo()
		{
			DataSet ds = new DataSet();

            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_zAuditIdrAccountStageInfoSelect";
					cmd.Connection = cn;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(ds);
				}
			}
			return ds;
		}

        public static void InsertZAuditIdrAccountStageInfo(int Id, string accountNumber, string utilityCode, string stage, int status, string notes,
			int changeType, DateTime changeDate, int changeBy, string changeLocation)
		{
            using (SqlConnection cn = new SqlConnection(Helper.ConnectionString))
			{
                using (SqlCommand cmd = new SqlCommand())
				{
					cn.Open();
					cmd.Connection = cn;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.CommandText = "usp_zAuditIdrAccountStageInfoInsert";

                    cmd.Parameters.Add(new SqlParameter("@Id", Id));
                    cmd.Parameters.Add(new SqlParameter("@AccountNumber", accountNumber));
                    cmd.Parameters.Add(new SqlParameter("@UtilityCode", utilityCode));
                    cmd.Parameters.Add(new SqlParameter("@Stage", stage));
                    cmd.Parameters.Add(new SqlParameter("@Status", status));
                    cmd.Parameters.Add(new SqlParameter("@Notes", notes));
                    cmd.Parameters.Add(new SqlParameter("@ChangeType", changeType));
                    cmd.Parameters.Add(new SqlParameter("@ChangeDate", changeDate));
                    cmd.Parameters.Add(new SqlParameter("@ChangeBy", changeBy));
                    cmd.Parameters.Add(new SqlParameter("@ChangeLocation", changeLocation));

					cmd.ExecuteNonQuery();
				}
			}
        }

        public static DataSet GetIDRMeterReads(string account, string meterNumber, DateTime from, DateTime to)
        {
            DataSet ds1 = new DataSet();

            using (SqlConnection conn = new SqlConnection(Helper.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "usp_GetIDRMeterUsage";
                    cmd.Connection = conn;

                    cmd.Parameters.Add(new SqlParameter("AccountNumber", account));
                    cmd.Parameters.Add(new SqlParameter("MeterNumber", meterNumber));
                    cmd.Parameters.Add(new SqlParameter("BeginDate", from));
                    cmd.Parameters.Add(new SqlParameter("EndDate", to));

                    using (SqlDataAdapter da1 = new SqlDataAdapter(cmd))
                    {
                        da1.Fill(ds1);
                    }
                }
            }

            return ds1;
		}
	}

}

