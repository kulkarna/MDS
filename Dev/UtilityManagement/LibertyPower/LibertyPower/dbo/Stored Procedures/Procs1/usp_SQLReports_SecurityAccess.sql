





-- =============================================
-- Author:		Hector Gomez
-- Create date: June 19, 2009
-- Description:	Will grant Read/Write access to all
-- databases within SQL Server.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SQLReports_SecurityAccess]
AS
BEGIN
	--USE master
	--GO

	SET NOCOUNT ON

	DECLARE @database_name sysname

	CREATE TABLE #databases (DATABASE_NAME sysname, DATABASE_SIZE int, REMARKS varchar(254))

	INSERT #databases EXEC sp_databases

	-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME NOT IN ('master', 'model', 'tempdb', 'msdb', 'distribution', 'ASPState')


	OPEN db_cur

	WHILE 1 = 1
	BEGIN
		FETCH db_cur INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		------------------------------------------
		-- user: readonly_msoffice
		------------------------------------------

		-- add user to databases
		EXEC ('USE ' + @database_name +';
				IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''readonly_msoffice'' ) 
					BEGIN
						EXEC sp_revokedbaccess ''readonly_msoffice''
					END
				') 
					
		-- grant access to databases
		EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''readonly_msoffice''; ')
		-- add user to db_OWNER
--		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''readonly_msoffice''; ')
		-- add user to db_datareader
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''readonly_msoffice''; ')
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''readonly_msoffice''; ')
		

		------------------------------------------
		-- user: ReadOnly_Access_v2
		------------------------------------------

		-- add user to databases
		EXEC ('USE ' + @database_name +';
				IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''ReadOnly_Access_v2'' ) 
					BEGIN
						EXEC sp_revokedbaccess ''ReadOnly_Access_v2''
					END
				') 
					
		-- grant access to databases
		EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''ReadOnly_Access_v2''; ')
		-- add user to db_datareader
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''ReadOnly_Access_v2''; ')
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''ReadOnly_Access_v2''; ')


		
		------------------------------------------
		-- user: ReadOnly_Excel_v2
		------------------------------------------

		-- add user to databases
		EXEC ('USE ' + @database_name +';
				IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''ReadOnly_Excel_v2'' ) 
					BEGIN
						EXEC sp_revokedbaccess ''ReadOnly_Excel_v2''
					END
				') 
					
		-- grant access to databases
		EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''ReadOnly_Excel_v2''; ')
		-- add user to db_datareader
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''ReadOnly_Excel_v2''; ')
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''ReadOnly_Excel_v2''; ')
		
		if @database_name = 'LP_RptObjects'
			begin
				EXEC ('USE ' + @database_name +'; GRANT EXECUTE on CUBS_billing_macro   to ReadOnly_Excel_v2;')
				EXEC ('USE ' + @database_name +'; GRANT EXECUTE on UNBILLED_USAGE_macro to ReadOnly_Excel_v2;')
			end

		
		--------------------------------------------
		---- user: SQLReports_Read
		--------------------------------------------

		-- add user to databases
		EXEC ('USE ' + @database_name +';
				IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''SQLReports_Read'' ) 
					BEGIN
						EXEC sp_revokedbaccess ''SQLReports_Read''
					END
				') 
					
		-- grant access to databases
		EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''SQLReports_Read''; ')
		-- add user to db_OWNER
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''SQLReports_Read''; ')
		-- add user to db_datareader
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''SQLReports_Read''; ')
		


		--------------------------------------------
		---- user: SQLReports_RW
		--------------------------------------------	

		---- add user to databases
		EXEC ('USE ' + @database_name +';
				IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''SQLReports_RW'' ) 
					BEGIN
						EXEC sp_revokedbaccess ''SQLReports_RW''
					END
				') 
				
		-- grant access to databases
		EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''SQLReports_RW''; ')
		-- add user to db_OWNER
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''SQLReports_RW''; ')
		-- add user to db_datareader
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''SQLReports_RW''; ')
		-- add user to db_datawriter
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datawriter'', ''SQLReports_RW''; ')
		

		----------------------------------------------
		------ user: SQL_Comm_Rep_svc
		----------------------------------------------	

		---- add user to databases
		EXEC ('USE ' + @database_name +';
				IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\SQL_Comm_Rep_svc'' ) 
					BEGIN
						EXEC sp_revokedbaccess ''LIBERTYPOWER\SQL_Comm_Rep_svc''
					END
				') 
				
		-- grant access to databases
		EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\SQL_Comm_Rep_svc''; ')
		-- add user to db_OWNER
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''LIBERTYPOWER\SQL_Comm_Rep_svc''; ')
		-- add user to db_datareader
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\SQL_Comm_Rep_svc''; ')
		-- add user to db_datawriter
		EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datawriter'', ''LIBERTYPOWER\SQL_Comm_Rep_svc''; ')
		


		----------------------------------------------
		------ user: SQLProdSupportRO_DW
		----------------------------------------------	

		---- add user to databases
		EXEC ('USE ' + @database_name +';
				IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\SQLProdSupportRO_DW'' ) 
					BEGIN
						DROP USER [LIBERTYPOWER\SQLProdSupportRO_DW]
					END
				') 
				
		-- grant access to databases
		EXEC ('USE ' + @database_name +'; CREATE USER [LIBERTYPOWER\SQLProdSupportRO_DW];')
		-- add user to db_datareader
		EXEC ('USE ' + @database_name +'; Grant view definition to [LIBERTYPOWER\SQLProdSupportRO_DW]; ')
		if @database_name = 'dw_workspace'
		 begin
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''LIBERTYPOWER\SQLProdSupportRO_DW''; ')
		 end
		else
		 begin
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\SQLProdSupportRO_DW''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\SQLProdSupportRO_DW''; ')
		 end



	END
	CLOSE db_cur
	DEALLOCATE db_cur


	-- GRANT ACCESS TO SPECIFIC DATABASES FOR SPECIFIC USERS
	

	-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur2 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('libertypower','integration','lp_reports','lp_account','lp_common','lp_commissions','lp_deal_capture','lp_enrollment','offerenginedb','salesforce','ReportServer$LPCSQL1DEV','lp_risk','ISTA','ISTA_Billing','ISTA_Market','LP_RPTObjects')



	OPEN db_cur2

	WHILE 1 = 1
	BEGIN
		FETCH db_cur2 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		--	PRINT ''
		--	PRINT 'Current database=' + @database_name
		
		------------------------------------------
		-- user: SQLReports_Read
		------------------------------------------
--		IF @database_name <> 'lp_reports'
--			BEGIN
			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dhung'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\dhung''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dhung''; ')
			-- add user to db_OWNER
--			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''LIBERTYPOWER\dhung''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dhung''; ')
			
			
			
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dmarino'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\dmarino''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dmarino''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dmarino''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\dmarino''; ')
			
			
			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\earistud'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\earistud''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\earistud''; ')
			-- add user to db_OWNER
--			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''LIBERTYPOWER\earistud''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\earistud''; ')
			



			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\vprasad'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\vprasad''
						END
					') 
						
			-- grant access to databases
--			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess  ''LIBERTYPOWER\vprasad''; ')
			EXEC ('USE ' + @database_name +'; CREATE USER  [LIBERTYPOWER\vprasad] for LOGIN [LIBERTYPOWER\vprasad] WITH DEFAULT_SCHEMA = dbo; ')
 
 			-- add user to db_OWNER
--			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''LIBERTYPOWER\vprasad''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\vprasad''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\vprasad''; ')
			

			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dcarbonell'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\dcarbonell''
						END
					') 
						
			-- grant access to databases
--			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess  ''LIBERTYPOWER\vprasad''; ')
			EXEC ('USE ' + @database_name +'; CREATE USER  [LIBERTYPOWER\dcarbonell] for LOGIN [LIBERTYPOWER\dcarbonell] WITH DEFAULT_SCHEMA = dbo; ')
 
 			-- add user to db_OWNER
--			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''LIBERTYPOWER\vprasad''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dcarbonell''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\dcarbonell''; ')
			
			
			
						
			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\atafur'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\atafur''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\atafur''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\atafur''; ')			
			


			-- add user to databases
--			EXEC ('USE ' + @database_name +';
--					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\rdelsalto'' ) 
--						BEGIN
--							EXEC sp_revokedbaccess ''LIBERTYPOWER\rdelsalto''
--						END
--					') 
						
--			-- grant access to databases
--			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\rdelsalto''; ')
--			-- add user to db_OWNER
----			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''LIBERTYPOWER\rdelsalto''; ')
--			-- add user to db_datareader
--			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\rdelsalto''; ')
			

			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\rcoots'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\rcoots''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\rcoots''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\rcoots''; ')			
		    EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\rcoots''; ')  
			
			
			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mbolivar'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\mbolivar''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mbolivar''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mbolivar''; ')						
			
			
			
			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\iserna'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\iserna''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\iserna''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\iserna''; ')
			
			
			
			
			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\asinayuk'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\asinayuk''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\asinayuk''; ')
			-- add user to db_OWNER
--			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_owner'', ''LIBERTYPOWER\rcoots''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\asinayuk''; ')				
--		END


			---- add user to databases
			--EXEC ('USE ' + @database_name +';
			--		IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\tcrooks'' ) 
			--			BEGIN
			--				EXEC sp_revokedbaccess ''LIBERTYPOWER\tcrooks''
			--			END
			--		') 
						
			---- grant access to databases
			--EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\tcrooks''; ')
			--EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\tcrooks''; ')				



			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mscheuerman'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\mscheuerman''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mscheuerman''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mscheuerman''; ')				
			

			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\agregory'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\agregory''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\agregory''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\agregory''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\agregory''; ')
				

			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\jmorales'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\jmorales''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\jmorales''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\jmorales''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\jmorales''; ')
				

			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\wvilchez'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\wvilchez''
						END
					') 

		
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\wvilchez''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\wvilchez''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\wvilchez''; ')


									
			-- add user to databases
			-- (jth) EXEC ('USE ' + @database_name +';
			-- (jth)		IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\sscott'' ) 
			-- (jth)			BEGIN
			-- (jth)				EXEC sp_revokedbaccess ''LIBERTYPOWER\sscott''
			-- (jth)			END
			-- (jth)		') 
						
			-- grant access to databases
			-- (jth)EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\sscott''; ')
			-- (jth)EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\sscott''; ')
			-- (jth)EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\sscott''; ')

			-- (jth)if @database_name = 'lp_account'
			 -- (jth)begin
			-- (jth)	EXEC ('USE ' + @database_name +'; Grant execute on usp_account_sel_list to [libertypower\sscott] ')				
			 -- (jth)end

			-- (jth)if @database_name = 'libertypower'
			-- (jth)begin
			-- (jth)	EXEC ('USE ' + @database_name +'; Grant execute on ufn_GetLegacyAccountStatus to [libertypower\sscott] ')				
			-- (jth)	EXEC ('USE ' + @database_name +'; Grant execute on ufn_GetLegacyAccountSubStatus to [libertypower\sscott] ')				
			-- (jth) end

			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\sbarr'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\sbarr''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\sbarr''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\sbarr''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\sbarr''; ')
			
			
		
			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\sw users'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\sw users''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\sw users''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\sw users''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\sw users''; ')
			EXEC ('USE ' + @database_name +'; grant view definition to [LIBERTYPOWER\sw users]')

			
            -- add user to databases 
 			EXEC ('USE ' + @database_name +';
 					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\jmarsh'' ) 
 						BEGIN
 							EXEC sp_revokedbaccess ''LIBERTYPOWER\jmarsh''
 						END
 					') 
 						
 			-- grant access to databases
 			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\jmarsh''; ')
 			-- add user to db_datareader
 			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\jmarsh''; ')	
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\jmarsh''; ')

	        
	        -- add user to databases 
 			EXEC ('USE ' + @database_name +';
 					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\clima'' ) 
 						BEGIN
 							EXEC sp_revokedbaccess ''LIBERTYPOWER\clima''
 						END
 					') 
 						
 			-- grant access to databases
 			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\clima''; ')
 			-- add user to db_datareader
 			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\clima''; ')	
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\clima''; ')

	
	
            -- add user to databases 
 			EXEC ('USE ' + @database_name +';
 					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\lfreedman'' ) 
 						BEGIN
 							EXEC sp_revokedbaccess ''LIBERTYPOWER\lfreedman''
 						END
 					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''lfreedman'' )  -- different name in SQL1
 						BEGIN
 							EXEC sp_revokedbaccess ''lfreedman''
 						END
 					') 
 						
 			-- grant access to databases
 			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\lfreedman''; ')
 			-- add user to db_datareader
 			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\lfreedman''; ')	
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\lfreedman''; ')

	
            -- add user to databases 
 			EXEC ('USE ' + @database_name +';
 					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\rstein'' ) 
 						BEGIN
 							EXEC sp_revokedbaccess ''LIBERTYPOWER\rstein''
 						END
 					') 
 						
 			-- grant access to databases
 			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\rstein''; ')
 			-- add user to db_datareader
 			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\rstein''; ')	
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\rstein''; ')

	
		

	END
	CLOSE db_cur2
	DEALLOCATE db_cur2






-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur3 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('libertypower','lp_reports','lp_account','lp_common','lp_enrollment','ReportServer$LPCSQL1DEV', 'ISTA', 'ISTA_BIlling','LP_RPTObjects')



	OPEN db_cur3

	WHILE 1 = 1
	BEGIN
		FETCH db_cur3 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

	
		------------------------------------------
		-- user: SQLReports_Read
		------------------------------------------
			-- add user to databases
			-- jclemens removed 11/6/2012 sicne AD not exists and impacting SQLReorg
			--EXEC ('USE ' + @database_name +';
			--		IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\jclemens'' ) 
			--			BEGIN
			--				EXEC sp_revokedbaccess ''LIBERTYPOWER\jclemens''
			--			END
			--		') 
						
			---- grant access to databases
			--EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\jclemens''; ')
			---- add user to db_datareader
			--EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\jclemens''; ')

			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\phill'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\phill''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\phill''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\phill''; ')



			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dkates'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\dkates''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dkates''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dkates''; ')
		    EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\dkates''; ')  


			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\hjormelius'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\hjormelius''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\hjormelius''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\hjormelius''; ')
		    EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\hjormelius''; ')  


			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dkodama'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\dkodama''
						END
					') 
		

			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dkodama''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dkodama''; ')
		    EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\dkodama''; ')  


	END
	CLOSE db_cur3
	DEALLOCATE db_cur3





-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur4 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('lp_reports','lp_account','Salesforce','LP_RPTObjects')



	OPEN db_cur4

	WHILE 1 = 1
	BEGIN
		FETCH db_cur4 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		  ------------------------------------------  
		  -- user: LIBERTYPOWER\vprasad  
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\vprasad added 10/18/2011 (ticket 1-3543861)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\vprasad'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\vprasad''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\vprasad''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\vprasad''; ')  
     
     	------------------------------------------
		-- user: SQLReports_Read
		------------------------------------------
			-- add user to databases
			--
			-- LIBERTYPOWER\dcarbonell added 5/2/2011 (ticket 22816)
 			--
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dcarbonell'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\dcarbonell''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dcarbonell''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dcarbonell''; ')
			
			
			
			------------------------------------------
		-- user: SQLReports_Read
		------------------------------------------
			-- add user to databases
			--
			-- LIBERTYPOWER\m2gonzalez added 8/29/2011 (Per Douglas Marino)
 			--
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\m2gonzalez'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\m2gonzalez''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\m2gonzalez''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\m2gonzalez''; ')


			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dkodama'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\dkodama''
						END
					') 
		

			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dkodama''; ')
			-- add user to db_datareader
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dkodama''; ')
		    EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\dkodama''; ')  



	END
	CLOSE db_cur4
	DEALLOCATE db_cur4

----

-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur5 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('Salesforce','LP_RPTObjects')

	OPEN db_cur5

	WHILE 1 = 1
	BEGIN
		FETCH db_cur5 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		  ------------------------------------------  
		  -- user: LIBERTYPOWER\vprasad  
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\EUSales_RO_Users added 4/13/2012 LF (ticket 1-12949991)  
		   --  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\EUSales_RO_Users'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\EUSales_RO_Users''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\EUSales_RO_Users''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\EUSales_RO_Users''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\EUSales_RO_Users''; ')  
     

	END
	CLOSE db_cur5
	DEALLOCATE db_cur5

-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur6 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('Libertypower','lp_account','lp_common','lp_deal_capture','LP_RPTObjects')

	OPEN db_cur6

	WHILE 1 = 1
	BEGIN
		FETCH db_cur6 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		  ------------------------------------------  
		  -- user: LIBERTYPOWER\wholesalesqlaccess
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\wholesalesqlaccess added 5/7/2012 LF (ticket 1-14585971)  
		   --  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\wholesalesqlaccess'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\wholesalesqlaccess''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\wholesalesqlaccess''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\wholesalesqlaccess''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\wholesalesqlaccess''; ')  
     

	END
	CLOSE db_cur6
	DEALLOCATE db_cur6

-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur7 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('lp_reports', 'lp_account','libertypower','LP_RPTObjects')


	OPEN db_cur7

	WHILE 1 = 1
	BEGIN
		FETCH db_cur7 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		  ------------------------------------------  
		  -- user: LIBERTYPOWER\aHylor
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\aHylor added 8/6/2011 (ticket )  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\aHylor'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\aHylor''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\aHylor''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\aHylor''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\aHylor''; ')  
     
		  ------------------------------------------  
		  -- user: LIBERTYPOWER\mcosio
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\mcosio added 9/13/2012 (ticket 1-27312221 )  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mcosio'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\mcosio''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mcosio''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mcosio''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\mcosio''; ')  
     
     


	END
	CLOSE db_cur7
	DEALLOCATE db_cur7


-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur7a CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('lp_reports', 'lp_account','libertypower','lp_common','lp_commissions','LP_RPTObjects')


	OPEN db_cur7a

	WHILE 1 = 1
	BEGIN
		FETCH db_cur7a INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		  ------------------------------------------  
		  -- user: LIBERTYPOWER\mcallaghan 
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\mcallaghan added 5/23/2011 (ticket 1-16219791 and 1-20711411)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mcallaghan'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\mcallaghan''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mcallaghan''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mcallaghan''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\mcallaghan''; ')  


	END
	CLOSE db_cur7a
	DEALLOCATE db_cur7a

-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur8 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('libertypower', 'ordermanagement', 'lp_account', 'lp_reports','ISTA','ISTA_Billing','LP_RPTObjects', 'lp_common')


	OPEN db_cur8

	WHILE 1 = 1
	BEGIN
		FETCH db_cur8 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		  ------------------------------------------  
		  -- user: LIBERTYPOWER\mscheuerman
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\mscheuerman added 6/28/2011 (ticket 1-18294601)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mscheuerman'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\mscheuerman''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mscheuerman''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mscheuerman''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\mscheuerman''; ')  
     
		  ------------------------------------------  
		  -- user: LIBERTYPOWER\agregory
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\agregory added 6/28/2011 (ticket 1-18294601)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\agregory'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\agregory''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\agregory''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\agregory''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\agregory''; ')  
     
		  ------------------------------------------  
		  -- user: LIBERTYPOWER\a2martinez
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\a2martinez added 6/28/2011 (ticket 1-18294601)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\a2martinez'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\a2martinez''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\a2martinez''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\a2martinez''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\a2martinez''; ')  

		  ------------------------------------------  
		  -- user: LIBERTYPOWER\SLEVINE
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\SLEVINE added 4/1/2013 (ticket 1-88796664)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\SLEVINE'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\SLEVINE''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\SLEVINE''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\SLEVINE''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\SLEVINE''; ')  

     

	END
	CLOSE db_cur8
	DEALLOCATE db_cur8

----


-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++

-- THIS ONE ONLY FOR ROPS_Interface_svc

	DECLARE db_cur9 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('libertypower', 'lp_account', 'lp_common', 'lp_risk', 'lp_deal_capture','LP_RPTObjects')


	OPEN db_cur9

	WHILE 1 = 1
	BEGIN
		FETCH db_cur9 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK


			-- add user to databases
			EXEC ('USE ' + @database_name +';
					IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\ROPS_Interface_svc'' ) 
						BEGIN
							EXEC sp_revokedbaccess ''LIBERTYPOWER\ROPS_Interface_svc''
						END
					') 
						
			-- grant access to databases
			EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\ROPS_Interface_svc''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\ROPS_Interface_svc''; ')
			EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\ROPS_Interface_svc''; ')
	

	END
	CLOSE db_cur9
	DEALLOCATE db_cur9

----
-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur10 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('libertypower', 'lp_common','LP_RPTObjects')


	OPEN db_cur10

	WHILE 1 = 1
	BEGIN
		FETCH db_cur10 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

     
		  ------------------------------------------  
		  -- user: LIBERTYPOWER\tetson
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\tetson added 10/11/2011 (ticket 1-32909103)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\tetson'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\tetson''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\tetson''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\tetson''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\tetson''; ')  

		  ------------------------------------------  
		  -- user: LIBERTYPOWER\msanghavi
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\tetson added 10/11/2011 (ticket 1-32909103)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\msanghavi'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\msanghavi''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\msanghavi''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\msanghavi''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\msanghavi''; ')  


	END
	CLOSE db_cur10
	DEALLOCATE db_cur10



-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur11 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('lp_Account','LP_RPTObjects')


	OPEN db_cur11

	WHILE 1 = 1
	BEGIN
		FETCH db_cur11 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

     
		  ------------------------------------------  
		  -- user: LIBERTYPOWER\ABUHLER
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\ABUHLER added 10/11/2011 (ticket 1-32909103)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\ABUHLER'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\ABUHLER''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\ABUHLER''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\ABUHLER''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\ABUHLER''; ')  



	END
	CLOSE db_cur11
	DEALLOCATE db_cur11
----
-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur12 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('integration','LP_RPTObjects', 'OfferEngineDB')


	OPEN db_cur12

	WHILE 1 = 1
	BEGIN
		FETCH db_cur12 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

     
		  ------------------------------------------  
		  -- user: LIBERTYPOWER\a2martinez
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\a2martinez added 17/12/2012 (ticket 1-44882321)  
		   -- Access to OfferEngineDB added 3/12/2012 (ticket 1-74098859)
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\a2martinez'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\a2martinez''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\a2martinez''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\a2martinez''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\a2martinez''; ')  


		  ------------------------------------------  
		  -- user: LIBERTYPOWER\SLEVINE
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- LIBERTYPOWER\SLEVINE added 4/1/2013 (ticket 1-88796664)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\SLEVINE'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\SLEVINE''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\SLEVINE''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\SLEVINE''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\SLEVINE''; ')  


	END
	CLOSE db_cur12
	DEALLOCATE db_cur12


-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur13 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('lp_billing', 'lp_commissions', 'lp_enrollment', 'lp_deal_capture', 'OfferEngineDB')


	OPEN db_cur13

	WHILE 1 = 1
	BEGIN
		FETCH db_cur13 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

     
		  ------------------------------------------  
		  -- user: LIBERTYPOWER\msanghavi
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- added 2/7/2013 (ticket 1-61356831)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\msanghavi'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\msanghavi''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\msanghavi''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\msanghavi''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\msanghavi''; ')  


	END
	CLOSE db_cur13
	DEALLOCATE db_cur13



-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur14 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('ERCOT', 'lp_risk')


	OPEN db_cur14

	WHILE 1 = 1
	BEGIN
		FETCH db_cur14 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

     
			-- Ticket by TEston 1-64785081 

			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\aonaghten'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\aonaghten''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\aonaghten''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\aonaghten''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\aonaghten''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dpena'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\dpena''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dpena''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dpena''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\dpena''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\gdiaz'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\gdiaz''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\gdiaz''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\gdiaz''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\gdiaz''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\jalbarran'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\jalbarran''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\jalbarran''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\jalbarran''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\jalbarran''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\kramgulam'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\kramgulam''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\kramgulam''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\kramgulam''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\kramgulam''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mbarrett'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\mbarrett''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mbarrett''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mbarrett''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\mbarrett''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\rcoots'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\rcoots''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\rcoots''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\rcoots''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\rcoots''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\rfgomez'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\rfgomez''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\rfgomez''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\rfgomez''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\rfgomez''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\wampofo'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\wampofo''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\wampofo''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\wampofo''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\wampofo''; ')  



	END
	CLOSE db_cur14
	DEALLOCATE db_cur14


-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur15 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('lp_Account','SalesForce','OfferEngineDB')


	OPEN db_cur15

	WHILE 1 = 1
	BEGIN
		FETCH db_cur15 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

		   -- LIBERTYPOWER\aonaghten added 3/6/2013 (ticket 1-73521421/1-73523171)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\aonaghten'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\aonaghten''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\aonaghten''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\aonaghten''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\aonaghten''; ')  


		   -- LIBERTYPOWER\aonaghten added 3/6/2013 (ticket 1-1-73550301)  
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dmendez'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\dmendez''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dmendez''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dmendez''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\dmendez''; ')  

		   -- LIBERTYPOWER\tcoffing, dmoretti, mstracke, wampofo, mamador   added 3/7/2013 (ticket 1-1-73550301)  
			
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\tcoffing'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\tcoffing''  
			  END  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\tcoffing''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\tcoffing''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\tcoffing''; ')  
--
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\dmoretti'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\dmoretti''  
			  END  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\dmoretti''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\dmoretti''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\dmoretti''; ')  
--
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mstracke'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\mstracke''  
			  END  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mstracke''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mstracke''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\mstracke''; ')  
--
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\wampofo'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\wampofo''  
			  END  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\wampofo''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\wampofo''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\wampofo''; ')  
--
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mamador'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\mamador''  
			  END  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mamador''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mamador''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\mamador''; ')  


	END
	CLOSE db_cur15
	DEALLOCATE db_cur15

-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur16 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('libertypower', 'lp_common', 'lp_deal_capture')


		-- All following users granted on ticket 1-77343671 

	OPEN db_cur16

	WHILE 1 = 1
	BEGIN
		FETCH db_cur16 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

			----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\jalbarran'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\jalbarran''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\jalbarran''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\jalbarran''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\jalbarran''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\mbarrett'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\mbarrett''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\mbarrett''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\mbarrett''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\mbarrett''; ')  

		----
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\rfgomez'' )   
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\rfgomez''  
			 ')   
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\rfgomez''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\rfgomez''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\rfgomez''; ')  

		----  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\tetson'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\tetson''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\tetson''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\tetson''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\tetson''; ')  


	END
	CLOSE db_cur16
	DEALLOCATE db_cur16


-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur17 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('SalesForce')


	OPEN db_cur17

	WHILE 1 = 1
	BEGIN
		FETCH db_cur17 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK

     
		  ------------------------------------------  
		  -- user: linked_server_login_from_SQL9
		  ------------------------------------------  
		   -- add user to databases  
		   --  
		   -- added for IT051
			--  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''linked_server_login_from_SQL9'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''linked_server_login_from_SQL9''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''linked_server_login_from_SQL9''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''linked_server_login_from_SQL9''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''linked_server_login_from_SQL9''; ')  


	END
	CLOSE db_cur17
	DEALLOCATE db_cur17


	-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur18 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('lp_transactions','OrderManagement','libertypower','integration','lp_documents','lp_reports','lp_account','lp_common','lp_commissions','lp_deal_capture','lp_enrollment','offerenginedb','salesforce','ReportServer$LPCSQL1DEV','lp_risk')



	OPEN db_cur18

	WHILE 1 = 1
	BEGIN
		FETCH db_cur18 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK


		----  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\vmotipalli'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\vmotipalli''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\vmotipalli''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\vmotipalli''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\vmotipalli''; ')  
		   EXEC ('USE ' + @database_name +'; grant view definition to [libertypower\vmotipalli]; ')  
			if @database_name = 'libertypower'
			 begin
				EXEC ('USE ' + @database_name +'; Grant execute on ufn_GetLegacyAccountStatus to [libertypower\vmotipalli] ')				
				EXEC ('USE ' + @database_name +'; Grant execute on ufn_GetLegacyAccountSubStatus to [libertypower\vmotipalli] ')				
				EXEC ('USE ' + @database_name +'; Grant execute on ufn_GetLegacyDateDeenrollment to [libertypower\vmotipalli] ')			
			 end



	END

	CLOSE db_cur18
	DEALLOCATE db_cur18



	-- ++++++++++++++++++ loop thro' all User-Databases ++++++++++++++++++
	DECLARE db_cur19 CURSOR LOCAL FAST_FORWARD FOR
		SELECT 
			DATABASE_NAME 
		FROM 
			#databases
		WHERE 
			DATABASE_NAME IN ('lp_reports')

	-- Ticket 1-103110811 


	OPEN db_cur19

	WHILE 1 = 1
	BEGIN
		FETCH db_cur19 INTO @database_name
		IF (@@FETCH_STATUS <> 0) BREAK


		----  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\tetson'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\tetson''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\tetson''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\tetson''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\tetson''; ')  


		----  
		   EXEC ('USE ' + @database_name +';  
			 IF EXISTS (SELECT 1 FROM sysusers WHERE [name] = ''LIBERTYPOWER\msanghavi'' )   
			  BEGIN  
			   EXEC sp_revokedbaccess ''LIBERTYPOWER\msanghavi''  
			  END  
			 ')   
		        
		   -- grant access to databases  
		   EXEC ('USE ' + @database_name +'; EXEC sp_grantdbaccess ''LIBERTYPOWER\msanghavi''; ')  
		   -- add user to db_datareader  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_datareader'', ''LIBERTYPOWER\msanghavi''; ')  
		   EXEC ('USE ' + @database_name +'; EXEC sp_addrolemember ''db_denydatawriter'', ''LIBERTYPOWER\msanghavi''; ')  


	END

	CLOSE db_cur19
	DEALLOCATE db_cur19



	DROP TABLE #databases


END






