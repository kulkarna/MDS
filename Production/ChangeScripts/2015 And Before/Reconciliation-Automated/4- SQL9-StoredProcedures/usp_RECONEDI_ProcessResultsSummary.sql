/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ProcessResultsSummary]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*******************************************************************************  
 * usp_RECONEDI_ProcessResultsSummary 
 * Select reconciliation results (Summary)
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
CREATE procedure [dbo].[usp_RECONEDI_ProcessResultsSummary]
(@p_reconid                                        int)
as

set nocount on

declare @w_ID                                      int
declare @w_GroupID                                 int
declare @w_LineID                                  int
declare @w_ResultDescp                             varchar(100)
declare @w_ResultAddDescp                          varchar(100)
declare @w_ParentReconReasonID                     int
declare @w_ReconReasonID                           int
declare @w_SummaryScript                           varchar(max)

declare @w_SqlCommand                              nvarchar(max)
declare @w_ReconReasonIDIN                         varchar(100)
declare @t_ID                                      int

declare @w_SqlCmd                                  varchar(max)

create table #Report
(ID                                                int identity(1, 1) primary key clustered,
 GroupID                                           int,
 LineID                                            int,
 ResultDescp                                       varchar(100),
 ResultAddDescp                                    varchar(400),
 Book0_NoAccounts                                  int,
 Book0_VolumeMwh                                   int,
 Book1_NoAccounts                                  int,
 Book1_VolumeMwh                                   int,
 Total_NoAccounts                                  int,
 Total_VolumeMwh                                   int)

create table #Formula
(Book0_NoAccounts                                  int,
 Book0_VolumeMwh                                   int,
 Book1_NoAccounts                                  int,
 Book1_VolumeMwh                                   int,
 Total_NoAccounts                                  int,
 Total_VolumeMwh                                   int)


create table #Summary
(ID                                                int identity(1, 1) primary key clustered,
 GroupID                                           int,
 LineID                                            int,
 ResultDescp                                       varchar(100),
 ResultAddDescp                                    varchar(400),
 ParentReconReasonID                               int,
 ReconReasonID                                     int,
 SummaryScript                                     varchar(max))

insert into #Summary
select a.GroupID,
       a.LineID,
       c.ReconReason,
	   c.ReconReasonDescp,
       a.ParentReconReasonID,
       a.ReconReasonID,
       SummaryScript                               = b.Formula
from RECONEDI_ProcessResults a (nolock)
inner join RECONEDI_ProcessResultsFormula b (nolock)
on  a.SummaryQueryID                               = b.ID
inner join dbo.RECONEDI_ReconReason c (nolock)
on  a.ReconReasonID                                = c.ReconReasonID
where a.InactiveInd                                = 0
order by a.GroupID,
         a.LineID

select @t_ID                                       = 1

select @w_ID                                       = ID,
       @w_GroupID                                  = GroupID,
       @w_LineID                                   = LineID,
       @w_ResultDescp                              = ResultDescp,
       @w_ResultAddDescp                           = ResultAddDescp,
       @w_ParentReconReasonID                      = ParentReconReasonID,
       @w_ReconReasonID                            = ReconReasonID,
       @w_SummaryScript                            = SummaryScript
from #Summary                                      
where ID                                           = @t_ID

while @@ROWCOUNT                                  <> 0
begin

   select @w_SqlCommand                            = @w_SummaryScript

   select @w_SqlCommand                            = REPLACE(@w_SqlCommand, '@ReconID', ltrim(rtrim(convert(varchar(20), @p_ReconID))))

   select @w_ReconReasonIDIN                       = ''

   if  exists (select null
               from RECONEDI_ProcessResults (nolock)
			   where ParentReconReasonID           = @w_ReconReasonID
			   and   InactiveInd                   = 0)
   and @w_ReconReasonID                           <> 0
   begin
      select @w_ReconReasonIDIN                    = COALESCE(@w_ReconReasonIDIN  + ', ', '') 
	                                               + convert(varchar(10), ReconReasonID) 
	  from RECONEDI_ProcessResults (nolock)
	  where ParentReconReasonID                    = @w_ReconReasonID
	  and   ReconReasonID                         <> 0

      select @w_ReconReasonIDIN                    = '('
	                                               + ltrim(rtrim(convert(varchar(100), @w_ReconReasonID)))
	                                               + ltrim(rtrim(@w_ReconReasonIDIN)) 
												   + ')'
   end
   else
   begin
      select @w_ReconReasonIDIN                    = '('
	                                               + ltrim(rtrim(convert(varchar(100), @w_ReconReasonID)))
												   + ')'

      if  @w_ReconReasonID                         = 0
      begin
         select @w_ReconReasonIDIN                 = '('
	                                               + ltrim(rtrim(convert(varchar(100), @w_ParentReconReasonID)))
												   + ')'
      end
   end

   select @w_SqlCommand                            = REPLACE(@w_SqlCommand , '@ReconReasonID', ltrim(rtrim(convert(varchar(100), @w_ReconReasonIDIN))))

   truncate table #Formula

   insert into #Formula
   exec (@w_SqlCommand)

   insert into #Report
   select @w_GroupID,
          @w_LineID,
          @w_ResultDescp,
          @w_ResultAddDescp,
          Book0_NoAccounts,
          Book0_VolumeMwh,
          Book1_NoAccounts,
          Book1_VolumeMwh,
          Total_NoAccounts,
          Total_VolumeMwh
   from #Formula

   select @t_ID                                    = @t_ID
                                                   + 1

   select @w_ID                                    = ID,
          @w_GroupID                               = GroupID,
          @w_LineID                                = LineID,
          @w_ResultDescp                           = ResultDescp,
          @w_ResultAddDescp                        = ResultAddDescp,
          @w_ParentReconReasonID                   = ParentReconReasonID,
          @w_ReconReasonID                         = ReconReasonID,
          @w_SummaryScript                         = SummaryScript
   from #Summary                                      
   where ID                                        = @t_ID
end

select * 
from #Report

set nocount off
GO
