using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;
using LibertyPower.DataAccess.SqlAccess.TransactionsSql.Model;
using Moq;
using LibertyPower.Business.MarketManagement.UtilityManagement;

namespace IdrUsageTests
{
    [TestClass]
    public class AccountDataEstimatorTestFixture
    {
        [TestMethod]
        public void FillInBlanksUsingNeighbors()
        {
            //Arrange
            var data = new List<IdrAccountDetail> { 
                new IdrAccountDetail { Values = new List<IdrValueExtended>
                { 
                    new IdrValueExtended { O = 3 }, new IdrValueExtended { O = null }, new IdrValueExtended { O = 5 } } 
                } 
            };

            //Act
            new AccountDataEstimator().FillInBlanks(data, data.Count);

            //Assert
            Assert.AreEqual(3, data[0].Values[0].O);
            Assert.IsNull(data[0].Values[0].E);
            
            Assert.AreEqual(4, data[0].Values[1].E);
            Assert.IsNull(data[0].Values[1].O);
            
            Assert.AreEqual(5, data[0].Values[2].O);
            Assert.IsNull(data[0].Values[2].E);
        }

        [TestMethod]
        public void FillInBlanksUsingNeighborsEstimated()
        {
            //Arrange
            var data = new List<IdrAccountDetail> 
            { 
                new IdrAccountDetail 
                { 
                    Values = new List<IdrValueExtended>
                    { 
                        new IdrValueExtended { O = null, E = 3 }, new IdrValueExtended { O = null }, new IdrValueExtended { O = null, E = 5 }
                    }
                } 
            };

            //Act
            new AccountDataEstimator().FillInBlanks(data, data.Count);

            //Assert
            Assert.AreEqual(3, data[0].Values[0].OorE);
            Assert.IsNull(data[0].Values[0].O);

            Assert.AreEqual(4, data[0].Values[1].E);
            Assert.IsNull(data[0].Values[1].O);

            Assert.AreEqual(5, data[0].Values[2].OorE);
            Assert.IsNull(data[0].Values[2].O);
        }

        [TestMethod]
        public void FillInBlanksJumpFirstElement()
        {
            //Arrange
            var data = new List<IdrAccountDetail> { 
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = null }, new IdrValueExtended { O = 5 } } },
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 1 }, new IdrValueExtended { O = 5 } } },
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 2 }, new IdrValueExtended { O = 5 } } },
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 3 }, new IdrValueExtended { O = 5 } } },
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 4 }, new IdrValueExtended { O = 5 } } },
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 5 }, new IdrValueExtended { O = 5 } } },
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 6 }, new IdrValueExtended { O = 5 } } },
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 7 }, new IdrValueExtended { O = 5 } } },
            };

            //Act
            new AccountDataEstimator().FillInBlanks(data, data.Count);

            //Assert
            Assert.IsNull(data[0].Values[0].O);
            Assert.AreEqual(1, data[0].Values[0].E);
        }

        [TestMethod]
        public void FillInBlanksJumpLastElement()
        {
            //Arrange
            var data = new List<IdrAccountDetail> { 
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 5 }, new IdrValueExtended { O = null } } } ,
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 1 }, new IdrValueExtended { O = 1 } } } ,
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 2 }, new IdrValueExtended { O = 2 } } } ,
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 3 }, new IdrValueExtended { O = 3 } } } ,
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 4 }, new IdrValueExtended { O = 4 } } } ,
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 5 }, new IdrValueExtended { O = 5 } } } ,
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 6 }, new IdrValueExtended { O = 6 } } } ,
                new IdrAccountDetail { Values = new List<IdrValueExtended> { 
                    new IdrValueExtended { O = 7 }, new IdrValueExtended { O = 7 } } } ,
            };

            //Act
            new AccountDataEstimator().FillInBlanks(data, data.Count);

            //Assert
            Assert.IsNull(data[0].Values[1].O);
            Assert.AreEqual(1, data[0].Values[1].E);
        }

        [TestMethod]
        public void FillInBlanksJump7AndNeg7()
        {
            //Arrange
            var data = new List<IdrAccountDetail>();
            
            //Create 15 intervals
            for (int i = 0; i < 15; i++) {

                data.Add(new IdrAccountDetail
                {
                    Values = new List<IdrValueExtended> { new IdrValueExtended { O = i }, new IdrValueExtended { O = i } }
                });
            };

            //Set the middle value to null
            data[7].Values[0].O = null;

            //Set the last value to null, so the jump has to go back
            data[14].Values[0].O = null;

            //Act
            new AccountDataEstimator().FillInBlanks(data, data.Count);

            //Assert
            Assert.AreEqual(0, data[7].Values[0].E);
            Assert.AreEqual(0, data[14].Values[0].E);
        }

        [TestMethod]
        public void FillInEmptyDays7DaysOrLess() 
        {
            //Arrange
            //Arrange
            var data = new List<IdrAccountDetail>();

            //Create 15 intervals
            for (var i = 0; i < 14; i++)
            {
                //Create the first week as all nulls.
                data.Add(new IdrAccountDetail
                {
                    Values = new List<IdrValueExtended> { new IdrValueExtended { O = i < 7 ? (decimal?)null : i }, new IdrValueExtended { O = i < 7 ? (decimal?)null : 3 * i } }
                });
            };

            //Act
            new AccountDataEstimator().FillInEmptyDays(data, data.Count);

            //Assert
            for (var i = 0; i < 7; i++) {

                Assert.AreEqual(7 + i, data[i].Values[0].OorE);
                Assert.AreEqual(3 * (7 + i), data[i].Values[1].OorE);
            }
        }

        [TestMethod]
        public void FillInEmptyDays7DaysOrLessWithLoopback()
        {
            //Arrange
            var data = new List<IdrAccountDetail>();

            //Create 21 intervals
            for (var i = 0; i < 21; i++)
            {
                //Create the first week and last week as all nulls.
                data.Add(new IdrAccountDetail
                {
                    Values = new List<IdrValueExtended> { new IdrValueExtended { O = (i > 6 && i < 14) ? i : (decimal?)null }, new IdrValueExtended { O = (i > 6 && i < 14) ? 3 * i : (decimal?)null } }
                });
            };

            //Act
            new AccountDataEstimator().FillInEmptyDays(data, data.Count);

            //Assert
            for (var i = 0; i < 7; i++)
            {

                Assert.AreEqual(7 + i, data[i].Values[0].OorE);
                Assert.AreEqual(3 * (7 + i), data[i].Values[1].OorE);
                Assert.AreEqual(7 + i, data[14 + i].Values[0].OorE);
                Assert.AreEqual(3 * (7 + i), data[14 + i].Values[1].OorE);
            }
        }

        [TestMethod]
        public void FillInEmptyDaysBetween8And57Days()
        {
            //Arrange
            var data = new List<IdrAccountDetail>();

            //Create 23 intervals
            for (var i = 0; i < 23; i++)
            {
                data.Add(new IdrAccountDetail
                {
                    Date = new DateTime().AddDays(i),
                    Values = new List<IdrValueExtended> { new IdrValueExtended { O = i }, new IdrValueExtended { O = 10 * i } }
                });
            };

            //Nullify from 7 to 15 (9 entries)
            for (var i = 7; i <= 15; data[i].Values[0].O = data[i++].Values[1].O = null) ;

            //Act
            new AccountDataEstimator().FillInEmptyDays(data, data.Count);

            //Assert
            //Verify first half
            for (var i = 7; i <= 10; i++)
            {
                //Assert day of week is the same.
                Assert.AreEqual(data[i - 7].Date.DayOfWeek, data[i].Date.DayOfWeek);

                Assert.AreEqual(i - 7, data[i].Values[0].OorE);
                Assert.AreEqual(10 * (i - 7), data[i].Values[1].OorE);
            }

            //Verify second half
            for (var i = 11; i <= 15; i++)
            {
                //Assert day of week is the same.
                Assert.AreEqual(data[i + 7].Date.DayOfWeek, data[i].Date.DayOfWeek);

                Assert.AreEqual(i + 7, data[i].Values[0].OorE);
                Assert.AreEqual(10 * (i + 7), data[i].Values[1].OorE);
            }
        }

        [TestMethod]
        public void FillInEmptyDaysMoreThan57Days()
        {
            //Arrange
            var data = new List<IdrAccountDetail>();

            //Create 113 intervals
            for (var i = 0; i < 120; i++)
            {
                data.Add(new IdrAccountDetail
                {
                    Date = new DateTime().AddDays(i),
                    Values = new List<IdrValueExtended> { new IdrValueExtended { O = i }, new IdrValueExtended { O = 10 * i } }
                });
            };

            //Nullify from 28 to 84 (57 entries)
            for (var i = 28; i <= 84; data[i].Values[0].O = data[i++].Values[1].O = null) ;

            //Act
            new AccountDataEstimator().FillInEmptyDays(data, data.Count);

            //Assert
            //Verify first half
            for (var i = 28; i <= 48; i++)
            {
                //Assert day of week is the same.
                Assert.AreEqual(data[i - 28].Date.DayOfWeek, data[i].Date.DayOfWeek);
                Assert.AreEqual(i - 28, data[i].Values[0].OorE);
                Assert.AreEqual(10 * (i - 28), data[i].Values[1].OorE);
            }

            //Verify second half
            for (var i = 56; i < 84; i++)
            {
                //Assert day of week is the same.
                Assert.AreEqual(data[i + 28 + 7].Date.DayOfWeek, data[i].Date.DayOfWeek);
                Assert.AreEqual(i + 28 + 7, data[i].Values[0].OorE);
                Assert.AreEqual(10 * (i + 28 + 7), data[i].Values[1].OorE);
            }

            //Assert day of week is the same.
            Assert.AreEqual(data[91].Date.DayOfWeek, data[84].Date.DayOfWeek);
            Assert.AreEqual(91, data[91].Values[0].OorE);
            Assert.AreEqual(910, data[91].Values[1].OorE);
        }

        [TestMethod]
        public void FillInZeroes()
        {
            //Arrange

            var estimator =  new AccountDataEstimator{Tolerance = 0.5M};

            //Create some data and calculate the sum of the values
            var data = new List<IdrAccountDetail>();

            decimal sum = 0;

            for (var i = 0; i < 100; i++)
            {
                var values = new List<IdrValueExtended>();

                for (var j = 0; j < 24; j++)
                {
                    var v = new IdrValueExtended { O = i * 10 + j };
                    sum += v.OorE ?? 0;
                    values.Add(v);
                }
                data.Add(new IdrAccountDetail
                {
                    Date = DateTime.Today.AddDays(i - 100),
                    Values = values
                });
            };

            //Put some zeroes
            data[40].Values[5].O = 0; // To be estimated with left/right neighbors
            sum -= 405;

            data[40].Values[0].O = 0; // To be estimated with +/- 7 hopping
            sum -= 400;

            //Create HU
            UsageList usages = new UsageList();
            usages.Add(new Usage
            {
                BeginDate = DateTime.Today.AddDays(-100),
                EndDate = DateTime.Today.AddDays(-1),
                TotalKwh = (int)(100 * sum / (estimator.Tolerance + 100) * 0.9M) // to be out of the tolerance
            });
 
            //Act
            estimator.FillInZeroes(data, usages, data.Count);

            Assert.AreEqual((404 + 406) / 2.0M, data[40].Values[5].E);
            Assert.AreEqual(330, data[40].Values[0].E);
        }
    }
}
