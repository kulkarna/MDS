using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibertyPower.MarketDataServices.UsageEclRepository;

namespace UsageEclServiceTests
{

    public class DataColumnDefinition
    {
        public string ColumnName { get; set; }
        public string DataType { get; set; }
    }


    public class DataTableColumns : List<DataColumnDefinition>
    {
        public Type GetTypeFromString(string dataType)
        {
            Type type = null;

            switch (dataType)
            {
                case "STRING":
                    type = typeof(string);
                    break;
                case "INTEGER":
                    type = typeof(int);
                    break;
                case "DECIMAL":
                    type = typeof(decimal);
                    break;
                case "DATETIME":
                    type = typeof(DateTime);
                    break;
            }

            return type;
        }

        public DataSet GenerateDataSet(List<List<string>> values)
        {
            DataSet dataSet = new DataSet();
            DataTable dataTable = new DataTable();

            foreach (DataColumnDefinition dataColumnDefinition in this)
            {
                Type type = GetTypeFromString(dataColumnDefinition.DataType);
                dataTable.Columns.Add(dataColumnDefinition.ColumnName, type);
            }

            int counter = 0;
            foreach (List<string> listOfStrings in values)
            {
                counter = 0;
                DataRow dataRow = dataTable.NewRow();
                foreach (string value in listOfStrings)
                {
                    switch (this[counter].DataType)
                    {
                        case "INTEGER":
                            dataRow[counter] = Utilities.Common.NullSafeInteger(value);
                            break;
                        case "STRING":
                            dataRow[counter] = Utilities.Common.NullSafeString(value);
                            break;
                        case "DATETIME":
                            dataRow[counter] = Utilities.Common.NullSafeDateTime(value);
                            break;
                        case "DECIMAL":
                            dataRow[counter] = Utilities.Common.NullSafeDecimal(value);
                            break;
                    }
                }
                dataTable.Rows.Add(dataRow);
            }
            dataSet.Tables.Add(dataTable);
            return dataSet;
        }

        public DataTableColumns(string value)
        {
            string[] columns = value.Split(';');
            foreach (string column in columns)
            {
                string[] values = column.Split(',');
                if (values != null && values.Length == 2 && !string.IsNullOrWhiteSpace(values[0]) && !string.IsNullOrWhiteSpace(values[1])
                     && (values[1] == "DATETIME" || values[1] == "STRING" || values[1] == "INTEGER" || values[1] == "DECIMAL"))
                {
                    DataColumnDefinition dataColumnDefinition = new DataColumnDefinition()
                    {
                        ColumnName = values[0],
                        DataType = values[1]
                    };
                    this.Add(dataColumnDefinition);
                }
            }
        }
    }

    public class UsageEclBusinessLayerTestRepositoryReturningOneMock : IRepository
    {
        public DataSet DoesEclDataExist(string messageId, string accountNumber, int utilityId)
        {
            DataSet dataSet = new DataSet();
            DataTable dataTable = new DataTable();
            dataTable.Columns.Add("Id", typeof(int));
            DataRow dataRow = dataTable.NewRow();
            dataRow[0] = 1;
            dataTable.Rows.Add(dataRow);
            throw new NotImplementedException();
        }

        

    }
}
