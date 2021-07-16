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
INSERT INTO report VALUES (1,2,11,21,'日本語');
INSERT INTO report VALUES (1,3,12,1000,'ｱｲｳｴｵ');

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
INSERT INTO report2 VALUES (1,2,11,21,'日本語');
INSERT INTO report2 VALUES (1,3,12,1000,'ｱｲｳｴｵ');

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

CREATE TABLE logtable1
(
    logtable1_id Integer,
    data1 Integer,
    PRIMARY KEY (logtable1_id)
);
INSERT INTO logtable1 VALUES (1,100);
INSERT INTO logtable1 VALUES (2,200);
INSERT INTO logtable1 VALUES (3,300);
INSERT INTO logtable1 VALUES (4,400);
INSERT INTO logtable1 VALUES (5,500);

CREATE TABLE logtable2
(
    logtable2_id Integer,
    data2 VARCHAR(32),
    PRIMARY KEY (logtable2_id)
);
INSERT INTO logtable2 VALUES (101,'AA');
INSERT INTO logtable2 VALUES (102,'BB');
INSERT INTO logtable2 VALUES (103,'CCC');
INSERT INTO logtable2 VALUES (104,'DD');
INSERT INTO logtable2 VALUES (105,'EEE');