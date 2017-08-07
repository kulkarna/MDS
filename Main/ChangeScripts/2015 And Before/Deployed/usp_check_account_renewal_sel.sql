USE [lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_check_account_renewal_sel]    Script Date: 04/18/2012 11:32:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/19/2007
-- Description:	Select accounts for renewal
-- =============================================
ALTER procedure [dbo].[usp_check_account_renewal_sel]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12) ,
 @p_account_id                                      char(12) = 'NONE',
 @p_account_number                                  varchar(30) =  'NONE',
 @p_check_type                                      char(15),
 @p_check_request_id                                char(25),
 @p_request_id                                      varchar(50) = 'NONE',
 @p_action                                          varchar(20) = 'NONE',
 @p_date_created									datetime = NULL) -- Ticket 1-12504523
as

if  @p_account_id                                   = 'NONE' 
and @p_account_number                              <> 'NONE' 
and @p_account_number                              <> ' '  
begin
   select @p_account_id                             = rtrim(account_id)
   from lp_account..account_renewal with (NOLOCK)
   where @p_account_number                          = account_number
end

declare @w_account_number                           varchar(30)
select @w_account_number                            = ' '

if  @p_account_id                                  <> 'NONE'
begin
   select @w_account_number                         = rtrim(account_number)
   from lp_account..account_renewal with (NOLOCK)
   where @p_account_id                              = account_id
end

if  @p_account_id                                    = 'NONE' 
and @p_account_number                                = 'NONE'  
begin
   select @p_account_id                              = ''
end

declare @w_row_number                               int
declare @w_row_number_max                           int

select @w_row_number                                = 0 
select @w_row_number_max                            = 0 

if  @p_request_id                                  <> 'NONE'
and @p_action                                      <> 'NONE'
begin

   select @w_row_number_max                         = isnull(max(row_number), 0)
   from retention_records WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = retention_records_idx)
   where request_id                                 = @p_request_id

   select @w_row_number                             = row_number
   from retention_records WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = retention_records_idx1)
   where request_id                                 = @p_request_id
   and   contract_nbr                               = @p_contract_nbr
   and   account_id                                 = @p_account_id
   and   check_type                                 = @p_check_type
   and   check_request_id                           = @p_check_request_id

end

if  @w_row_number                                  <> 0
and @w_row_number_max                              <> 0                                  
begin

   if @p_action                                     = 'NEXT'
   begin
      select @w_row_number                          = @w_row_number + 1

      if @w_row_number                              = @w_row_number_max
      begin
         select @w_row_number                       = 1
      end
   end

   if @p_action                                     = 'PREVIOUS'
   begin

      select @w_row_number                          = @w_row_number - 1

      if @w_row_number                              = 0
      begin
         select @w_row_number                       = @w_row_number_max
      end

   end

   select @p_request_id                             = request_id,
          @p_contract_nbr                           = contract_nbr,
          @p_account_id                             = account_id,
          @p_check_type                             = check_type,
          @p_check_request_id                       = check_request_id
   from retention_records WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = retention_records_idx)
   where request_id                                 = @p_request_id
   and   row_number                                 = @w_row_number
end

declare @w_credit_ind                               int
select @w_credit_ind                                = 1

select top 1 
       contract_nbr,
       account_id,
       account_number                               = @w_account_number,
       check_type,
       check_request_id,
       approval_status,
       approval_status_date,
       approval_comments,
       approval_eff_date,
       origin,
       userfield_text_01,
       userfield_text_02,
       userfield_date_03,
       userfield_text_04,
       userfield_date_05,
       userfield_date_06,
       userfield_amt_07,
       username,
       date_created,
       credit_ind                                   = @w_credit_ind,
       chgstamp
from check_account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = check_account_idx) 
where contract_nbr                                  = @p_contract_nbr
and   account_id                                    = @p_account_id
and   check_type                                    = @p_check_type
and   check_request_id                              = @p_check_request_id
 -- Ticket 1-12504523
--and	  CONVERT(DATETIME, date_created, 120)			= ISNULL(CONVERT(DATETIME,@p_date_created,120), CONVERT(DATETIME,date_created,120)) NOTE: Converssion didin`t work when page sent the Date
and   DATEPART(YEAR, date_created)					= ISNULL(DATEPART(YEAR,@p_date_created), DATEPART(YEAR,date_created))
and   DATEPART(MONTH, date_created)					= ISNULL(DATEPART(MONTH,@p_date_created), DATEPART(MONTH,date_created))
and   DATEPART(DAY, date_created)					= ISNULL(DATEPART(DAY,@p_date_created), DATEPART(DAY,date_created))
and   DATEPART(HOUR, date_created)					= ISNULL(DATEPART(HOUR,@p_date_created), DATEPART(HOUR,date_created))
and   DATEPART(MINUTE, date_created)				= ISNULL(DATEPART(MINUTE,@p_date_created), DATEPART(MINUTE,date_created))
and   DATEPART(SECOND, date_created)				= ISNULL(DATEPART(SECOND,@p_date_created), DATEPART(SECOND,date_created))
 -- End Ticket 1-12504523