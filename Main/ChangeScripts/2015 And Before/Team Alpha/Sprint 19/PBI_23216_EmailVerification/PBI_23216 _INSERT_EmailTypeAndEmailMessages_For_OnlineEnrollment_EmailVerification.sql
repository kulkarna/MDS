USE OnlineEnrollment
go

DELETE FROM Email WHERE EmailTypeID = 7
/***************************************************************************/
SET IDENTITY_INSERT EmailType ON

--Database entry that corresponds with EmailType enum in the code
INSERT EmailType (EmailTypeID, Description) 
select 
7 /*EmailTypeId*/,
'Online Enrollment Email Verfication' 
WHERE NOT EXISTS (SELECT * FROM EmailType WHERE EmailTypeID = 7) 

SET IDENTITY_INSERT EmailType OFF

--Update the inserted record if there are more values 

/****************************************************************/
--Email Message for English
INSERT Email (EmailTypeID,LanguageID,Subject,Message,IsActive)
  VALUES(7,
  1,
  'Liberty Power Online Enrollment Email Verfication',
  'Welcome to Liberty Power Email Verification.  <P> Verification Code: @EmailVerificationCode </P><P>Email Verification Link: <a href="@EmailVerificationLink">@EmailVerificationLink</a> </P>',
   1);

INSERT Email (EmailTypeID,LanguageID,Subject,Message,IsActive)
  VALUES(7,
  2,
  'Liberty Power Online Enrollment Email Verfication',
  'Welcome to Liberty Power Email Verification.  <P> Verification Code: @EmailVerificationCode </P><P>Email Verification Link: <a href="@EmailVerificationLink">@EmailVerificationLink</a> </P> ',
   1);   
--Email Message for Spanish

