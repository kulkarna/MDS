using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OrdersAPITests
{
    /*
    public class AgentProfile
    {
        private static CommonServicesAPI.CommonServicesClient CommonClient = new CommonServicesAPI.CommonServicesClient();
        //public static PricingServicesAPI.PricingServicesClient PricingClient = new PricingServicesAPI.PricingServicesClient();


        public string SalesRepName { get; }
        public string UserLogin { get; }


        public CommonServicesAPI.WSSalesChannel salesChannel;
        public CommonServicesAPI.WSSalesChannel SalesChannel { get { return this.salesChannel; } }

        private CommonServicesAPI.WSSalesChannelUser portalUser;
        public CommonServicesAPI.WSSalesChannelUser PortalUser { get { return this.portalUser; } }


        private int salesChannelId = 0;
        private string salesChannelCode = "";
        private string userLogin = "";


        private AgentProfile( int salesChannelId, string salesChannelCode, string userLogin )
        {
            this.salesChannelCode = salesChannelCode;
            this.salesChannelId = salesChannelId;
            this.userLogin = userLogin;
            LoadData();
        }


        public AgentProfile( int salesChannelId )
            : this( salesChannelId, "", "" )
        {

        }

        public AgentProfile( string salesChannelCode )
            : this( 0, salesChannelCode, "" )
        {

        }

        private void LoadData()
        {
            this.LoadPortalUserData();
            this.LoadSalesChannelData();
        }

        private void LoadPortalUserData()
        {
            CommonServicesAPI.WSSalesChannelUserResult res = CommonClient.GetSalesChannelUser( this.userLogin );
            if (!res.HasErrors)
            {
                this.portalUser = res.SalesChannelUsers.FirstOrDefault();
            }
        }

        private void LoadSalesChannelData()
        {

            //CommonServicesAPI.WSSalesChannel res = CommonClient.GetSalesChannelUser( this.userLogin );
            //if (!res.HasErrors)
            //{
            //    this.portalUser = res.SalesChannelUsers.FirstOrDefault();
            //}
        }

    }
     * */
}
