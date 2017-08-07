Use Libertypower

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_UtilIDZone]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_UtilIDZone]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_tmp_UtilIDZone](
	[UtilID&EnrollZone] [nvarchar](255) NULL,
	[UtilityID] [float] NULL,
	[ISO] [nvarchar](255) NULL,
	[EnrollmentZone] [nvarchar](255) NULL,
	[ZainetZone] [nvarchar](255) NULL,
	[Util_Code] [nvarchar](255) NULL,
	[Util Full Name] [nvarchar](255) NULL,
	[Overlap?] [float] NULL,
	[F9] [nvarchar](255) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'1HOUSTON', 1, N'ERCOT', N'HOUSTON', N'HOUST', N'AEPCE', N'AEP Texas Central (Corpus Christi Area)', 1, N'AEPCE_HOUSTON')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'1SOUTH', 1, N'ERCOT', N'SOUTH', N'SOUTH', N'AEPCE', N'AEP Texas Central (Corpus Christi Area)', 1, N'AEPCE_SOUTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'1WEST', 1, N'ERCOT', N'WEST', N'WEST', N'AEPCE', N'AEP Texas Central (Corpus Christi Area)', 1, N'AEPCE_WEST')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'2NORTH', 2, N'ERCOT', N'NORTH', N'NORTH', N'AEPNO', N'AEP Texas North (Abilene Area)', 1, N'AEPNO_NORTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'2SOUTH', 2, N'ERCOT', N'SOUTH', N'SOUTH', N'AEPNO', N'AEP Texas North (Abilene Area)', 1, N'AEPNO_SOUTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'2WEST', 2, N'ERCOT', N'WEST', N'WEST', N'AEPNO', N'AEP Texas North (Abilene Area)', 1, N'AEPNO_WEST')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'3HOUSTON', 3, N'ERCOT', N'HOUSTON', N'HOUST', N'CTPEN', N'Centerpoint Energy (Houston Area)', 1, N'CTPEN_HOUSTON')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'3NORTH', 3, N'ERCOT', N'NORTH', N'NORTH', N'CTPEN', N'Centerpoint Energy (Houston Area)', 1, N'CTPEN_NORTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'3SOUTH', 3, N'ERCOT', N'SOUTH', N'SOUTH', N'CTPEN', N'Centerpoint Energy (Houston Area)', 1, N'CTPEN_SOUTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'4HOUSTON', 4, N'ERCOT', N'HOUSTON', N'HOUST', N'TXNMP', N'TNMP (Texas New Mexico Power Area)', 1, N'TXNMP_HOUSTON')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'4NORTH', 4, N'ERCOT', N'NORTH', N'NORTH', N'TXNMP', N'TNMP (Texas New Mexico Power Area)', 1, N'TXNMP_NORTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'4WEST', 4, N'ERCOT', N'WEST', N'WEST', N'TXNMP', N'TNMP (Texas New Mexico Power Area)', 1, N'TXNMP_WEST')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'5HOUSTON', 5, N'ERCOT', N'HOUSTON', N'HOUST', N'ONCOR', N'ONCOR ELECTRIC DELIVERY', 1, N'ONCOR_HOUSTON')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'5NORTH', 5, N'ERCOT', N'NORTH', N'NORTH', N'ONCOR', N'ONCOR ELECTRIC DELIVERY', 1, N'ONCOR_NORTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'5SOUTH', 5, N'ERCOT', N'SOUTH', N'SOUTH', N'ONCOR', N'ONCOR ELECTRIC DELIVERY', 1, N'ONCOR_SOUTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'5WEST', 5, N'ERCOT', N'WEST', N'WEST', N'ONCOR', N'ONCOR ELECTRIC DELIVERY', 1, N'ONCOR_WEST')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'8NORTH', 8, N'ERCOT', N'NORTH', N'NORTH', N'TXU-SESCO', N'Oncor Electric Delivery (SESCO)', 0, N'TXU-SESCO_NORTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'9AECO', 9, N'PJM', N'AECO', N'AECO', N'ACE', N'ACE (ATLANTIC CITY ELECTRIC)', 0, N'ACE_AECO')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'10APS', 10, N'PJM', N'APS', N'APS', N'ALLEGMD', N'POTOMAC EDISON (ALLEGHENY POWER)', 0, N'ALLEGMD_APS')

INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'11AMIL.LPC1', 11, N'MISO', N'AMIL.LPC1', N'LPC1', N'AMEREN', N'AMEREN ELECTRIC', 0, N'AMEREN_AMIL.LPC1')

INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'11AMIL', 11, N'MISO', N'AMIL', N'LPC1', N'AMEREN', N'AMEREN ELECTRIC', 0, N'AMEREN_AMIL')


INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'12ME', 12, N'NEISO', N'ME', N'ME', N'BANGOR', N'BANGOR-HYD (BANGOR HYDRO ELECTRIC CO.)', 0, N'BANGOR_ME')

INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'12MAINE', 12, N'NEISO', N'MAINE', N'ME', N'BANGOR', N'BANGOR-HYD (BANGOR HYDRO ELECTRIC CO.)', 0, N'BANGOR_MAINE')


INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'13BGE', 13, N'PJM', N'BGE', N'BGE', N'BGE', N'BGE (BALTIMORE GAS AND ELECTRIC)', 0, N'BGE_BGE')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'14G', 14, N'NYISO', N'G', N'ZONE G', N'CENHUD', N'CENHUD (CENTRAL HUDSON)', 0, N'CENHUD_G')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'15CT', 15, N'NEISO', N'CT', N'CT', N'CL&P', N'CL&P (CONNECTICUT LIGHT AND POWER)', 0, N'CL&P_CT')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'16ME', 16, N'NEISO', N'ME', N'ME', N'CMP', N'CMP (CENTRAL MAINE POWER)', 0, N'CMP_ME')

INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'16MAINE', 16, N'NEISO', N'MAINE', N'ME', N'CMP', N'CMP (CENTRAL MAINE POWER)', 0, N'CMP_MAINE')

INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'17COMED', 17, N'PJM', N'COMED', N'COMED', N'COMED', N'COMED (COMMONWEALTH EDISON)', 0, N'COMED_COMED')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'18H', 18, N'NYISO', N'H', N'ZONE H', N'CONED', N'CONED (CON EDISON COMPANY OF NEW YORK)', 1, N'CONED_H')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'18I', 18, N'NYISO', N'I', N'ZONE I', N'CONED', N'CONED (CON EDISON COMPANY OF NEW YORK)', 1, N'CONED_I')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'18J', 18, N'NYISO', N'J', N'ZONE J', N'CONED', N'CONED (CON EDISON COMPANY OF NEW YORK)', 1, N'CONED_J')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'19DPL', 19, N'PJM', N'DPL', N'DPL', N'DELDE', N'DELDE (DELMARVA POWER)', 0, N'DELDE_DPL')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'20DPL', 20, N'PJM', N'DPL', N'DPL', N'DELMD', N'DELMD (DELMARVA POWER)', 0, N'DELMD_DPL')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'21DUQ', 21, N'PJM', N'DUQ', N'DUQ', N'DUQ', N'DUQ (DUQUESNE LIGHT AND POWER)', 0, N'DUQ_DUQ')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'22JCPL', 22, N'PJM', N'JCPL', N'JCPL', N'JCP&L', N'JCP&L (JERSEY CENTRAL POWER & LIGHT)', 0, N'JCP&L_JCPL')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'23NEMA', 23, N'NEISO', N'NEMA', N'NEMASS', N'MECO', N'MECO (MASSACHUSETTS ELECTRIC CO - NATIONAL GRID)', 1, N'MECO_NEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'23SEMA', 23, N'NEISO', N'SEMA', N'SEMASS', N'MECO', N'MECO (MASSACHUSETTS ELECTRIC CO - NATIONAL GRID)', 1, N'MECO_SEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'23WCMA', 23, N'NEISO', N'WCMA', N'WCMASS', N'MECO', N'MECO (MASSACHUSETTS ELECTRIC CO - NATIONAL GRID)', 1, N'MECO_WCMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'24SEMA', 24, N'NEISO', N'SEMA', N'SEMASS', N'NANT', N'NANT (NANTUCKET ELECTRIC CO. - NATIONAL GRID)', 1, N'NANT_SEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'24WCMA', 24, N'NEISO', N'WCMA', N'WCMASS', N'NANT', N'NANT (NANTUCKET ELECTRIC CO. - NATIONAL GRID)', 1, N'NANT_WCMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'25WCMA', 25, N'NEISO', N'WCMA', N'WCMASS', N'NECO', N'NECO (NARRANGANSETT ELECTRIC CO. - NATIONAL GRID)', 1, N'NECO_WCMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'25RI', 25, N'NEISO', N'RI', N'RI', N'NECO', N'NECO (NARRANGANSETT ELECTRIC CO. - NATIONAL GRID)', 1, N'NECO_RI')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'26A', 26, N'NYISO', N'A', N'ZONE A', N'NIMO', N'NIMO (NIAGARA MOHAWK)', 1, N'NIMO_A')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'26B', 26, N'NYISO', N'B', N'ZONE B', N'NIMO', N'NIMO (NIAGARA MOHAWK)', 1, N'NIMO_B')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'26C', 26, N'NYISO', N'C', N'ZONE C', N'NIMO', N'NIMO (NIAGARA MOHAWK)', 1, N'NIMO_C')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'26D', 26, N'NYISO', N'D', N'ZONE D', N'NIMO', N'NIMO (NIAGARA MOHAWK)', 1, N'NIMO_D')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'26E', 26, N'NYISO', N'E', N'ZONE E', N'NIMO', N'NIMO (NIAGARA MOHAWK)', 1, N'NIMO_E')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'26F', 26, N'NYISO', N'F', N'ZONE F', N'NIMO', N'NIMO (NIAGARA MOHAWK)', 1, N'NIMO_F')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'27NEMA', 27, N'NEISO', N'NEMA', N'NEMASS', N'NSTAR-BOS', N'NSTAR-BOS (NSTAR BOSTON EDISON)', 1, N'NSTAR-BOS_NEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'27SEMA', 27, N'NEISO', N'SEMA', N'SEMASS', N'NSTAR-BOS', N'NSTAR-BOS (NSTAR BOSTON EDISON)', 1, N'NSTAR-BOS_SEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'28NEMA', 28, N'NEISO', N'NEMA', N'NEMASS', N'NSTAR-CAMB', N'NSTAR-CAMB (NSTAR CAMBRIDGE)', 1, N'NSTAR-CAMB_NEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'28SEMA', 28, N'NEISO', N'SEMA', N'SEMASS', N'NSTAR-CAMB', N'NSTAR-CAMB (NSTAR CAMBRIDGE)', 1, N'NSTAR-CAMB_SEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'29NEMA', 29, N'NEISO', N'NEMA', N'NEMASS', N'NSTAR-COMM', N'NSTAR-COMM (NSTAR COMMONWEALTH)', 1, N'NSTAR-COMM_NEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'29SEMA', 29, N'NEISO', N'SEMA', N'SEMASS', N'NSTAR-COMM', N'NSTAR-COMM (NSTAR COMMONWEALTH)', 1, N'NSTAR-COMM_SEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'30A', 30, N'NYISO', N'A', N'ZONE A', N'NYSEG', N'NYSEG (NEW YORK STATE ELECTRIC AND GAS)', 1, N'NYSEG_A')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'30C', 30, N'NYISO', N'C', N'ZONE C', N'NYSEG', N'NYSEG (NEW YORK STATE ELECTRIC AND GAS)', 1, N'NYSEG_C')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'30D', 30, N'NYISO', N'D', N'ZONE D', N'NYSEG', N'NYSEG (NEW YORK STATE ELECTRIC AND GAS)', 1, N'NYSEG_D')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'30E', 30, N'NYISO', N'E', N'ZONE E', N'NYSEG', N'NYSEG (NEW YORK STATE ELECTRIC AND GAS)', 1, N'NYSEG_E')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'30F', 30, N'NYISO', N'F', N'ZONE F', N'NYSEG', N'NYSEG (NEW YORK STATE ELECTRIC AND GAS)', 1, N'NYSEG_F')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'30H', 30, N'NYISO', N'H', N'ZONE H', N'NYSEG', N'NYSEG (NEW YORK STATE ELECTRIC AND GAS)', 1, N'NYSEG_H')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'31G', 31, N'NYISO', N'G', N'ZONE G', N'O&R', N'ORANGE AND ROCKLAND', 0, N'O&R_G')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'32NORTH', 32, N'ERCOT', N'NORTH', N'NORTH', N'ONCOR-SESCO', N'ONCOR-SESCO (ONCOR ELECTRIC DELIVERY SESCO)', 1, N'ONCOR-SESCO_NORTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'32SOUTH', 32, N'ERCOT', N'SOUTH', N'SOUTH', N'ONCOR-SESCO', N'ONCOR-SESCO (ONCOR ELECTRIC DELIVERY SESCO)', 1, N'ONCOR-SESCO_SOUTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'32WEST', 32, N'ERCOT', N'WEST', N'WEST', N'ONCOR-SESCO', N'ONCOR-SESCO (ONCOR ELECTRIC DELIVERY SESCO)', 1, N'ONCOR-SESCO_WEST')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'33RECO', 33, N'PJM', N'RECO', N'RECO', N'ORNJ', N'ROCKLAND NEW JERSEY', 0, N'ORNJ_RECO')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'34PEPCO', 34, N'PJM', N'PEPCO', N'PEPCO', N'PEPCO-DC', N'PEPCO-DC (POTOMAC ELECTRIC POWER COMPANY DC)', 0, N'PEPCO-DC_PEPCO')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'35PEPCO', 35, N'PJM', N'PEPCO', N'PEPCO', N'PEPCO-MD', N'PEPCO-MD (POTOMAC ELECTRIC POWER COMPANY MARYLAND)', 0, N'PEPCO-MD_PEPCO')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'36PGE', 36, N'CAISO', N'PGE', N'PGE', N'PGE', N'PGE (PACIFIC GAS AND ELECTRIC COMPANY)', 0, N'PGE_PGE')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'37PPL', 37, N'PJM', N'PPL', N'PPL', N'PPL', N'PPL (PENNSYLVANIA POWER AND LIGHT)', 0, N'PPL_PPL')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'38PSEG', 38, N'PJM', N'PSEG', N'PSEG', N'PSEG', N'PSEG (PUBLIC SERVICE ELECTRIC & GAS)', 0, N'PSEG_PSEG')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'39B', 39, N'NYISO', N'B', N'ZONE B', N'RGE', N'RGE (ROCHESTER GAS & ELECTRIC)', 0, N'RGE_B')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'40RECO', 40, N'PJM', N'RECO', N'RECO', N'ROCKLAND', N'ROCKLAND ELECTRIC', 0, N'ROCKLAND_RECO')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'41SCE', 41, N'CAISO', N'SCE', N'SCE', N'SCE', N'SCE (SOUTHERN CALIFORNIA EDISON)', 0, N'SCE_SCE')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'42SDGE', 42, N'CAISO', N'SDGE', N'SDGE', N'SDGE', N'SDGE (SAN DIEGO GAS AND ELECTRIC)', 0, N'SDGE_SDGE')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'43SOUTH', 43, N'ERCOT', N'SOUTH', N'SOUTH', N'SHARYLAND', N'SHARYLAND UTILITIES', 0, N'SHARYLAND_SOUTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'43WEST', 43, N'ERCOT', N'WEST', N'WEST', N'SHARYLAND', N'SHARYLAND UTILITIES', 0, N'SHARYLAND_WEST')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'44HOUSTON', 44, N'ERCOT', N'HOUSTON', N'HOUST', N'TXU', N'TXU ELECTRIC DELIVERY', 1, N'TXU_HOUSTON')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'44NORTH', 44, N'ERCOT', N'NORTH', N'NORTH', N'TXU', N'TXU ELECTRIC DELIVERY', 1, N'TXU_NORTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'44SOUTH', 44, N'ERCOT', N'SOUTH', N'SOUTH', N'TXU', N'TXU ELECTRIC DELIVERY', 1, N'TXU_SOUTH')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'44WEST', 44, N'ERCOT', N'WEST', N'WEST', N'TXU', N'TXU ELECTRIC DELIVERY', 1, N'TXU_WEST')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'45UGI', 45, N'PJM', N'UGI', N'UGI', N'UGI', N'UGI (UGI UTILITIES)', 0, N'UGI_UGI')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'46CT', 46, N'NEISO', N'CT', N'CT', N'UI', N'UI (UNITED ILLUMINATING)', 0, N'UI_CT')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'47NEMA', 47, N'NEISO', N'NEMA', N'NEMASS', N'UNITIL', N'UNITIL (FITCHBURG GAS & ELECTRIC CO)', 1, N'UNITIL_NEMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'47WCMA', 47, N'NEISO', N'WCMA', N'WCMASS', N'UNITIL', N'UNITIL (FITCHBURG GAS & ELECTRIC CO)', 1, N'UNITIL_WCMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'48WCMA', 48, N'NEISO', N'WCMA', N'WCMASS', N'WMECO', N'WMECO (WESTERN MASSACHUSETTS CO)', 0, N'WMECO_WCMA')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'49METED', 49, N'PJM', N'METED', N'METED', N'METED', N'METED (METROPOLITAN EDISON COMPANY)', 0, N'METED_METED')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'50PENELEC', 50, N'PJM', N'PENELEC', N'PENELE', N'PENELEC', N'PENELEC (PENNSYLVANIA ELECTRIC COMPANY)', 0, N'PENELEC_PENELEC')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'51ATSI', 51, N'PJM', N'ATSI', N'ATSI', N'PENNPR', N'PENNPR (PENN POWER)', 0, N'PENNPR_ATSI')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'55PECO', 55, N'PJM', N'PECO', N'PECO', N'PECO', N'PECO ENERGY (EXELON)', 0, N'PECO_PECO')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'56APS', 56, N'PJM', N'APS', N'APS', N'WPP', N'WEST PENN POWER (ALLEGHENY)', 0, N'WPP_APS')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'58AEP', 58, N'PJM', N'AEP', N'AEP', N'OHP', N'AEP OHIO POWER', 0, N'OHP_AEP')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'59AEP', 59, N'PJM', N'AEP', N'AEP', N'CSP', N'AEP COLUMBUS SOUTHERN POWER', 0, N'CSP_AEP')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'60DEOK', 60, N'PJM', N'DEOK', N'DEOK', N'DUKE', N'DUKE ENERGY', 0, N'DUKE_DEOK')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'61DAY', 61, N'PJM', N'DAY', N'DAY', N'DAYTON', N'DAYTON POWER & LIGHT', 0, N'DAYTON_DAY')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'62ATSI', 62, N'PJM', N'ATSI', N'ATSI', N'CEI', N'CLEVELAND ILLUMINATING', 0, N'CEI_ATSI')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'63ATSI', 63, N'PJM', N'ATSI', N'ATSI', N'TOLED', N'TOLEDO EDISON', 0, N'TOLED_ATSI')
INSERT [dbo].[_tmp_UtilIDZone] ([UtilID&EnrollZone], [UtilityID], [ISO], [EnrollmentZone], [ZainetZone], [Util_Code], [Util Full Name], [Overlap?], [F9]) VALUES (N'64ATSI', 64, N'PJM', N'ATSI', N'ATSI', N'OHED', N'OHIO EDISON', 0, N'OHED_ATSI')

GO

UPDATE	[dbo].[_tmp_UtilIDZone]
SET		EnrollmentZone = Util_Code + '-' + EnrollmentZone

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_RiskUtil]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_RiskUtil]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_tmp_RiskUtil](
	[INDEX] [nvarchar](255) NULL,
	[Zainet] [nvarchar](255) NULL,
	[ID] [float] NULL,
	[UtilityCode] [nvarchar](255) NULL,
	[WholeSaleMktID] [nvarchar](255) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'PGE1', N'PGE', 36, N'PGE', N'CAISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SCE1', N'SCE', 41, N'SCE', N'CAISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SDGE1', N'SDGE', 42, N'SDGE', N'CAISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SOUTH1', N'SOUTH', 1, N'AEPCE', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'NORTH1', N'NORTH', 2, N'AEPNO', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WEST1', N'WEST', 2, N'AEPNO', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SOUTH2', N'SOUTH', 3, N'CTPEN', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'HOUST1', N'HOUST', 3, N'CTPEN', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'HOUST2', N'HOUST', 4, N'TXNMP', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WEST2', N'WEST', 4, N'TXNMP', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'NORTH2', N'NORTH', 4, N'TXNMP', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WEST3', N'WEST', 5, N'ONCOR', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SOUTH3', N'SOUTH', 5, N'ONCOR', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'NORTH3', N'NORTH', 5, N'ONCOR', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'NORTH4', N'NORTH', 8, N'TXU-SESCO', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WEST4', N'WEST', 32, N'ONCOR-SESCO', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SOUTH4', N'SOUTH', 32, N'ONCOR-SESCO', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'NORTH5', N'NORTH', 32, N'ONCOR-SESCO', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WEST5', N'WEST', 43, N'SHARYLAND', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'0', NULL, 44, N'TXU', N'ERCOT')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'LPC11', N'LPC1', 11, N'AMEREN', N'MISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ME1', N'ME', 12, N'BANGOR', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'CT1', N'CT', 15, N'CL&P', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ME2', N'ME', 16, N'CMP', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WCMASS1', N'WCMASS', 23, N'MECO', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SEMASS1', N'SEMASS', 23, N'MECO', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'NEMASS1', N'NEMASS', 23, N'MECO', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'RI1', N'RI', 23, N'MECO', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SEMASS2', N'SEMASS', 24, N'NANT', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WCMASS2', N'WCMASS', 25, N'NECO', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'RI2', N'RI', 25, N'NECO', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SEMASS3', N'SEMASS', 27, N'NSTAR-BOS', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'NEMASS2', N'NEMASS', 27, N'NSTAR-BOS', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'NEMASS3', N'NEMASS', 28, N'NSTAR-CAMB', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'SEMASS4', N'SEMASS', 29, N'NSTAR-COMM', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'CT2', N'CT', 46, N'UI', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WCMASS3', N'WCMASS', 47, N'UNITIL', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'WCMASS4', N'WCMASS', 48, N'WMECO', N'NEISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE G1', N'ZONE G', 14, N'CENHUD', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE H1', N'ZONE H', 18, N'CONED', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE I1', N'ZONE I', 18, N'CONED', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE J1', N'ZONE J', 18, N'CONED', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE A1', N'ZONE A', 26, N'NIMO', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE B1', N'ZONE B', 26, N'NIMO', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE C1', N'ZONE C', 26, N'NIMO', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE D1', N'ZONE D', 26, N'NIMO', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE E1', N'ZONE E', 26, N'NIMO', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE F1', N'ZONE F', 26, N'NIMO', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE C2', N'ZONE C', 30, N'NYSEG', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE D2', N'ZONE D', 30, N'NYSEG', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE E2', N'ZONE E', 30, N'NYSEG', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE F2', N'ZONE F', 30, N'NYSEG', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE A2', N'ZONE A', 30, N'NYSEG', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE H2', N'ZONE H', 30, N'NYSEG', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE G2', N'ZONE G', 31, N'O&R', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ZONE B2', N'ZONE B', 39, N'RGE', N'NYISO')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'AECO1', N'AECO', 9, N'ACE', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'APS1', N'APS', 10, N'ALLEGMD', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'BGE1', N'BGE', 13, N'BGE', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'COMED1', N'COMED', 17, N'COMED', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'DPL1', N'DPL', 19, N'DELDE', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'DPL2', N'DPL', 20, N'DELMD', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'DUQ1', N'DUQ', 21, N'DUQ', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'JCPL1', N'JCPL', 22, N'JCP&L', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'RECO1', N'RECO', 33, N'ORNJ', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'PEPCO1', N'PEPCO', 34, N'PEPCO-DC', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'PEPCO2', N'PEPCO', 35, N'PEPCO-MD', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'PPL1', N'PPL', 37, N'PPL', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'PSEG1', N'PSEG', 38, N'PSEG', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'RECO2', N'RECO', 40, N'ROCKLAND', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'UGI1', N'UGI', 45, N'UGI', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'METED1', N'METED', 49, N'METED', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'PENELEC1', N'PENELEC', 50, N'PENELEC', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ATSI1', N'ATSI', 51, N'PENNPR', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'PECO1', N'PECO', 55, N'PECO', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'APS2', N'APS', 56, N'WPP', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'AEP1', N'AEP', 58, N'OHP', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'AEP2', N'AEP', 59, N'CSP', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'DEOK1', N'DEOK', 60, N'DUKE', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'DAY1', N'DAY', 61, N'DAYTON', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ATSI2', N'ATSI', 62, N'CEI', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ATSI3', N'ATSI', 63, N'TOLED', N'PJM')
INSERT [dbo].[_tmp_RiskUtil] ([INDEX], [Zainet], [ID], [UtilityCode], [WholeSaleMktID]) VALUES (N'ATSI4', N'ATSI', 64, N'OHED', N'PJM')


select	*
from	[_tmp_RiskUtil]


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_RiskCodeMapNoUtility]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_RiskCodeMapNoUtility]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_RiskCodeMapNoUtility]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_RiskCodeMapNoUtility]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_tmp_RiskCodeMapNoUtility](
	[F1] [float] NULL,
	[ISO] [nvarchar](255) NULL,
	[Location_TYPE] [nvarchar](255) NULL,
	[ISO_SETTLEMENT] [nvarchar](255) NULL,
	[ZAINET] [nvarchar](255) NULL,
	[ENROLLMENT_STD] [nvarchar](255) NULL,
	[INTERNAL_CRV] [nvarchar](255) NULL,
	[MATPRICE] [nvarchar](255) NULL,
	[KIODEX] [nvarchar](255) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (1, N'ERCOT', N'LOAD ZONE', N'LZ_NORTH', N'NORTH', N'NORTH', N'LZ_NORTH', N'ERCOT_NZ', N'ERCOT North Zone')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (2, N'ERCOT', N'LOAD ZONE', N'LZ_HOUSTON', N'HOUST', N'HOUSTON', N'LZ_HOUSTON', N'ERCOT_HZ', N'ERCOT Houston Zone')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (3, N'ERCOT', N'LOAD ZONE', N'LZ_SOUTH', N'SOUTH', N'SOUTH', N'LZ_SOUTH', N'ERCOT_SZ', N'ERCOT South Zone')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (4, N'ERCOT', N'LOAD ZONE', N'LZ_WEST', N'WEST', N'WEST', N'LZ_WEST', N'ERCOT_WZ', N'ERCOT West Zone')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (5, N'ERCOT', N'HUB', N'HB_NORTH', N'ENHUB', N'HB_NORTH', N'HB_NORTH', N'ERCOT_ENHUB', N'ERCOT North Hub')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (6, N'ERCOT', N'HUB', N'HB_HOUSTON', N'EHHUB', N'HB_HOUSTON', N'HB_HOUSTON', N'ERCOT_EHHUB', N'ERCOT Houston Hub')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (7, N'ERCOT', N'HUB', N'HB_SOUTH', N'ESHUB', N'HB_SOUTH', N'HB_SOUTH', N'ERCOT_ESHUB', N'ERCOT South Hub')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (8, N'ERCOT', N'HUB', N'HB_WEST', N'EWHUB', N'HB_WEST', N'HB_WEST', N'ERCOT_EWHUB', N'ERCOT West Hub')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (9, N'MISO', N'HUB', N'MICHIGAN.HUB', N'MICHHB', N'MICHIGAN.HUB', N'MICH_HUB', N'MISO_MIHUB', N'MISO MICHIGAN HUB')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (10, N'MISO', N'HUB', N'MINN.HUB', N'MNHB', N'MINN.HUB', N'MIN_HUB', N'MISO_MNHUB', N'MISO MINNESOTA HUB')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (11, N'MISO', N'LOAD ZONE', N'AMIL.LPC1', N'LPC1', N'AMIL.LPC1', N'AMIL.LPC1', N'MISO_AMIL.LPC1', N'MISO CIPS')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (12, N'MISO', N'HUB', N'INDIANA.HUB', N'INDYHB', N'INDIANA.HUB', N'INDY_HUB', N'MISO_INDYHUB', N'INDY HUB')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (13, N'MISO', N'HUB', N'ILLINOIS.HUB', N'ILHUB', N'ILLINOIS.HUB', N'IL_HUB', N'MISO_ILHUB', N'MISO Illinois Hub')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (14, N'MISO', N'LOAD ZONE', N'AMIL.BGS9', N'BGS9', N'AMIL.BGS9', N'AMIL.BGS9', N'MISO_AMIL.BGS9', N'MISO AMIL.BGS9')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (15, N'NEISO', N'LOAD ZONE', N'.Z.MAINE', N'ME', N'ME', N'ME', N'NEPOOL_ME', N'ISO New England ME')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (16, N'NEISO', N'LOAD ZONE', N'.Z.NEWHAMPSHIRE', N'NH', N'NH', N'NH', N'NEPOOL_NH', N'ISO New England NH')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (17, N'NEISO', N'LOAD ZONE', N'.Z.CONNECTICUT', N'CT', N'CT', N'CT', N'NEPOOL_CT', N'ISO New England CT')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (18, N'NEISO', N'LOAD ZONE', N'.Z.RHODEISLAND', N'RI', N'RI', N'RI', N'NEPOOL_RI', N'ISO New England RI')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (19, N'NEISO', N'LOAD ZONE', N'.Z.SEMASS', N'SEMASS', N'SEMA', N'SEMA', N'NEPOOL_SEMASS', N'ISO New England SE Mass')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (20, N'NEISO', N'LOAD ZONE', N'.Z.WCMASS', N'WCMASS', N'WCMA', N'WCMA', N'NEPOOL_WCMASS', N'ISO New England WC Mass')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (21, N'NEISO', N'LOAD ZONE', N'.Z.NEMASSBOST', N'NEMASS', N'NEMA', N'NEMA', N'NEPOOL_NEMASS', N'NEPOOL NEMA')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (22, N'NEISO', N'HUB', N'.H.INTERNAL_HUB', N'MASSHB', N'MASS_HUB', N'MASS_HUB', N'NEPOOL_MASSHB', N'NEPOOL Massachusetts Hub')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (23, N'NEISO', N'LOAD ZONE', N'.Z.VERMONT', N'VT', N'VT', N'VT', N'NEPOOL_VT', N'NEPOOL VT')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (24, N'NYISO', N'LOAD ZONE', N'CAPITL', N'ZONE F', N'F', N'ZONE_F', N'NYISO_F', N'NYISO Zone F')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (25, N'NYISO', N'LOAD ZONE', N'CENTRL', N'ZONE C', N'C', N'ZONE_C', N'NYISO_C', N'NYISO Zone C')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (26, N'NYISO', N'LOAD ZONE', N'DUNWOD', N'ZONE I', N'I', N'ZONE_I', N'NYISO_I', N'NYISO Zone I')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (27, N'NYISO', N'LOAD ZONE', N'GENESE', N'ZONE B', N'B', N'ZONE_B', N'NYISO_B', N'NYISO Zone B')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (28, N'NYISO', N'LOAD ZONE', N'HUD VL', N'ZONE G', N'G', N'ZONE_G', N'NYISO_G', N'NYISO Zone G')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (29, N'NYISO', N'LOAD ZONE', N'LONGIL', N'ZONE K', N'K', N'ZONE_K', N'NYISO_K', N'NYISO Zone K')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (30, N'NYISO', N'LOAD ZONE', N'MHK VL', N'ZONE E', N'E', N'ZONE_E', N'NYISO_E', N'NYISO Zone E')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (31, N'NYISO', N'LOAD ZONE', N'MILLWD', N'ZONE H', N'H', N'ZONE_H', N'NYISO_H', N'NYISO Zone H')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (32, N'NYISO', N'LOAD ZONE', N'J', N'ZONE J', N'J', N'ZONE_J', N'NYISO_J', N'NYISO Zone J')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (33, N'NYISO', N'LOAD ZONE', N'NORTH', N'ZONE D', N'D', N'ZONE_D', N'NYISO_D', N'NYISO Zone D')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (34, N'NYISO', N'LOAD ZONE', N'WEST', N'ZONE A', N'A', N'ZONE_A', N'NYISO_A', N'NYISO Zone A')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (35, N'PJM', N'LOAD ZONE', N'AECO', N'AECO', N'AECO', N'AECO', N'PJM_AECO', N'PJM AECO')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (36, N'PJM', N'LOAD ZONE', N'AEP', N'AEP', N'AEP', N'AEP', N'PJM_AEP', N'PJM AEP')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (37, N'PJM', N'LOAD ZONE', N'APS', N'APS', N'APS', N'APS', N'PJM_APS', N'PJM APS')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (38, N'PJM', N'LOAD ZONE', N'ATSI', N'ATSI', N'ATSI', N'ATSI', N'PJM_ATSI', N'PJM ATSI')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (39, N'PJM', N'LOAD ZONE', N'BGE', N'BGE', N'BGE', N'BGE', N'PJM_BGE', N'PJM BGE')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (40, N'PJM', N'LOAD ZONE', N'COMED', N'COMED', N'COMED', N'COMED', N'PJM_COMED', N'PJM COMED')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (41, N'PJM', N'LOAD ZONE', N'DAY', N'DAY', N'DAY', N'DAY', N'PJM_DAYTON', N'PJM DAYTON')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (42, N'PJM', N'LOAD ZONE', N'DOM', N'DOM', N'DOM', N'DOM', N'PJM_DOM', N'PJM DOM')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (43, N'PJM', N'LOAD ZONE', N'DPL', N'DPL', N'DPL', N'DPL', N'PJM_DPL', N'PJM DPL')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (44, N'PJM', N'LOAD ZONE', N'DUQ', N'DUQ', N'DUQ', N'DUQ', N'PJM_DUQ', N'PJM DUQ')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (45, N'PJM', N'LOAD ZONE', N'JCPL', N'JCPL', N'JCPL', N'JCPL', N'PJM_JCPL', N'PJM JCPL')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (46, N'PJM', N'LOAD ZONE', N'METED', N'METED', N'Meted', N'Meted', N'PJM_METED', N'PJM METED')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (47, N'PJM', N'LOAD ZONE', N'PECO', N'PECO', N'PECO', N'PECO', N'PJM_PECO', N'PJM PECO')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (48, N'PJM', N'LOAD ZONE', N'PENELEC', N'PENELE', N'PENELEC', N'PENELEC', N'PJM_PENELEC', N'PJM PENELEC')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (49, N'PJM', N'LOAD ZONE', N'PEPCO', N'PEPCO', N'PEPCO', N'PEPCO', N'PJM_PEPCO', N'PJM PEPCO')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (50, N'PJM', N'LOAD ZONE', N'PPL', N'PPL', N'PPL', N'PPL', N'PJM_PPL', N'PJM PPL')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (51, N'PJM', N'LOAD ZONE', N'PSEG', N'PSEG', N'PSEG', N'PSEG', N'PJM_PSEG', N'PJM PSEG')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (52, N'PJM', N'LOAD ZONE', N'RECO', N'RECO', N'RECO', N'RECO', N'PJM_RECO', N'PJM RECO')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (53, N'PJM', N'LOAD ZONE', N'UGI', N'UGI', N'UGI', N'UGI', N'PJM_UGI', N'PJM UGI')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (54, N'PJM', N'HUB', N'AEP-DAYTON HUB', N'ADHUB', N'AD_HUB', N'AD_HUB', N'PJM_ADHUB', N'PJM AD Hub')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (55, N'PJM', N'HUB', N'N ILLINOIS HUB', N'NIHUB', N'NI_HUB', N'NI_HUB', N'PJM_NIHUB', N'NI Hub Into')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (56, N'PJM', N'HUB', N'WESTERN HUB', N'WHUB', N'WHUB', N'WHUB', N'PJM_WESTERNHUB', N'PJM Western Hub, PJM West')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (57, N'PJM', N'HUB', N'EASTERN HUB', N'EASTHB', N'EASTHB', N'EASTHB', N'PJM_EASTERNHUB', N'PJM EASTERN HUB')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (58, N'PJM', N'LOAD ZONE', N'DEOK', N'DEOK', N'DEOK', N'DEOK', N'PJM_DEOK', N'PJM DEOK')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (59, N'CAISO', N'HUB', N'TH_NP15_GEN-APND', N'NP-15', N'NP15', N'NP15', N'CAISO_NP15', N'CAISO NP-15')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (60, N'CAISO', N'HUB', N'TH_SP15_GEN-APND', N'SP-15', N'SP15', N'SP15', N'CAISO_SP15', N'CAISO SP-15')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (61, N'CAISO', N'LOAD ZONE', N'DLAP_PGAE-APND', N'PGE', N'PGE', N'PGE', N'CAISO_PGE', N'CAISO PGE')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (62, N'CAISO', N'LOAD ZONE', N'DLAP_SCE-APND', N'SCE', N'SCE', N'SCE', N'CAISO_SCE', N'CAISO SCE')
INSERT [dbo].[_tmp_RiskCodeMapNoUtility] ([F1], [ISO], [Location_TYPE], [ISO_SETTLEMENT], [ZAINET], [ENROLLMENT_STD], [INTERNAL_CRV], [MATPRICE], [KIODEX]) VALUES (63, N'CAISO', N'LOAD ZONE', N'DLAP_SDGE-APND', N'SDGE', N'SDGE', N'SDGE', N'CAISO_SDGE', N'CAISO SDGE')
GO
print 'Processed 63 total records'

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_tmp_RiskCodeMap]') AND type in (N'U'))
	DROP TABLE [dbo].[_tmp_RiskCodeMap]
GO


GO
CREATE TABLE [dbo].[_tmp_RiskCodeMap](
	[F1] int IDENTITY(1,1),
	[Util_Code] [nvarchar](255) NULL,
	[ISO] [nvarchar](255) NULL,
	[Location_TYPE] [nvarchar](255) NULL,
	[ISO_SETTLEMENT] [nvarchar](255) NULL,
	[ZAINET] [nvarchar](255) NULL,
	[ENROLLMENT_STD] [nvarchar](255) NULL,
	[INTERNAL_CRV] [nvarchar](255) NULL,
	[MATPRICE] [nvarchar](255) NULL,
	[KIODEX] [nvarchar](255) NULL
) ON [PRIMARY]
GO

INSERT	INTO [_tmp_RiskCodeMap]
select	u.UtilityCode, t.ISO, t.Location_TYPE, t.ISO_SETTLEMENT, t.ZAINET, u.UtilityCode + '-' + t.ENROLLMENT_STD AS ENROLLMENT_STD, INTERNAL_CRV, MATPRICE, KIODEX
from	[_tmp_RiskCodeMapNoUtility] t
inner	join Utility u
on		t.ISO = u.WholeSaleMktID
order	by t.ISO, u.UtilityCode
