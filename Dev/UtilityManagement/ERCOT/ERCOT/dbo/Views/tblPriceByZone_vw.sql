


CREATE view [dbo].[tblPriceByZone_vw] as 
/* 11/22/2010 Douglas Marino - Changes made to be compliant with the Nodal Project*/

select 
h.RECORDER as ZoneID
,substring(h.RECORDER,7,1) as CMZone
,d.TRADE_DATE as PriceDate
,d.INT001 as PriceH01
,d.INT002 as PriceH02
,d.INT003 as PriceH03
,d.INT004 as PriceH04
,d.INT005 as PriceH05
,d.INT006 as PriceH06
,d.INT007 as PriceH07
,d.INT008 as PriceH08
,d.INT009 as PriceH09
,d.INT010 as PriceH10

,d.INT011 as PriceH11
,d.INT012 as PriceH12
,d.INT013 as PriceH13
,d.INT014 as PriceH14
,d.INT015 as PriceH15
,d.INT016 as PriceH16
,d.INT017 as PriceH17
,d.INT018 as PriceH18
,d.INT019 as PriceH19
,d.INT020 as PriceH20

,d.INT021 as PriceH21
,d.INT022 as PriceH22
,d.INT023 as PriceH23
,d.INT024 as PriceH24
,d.INT025 as PriceH25
,d.INT026 as PriceH26
,d.INT027 as PriceH27
,d.INT028 as PriceH28
,d.INT029 as PriceH29
,d.INT030 as PriceH30

,d.INT031 as PriceH31
,d.INT032 as PriceH32
,d.INT033 as PriceH33
,d.INT034 as PriceH34
,d.INT035 as PriceH35
,d.INT036 as PriceH36
,d.INT037 as PriceH37
,d.INT038 as PriceH38
,d.INT039 as PriceH39
,d.INT040 as PriceH40

,d.INT041 as PriceH41
,d.INT042 as PriceH42
,d.INT043 as PriceH43
,d.INT044 as PriceH44
,d.INT045 as PriceH45
,d.INT046 as PriceH46
,d.INT047 as PriceH47
,d.INT048 as PriceH48
,d.INT049 as PriceH49
,d.INT050 as PriceH50

,d.INT051 as PriceH51
,d.INT052 as PriceH52
,d.INT053 as PriceH53
,d.INT054 as PriceH54
,d.INT055 as PriceH55
,d.INT056 as PriceH56
,d.INT057 as PriceH57
,d.INT058 as PriceH58
,d.INT059 as PriceH59
,d.INT060 as PriceH60

,d.INT061 as PriceH61
,d.INT062 as PriceH62
,d.INT063 as PriceH63
,d.INT064 as PriceH64
,d.INT065 as PriceH65
,d.INT066 as PriceH66
,d.INT067 as PriceH67
,d.INT068 as PriceH68
,d.INT069 as PriceH69
,d.INT070 as PriceH70

,d.INT071 as PriceH71
,d.INT072 as PriceH72
,d.INT073 as PriceH73
,d.INT074 as PriceH74
,d.INT075 as PriceH75
,d.INT076 as PriceH76
,d.INT077 as PriceH77
,d.INT078 as PriceH78
,d.INT079 as PriceH79
,d.INT080 as PriceH80

,d.INT081 as PriceH81
,d.INT082 as PriceH82
,d.INT083 as PriceH83
,d.INT084 as PriceH84
,d.INT085 as PriceH85
,d.INT086 as PriceH86
,d.INT087 as PriceH87
,d.INT088 as PriceH88
,d.INT089 as PriceH89
,d.INT090 as PriceH90

,d.INT091 as PriceH91
,d.INT092 as PriceH92
,d.INT093 as PriceH93
,d.INT094 as PriceH94
,d.INT095 as PriceH95
,d.INT096 as PriceH96
,d.INT097 as PriceH97
,d.INT098 as PriceH98
,d.INT099 as PriceH99
,d.INT100 as PriceH100
,d.TRADE_DATE

--, h.INTERVAL_DATA_ID
--, h.INTERVAL_ID
--, h.RECORDER
--, h.MARKET_INTERVAL
--, h.START_TIME
--, h.STOP_TIME
--, h.SECONDS_PER_INTERVAL
--, h.MEASUREMENT_UNITS_CODE
--, h.DSTPARTICIPANT
--, h.TIMEZONE
--, h.ORIGIN
--, h.EDITED
--, h.INTERNALVALIDATION
--, h.EXTERNALVALIDATION
--, h.MERGEFLAG
--, h.DELETEFLAG
--, h.VALFLAGE
--, h.VALFLAGI
--, h.VALFLAGO
--, h.VALFLAGN
--, h.TKWRITTENFLAG
--, h.DCFLOW
--, h.ACCEPTREJECTSTATUS
--, h.TRANSLATIONTIME
--, h.DESCRIPTOR
--, h.[TIMESTAMP]
--, h.[COUNT]
--, d.TRANSACTION_DATE
--, d.LOG_ID
--, d.INTERVAL_DATA_ID 
--, d.TRANSACTION_DATE 
--, d.TRADE_DATE
--,* 
from 
dbo.MARKET_INTERVAL_HEADER h inner join
dbo.MARKET_INTERVAL_DATA d on h.interval_data_id=d.interval_data_id inner join
(select 
mh.RECORDER
,md.TRADE_DATE
,max(md.TRANSACTION_DATE) MAX_DATE
from 
dbo.MARKET_INTERVAL_HEADER mh inner join
dbo.MARKET_INTERVAL_DATA md on mh.interval_data_id=md.interval_data_id
group by 
mh.RECORDER
,md.TRADE_DATE) mxd on h.RECORDER=mxd.RECORDER and d.TRADE_DATE=mxd.TRADE_DATE and d.TRANSACTION_DATE=mxd.MAX_DATE
where substring(h.RECORDER,1,5)='MCPEL' --or substring(h.RECORDER,1,5)='MCPER'

UNION -- Disable until Dec 1 2010

SELECT 
substring([SETTLEMENT_POINT],4,Len([SETTLEMENT_POINT])) as ZoneID
      --,[SETTLEMENT_POINT]
      ,substring([SETTLEMENT_POINT],4,1) as CMZone
,DELIVERY_DATE as PriceDate
,INT001 as PriceH01
,INT002 as PriceH02
,INT003 as PriceH03
,INT004 as PriceH04
,INT005 as PriceH05
,INT006 as PriceH06
,INT007 as PriceH07
,INT008 as PriceH08
,INT009 as PriceH09
,INT010 as PriceH10

,INT011 as PriceH11
,INT012 as PriceH12
,INT013 as PriceH13
,INT014 as PriceH14
,INT015 as PriceH15
,INT016 as PriceH16
,INT017 as PriceH17
,INT018 as PriceH18
,INT019 as PriceH19
,INT020 as PriceH20

,INT021 as PriceH21
,INT022 as PriceH22
,INT023 as PriceH23
,INT024 as PriceH24
,INT025 as PriceH25
,INT026 as PriceH26
,INT027 as PriceH27
,INT028 as PriceH28
,INT029 as PriceH29
,INT030 as PriceH30

,INT031 as PriceH31
,INT032 as PriceH32
,INT033 as PriceH33
,INT034 as PriceH34
,INT035 as PriceH35
,INT036 as PriceH36
,INT037 as PriceH37
,INT038 as PriceH38
,INT039 as PriceH39
,INT040 as PriceH40

,INT041 as PriceH41
,INT042 as PriceH42
,INT043 as PriceH43
,INT044 as PriceH44
,INT045 as PriceH45
,INT046 as PriceH46
,INT047 as PriceH47
,INT048 as PriceH48
,INT049 as PriceH49
,INT050 as PriceH50

,INT051 as PriceH51
,INT052 as PriceH52
,INT053 as PriceH53
,INT054 as PriceH54
,INT055 as PriceH55
,INT056 as PriceH56
,INT057 as PriceH57
,INT058 as PriceH58
,INT059 as PriceH59
,INT060 as PriceH60

,INT061 as PriceH61
,INT062 as PriceH62
,INT063 as PriceH63
,INT064 as PriceH64
,INT065 as PriceH65
,INT066 as PriceH66
,INT067 as PriceH67
,INT068 as PriceH68
,INT069 as PriceH69
,INT070 as PriceH70

,INT071 as PriceH71
,INT072 as PriceH72
,INT073 as PriceH73
,INT074 as PriceH74
,INT075 as PriceH75
,INT076 as PriceH76
,INT077 as PriceH77
,INT078 as PriceH78
,INT079 as PriceH79
,INT080 as PriceH80

,INT081 as PriceH81
,INT082 as PriceH82
,INT083 as PriceH83
,INT084 as PriceH84
,INT085 as PriceH85
,INT086 as PriceH86
,INT087 as PriceH87
,INT088 as PriceH88
,INT089 as PriceH89
,INT090 as PriceH90

,INT091 as PriceH91
,INT092 as PriceH92
,INT093 as PriceH93
,INT094 as PriceH94
,INT095 as PriceH95
,INT096 as PriceH96
,INT097 as PriceH97
,INT098 as PriceH98
,INT099 as PriceH99
,INT100 as PriceH100
,DELIVERY_DATE as TRADE_DATE
  FROM [ERCOT].[dbo].[DAM_PRICE_15MIN]  WITH (NOLOCK) where [SETTLEMENT_POINT] like 'lz_%'
  





