using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;
using LibertyPower.Business.CustomerManagement.AccountManagement;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    /*  
        Created on:     22 Dec 2015
        Modified by:    Manish Pandey
        Discription:    To Create Do Not Knock Method.
    */
    public class DoNotKnockFactory
    {
        /*  
           Created on:     22 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Get Do Not Knock List.
        */
        /*  
           Modified on:     16 June 2015
           Modified by:    Raul Castellanos
        */
        public static DataSet GetDoNotKnockList(string FirstName, string LastName,
                string Company, string TelephoneNumber, string State, string ZipCode, string ActiveInactive,
                string OrderBY, int pageSize, int CurrentpageIndex, out int totalCount, int? IsImport = 0, string DoNotKnockID = "", string OrderExp = "Desc")
        {
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetDoNotKnockList(FirstName, LastName,
                Company, TelephoneNumber, State, ZipCode, ActiveInactive, OrderBY, pageSize, CurrentpageIndex, IsImport, DoNotKnockID, OrderExp);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0 && IsImport != 1)
            {
                totalCount = ds.Tables[0].Rows[0].Field<int>("TotalRecords");
            }
            else
                totalCount = 0;
            return ds;
        }

        public static DataSet GetDoNotKnockList(int salesChannelId, string lastModifiedDate = null)
        {
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetDoNotKnockListWithAuthorizedMarkets(salesChannelId, lastModifiedDate);
            return ds;
        }

        /*  
           Created on:     29 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Get Company List.
        */
        public static DataSet GetCompanyData(string Company)
        {
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetCompanyData(Company);
            return ds;
        }

        /*  
           Created on:     29 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Get State List.
        */
        public static DataSet GetStateData(string State)
        {
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetStateData(State);
            return ds;
        }

        /*  
           Created on:     29 Dec 2015
           Modified by:    Manish Pandey
           Discription:    To Get ZipCode List.
        */
        

        public static DataSet GetZipCodeData(string ZipCode)
        {
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetZipCodeData(ZipCode);
            return ds;
        }
        public static int InsertDoNotKnockList(List<DoNotKnock> DoNotKnockList, out DataTable DoNotKnockDt, bool? ValidationRequired = true, int? ErrorCode = 0)
        {
            DataTable dt = new DataTable();
            dt = ConvertListIntoDataset(DoNotKnockList);

            return DoNotKnockSQL.InsertDoNotKnockList(dt, out DoNotKnockDt, ValidationRequired, ErrorCode);
        }

        /*
         * Created on: 6 May 2016
         * Modified By: Raul Castellanos
         * Description: To Insert/Update do_not_knock item
         */
        public static int SaveDoNotKnock(DoNotKnock doNotKnock,bool insert,bool validate)
        {
            if (insert)
                return DoNotKnockSQL.InsertDoNotKnockValidate(MapToDoNotKnock(doNotKnock),validate);
            else
            {
                doNotKnock.EditedDate = DateTime.Now;
                return DoNotKnockSQL.UpdateDoNotKnockValidate(MapToDoNotKnock(doNotKnock),validate);
            }
        }

        public static DoNotKnock GetPreviusDoNotKnock(DoNotKnock newDoNotKnock, bool update)
        {
            LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.DoNotKnock oldDnk =  DoNotKnockSQL.IsDoNotKnockInTheSystem(MapToDoNotKnock(newDoNotKnock), update);
            if (oldDnk != null)
                return MapToClientDoNotKnock(oldDnk);
            else
                return null;


        }

        public static DoNotKnock SearchDoNotKnock(DoNotKnock newDoNotKnock, bool update,bool status)
        {
            LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.DoNotKnock oldDnk = DoNotKnockSQL.IsDoNotKnockInTheSystemByStatus(MapToDoNotKnock(newDoNotKnock), update,status);
            if (oldDnk != null)
                return MapToClientDoNotKnock(oldDnk);
            else
                return null;


        }

        public static bool IsInSystem(string firstName, string lastName, string phoneNumber,string streetAddress)
        {
            return DoNotKnockSQL.IsInTheSystem(firstName, lastName, phoneNumber, streetAddress);
        }

        public static DoNotKnock GetDoNotKnockById(int id)
        {
            LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.DoNotKnock dnk = DoNotKnockSQL.GetDoNotKnockById(id);
            if (dnk != null)
                return MapToClientDoNotKnock(dnk);
            else
                return null;


        }

        public static int SaveDoNotKnockList(List<DoNotKnock> DoNotKnockList, out DataTable DoNotKnockDt, bool? ValidationRequired = true, int? ErrorCode = 0)
        {
            DataTable dt = new DataTable();
            dt = ConvertListIntoDataset(DoNotKnockList);

            return DoNotKnockSQL.SaveDoNotKnockList(dt, out DoNotKnockDt, ValidationRequired, ErrorCode);

        }

        /*
         * Created on: 6 May 2016
         * Modified By: Raul Castellanos
         * Description: To map to LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.DoNotKnock do_not_knock item
         */
        private static LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.DoNotKnock MapToDoNotKnock(DoNotKnock doNotKnock)
        {
            LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.DoNotKnock newDoNotKnock = new LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.DoNotKnock();
            if (doNotKnock.ActiveOrInactive == "1")
                newDoNotKnock.ActiveOrInactive = true;
            else
                newDoNotKnock.ActiveOrInactive = false;
            newDoNotKnock.AptOrUnitNumber = doNotKnock.AptOrUnitNumber;
            newDoNotKnock.City = doNotKnock.City;
            newDoNotKnock.Comments = doNotKnock.Comments;
            newDoNotKnock.Company = doNotKnock.Company;
            newDoNotKnock.DoNotKnockID = doNotKnock.DoNotKnockID;
            newDoNotKnock.EditedBy = doNotKnock.EditedBy;
            newDoNotKnock.EditedDate = doNotKnock.EditedDate;
            newDoNotKnock.EffectiveDate = doNotKnock.EffectiveDate;
            newDoNotKnock.FirstName = doNotKnock.FirstName;
            newDoNotKnock.LastName = doNotKnock.LastName;
            newDoNotKnock.NameofAptComplex = doNotKnock.NameofAptComplex;
            newDoNotKnock.PhoneNumber = doNotKnock.PhoneNumber;
            if (doNotKnock.RegulatoryComplaint == "1")
                newDoNotKnock.RegulatoryComplaint = true;
            else
                newDoNotKnock.RegulatoryComplaint = false;
            newDoNotKnock.State = doNotKnock.State;
            newDoNotKnock.StreetAddress = doNotKnock.StreetAddress;
            newDoNotKnock.ZipCode = doNotKnock.ZipCode;
            return newDoNotKnock;
        }

        private static DoNotKnock MapToClientDoNotKnock(LibertyPower.DataAccess.SqlAccess.CustomerManagementEF.DoNotKnock doNotKnock)
        {
            DoNotKnock newDoNotKnock = new DoNotKnock();
            if (doNotKnock.ActiveOrInactive.Value)
                newDoNotKnock.ActiveOrInactive = "1";
            else
                newDoNotKnock.ActiveOrInactive = "0";
            newDoNotKnock.AptOrUnitNumber = doNotKnock.AptOrUnitNumber;
            newDoNotKnock.City = doNotKnock.City;
            newDoNotKnock.Comments = doNotKnock.Comments;
            newDoNotKnock.Company = doNotKnock.Company;
            newDoNotKnock.DoNotKnockID = doNotKnock.DoNotKnockID;
            newDoNotKnock.EditedBy = doNotKnock.EditedBy.Value;
            newDoNotKnock.EditedDate = doNotKnock.EditedDate;
            newDoNotKnock.EffectiveDate = doNotKnock.EffectiveDate;
            newDoNotKnock.FirstName = doNotKnock.FirstName;
            newDoNotKnock.LastName = doNotKnock.LastName;
            newDoNotKnock.NameofAptComplex = doNotKnock.NameofAptComplex;
            newDoNotKnock.PhoneNumber = doNotKnock.PhoneNumber;
            if (doNotKnock.RegulatoryComplaint.Value)
                newDoNotKnock.RegulatoryComplaint = "1";
            else
                newDoNotKnock.RegulatoryComplaint = "0";
            newDoNotKnock.State = doNotKnock.State;
            newDoNotKnock.StreetAddress = doNotKnock.StreetAddress;
            newDoNotKnock.ZipCode = doNotKnock.ZipCode;
            return newDoNotKnock;
        }

        private static void MapDataRowToDoNotKnock(DataRow dataRow, DoNotKnock DataObj)
        {
            DataObj.DoNotKnockID = dataRow.Field<int>("DoNotKnockID");
            DataObj.EffectiveDate = dataRow.Field<DateTime>("EffectiveDate");
            DataObj.FirstName = dataRow.Field<string>("FirstName");
            DataObj.LastName = dataRow.Field<string>("LastName");
            DataObj.StreetAddress = dataRow.Field<string>("StreetAddress");
            DataObj.AptOrUnitNumber = dataRow.Field<string>("AptOrUnitNumber");
            DataObj.City = dataRow.Field<string>("City");
            DataObj.State = dataRow.Field<string>("State");
            DataObj.ZipCode = dataRow.Field<string>("ZipCode");
            DataObj.PhoneNumber = dataRow.Field<string>("PhoneNumber");
            DataObj.NameofAptComplex = dataRow.Field<string>("NameofAptComplex");
            DataObj.Company = dataRow.Field<string>("Company");
            DataObj.RegulatoryComplaint = (dataRow.Field<string>("RegulatoryComplaint"));
            DataObj.ActiveOrInactive = dataRow.Field<string>("ActiveOrInactive");
            DataObj.Comments = dataRow.Field<string>("Comments");
            DataObj.EditedBy = dataRow.Field<int>("EditedBy");
            //DataObj.EditedDate = dataRow.Field<DateTime>("EditedDate");

        }
        public static DataTable ConvertListIntoDataset(List<DoNotKnock> records)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("DoNotKnockID", typeof(int));
            dt.Columns.Add("EffectiveDate", typeof(DateTime));
            dt.Columns.Add("FirstName", typeof(string));
            dt.Columns.Add("LastName", typeof(string));
            dt.Columns.Add("StreetAddress", typeof(string));
            dt.Columns.Add("AptOrUnitNumber", typeof(string));
            dt.Columns.Add("City", typeof(string));
            dt.Columns.Add("State", typeof(string));
            dt.Columns.Add("ZipCode", typeof(string));
            dt.Columns.Add("PhoneNumber", typeof(string));
            dt.Columns.Add("NameofAptComplex", typeof(string));
            dt.Columns.Add("Company", typeof(string));
            dt.Columns.Add("RegulatoryComplaint", typeof(string));
            dt.Columns.Add("ActiveOrInactive", typeof(string));
            dt.Columns.Add("Comments", typeof(string));
            dt.Columns.Add("EditedBy", typeof(int));
            dt.Columns.Add("EditedDate", typeof(DateTime));

            foreach (DoNotKnock record in records)
            {
                dt.Rows.Add(record.DoNotKnockID, record.EffectiveDate, record.FirstName, record.LastName, record.StreetAddress, record.AptOrUnitNumber, record.City,
                    record.State, record.ZipCode, record.PhoneNumber, record.NameofAptComplex, record.Company, record.RegulatoryComplaint, record.ActiveOrInactive,
                    record.Comments, record.EditedBy, record.EditedDate);
            }
            return dt;
        }

        public static string ValidateForUpload(string effectiveDate, string firstName, string company, string address, string state)
        {
            string error = string.Empty;
            if (effectiveDate == null || effectiveDate == "")
                error += "</br>Effective Date can not be blank";
            if ((firstName == null || firstName == "") && (company == null || company == ""))
                error += "</br>First Name and Company both can not be blank";
            if (address == null || address == "")
                error += "</br>Address can not be blank";
            if (state == null || state == "")
                error += "</br>State can not be blank";
            return error;
        }

        public static DataTable ConvertIntoImportDataTable(DataTable importedRecords)
        { 
            DataTable dt = new DataTable();
            dt.Columns.Add("DoNotKnockID", typeof(int));
            dt.Columns.Add("EffectiveDate", typeof(DateTime));
            dt.Columns.Add("FirstName", typeof(string));
            dt.Columns.Add("LastName", typeof(string));
            dt.Columns.Add("StreetAddress", typeof(string));
            dt.Columns.Add("AptOrUnitNumber", typeof(string));
            dt.Columns.Add("City", typeof(string));
            dt.Columns.Add("State", typeof(string));
            dt.Columns.Add("ZipCode", typeof(string));
            dt.Columns.Add("PhoneNumber", typeof(string));
            dt.Columns.Add("NameofAptComplex", typeof(string));
            dt.Columns.Add("Company", typeof(string));
            dt.Columns.Add("RegulatoryComplaint", typeof(string));
            dt.Columns.Add("ActiveOrInactive", typeof(string));
            dt.Columns.Add("Comments", typeof(string));
            dt.Columns.Add("EditedBy", typeof(int));
            dt.Columns.Add("EditedDate", typeof(DateTime));
            dt.Columns.Add("Error", typeof(string));
            dt.Columns.Add("ShowData", typeof(int));
            dt.Columns.Add("IsCorrect", typeof(int));

            foreach (DataRow row in importedRecords.Rows)
            {
                string error = string.Empty;
                string firstName = row["First Name"].ToString();
                string lastName = row["Last Name"].ToString();
                string phoneNumber = row["Phone Number"].ToString();
                string company = row["Company"].ToString();
                string comment = row["Comments"].ToString();
                string effectiveDate = row["EffectiveDate"].ToString();
                string address = row["Street Address"].ToString();
                string state = row["State"].ToString();
                int showData = 1, isCorrect = 1;

                if ((firstName.ToLower().Equals("sample")) && (lastName.ToLower().Equals("sample")) && (phoneNumber.ToLower().Equals("999-999-999"))
                    && (company.ToLower().Equals("company test")) && (comment.ToLower().Equals("general comments")))
                {
                    error = "Sample file data";
                    showData = 0;
                    isCorrect = 0;
                }
                else
                {
                    error = ValidateForUpload(effectiveDate,firstName,company, address, state);
                    if(error == string.Empty)
                    {
                        if (DoNotKnockFactory.IsInSystem(firstName, lastName, phoneNumber, address))
                        {
                            error += "Entry exist in database.<br/>";
                            showData = 1;
                            isCorrect = 0;
                        }
                    }
                    else
                    {
                        showData = 1;
                        isCorrect = 0;
                    }

                }
                
                dt.Rows.Add(row["DoNotKnockID"],effectiveDate,firstName,lastName,address, row["Apt Or Unit Number"],
                row["City"],state,row["Zip Code"],phoneNumber, row["Name of Apt Complex"],company,row["Regulatory Complaint"],row["ActiveOrInactive"],
                comment,row["EditedBy"],  row["EditedDate"],error,showData,isCorrect);
            }
            return dt;
        }

        public static bool GetCompanyList(string Company, out List<DoNotKnock> reports)
        {
            reports = new List<DoNotKnock>();
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetCompanyData(Company);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    DoNotKnock DoNotKnock = new DoNotKnock();
                    MapDataRowToCompanies(row, DoNotKnock);
                    reports.Add(DoNotKnock);
                }
            }
            return true;
        }

        private static void MapDataRowToCompanies(DataRow dataRow, DoNotKnock DataObj)
        {
            DataObj.Company = dataRow.Field<string>("Company");

        }

        public static bool GetStateList(string State, out List<DoNotKnock> reports)
        {
            reports = new List<DoNotKnock>();
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetStateData(State);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    DoNotKnock DoNotKnock = new DoNotKnock();
                    MapDataRowToStates(row, DoNotKnock);
                    reports.Add(DoNotKnock);
                }
            }
            return true;
        }

        private static void MapDataRowToStates(DataRow dataRow, DoNotKnock DataObj)
        {
            DataObj.State = dataRow.Field<string>("State");

        }

        public static bool GetZipCodeList(string ZipCode, out List<DoNotKnock> reports)
        {
            reports = new List<DoNotKnock>();
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetZipCodeData(ZipCode);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {

                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    DoNotKnock DoNotKnock = new DoNotKnock();
                    MapDataRowToZipCodes(row, DoNotKnock);
                    reports.Add(DoNotKnock);
                }
            }
            return true;
        }

        private static void MapDataRowToZipCodes(DataRow dataRow, DoNotKnock DataObj)
        {
            DataObj.ZipCode = dataRow.Field<string>("ZipCode");

        }

        

        public static int GetDoNotKnockDetails(DataTable DoNotKnockDetails, out DataTable DoNotKnockDt, int? CurrentUserID)
        {
            DoNotKnockDetails.Columns.Add("ActiveOrInactive", typeof(System.Int32)).SetOrdinal(12);
            DoNotKnockDetails.Columns.Add("EditedBy");
            DoNotKnockDetails.Columns.Add("EditedDate");
            DoNotKnockDetails.Columns.Add("DoNotKnockID", typeof(System.Int32)).SetOrdinal(0);
            for (int i = 0; i <= DoNotKnockDetails.Rows.Count - 1; i++)
            {

                DoNotKnockDetails.Rows[i][0] = 0;
                string regulatoryComplaint = DoNotKnockDetails.Rows[i][12].ToString();
                if ((DoNotKnockDetails.Rows[i][1].ToString()).Trim() == "")
                {
                    DoNotKnockDetails.Rows[i][1] = null;
                }
                else
                {
                    DoNotKnockDetails.Rows[i][1] = Convert.ToDateTime(DoNotKnockDetails.Rows[i][1]);
                }

                if (regulatoryComplaint.ToUpper().Trim() == "YES")
                {
                    DoNotKnockDetails.Rows[i][12] = "1";
                }
                else
                {
                    DoNotKnockDetails.Rows[i][12] = "0";
                }

                DoNotKnockDetails.Rows[i]["ActiveOrInactive"] = "1"; //ACTIVE

                if (CurrentUserID != null)
                {
                    DoNotKnockDetails.Rows[i]["EditedBy"] = CurrentUserID;
                }

                DoNotKnockDetails.Rows[i]["EditedDate"] = DateTime.Now;

            }
            DoNotKnockDt = ConvertIntoImportDataTable(DoNotKnockDetails);
            //DataSet ds = new DataSet();
            //int retValue = DoNotKnockSQL.GetDoNotKnockDetails(DoNotKnockDetails, out DoNotKnockDt);


            return -2;
        }
        public static DataSet GetDoNotKnockHistory(string DoNotKnockID, out int totalCount)
        {
            DataSet ds = new DataSet();
            ds = DoNotKnockSQL.GetDoNotKnockHistory(DoNotKnockID);
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                totalCount = ds.Tables[0].Rows.Count;
            }
            else
                totalCount = 0;

            return ds;
        }
    }


}
