--zad1A
create table FIGURY(
    ID NUMBER(1) PRIMARY KEY,
    KSZTALT MDSYS.SDO_GEOMETRY
)

--zada1B
insert into figury values(
    1, 
    MDSYS.SDO_GEOMETRY(
        2003, -- w 2 wymiarach - wielokat
        null, -- jaki ukad wspolrzednych - null - kartezjanski
        null, -- 
        SDO_ELEM_INFO_ARRAY(1,1003,4), -- pozycja pierwszej kookrynaty,  typ elementu, interpretacja
        -- 1- pozycja, wielokat zewnwtrzny, kolo
        SDO_ORDINATE_ARRAY(3,5 ,5,3 ,7,5) -- koordynaty poszczegolnych punktow
    )
);
			
insert into figury values(
    2,
    MDSYS.SDO_GEOMETRY(
        2003, 
        NULL, 
        NULL, 
        MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);	
						
insert into figury values(
    3,
    MDSYS.SDO_GEOMETRY(
        2002, -- w 2 wymiarach - ciagla linia
        null,
        null,
        SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1 ,5,2,2),
        SDO_ORDINATE_ARRAY(3,2 ,6,2 ,7,3 ,8,2, 7,1)
    )
);

--zad1C
--ko³o zdefiniowane przez punkty le¿¹ce na prostej,
insert into figury values(
    4, 
    MDSYS.SDO_GEOMETRY(
        2003,
        null,
        null,
        SDO_ELEM_INFO_ARRAY(1,1003,4),
        SDO_ORDINATE_ARRAY(3,5 ,5,5 ,7,5)
    )
);

--zad1D
SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01)
from figury;

--zad1E	
Delete from figury
where SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt,0.01) <> 'TRUE'

--zad1F
COMMIT;









