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
INSERT INTO report VALUES (1,3,12,22,'ｱｲｳｴｵ');

CREATE TABLE public.report2
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20),
    PRIMARY KEY (orderid)
);
INSERT INTO report2 VALUES (1,1,10,10020,'abc');
INSERT INTO report2 VALUES (1,2,11,10021,'日本語');
INSERT INTO report2 VALUES (1,3,12,10022,'ｱｲｳｴｵ');

CREATE TABLE public.report3
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
    memo VARCHAR(20),
    PRIMARY KEY (orderid)
);

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

