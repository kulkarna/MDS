-- =============================================
-- Author:		Rick Deigsler
-- Create date: 3/27/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_error_ins] 

@p_price_request_id			varchar(50),
@p_offer_id					varchar(50),
@p_utility_id				varchar(50),
@p_account_number			varchar(50),
@p_error_msg				varchar(4000),
@p_username					varchar(100),
@p_filename					varchar(100)

AS

INSERT INTO zErrors 
			(RequestID, OfferID, AccountNumber, Utility, ErrorMessage, Username, [Filename], DateInsert)
VALUES		(@p_price_request_id, @p_offer_id, @p_account_number, @p_utility_id, @p_error_msg, @p_username, @p_filename, GETDATE()) 




