select * from accountpropertyhistory aph (nolock)
where utilityid='coned' and fieldname = 'LBMPZone' and fieldsource ='WebScraping'


update accountpropertyhistory
set fieldname ='Zone'
where utilityid='coned' and fieldname = 'LBMPZone' and fieldsource ='WebScraping'
