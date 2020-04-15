CREATE USER 'demo' IDENTIFIED BY 'demo';
grant all on demo.* to 'demo';
USE demo;

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
INSERT INTO report VALUES (1,3,12,22,'NoJapanesePreset2');

CREATE TABLE report2
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(80),
    PRIMARY KEY (orderid)
);
INSERT INTO report2 VALUES (1,1,10,10020,'abc');
INSERT INTO report2 VALUES (1,2,11,10021,'NoJapanesePreset');
INSERT INTO report2 VALUES (1,3,12,10022,'NoJapanesePreset2');

CREATE TABLE report3
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(80),
    PRIMARY KEY (orderid)
);

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

