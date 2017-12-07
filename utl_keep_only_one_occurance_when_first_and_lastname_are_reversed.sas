Keep only one occurance when first and lastname are reversed

Same results from WPS and SAS

related to:
https://goo.gl/nkdaVt
https://communities.sas.com/t5/Base-SAS-Programming/remove-duplicated-pairs-of-variable-values/m-p/419113

s_lassen profile
https://communities.sas.com/t5/user/viewprofilepage/user-id/45151


INPUT
=====

  WORK.HAVE total obs=6            RULES
                                   =====
     FIRST    LAST

     David    John               David    John
     Jane     Doe
     John     David              John     David  * keep just one of these
     Mary     Minor
     Kate     Henry
     Mark     Monroe


PROCESS  (All the code)
=======================

  data want;
    set have;
    array student{2} first last;
    call sortc(of student{*});
  run;quit;

  proc sort data=want nodupkey;
    by first last;
  run;quit;


OUTPUT
======

WORK.WANT total obs=5

  FIRST     LAST

  David    Johns
  Doe      Jane
  Henry    Kate
  Mark     Monroe
  Mary     Minor

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
input first$ last$;
cards4;
David John
Jane Doe
John David
Mary Minor
Kate Henry
Mark Monroe
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

data want;
  set have;
  array student{2};
  call sortc(of student{*});
run;

proc sort data=want nodupkey;
  by student:;
run;


%utl_submit_wps64('
  libname wrk sas7bdat "%sysfunc(pathname(work))";
  data wantpre;
    set wrk.have;
    array student[2] first last;
    call sortc(of student[*]);
  run;quit;

  proc sort data=wantpre out=want nodupkey;
    by first last;
  run;quit;

  proc print data=want;
  run;quit;
');

