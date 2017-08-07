namespace UsageEventAggregator
{
    public interface IHandleEvents<T>
    {
        void Handle(T e);
    }
}