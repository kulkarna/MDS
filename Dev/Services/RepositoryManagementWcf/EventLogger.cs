using System.Diagnostics;

namespace LibertyPower.RepositoryManagement.Web
{
    public static class EventLogger
    {
        private static void PrepareLog(string sourceName, string logName)
        {
            if (!EventLog.SourceExists(sourceName))
                EventLog.CreateEventSource(sourceName, logName);
        }

        public static void WriteEntry(string message)
        {
            PrepareLog(Configuration.EventSourceName, Configuration.EventLogName);
            EventLog.WriteEntry(Configuration.EventSourceName, message);
        }

        public static void WriteEntry(string message, EventLogEntryType type)
        {
            PrepareLog(Configuration.EventSourceName, Configuration.EventLogName);
            EventLog.WriteEntry(Configuration.EventSourceName, message, type);
        }

        public static void WriteEntry(string message, EventLogEntryType type, int eventId)
        {
            PrepareLog(Configuration.EventSourceName, Configuration.EventLogName);
            EventLog.WriteEntry(Configuration.EventSourceName, message, type, eventId);
        }

        public static void WriteEntry(string message, EventLogEntryType type, int eventId, short category)
        {
            PrepareLog(Configuration.EventSourceName, Configuration.EventLogName);
            EventLog.WriteEntry(Configuration.EventSourceName, message, type, eventId, category);
        }
    }
}