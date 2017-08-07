using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Timers;
using Common.Logging;
using Microsoft.SqlServer.Server;
using UsageEventAggregator.Events;


namespace UsageEventAggregator.EventTransports.SqlPersistance
{
    public class SqlPersistanceTransport
    {
        private string _connectionString;
        private int _pollIntervalSeconds;
        private Timer _pollTimer;
        private static readonly ILog Log = LogManager.GetCurrentClassLogger();
        private List<SqlDataRecord> _messageTypes;

        internal event EventHandler<TransportMessageReceivedEventArgs> TransportMessageReceived;

        internal SqlPersistanceTransport(List<string> messageTypes)
        {
            _SetMessageTypes(messageTypes);

            _VerifyConfiguration();


            //No need to poll if no message handlers present
            if(messageTypes.Count != 0)
                _PollForEvents();
        }



        internal void MarkMessageAsProcessedBySubscriber(long messageId, string errorMessage = null)
        {
            using (var con = new SqlConnection(_connectionString))
            {
                using (var cmd = new SqlCommand("usp_UsageEvents_MarkAsProcessed", con))
                {
                    cmd.Parameters.Add(new SqlParameter("EventMessageId", messageId));
                    cmd.Parameters.Add(string.IsNullOrWhiteSpace(errorMessage) ? new SqlParameter("ErrorMessage", DBNull.Value) : new SqlParameter("ErrorMessage", errorMessage));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        private void _SetMessageTypes(List<string> messageTypes)
        {
            _messageTypes = new List<SqlDataRecord>();
            foreach (var messageType in messageTypes)
            {
                var dr = new SqlDataRecord(new []{new SqlMetaData("MessageType", SqlDbType.VarChar, 255)});
                dr.SetString(0, messageType);
                _messageTypes.Add(dr);
            }
            
        }

        private void _VerifyConfiguration()
        {
            var configValues = ConfigurationManager.AppSettings.GetValues("ConnectionStringNameLpTransactions");
            if (configValues == null)
            {
                var ex = new ConfigurationErrorsException("Connection string name not found in app settings key of ConnectionStringNameLpTransactions");
                Log.Error(ex.Message, ex);
                throw ex;
            }

            var connectionStringName = configValues[0];
            _connectionString = ConfigurationManager.ConnectionStrings[connectionStringName].ConnectionString;
            if (string.IsNullOrWhiteSpace(_connectionString))
            {
                var ex = new ConfigurationErrorsException("Connection string not found with name of " + connectionStringName);
                Log.Error(ex.Message, ex);
                throw ex;
            }

            //No need to poll if no message handlers present
            if (_messageTypes.Count == 0)
                return;

            var pollIntervalValues = ConfigurationManager.AppSettings.GetValues("PollInterval");
            if (pollIntervalValues == null)
            {
                var ex = new ConfigurationErrorsException("Poll Interval not set using app setting key of PollInterval");
                Log.Error(ex.Message, ex);
                throw ex;
            }

            int interval;
            if (!int.TryParse(pollIntervalValues[0], out interval))
            {
                var ex = new InvalidCastException("Could not cast interval to int using " + pollIntervalValues[0]);
                Log.Error(ex.Message, ex);
                throw ex;
            }
            _pollIntervalSeconds = interval;

        }

        private void _PollForEvents()
        {
            _pollTimer = new Timer();
            _pollTimer.Elapsed += (sender, args) => _ProcessEventMessages();
            _pollTimer.Interval = _pollIntervalSeconds;
            _pollTimer.Enabled = true;
        }
        
        private void _ProcessEventMessages()
        {
            if (TransportMessageReceived == null)
                return;
            try
            {
                _pollTimer.Enabled = false;
                using (var con = new SqlConnection(_connectionString))
                {
                    using (var cmd = new SqlCommand("usp_UsageEvents_GetEventMessages", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        var p = cmd.Parameters.AddWithValue("@MessageTypes", _messageTypes);
                        p.SqlDbType = SqlDbType.Structured;
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                        {
                            while (reader.Read())
                            {
                                var message = new EventTransportMessage
                                    {
                                        Id = reader.GetInt64(0),
                                        CorrelationId = reader.IsDBNull(1) ? 0 : reader.GetInt64(1),
                                        Body = reader.GetString(2),
                                        TimeSent = reader.GetDateTime(3),
                                        MessageType = reader.GetString(4)
                                    };
                                TransportMessageReceived(null, new TransportMessageReceivedEventArgs(message));

                            }
                        }
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex.Message, ex);
            }
            finally
            {
                _pollTimer.Enabled = true;
            }

            
        }

        internal Subscription<T> GetSubscription<T>(IHandleEvents<T> subscriber)
        {
            using (var con = new SqlConnection(_connectionString))
            {
                using (var cmd = new SqlCommand("UsageEvents_GetSubscription", con))
                {
                    cmd.Parameters.Add(new SqlParameter("Subscriber", subscriber.GetType().FullName));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        return new Subscription<T>
                            {
                                Id = reader.GetInt32(0),
                                DateTimeToStartFrom = reader.GetDateTime(1),
                                Subscriber = subscriber
                            };
                    }
                }
            }
        }

        internal void SendEventMessage(EventTransportMessage message)
        {
            using (var con = new SqlConnection(_connectionString))
            {
                using (var cmd = new SqlCommand("usp_UsageEvents_SendEventMessage", con))
                {
                    //cmd.Parameters.Add(new SqlParameter
                    //    {
                    //        ParameterName = "EventMessageId",
                    //        SqlDbType = SqlDbType.BigInt,
                    //        Direction = ParameterDirection.Output
                    //    });
                    cmd.Parameters.Add(new SqlParameter("TimeSent", DateTime.Now));
                    cmd.Parameters.Add(new SqlParameter("MessageType", message.MessageType));
                    cmd.Parameters.Add(message.CorrelationId == 0 ? new SqlParameter("CorrelationId", DBNull.Value) : new SqlParameter("CorrelationId", message.CorrelationId));
                    cmd.Parameters.Add(new SqlParameter("Body", message.Body));
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }

        internal void SetProcessingToFalse(long messageId)
        {
            try
            {
                using (var con = new SqlConnection(_connectionString))
                {
                    using (var cmd = new SqlCommand("usp_UsageEvents_SetProcessingToFalse", con))
                    {
                        cmd.Parameters.Add(new SqlParameter("EventMessageId", messageId));
                        cmd.CommandType = CommandType.StoredProcedure;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Error("Clear processing failed on message id " + messageId, ex);                
            }

        }

    }
}