
USE LibertyPower
GO

DECLARE @agentID int = 0;
DECLARE @partnerID int = 0;
DECLARE @agentName varchar(50) = '';
DECLARE @deviceID varchar(50) = '';
DECLARE @enabled bit = 0;
DECLARE @loginID varchar(50) = '';
DECLARE @password varchar(50) = '';
DECLARE @deviceName varchar(50) = '';

DECLARE @LK_PartnerAgent TABLE
(
	AgentID int,
	PartnerID int,
	AgentName varchar(50),
	DeviceID varchar(50),
	Enabled bit,
	LoginID varchar(50),
	Password varchar(50),
	DeviceName varchar(50)
)

INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(388, 354, 'Inna Krisitskaya - 5849', 'a52b71b4f633bc07', 1, 'inna', 'ik5849', 'Sales185') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(22, 475, 'Nicholas Bounos', '3856bbe975cec75d', 1, 'sales1', 'qwas12', 'Sales1') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(23, 475, 'Rodger Walter', '7d42f544cdd2ca14', 1, 'sales2', 'rw7777', 'Sales2') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(24, 475, 'Greg Resetar', 'dc2c5799b0328dfb', 1, 'sales4', 'maine4546', 'Sales4') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(25, 475, 'Justin Roybal', 'fc583b672bb3cb94', 1, 'sales10', '1sustenance', 'Sales10') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(26, 475, 'Xander Dobreff', 'd8eaf2e89550248f', 1, 'sales7', 'sign55', 'Sales7') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(27, 475, 'Sales12', '6644301953421de4', 1, 'sales12', 'liberty12', 'Sales12') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(29, 475, 'Larry Arant', 'fe0dce6a8407aed7', 1, 'sales9', 'roofbake1', 'Sales9') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(30, 475, 'Sales11', '66f24c7c1132f24b', 1, 'sales11', 'liberty11', 'sales11') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(31, 475, 'Matt Weaver', '92b121c7cb4bc8e0', 1, 'sales8', 'cinnamon1', 'Sales8') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(32, 475, 'Paul Vienne', 'c16dc58e1300efc3', 1, 'sales5', 'ravens', 'Sales5') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(33, 475, 'Ernie Horning', '76f4ea2ebae615cb', 1, 'sales3', 'samlou9799', 'Sales3') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(34, 475, 'James Baker', 'b7a4dbeeb9a63ac3', 1, 'sales6', 'sequoia1', 'Sales6') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(339, 475, 'Ariel', 'e5d48e51d53a2d21', 1, 'ariel', 'liberty', 'Ariel Test') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(424, 475, 'Jaime Forero', 'dsfdsfsdf', 1, 'jforero', 'tablet', 'Internal100') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(623, 475, 'MarieAnn Blake', '406b51167e7569db', 1, 'ablake', 'qwerty1', 'ANN MARIE  BLAKE') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(671, 475, 'Nicholas Bounos', '929a823d8f7b2efa', 1, 'pilot315', 'qwerty1', 'Sales315') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(688, 475, 'Enrique-Test-Only', '76f9219014031f92XXX', 1, 'enrique', 'qwerty1', 'TEST') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(689, 475, 'Latasha Seth', '70c1826ae86016f9', 1, 'lseth', 'qwerty1', 'LATASHA') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(708, 475, 'Dulna Aubourg', '54c1941a25162a11', 1, 'daubourg', 'qwerty1', 'DULNA') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(715, 475, 'Ananta Kamalu', '7f6769d49abfc570', 1, 'akamalu', 'ak3770', 'ANANTA K.') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(758, 475, 'powerpadtest4', '1d2d6034218066c', 1, 'powerpadtest4', 'qwerty1', 'powerpadtest4') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(42, 544, 'Erika', '6c585226d94eb10', 1, 'erika', 'liberty', 'Erika Wifi') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(605, 544, 'textonly- W Taylor', 'c23042ceb6e5c218', 1, 'powerpadtest2', 'qwerty1', 'powerpadtest2') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(99, 545, 'Vincent DeCicco', 'fc8f91294bd9c0a5', 1, 'vincent', 'liberty', 'His Tablet') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(450, 549, 'Nakisha Wong-Chong', 'e2389f38e9380227', 1, 'nakisha', 'liberty', 'Nakisha 4G') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(695, 553, '0012 - Shersha Safi', '2ccf16801568ad2b', 1, 'sales319', 'a319', 'Sales 319') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(696, 553, '0010 - Wahid Safi', '230f7de31f265279', 1, 'sales320', 'b320', 'Sales 320') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(699, 553, '0013 - Juan Joledo', '8d1fdfa2f53b7524', 1, 'sales321', 'c321', 'Sales 321') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(700, 553, '0023 - Lolita Lewis', '4f7fcd43713641fb', 1, 'sales322', 'll322', 'Sales 322') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(701, 553, '0021 - Mohamed Sheik', '49173d52a470c0d9', 1, 'sales323', 'e323', 'Sales 323') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(702, 553, '0017 - Wahdat Safi', '7830fc4f8262f7a0', 1, 'sales324', 'f324', 'Sales 324') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(704, 553, '0014 - Mirel Ibrahimovic', 'c651810a9bb186d0', 1, 'sales325', 'g325', 'Sales 325') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(713, 553, 'Mike Artlip', 'f50e04c96fcca5e6XXX', 1, 'martlip', 'ma123', 'Mike Artlip') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(714, 553, '0022 - Fareed Mohammad', '1f012142b3043c4c', 1, 'sales326', 'fm326', 'Sales 326') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(788, 553, '0028 - Samir Assa', '6d33b784cc125997', 1, 'sales327', 'sa327', 'Sales 327') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(791, 553, '0025 - Levi Owen Fisher', '3456d80294d8b237', 1, 'sales328', 'lf328', 'Sales 328') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(792, 553, '0024 - Taylor Walsh', 'e224b0551787a0f7', 1, 'sales329', 'tw329', 'Sales 329') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(794, 553, '0026 - Jaran Chad Holman', 'ccc89ddce2b60af4', 1, 'sales330', 'jh330', 'Sales 330') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(803, 553, '0027 - Joseph Ploeckelman', '9c3d06ba5f1bff6f', 1, 'sales331', 'jp331', 'Sales 331') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(733, 554, '1000 - George Western', 'd125f658668964dd', 1, 'sales200', 'gw200', 'Sales 200') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(736, 554, '2004 - Marquette Taylor', '127583e932c40024', 1, 'sales201', 'mt201', 'Sales 201') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(740, 554, '2002 - Maya Jones', 'caa5a4deaa9b96d5', 1, 'sales202', 'mj202', 'Sales 202') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(741, 554, '2005 - Gregory Edwards', '95e6d158c374a14', 1, 'sales203', 'ge203', 'Sales 203') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(742, 554, '2006 - Katrina Sherman', 'd5a97116785b6c9a', 1, 'sales204', 'ks204', 'Sales 204') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(759, 554, 'Enrique-Test-Only', '76f9219014031f92', 1, 'enrique', 'qwerty1', 'TEST') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(778, 554, '1001 - Alfred Carney', '52de1ceca40d70f8', 1, 'sales205', 'ac205', 'Sales 205') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(779, 554, '1002 - Jassy Perez Rivera', 'aa17b3cc521f03a9', 1, 'sales206', 'jp206', 'Sales 206') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(780, 554, '1003 - Hector Melendez', 'd84ea510506eabf', 1, 'sales207', 'hm207', 'Sales 207') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(760, 556, '1000 - Norman Starks', '10db97ce659b3646', 1, 'sales400', 'ns400', 'Sales 400') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(762, 556, '1001 - Andromeda Deshazor', '6d5183905807343b', 1, 'sales401', 'ad401', 'Sales 401') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(763, 556, '1002 - Allen Francois', '4f4df07d21cf787d', 1, 'sales402', 'af402', 'Sales 402') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(765, 556, '1003 - Anthony Leon', 'eb2002efcb7f72b9', 1, 'sales403', 'al403', 'Sales 403') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(766, 556, '1004 - Linetta Lowery', '75f51054518d0d97', 1, 'sales404', 'll404', 'Sales 404') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(768, 556, '1005 - Maxon Beaubeouf', '817b804e597d883c', 1, 'sales405', 'mb405', 'Sales 405') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(772, 556, '1006 - Katherine Shank', '40e57049c090a08d', 1, 'sales406', 'ks406', 'Sales 406') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(773, 556, '1007 - Lafucia King', 'c5d9ce9e8f807489', 1, 'sales407', 'lk407', 'Sales 407') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(775, 556, '1008 - James Green', '7b613f533b199632', 1, 'sales408', 'jg408', 'Sales 408') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(776, 556, 'Erika Hills', 'f50e04c96fcca5e6', 1, 'erika', 'eh7466', 'ERIKA') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(777, 556, 'Julie Lawrence', '608ef4c214aa4aef', 1, 'jlawrence', 'liberty1', 'JULIE') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(783, 556, 'testonly - W Taylor', '821b0b4e75d09e45', 1, 'powerpadtest', 'qwerty1', 'powerpadtest') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(784, 556, '1009 - Brian Wacker', '2f03b6fbf37d3d8b', 1, 'sales409', 'bw409', 'Sales 409') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(786, 556, '1010 - Jeremy Walker', 'd8128b6fb39af821', 1, 'sales410', 'jw410', 'Sales 410') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(787, 556, '1011 - Vincent Walker', 'bf9efc5dc6b89963', 1, 'sales411', 'vw411', 'Sales 411') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(804, 558, '6100 - Erica P Smith', '1660f22482e347ae', 1, 'sales600', 'es600', 'Sales 600') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(805, 558, '6101 - Keitth Cox', '27f2bfc2e2f35a21', 1, 'sales601', 'kc601', 'Sales 601') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(806, 558, '6106 - Darrell Gregg', '766d18786f4aab83', 1, 'sales602', 'dg602', 'Sales 602') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(807, 558, '6103 - Terika L Thomas', 'b0bce850238973fd', 1, 'sales603', 'tt603', 'Sales 603') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(809, 558, '6104 - Tiara Spates', 'be47734e4e303ac', 1, 'sales604', 'ts604', 'Sales 604') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(813, 558, '6105 - Grant Bourdeaux', '9062c9052ebf9179', 1, 'sales605', 'gb605', 'Sales 605') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(832, 559, '20021 - Jonathan Gonzalez', '17c492bfca1f79db', 1, 'sales800', 'jg800', 'Sales 800') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(833, 559, '20012 - Lorraine Hudson', 'd8181f612501d3be', 1, 'sales801', 'lh801', 'Sales 801') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(835, 559, '20006 - James Sumler', 'ed5e7a74e6240507', 1, 'sales802', 'js802', 'Sales 802') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(839, 559, '20004 - Loris Young', '7b39dc84c34c8604', 1, 'sales803', 'ly803', 'Sales 803') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(840, 559, '20005 - Colavito McGhee', 'b7bcb09b0de61fdc', 1, 'sales804', 'cm804', 'Sales 804') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(841, 559, '20008 - Dwayne Crout', 'f8e186453e900e46', 1, 'sales805', 'dc805', 'Sales 805') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(878, 559, '20005 - Colavito McGhee', '5e53adba7b606051', 1, 'sales808', 'cm808', 'Sales 808') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(879, 559, '20009 - Premtim Ferati', '9b5b0b277267cf40', 1, 'sales809', 'pf809', 'Sales 809') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(881, 559, '20024 - Martin Howard Paez', '36712c5bd367f72', 1, 'sales812', 'mh812', 'Sales 812') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(897, 559, '20010 - Jaunius Geleziunas', '1c712ba12b0140a2', 1, 'sales806', 'jg806', 'Sales 806') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(903, 559, '20025 - Greg Vangjel', '781821e2b8a67407', 1, 'sales813', 'gv813', 'Sales 813') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(914, 559, '20026 - Marisha James', '1c51573bdb286693', 1, 'sales811', 'mj811', 'Sales 811') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(842, 560, 'OER-0039 - John Phillips', 'c2e419c4010ea9c9', 1, 'sales700', 'jp700', 'Sales 700') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(843, 560, 'Test - Regan Phillips', '1055f28d0c548116', 1, 'sales701', 'rp701', 'Sales 701') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(844, 560, 'OER-0041 - Lyndon Loschen', '5671f6a7c9f9417c', 1, 'sales703', 'll703', 'Sales 703') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(845, 560, 'OER-0042 - Keith Walton', '6fc98ffe2858bc45', 1, 'sales704', 'kw704', 'Sales 704') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(846, 560, 'OER-0007 - Ryan Anthony', 'dbe2a55d3d5efb79', 1, 'sales705', 'ra705', 'Sales 705') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(847, 560, 'OER-0045 -  Hani Ashkar', '99e2fc940b787a84', 1, 'sales706', 'ha706', 'Sales 706') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(849, 560, 'OER-0007 - Ryan Anthony', '26bccfbee29daac8', 1, 'sales707', 'ra707', 'Sales 707') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(851, 560, 'OER-0005 - Ryan Jeffries', '4ad65e222225f570', 1, 'sales708', 'rj708', 'Sales 708') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(852, 560, 'OER-0038 - Chris Boone', '8db9abd6ab456d90', 1, 'sales709', 'cb709', 'Sales 709') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(96, 561, 'Douglas Marino', '75c68df3bfaee83c', 1, 'douglas', 'tablet', 'IT Test') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(814, 561, '1110 - Nicholas Pierce', '4027304ba999cb64', 1, 'sales500', 'np500', 'Sales 500') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(815, 561, '1111 - John Joe', '11187441ce45e39b', 1, 'sales501', 'jj501', 'Sales 501') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(816, 561, '1112 - Nikosi Barber', '966bd454dfb044ab', 1, 'sales502', 'nb502', 'Sales 502') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(817, 561, '1113 - Marcus McBeth', 'd8f41f7f096415c', 1, 'sales503', 'mm503', 'Sales 503') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(818, 561, '1114 - Porsche Mosley', '76be71bd428a0f5a', 1, 'sales504', 'pm504', 'Sales 504') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(830, 561, 'Nexus10-Test-Only', 'a5ed41b42f87c2b', 1, 'nexus10', 'qwerty1', 'TEST') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(853, 561, '1210 - Michael Venturini', 'abb9215333bf53cd', 1, 'sales505', 'mv505', 'Sales 505') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(854, 561, '1211 - Ebony Nicholas', 'fa2876e4e8902cd4', 1, 'sales506', 'en506', 'Sales 506') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(856, 561, '1212 - Shamika Shell', '671052ddd4828995', 1, 'sales507', 'ss507', 'Sales 507') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(857, 561, '1213 - Yessika Giron', '36a7b810c78dc3cc', 1, 'sales508', 'yg508', 'Sales 508') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(860, 561, '1214 - Veronica Terry', 'fd6835947e924c01', 1, 'sales509', 'vt509', 'Sales 509') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(861, 561, '1215 - James Street', '70383b2621fc57cd', 1, 'sales510', 'js510', 'Sales 510') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(863, 561, '1216 - Jessica Knowlin', '8648f18ac103d37e', 1, 'sales511', 'jk511', 'Sales 511') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(864, 561, '1217 - Marlena Wallace', '615aed30a47c213c', 1, 'sales512', 'mw512', 'Sales 512') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(865, 561, '1218 - Marvin Hatcher', 'c218e3a6f63c84e0', 1, 'sales513', 'mh513', 'Sales 513') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(867, 561, 'NYMF15 - Kenneth George Reece', '987cddaddc04cd43', 1, 'sales514', 'kg514', 'Sales 514') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(868, 561, 'NYMF16 - Akinwumi Alo', '70276c3fb5c531ed', 1, 'sales515', 'aa515', 'Sales 515') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(871, 561, 'NYMF17 - Derek Dingle', 'b31ab5b40ab3c76', 1, 'sales516', 'dd516', 'Sales 516') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(872, 561, 'NYMF18 - Desiree Guinto', '7dadc84d13b93366', 1, 'sales517', 'dg517', 'Sales 517') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(873, 561, 'NYMF66 - Ryan Faulk', '7c585438497b7481', 1, 'sales518', 'rf518', 'Sales 518') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(874, 561, 'NYMF67 - Jhonattan Cortez', 'c89c1187c4c50b39', 1, 'sales519', 'jc519', 'Sales 519') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(875, 561, 'NYM21 - Mona Tiu', 'f2d428b46c9f103c', 1, 'sales520', 'mt520', 'Sales 520') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(901, 561, 'testonly - W Taylor', '821b0b4e75d09e45xxxx', 1, 'powerpadtest', 'qwerty1', 'powerpadtest') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(904, 561, 'NYMF66 - Ryan Faulk', 'f2b1d5370c259bad', 1, 'sales521', 'rf521', 'Sales 521') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(905, 561, 'NYMF67 - Jhonattan Cortez', 'b778d7dea1516a92', 1, 'sales522', 'jc522', 'Sales 522') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(906, 561, 'NYMF68 - Miguel Planas-Costas', 'b44abb836f62b4c0', 1, 'sales523', 'mp523', 'Sales 523') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(908, 561, 'NYMF70 - Gillian Engle', '6b55f048fd65d28b', 1, 'sales524', 'ge524', 'Sales 524') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(910, 561, 'NYMF78 - Kurt Locke', '3ac23f3c37450d1a', 1, 'sales525', 'kl525', 'Sales 525') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(911, 561, 'NYMF79 - Leonard Wilson', '4b7b565941529407', 1, 'sales526', 'lw526', 'Sales 526') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(912, 561, 'NYMF35 - Pilar De Jesus', 'f4eed2de8d097022', 1, 'sales527', 'pj527', 'Sales 527') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(913, 561, 'Monique Barrant', 'df361790b26d31a0', 1, 'mbarrant', '1142', 'MONIQUE') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(915, 561, 'NYMF68 - Miguel Planas-Costas', '89fc7b2ebb933265', 1, 'sales528', 'mc528', 'Sales 528') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(917, 561, 'NYMF70 - Gillian Engle', 'ada13a061f95bec1', 1, 'sales529', 'ge529', 'Sales 529') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(918, 561, 'NYMF78 - Kurt Locke', '7fa56e7ad7122f7d', 1, 'sales530', 'kl530', 'Sales 530') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(919, 561, 'NYMF79 - Leonard Wilson', '60a9574588ba1f19', 1, 'sales531', 'lw531', 'Sales 531') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(882, 562, '10000 - Dion Strong', 'c9cef8e805a13cb', 1, 'sales900', 'ds900', 'Sales 900') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(883, 562, '10001 - Alethea Toney', 'a7c222c4d0720413', 1, 'sales901', 'at901', 'Sales 901') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(884, 562, '10002 - Deshawn Strong', '84b5e9a06ef76504', 1, 'sales902', 'ds902', 'Sales 902') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(885, 562, '10003 - Karen Smothers', '24b77edc499de4d5', 1, 'sales903', 'ks903', 'Sales 903') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(886, 562, '10004 - Avion Strong', 'ef6751fd2802242c', 1, 'sales904', 'as904', 'Sales 904') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(887, 562, '10005 - Tony Johnson', 'f7e9c763adc47499', 1, 'sales905', 'tj905', 'Sales 905') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(888, 562, '10006 - Marisha James', 'e85265e09b442909', 1, 'sales906', 'mj906', 'Sales 906') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(889, 562, '10007 - Clarence Davis', 'd874b43f8ff650a1', 1, 'sales907', 'cd907', 'Sales 907') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(890, 562, '10008 - Nakiya Johnson', 'fbc9f39808adfa7f', 1, 'sales908', 'nj908', 'Sales 908') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(891, 562, '10009 - Simmieon Mcgruder', '38711a8285420deb', 1, 'sales909', 'sm909', 'Sales 909') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(896, 562, '10010 - Rashidi Djumbe', '9406079d5a5e8e81', 1, 'sales910', 'rd910', 'Sales 910') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(898, 562, '10014 - Sharon Lawrence', 'f92897e48b493bfa', 1, 'sales914', 'sl914', 'Sales 914') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(902, 562, '10012 - Torrence Perry', '6a74eb8dff04d3ca', 1, 'sales913', 'tp913', 'Sales 913') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(831, 567, 'GalaxyNote-TEST-Only', '34bb5ba76bf21875', 1, 'jforero', 'qwerty1', 'TEST') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(920, 567, 'Markus Geiger', 'ab427fa1afd09b9', 1, 'mgeiger', 'access123', 'Sales317') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(921, 567, 'Kevin Moore', 'edcdf531b2b868e7', 1, 'kmoore', 'qwerty1', 'TEST921') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(922, 567, 'Fernando Alves', '8b11593b6ac8a4d1', 1, 'falves', 'Orange123', 'TEST293') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(923, 567, 'Jill Steixner', '9cb13dae41b77474', 1, 'jill', 'qwerty1', 'TEST294') 
INSERT INTO @LK_PartnerAgent ([AgentID], [PartnerID],[AgentName],[DeviceID],[Enabled],[LoginID],[Password],[DeviceName])VALUES(924, 567, 'Travis InSales', 'a947ec5f85cb5d94', 1, 'Travis', '1982', 'TEST295') 

DECLARE agentList CURSOR FAST_FORWARD FOR 
	SELECT TOP 1000 
		   [AgentID]
		  ,[PartnerID]
		  ,[AgentName]
		  ,[DeviceID]
		  ,[Enabled]
		  ,[LoginID]
		  ,[Password]
		  ,[DeviceName]
	  FROM @LK_PartnerAgent
	  WHERE [Enabled] = 1
	  ORDER BY PartnerID, AgentID;
  
DECLARE @firstName varchar(50) = '';
DECLARE @lastName varchar(50) = '';
DECLARE @userID int = 0;
DECLARE @sysUserID int = 0;
DECLARe @curPos int = 0;
DECLARE @entityID int = 0;



BEGIN
	
	SELECT @sysUserID = [UserID] FROM LibertyPower..[User] with (Nolock) WHERE LOWER(SYSTEM_USER) = [UserName];
	
	OPEN agentList;
	
	FETCH NEXT FROM agentList INTO @agentID, @partnerID, @agentName, @deviceID, @enabled, @loginID, @password, @deviceName;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		-- Deal with LibertyPower User tables. SELECT the @user if it exists, else insert it and set the @userID to @@Identity
		if(EXISTS(SELECT * FROM LibertyPower..[User]  with (Nolock) WHERE [UserName] = 'libertypower\' + LOWER(@loginID) ))
		BEGIN
			PRINT 'libertypower\' + LOWER(@loginID) +  ': User already exist';
			
			SELECT TOP 1 @userID = [UserID] FROM LibertyPower..[User]  with (Nolock) WHERE [UserName] = 'libertypower\' + LOWER(@loginID);
		END
		ELSE
		BEGIN
			PRINT 'libertypower\' + LOWER(@loginID) + ': User does not exist. Creating...';
			
			INSERT INTO LibertyPower..[User] 
			([UserName], [Password], [Firstname], [Lastname], [Email], [DateCreated], [DateModified], [CreatedBy], [ModifiedBy], [UserType], [isActive], [UserGUID])
			--OUTPUT inserted.* INTO @userTable
			VALUES
			('libertypower\' + LOWER(@loginID), @password, @agentName, '', '', GETDATE(), GETDATE(), @sysUserID, @sysUserID, 'EXTERNAL', CASE WHEN @enabled = 1 THEN 'Y' ELSE 'N' END, NEWID());
			
			Set @userID = @@identity
			
			PRINT 'libertypower\' + LOWER(@loginID) + ': User created with userID ' + CAST(@userID as nvarchar(30));
		END
		
		--Now deal with the SalesChannelUser. If the sales channel user already exist, continue without doing anything, else create sales channel user and entity
			
		if(Exists(SELECT * FROM LibertyPower..SalesChannelUser  with (Nolock) WHERE UserID = @userID))
		BEGIN
			FETCH NEXT FROM agentList INTO @agentID, @partnerID, @agentName, @deviceID, @enabled, @loginID, @password, @deviceName;
			
			PRINT 'SalesChannelUser found for libertypower\' + LOWER(@loginID) + '. Moving to next loop...'
			
			CONTINUE		
		END		
		ELSE
		BEGIN		
		
			PRINT 'SalesChannelUser was not found. Creating Entity, EnityIndividual, and SalesChannelUser for libertypower\' + LOWER(@loginID);
			
			INSERT INTO LibertyPower..Entity 
			(
				[EntityType]
			   ,[DateCreated]
			   ,[CreatedBy]
			   ,[ModifiedBy]
			   ,[DateModified]
			   ,[Tag]
			   ,[StartDate]
			)
			VALUES
			(
				  'I'
				, GETDATE()
				, @sysUserID
				, @sysUserID
				, GETDATE()
				, ''
				, NULL
				
			)
			
			Set @entityID = @@IDENTITY
			
			INSERT INTO LibertyPower..EntityIndividual
			(
				[EntityID]
			   ,[Firstname]
			   ,[Lastname]
			   ,[MiddleName]
			   ,[MiddleInitial]
			   ,[Title]
			   ,[SocialSecurityNumber]
			)
			VALUES
			(
				@entityID
				, @agentName
				, @lastName
				, ''
				, ''
				, 'Sales Rep'
				, ''
			)
			
			INSERT INTO [LibertyPower].[dbo].[SalesChannelUser]
				   ([ChannelID]
				   ,[UserID]
				   ,[DateCreated]
				   ,[DateModified]
				   ,[CreatedBy]
				   ,[ModifiedBy]
				   ,[EntityID]
				   ,[ReportsTo])
			 VALUES
				   (@partnerID
				   ,@userID
				   ,GETDATE()
				   ,GETDATE()
				   ,@sysUserID
				   ,@sysUserID
				   ,@entityID
				   ,0)
		END
			
		PRINT 'SalesChannelUser created for libertypower\' + LOWER(@loginID) + 'with ChannelUserID: ' + CAST(@@Identity as nvarchar(30));
		
	   FETCH NEXT FROM agentList INTO @agentID, @partnerID, @agentName, @deviceID, @enabled, @loginID, @password, @deviceName;
	END
	CLOSE agentList   
	DEALLOCATE agentList
END;