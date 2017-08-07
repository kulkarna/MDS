namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.MarketManagement.UtilityManagement;
    using LibertyPower.DataAccess.SqlAccess.CommonSql;
    using LibertyPower.DataAccess.SqlAccess.LibertyPowerSql;

    public static class ProspectAccountCandidateFactory
    {
        #region Methods

        public static ProspectAccountCandidateCollection UpgradeUtilityAccountList(UtilityAccountList list)
        {
            ProspectAccountCandidateCollection upgrade = null;
            foreach (LibertyPower.Business.MarketManagement.UtilityManagement.UtilityAccount account in list)
            {
                try
                {
                    ProspectAccountCandidate a = (ProspectAccountCandidate)account;
                    if (upgrade == null)
                        upgrade = new ProspectAccountCandidateCollection();
                    upgrade.Add(a);
                }
                catch { return null; }
            }
            return upgrade;
        }

        internal static ProspectAccountCandidate GetProspectAccountCandidate(int excelRowNumber)
        {
            return new ProspectAccountCandidate(excelRowNumber);
        }

        internal static ProspectAccountCandidate GetProspectAccountCandidate(int excelRowNumber, string sheetName)
        {
            return new ProspectAccountCandidate(excelRowNumber, sheetName);
        }


        #endregion Methods
    }
}