CREATE TABLE public.mytable 
(
    pid  Integer,
    col1  Integer,
    col2  Integer,
    PRIMARY KEY (pid)
);

INSERT INTO mytable VALUES (1,10,20);

CREATE TABLE public.jisseki 
(
    seq Integer,
    orderid Integer,
    data1 Integer,
    data2 Integer,
   PRIMARY KEY (orderid)
);

INSERT INTO jisseki VALUES (1,1,10,20);
INSERT INTO jisseki VALUES (1,2,11,21);
INSERT INTO jisseki VALUES (1,3,12,22);

CREATE TABLE public.jissekiTrigger
(
    seq Integer,
   PRIMARY KEY (seq)
);

INSERT INTO jissekiTrigger VALUES (1);

CREATE TABLE public.jissekiTarget
(
    orderid Integer,
    data1 Integer,
    data2 Integer
);
