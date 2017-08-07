using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.AccountManagement
{
	public class ProductEligibilityCheckState : IEtfState
	{

		public ProductEligibilityCheckState()
			: base( EtfState.ProductEligibilityCheck )
		{

		}

		public override void Process( EtfContext context )
		{
            DataSet ds = LibertyPower.DataAccess.SqlAccess.LibertyPowerSql.CRMLibertyPowerSql.GetAccountContractRatesByAccountContractNumber(context.CompanyAccount.AccountNumber, context.CompanyAccount.ContractNumber);

            string productID = context.CompanyAccount.Product.ProductId;
            bool isContractedRate = true;

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    string product = "";
                    if (dr["LegacyProductId"] != DBNull.Value)
                    {
                        product = dr["LegacyProductId"].ToString().Trim().ToUpper();
                    }

                    if (!String.IsNullOrEmpty(product) && product.Contains(productID.ToUpper()))
                    {
                        if (dr["IsContractedRate"] != DBNull.Value && !Convert.ToBoolean(dr["IsContractedRate"]))
                        {
                            isContractedRate = false;
                        }
                    }
                }
            }

			//if ( context.CompanyAccount.Product.EtfDisabled )
            if (!isContractedRate)
            {
                context.CompanyAccount.Etf.EtfState = EtfState.EtfCompleted;

                // This will be later on replaced by a database driven rules solution
                // This is the bare minimum to satisfy INF93-CR1			
                if (context.CompanyAccount.RetailMarketCode.ToUpper() == "TX")
                {
                    context.CompanyAccount.Etf.ErrorMessage = "Texas Default Variable Products are excluded from ETF calculations.";
                }
                else if (context.CompanyAccount.RetailMarketCode.ToUpper() != "TX")
                {
                    context.CompanyAccount.Etf.ErrorMessage = "ETF Calculations for Default Variable Products are currently disabled.";
                    CompanyAccountFactory.InsertComment(context.CompanyAccount.Identifier, "ETF Calculation", "ETF Calculations for Default Variable Products are currently disabled.", "SYSTEM");
                }
                else if (productID.Contains("_FS"))
                {
                    context.CompanyAccount.Etf.ErrorMessage = "FREEDOM TO SAVE products are not subject to ETF.";
                }
                else
                {
                    context.CompanyAccount.Etf.ErrorMessage = "ETF Calculations for " + context.CompanyAccount.Product.Description + " are currently disabled.";
                }

                context.CompanyAccount.Etf.EtfEndStatus = EtfEndStatus.IneligibleProduct;
                context.CurrentIEtfState = new EtfCompletedState();
            }
            else
            {
                context.CurrentIEtfState = new EtfCalculatingState();
            }

		}

	}
}
