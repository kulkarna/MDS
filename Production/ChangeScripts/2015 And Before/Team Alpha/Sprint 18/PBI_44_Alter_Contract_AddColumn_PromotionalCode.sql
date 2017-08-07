--USE OnlineEnrollment
--GO
ALTER TABLE Contract ADD PromotionCode VARCHAR(20) DEFAULT NULL
ALTER TABLE Contract ADD PromotionCodeMessage VARCHAR(1000) DEFAULT NULL
