CREATE TABLE public.mytable 
(
    pid  Integer,
    col1  Integer,
    col2  Integer,
    PRIMARY KEY (pid)
);

INSERT INTO mytable VALUES (1,10,20);

CREATE TABLE public.orderinfo
(
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20)
);

CREATE TABLE public.process 
(
    orderid Integer,
    processid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20)
);

CREATE TABLE public.report 
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20),
    PRIMARY KEY (orderid)
);

INSERT INTO report VALUES (1,1,10,20,'abc');
INSERT INTO report VALUES (1,2,11,21,'日本語');
INSERT INTO report VALUES (1,3,12,1000,'ｱｲｳｴｵ');

CREATE TABLE public.report2
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20),
    PRIMARY KEY (orderid)
);
INSERT INTO report2 VALUES (1,1,10,20,'abc');
INSERT INTO report2 VALUES (1,2,11,21,'日本語');
INSERT INTO report2 VALUES (1,3,12,1000,'ｱｲｳｴｵ');

CREATE TABLE public.report3
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20),
    PRIMARY KEY (orderid)
);
INSERT INTO report3 VALUES (1,1,10,20,'abc');
INSERT INTO report3 VALUES (1,2,11,21,'def');
INSERT INTO report3 VALUES (1,3,12,1000,'ABC');

CREATE TABLE public.report4
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

CREATE TABLE public.report5
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

CREATE TABLE public.reportTrigger
(
   seq Integer,
   PRIMARY KEY (seq)
);

CREATE TABLE public.reportTarget
(
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20)
);


CREATE TABLE public.reportResult
(
    logtimestamp TIMESTAMP,
    target VARCHAR(128),
    orderid Integer,
    data1 Integer,
    result Integer
);

CREATE TABLE public.multi1
(
    multi1_id Integer,
    data1 Integer,
    PRIMARY KEY (multi1_id)
);
INSERT INTO multi1 VALUES (1,100);
INSERT INTO multi1 VALUES (2,200);
INSERT INTO multi1 VALUES (3,300);
INSERT INTO multi1 VALUES (4,400);
INSERT INTO multi1 VALUES (5,500);
CREATE TABLE public.multi2
(
    multi2_id Integer,
    data2 VARCHAR(32),
    PRIMARY KEY (multi2_id)
);
INSERT INTO multi2 VALUES (101,'AA');
INSERT INTO multi2 VALUES (102,'BB');
INSERT INTO multi2 VALUES (103,'CCC');
INSERT INTO multi2 VALUES (104,'DD');
INSERT INTO multi2 VALUES (105,'EEE');
CREATE TABLE public.multi3
(
    multi3_id Integer,
    data3 Integer,
    PRIMARY KEY (multi3_id)
);
INSERT INTO multi3 VALUES (1,11);
INSERT INTO multi3 VALUES (2,12);
INSERT INTO multi3 VALUES (3,13);
INSERT INTO multi3 VALUES (4,14);
INSERT INTO multi3 VALUES (5,15);
