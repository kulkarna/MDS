using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace LibertyPower.DataAccess.TextAccess
{
	public class FileInfoDetailed
	{
		public FileInfoDetailed(string file)
		{
			FileInfo fileInfo = new FileInfo( file );
			this.FileName = fileInfo.Name;
			this.FilePath = fileInfo.DirectoryName;
			this.Contents = FileReader.Read( file );
		}

		public string FileName
		{
			get;
			set;
		}

		public string FilePath
		{
			get;
			set;
		}

		public string Contents
		{
			get;
			set;
		}
	}
}
