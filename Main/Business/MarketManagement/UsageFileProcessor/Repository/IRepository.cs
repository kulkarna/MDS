using LibertyPower.Business.MarketManagement.UtilityManagement;
using UsageFileProcessor.Entities;

namespace UsageFileProcessor.Repository
{
    public interface IRepository
    {

        int InsertAccount(ParserAccount account);


        void InsertUsage(int fileAccountId, Usage usage);


        void InsertAddresses(int fileAccountId, ParserAccount account);
    }
}