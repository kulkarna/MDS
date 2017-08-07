using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace UtilityManagement.FileUploadProcessors
{
    public class UtilityCompanyFileEntity
    {
        #region public properties
        public string Title { get; set; }
        public Guid Id { get; set; }
        public int UI { get; set; }
        public string UC { get; set; }
        public string UN { get; set; }
        public string Iso { get; set; }
        public string Mkt { get; set; }
        public string PDN { get; set; }
        public string LEI { get; set; }
        public string US { get; set; }
        public int ELD { get; set; }
        public string BT { get; set; }
        public int AL { get; set; }
        public string ANP { get; set; }
        public bool PO { get; set; }
        public bool MNR { get; set; }
        public bool MNL { get; set; }
        public bool EC { get; set; }
        public string UPN { get; set; }
        public bool Inctv { get; set; }
        public string CrtBy { get; set; }
        public DateTime CrtDt { get; set; }
        public string LstModBy { get; set; }
        public DateTime LstModDt { get; set; }
        #endregion

        public bool AreDataElementsValid(string[] dataElements)
        {
            if(dataElements != null && dataElements.Length == 23)
            {
                bool isValid = false;
                foreach(string element in dataElements)
                {
                    isValid = string.IsNullOrWhiteSpace(element);
                    if(!isValid)
                        return isValid;
                }
                //if(Utilities.Common.IsValidGuid(Utilities.Common.NullSafeGuid(dataElements[0])) && 
                //    int.TryParse(dataElements[1], out UI) 
                //    )
                //{
                //}
            }
            return false;
        }
    }

    public class UtilityCompanyFileProcessor
    {
        #region public constants
        public const string TITLE = "Id,UI,UC,UN,Iso,Mkt,PDN,LEI,US,ELD,BT,AL,ANP,PO,MNR,MNL,EC,UPN,Inctv,CrtBy,CrtDate,LstModBy,LstModDt";
        #endregion



        //public void ProcessElements(string dataElement)
        //{
        //    string[] dataElements = dataElement.Split(',');
        //    UtilityCompanyFileEntity utilityCompanyFileEntity =  new UtilityCompanyFileEntity();
        //    if(utilityCompanyFileEntity.AreDataElementsValid(dataElements))
        //    {
        //        utilityCompanyFileEntity.PopulateFileEntityByDataElements(dataElements);
        //    }
        //}


        public bool IsTitleValid(string title)
        {
            return 
                !string.IsNullOrWhiteSpace(title) && 
                TITLE.Trim().ToLower() == title.Trim().ToLower();
        }

        //public bool IsIdValid()

        public void ProcessFile(HttpPostedFileBase file, string serverPath)
        {
            if (file.ContentLength > 0)
            {
                Stream stream = null;
                string fileName = Path.GetFileName(file.FileName);
                string path = Path.Combine(serverPath, fileName);
                file.InputStream.CopyTo(stream);
                StreamReader streamReader = new StreamReader(stream);
                bool isFirstTimeThrough = true;
                foreach (var line in streamReader.ReadLine())
                {
                    if (isFirstTimeThrough)
                    {

                    }
                    isFirstTimeThrough = false;
                }
            }
        }
    }
}