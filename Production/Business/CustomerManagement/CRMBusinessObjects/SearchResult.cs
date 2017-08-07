using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LibertyPower.Business.CustomerManagement.CRMBusinessObjects
{
    public class SearchResult
    {
        string Query { get; set; }

        List<SearchResultDetail> Results { get; set; }

    }

    public class SearchResultDetail
    {
        /// <summary>
        /// If item belong to a database row, this will be its primary key
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Result Title
        /// </summary>
        public string Title { get; set; }


        public string URL { get; set; }

        public DateTime RelativeDate { get; set; }

        public SearchResultItemType Type { set; get; }

        /// <summary>
        /// This could be any type of object that is relative to the result
        /// </summary>
        public object SourceEntityItem { get; set; }

    }

    public enum SearchResultItemType
    {
        Account,
        Contract,
        Customer,
        Rate
    }
}
