
using System.IO;
using System.Text;
using System.Web.Script.Serialization;
using System.Xml.Serialization;
namespace WatchUs.Common.Utility
{
    public static class Serializer
    {
        /// <summary>
        /// this method is to deserialize a JSON string and return the proper object
        /// </summary>
        /// <typeparam name="T"> type to which the JSON string need to be deserialized</typeparam>
        /// <param name="jsonString">the string which needs to be deserialized</param>
        /// <returns>deserialized type object</returns>
        public static T DeserializeFromJson<T>(string jsonString) where T : class
        {
            if (jsonString == null && jsonString.Trim().Length == 0)
            {
                return null;
            }

            //create the Java Script Serializer instance and call deserialize method           
            return new JavaScriptSerializer().Deserialize<T>(jsonString);
        }

        /// <summary>
        /// Serializes object to a JSON string
        /// </summary>
        /// <typeparam name="T">Type T</typeparam>
        /// <param name="instance">object of type T</param>
        /// <returns>returns JSON string</returns>
        public static string SerializeToJason<T>(T instance)
        {
            return  new JavaScriptSerializer().Serialize(instance);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="instance"></param>
        /// <returns></returns>
        public static string Serialize<T>(T instance)
        {
            var serializer = new XmlSerializer(typeof(T));
            var sb = new StringBuilder();
            using (var sw = new StringWriter(sb))
            {
                serializer.Serialize(sw, instance);
            }
            return sb.ToString();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="instance"></param>
        /// <returns></returns>
        public static string Serialize<T>(T instance, Encoding enc)
        {
            var serializer = new XmlSerializer(typeof(T));

            var memoryStream = new MemoryStream();
            var streamWriter = new StreamWriter(memoryStream, enc);

            serializer.Serialize(streamWriter, instance);

            memoryStream.Seek(0, SeekOrigin.Begin);
            var streamReader = new StreamReader(memoryStream, enc);
            return streamReader.ReadToEnd();
            
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="xml"></param>
        /// <returns></returns>
        public static T DeserializeFromXml<T>(string xml)
        {
            if (xml == null)
            {
                return default(T);
            }

            if (xml.Trim().Length == 0)
            {
                return default(T);
            }

            T result;
            var serializer = new XmlSerializer(typeof(T));
            using (TextReader tr = new StringReader(xml))
            {
                result = (T)serializer.Deserialize(tr);
            }
            return result;
        }

    }
}
