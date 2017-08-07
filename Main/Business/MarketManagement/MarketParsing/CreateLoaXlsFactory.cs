namespace LibertyPower.Business.MarketManagement.MarketParsing
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using System.Reflection;
    using System.Text;

    using LibertyPower.Business.CommonBusiness.CommonEntity;
    using LibertyPower.Business.CommonBusiness.FileManager;
    using LibertyPower.Business.MarketManagement.UtilityManagement;

    public static class CreateLoaXlsFactory
    {
        #region Methods

        //TODO change return type to FileContext
        public static FileContext GetConsolidatedLoa(UtilityAccountList selectedAccounts, int userID)
        {
            FileContext fc = null;
            //retrieve file template from resource
            System.Reflection.Assembly a = System.Reflection.Assembly.GetExecutingAssembly();
            string[] resources = a.GetManifestResourceNames();
            if( resources.Length > 0 )
            {
                for( int i = 0; i < resources.Length; i++ )
                {
                    if( resources[i].StartsWith( "LibertyPower.Business.MarketManagement.MarketParsing.LOA.xls" ) == true )
                    {
                        Stream file = a.GetManifestResourceStream( resources[i] );
                        Infragistics.Excel.Workbook workbook = Infragistics.Excel.Workbook.Load( file );
                        //add accounts to file
                        int row = 1;
                        Infragistics.Excel.Worksheet sheet = workbook.Worksheets["ERCOT_AccountListing"];
                        foreach(UtilityAccount acct in selectedAccounts)
                        {
                            ProspectAccountCandidate ac = (ProspectAccountCandidate) acct;
                            sheet.Rows[row].Cells[0].Value = ac.AccountNumber.Trim();
                            sheet.Rows[row].Cells[1].Value = ac.RetailMarketCode.Trim();
                            sheet.Rows[row].Cells[2].Value = ac.UtilityCode.Trim();
                            if(ac.Meters!=null && ac.Meters.Count>0)
                                sheet.Rows[row].Cells[3].Value = ac.Meters[0].MeterNumber;
                            sheet.Rows[row].Cells[4].Value = ((UsGeographicalAddress) ac.ServiceAddress).Street.Trim();
                            sheet.Rows[row].Cells[5].Value = ((UsGeographicalAddress) ac.ServiceAddress).CityName.Trim();
                           sheet.Rows[row].Cells[6].Value = ((UsGeographicalAddress) ac.ServiceAddress).StateCode.Trim();
                            sheet.Rows[row].Cells[7].Value = ((UsGeographicalAddress) ac.ServiceAddress).ZipCode.Trim();
                            sheet.Rows[row].Cells[8].Value = ((UsGeographicalAddress) ac.ServiceAddress).CountryName.Trim();
                            sheet.Rows[row].Cells[9].Value = ac.NameKey;
                            sheet.Rows[row].Cells[10].Value = ac.BillingAccount;
                            sheet.Rows[row].Cells[11].Value = ((UsGeographicalAddress)ac.BillingAddress).Street;
                            sheet.Rows[row].Cells[12].Value = ((UsGeographicalAddress)ac.BillingAddress).CityName;
                            sheet.Rows[row].Cells[13].Value = ((UsGeographicalAddress)ac.BillingAddress).StateCode;
                            sheet.Rows[row].Cells[14].Value = ((UsGeographicalAddress)ac.BillingAddress).ZipCode;
                            sheet.Rows[row].Cells[15].Value = ((UsGeographicalAddress)ac.BillingAddress).CountryName;
                            row++;
                        }
                        //add file to FileManager or download directly as a stream
                        string fileManagerRoot = (string) System.Configuration.ConfigurationManager.AppSettings.Get( "FileManagerRoot" );
                        string fileManagerContextKey = (string) System.Configuration.ConfigurationManager.AppSettings.Get( "FileManagerContextKey" );
                        FileManager fm = FileManagerFactory.GetFileManager(fileManagerContextKey, "OMS File Uploads", fileManagerRoot, userID);
                        fc = fm.AddFile( file, "SelectedAccounts.xls", userID );
                        workbook.Save(fc.FullFilePath );
                        return fc;
                    }
                }
            }
            //return FileContext
            return fc;
        }

        #endregion Methods
    }
}