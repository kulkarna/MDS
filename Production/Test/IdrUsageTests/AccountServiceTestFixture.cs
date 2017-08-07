using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model;

namespace IdrUsageTests
{
    [TestClass]
    public class AccountServiceTestFixture
    {
        [TestMethod]
        public void FillInMissingDatesFillInSingleDay()
        {
            //Arrange
            var details = new List<IdrAccountDetail> 
            {
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 1) },
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 3) }
            };

            //Act
            new AccountService().FillInMissingDates(details);

            //Assert
            Assert.AreEqual(420, details.Count);
            Assert.AreEqual(new DateTime(2012, 1, 2), details[418].Date);
        }

        [TestMethod]
        public void FillInMissingDatesFillInMultipleDays()
        {
            //Arrange
            var details = new List<IdrAccountDetail> 
            {
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 1) },
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 5) }
            };

            //Act
            new AccountService().FillInMissingDates(details);

            //Assert
            Assert.AreEqual(420, details.Count);
            Assert.AreEqual(new DateTime(2012, 1, 2), details[416].Date);
            Assert.AreEqual(new DateTime(2012, 1, 3), details[417].Date);
            Assert.AreEqual(new DateTime(2012, 1, 4), details[418].Date);
        }
        
        [TestMethod]
        public void FillInMissingDatesFillInMultipleDaysMultipleIntervals()
        {
            //Arrange
            var details = new List<IdrAccountDetail> 
            {
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 1) },
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 5) },
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 10) }
            };

            //Act
            new AccountService().FillInMissingDates(details);

            //Assert
            for (var i = 0; i < 420; i++ )
                Assert.AreEqual(new DateTime(2012, 1, 10).AddDays(-i), details[419-i].Date);
        }

        [TestMethod]
        public void FillInMissingDatesComplete420Days()
        {
            //Arrange
            var details = new List<IdrAccountDetail> 
            {
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 1) },
                new IdrAccountDetail(24) { Date = new DateTime(2012, 1, 3) },
            };
            
            var firstDate = details[0].Date.AddDays(-417);

            //Act
            new AccountService().FillInMissingDates(details);

            //Assert
            Assert.AreEqual(420, details.Count);
            Assert.AreEqual(firstDate, details[0].Date);
        }
    }
}
