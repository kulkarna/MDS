namespace UsageEventAggregator
{
    public interface ISubscriber<in T>
    {
        void Send(T eventMessage);
    }
}