-- Part 2.4 update.sql
--
-- Submitted by: Yana Popova, 1705057
-- 

-- DO NOT use these SQL commands in your submission (they will cause an 
-- error on the NMS database server):
-- CREATE SCHEMA 
-- USE 

-- The HOURLY_PAYMENT attribute is added, 
-- and the DAILYSALARY attribute is deleted - we want to keep only
-- the data about the hourly payment.
ALTER TABLE COACH ADD HOURLY_PAYMENT DOUBLE NOT NULL;
UPDATE COACH
SET COACH.HOURLY_PAYMENT = COACH.DAILYSALARY/4;
ALTER TABLE COACH DROP DAILYSALARY; 

-- We do the same for the participants as well.
ALTER TABLE PARTICIPANT ADD HOURLY_PAYMENT DOUBLE NOT NULL;
UPDATE PARTICIPANT
SET PARTICIPANT.HOURLY_PAYMENT = PARTICIPANT.DAILYSALARY/4;
ALTER TABLE PARTICIPANT DROP DAILYSALARY; 

-- We add attributes for the arrival time and the departure time.
-- I interpret attendance table as COACHINSHOW and CONTENDERINSHOW
ALTER TABLE COACHINSHOW ADD ARRIVAL_TIME TIME;
ALTER TABLE COACHINSHOW ADD DEPARTURE_TIME TIME;

-- We add attributes for the arrival time and the departure time.
ALTER TABLE CONTENDERINSHOW ADD ARRIVAL_TIME TIME;
ALTER TABLE CONTENDERINSHOW ADD DEPARTURE_TIME TIME;

-- We derive the values for arrival_time and departure_time
-- from the values of the start time and the end time of every show.  
UPDATE CONTENDERINSHOW, TVSHOW
SET ARRIVAL_TIME = DATE_ADD(TVSHOW.STARTTIME, INTERVAL -1 HOUR)
WHERE TVSHOW.IDSHOW = CONTENDERINSHOW.IDSHOW;

UPDATE CONTENDERINSHOW, TVSHOW
SET DEPARTURE_TIME = DATE_ADD(TVSHOW.ENDTIME, INTERVAL 1 HOUR) 
WHERE CONTENDERINSHOW.IDSHOW = TVSHOW.IDSHOW;

-- We do the same for coachinshow
UPDATE COACHINSHOW, TVSHOW
SET ARRIVAL_TIME = DATE_ADD(TVSHOW.STARTTIME, INTERVAL -1 HOUR)
WHERE TVSHOW.IDSHOW = COACHINSHOW.IDSHOW;

UPDATE COACHINSHOW, TVSHOW
SET DEPARTURE_TIME = DATE_ADD(TVSHOW.ENDTIME, INTERVAL 1 HOUR) 
WHERE COACHINSHOW.IDSHOW = TVSHOW.IDSHOW;
