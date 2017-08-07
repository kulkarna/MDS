using System.Collections.Generic;

namespace LibertyPower.RepositoryManagement.Core.AccountManagement
{
    public class ServiceAccountProperties
    {
        public string Utility { get; set; }
        public string AccountNumber { get; set; }

        private List<ServiceAccountProperty> properties = new List<ServiceAccountProperty>();
        public List<ServiceAccountProperty> Properties
        {
            get { return properties; }
            set { properties = value; }
        }

        public override string ToString()
        {
            System.Text.StringBuilder propertiesStringBuilder = new System.Text.StringBuilder();
            if (Properties != null && Properties.Count > 0)
            {
                foreach (ServiceAccountProperty serviceAccountProperty in Properties)
                {
                    propertiesStringBuilder.Append(string.Format("ServiceAccountProperty[{0}],", serviceAccountProperty));
                }
            }

            string returnValue = string.Format("ServiceAccountProperties[Utility:{0},AccountNumber:{1},Properties:[{2}]]", Utility, AccountNumber, propertiesStringBuilder);
            return base.ToString();
        }
    }
}