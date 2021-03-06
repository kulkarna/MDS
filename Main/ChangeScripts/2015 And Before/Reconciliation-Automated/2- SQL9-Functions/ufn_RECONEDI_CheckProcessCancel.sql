/****** Object:  UserDefinedFunction [dbo].[ufn_RECONEDI_CheckProcessCancel]    Script Date: 7/2/2014 10:10:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*******************************************************************************  
 * ufn_RECONEDI_CheckProcessCancel 
 * Verify is a Process was canceled by user.   
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
CREATE function [dbo].[ufn_RECONEDI_CheckProcessCancel]
(@p_ReconID                                        bigint)  
returns int
as
begin

   declare @w_Return                               int

   select @w_Return                                = 0
   if exists(select null
             from dbo.RECONEDI_Header (nolock)
		     where ReconID                         = @p_ReconID
		     and  (StatusID                        = 4
			 or    StatusID                        = 6))
   begin
      select @w_Return                             = 1
   end

   return @w_Return

end
GO
