using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Security.Cryptography;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.OnlineDataSynchronization
{
    /// <summary>
    /// Data contract representing all the metadata for a document
    /// </summary>
    [DataContract]
    public class TabletDocument : IEquatable<TabletDocument>
    {

        private string hash = "";
        private DateTime? modifiedDate = DateTime.Now;
        private int documentID = 0;
        private byte[] fileBytes = null;
        
                
        /// <summary>
        /// Gets or sets the document id.
        /// </summary>
        [DataMember]
        public int DocumentID
        {
            get { return documentID; }
            set
            {
                this.documentID = value;
                this.CreateHash();
            }
        }


        [DataMember]
        public DateTime? EffectiveStartDate { get; set; }

        [DataMember]
        public DateTime? EffectiveEndDate { get; set; }
        /// <summary>
        /// Gets or sets the file name.
        /// </summary>
        [DataMember]
        public string FileName { get; set; }

        /// <summary>
        /// Gets or sets the associated document type id.
        /// </summary>
        [DataMember]
        public int? DocumentTypeID { get; set; }

        /// <summary>
        /// Gets or sets the document orientation.
        /// </summary>
        [DataMember]
        public string DocOrientation { get; set; }

        /// <summary>
        /// Gets or sets the record modified date.
        /// </summary>
        [DataMember]
        public DateTime? ModifiedDate
        {
            get { return modifiedDate; }
            set
            {
                this.modifiedDate = value;
                CreateHash();
            }
        }

        /// <summary>
        /// Gets or sets the document version number
        /// </summary>
        [DataMember]
        public string DocumentVersion { get; set; }

        /// <summary>
        /// Gets or sets the associated language id.
        /// </summary>
        [DataMember]
        public int? LanguageID { get; set; }

        /// <summary>
        /// Gets the unique hash checksum for the current document version
        /// </summary>
        /// <remarks>The md5 hash is based on the unique document id and current modified date string values</remarks>
        [DataMember]
        public string Hash
        {
            get
            {
                return this.hash;
            }
            set
            {
                this.hash = value;
            }
        }

        private void CreateHash()
        {
            this.hash = (this.documentID.ToString() + this.modifiedDate.ToString()).MD5Hash();
        }


        [System.Runtime.Serialization.DataMember]
        public byte[] FileBytes
        {
            get
            {
                return fileBytes;
            }
            set
            {
                fileBytes = value;
            }
        }


        private string Domain
        {
            get
            {
                if (TabletDocument.IsGenieDocument(this.DocumentID))
                    return TabletDocument.GetConfigSetting(TabletDocument.GenieDomainConfigSetting);

                return TabletDocument.GetConfigSetting(TabletDocument.TabletRepositoryDomainConfigSetting);
            }
        }

        private string Username
        {
            get
            {
                if (TabletDocument.IsGenieDocument(this.DocumentID))
                    return TabletDocument.GetConfigSetting(TabletDocument.GenieUsernameConfigSetting);

                return TabletDocument.GetConfigSetting(TabletDocument.TabletRepositoryUsernameConfigSetting);
            }
        }
        private string Password
        {
            get
            {
                if (TabletDocument.IsGenieDocument(this.DocumentID))
                    return TabletDocument.GetConfigSetting(TabletDocument.GeniePasswordConfigSetting);

                return TabletDocument.GetConfigSetting(TabletDocument.TabletRepositoryPasswordConfigSetting);
            }
        }

        /// <summary>
        /// This business rule will check whether the DocumentID passed is a Flyer or Genie Document by checking
        /// if id is >1000000 then it is a Flyer Document else it is a Genie Document
        /// </summary>
        /// <param name="documentID"></param>
        /// <returns></returns>
        public static bool IsGenieDocument(int documentId)
        {
            if (documentId > 1000000)
                return false;

            return true;
        }


        /// <summary>
        /// This will try to get the file from the network location, it will populate the FileBytes property with the contents of the file
        /// </summary>
        /// <returns></returns>
        public bool RetrieveTabletFile(string basePath)
        {
            byte[] buffer = null;
            string filePath="";

            if (TabletDocument.IsGenieDocument(this.DocumentID))
                filePath = System.IO.Path.Combine(TabletDocument.GetBasePath(), this.FileName);
            else
                filePath = System.IO.Path.Combine(basePath, this.FileName);
               
            
      WrapperImpersonationContext context = new WrapperImpersonationContext(this.Domain, this.Username, this.Password);
                context.Enter();
                // Execute code under other uses context
                //Console.WriteLine(“Current user: “ + WindowsIdentity.GetCurrent().Name);

                if (!File.Exists(filePath))
                {
                    string errMessage = string.Format("Could not find the file: {0} or username: {1} does not have valid permissions to read the file.", filePath, this.Username);
                    context.Leave();
                    throw new FileNotFoundException(errMessage);
                }

                try
                {
                    /* Once valid Template requested from right device then read the file and return the byte[]*/
                    using (System.IO.FileStream fs = new System.IO.FileStream(filePath, System.IO.FileMode.Open, System.IO.FileAccess.Read,
                                                            System.IO.FileShare.Read))
                    {
                        buffer = new byte[fs.Length];
                        fs.Read(buffer, 0, (int)fs.Length);
                    }
                    this.FileBytes = buffer;
                }
                catch (Exception ex)
                {
                    Exception newEx = new Exception("Error while trying to read the APK file, see Inner Exception for details", ex);
                    throw newEx;
                }
                finally
                {
                    context.Leave();
                }
            return true;
        }

        private static string GenieFilePathConfigSetting = "GenieTemplateFilePath";
        private static string GenieUsernameConfigSetting = "GenieUsername";
        private static string GeniePasswordConfigSetting = "GeniePassword";
        private static string GenieDomainConfigSetting = "GenieDomain";
        private static string TabletRepositoryUsernameConfigSetting = "TabletRepositoryUsername";
        private static string TabletRepositoryPasswordConfigSetting = "TabletRepositoryPassword";
        private static string TabletRepositoryDomainConfigSetting = "TabletRepositoryDomain";


        private static string GetBasePath()
        {
            string path = string.Empty;
            if (System.Configuration.ConfigurationManager.AppSettings.AllKeys.Contains(GenieFilePathConfigSetting))
            {
                path = System.Configuration.ConfigurationManager.AppSettings[GenieFilePathConfigSetting].ToString();
            }
            else
            {
                throw new MissingFieldException("Could not find Application Configuration setting: " + GenieFilePathConfigSetting + " that points to the network location to find the Genie Template files");
            }
            return path;
        }

        private static string GetConfigSetting(string configSetting)
        {
            string result = string.Empty;
            if (System.Configuration.ConfigurationManager.AppSettings.AllKeys.Contains(configSetting))
            {
                result = System.Configuration.ConfigurationManager.AppSettings[configSetting].ToString();
            }
            else
            {
                throw new MissingFieldException("Could not find Application Configuration setting: " + configSetting);
            }
            return result;
        }



        public bool Equals(TabletDocument other)
        {
            return other != null && this.DocumentID == other.DocumentID &&
                this.Hash == other.Hash &&
                this.LanguageID == other.LanguageID &&
                this.DocumentTypeID == other.DocumentTypeID &&
                this.DocumentVersion == other.DocumentVersion &&
                this.DocOrientation == other.DocOrientation;
        }
        public override int GetHashCode()
        {
            return this.DocumentID.GetHashCode();
        }
        public override bool Equals(object obj)
        {
            return this.Equals((TabletDocument)obj);
        }
    }
}
