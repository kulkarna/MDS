USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[UtilityStratumRange](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UtilityId] [int] NOT NULL,
	[ServiceRateClass] [varchar](50) NULL,
	[StratumVariable] [varchar](50) NULL,
	[StratumStart] [float] NOT NULL,
	[StratumEnd] [float] NOT NULL,
 CONSTRAINT [PK_UtilityStratumRange] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


 
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	1	,'ANNUAL KWHR',	0	,	1948	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	1	,'ANNUAL KWHR',	1948	,	2897	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	1	,'ANNUAL KWHR',	2897	,	3897	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	1	,'ANNUAL KWHR',	3897	,	5239	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	1	,'ANNUAL KWHR',	5239	,	7741	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	1	,'ANNUAL KWHR',	0	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	1	,'ANNUAL KWHR',	7741	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	2	,'SUMMER KWHR',	0	,	1500	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	2	,'SUMMER KWHR',	1500	,	3000	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	2	,'SUMMER KWHR',	3000	,	5000	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	2	,'SUMMER KWHR',	5000	,	8000	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	2	,'SUMMER KWHR',	0	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	2	,'SUMMER KWHR',	8000	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	3	,'ANNUAL KWHR',	0	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	4	,'AVG SUMMER KW',	0	,	1500	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	4	,'AVG SUMMER KW',	0	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	4	,'AVG SUMMER KW',	1500	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	5	,'ANNUAL KWHR',	0	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	6	,'MONTHLY KWHR ',	0	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	7	,'ANNUAL KWHR',	0	,	7302	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	7	,'ANNUAL KWHR',	7302	,	15236	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	7	,'ANNUAL KWHR',	15236	,	34512	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	7	,'ANNUAL KWHR',	0	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	7	,'ANNUAL KWHR',	34512	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	8	,'AVG SUMMER KW',	0	,	120	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	8	,'AVG SUMMER KW',	120	,	220	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	8	,'AVG SUMMER KW',	220	,	340	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	8	,'AVG SUMMER KW',	340	,	530	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	8	,'AVG SUMMER KW',	530	,	1500	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	8	,'AVG SUMMER KW',	0	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	8	,'AVG SUMMER KW',	1500	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	9	,'AVG SUMMER KW',	0	,	17	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	9	,'AVG SUMMER KW',	17	,	33	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	9	,'AVG SUMMER KW',	33	,	70	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	9	,'AVG SUMMER KW',	70	,	200	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	9	,'AVG SUMMER KW',	200	,	1500	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	9	,'AVG SUMMER KW',	0	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	9	,'AVG SUMMER KW',	1500	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	10	,'AVG SUMMER KW',	0	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	12	,'NOV - FEB KWHR',	0	,	12000	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	12	,'NOV - FEB KWHR',	12000	,	40000	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	12	,'NOV - FEB KWHR',	40000	,	2000000	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	12	,'NOV - FEB KWHR',	0	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	12	,'NOV - FEB KWHR',	2000000	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	13	,'AVG SUMMER KW',	0	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	21	,'ANNUAL KWHR',	0	,	2199	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	21	,'ANNUAL KWHR',	2199	,	3999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	21	,'ANNUAL KWHR',	3999	,	5499	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	21	,'ANNUAL KWHR',	0	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	21	,'ANNUAL KWHR',	5499	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	29	,'AVG NOV-FEB KW',	0	,	66	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	29	,'AVG NOV-FEB KW',	66	,	188	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	29	,'AVG NOV-FEB KW',	188	,	652	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	29	,'AVG NOV-FEB KW',	652	,	1500	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	29	,'AVG NOV-FEB KW',	0	,	999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	51	,'ANNUAL KWHR',	0	,	47542	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	51	,'ANNUAL KWHR',	47542	,	122555	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	51	,'ANNUAL KWHR',	122555	,	286305	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	51	,'ANNUAL KWHR',	286305	,	1858670	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	51	,'ANNUAL KWHR',	0	,	99999999	)
INSERT INTO UtilityStratumRange ( UtilityId, ServiceRateClass, StratumVariable, StratumStart, StratumEnd ) VALUES (	18,	51	,'ANNUAL KWHR',	1858670	,	99999999	)

