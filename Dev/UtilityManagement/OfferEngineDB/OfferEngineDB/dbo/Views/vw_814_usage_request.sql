create view [dbo].[vw_814_usage_request]  as 

select 
distinct 
a.esiid as AccountNumber
,c.TdspDuns as UtilityDuns
,c.CrDuns as LibertyPowerEntityDuns
,c.TransactionNbr
,c.ReferenceNbr
,a.ServiceType2
--,c.TransactionSetId
--,c.TransactionSetPurposeCode
,c.Direction
,c.ActionCode as TransactionType
,a.ActionCode TransactionStatus
--,convert(datetime,a.SpecialReadSwitchDate,101) as  SpecialReadSwitchDate
--,convert(datetime,a.EsiidStartDate,101) as FlowStartDate
--,convert(datetime,a.EsiidEndDate,101) as DeEnrollmentDate
,convert(datetime,c.TransactionDate,101) as TransactionDate
,a.PreviousESiId
--,b.EntityName as AccountName
--,b.Address1 
--,b.Address2
--,b.City
--,b.State
--,b.PostalCode
--,b.CountryCode
--,b.ContactCode
--,b.ContactName
--,b.ContactPhoneNbr1
--,b.ContactPhoneNbr2
,d.MeterNumber
,a.CapacityObligation
,a.TransmissionObligation
,d.LoadProfile
,d.RateClass
,d.RateSubClass
,d.MeterType
,a.LBMPZone
,a.PowerRegion
,a.StationId
,a.DistributionLossFactorCode
,a.LDCBillingCycle
,d.MeterCycle
--,a.ESPCommodityPrice 
--,a.PremiseType
--,a.BillType
--,a.BillCalculator
--,a.NotificationWaiver
--,d.ESPRateCode
,e.RejectCode
,e.RejectReason
--,f.ChangeReason
--,f.ChangeDescription
from 
ISTA..tbl_814_header c left join
ISTA..tbl_814_Service a  on a.[814_key]=c.[814_key] left join
ISTA..tbl_814_Service_Meter d on a.Service_key=d.Service_key left join
ISTA..tbl_814_Service_Reject e on e.Service_key=a.Service_key left join
ISTA..tbl_814_Service_Account_Change f on a.Service_key=f.Service_key left join
(SELECT 
      [814_Key]      
      ,Max([EntityName]) EntityName
      ,Max([EntityName2]) EntityName2
      ,Max([EntityName3]) EntityName3
      ,Max([EntityDuns]) EntityDuns
      ,Max([Address1]) Address1
      ,Max([Address2]) Address2
      ,Max([City]) City
      ,Max([State]) [State]
      ,Max([PostalCode]) PostalCode
      ,Max([CountryCode]) CountryCode
      ,Max([ContactCode]) ContactCode
      ,Max([ContactName]) ContactName
      ,Max([ContactPhoneNbr1]) ContactPhoneNbr1
      ,Max([ContactPhoneNbr2]) ContactPhoneNbr2
  FROM ISTA..[tbl_814_Name] group by [814_Key]) b on a.[814_key]=b.[814_key]
where a.ServiceType2='HU'
