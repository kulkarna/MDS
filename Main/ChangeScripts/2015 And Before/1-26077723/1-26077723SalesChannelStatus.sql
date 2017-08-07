USE [Lp_common]
GO

/****** Object:  StoredProcedure [dbo].[usp_views_sel]    Script Date: 08/30/2013 09:44:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------------
/*
Modified ON: August 30 2013
Modified by: Sara Lakshmanan
Ticket:1-26077723: Sales Channel Selection during Contract Entry
Reason: Prospect sales channels were shown on the deal capture.
So,modified the filter to show only the channels with Sales Status of 2(Active)
(Root cause there were records with status of 0)
//Added With (NOLock) to all the select statements
*/
------------------------------------------------------------------------------------------------------
  
ALTER PROCEDURE [dbo].[usp_views_sel]  
(@p_username                nchar(100),  
 @p_process_id              VARCHAR(30),
 @p_retail_mkt_id			char(2) = null,
 @p_code_plus_desc			bit = NULL,  -- ADICIONADO -JAG SIRVE PARA  MOSTRA CODIGO Y DESC JUNTAS DEFAUL NULL COMO ANTES  
 @p_show_inactive			bit = NULL  -- Added to be able to include inactive channels
 )
as
SET NOCOUNT ON

IF @p_process_id                                    = 'SYSTEM CODE'  
BEGIN  
 
   SELECT option_id                                 = upper(system_name),  
          RETURN_value                              = system_code                                
   FROM lp_doc.dbo.doc_systems with (NOLOCK)-- INDEX = PK_doc_systems)   
   RETURN  
END  

IF @p_process_id                                    = 'ACCOUNT TYPE ALL'  
BEGIN  
   SELECT option_id                                 = 'All',  
          RETURN_value                              = 'ALL'  
   UNION  
   SELECT option_id                                 = option_id,  
          RETURN_value                              = upper(option_id)                                
   FROM common_views WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_views_idx)  
   WHERE process_id                                 = 'ACCOUNT TYPE'  
   RETURN  
END  
  
IF @p_process_id                                    = 'MONTHS DAYS'  
BEGIN  
   SELECT option_id                                 = a.option_id,  
          RETURN_value                              = a.RETURN_value  
   FROM (SELECT seq                                 = 0,  
                option_id                           = 'None',  
                RETURN_value                        = 'NONE'  
         UNION  
         SELECT a.seq,  
                option_id                           = case when a.option_id   = '01'  
                                                           then 'Jan/'  
                                                           when a.option_id   = '02'  
                                                           then 'Feb/'  
                                                           when a.option_id   = '03'  
                                                           then 'Mar/'  
                                                           when a.option_id   = '04'  
                                                            then 'Apr/'  
                                                           when a.option_id   = '05'  
                                                           then 'May/'  
                                                           when a.option_id   = '06'  
                                                           then 'Jun/'  
                                                           when a.option_id   = '07'  
                                                           then 'Jul/'  
                                                           when a.option_id   = '08'  
                                                           then 'Aug/'  
                                                           when a.option_id   = '09'  
                                                           then 'Sep/'  
                                                           when a.option_id   = '10'  
                                                           then 'Oct/'  
                                                           when a.option_id   = '11'  
                                                           then 'Nov/'  
                                                           when a.option_id   = '12'  
                                                           then 'Dec/'  
                                                      END  
                                                    + b.option_id,  
                RETURN_value                        = ltrim(rtrim(a.option_id))   
                                                    + '/'  
                                                    + ltrim(rtrim(b.option_id))   
         FROM lp_common..common_views a WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_views_idx),  
              ,lp_common..common_views b WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_views_idx)  
         WHERE a.process_id                         = 'MONTH'  
         AND   b.process_id                         = 'DAY') a  
   WHERE a.RETURN_value                            <> '02/30'  
   AND   a.RETURN_value                            <> '02/31'  
   AND   a.RETURN_value                            <> '04/31'  
   AND   a.RETURN_value                            <> '06/31'  
   AND   a.RETURN_value                            <> '07/31'  
   AND   a.RETURN_value                            <> '09/31'  
   AND   a.RETURN_value                            <> '11/31'  
   ORDER BY a.seq        
END  
  
IF @p_process_id = 'SALES CHANNEL'  
BEGIN  
	DECLARE @w_sales_channel_prefix VARCHAR(100)  

	SELECT @w_sales_channel_prefix = sales_channel_prefix  
	FROM lp_common..common_config with (NOLOCK)  

	DECLARE @w_user_id INT  
	
	SELECT @w_user_id = UserID  
	FROM libertypower.dbo.[user] with (NOLOCK)  
	WHERE Username = @p_username
 

	SELECT CONVERT(VARCHAR(100),'None') AS option_id, CONVERT(VARCHAR(100),'NONE') AS RETURN_value
	INTO #List_of_sales_channels

	-- This allows all liberty employees to have access to all sales channels.  ticket # 2099
	-- 4/30/2010 - George Worthington - modified "Sales Channel" queries to use the LibertyPower database
	IF lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
		INSERT INTO #List_of_sales_channels
		SELECT option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/','')
		, RETURN_value = REPLACE(b.RoleName,'Sales Channel/','Sales Channel/')
		FROM libertypower..[Role] b WITH (NOLOCK)
		WHERE b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  
	ELSE
		INSERT INTO #List_of_sales_channels
			SELECT 
				option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/','')
				, RETURN_value = REPLACE(b.RoleName,'Sales Channel/','Sales Channel/')
			FROM 
				libertypower..UserRole a with (NOLOCK)
				JOIN libertypower..[Role] b with (NOLOCK) ON a.RoleID = b.RoleID  
			WHERE 
				a.UserID = @w_user_id  
				AND b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  
				-- Following comment by Hector Gomez 4/8/2010
				-- Added the following line due to the fact that a sales channel was able to
				-- select a different sales channel from the drop down, and with this it will
				-- be limited to only the user sales channel.
				AND REPLACE(@p_username,'libertypower\','Sales Channel/') = b.RoleName

	SELECT * FROM #List_of_sales_channels 
	WHERE return_value in ( SELECT 'SALES CHANNEL/'+ ChannelName FROM libertyPower..saleschannel with (NOLOCK) WHERE inactive = 0 
	   --modified Aug 30 2013 Ticket: 1-26077723  Changed the sales status to 2
	--AND SalesStatus <> 1)
		   AND SalesStatus=2)
	OR @p_show_inactive = 1
	--WHERE return_value in (SELECT vendor_system_name FROM lp_commissions..vendor WHERE inactive_ind = 0)
	
	ORDER BY RETURN_Value
	RETURN  
	
	
----DECLARE @p_username varchar(100)

----SET @p_username = 'libertypower\hgomez'
----drop table #List_of_sales_channels


----IF @p_process_id = 'SALES CHANNEL'  
----BEGIN  
--	DECLARE @w_sales_channel_prefix VARCHAR(100)  

--	SELECT @w_sales_channel_prefix = sales_channel_prefix  
--	FROM lp_common..common_config with (NOLOCK)  

--	DECLARE @w_user_id INT  

--	SELECT @w_user_id = UserID  
--	FROM lp_portal..Users with (NOLOCK INDEX = IX_Users)  
--	WHERE Username = @p_username  

--	SELECT CONVERT(VARCHAR(100),'None') AS option_id, CONVERT(VARCHAR(100),'NONE') AS RETURN_value
--	INTO #List_of_sales_channels
	
-----------------------------------------------
---- THE FOLLOWING HAS BEEN COMMENTED DUE TO A NEW CHANGE IN CHANNEL SECURITY (ABC/TELESALES)	
------ This allows all liberty employees to have access to all sales channels.  ticket # 2099
----IF lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1
----	INSERT INTO #List_of_sales_channels
----	SELECT option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/',''), RETURN_value = b.RoleName  
----	FROM lp_portal..Roles b 
----	WHERE b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  
----ELSE
----	INSERT INTO #List_of_sales_channels
----	SELECT option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/',''), RETURN_value = b.RoleName  
----	FROM lp_portal..UserRoles a
----	JOIN lp_portal..Roles b ON a.RoleID = b.RoleID  
----	WHERE a.UserID = @w_user_id  
----	AND b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  
-----------------------------------------------

--	-------------------------------------------------------
--	-- NEW ENHANCEMENT FOR THE SALES CHANNEL DROP DOWN 
--	-- Author: Hector Gomez (06/01/2009)

--	 --This allows all Liberty Power ADMINS to have access to all sales channels.  
--	IF (
--			SELECT COUNT(*) 
--			FROM 
--				lp_portal..UserRoles 
--				JOIN lp_portal..Roles ON UserRoles.RoleID =  Roles.RoleID 
--			WHERE 
--				UserID = @w_user_id 
--				AND Roles.RoleName = 'LibertyPo werAdmin'
--		) = 1 	
--		INSERT INTO #List_of_sales_channels
--			SELECT 
--				option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/','')
--				, RETURN_value = UPPER(b.RoleName)
--			FROM 
--				lp_portal..Roles b 
--			WHERE 
--				b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  
--				AND 0 < (				
--							SELECT 
--								COUNT(*)
--							FROM
--								lp_commissions..vendor v 
--								JOIN lp_commissions..vendor_category vc ON v.vendor_category_id = vc.vendor_category_id
--							WHERE
--								Replace(Replace(Vendor_System_Name,'Sales Channel/',''),' ','') = Replace(b.RoleName,'Sales Channel/','')
--								AND inactive_ind = 0
--						)		
--	ELSE
--		IF (
--			SELECT COUNT(*) 
--			FROM 
--				lp_portal..UserRoles 
--				JOIN lp_portal..Roles ON UserRoles.RoleID =  Roles.RoleID 
--			WHERE 
--				UserID = @w_user_id 
--				AND Roles.RoleName = 'LibertyPowerEmployes'
--		) = 1 		

--BEGIN
--print 'employee'
--			-- EMPLOYEES of LPC
--			INSERT INTO #List_of_sales_channels
--				SELECT 
--					option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/','')
--					, RETURN_value = UPPER(b.RoleName)
--				FROM 
--					lp_portal..UserRoles a
--					JOIN lp_portal..Roles b ON a.RoleID = b.RoleID  
--				WHERE 
--					a.UserID = @w_user_id  
--					AND b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  

--				UNION 	
--				-------------------------------------------
--				-- To Retrieve only the ABC Channel Role.
--				-------------------------------------------
--				SELECT 
--					option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/','')
--					, RETURN_value = UPPER(b.RoleName)
--				FROM 
--					lp_portal..Roles b
--				WHERE
--					b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  
--					AND 0< (
--							SELECT 
--								COUNT(*)
--							FROM
--								lp_commissions..vendor v 
--								JOIN lp_commissions..vendor_category vc ON v.vendor_category_id = vc.vendor_category_id
--							WHERE
--								Replace(Replace(Vendor_System_Name,'Sales Channel/',''),' ','') = Replace(b.RoleName,'Sales Channel/','')
--								AND inactive_ind = 0
--								AND Vendor_Category_Code = 'ABC'

--						)
--					------ Only show Sales Channel that actually 
--					AND 0 < (
--								SELECT  
--									COUNT(*)	
--								FROM 
--									lp_portal..UserRoles aa
--									JOIN 
--									lp_portal..Roles bb ON aa.RoleID = bb.RoleID  
--								WHERE 
--									aa.UserID = @w_user_id 					
--									AND bb.RoleName = 'ABC Channels' -- HARDCODED, only way to get this type of channel role
--									)

					
--				UNION 	
--				-------------------------------------------
--				-- To Retrieve only the TELESALES Channel Role.
--				-------------------------------------------
--				SELECT 
--					option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/','')
--					, RETURN_value = UPPER(b.RoleName)
--				FROM 
--					lp_portal..Roles b
--				WHERE
--					b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  
--					AND 0< (
--							SELECT 
--								COUNT(*)
--							FROM
--								lp_commissions..vendor v 
--								JOIN lp_commissions..vendor_category vc ON v.vendor_category_id = vc.vendor_category_id
--							WHERE
--								Replace(Replace(Vendor_System_Name,'Sales Channel/',''),' ','') = Replace(b.RoleName,'Sales Channel/','')
--								AND inactive_ind = 0
--								AND Vendor_Category_Code = 'Telesales'

--						)
--					------ Only show Sales Channel that actually 
--					AND 0 < (
--								SELECT  
--									COUNT(*)	
--								FROM 
--									lp_portal..UserRoles aa
--									JOIN 
--									lp_portal..Roles bb ON aa.RoleID = bb.RoleID  
--								WHERE 
--									aa.UserID = @w_user_id 					
--									AND bb.RoleName = 'Telesales Channels' -- HARDCODED, only way to get this type of channel role
--									)
--			END				
--		ELSE
--			---------------------------
--			-- NOT EMPLOYEES of LPC
--			---------------------------
--			INSERT INTO #List_of_sales_channels
--				SELECT 
--					option_id = REPLACE(UPPER(b.RoleName),'SALES CHANNEL/','')
--					, RETURN_value = UPPER(b.RoleName)
--				FROM 
--					lp_portal..UserRoles a
--					JOIN lp_portal..Roles b ON a.RoleID = b.RoleID  
--				WHERE 
--					a.UserID = @w_user_id  
--					AND b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%'  
--					AND 0 < (				
--								SELECT 
--									COUNT(*)
--								FROM
--									lp_commissions..vendor v 
--									JOIN lp_commissions..vendor_category vc ON v.vendor_category_id = vc.vendor_category_id
--								WHERE
--									Replace(Replace(Vendor_System_Name,'Sales Channel/',''),' ','') = Replace(b.RoleName,'Sales Channel/','')
--									AND inactive_ind = 0
--							)		

	
--	-- END OF NEW ENHANCEMENT
--	-------------------------------------------------------


--	SELECT * FROM #List_of_sales_channels ORDER BY RETURN_Value
--	RETURN  
----END  
  	
	
END  
  
IF @p_process_id                                    = 'SALES CHANNEL ALL'  
BEGIN  
  
   DECLARE @w_sales_channel_prefix_all              VARCHAR(100)  
  
   SELECT @w_sales_channel_prefix_all               = sales_channel_prefix  
   FROM lp_common..common_config with (NOLOCK)  
  
   SELECT option_id                                 = 'All',  
          RETURN_value                              = 'ALL'  
   UNION  
   SELECT option_id                                 = RoleName,  
          RETURN_value                              = RoleName  
   FROM libertypower..[Role] with (NOLOCK)  
   WHERE RoleName                                LIKE ltrim(rtrim(@w_sales_channel_prefix_all)) + '%'  
  
   RETURN  
END  
  
IF @p_process_id                                    = 'YEAR'  
BEGIN  
   SELECT option_id                                 = datepart(yy, dateadd(yy, - 2, getdate())),  
          RETURN_value                              = datepart(yy, dateadd(yy, - 2, getdate()))  
   UNION  
   SELECT option_id                                 = datepart(yy, dateadd(yy, - 1, getdate())),  
          RETURN_value                              = datepart(yy, dateadd(yy, - 1, getdate()))  
   UNION  
   SELECT option_id                                 = datepart(yy, getdate()),  
          RETURN_value                              = datepart(yy, getdate())  
   RETURN  
END  
  
IF @p_process_id                                    = 'RETAIL MARKET'  
BEGIN  
   SELECT option_id                                 = retail_mkt_descp,  
          RETURN_value                              = rtrim(retail_mkt_id),
          ID			                            = ID
   FROM common_retail_market WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_retail_market_idx)  
   WHERE inactive_ind                               = '0'  
   ORDER BY option_id
   RETURN  
END  
  
IF @p_process_id                                    = 'RETAIL MARKET ALL'  
BEGIN  
   SELECT option_id                                 = 'All',  
          RETURN_value                              = 'ALL'  
   UNION  
   SELECT option_id                                 = retail_mkt_descp,  
          RETURN_value                              = rtrim(retail_mkt_id)
   FROM common_retail_market WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_retail_market_idx)  
   WHERE inactive_ind                               = '0'  
   RETURN  
END  
  
IF @p_process_id                                    = 'WHOLESALE MARKET'  
BEGIN  
   SELECT option_id                         = wholesale_mkt_descp,  
          RETURN_value                              = wholesale_mkt_id                          
   FROM common_wholesale_market WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_wholesale_market_idx)  
   WHERE inactive_ind                               = '0'  
   RETURN  
END  
  
IF @p_process_id                                    = 'ENTITY ID'  
BEGIN  
   SELECT option_id                                 = entity_descp,  
          RETURN_value                              = rtrim(entity_id)
   FROM common_entity WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_entity_idx)  
   WHERE inactive_ind                               = '0' 
   ORDER BY option_id
   RETURN  
END  
  
IF @p_process_id                                    = 'UTILITY ID'  
BEGIN  
   SELECT option_id                                 = utility_descp,  
          RETURN_value                              = rtrim(utility_id)                          
   FROM common_utility WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_utility_idx)  
   WHERE inactive_ind                               = '0'  
   RETURN  
END  
  
IF @p_process_id                                    = 'UTILITY ID ALL'  
BEGIN  
   SELECT option_id                                 = 'All',  
          RETURN_value                              = 'ALL'  
   UNION  
   SELECT option_id                                 = utility_descp,  
          RETURN_value                              = rtrim(utility_id)                          
   FROM common_utility WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_utility_idx)  
   WHERE inactive_ind                               = '0'  
   ORDER BY option_id  
   RETURN  
END  
  
IF @p_process_id                                    = 'PRODUCT ID'  
BEGIN  
   SELECT option_id                                 = product_descp,  
          RETURN_value                              = rtrim(product_id)                          
   FROM common_product WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_idx)  
   WHERE inactive_ind                               = '0'  
   RETURN  
END  

IF @p_process_id                                    = 'SERVICE CLASS'  
BEGIN  
   SELECT option_id                                 = null,  
          RETURN_value                              = 'ALL'  
   UNION  
   SELECT option_id                                 = service_rate_class_id,  
          RETURN_value                              = isnull(retail_mkt_id, 'All Markets') + ' : ' + isnull(utility_id,'All Utilities') + ' : ' + service_rate_class                          
   FROM service_rate_class  with (NOLOCK)
   RETURN  
END  
  
IF @p_process_id                                    = 'ZONE'  
BEGIN  
   SELECT option_id                                 = null,  
          RETURN_value                              = 'ALL'  
   UNION  
   SELECT option_id                                 = zone_id,  
          RETURN_value                              = isnull(retail_mkt_id, 'All Markets') + ' : ' + isnull(utility_id,'All Utilities') + ' : ' + zone
   FROM zone with (NOLOCK)
   RETURN  
END  
  
IF @p_process_id                                    = 'ACTIVITY ID'  
BEGIN  
   SELECT option_id                                 = activity_descp,  
          RETURN_value = activity_id                                
   FROM lp_security..security_activity WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = security_activity_idx1)  
   RETURN  
END  
  
IF @p_process_id                                    = 'ROLE ID'  
BEGIN  
   SELECT option_id                                 = RoleName,  
          RETURN_value                              = RoleID  
   FROM lp_portal..Roles WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = IX_RoleName)  
   RETURN  
END    
  
IF @p_process_id                                    = 'UTILITY VALUE TYPE'  
BEGIN  
   SELECT option_id                                 = 'None',  
          RETURN_value                              = 'NONE'  
   UNION  
   SELECT option_id                                 = 'Value',  
          RETURN_value                              = 'VALUE'  
   UNION  
   SELECT distinct               
          process_id,  
          RETURN_value                              = process_id  
   FROM lp_common..common_views WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_views_idx)  
   WHERE process_id                                 = 'ZONE ID'  
   or    process_id                                 = 'TRIP'  
   
END  



-- ***********************************************************************************************************
-- START CHANGING SP TO REFLECT NEW TABLE
-- ***********************************************************************************************************


IF @p_process_id                                    = 'BUSINESS TYPE DEAL'  
or @p_process_id                                    = 'BUSINESS ACTIVITY DEAL'  
BEGIN  
	-- REPLACED WITH THIS:
	IF @p_process_id = 'BUSINESS TYPE DEAL' 
	BEGIN
		-- FOR BUSINESS TYPE
		SELECT option_id, RETURN_value FROM (
		SELECT		[Type] as option_id ,  RETURN_value = substring(upper(BT.[Type]), 1, 35) , CASE WHEN BT.BusinessTypeID = 1 THEN 1 ELSE 2 END SEQ
		FROM		LibertyPower..BusinessType BT  with (NOLOCK)
		WHERE		BT.Sequence < 20000  
		) A
		ORDER BY	SEQ, option_id
		;
	END
	ELSE
	BEGIN
		-- FOR BUSINESS ACTIVITY
		SELECT A.Activity option_id, A.Activity RETURN_value
		FROM
			(	
			SELECT	Activity = substring(upper(BA.Activity), 1, 40) ,
					CASE WHEN BA.BusinessActivityID = 1 THEN 1 ELSE 2 END seq
			FROM	LibertyPower.dbo.BusinessActivity BA with (NOLOCK)
			WHERE 	BA.Sequence < 20000
			) A
		ORDER BY A.seq, A.Activity
	END
   --SELECT a.option_id,  
   --       RETURN_value                              = substring(a.RETURN_value, 1, 35)               
   --FROM (SELECT seq                                 = 1,  
   --             option_id                           = 'None',  
   --             RETURN_value                        = 'NONE'  
   --      UNION  
   --      SELECT seq                                 = 2,  
   --             option_id,  
   --             RETURN_value                        = case when RETURN_value = ' '  
   --                                                        then upper(option_id)  
   --                                                        else RETURN_value  
   --                                                   END  
   --      FROM lp_common..common_views WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_views_idx)  
   --      WHERE process_id                           = case when @p_process_id = 'BUSINESS TYPE DEAL'  
   --                                                        then 'BUSINESS TYPE'  
   --                                                        else 'BUSINESS ACTIVITY'  
   --                                                   END  
   --      AND   seq                                  < 20000  
   --      AND   option_id                           <> 'NONE') a  
   --ORDER BY a.seq, a.option_id  
      
END  


IF @p_process_id                                    = 'BUSINESS TYPE'  
or @p_process_id                                    = 'BUSINESS ACTIVITY'  
BEGIN  
	IF @p_process_id = 'BUSINESS TYPE' 
	BEGIN
		-- FOR BUSINESS TYPE
		SELECT option_id, RETURN_value FROM (
		select		[Type] as option_id ,  RETURN_value = substring(upper(BT.[Type]), 1, 40) , CASE WHEN BT.BusinessTypeID = 1 THEN 1 ELSE 2 END SEQ
		FROM		LibertyPower..BusinessType BT with (NOLOCK)
		) A
		ORDER BY	SEQ, option_id
	END
	ELSE
	BEGIN
		-- FOR BUSINESS ACTIVITY
		SELECT A.Activity option_id, A.Activity RETURN_value
		FROM
			(	
			SELECT	Activity = substring(upper(BA.Activity), 1, 40) ,
					CASE WHEN BA.BusinessActivityID = 1 THEN 1 ELSE 2 END seq
			FROM	LibertyPower.dbo.BusinessActivity BA with (NOLOCK)
			--WHERE 	BA.Sequence < 20000
			) A
		ORDER BY A.seq, A.Activity
	END
END  


-- ***********************************************************************************************************
-- END CHANGING SP TO REFLECT NEW TABLE
-- ***********************************************************************************************************


IF @p_process_id                                    = 'ENROLLMENT TYPE'  
BEGIN
   -- A market needs to has to be given access to the various enrollment types.
   -- Every market has access to at least the the stANDard enrollment type, seq=1.
   SELECT option_id, RETURN_value
   FROM lp_common.dbo.common_views  with (NOLOCK)
   WHERE process_id = @p_process_id AND
	(seq=1 OR seq IN (SELECT enrollment_type_id FROM lp_common.dbo.market_enrollment_type with (NOLOCK) WHERE retail_mkt_id = isnull(@p_retail_mkt_id,retail_mkt_id)))
   AND active = 1
   ORDER BY seq
END

IF @p_process_id                                    = 'STATUS CALL'  
BEGIN  
   SELECT option_id                                 = call_status_descp,   
          RETURN_value                              = call_status  
   FROM lp_enrollment..call_status with (NOLOCK)  
   WHERE reason_code                                = call_status  
   RETURN  
END  
  
  
IF @p_process_id                                    = 'CALL STATUS'  
BEGIN  
   SELECT option_id                                 = call_status_descp,   
          RETURN_value                              = call_status  
   FROM lp_enrollment..call_status with (NOLOCK)  
   WHERE reason_code                                = call_status  
   RETURN  
/*  
   SELECT a.option_id,   
          a.RETURN_value  
   FROM common_views a with (NOLOCK INDEX = common_views_idx),  
        lp_enrollment..call_status b with (NOLOCK INDEX = call_status_idx)  
   WHERE a.process_id                               = 'REASON CODE'  
   AND   a.RETURN_value                             = b.reason_code  
   RETURN  
*/  
END  
  
IF @p_process_id                                    = 'CALL STATUS ALL'  
BEGIN  
   SELECT a.option_id,  
          a.RETURN_value  
   FROM (SELECT seq                                 = 1,  
                option_id                           = 'ALL',   
                RETURN_value                        = 'All'  
         UNION     
         SELECT seq                                 = 2,  
                option_id                           = call_status_descp,   
                RETURN_value                        = call_status  
         FROM lp_enrollment..call_status with (NOLOCK)  
         WHERE reason_code                          = call_status) a  
   ORDER BY a.seq  
   RETURN  
/*  
   SELECT a.option_id,   
          a.RETURN_value  
   FROM common_views a with (NOLOCK INDEX = common_views_idx),  
        lp_enrollment..call_status b with (NOLOCK INDEX = call_status_idx)  
   WHERE a.process_id                               = 'REASON CODE'  
   AND   a.RETURN_value                             = b.reason_code  
   RETURN  
*/  
END  

IF @p_process_id                                    = 'CALL STATUS WELCOME ALL'  
BEGIN  
   SELECT a.option_id,  
          a.RETURN_value  
   FROM (SELECT seq                                 = 1,  
                option_id                           = 'ALL',   
                RETURN_value                        = 'All'  
         UNION     
         SELECT seq                                 = 2,  
                option_id                           = call_status_descp,   
                RETURN_value                        = call_status  
         FROM lp_enrollment..call_status with (NOLOCK)  
         WHERE reason_code                          = call_status
		  or call_status = 'C') a  
   ORDER BY a.seq  
   RETURN 
END

IF @p_process_id                                    = 'LOST REASON CODE'  
BEGIN  
   SELECT a.option_id,  
          a.RETURN_value  
   FROM (SELECT seq                                 = 1,  
                option_id                           = 'None',   
                RETURN_value                        = 'NON'  
         UNION  
         SELECT distinct
                seq                                 = 2,
                option_id                           = a.option_id,
                RETURN_value                        = a.RETURN_value
         FROM lp_common..common_views a with (NOLOCK),
              lp_enrollment..call_status b with (NOLOCK)
         WHERE a.process_id                         = 'REASON CODE'
         AND   b.reason_code                        = a.RETURN_value
		 AND b.reason_code not in ('A','L','S','O')
		 AND reason_code_parent = 0
		 AND a.active = 1
         AND   b.call_status                        = 'L' 
         AND   a.RETURN_value                      <> 'NON') a
   ORDER BY seq, a.option_id 
END  

/*  ----------  original  ---------------------------------------------
IF @p_process_id                                    = 'LOST REASON CODE'  
BEGIN  
   SELECT a.option_id,  
          a.RETURN_value  
   FROM (SELECT seq                                 = 1,  
                option_id                           = 'None',   
                RETURN_value                        = 'NON'  
         UNION  
         SELECT seq = 2,  
                a.option_id,   
                a.RETURN_value  
         FROM common_views a with (NOLOCK INDEX = common_views_idx),  
              lp_enrollment..call_status b with (NOLOCK INDEX = call_status_idx)  
         WHERE a.process_id                         = 'REASON CODE'  
         AND   a.RETURN_value                       = b.reason_code  
         AND   b.call_status                        = 'L'  
         AND   a.RETURN_value                      <> 'NON') a  
   ORDER BY a.seq, a.option_id  
END  
*/
  
IF @p_process_id                                    = 'CAMPAIGN'  
BEGIN  
   SELECT option_id                                 = 'All Dates',  
          RETURN_value                              = 'ALL'  
   UNION  
   SELECT option_id,  
          RETURN_value                               
   FROM common_views with (NOLOCK)  
   WHERE process_id									= @p_process_id 
   RETURN  
END  

IF (@p_code_plus_desc is null OR @p_code_plus_desc = 0)
BEGIN  
   SELECT option_id,  
		  RETURN_value                                 = case when RETURN_value = ' '  
															  then upper(option_id)  
															  else RETURN_value  
														 END  
   FROM lp_common..common_views WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_views_idx)  
   WHERE process_id = @p_process_id
   AND (active = 1 OR @p_process_id <> 'ENROLLMENT TYPE') -- hotfix to prevent double datasets from returning when requesting enrollment type.
   --ORDER BY option_id
END  
ELSE
BEGIN  
   SELECT option_id= case when RETURN_value = 'NONE'  
        then option_id  
        else RTRIM(LTRIM(RETURN_value))+' '+option_id  
                     END,  
          RETURN_value                                 = case when RETURN_value = ' '  
                                                              then upper(option_id)  
                                                              else RETURN_value  
                                                         END  
   FROM lp_common..common_views WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_views_idx)  
   WHERE process_id                                    = @p_process_id  
END

SET NOCOUNT OFF

GO


