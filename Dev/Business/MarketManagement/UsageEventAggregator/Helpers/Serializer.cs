using System;
using Newtonsoft.Json;

namespace UsageEventAggregator.Helpers
{
    public class Serializer
    {
        public static string Serialize<T>(T value)
        {
            return JsonConvert.SerializeObject(value);
        }         
        
        public static object Deserialize(string value, Type type)
        {
            return JsonConvert.DeserializeObject(value, type);
        } 
    }
}