








CREATE VIEW [dbo].[vw_SalesManagerHistory]
AS

SELECT 
	MM_RNUM.vendor_category_id
	, MM_RNUM.Vendor_System_Name 
	, MM_RNUM.Date_Audit 
	, MM_RNUM.Sales_Manager
	, MM_RNUM.vendor_category_code
--INTO #tmpView
FROM
	(
		SELECT 
			vendor_category_id, Vendor_System_Name, Date_Audit,MAX(RNum)  RNUM
		FROM
			(
				SELECT 
					ROW_NUMBER() OVER (PARTITION BY Vendor_Category_ID, Vendor_System_Name, Date_Audit Order by QryLevel, Date_Audit )  RNum
					,* 
				FROM
					(	
						SELECT DISTINCT
							1 QryLevel
							, vc.vendor_category_id
							, UPPER(ZAV.Vendor_System_Name) Vendor_System_Name
--							,DateAdd(dd, DateDiff(dd, 0, Date_Audit) , 0 ) 
							, date_audit Date_Audit
							, ZAV.Sales_Manager
							, COALESCE(vc.vendor_category_code,'NONE') vendor_category_code
						FROM
							Lp_Commissions.dbo.zAudit_Vendor ZAV (nolock)
							JOIN lp_commissions..vendor_category vc (nolock)
											ON ZAV.vendor_category_id = vc.vendor_category_id
						WHERE 
							ZAV.Sales_Manager IS NOT NULL
							AND date_audit = (
												SELECT 
													MAX(Date_Audit) 
												FROM 
													Lp_Commissions.dbo.zAudit_Vendor ZAV2 (nolock)
														JOIN lp_commissions..vendor_category vc2 (nolock)
															ON ZAV2.vendor_category_id = vc2.vendor_category_id					
												WHERE
													ZAV2.Sales_Manager IS NOT NULL
													AND ZAV2.Vendor_System_Name = ZAV.vendor_system_name
													AND DateAdd(dd, DateDiff(dd, 0, ZAV2.Date_Audit) , 0 ) = DateAdd(dd, DateDiff(dd, 0, ZAV.Date_Audit) , 0 ) 
											)
							AND Date_Audit <= (
												SELECT 
													MAX(sch.datemodified)
												FROM 
													Libertypower.dbo.SalesChannelHistory SCH 
													LEFT JOIN Libertypower.dbo.[User] ON UserID=ChannelDevelopmentManagerID
												WHERE	
													SCH.ChannelName = REPLACE(Vendor_System_Name,'Sales CHannel/','')
											)											
--AND Vendor_System_Name='sales channel/MME'		 --order by 4			
		UNION
		
		
		
		
				SELECT 
					2 QryLevel
--					, (SELECT vendor_category_id FROM Lp_Commissions.dbo.Vendor WHERE vendor_name=ChannelName) Vendor_Category_ID
					, (SELECT vendor_category_id FROM Lp_Commissions.dbo.Vendor WHERE Vendor_System_Name=('SALES CHANNEL/'+ChannelName)) Vendor_Category_ID
					,('SALES CHANNEL/'+ChannelName) Vendor_System_Name
					--,DateAdd(dd, DateDiff(dd, 0, SCH.DateModified) , 0 ) 
					,sch.datemodified Date_Audit
--					, (FirstName+' '+Lastname) Sales_Manager
					
					, COALESCE(  (
						SELECT TOP 1 (X.FirstName+' '+X.Lastname)
						FROM LibertyPower.dbo.SalesChannelHistory Z
							JOIN LibertyPower.dbo.[User] X ON X.UserID=Z.ChannelDevelopmentManagerID
						WHERE 
							Z.ChannelName = SCH.ChannelName
							AND Z.DateModified > SCH.DateModified
							AND Z.DateModified = (SELECT MIN(zz.DateModified) FROM LibertyPower.dbo.SalesChannelHistory zz WHERE zz.ChannelName=z.channelName AND zz.DateModified>=z.DateModified)
						)
						, (FirstName+' '+Lastname) ) Sales_Manager
				
					,(
						SELECT COALESCE(vc.vendor_category_code,'NONE') vendor_category_code 
						FROM 
							lp_commissions.dbo.vendor VE 
							JOIN lp_commissions.dbo.vendor_category VC ON VC.vendor_category_id=VE.vendor_category_id 
						WHERE VE.vendor_name=ChannelName
					) Vendor_category_code 
				FROM 
					Libertypower.dbo.SalesChannelHistory SCH 
					LEFT JOIN Libertypower.dbo.[User] ON UserID=ChannelDevelopmentManagerID

--where channelname='mme'


		UNION

			SELECT 
				3 QryLevel
				, (SELECT vendor_category_id FROM Lp_Commissions.dbo.Vendor WHERE Vendor_System_Name=('SALES CHANNEL/'+SC.ChannelName)) Vendor_Category_ID
				, ('SALES CHANNEL/'+SC.ChannelName) Vendor_System_Name
--				, DateAdd(dd, DateDiff(dd, 0, SCH.DateModified) , 0 ) 
				, SCH.DateModified Date_Audit
				, (FirstName+' '+Lastname) Sales_Manager
				, (SELECT COALESCE(vc.vendor_category_code,'NONE')) vendor_category_code 
			FROM
				Libertypower.dbo.SalesChannel SC
					JOIN Libertypower.dbo.SalesChannelHistory SCH ON SC.ChannelName=SCH.ChannelName
					JOIN Libertypower.dbo.[User] ON UserID=SC.ChannelDevelopmentManagerID
					JOIN lp_commissions.dbo.vendor VE ON ('Sales Channel/'+SC.ChannelName) = VE.vendor_system_name
					JOIN lp_commissions.dbo.vendor_category VC ON VC.vendor_category_id=VE.vendor_category_id 
					
			WHERE
				SCH.ChannelHistoryID = (
										SELECT  MAX(SCH2.ChannelHistoryID)
										FROM Libertypower.dbo.SalesChannelHistory SCH2
										WHERE SCH.ChannelName=SCH2.ChannelName
										)
--and Vendor_System_Name='sales channel/mme'
			) MASTER_Q
--where Vendor_System_Name='sales channel/soe'
			) MMASTER

		GROUP BY vendor_category_id, Vendor_System_Name, Date_Audit
		
	) MASTER_GROUP
	
	
	JOIN (
			SELECT 
				ROW_NUMBER() OVER (PARTITION BY Vendor_Category_ID, Vendor_System_Name, Date_Audit Order by QryLevel, Date_Audit ) RNum
				,* 
			FROM
				(	
					SELECT DISTINCT
						1 QryLevel
						, vc.vendor_category_id
						, UPPER(ZAV.Vendor_System_Name) Vendor_System_Name
						--,DateAdd(dd, DateDiff(dd, 0, Date_Audit) , 0 ) 
						, date_audit Date_Audit
						, ZAV.Sales_Manager
						, COALESCE(vc.vendor_category_code,'NONE') vendor_category_code
					FROM
						Lp_Commissions.dbo.zAudit_Vendor ZAV (nolock)
						JOIN lp_commissions..vendor_category vc (nolock)
										ON ZAV.vendor_category_id = vc.vendor_category_id
					WHERE 
						ZAV.Sales_Manager IS NOT NULL
							AND date_audit = (
												SELECT 
													MAX(Date_Audit) 
												FROM 
													Lp_Commissions.dbo.zAudit_Vendor ZAV2 (nolock)
														JOIN lp_commissions..vendor_category vc2 (nolock)
															ON ZAV2.vendor_category_id = vc2.vendor_category_id					
												WHERE
													ZAV2.Sales_Manager IS NOT NULL
													AND ZAV2.Vendor_System_Name = ZAV.vendor_system_name
													AND DateAdd(dd, DateDiff(dd, 0, ZAV2.Date_Audit) , 0 ) = DateAdd(dd, DateDiff(dd, 0, ZAV.Date_Audit) , 0 ) 
											)						
							AND Date_Audit <= (
												SELECT 
													MAX(sch.datemodified)
												FROM 
													Libertypower.dbo.SalesChannelHistory SCH 
													LEFT JOIN Libertypower.dbo.[User] ON UserID=ChannelDevelopmentManagerID
												WHERE	
													SCH.ChannelName = REPLACE(Vendor_System_Name,'Sales CHannel/','')
											)						
			UNION
					SELECT 
						2 QryLevel
						--, (SELECT vendor_category_id FROM Lp_Commissions.dbo.Vendor WHERE vendor_name=ChannelName) Vendor_Category_ID
						, (SELECT vendor_category_id FROM Lp_Commissions.dbo.Vendor WHERE Vendor_System_Name=('SALES CHANNEL/'+ChannelName)) Vendor_Category_ID
						,('SALES CHANNEL/'+ChannelName) Vendor_System_Name
						--,DateAdd(dd, DateDiff(dd, 0, SCH.DateModified) , 0 ) 
						, sch.DateModified Date_Audit
						, (FirstName+' '+Lastname) Sales_Manager
						,(SELECT COALESCE(vc.vendor_category_code,'NONE') vendor_category_code 
						FROM 
							lp_commissions.dbo.vendor VE 
							JOIN lp_commissions.dbo.vendor_category VC ON VC.vendor_category_id=VE.vendor_category_id 
						WHERE VE.vendor_name=ChannelName) Vendor_category_code 
					FROM 
						Libertypower.dbo.SalesChannelHistory SCH 
						LEFT JOIN Libertypower.dbo.[User] ON UserID=ChannelDevelopmentManagerID
						
			UNION

				SELECT 
					3 QryLevel
					--, (SELECT vendor_category_id FROM Lp_Commissions.dbo.Vendor WHERE vendor_name=SC.ChannelName) Vendor_Category_ID
					, (SELECT vendor_category_id FROM Lp_Commissions.dbo.Vendor WHERE Vendor_System_Name=('SALES CHANNEL/'+SC.ChannelName)) Vendor_Category_ID
					, ('SALES CHANNEL/'+SC.ChannelName) Vendor_System_Name
					--, DateAdd(dd, DateDiff(dd, 0, SCH.DateModified) , 0 ) 
					, SCH.DateModified Date_Audit
					, (FirstName+' '+Lastname) Sales_Manager
					, (SELECT COALESCE(vc.vendor_category_code,'NONE')) vendor_category_code 
				FROM
					Libertypower.dbo.SalesChannel SC
						JOIN Libertypower.dbo.SalesChannelHistory SCH ON SC.ChannelName=SCH.ChannelName
						JOIN Libertypower.dbo.[User] ON UserID=SC.ChannelDevelopmentManagerID
						JOIN lp_commissions.dbo.vendor VE ON ('Sales Channel/'+SC.ChannelName) = VE.vendor_system_name
						JOIN lp_commissions.dbo.vendor_category VC ON VC.vendor_category_id=VE.vendor_category_id 
						
				WHERE
					SCH.ChannelHistoryID = (
											SELECT  MAX(SCH2.ChannelHistoryID)
											FROM Libertypower.dbo.SalesChannelHistory SCH2
											WHERE SCH.ChannelName=SCH2.ChannelName
											)

				) MASTER_Q	
		) MM_RNUM ON MM_RNUM.RNum = MASTER_GROUP.RNUM AND MM_RNUM.vendor_category_id=MASTER_GROUP.vendor_category_id AND MM_RNUM.Vendor_System_Name=MASTER_GROUP.Vendor_System_Name AND MM_RNUM.Date_Audit=MASTER_GROUP.Date_Audit

-- ONLY FOR TESTING PURPOSES
--where MM_RNUM.Vendor_System_Name='sales channel/eeg'


--SELECT
--	*
--FROM
--	#tmpView tV
--WHERE
--	tV.Date_Audit = (
--					SELECT 
--						MAX(TV2.Date_Audit) 
--					FROM 
--						#tmpView TV2
--					WHERE
--						TV.Vendor_System_Name = TV2.Vendor_System_Name
--						AND DateAdd(dd, DateDiff(dd, 0, TV.Date_Audit ) , 0 ) =DateAdd(dd, DateDiff(dd, 0, TV2.Date_Audit ) , 0 ) 
--						)
						
		
--DROP TABLE #tmpView
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_SalesManagerHistory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[75] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2) )"
      End
      ActivePaneConfig = 14
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_SalesManagerHistory';

