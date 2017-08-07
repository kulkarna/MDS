using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccessLayerEntityFramework;
using UtilityDto;
using UtilityLogging;

namespace UtilityManagementDataMapper
{
    public class EFToDtoMapping
    {
        public PurchaseOfReceivableList GeneratePorFromEf(System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode_Result> results)
        {
            ILogger _logger = new Logger();

            _logger.LogInfo("PurchaseOfReceivableList GeneratePorFromEf(System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode_Result> results) BEGIN");
            PurchaseOfReceivableList purchaseOfReceivableList = new PurchaseOfReceivableList();
            System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode_Result> resultsTemp = results;
            bool isValid = results != null;// && results.Count() > 0;
            _logger.LogInfo(string.Format("if (isValid:{0})", isValid.ToString()));
            _logger.LogInfo("Test");
            if (isValid)
            {
                _logger.LogInfo("foreach (var item in results)");
                foreach (var item in resultsTemp)
                {
                    _logger.LogInfo("UtilityDto.PurchaseOfReceivable porItem = new UtilityDto.PurchaseOfReceivable()");
                    UtilityDto.PurchaseOfReceivable porItem = new UtilityDto.PurchaseOfReceivable()
                    {
                        CreatedBy = item.CreatedBy,
                        CreatedDate = item.CreatedDate,
                        Id = item.Id,
                        Inactive = item.Inactive,
                        IsPorAssurance = item.IsPorAssurance,
                        IsPorOffered = item.IsPorOffered,
                        IsPorParticipated = item.IsPorParticipated,
                        LastModifiedBy = item.LastModifiedBy,
                        LastModifiedDate = item.LastModifiedDate,
                        LoadProfileId = item.LoadProfileId,
                        PorDiscountEffectiveDate = item.PorDiscountEffectiveDate,
                        PorDiscountExpirationDate = item.PorDiscountExpirationDate,
                        PorDiscountRate = item.PorDiscountRate,
                        PorDriverId = item.PorDriverId,
                        PorFlatFee = item.PorFlatFee,
                        PorRecourseId = item.PorRecourseId,
                        RateClassId = item.RateClassId,
                        TariffCodeId = item.TariffCodeId,
                        UtilityCompanyId = item.UtilityCompanyId
                    };
                    _logger.LogInfo("purchaseOfReceivableList.Add(porItem);");
                    purchaseOfReceivableList.Add(porItem);
                    _logger.LogInfo("purchaseOfReceivableList.Add(porItem); AFTER");
                }
            }
            else
            {
                _logger.LogInfo("null value for results");
            }

            _logger.LogInfo("PurchaseOfReceivableList GeneratePorFromEf(System.Data.Objects.ObjectResult<DataAccessLayerEntityFramework.usp_PurchaseOfReceivables_SELECT_ByUtilityCodeLoadProfileCodeRateClassCodeTariffCode_Result> results) END");
            return purchaseOfReceivableList;

        }
    }
}
