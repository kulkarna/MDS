use libertypower 
set identity_insert libertypower..reasoncode on

if (not exists(select 1 from reasoncode (nolock) where value=17))
insert into reasoncode(value,description,created,createdby)
values(17,'AGGREGATED KWH FROM OVERLAPPING USAGES',GETDATE(),'jjohn')

set identity_insert libertypower..reasoncode off