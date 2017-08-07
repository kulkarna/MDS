using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EF = LibertyPower.DataAccess.SqlAccess.CustomerManagementEF;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public static class SearchHelper
    {

        public static bool IsAccountNumber( string input )
        {
            if( string.IsNullOrEmpty( input ) )
            {
                return false;
            }

            string tmp = input.Trim().ToLower();

            //if there are spaces and words it might not be an accountnumber
            if( HasWords( tmp ) )
            {
                return false;
            }

            EF.LibertyPowerEntities dal = new EF.LibertyPowerEntities();

            var utilityRules = from util in dal.Utilities
                               where util.InactiveInd == "0"
                               select new { util.UtilityCode, util.AccountNumberPrefix, util.AccountLength };


            var matches = from x in utilityRules
                          where string.IsNullOrEmpty( x.AccountNumberPrefix.Trim() ) || tmp.StartsWith( x.AccountNumberPrefix )
                          && tmp.Length == x.AccountLength.Value
                          select x;

            if( matches != null && matches.Count() > 0 )
                return true;
            else
                return false;

        }


        public static bool IsStandardContractNumber( string input )
        {
            if( string.IsNullOrEmpty( input ) )
                return false;

            string tmp = input.Trim().ToLower();

            //if there are spaces and words it might not be an accountnumber
            if( HasWords( tmp ) )
                return false;


            if( tmp.Length != 12 )
                return false;

            string[] parts = tmp.Split( '-' );

            if( parts.Count() != 2 )
            {
                return false;
            }

            int year, sequence;


            if( int.TryParse( parts[0], out year ) && int.TryParse( parts[1], out sequence ) )
            {
                if( year > 2000 && year <= DateTime.Now.Year + 1 )
                {
                    return true;
                }
            }
            return false;
        }

        public static bool IsNormalText( string input )
        {
            if( HasSpaces( input ) || HasWords( input ) )
            {
                return true;
            }
            return false;
        }

        public static bool IsNumeric( string input )
        {
            double num;
            bool answer = double.TryParse( input, out num );
            return answer;
        }


        public static bool HasSpaces( string input )
        {
            return input.Contains( " " );
        }


        public static bool HasWords( string input )
        {
            string[] words = input.Split( ' ' );
            return words.Length > 1;
        }

        public static List<SearchResultDetail> SearchAccounts( string query )
        {
            List<SearchResultDetail> results = new List<SearchResultDetail>();
            EF.LibertyPowerEntities dal = new EF.LibertyPowerEntities();
            var accounts = (from ac in dal.Accounts
                            where ac.AccountNumber.StartsWith( query )
                            select new { ac.AccountID, ac.AccountNumber, ac.Modified, ac.UtilityID, ac.RetailMktID }).Take( 20 );

            foreach( var item in accounts )
            {
                results.Add( new SearchResultDetail() { Id = item.AccountID, Title = item.AccountNumber, Type = SearchResultItemType.Account, RelativeDate = item.Modified, SourceEntityItem = null } );
            }

            return results;
        }

        public static List<SearchResultDetail> SearchCustomers( string query )
        {
            EF.LibertyPowerEntities dal = new EF.LibertyPowerEntities();
            List<SearchResultDetail> results = new List<SearchResultDetail>();

            var customers = (from c in dal.Customers
                             where c.CustomerName.FullName.ToLower().Contains( query.ToLower() )
                             select new { c.CustomerID, c.CustomerName.FullName, c.Modified }).Take( 20 );

            foreach( var item in customers )
            {
                results.Add( new SearchResultDetail() { Id = item.CustomerID, Type = SearchResultItemType.Customer, Title = item.FullName, RelativeDate = item.Modified, SourceEntityItem = null } );
            }
            return results;
        }

        public static List<SearchResultDetail> SearchContracts( string query )
        {
            EF.LibertyPowerEntities dal = new EF.LibertyPowerEntities();
            List<SearchResultDetail> results = new List<SearchResultDetail>();

            var customers = (from c in dal.Contracts
                             where c.Number.ToLower().Contains( query )
                             select new { c.ContractID, c.Number, c.Modified }).Take( 20 );

            foreach( var item in customers )
            {
                results.Add( new SearchResultDetail() { Id = item.ContractID, Type = SearchResultItemType.Contract, Title = item.Number, RelativeDate = item.Modified, SourceEntityItem = null } );
            }
            return results;
        }

        public static List<SearchResultDetail> SearchAll( string query )
        {
            List<SearchResultDetail> results = new List<SearchResultDetail>();
            results.AddRange( SearchAccounts( query ) );
            results.AddRange( SearchCustomers( query ) );
            results.AddRange( SearchContracts( query ) );
            return results;
        }

    }
}
