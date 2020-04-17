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

