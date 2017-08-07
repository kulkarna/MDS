
CREATE VIEW [dbo].[vw_SalesChannel]
AS
SELECT DISTINCT 
	SC.ChannelID, SC.ChannelName, SC.DateCreated, SC.DateModified, SC.CreatedBy, SC.ModifiedBy, SC.EntityID, SC.ChannelDevelopmentManagerID, 
    SC.ChannelDescription, SC.ActiveDirectoryLoginID, SC.HasManagedUsers, SC.Inactive, VEN.vendor_system_name, 
    RTRIM(COALESCE (USR.Firstname, '') + ' ' + COALESCE (USR.Lastname, '')) AS SalesManager, VEN.vendor_type_id, VT.vendor_type_code, 
    VEN.vendor_category_id, VC.vendor_category_code, COALESCE (USR.Email, '') AS ManagerEmail
    , USR.UserName
	, ( 
		SELECT ChannelType 
		FROM LibertyPower.dbo.OrgChartHistory OCH
		WHERE EffectiveDate=(SELECT MAX(OCH2.EffectiveDate) FROM LibertyPower.dbo.OrgChartHistory OCH2 WHERE OCH2.SalesMgrChannel=OCH.SalesMgrChannel)
			AND RTRIM(COALESCE (USR.Firstname, '') + ' ' + COALESCE (USR.Lastname, '')) = SalesMgrChannel
		) Department
FROM         dbo.SalesChannel AS SC WITH (NOLOCK) LEFT OUTER JOIN
                      dbo.[User] AS USR WITH (NOLOCK) ON USR.UserID = SC.ChannelDevelopmentManagerID LEFT OUTER JOIN
                      lp_commissions.dbo.vendor AS VEN WITH (NOLOCK) ON VEN.vendor_system_name = 'Sales Channel/' + SC.ChannelName LEFT OUTER JOIN
                      lp_commissions.dbo.vendor_category AS VC WITH (NOLOCK) ON VC.vendor_category_id = VEN.vendor_category_id LEFT OUTER JOIN
                      lp_commissions.dbo.vendor_type AS VT WITH (NOLOCK) ON VT.vendor_type_id = VEN.vendor_type_id
WHERE     (VEN.vendor_system_name IS NOT NULL)
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_SalesChannel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'nd
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_SalesChannel';


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
         Configuration = "(H (1 [50] 4 [25] 3))"
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
         Configuration = "(H (1 [75] 4))"
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
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SC"
            Begin Extent = 
               Top = 29
               Left = 554
               Bottom = 144
               Right = 790
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "USR"
            Begin Extent = 
               Top = 16
               Left = 921
               Bottom = 131
               Right = 1073
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "VEN"
            Begin Extent = 
               Top = 125
               Left = 254
               Bottom = 240
               Right = 522
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VC"
            Begin Extent = 
               Top = 229
               Left = 15
               Bottom = 329
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VT"
            Begin Extent = 
               Top = 192
               Left = 894
               Bottom = 292
               Right = 1071
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
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
   E', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_SalesChannel';

