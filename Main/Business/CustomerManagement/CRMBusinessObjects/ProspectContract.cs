using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class ProspectContract
    {
        private Contract contract;
        private Customer customer;
        private List<AccountContract> accountsContracts;

        public string ContractNumber
        {
            get
            {
                return this.contract.Number;
            }

            set
            {
                this.contract.Number = value;
            }
        }

        public ProspectContract()
        {
            contract = new Contract();
            customer = new Customer();
            accountsContracts = new List<AccountContract>();
        } 

        public ProspectContract(string query)
        {
            // detect query type

        }

        public void AddNewAccount( string accountNumber )
        {
            Account newAccount = new Account();
            newAccount.AccountNumber = accountNumber;
            newAccount.DateCreated = DateTime.Now;
            newAccount.Modified = DateTime.Now;
            if( !this.accountsContracts.Where( w => w.Account != null ).Select( s => s.Account ).ToList().Exists( e => e.AccountNumber == accountNumber ) )
            {
                AccountContract ac = new AccountContract();
                ac.Account = newAccount;
                this.accountsContracts.Add( ac );
            }
        }

        public void SearchMatch()
        {

        }

        public void PrintAccounts()
        {

            Console.WriteLine( "Information on Contract:" + this.ContractNumber );

            var accounts = from ac in this.accountsContracts
                           where ac.Account != null
                           select ac.Account;

            Console.WriteLine( "Number Of Accounts" + accounts.Count() );
            foreach( var acc in accounts )
            {
                Console.WriteLine( "Account : " + acc.AccountNumber );
            }
        }

    }
}
