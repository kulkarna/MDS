using System.Reflection;
using LibertyPower.Business.MarketManagement.IdrUsageManagement.Readers;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IdrUsageTests.Readers
{
    [TestClass]
    public class ZipFileManagerTestFixture
    {
        [TestMethod]
        public void CanEnumerateFilesInZip()
        {
            //Arrange
            var zipStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("IdrUsageTests.Resources.Readers.Sample.zip");

            //Act
            var unzipedStreams = ZipFileManager.Unzip(zipStream);

            //Assert
            Assert.IsTrue(unzipedStreams.Count == 3);
        }
    }
}
