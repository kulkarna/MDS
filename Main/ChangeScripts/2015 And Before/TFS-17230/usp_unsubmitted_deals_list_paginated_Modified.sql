Use Lp_deal_capture
Go  
Create PROCEDURE [dbo].[usp_unsubmitted_deals_list_paginated]  
 @p_SalesChannel nvarchar(50), @p_Username nvarchar(50), @p_DateCreated nvarchar(50), @p_ContractNumber nvarchar(50), @PageNumber int
AS  
BEGIN  
 
IF OBJECT_ID(N'TEMPDB..#T') <> 0 DROP TABLE #T
CREATE TABLE #T
(
 full_name varchar(100)
, sales_channel_role nvarchar(50)
, username nchar(100)
, date_created datetime
, contract_nbr char(12)
, contract_type varchar(20)
)
 -- For Renewall  	
IF OBJECT_ID(N'TEMPDB..#T1') <> 0 DROP TABLE #T1
CREATE TABLE #T1
(
 full_name varchar(100)
, sales_channel_role nvarchar(50)
, username nchar(100)
, date_created datetime
, contract_nbr char(12)
, contract_type varchar(20)
, original_contract_nbr varchar(13)
)
--For UNION 
IF OBJECT_ID(N'TEMPDB..#T3') <> 0 DROP TABLE #T3
CREATE TABLE #T3
(
 full_name varchar(100)
, sales_channel_role nvarchar(50)
, username nchar(100)
, date_created datetime
, contract_nbr char(12)
, contract_type varchar(20)
, original_contract_nbr varchar(13)
)

--For Rownumber after union
 IF OBJECT_ID(N'TEMPDB..#T2') <> 0 DROP TABLE #T2
CREATE TABLE #T2
(
 full_name varchar(100)
, sales_channel_role nvarchar(50)
, username nchar(100)
, date_created datetime
, contract_nbr char(12)
, contract_type varchar(20)
, original_contract_nbr varchar(13)
, RowNumber bigint
)

 IF OBJECT_ID(N'TEMPDB..#final_dc') <> 0 DROP TABLE #final_dc
 CREATE TABLE #final_dc
(
 CustomerName varchar(50)
 , SalesChannel varchar(50)
 , UserName varchar(50)
 , DateCreated varchar(50)
 , ContractNumber varchar(50)
 , ContractType varchar(50)
 , OriginalContractNumber varchar(50)
 , AccountCount int
 , First10Accounts varchar(500)
)  
   
	 
 declare @sql nvarchar(max), @where nvarchar(max)  
    
 declare @customerName varchar(50), @salesChannel varchar(50), @userName varchar(50), 
  @dateCreated varchar(50), @contractNumber varchar(50), @contractType varchar(50),
  @originalContractNumber varchar(50), @accountCount int, @first10Accounts varchar(500),
  @t_ac varchar(50)  
 
 declare @date datetime, @tdate datetime, @adate datetime  
  set @date = convert(datetime, @p_DateCreated)  
  set @tdate = convert(datetime, floor(convert(numeric(18, 9), @date)))  
  set @adate = dateadd(ss, 59, dateadd(mi, 59, dateadd(hh, 23, @tdate)))  
 
 --For pagination 
 Declare @RowStart int 
 Declare @RowEnd int
 Declare @PageSize  int

 SET @PageSize=20;
 SET @RowStart = @PageSize * @PageNumber + 1; 
 SET @RowEnd = @RowStart + @PageSize - 1 ; 
 --SELECT @RowEnd,@RowStart
  
 set @sql = N'select n.full_name,  
     dc.sales_channel_role,  
     dc.username,  
     dc.date_created,  
     dc.contract_nbr,  
     dc.contract_type
    from lp_deal_capture..deal_contract dc with (nolock) left join lp_deal_capture..deal_name  n  with (nolock)
    on dc.contract_nbr = n.contract_nbr and dc.customer_name_link = n.name_link'  
  
 set @where = N''  
  
 if @p_SalesChannel <> ''  
 begin  
  if @where = N''  
  begin  
   set @where = N'  
    where'  
  end  
    
  set @where = @where + N' dc.sales_channel_role like ''%' + cast(@p_SalesChannel as nvarchar) + '%'''  
 end  
  
 if @p_UserName <> ''  
 begin  
  if @where = N''  
  begin  
   set @where = N'  
    where'  
  end  
  else  
   set @where = @where + N' and'  
    
  set @where = @where + N' dc.username like ''%' + cast(@p_UserName as nvarchar) + '%'''  
 end  
  
 if @p_DateCreated <> ''  
 begin  
  if @where = N''  
  begin  
   set @where = N'  
    where'  
  end  
  else  
   set @where = @where + N' and'  
      
  set @where = @where + N' (dc.date_created > ''' + convert(nvarchar, @tdate) + ''' and dc.date_created < ''' + convert(nvarchar, @adate) + ''')'  
 end  
  
 if @p_ContractNumber <> ''  
 begin  
  if @where = N''  
  begin  
   set @where = N'  
    where'  
  end  
  else  
   set @where = @where + N' and'  
    
  set @where = @where + N' dc.contract_nbr like ''%' + cast(@p_ContractNumber as nvarchar) + '%'''  
 end  
  
 set @sql = @sql + @where  

 insert into #T
 exec sp_executesql @sql
  

 ---Renewals

 set @sql = N'select n.full_name,  
     dc.sales_channel_role,  
     dc.username,  
     dc.date_created,  
     dc.contract_nbr,  
     dc.contract_type,  
     dc.original_contract_nbr
    from lp_contract_renewal..deal_contract  dc with (nolock) left join lp_contract_renewal..deal_name n  with (nolock) 
    on dc.contract_nbr = n.contract_nbr and dc.customer_name_link = n.name_link'  
      
 set @sql = @sql + @where  
 
 Insert into #T1
 exec sp_executesql @sql 
 
--- union
  declare @sql1 nvarchar(max)
  set @sql1 = N'SELECT full_name, sales_channel_role, username, date_created, contract_nbr , contract_type , null 
               FROM #T union 
               SELECT full_name, sales_channel_role, username, date_created, contract_nbr , contract_type,original_contract_nbr  
                FROM #T1 order by date_created desc'
                            
 Insert into #T3          
 exec sp_executesql @sql1
 
 ---Pagination logic  
   set @sql1  =  N' SELECT full_name, sales_channel_role, username, date_created, contract_nbr , contract_type,original_contract_nbr 
                   ,ROW_NUMBER() over (order by (select 0) ) as RowNumber
                   FROM #T3'
  

 Insert into #T2
 exec sp_executesql @sql1   
  
  set @sql1 = N'SELECT full_name, sales_channel_role, username, date_created, contract_nbr , contract_type,original_contract_nbr  
                FROM #T2 Where RowNumber >= ' + cast(@RowStart as nvarchar)+ ' and RowNumber <= ' + cast(@RowEnd as nvarchar)  
 
 declare @stat nvarchar(max)    
 set @stat =  N'set @cur_dc = cursor for ' + @sql1 + N'; open @cur_dc'  
  
 declare @cur_dc cursor    
 exec sp_executesql @stat, N'@cur_dc cursor output', @cur_dc output  
  
 ---- Cursor to append top 10 accounts per customer
	 fetch @cur_dc  
	 into @customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType, @originalContractNumber  
	  
	 while @@fetch_status = 0  
	 begin  
	  set @accountCount = (select count(*) from lp_contract_renewal..deal_contract_account with(nolock) where lp_contract_renewal..deal_contract_account.contract_nbr = @contractNumber)  
	    
	  declare cur_fdc cursor Fast_Forward  for  
	   select top 10 account_number  
	   from lp_contract_renewal..deal_contract_account  with (nolock) 
	   where lp_contract_renewal..deal_contract_account.contract_nbr = @contractNumber  
	  
	  open cur_fdc  
	  
	  fetch next from cur_fdc  
	  into @t_ac  
	  
	  set @first10Accounts = ''  
	  
	  while @@fetch_status = 0  
	  begin  
	   if @first10Accounts <> ''  
	   begin  
		set @first10Accounts = @first10Accounts + ', '  
	   end  
	  
	   set @first10Accounts = @first10Accounts + @t_ac  
	  
	   fetch cur_fdc  
	   into @t_ac  
	  end  
	  
	  close cur_fdc  
	  deallocate cur_fdc  
	   fetch @cur_dc  
	  into @customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType, @originalContractNumber 

	  insert into #final_dc values(@customerName, @salesChannel, @userName, @dateCreated, @contractNumber, @contractType, @originalContractNumber, @accountCount, @first10Accounts)  
	  
	  
	 end  
	 close @cur_dc  
	 deallocate @cur_dc  

---Final Query
 select * from #final_dc 
 
 Drop table #t
 Drop table #t1
 Drop table #t2
 Drop table #t3
 Drop table #final_dc
 
END  




  
  
  