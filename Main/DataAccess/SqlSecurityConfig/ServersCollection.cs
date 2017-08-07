using System.Configuration;

namespace LibertyPower.DataAccess.ConfigAccess.SqlSecurityConfig
{
    public class ServerCollection : ConfigurationElementCollection
    {
        public override ConfigurationElementCollectionType CollectionType
        {
            get { return ConfigurationElementCollectionType.AddRemoveClearMap; }
        }

        public ServerElement this[int index]
        {
            get { return (ServerElement)BaseGet(index); }
            set
            {
                if (BaseGet(index) != null)
                    BaseRemoveAt(index);
                BaseAdd(index, value);
            }
        }

        public new ServerElement this[string index]
        {
            get { return (ServerElement)BaseGet(index); }
        }

        public void Add(ServerElement element)
        {
            BaseAdd(element);
        }

        public void Clear()
        {
            BaseClear();
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new ServerElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((ServerElement)element).Name;
        }

        public void Remove(ServerElement element)
        {
            BaseRemove(element.Name);
        }

        public void Remove(string name)
        {
            BaseRemove(name);
        }

        public void RemoveAt(int index)
        {
            BaseRemoveAt(index);
        }

        public new int Count
        {
            get { return base.Count; }
        }
    }
}
