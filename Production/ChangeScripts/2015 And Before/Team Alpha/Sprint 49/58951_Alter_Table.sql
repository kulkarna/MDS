-- ============================================================================
-- Author: Bhavana Bakshi
-- Date:   01/29/2014
-- PBI:    58951 Audio length displayed and filtered.
-- Change: Adding a nullable bigint column for AudioLength
-- ============================================================================


use lp_deal_capture 
ALTER TABLE lp_deal_capture..TabletIncompleteContract
ADD AudioLength bigint 


