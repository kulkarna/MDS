Create Procedure test1
as
Select top 10 * from Lp_common.dbo.log_entry with(nolock)