--USE OnlineEnrollment
--go

-- This will update the existing records for Customers that did not have the opportunity to Opt In
Update CustomerPreference set OptOutSpecialOffers = 1

ALTER TABLE CustomerPreference DROP CONSTRAINT DF_CustomerPreference_OptOutSpecialOffers
ALTER TABLE CustomerPreference ADD CONSTRAINT DF_CustomerPreference_OptOutSpecialOffers DEFAULT 1 FOR OptOutSpecialOffers;