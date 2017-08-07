



create view [dbo].[tblHubPriceByZone_vw] as 

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
  FROM [ERCOT].[dbo].[DAM_PRICE_15MIN]  WITH (NOLOCK) where [SETTLEMENT_POINT] like 'hb_%'
  






