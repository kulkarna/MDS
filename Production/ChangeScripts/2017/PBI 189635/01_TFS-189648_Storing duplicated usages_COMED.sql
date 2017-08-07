USE [Workspace]

IF(OBJECT_ID('Workspace..TFS_189365_DuplicatedUsageAccounts')) IS NOT NULL
       DROP TABLE Workspace..TFS_189365_DuplicatedUsageAccounts

SELECT * 
       INTO Workspace..TFS_189365_DuplicatedUsageAccounts
       FROM Libertypower..UsageConsolidated (NOLOCK)
       WHERE AccountNumber IN ('0005146038', '0009112010', '0011013004', '0011126006', '0013068025', '0019057017', '0023142010', '0029039012', '0039152013',
              '0041066013', '0043131031', '0049081012', '0051017022', '0055016049', '0057075000', '0057120108', '0069104007', '0079082009', '0083069005',
              '083121000', '0085129004', '0087161028', '0089146010', '0091068012', '0091106017', '0097000023', '0097035008', '0105012039', '0105013036', '0105025027',
              '0109139013', '0115012014', '0115126022', '0121088015', '0137053028', '0137057053', '0145095003', '0147011023', '0151129001', '0153137001', '0187021012',
              '0187125015', '0189122012', '0193017015', '0197159005', '0208648033', '0211026014', '0211131010', '0211213017', '0213023020', '0219093017', '0223168018',
              '0225089001', '0229160007',
'0237032003',
'0237158002',
'0245016004',
'0253107005',
'0265045001',
'0267112023',
'0267140018',
'0271024018',
'0271049015',
'0273155016',
'0275096010',
'0275140013',
'0283093032',
'0293153009',
'0301008015',
'0303050026',
'0305118012',
'0309149004',
'0311008009',
'0321134007',
'0325091003',
'0327095009',
'0335015006',
'0345064011',
'0345087014',
'0357121012',
'0363030200',
'0363063030',
'0367098011',
'0369011012',
'0375103012',
'0391107010',
'0403012000',
'0403157004',
'0405086008',
'0417070001',
'0419073000',
'0421085001',
'0423009018',
'0439030010',
'0441092011',
'0445138018',
'0447069016',
'0449072002',
'0449108007',
'0457014014',
'0475123016',
'0481130009',
'0485127008',
'0487114009',
'0489120005',
'0493032009',
'0497038007',
'0505122001',
'0505133004',
'0513021013',
'0521004035',
'0525048015',
'0525150010',
'0529038015',
'0533157005',
'0539088018',
'0539122015',
'0541107019',
'0567060002',
'0569049001',
'0571026009',
'0571143005',
'0573089004',
'0575024001',
'0587033001',
'0587057001',
'0589022006',
'0591054018',
'0591153016',
'0597068098',
'0601083005',
'0603004011',
'0603066039',
'0603100036',
'0605015012',
'0611112013',
'0625078015',
'0629071003',
'0635061004',
'0637056010',
'0639169010',
'0643131015',
'0651086001',
'0651154004',
'0653041000',
'0655083006',
'0667030006',
'0667124003',
'0669073063',
'0673130008',
'0685025003',
'0697023019',
'0715134026',
'0723048039',
'0737051008',
'0741040004',
'0743092006',
'0771071017',
'0777031017',
'0779057019',
'0780819052',
'0781078019',
'0783115015',
'0787035018',
'0789029018',
'0793129012',
'0793166015',
'0805080022',
'0811091013',
'0813022052',
'0813074001',
'0819034001',
'0823162009',
'0825116005',
'0825171006',
'0829057007',
'0829114007',
'0837090007',
'0847046011',
'0851054012',
'0863017010',
'0863121019',
'0873123016',
'0881145008',
'0889019014',
'0903114009',
'0919004005',
'0929108010',
'0933086018',
'0935046012',
'0941105013',
'0945039010',
'0947171011',
'0949015016',
'0953063002',
'1033613063',
'1033616000',
'1275418106',
'1278809074',
'1285540035',
'1295206022',
'1452089021',
'2151533070',
'2211098003',
'2284161111',
'2379325070',
'2403038186',
'2461176001',
'2566640008',
'2879330062',
'2888828048',
'2902596063',
'2976022074',
'3051582143',
'3064332068',
'3133645005',
'3159217118',
'3261124013',
'3294685058',
'3377355080',
'3537332114',
'3664143027',
'3716324081',
'3813398036',
'3899525148',
'3966534031',
'3975729039',
'3975752038',
'4000272108',
'4003191084',
'4081068004',
'4132445002',
'4164516012',
'4237062149',
'4410209071',
'4423232093',
'4466039023',
'4487518092',
'4569266024',
'4647068026',
'4647152050',
'4731433000',
'4739581021',
'4821646079',
'4897168057',
'4981209021',
'4983637005',
'5001131107',
'5072079054',
'5317609050',
'5340425019',
'5344748102',
'5390560027',
'5409239019',
'5567324024',
'5799808008',
'5929265104',
'5987244016',
'6064393000',
'6152768044',
'6169645001',
'6353072014',
'6353251024',
'6505328009',
'6521681083',
'6623081047',
'6775483000',
'6807782070',
'6911191043',
'6912651066',
'6956147029',
'7066448009',
'7250200006',
'7264281064',
'7264288063',
'7270342103',
'7501748024',
'7595584158',
'7676196032',
'7751177060',
'7756403038',
'7832828008',
'7920139007',
'7928665004',
'7931631058',
'8031132008',
'8169766061',
'8235720053',
'8264226126',
'8264391066',
'8282257003',
'8331109005',
'8337732008',
'8509228084',
'8522789026',
'8571238016',
'8614347043',
'8622735020',
'8768529057',
'8836823082',
'8840793006',
'9004839042',
'9042685075',
'9090467029',
'9191103008',
'9196558030',
'9207084007',
'9251152092',
'9267179009',
'9359199071',
'9360604001',
'9361735005',
'9373323006',
'9410465029',
'9509281046',
'9525340095',
'9527193003',
'9687263073',
'9700749005',
'9746044038',
'9775301006')