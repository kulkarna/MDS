USE [OnlineEnrollment]

begin tran

update Email
set Message=
'Error in Liberty Power Online Enrollment submission: <br/><br/>@Message<br/><br/>List of Accounts: <br/>@Accounts<br/><br/>
<b>Contract Information</b>
<table><tr><td><i>Number:</i></td><td>@ContractNumber</td></tr>
<tr><td><i>Start Date:</i></td><td>@StartDate</td></tr>
<tr><td><i>Signed Date:</i></td><td>@SignedDate</td></tr>
<tr><td><i>Utility:</i></td><td>@Utility</td></tr>
<tr><td><i>Account Type:</i></td><td>@AccountType</td></tr>
<tr><td><i>Product:</i></td><td>@Product</td></tr>
<tr><td><i>Term:</i></td><td>@Term</td></tr>
<tr><td><i>Price Tier:</i></td><td>@PriceTier</td></tr></table><br/>
<b>Customer Information</b>
<table><tr><td><i>Name:</i></td><td>@CustomerName</td></tr>
<tr><td><i>SSN:</i></td><td>@SSN</td></tr>
<tr><td valign="top"><i>Address:</i></td><td>@BillingAddress</td></tr>
<tr><td valign="top"><i>Contact:</i></td><td>@Contact</td></tr></table><br/>
<b>Accounts'' Information</b><br>@AccountDetails<br>'
where EmailID = 3

commit
