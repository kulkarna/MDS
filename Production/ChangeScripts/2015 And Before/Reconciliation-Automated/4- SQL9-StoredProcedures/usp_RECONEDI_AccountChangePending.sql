/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_AccountChangePending]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_AccountChangePending
 * Collect Accounts Changes Information.
 * 
 * History
 *******************************************************************************
 * 2014/04/01 - William Vilchez
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
 CREATE procedure [dbo].[usp_RECONEDI_AccountChangePending]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime,
 @p_LastAccountChanges                             date)
as
set nocount on

insert into dbo.RECONEDI_AccountChangePending
select distinct
       b.WholeSaleMktID,
       b.UtilityCode,
       c.new_Account_Number,
       '',
	   @p_ReconID
from Libertypower.dbo.Account a (nolock)
inner join libertypower.dbo.Utility b (nolock)
on  a.UtilityID                                    = b.ID
inner join lp_account.dbo.account_number_history c (nolock)
on  a.AccountIDLegacy                              = c.Account_ID
where b.WholeSaleMktID                             = @p_ISO
and   c.date_created                               > @p_LastAccountChanges
and   c.date_created                               <= convert(char(08), @p_ProcessDate, 112)
and not exists(select null
               from dbo.RECONEDI_AccountChangePending d with (nolock)
               where d.ISO                          = b.WholeSaleMktID
               and   d.UtilityCode                  = b.UtilityCode
               and   d.Esiid                        = c.new_Account_Number
               and   d.EsiidOld                     = '')

insert into dbo.RECONEDI_AccountChangePending
select distinct
       c.WholeSaleMktID,
       c.UtilityCode,
       d.new_Account_Number,
       d.old_Account_Number,
	   @p_ReconID
from dbo.RECONEDI_AccountChangePending a with (nolock)
inner join Libertypower.dbo.Account b (nolock)
on  a.Esiid                                        = b.AccountNumber                                
inner join Libertypower.dbo.Utility c (nolock)
on  b.UtilityID                                    = c.ID
and a.UtilityCode                                  = c.UtilityCode
inner join lp_account..account_number_history d (nolock)
on  b.AccountIDLegacy                              = d.Account_ID
where c.WholeSaleMktID                             = @p_ISO
and   a.EsiidOld                                   = ''
and   d.date_created                               > @p_LastAccountChanges
and   d.date_created                              <= convert(char(08), @p_ProcessDate, 112)
and not exists(select null
               from dbo.RECONEDI_AccountChangePending b with (nolock)
               where b.ISO                         = c.WholeSaleMktID
               and   b.UtilityCode                 = c.UtilityCode
               and   b.Esiid                       = d.new_Account_Number
               and   b.EsiidOld                    = d.old_Account_Number)

update a set LastAccountChanges = convert(char(08), @p_ProcessDate, 112)
from dbo.RECONEDI_ISOControl a (nolock)
where a.ISO                                        = @p_ISO

set nocount off

GO
