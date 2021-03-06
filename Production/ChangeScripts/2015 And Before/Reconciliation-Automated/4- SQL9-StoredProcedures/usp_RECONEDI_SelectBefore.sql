/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_SelectBefore]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_SelectBefore
 * Collect data for running the Enrollment process and EDI Process.
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
 --exec usp_RECONEDI_SelectBefore 1, 'CAISO', '*', '20140409', '20140409'
CREATE procedure [dbo].[usp_RECONEDI_SelectBefore]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime,
 @p_Process                                        char(01) = 'T')
as

set nocount on

select ISO,
       [814_Key],
       LastEDI,
       LastAccountChanges
from dbo.RECONEDI_ISOControl (nolock)
where (ISO                                         = @p_ISO
or     len(ltrim(rtrim(ISO)))                      = 0)

select *
from dbo.RECONEDI_Filter (nolock)
where ISO                                          = @p_ISO
and  (Utility                                      = @p_Utility
or    @p_Utility                                   = '*')

select * 
from dbo.RECONEDI_AccountChangePending (nolock)
where ISO                                          = @p_ISO
and  (UtilityCode                                  = @p_Utility
or    @p_Utility                                   = '*')

select top 1 * 
from dbo.RECONEDI_Header (nolock)
where ReconID                                      < @p_ReconID
and   AsOfDate                                    >= @p_AsOfDate
and   ((ISO                                        = @p_ISO)
or     (ISO                                        = '*'))
and   StatusID                                     = 5              
and   SubStatusID                                  = 0
set nocount off

GO
