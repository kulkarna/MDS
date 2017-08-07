/* * * * * * * * * * * * * * * * * * *
Goal: Update description from CheckList table.
--------------------------------------------------------------------
Creation time: 11/19/2011
Created by: Lucio Teles
* * * * * * * * * * * * * * * * * * */ 
CREATE procedure [dbo].[usp_CheckListUpdateDescription](@CheckListID int, @Description varchar(100), @Order int) as
begin
   update checklist set 
   description = @Description, [Order] = @Order
   where CheckListID = @CheckListID
end
