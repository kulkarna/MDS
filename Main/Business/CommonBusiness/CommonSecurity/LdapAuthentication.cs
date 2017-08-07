using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Collections;
using System.DirectoryServices;

namespace LibertyPower.Business.CommonBusiness.SecurityManager
{
    public class LdapAuthentication
    {
        #region Fields

        private string _filterAttribute;
        private string _path;

        #endregion Fields

        #region Constructors

        public LdapAuthentication(string path)
        {
            _path = path;
        }

        #endregion Constructors

        #region Methods

        public string GetGroups()
        {
            var search = new DirectorySearcher(_path);
            search.Filter = "(cn=" + _filterAttribute + ")";
            search.PropertiesToLoad.Add("memberOf");
            var groupNames = new StringBuilder();

            try
            {
                SearchResult result = search.FindOne();
                int propertyCount = result.Properties["memberOf"].Count;

                string dn = null;
                object equalsIndex = null;
                object commaIndex = null;

                int propertyCounter = 0;

                for (propertyCounter = 0; propertyCounter < propertyCount; propertyCounter++)
                {
                    dn = Convert.ToString(result.Properties["memberOf"][propertyCounter]);

                    equalsIndex = dn.IndexOf("=", 1);
                    commaIndex = dn.IndexOf(",", 1);
                    if ((int)equalsIndex == -1)
                    {
                        return null;
                    }

                    groupNames.Append(dn.Substring(((int)equalsIndex + 1), ((int)commaIndex - (int)equalsIndex) - 1));
                    groupNames.Append("|");
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error obtaining group names. " + ex.Message);
            }

            return groupNames.ToString();
        }

        public bool IsAuthenticated(string domain, string username, string pwd)
        {
            string domainAndUsername = domain + "\\" + username;
            var entry = new DirectoryEntry(_path, domainAndUsername, pwd);
            entry.Username = username;
            entry.Password = pwd;

            try
            {
                //Bind to the native AdsObject to force authentication.
                object obj = entry.NativeObject;
                var search = new DirectorySearcher(entry);

                search.Filter = "(SAMAccountName=" + username + ")";
                search.PropertiesToLoad.Add("cn");
                SearchResult result = search.FindOne();

                if (result == null)
                {
                    return false;
                }

                IEnumerator enumerator = result.Properties.PropertyNames.GetEnumerator();
                while (enumerator.MoveNext())
                {
                    var prop = (string)enumerator.Current;
                }

                //Update the new path to the user in the directory.
                _path = result.Path;
                _filterAttribute = Convert.ToString(result.Properties["cn"][0]);
            }
            catch
            {
                return false;
            }

            return true;
        }

        #endregion Methods
    }
}
