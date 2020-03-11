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
    data2 Integer
);

CREATE TABLE public.process 
(
    orderid Integer,
    processid Integer,
    data1 Integer,
    data2 Integer
);

CREATE TABLE public.report 
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
   PRIMARY KEY (orderid)
);

INSERT INTO report VALUES (1,1,10,20);
INSERT INTO report VALUES (1,2,11,21);
INSERT INTO report VALUES (1,3,12,22);

CREATE TABLE public.reportTrigger
(
   seq Integer,
   PRIMARY KEY (seq)
);

CREATE TABLE public.reportTarget
(
    orderid Integer,
    data1 Integer,
    data2 Integer
);
