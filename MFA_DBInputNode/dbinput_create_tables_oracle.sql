DROP TABLE "DBINPUT_CUSTOMER";
CREATE TABLE "DBINPUT_CUSTOMER" (
		"PKEY" VARCHAR(10) NOT NULL,
		"FIRSTNAME" VARCHAR(20),
		"LASTNAME" VARCHAR(20),
		"CCODE" VARCHAR(10) NOT NULL,
		PRIMARY KEY(PKEY,CCODE) 
	);

DROP TABLE "DBINPUT_EVENTS";
CREATE TABLE "DBINPUT_EVENTS" (
		"EVENT_ID" INTEGER PRIMARY KEY,
		"OBJECT_KEY1" VARCHAR(80) NOT NULL,
		"OBJECT_KEY2" VARCHAR(80) NOT NULL,
		"OBJECT_VERB" VARCHAR(40) NOT NULL
	);

DROP SEQUENCE "DBINPUT_SEQUENCE";	
CREATE SEQUENCE "DBINPUT_SEQUENCE" START WITH 1 INCREMENT BY   1 NOCACHE  NOCYCLE;
 
CREATE OR REPLACE TRIGGER "DBIN_SEQ_TRIG" 
  BEFORE INSERT ON "DBINPUT_EVENTS" 
  FOR EACH ROW 
  BEGIN 
    SELECT DBINPUT_SEQUENCE.nextval INTO :NEW.EVENT_ID FROM dual; 
  END;

CREATE OR REPLACE TRIGGER "DBIN_CUST_EVENT" 
	AFTER INSERT OR DELETE OR UPDATE ON "DBINPUT_CUSTOMER"
	REFERENCING  NEW AS N OLD AS O
	FOR EACH ROW
	BEGIN
		IF inserting THEN
			INSERT INTO DBINPUT_EVENTS(OBJECT_KEY1, OBJECT_KEY2, OBJECT_VERB)
				VALUES(:N.PKEY, :N.CCODE, 'Create');
		END IF;
		IF updating THEN
			INSERT INTO DBINPUT_EVENTS(OBJECT_KEY1, OBJECT_KEY2, OBJECT_VERB)
				VALUES(:N.PKEY, :N.CCODE, 'Update');
		END IF;
	END;
	
	
ALTER TRIGGER "DBIN_SEQ_TRIG" ENABLE;

ALTER TRIGGER "DBIN_CUST_EVENT" ENABLE;
	