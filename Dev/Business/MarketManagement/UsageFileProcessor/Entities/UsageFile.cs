using System;
using System.IO;

namespace UsageFileProcessor.Entities
{
    public class UsageFile : IDisposable
    {
        public string Path { get; private set; }
        
        public string UtilityCode { get; set; }

        public Stream FileStream { get; private set; }

        public UsageFile(string utilityCode, string path)
        {
            if(string.IsNullOrWhiteSpace(utilityCode))
                throw new ArgumentNullException("utilityCode", "Utility code is blank.");

            UtilityCode = utilityCode;
            
            if(string.IsNullOrWhiteSpace(path))
                throw new ArgumentNullException("path", "Path is blank");

            Path = path.ToLower();

            if(!_LoadFile())
                throw new FileNotFoundException("Could not find usage file at " + path);
        }

        private bool _LoadFile()
        {
            
            using (var file = new FileStream(Path, FileMode.Open, FileAccess.Read))
            {
                var bytes = new byte[file.Length];
                file.Read(bytes, 0, (int)file.Length);
                FileStream = new MemoryStream(bytes, 0, (int)file.Length);
            }

            return true;
        }



        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing && FileStream != null) 
                FileStream.Dispose();
        }
    }
}