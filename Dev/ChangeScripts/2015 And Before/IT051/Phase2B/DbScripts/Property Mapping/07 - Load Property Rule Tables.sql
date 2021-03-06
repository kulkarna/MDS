USE LibertyPower
GO

create table #tempRule ( UtilityCode varchar(20) ,RuleCode varchar(max), RuleDescp varchar(max) ) 

insert into #tempRule values ( 'O&R' , '(First 5 Characters of Profile)' , '(First 5 Characters of Profile)'  ) 
insert into #tempRule values ( 'CONED', 'ConEd SC[RateClass],[StratumStart],[StartumEnd]' , 'Replace RateClass and the Startum Range Start and End values. e.g. ConEd SC9, 1758, 8560'  ) 
insert into #tempRule values ( 'NYSEG', '0[LoadProfile]' , 'Replace [LoadProfile] with actual value. e.g. 048' ) 
insert into #tempRule values ( 'NIMO', 'NMP-E_[LoadProfile]_06_CALENDAR' , 'Replace [LoadProfile] with actual value. e.g. NMP-E_4SC3_06_CALENDAR'  ) 
insert into #tempRule values ( 'PEPCO', 'PEPCO MDND' , 'Only if the profile is an integer'  ) 
insert into #tempRule values ( 'PEPCO', 'PEPCO MMGTL2' , 'Only if if profile is MMGTL2A or MMGTL2B' ) 
insert into #tempRule values ( 'PEPCO', 'PEPCO [LoadProfile]' , 'Replace [LoadProfile] with actual value. e.g.PEPCO DMGT2' ) 

-- Get UtiltyIDs
-- ===========================
SELECT vee.ID , vee.Name , tr.UtilityCode
	INTO #UtilityList
FROM #tempRule tr
LEFT JOIN vw_ExternalEntity vee ON vee.Name like '%' + tr.UtilityCode + '%' 


-- Insert PropertyRule
-- ===========================
INSERT INTO [LibertyPower].[dbo].[PropertyRule]
           ([PropertyID],[RuleCode],[RuleDescription],[DateCreated],[CreatedBy])
SELECT 2 , RuleCode , RuleDescp , GETDATE() , 0 
FROM #tempRule tr 


-- Insert ExternalEntityPropertyRule
-- ============================
INSERT INTO [LibertyPower].[dbo].[ExternalEntityPropertyRule]
           ([ExternalEntityID],[PropertyRuleID],[DateCreated],[CreatedBy])
SELECT u.ID, pr.ID , GETDATE() , 0 
FROM #tempRule tr
	JOIN #UtilityList u on u.UtilityCode = tr.UtilityCode
	JOIN [LibertyPower].[dbo].[PropertyRule] pr on pr.RuleCode = tr.RuleCode
 
	
	
		