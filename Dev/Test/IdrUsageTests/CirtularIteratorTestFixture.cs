using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibertyPower.Business.MarketManagement.IdrUsageManagement;

namespace IdrUsageTests
{
    [TestClass]
    public class CirtularIteratorTestFixture
    {
        #region Indexer Tests

        [TestMethod]
        public void TestIndexingInRange()
        {
            //Arrange
            var data = new List<int> { 1,2,3 };

            //Act
            var it = new CircularIterator<int>(data);

            //Assert
            for (int i = 0; i < data.Count; i++)
                Assert.AreEqual(data[i], it[i]);
        }

        [TestMethod]
        public void TestIndexingSingleElementListInBothDirections()
        {
            //Arrange
            var data = new List<int> { 1 };

            //Act
            var it = new CircularIterator<int>(data);

            //Assert
            for (int i = 0; i < 10; i++)
            {
                Assert.AreEqual(data[0], it[i]);
                Assert.AreEqual(data[0], it[-1 * i]);
            }
        }
        [TestMethod]
        public void TestIndexingNegative()
        {
            //Arrange
            var data = new List<int> { 1, 2, 3 };

            //Act
            var it = new CircularIterator<int>(data);

            //Assert
            Assert.AreEqual(data[2], it[-1]);
            Assert.AreEqual(data[1], it[-2]);
            Assert.AreEqual(data[0], it[-3]);
            Assert.AreEqual(data[2], it[-4]);
            Assert.AreEqual(data[1], it[-5]);
            Assert.AreEqual(data[0], it[-6]);
        }

        [TestMethod]
        public void TestIndexingLargerThanCollection()
        {
            //Arrange
            var data = new List<int> { 1, 2, 3 };

            //Act
            var it = new CircularIterator<int>(data);

            //Assert
            Assert.AreEqual(data[0], it[3]);
            Assert.AreEqual(data[1], it[4]);
            Assert.AreEqual(data[2], it[5]);
            Assert.AreEqual(data[0], it[6]);
            Assert.AreEqual(data[1], it[7]);
            Assert.AreEqual(data[2], it[8]);
        }

        [TestMethod, ExpectedException(typeof(Exception))]
        public void TestIndexingInvalidLoopbackLength()
        {
            //Arrange
            var data = new List<int> { 1, 2, 3 };

            //Act. This will fail. Loopback argument must be less or equal to the size of the collection.
            var it = new CircularIterator<int>(data, 4);

            //Assert
        }

        [TestMethod]
        public void TestIndexingDifferentLoopbackLength()
        {
            //Arrange
            var data = new List<int> { 1, 2, 3 };

            //Act
            var it = new CircularIterator<int>(data, 2);

            //Assert
            Assert.AreEqual(2, it[-1]);
            Assert.AreEqual(1, it[-2]);
            Assert.AreEqual(2, it[-3]);
            Assert.AreEqual(1, it[-4]);
            Assert.AreEqual(2, it[-5]);
            Assert.AreEqual(1, it[-6]);

            Assert.AreEqual(2, it[3]);
            Assert.AreEqual(3, it[4]);
            Assert.AreEqual(2, it[5]);
            Assert.AreEqual(3, it[6]);
            Assert.AreEqual(2, it[7]);
            Assert.AreEqual(3, it[8]);
        }

        #endregion Indexer Tests
    }
}
