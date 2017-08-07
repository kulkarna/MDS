begin tran  -- rollback  commit

SELECT *
  FROM [Libertypower].[dbo].[ApplicationFeatureSettings]
  
update [Libertypower].[dbo].[ApplicationFeatureSettings]
set featurevalue =1
where id = 1

SELECT *
  FROM [Libertypower].[dbo].[ApplicationFeatureSettings]