DROP TABLE IF EXISTS flattened_nss;

create table flattened_nss as

select 
  "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE",  

    avg(cast(nss."Q1" AS int)) AS "Q1",
    avg(cast(nss."Q2" AS int)) AS "Q2",
    avg(cast(nss."Q3" AS int)) AS "Q3",
    avg(cast(nss."Q4" AS int)) AS "Q4",
    avg(cast(nss."Q5" AS int)) AS "Q5",
    avg(cast(nss."Q6" AS int)) AS "Q6",
    avg(cast(nss."Q7" AS int)) AS "Q7",
    avg(cast(nss."Q8" AS int)) AS "Q8",
    avg(cast(nss."Q9" AS int)) AS "Q9",
    avg(cast(nss."Q10" AS int)) AS "Q10",
    avg(cast(nss."Q11" AS int)) AS "Q11",
    avg(cast(nss."Q12" AS int)) AS "Q12",
    avg(cast(nss."Q13" AS int)) AS "Q13",
    avg(cast(nss."Q14" AS int)) AS "Q14",
    avg(cast(nss."Q15" AS int)) AS "Q15",
    avg(cast(nss."Q16" AS int)) AS "Q16",
    avg(cast(nss."Q17" AS int)) AS "Q17",
    avg(cast(nss."Q18" AS int)) AS "Q18",
    avg(cast(nss."Q19" AS int)) AS "Q19",
    avg(cast(nss."Q20" AS int)) AS "Q20",
    avg(cast(nss."Q21" AS int)) AS "Q21",
avg(cast(nss."Q22" AS int)) AS "Q22"
from nss GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE"
;

DROP TABLE IF EXISTS flattened_degreeclass;

create table flattened_degreeclass as

select 
  "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE",  

    avg(cast(degreeclass."UFIRST" AS int)) AS "DEGREE_FIRST",
    avg(cast(degreeclass."UUPPER" AS int)) AS "DEGREE_UPPER",
    avg(cast(degreeclass."ULOWER" AS int)) AS "DEGREE_LOWER",
    avg(cast(degreeclass."UOTHER" AS int)) AS "DEGREE_OTHER",
    avg(cast(degreeclass."UORDINARY" AS int)) AS "DEGREE_ORDINARY",
    avg(cast(degreeclass."UNA"    AS int)) AS "DEGREE_UNA"

from degreeclass GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE"
;

DROP TABLE IF EXISTS flattened_continuation;

create table flattened_continuation as

select 
  "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE",  

    avg(cast(continuation."UCONT" AS int)) AS "UCONT",
    avg(cast(continuation."UDORMANT" AS int)) AS "UDORMANT",
    avg(cast(continuation."UGAINED" AS int)) AS "UGAINED",
    avg(cast(continuation."ULEFT" AS int)) AS "ULEFT",
    avg(cast(continuation."ULOWER" AS int)) AS "ULOWER"
    
from continuation GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE"
;

DROP TABLE IF EXISTS flattened_jobtype;

create table flattened_jobtype as

select 
  "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE",  

    avg(cast(jobtype."PROFMAN" AS int)) AS "PROFMAN"
    
from jobtype GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE"
;

DROP TABLE IF EXISTS flattened_entry;

create table flattened_entry as

select 
  "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE",  

    avg(cast(entry."ACCESS" AS int)) AS "ACCESS",
    avg(cast(entry."ALEVEL" AS int)) AS "ALEVEL",
    avg(cast(entry."BACC" AS int)) AS "BACC",
    avg(cast(entry."DEGREE" AS int)) AS "DEGREE",
    avg(cast(entry."FOUNDTN" AS int)) AS "FOUNDTN",
    avg(cast(entry."NOQUALS" AS int)) AS "NOQUALS",
    avg(cast(entry."OTHER" AS int)) AS "OTHERQUALS"
    
from entry GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE"
;

DROP TABLE IF EXISTS flattened_sbj;

CREATE TABLE flattened_sbj AS
SELECT cs.*, nss_jacs3.description
FROM SBJ cs
INNER JOIN
    (SELECT "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE", MIN("SBJ") AS minsbj
    FROM sbj
    GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE") groupedcs
ON cs."SBJ" = groupedcs.minsbj 
AND cs."PUBUKPRN" = groupedcs."PUBUKPRN"
AND trim (LEADING '0' FROM cs."KISCOURSEID") = trim (LEADING '0' FROM groupedcs."KISCOURSEID")
AND cs."KISMODE" = groupedcs."KISMODE"

LEFT JOIN
    nss_jacs3
ON
    cs."SBJ" = nss_jacs3.code
;

DROP TABLE IF EXISTS flattened_common;

create table flattened_common as

select 
  "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE",  

    avg(cast(common."COMPOP" AS int)) AS "COMPOP",
    avg(cast(common."COMAGG" AS int)) AS "COMAGG",
    stddev_samp(cast(common."COMPOP" AS int)) AS "SD_COMPOP",
    stddev_samp(cast(common."COMAGG" AS int)) AS "SD_COMAGG"

from common GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE"
;

DROP TABLE IF EXISTS flattened_location;

CREATE TABLE flattened_location AS

SELECT "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE", location."LOCID", "LATITUDE", "LONGITUDE"
FROM courselocation, location
WHERE
courselocation."LOCID" = location."LOCID"
AND
        courselocation."PUBUKPRN" = location."UKPRN"
;

DROP TABLE IF EXISTS flattened_stage;

CREATE TABLE flattened_stage AS
SELECT cs.*
FROM coursestage cs
INNER JOIN
    (SELECT "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE", MAX("STAGE") AS maxstage
    FROM coursestage
    GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE") groupedcs
ON cs."STAGE" = groupedcs.maxstage 
AND cs."PUBUKPRN" = groupedcs."PUBUKPRN"
AND trim (LEADING '0' FROM cs."KISCOURSEID") = trim (LEADING '0' FROM groupedcs."KISCOURSEID")
AND cs."KISMODE" = groupedcs."KISMODE"
;

DROP TABLE IF EXISTS flattened_tariff;

create table flattened_tariff as

select 
  "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE",  

    avg(cast(tariff."TARPOP" AS int)) AS tarpop,
    avg(cast(tariff."TARAGG" AS int)) AS taragg,
    avg(cast(tariff."T1" AS int)) AS T1,
    avg(cast(tariff."T120" AS int)) AS T120,
    avg(cast(tariff."T160" AS int)) AS T160,
    avg(cast(tariff."T200" AS int)) AS T200,
    avg(cast(tariff."T240" AS int)) AS T240,
    avg(cast(tariff."T280" AS int)) AS T280,
    avg(cast(tariff."T320" AS int)) AS T320,
    avg(cast(tariff."T360" AS int)) AS T360,
    avg(cast(tariff."T400" AS int)) AS T400,
    avg(cast(tariff."T440" AS int)) AS T440,
    avg(cast(tariff."T480" AS int)) AS T480,
    avg(cast(tariff."T520" AS int)) AS T520,
    avg(cast(tariff."T560" AS int)) AS T560,
    avg(cast(tariff."T600" AS int)) AS T600,

    stddev_samp(cast(tariff."TARPOP" AS int)) AS sd_tarpop,
    stddev_samp(cast(tariff."TARAGG" AS int)) AS sd_taragg,
    stddev_samp(cast(tariff."T1" AS int)) AS sd_T1,
    stddev_samp(cast(tariff."T120" AS int)) AS sd_T120,
    stddev_samp(cast(tariff."T160" AS int)) AS sd_T160,
    stddev_samp(cast(tariff."T200" AS int)) AS sd_T200,
    stddev_samp(cast(tariff."T240" AS int)) AS sd_T240,
    stddev_samp(cast(tariff."T280" AS int)) AS sd_T280,
    stddev_samp(cast(tariff."T320" AS int)) AS sd_T320,
    stddev_samp(cast(tariff."T360" AS int)) AS sd_T360,
    stddev_samp(cast(tariff."T400" AS int)) AS sd_T400,
    stddev_samp(cast(tariff."T440" AS int)) AS sd_T440,
    stddev_samp(cast(tariff."T480" AS int)) AS sd_T480,
    stddev_samp(cast(tariff."T520" AS int)) AS sd_T520,
    stddev_samp(cast(tariff."T560" AS int)) AS sd_T560,
    stddev_samp(cast(tariff."T600" AS int)) AS sd_T600

from tariff GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE"
;

DROP TABLE IF EXISTS flattened_salary;

create table flattened_salary as

select 
  "PUBUKPRN", trim (LEADING '0' FROM "KISCOURSEID") as "KISCOURSEID", "KISMODE", 
 
    avg(cast(salary."SALPOP" AS int)) as "SALPOP",
    avg(cast(salary."SALAGG" AS int)) as "SALAGG",
    avg(cast(salary."LDLQ" AS int)) as "LDLQ",
    avg(cast(salary."LDMED" AS int)) as "LDMED",
    avg(cast(salary."LDUQ" AS int)) as "LDUQ",
    avg(cast(salary."LQ" AS int)) as "LQ",
    avg(cast(salary."MED" AS int)) as "MED",
    avg(cast(salary."UQ" AS int)) as "UQ",
    avg(cast(salary."INSTLQ" AS int)) as "INSTLQ",
    avg(cast(salary."INSTMED" AS int)) as "INSTMED",
    avg(cast(salary."INSTUQ" AS int)) as "INSTUQ",

    stddev_samp(cast(salary."SALPOP" AS int)) as "sd_SALPOP",
    stddev_samp(cast(salary."SALAGG" AS int)) as "sd_SALAGG",
    stddev_samp(cast(salary."LDLQ" AS int)) as "sd_LDLQ",
    stddev_samp(cast(salary."LDMED" AS int)) as "sd_LDMED",
    stddev_samp(cast(salary."LDUQ" AS int)) as "sd_LDUQ",
    stddev_samp(cast(salary."LQ" AS int)) as "sd_LQ",
    stddev_samp(cast(salary."MED" AS int)) as "sd_MED",
    stddev_samp(cast(salary."UQ" AS int)) as "sd_UQ",
    stddev_samp(cast(salary."INSTLQ" AS int)) as "sd_INSTLQ",
    stddev_samp(cast(salary."INSTMED" AS int)) as "sd_INSTMED",
    stddev_samp(cast(salary."INSTUQ" AS int)) as "sd_INSTUQ",

    round(stddev_samp(cast(salary."SALPOP" AS int))/avg(cast(salary."SALPOP" AS int)),2) as "cv_ SALPOP",
    round(stddev_samp(cast(salary."SALAGG" AS int))/avg(cast(salary."SALAGG" AS int)),2) as "cv_ SALAGG",
    round(stddev_samp(cast(salary."LDLQ" AS int))/avg(cast(salary."LDLQ" AS int)),2) as "cv_LDLQ",
    round(stddev_samp(cast(salary."LDMED" AS int))/avg(cast(salary."LDMED" AS int)),2) as "cv_LDMED",
    round(stddev_samp(cast(salary."LDUQ" AS int))/avg(cast(salary."LDUQ" AS int)),2) as "cv_LDUQ",
    round(stddev_samp(cast(salary."LQ" AS int))/avg(cast(salary."LQ" AS int)),2) as "cv_LQ",
    round(stddev_samp(cast(salary."MED" AS int))/avg(cast(salary."MED" AS int)),2) as "cv_MED",
    round(stddev_samp(cast(salary."UQ" AS int))/avg(cast(salary."UQ" AS int)),2) as "cv_UQ",
    round(stddev_samp(cast(salary."INSTLQ" AS int))/avg(cast(salary."INSTLQ" AS int)),2) as "cv_INSTLQ",
    round(stddev_samp(cast(salary."INSTMED" AS int))/avg(cast(salary."INSTMED" AS int)),2) as "cv_INSTMED",
    round(stddev_samp(cast(salary."INSTUQ" AS int))/avg(cast(salary."INSTUQ" AS int)),2) as "cv_INSTUQ"

from salary GROUP BY "PUBUKPRN", "KISCOURSEID", "KISMODE"
;

        
DROP TABLE IF EXISTS very_flattened_test;

CREATE TABLE very_flattened_test AS

SELECT
    kiscourse."UKPRN",
    kiscourse."PUBUKPRN",
    kisaim."KISAIMCODE",
    kisaim."KISAIMLABEL",
    kiscourse."DISTANCE",
kiscourse."CRSEURL",
    kiscourse."ENGFEE",
    kiscourse."FOUNDATION",
    kiscourse."HONOURS",
    kiscourse."JACS1",
    kiscourse."JACS2",
    kiscourse."JACS3",
    kiscourse."LDCS1",
    kiscourse."LDCS2",
    kiscourse."LDCS3",
trim (LEADING '0' FROM kiscourse."KISCOURSEID") as "KISCOURSEID",
    kiscourse."KISMODE",
    kiscourse."LEVEL",
    kiscourse."NIFEE",
    kiscourse."NUMSTAGE",
    kiscourse."SANDWICH",
    kiscourse."SCOTFEE",
    kiscourse."TITLE",
    kiscourse."WAFEE",
    kiscourse."YEARABROAD",
    kiscourse."AVGCOURSEWORK",
    kiscourse."AVGSCHEDULED",
    kiscourse."AVGWRITTEN",
    flattened_common."COMPOP",
    flattened_common."COMAGG",
    flattened_stage."ASSACT",
    flattened_stage."COURSEWORK",
    flattened_stage."INDEPENDENT",
    flattened_stage."LTACT",
    flattened_stage."PLACEMENT",
    flattened_stage."PRACTICAL",
    flattened_stage."SCHEDULED",
    flattened_stage."STAGE",
    flattened_stage."WRITTEN",
    flattened_salary."SALPOP",
    flattened_salary."SALAGG",
    flattened_salary."LDLQ",
    flattened_salary."LDMED",
    flattened_salary."LDUQ",
    flattened_salary."LQ",
    flattened_salary."MED",
    flattened_salary."UQ",
    flattened_salary."INSTLQ",
    flattened_salary."INSTMED",
    flattened_salary."INSTUQ",
    flattened_tariff."tarpop",
    flattened_tariff."taragg",
    flattened_tariff."t1",
    flattened_tariff."t120",
    flattened_tariff."t160",
    flattened_tariff."t200",
    flattened_tariff."t240",
    flattened_tariff."t280",
    flattened_tariff."t320",
    flattened_tariff."t360",
    flattened_tariff."t400",
    flattened_tariff."t440",
    flattened_tariff."t480",
    flattened_tariff."t520",
    flattened_tariff."t560",
    flattened_tariff."t600",
    
    (
         (
          (cast(flattened_tariff."t1" AS decimal) * 60)
       + (cast(flattened_tariff."t120" AS decimal) * 140)
       + (cast(flattened_tariff."t160" AS decimal) * 180)
       + (cast(flattened_tariff."t200" AS decimal) * 220)
       + (cast(flattened_tariff."t240" AS decimal) * 260)
       + (cast(flattened_tariff."t280" AS decimal) * 300)
       + (cast(flattened_tariff."t320" AS decimal) * 340)
       + (cast(flattened_tariff."t400" AS decimal) * 420)
       + (cast(flattened_tariff."t440" AS decimal) * 460)
       + (cast(flattened_tariff."t480" AS decimal) * 500)
       + (cast(flattened_tariff."t520" AS decimal) * 520)
       + (cast(flattened_tariff."t560" AS decimal) * 580)
       + (cast(flattened_tariff."t600" AS decimal) * 620)
      )
       / 100 
    ) 
AS "AVG_TARIFF",
    
    flattened_sbj."SBJ",
    flattened_sbj."description" as "subjectDescription",
    flattened_entry."ACCESS",
    flattened_entry."ALEVEL",
    flattened_entry."BACC",
    flattened_entry."DEGREE",
    flattened_entry."FOUNDTN",
    flattened_entry."NOQUALS",
    flattened_entry."OTHERQUALS",

    flattened_continuation."UCONT",
    flattened_continuation."UDORMANT",
    flattened_continuation."UGAINED",
    flattened_continuation."ULEFT",
    flattened_continuation."ULOWER",
    flattened_degreeclass."DEGREE_FIRST",
    flattened_degreeclass."DEGREE_UPPER",
    flattened_degreeclass."DEGREE_LOWER",
    flattened_degreeclass."DEGREE_OTHER",
    flattened_degreeclass."DEGREE_ORDINARY",
    flattened_degreeclass."DEGREE_UNA",
    providers.provider_name as "PROVIDER_NAME",
    providers.view_name as "PROVIDER_VIEW_NAME",
flattened_jobtype."PROFMAN",
flattened_nss."Q1",
flattened_nss."Q2",
flattened_nss."Q3",
flattened_nss."Q4",
flattened_nss."Q5",
flattened_nss."Q6",
flattened_nss."Q7",
flattened_nss."Q8",
flattened_nss."Q9",
flattened_nss."Q10",
flattened_nss."Q11",
flattened_nss."Q12",
flattened_nss."Q13",
flattened_nss."Q14",
flattened_nss."Q15",
flattened_nss."Q16",
flattened_nss."Q17",
flattened_nss."Q18",
flattened_nss."Q19",
flattened_nss."Q20",
flattened_nss."Q21",
flattened_nss."Q22"

FROM
    kiscourse
    LEFT JOIN kisaim 
        ON 
kiscourse."KISAIMCODE" = kisaim."KISAIMCODE"
  LEFT JOIN flattened_salary
        ON 
            kiscourse."PUBUKPRN" = flattened_salary."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_salary."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_salary."KISMODE"
   LEFT JOIN flattened_tariff
        ON 
            kiscourse."PUBUKPRN" = flattened_tariff."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_tariff."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_tariff."KISMODE"
   LEFT JOIN flattened_stage
        ON 
            kiscourse."PUBUKPRN" = flattened_stage."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_stage."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_stage."KISMODE"
   LEFT JOIN flattened_common
        ON 
            kiscourse."PUBUKPRN" = flattened_common."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_common."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_common."KISMODE"
   LEFT JOIN flattened_sbj
        ON 
            kiscourse."PUBUKPRN" = flattened_sbj."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_sbj."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_sbj."KISMODE"
   LEFT JOIN flattened_entry
        ON 
            kiscourse."PUBUKPRN" = flattened_entry."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_entry."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_entry."KISMODE"
   LEFT JOIN flattened_jobtype
        ON 
            kiscourse."PUBUKPRN" = flattened_jobtype."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_jobtype."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_jobtype."KISMODE"
   LEFT JOIN flattened_continuation
        ON 
            kiscourse."PUBUKPRN" = flattened_continuation."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_continuation."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_continuation."KISMODE"
   LEFT JOIN flattened_degreeclass
        ON 
            kiscourse."PUBUKPRN" = flattened_degreeclass."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_degreeclass."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_degreeclass."KISMODE"
   LEFT JOIN flattened_nss
        ON 
            kiscourse."PUBUKPRN" = flattened_nss."PUBUKPRN"
        AND
            kiscourse."KISCOURSEID" = flattened_nss."KISCOURSEID"
        AND 
            kiscourse."KISMODE" = flattened_nss."KISMODE"
   LEFT JOIN providers
        ON 
            kiscourse."PUBUKPRN" = providers.ukprn

    WHERE
            kiscourse."KISTYPE"='1'
;
