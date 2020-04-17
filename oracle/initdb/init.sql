CONNECT sys/SYS@//localhost:1521/ORCLPDB1 as sysdba
DROP USER demo CASCADE;
CREATE USER demo IDENTIFIED BY demo DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO demo;
CONNECT demo/demo@//localhost:1521/ORCLPDB1

CREATE TABLE mytable 
(
    pid  Integer,
    col1  Integer,
    col2  Integer,
    PRIMARY KEY (pid)
);

INSERT INTO mytable VALUES (1,10,20);

CREATE TABLE orderinfo
(
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(80)
);

CREATE TABLE process 
(
    orderid Integer,
    processid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(80)
);

CREATE TABLE report 
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(80),
    PRIMARY KEY (orderid)
);

INSERT INTO report VALUES (1,1,10,20,'abc');
INSERT INTO report VALUES (1,2,11,21,'NoJapanesePreset');
INSERT INTO report VALUES (1,3,12,1000,'NoJapanesePreset2');

CREATE TABLE report2
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(80),
    PRIMARY KEY (orderid)
);
INSERT INTO report2 VALUES (1,1,10,20,'abc');
INSERT INTO report2 VALUES (1,2,11,21,'NoJapanesePreset');
INSERT INTO report2 VALUES (1,3,12,1000,'NoJapanesePreset2');

CREATE TABLE report3
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(80),
    PRIMARY KEY (orderid)
);
INSERT INTO report3 VALUES (1,1,10,20,'abc');
INSERT INTO report3 VALUES (1,2,11,21,'def');
INSERT INTO report3 VALUES (1,3,12,1000,'ABC');

CREATE TABLE report4
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20),
    done Boolean,
    PRIMARY KEY (orderid)
);
INSERT INTO report4 VALUES (1,1,10,20,'abc',false);
INSERT INTO report4 VALUES (1,2,11,21,'def',false);
INSERT INTO report4 VALUES (1,3,12,1000,'ABC',false);

CREATE TABLE report5
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20),
    PRIMARY KEY (orderid)
);
INSERT INTO report5 VALUES (1000,1,10,20,'abc');
INSERT INTO report5 VALUES (1001,2,11,21,'def');
INSERT INTO report5 VALUES (1002,3,12,1000,'ABC');

CREATE TABLE reportTrigger
(
   seq Integer,
   PRIMARY KEY (seq)
);

CREATE TABLE reportTarget
(
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(80)
);


CREATE TABLE reportResult
(
    logtimestamp TIMESTAMP,
    target VARCHAR(128),
    orderid Integer,
    data1 Integer,
    result Integer
);

