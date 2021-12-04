--zad 1.A.
INSERT INTO USER_SDO_GEOM_METADATA VALUES (
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 0, 100, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 0, 100, 0.01)
    ),
    NULL
);

SELECT * FROM USER_SDO_GEOM_METADATA;

-- zad 1.B.
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000, 8192, 10, 2, 0)
FROM FIGURY
WHERE ROWNUM <= 1;

-- zad 1.C.
CREATE INDEX ksztalt_idx
ON FIGURY(KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

-- zad 1.D
SELECT ID
FROM FIGURY
WHERE
    SDO_FILTER(
        KSZTALT,
        SDO_GEOMETRY(
            2001,
            NULL,
            SDO_POINT_TYPE(3,3, NULL),
            NULL, 
            NULL
        )
    ) = 'TRUE';
-- Odp: Nie odpowiada rzeczywisto�ci.

-- zad 1.E
SELECT ID
FROM FIGURY
WHERE
    SDO_RELATE(
        KSZTALT,
        SDO_GEOMETRY(
            2001,
            NULL,
            SDO_POINT_TYPE(3,3, NULL),
            NULL,
            NULL
        ),
        'mask=ANYINTERACT'
    ) = 'TRUE';
-- Odp: Tak.

-- zad 2.A
SELECT A.CITY_NAME MIASTO, ROUND(SDO_NN_DISTANCE(1), 2) ODL
FROM MAJOR_CITIES A, MAJOR_CITIES B
WHERE SDO_NN(
        A.GEOM,
        B.GEOM,
        'sdo_num_res=10 unit=km',
        1
    ) = 'TRUE'
    AND B.CITY_NAME = 'Warsaw'
    AND A.CITY_NAME <> 'Warsaw';

--zad 2.B
SELECT A.CITY_NAME MIASTO
FROM MAJOR_CITIES A, MAJOR_CITIES B
WHERE SDO_WITHIN_DISTANCE(
        A.GEOM,
        B.GEOM,
        'distance=100 unit=km'
    ) = 'TRUE'
    AND B.CITY_NAME = 'Warsaw'
    AND A.CITY_NAME <> 'Warsaw';

--zad 2.C
SELECT A.CNTRY_NAME KRAJ, B.CITY_NAME MIASTO
FROM COUNTRY_BOUNDARIES A, MAJOR_CITIES B
WHERE
    SDO_RELATE(B.GEOM, A.GEOM, 'mask=INSIDE') = 'TRUE'
    AND A.CNTRY_NAME = 'Slovakia';

--zad 2.D
SELECT A.CNTRY_NAME PANSTWO, ROUND(SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km'), 2) ODL
FROM COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
WHERE
    SDO_RELATE(
        A.GEOM,
        B.GEOM,
        'mask=ANYINTERACT'
    ) != 'TRUE'
    AND B.CNTRY_NAME = 'Poland';

-- zad 3.A
SELECT A.CNTRY_NAME, ROUND(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km'), 2) ODLEGLOSC
FROM COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
WHERE SDO_FILTER(A.GEOM, B.GEOM) = 'TRUE' 
AND B.CNTRY_NAME = 'Poland';

-- zad 3.B
SELECT CNTRY_NAME
FROM COUNTRY_BOUNDARIES
WHERE SDO_GEOM.SDO_AREA(GEOM) = (
    SELECT MAX(SDO_GEOM.SDO_AREA(GEOM))
    FROM COUNTRY_BOUNDARIES);

--zad 3.C
SELECT
    ROUND( SDO_GEOM.SDO_AREA(
            SDO_GEOM.SDO_MBR(
                SDO_GEOM.SDO_UNION(
                    A.GEOM,
                    B.GEOM,
                    0.01
                )
            ), 1,  'unit=SQ_KM' ), 2
    ) SQ_KM
FROM MAJOR_CITIES A, MAJOR_CITIES B
WHERE A.CITY_NAME = 'Warsaw' 
AND B.CITY_NAME = 'Lodz';

--zad 3.D
SELECT
    SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_DIMS() ||
    SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_LRS_DIM() ||
    LPAD(SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_GTYPE(), 2, '0') GTYPE
FROM COUNTRY_BOUNDARIES A, MAJOR_CITIES B
WHERE A.CNTRY_NAME = 'Poland'
AND B.CITY_NAME = 'Prague';

-- zad 3.E 
SELECT B.CITY_NAME, A.CNTRY_NAME
FROM COUNTRY_BOUNDARIES A, MAJOR_CITIES B
WHERE
    A.CNTRY_NAME = B.CNTRY_NAME
    AND SDO_GEOM.SDO_DISTANCE(
        SDO_GEOM.SDO_CENTROID(A.GEOM, 1),
        B.GEOM,
        1) = (
            SELECT
                MIN(SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(A.GEOM, 1), B.GEOM, 1))
            FROM COUNTRY_BOUNDARIES A, MAJOR_CITIES B
            WHERE A.CNTRY_NAME = B.CNTRY_NAME
        );

--zad 3.F
SELECT NAME, ROUND(SUM(DLUGOSC), 2) DLUGOSC
FROM (
    SELECT
        B.NAME,
        SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=KM') DLUGOSC
    FROM COUNTRY_BOUNDARIES A,
        RIVERS B
    WHERE
        SDO_RELATE(
            A.GEOM,
             B.GEOM,
            'mask=ANYINTERACT'
        ) = 'TRUE'
        AND A.CNTRY_NAME = 'Poland')
GROUP BY NAME
ORDER BY DLUGOSC;