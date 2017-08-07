use OnlineEnrollment
go

ALTER TABLE Contact ADD EmailVerificationCode VARCHAR(10) DEFAULT NULL
ALTER TABLE Contact ADD IsEmailVerified BIT DEFAULT 0 NOT NULL
ALTER TABLE Contact ADD EmailVerificationSendDate DATETIME DEFAULT NULL
ALTER TABLE Contact ADD EmailVerifiedDate DATETIME DEFAULT NULL

ALTER TABLE Contract ADD VerificationKey VARCHAR(38) DEFAULT NULL
ALTER TABLE Contract ADD ZipCode VARCHAR(10) DEFAULT NULL