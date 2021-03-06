USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_status_process]    Script Date: 04/20/2015 13:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================================
-- Modified 1/20/2015 - Diogo Lima, Sadiel Jarvis
-- (TFS 59805)
-- Removing the call to usp_UpdateAccountStatusNew.
-- =======================================
-- Modifed      3/13/2015
-- TFS:         64869
-- Desciption:  Removed status 04000/20 and 03000/20 for Re-enrollment process.
--              Added validation to check if contract wasn't rejected during dealscreening.
--
-- Modified:   04/21/2015
-- TFS:        69157
-- Desciption: 906000-10 and 06000-20 status should not be used as they are obsolete now.
-- =======================================

ALTER procedure [dbo].[usp_account_status_process]        
(@p_username                                        nchar(100),        
 @p_process_id                                      varchar(50) = ' ',        
 @p_account_id                                      varchar(12) = 'NONE',        
 @p_account_number                                  varchar(30) = 'NONE',        
 @p_param_01                                        varchar(20) = ' ' output,        
 @p_param_02                                        varchar(20) = ' ' output,        
 @p_param_03                                        varchar(20) = ' ' output,        
 @p_param_04                                        varchar(20) = ' ' output,        
 @p_param_05                                        varchar(20) = ' ' output,         
 @p_param_06                                        varchar(20) = ' ' output,        
 @p_param_07                                        varchar(20) = ' ' output,        
 @p_param_08                                        varchar(20) = ' ' output,        
 @p_error                                           char(01) = ' ' output,        
 @p_msg_id                                          char(08) = ' ' output,        
 @p_descp                                           varchar(250) = ' ' output,        
 @p_descp_add                                       varchar(100) = ' ' output,        
 @p_result_ind                                      char(01) = 'Y')        
as        
    
SET NOCOUNT ON;      
         
declare @w_error                                    char(01)        
declare @w_msg_id                                   char(08)        
declare @w_descp                                    varchar(250)        
declare @w_return                                   int        
declare @w_descp_add                                varchar(100)        
declare @w_application                              varchar(20)        
         
select @w_error                                     = 'I'        
select @w_msg_id                                    = '00000001'        
select @w_descp                                     = ' '        
select @w_return                                    = 0        
select @w_descp_add                                 = ' '        
select @w_application                               = 'COMMON'        
        
declare @w_getdate                                  datetime        
declare @w_utility_id                               char(15)        
declare @w_contract_nbr                             char(12)        
declare @w_account_id                               char(12)        
declare @w_contract_type                            varchar(35)        
declare @w_account_type                             varchar(35)        
declare @w_por_option                               varchar(03)        
declare @w_order                                    int        
declare @t_order                                    int        
declare @w_check_type                               char(15)        
declare @w_check_request_id                         char(25)        
declare @w_approval_status                          char(15)        
declare @w_approved_status                          char(15)        
declare @w_approved_sub_status                      char(15)        
declare @w_rejected_status                          char(15)        
declare @w_rejected_sub_status                      char(15)        
declare @w_status_code                              char(15)        
declare @w_enrollmentAcceptDate      datetime        
declare @w_DropAcceptDate       datetime        
declare @w_comments         varchar(max)   
declare @w_isContractRejected      BIT = 0      
    
        
        
select @w_account_id                                = @p_account_id        
select @w_getdate                                   = getdate()      
    
        
        
--begin 1-55261478        
set @w_enrollmentAcceptDate=(select top 1 request_date as 'EnrollmentAcceptDate' from integration..EDI_814_transaction t with (nolock)        
join integration..EDI_814_transaction_result tr with (nolock) on t.EDI_814_transaction_id=tr.EDI_814_transaction_id        
join integration..lp_transaction l  with (nolock) on l.lp_transaction_id =tr.lp_transaction_id        
where t.account_number=@p_account_number and l.lp_transaction_id=4    
order by t.date_created)       
        
        
set @w_dropAcceptDate=( select top 1 request_date as 'DropAcceptDate' from integration..EDI_814_transaction t with (nolock)        
join integration..EDI_814_transaction_result tr  with (nolock) on t.EDI_814_transaction_id=tr.EDI_814_transaction_id        
join integration..lp_transaction l  with (nolock) on l.lp_transaction_id =tr.lp_transaction_id        
where t.account_number=@p_account_number and l.lp_transaction_id=8    
order by t.date_created desc )        
        
if isnull(@w_dropAcceptDate,0)=0         
begin        
 set @w_dropAcceptDate=getdate()        
end        
--end 1-55261478    
  
IF EXISTS (SELECT 1  
     FROM LibertyPower..WIPTask       WIPT (NOLOCK)  
     JOIN LibertyPower..WIPTaskHeader WTH  (NOLOCK) ON WTH.WIPTaskHeaderId = WIPT.WIPTaskHeaderId  
     JOIN LibertyPower..WorkflowTask  WT   (NOLOCK) ON WT.WorkflowTaskID = WIPT.WorkflowTaskID  
     JOIN Libertypower..Workflow    WF (NOLOCK) ON WF.WorkflowId = WT.WorkflowId  
     JOIN LibertyPower..TaskStatus    TS   (NOLOCK) ON TS.TaskStatusID = WIPT.TaskStatusID  
     JOIN Libertypower..Contract  C (NOLOCK) ON C.ContractID = WTH.ContractId  
     JOIN Libertypower..Account A  (NOLOCK) ON A.CurrentContractID = C.ContractID   
     WHERE WorkflowName NOT LIKE 'Tax%Exemption%' AND TS.statusname = 'Rejected' AND A.AccountIDLegacy = @w_account_id )   
   
	BEGIN
     SET @w_isContractRejected = 1      
    END ELSE     
	BEGIN
     SET @w_isContractRejected = 0
	END

if @w_account_id                                    = 'NONE'        
begin        
   select @w_account_id                             = AccountIdLegacy        
   from Libertypower.dbo.Account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx1)        
   where accountnumber                             = @p_account_number        
end        
        
declare @w_status                                   varchar(15)        
declare @w_sub_status                               varchar(15)               
     
declare @p_status                                   varchar(15)        
declare @p_sub_status                               varchar(15)        
        
select @w_status                                    = ' '        
select @w_sub_status                                = ' '        
--select @w_sub_status                                = '19000101'        
         
if @p_process_id                                    = 'DEAL CAPTURE'        
begin        
   exec @w_return                                   = usp_account_status_deal_capture @p_username,        
                                                                                      @p_param_01, --utility id        
                                                                @p_param_02 output, --status        
                                                                                      @p_param_03 output, --sub_status        
                                                                                      @p_param_04 output -- credit check        
   return @w_return        
end        
        
if @p_process_id                                    = 'DEENROLLMENT REQUEST'        
begin        
        
   SET @p_status = Libertypower.dbo.ufn_GetAccountStatus (@p_account_id)    
   SET @p_sub_status = Libertypower.dbo.ufn_GetAccountSubStatus (@p_account_id)    
        
   select @w_status                                 = case when ltrim(rtrim(@p_status))        
                                                              + ltrim(rtrim(@p_sub_status)) <= '0500010'        
                                                           or   ltrim(rtrim(@p_status))        
              + ltrim(rtrim(@p_sub_status)) = '0600010'        
                                                           or   RTRIM(@p_status) = '01000'        
                                                           then '999999' -- Modified 2007-11-29 by Douglas Marino to reflect the right status it was updating to 999998        
                                                           when ltrim(rtrim(@p_status))        
                                                              + ltrim(rtrim(@p_sub_status)) = '1300060'        
                                                           then '911000'        
                                                           when ltrim(rtrim(@p_status))        
                                                              + ltrim(rtrim(@p_sub_status)) = '0500030'         
                                                              and @w_DropAcceptDate <= @w_enrollmentAcceptDate         
                                                           then '999998'        
                                                           when ltrim(rtrim(@p_status)) --1-55261478        
                                                              + ltrim(rtrim(@p_sub_status)) = '0500030'         
                                                              and @w_DropAcceptDate > @w_enrollmentAcceptDate        
                                                           then '11000'     
                                                           when ltrim(rtrim(@p_status)) --1-55261478        
                                                              + ltrim(rtrim(@p_sub_status)) = '0500030'         
                                                           then '11000'                                                                 
                                                           when ltrim(rtrim(@p_status))      
                                                              + ltrim(rtrim(@p_sub_status)) = '90500010'  --TFS 51619    
                                                           then '11000'       
                                                           else '12000'  --TFS 47892      
                                                      end,        
          @w_sub_status                             = case when ltrim(rtrim(@p_status))        
                                                              + ltrim(rtrim(@p_sub_status)) <= '0500010'        
                                                           or   ltrim(rtrim(@p_status))        
                                                              + ltrim(rtrim(@p_sub_status)) = '0600010'        
                                                           then '10'        
                                                           when ltrim(rtrim(@p_status))        
                                                              + ltrim(rtrim(@p_sub_status)) = '1300060'        
                                                           then '10'      
                                                           when ltrim(rtrim(@p_status)) --1-55261478        
                                                              + ltrim(rtrim(@p_sub_status)) = '0500030'         
                                                              and @w_DropAcceptDate <= @w_enrollmentAcceptDate        
                                                           then '10'                                                                   
                                                           when ltrim(rtrim(@p_status)) --1-55261478        
                                                              + ltrim(rtrim(@p_sub_status)) = '0500030'         
                                                              and @w_DropAcceptDate > @w_enrollmentAcceptDate        
                                                           then '50'    
                                                           when ltrim(rtrim(@p_status)) --1-55261478     
                                                              + ltrim(rtrim(@p_sub_status)) = '0500030'         
                                                           then '30'    
                                                           when ltrim(rtrim(@p_status))      
                                                              + ltrim(rtrim(@p_sub_status)) = '90500010'  --TFS 51619    
                                                           then '30'                                                                    
                                                           else '10'  --TFS 47892      
                                                      end        
    goto goto_account        
        
end        
                                                             
if @p_process_id                                    = 'ENROLLMENT-REENROLLMENT'        
begin        
        
   select @p_param_06                               = '13000'        
   select @p_param_07        = '60'        
        
   if  ltrim(rtrim(@p_param_03))        
   +   ltrim(rtrim(@p_param_04))                    = '1100030'        
   begin        
      select @p_param_06                            = '905000'        
      select @p_param_07                            = '10'        
        
        --pbi 69157: 906000-10 status is obsolete
        
      --if  @p_param_02                               = 'YES'        
      --begin        
      --   select @p_param_06                         = '906000'        
      --   select @p_param_07                         = '10'        
      --end        
   end        
        
   if  (ltrim(rtrim(@p_param_03))        
   +   ltrim(rtrim(@p_param_04)))                   = '99999910'        
   begin        
           
      if @w_isContractRejected                      = 0       
      begin        
         select @p_param_06                         = '05000'        
         select @p_param_07                         = '10'        
      end  
	  else   
	  if @w_isContractRejected                      = 1
	  begin
	   select @w_error                               = 'E'        
	   select @w_msg_id                              = '00001081'
	  end  
           
   end        
        
   /*Ticket 21747*/        
   if ltrim(rtrim(@p_param_03))                     = '999998'        
      or        
      ltrim(rtrim(@p_param_03))        
   +  ltrim(rtrim(@p_param_04))                    = '0500025' -- 1-1950791        
   begin        
        select @p_param_06                          = '05000'        
        select @p_param_07                          = '10'        
   end        
           
   if ltrim(rtrim(@p_param_03))        
   +  ltrim(rtrim(@p_param_04))                     = ltrim(rtrim(@p_param_06))        
                                                    + ltrim(rtrim(@p_param_07))        
   begin        
      goto goto_select        
   end        
        
   select @w_status                                 = @p_param_06        
   select @w_sub_status                             = @p_param_07        
        
   goto goto_account        
end        
        
if @p_process_id                                    = 'RETENTION LOST'        
begin        
   select @p_param_05                               = @p_param_03        
 select @p_param_06                               = @p_param_04        
        
   if ltrim(rtrim(@p_param_03))        
   +  ltrim(rtrim(@p_param_04))                     < '1100030'        
   begin        
      select @p_param_05                            = '11000'        
      select @p_param_06                            = '30'        
   end        
        
   if ltrim(rtrim(@p_param_03))        
   +  ltrim(rtrim(@p_param_04))                     = ltrim(rtrim(@p_param_05))        
                                                    + ltrim(rtrim(@p_param_06))        
   begin        
      goto goto_select        
   end        
        
   select @w_status                                 = @p_param_05        
   select @w_sub_status                             = @p_param_06        
        
   goto goto_account        
end        
        
if @p_process_id = 'RETENTION SAVE'        
begin        
        
   declare @currentstatus varchar(10)        
   set @currentstatus = ltrim(rtrim(@p_param_03)) + ltrim(rtrim(@p_param_04))        
        
   -- ticket 24172        
   -- Logic simplified to reduce errors.  See Vault for old version.        
        
   if @currentstatus in ('1100040','1100050','91100010')  -- If utility knows of drop request, schedule reenrollment.        
   begin        
   select @p_param_05 = '13000'        
   select @p_param_06 = '60'        
   end        
   else if @currentstatus in ('1100010','1100020','1100030')  -- If utility does not know yet, act like nothing happened, put account back to enrolled.        
   begin        
      select @p_param_05 = '905000'        
      select @p_param_06 = '10'        
   end        
   else  -- Other statuses should not be modified by this process.        
   begin        
   goto goto_select        
   end        
           
        
   if @currentstatus = ltrim(rtrim(@p_param_05)) + ltrim(rtrim(@p_param_06))        
   begin        
      goto goto_select        
   end        
        
   select @w_status = @p_param_05, @w_sub_status = @p_param_06        
        
   goto goto_account        
end        
        
if @p_process_id                                    = 'ENROLLMENT-FILE'        
begin        
   select @w_status                                 = '05000'        
   select @w_sub_status                             = '20'        
        
   goto goto_account        
        
end        
       
--TFS 69157: Obsolete status        
--if @p_process_id                                    = 'ENROLLMENT-CONSOLIDATED-FILE'        
--begin        
--   select @w_status                                 = '06000'        
--   select @w_sub_status                             = '20'        
        
--   goto goto_account        
        
--end        
        
if @p_process_id                                    = 'DEENROLLMENT-FILE'        
begin        
        
   select @w_status                                 = '11000'        
   select @w_sub_status                             = '40'        
        
   goto goto_account        
        
end        
        
if @p_process_id                                    = 'SET NUMBER'        
begin        
        
   select @w_status                                 = @p_param_01        
   select @w_sub_status                             = @p_param_02        
--the statuses can be: Type 3: 05000 25, 13000 60, 05000 27, 911000 10, 11000 50, 999998 10        
--      Type 4: 13000 80, 05000 30,        
--      Type 12: 13000 80, 05000 30,        
--      Type 8: 999998 10,  911000 10, 11000 50        
--      Type 6: 999998 10,  911000 10, 11000 50        
--      Type 7: 05000 25        
        
   goto goto_account        
end        
        
if @p_process_id                                    = 'TPV'        
begin        
        
   select @w_status                                 = '03000'        
   select @w_sub_status                             = '20'        
        
   goto goto_account        
end        
        
select @w_application                               = 'COMMON'        
select @w_error                                     = 'E'        
select @w_msg_id                                    = '00000051'        
select @w_return                                    = 1        
select @w_descp_add                                 = '(Process ID Not Exist)'        
goto goto_select        
        
goto_account:        
        
--*****        
begin tran account        
        
set @w_comments          = @p_process_id + ' (Processed on ' + convert(varchar(10), @w_getdate , 101) + ').'   -- Added ticket SD21269        
       
        
-- Update account status        
exec @w_return = lp_account..usp_account_status_process_upd @p_username,        
                                                            @p_process_id,        
                                                            @w_account_id,        
                                                            @w_status,        
                                                            @w_sub_status,        
                                                            @p_param_01,        
                                                            @p_param_02,        
                                                            @p_param_03,        
                                                            @p_param_04,        
                                                            @p_param_05,        
                                                            @p_param_06,        
                                                            @p_param_07,        
                                                            @p_param_08,        
                                                            @w_descp_add output,        
               @w_comments        
                       
--exec Libertypower..usp_UpdateAccountStatusNew @w_account_id, @w_status, @w_sub_status        
        
if @w_return                                        = 1        
begin        
   rollback tran account        
   select @w_error                                  = 'E'        
   select @w_msg_id                                 = '00000051'        
   goto goto_select        
end        
        
---- PBI 1004 implementation: resubmit new rate to ISTA for multi-term implementation Start here --------------------------        
IF (@w_status='13000' and @w_sub_status='80')        
BEGIN        
 DECLARE @UserId int, @IsMultiTerm bit;        
 DECLARE @EffReenrollmentDate DateTime        
 SELECT @UserId=UserID         
 FROM LibertyPower.dbo.[User] with (nolock)         
 WHERE UserName=@p_username;        
 SET @EffReenrollmentDate=Convert(DateTime,Convert(char(10),DATEADD(d,1,GETDATE()),101))        
 EXEC @IsMultiTerm=LibertyPower.dbo.usp_IsMultiTermProductBrandAssociatedWithCurrentAccount @AccountIdLegacy=@w_account_id, @CurrentDate=@EffReenrollmentDate        
 IF (@IsMultiTerm=1)        
 BEGIN        
  EXEC @w_return = LibertyPower.dbo.usp_AddRecordForReEnrolledAccountToMultiTermProcessingTable @AccountIdLegacy=@w_account_id, @ReenrollmentDate=@EffReenrollmentDate, @SubmitterUserId=@UserId;        
  IF @w_return = 1        
  BEGIN        
   rollback tran account        
   select @w_error = 'E'        
   select @w_msg_id = '00000051'        
   goto goto_select        
  END        
 END        
END        
---- PBI 1004 implementation: resubmit new rate to ISTA for multi-term implementation End here --------------------------        
        
commit tran account        
--*****        
        
---- Call Comm Trans stored proc to determine what commission transaction needs to be created        
---- ========================================================================================        
execute lp_commissions.dbo.usp_transaction_request_enrollment_process        
  @p_account_id = @w_account_id                        
 , @p_contract_nbr = null -- optional        
 , @p_transaction_type_code = null -- optional         
 , @p_reason_code = ''        
 , @p_source = @p_process_id        
 , @p_username = @p_username        
        
        
        
goto_select:        
        
if @w_error                                        <> 'N'        
begin        
   exec lp_common..usp_messages_sel @w_msg_id,        
                                    @w_descp output,        
                                    @w_application        
   select @w_descp                                  = ltrim(rtrim(@w_descp))        
                                                    + ' '        
                                                    + @w_descp_add         
end        
         
if @p_result_ind                                    = 'Y'        
begin        
   select flag_error                                = @w_error,        
          code_error                                = @w_msg_id,        
          message_error                             = @w_descp        
   goto goto_return        
end        
        
select @p_error                                     = @w_error,        
       @p_msg_id                                    = @w_msg_id,        
       @p_descp                                     = @w_descp        
         
goto_return:        
return @w_return     
    
SET NOCOUNT OFF; 