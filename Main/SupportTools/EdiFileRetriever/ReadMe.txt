EdiFileRetriever is a tool for IT to retrieve EDI files from a SQL statement to a specified file directory.  The original PBI was 103094.

1. Design a SQL to identify the EDI files in full file path.  The query must contain a column name 'FullFilePath' which the tool expects to read*.  Note the number of files to be retrieved.  See a sample SQL below:

select distinct EdiFileLogID, TransactionType, r.[Root]+b.RelativePath+c.[FileName] as 'FullFilePath'
from [lp_transactions].[dbo].[EdiAccount] a (nolock)
join [lp_transactions].[dbo].[EdiFileLog] f (nolock) on f.id = a.edifilelogid
join [Libertypower].[dbo].[FileContext] c (nolock) on f.FileGuid = c.FileGuid
join [Libertypower].[dbo].[ManagedBin] b (nolock) on c.ManagedBinID = b.ID
join [Libertypower].[dbo].[ManagerRoot] r (nolock) on b.ManagerRootID = r.ID
where 1=1
and a.utilitycode in ('NYSEG', 'NIMO')
and f.filetype = 0
and tcap > -1

(*) The configuration of the tool allows a different column name for the full file path.  If possible, use the default column name. 

2. From File Explorer, go to the tool's directory (for example, I:\MDS Support Tools\EdiFileRetriever)

3. Back up a copy of the configuration file EdiRetriever.exe.config (File name is EdiFileRetriever.exe with the File Type of XML Configuration File) in case it is needed.

4. Edit the configuration file in a text editor.

4.a. Set the desitination directory where the EDI files will be copy to.
In the config file, two tags are listed for convenience.  One is the local C: drive, and the other is the production EDI File Grabber folder where the EDI files are parsed (value="\\\\libertypower\\nocshares\\EDIFilesGrabber\\syncheddropedi").  Activate only one and comment out the rest.  Do not edit the value for the EDI File Grabber folder.

Also it is a good practice to test the results in a local drive before copying files to the EDI File Grabber folder.  Sometimes, the number of files differs because of duplicate file name.

4.b. Verify or edit the full path column name to match with your SQL.

4.c. Update the SQL statement with your SQL.
If your SQL has character like '&' as in 'O&R', then change the & to &amp; (for example, 'O&amp;R').  Without changing &, the tool will not work.  Examples include:
    " to  &quot;
    ' to  &apos;
    < to  &lt;
    > to  &gt;
    & to  &amp;

4.d. Save the config file.

5. Open another File Explorer and set to the desitnation directoy to verify the files will be retrieved.

6. Double click the application EdiRetriever to execute the tool.  A window will open to show status.  After the window is closed, count the number of files retrieved in the destination folder.  If the number does not match with the expected, verify the configuration (the SQL statement and the destination folder, or the backup config file).  Contact Abhi or his replacement if needed.
