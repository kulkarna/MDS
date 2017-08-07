use LibertyPower

update libertypower..UtilityFileDelimiters
set FieldDelimiter=N'*'
where UtilityCode like 'WMECO'


update libertypower..UtilityFileDelimiters
set FieldDelimiter=N'>'
where UtilityCode like 'CL&P'


