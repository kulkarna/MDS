using System.IO;
using System.Xml.Serialization;

namespace LibertyPower.RepositoryManagement.Data
{
    public static class Serializer
    {
        public static string ToXml<T>(this T value)
        {
            using (var sw = new StringWriter())
            {
                new XmlSerializer(typeof(T)).Serialize(sw, value);
                return sw.ToString();
            }
        }

        public static T FromXml<T>(string value)
        {
            var serializer = new XmlSerializer(typeof(T));
            using (var reader = new StringReader(value))
            {
                return (T)serializer.Deserialize(reader);
            }
        }
    }
}
