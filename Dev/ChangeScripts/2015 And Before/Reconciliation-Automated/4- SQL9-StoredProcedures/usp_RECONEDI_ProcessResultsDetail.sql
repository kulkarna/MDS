/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ProcessResultsDetail]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*******************************************************************************  
 * usp_RECONEDI_ProcessResultsDetail 
 * Select reconciliation results (Detail)
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
CREATE procedure [dbo].[usp_RECONEDI_ProcessResultsDetail]
(@p_reconid                                        int,
 @p_GroupID                                        int,
 @p_LineID                                         int)
as
set nocount on

declare @w_ResultDescp                             varchar(100)
declare @w_ResultAddDescp                          varchar(400)
declare @w_ParentReconReasonID                     int
declare @w_ReconReasonID                           int
declare @w_DetailScript                            varchar(max)

declare @w_SqlCommand                              varchar(max)
declare @w_ReconReasonIDIN                         varchar(100)

select @w_ResultDescp                              = c.ReconReason,
       @w_ResultAddDescp                           = c.ReconReasonDescp,
       @w_ParentReconReasonID                      = a.ParentReconReasonID,
       @w_ReconReasonID                            = a.ReconReasonID,
       @w_DetailScript                             = b.Formula
from RECONEDI_ProcessResults a (nolock)
inner join RECONEDI_ProcessResultsFormula b (nolock)
on  a.DetailQueryID                                = b.ID
inner join dbo.RECONEDI_ReconReason c (nolock)
on  a.ReconReasonID                                = c.ReconReasonID
where a.GroupID                                    = @p_GroupID
and   a.LineID                                     = @p_LineID
and   a.InactiveInd                                = 0

select @w_SqlCommand                               = @w_DetailScript

select @w_SqlCommand                               = REPLACE(@w_SqlCommand, '@ReconID', ltrim(rtrim(convert(varchar(20), @p_ReconID))))

select @w_ReconReasonIDIN                          = ''

if  exists (select null
            from RECONEDI_ProcessResults (nolock)
            where ParentReconReasonID              = @w_ReconReasonID
		    and   InactiveInd                      = 0)
and @w_ReconReasonID                              <> 0
begin
   select @w_ReconReasonIDIN                       = COALESCE(@w_ReconReasonIDIN  + ', ', '') 
	                                               + convert(varchar(10), ReconReasonID) 
   from RECONEDI_ProcessResults (nolock)
   where ParentReconReasonID                       = @w_ReconReasonID
   and   ReconReasonID                            <> 0

   select @w_ReconReasonIDIN                       = '('
	                                               + ltrim(rtrim(convert(varchar(100), @w_ReconReasonID)))
	                                               + ltrim(rtrim(@w_ReconReasonIDIN)) 
												   + ')'
end
else
begin
   select @w_ReconReasonIDIN                       = '('
	                                               + ltrim(rtrim(convert(varchar(100), @w_ReconReasonID)))
												   + ')'

   if  @w_ReconReasonID                            = 0
   begin
      select @w_ReconReasonIDIN                    = '('
	                                               + ltrim(rtrim(convert(varchar(100), @w_ParentReconReasonID)))
												   + ')'
   end
end

select @w_SqlCommand                               = REPLACE(@w_SqlCommand , '@ReconReasonID', ltrim(rtrim(convert(varchar(100), @w_ReconReasonIDIN))))

exec (@w_SqlCommand)
select @w_SqlCommand

set nocount off
GO
