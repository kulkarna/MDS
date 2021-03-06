SET IDENTITY_INSERT libertypower..EmailGroup ON
insert into libertypower..EmailGroup (Description, EmailGroupID)
values ('Natural Gas', 5)
SET IDENTITY_INSERT libertypower..EmailGroup OFF

SET IDENTITY_INSERT libertypower..EmailType ON
insert into libertypower..EmailType (Description, EmailTypeID)
values ('Natural Gas', 9)
SET IDENTITY_INSERT libertypower..EmailType OFF

declare @emailGroupId INT
select @emailGroupId = EmailGroupId
from libertypower..EmailGroup
where [Description] = 'Natural Gas'

SET IDENTITY_INSERT libertypower..EmailDistributionList ON
insert into libertypower..EmailDistributionList (EmailAddress, EmailGroupID, EmailDistributionListID, Created)
values ('greencontract@libertypowercorp.com', @emailGroupId, 2, GETDATE())
SET IDENTITY_INSERT libertypower..EmailDistributionList OFF

declare @emailTypeId INT
select @emailTypeID = EmailTypeId
from libertypower..EmailType
where [Description] = 'Natural Gas'

insert into libertypower..EmailModel(EmailTypeID, LanguageID, Subject, Message, IsActive)
values (@emailTypeId, 1,'Gas @ContractNumber, @CustomerName', '<b>Customer Information:</b><br/><br/><table><tr><td><i>Name:</i></td><td>@Name</td></tr><tr><td><i>Account Type:</i></td><td>@AccountType</td></tr><tr><td><i>Phone:</i></td><td>@Phone</td></tr><tr><td><i>Email:</i></td><td>@Email</td></tr><tr><td><i>Social Security:</i></td><td>@SSN</td></tr><tr><td><i>Birth Date:</i></td><td>@Dob</td></tr><tr><td><i>Address1:</i></td><td>@Address1</td></tr><tr><td><i>Address2:</i></td><td>@Address2</td></tr><tr><td><i>City:</i></td><td>@City</td></tr><tr><td><i>Zip:</i></td><td>@Zip</td></tr><tr><td><i>State:</i></td><td>@State</td></tr></table><br/><br/><b>Contract:<b><br/><br/><table><tr><td><i>Contract Number:</i></td><td>@ContractNumber</td></tr><tr><td><i>Sales Channel:</i></td><td>@SalesChannel</td></tr><tr><td><i>Sales Rep:</i></td><td>@SalesRep</td></tr><tr><td><i>Contract Signed Date:</i></td><td>@SignedDate</td></tr><tr><td><i>Service Requested Date:</i></td><td>@RequestedDate</td></tr><tr><td><i>Product:</i></td><td>@Product</td></tr><tr><td><i>Term:</i></td><td>@Term</td></tr><tr><td><i>Rate:</i></td><td>@Rate</td></tr></table><br/><br/><i>Number of Accounts: </i>@NumberOfAccounts<br/><br/><b>Accounts:<b><br/><br/>@AccountSection<br/>@AccountTableMarker<br/></br><table><tr><td><i>Market:</i></td><td>@Market</td></tr><tr><td><i>Utility:</i></td><td>@Utility</td></tr><tr><td><i>Account Number:</i></td><td>@AccountNumber</td></tr><tr><td><i>Service Address1:</i></td><td>@ServiceAddress1</td></tr><tr><td><i>Service Address2:</i></td><td>@ServiceAddress2</td></tr><tr><td><i>Service City:</i></td><td>@ServiceCity</td></tr><tr><td><i>Service Zip:</i></td><td>@ServiceZip</td></tr><tr><td><i>Service State:</i></td><td>@ServiceState</td></tr><tr><td><i>Billing Address1:</i></td><td>@BillingAddress1</td></tr><tr><td><i>Billing Address2:</i></td><td>@BillingAddress2</td></tr><tr><td><i>Billing City:</i></td><td>@BillingCity</td></tr><tr><td><i>Billing Zip:</i></td><td>@BillingZip</td></tr><tr><td><i>Billing State:</i></td><td>@BillingState</td></tr></table>', 1)
 
insert into libertypower..EmailTypeEmailGroup(EmailGroupID, EmailTypeID)
values (@emailGroupId, @emailTypeId)
