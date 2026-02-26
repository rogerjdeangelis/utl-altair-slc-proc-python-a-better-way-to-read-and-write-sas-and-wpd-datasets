# utl-altair-slc-proc-python-a-better-way-to-read-and-write-sas-and-wpd-datasets
Altair slc proc python a better way to read and write sas and wpd datasets
    %let pgm=utl-altair-slc-proc-python-a-better-way-to-read-and-write-sas-and-wpd-datasets;

    %stop_submission;

    Altair slc proc python a better way to read and write sas and wpd datasets

    Too long to post on a list, see github
    https://github.com/rogerjdeangelis/utl-altair-slc-proc-python-a-better-way-to-read-and-write-sas-and-wpd-datasets

    I was surprised to find out that the most recent version of python, 3.14,
      CAN convert panda dataframes to sas datasets.

    The latest python, 3.14, CANNOT convert sas datasets to panda dataframes, THIS NOT A SERIOUS PROBLEM because
    we have a very flexible python package that can read sas datasets and create a panda dataframes.
    Only python 3.10 with specific numpy and pandas can both read and write sas datasets?

     CONTENTS
         1 the issue inability to read sas datsets
         2 the solution pyreadstst


    Pyreadstat offers several methods for reading SAS datasets in Python, primarily targeting .sas7bdat
    files (and related formats like sas7bcat for catalogs). It returns a pandas or Polars DataFrame
    plus metadata. [github](https://github.com/Roche/pyreadstat)


     1 Core Reading Functions

       a read_sas7bdat(): Basic single-process read of .sas7bdat files, extracting data, column names,
         labels, and file metadata like encoding. [github](https://github.com/Roche/pyreadstat)

       b read_sas7bcat(): Reads SAS catalog files for value labels/formats (returns empty DataFrame +
         metadata dictionary). [github](https://github.com/Roche/pyreadstat)


     2 Advanced

      Reading Options

       a usecols=[list]: Load only specified columns to reduce memory/speed up
         (case-sensitive). [github](https://github.com/Roche/pyreadstat)

       b row_offset and row_limit:
         Skip rows or limit to a subset for chunked/partial reads.
         [stackoverflow](https://stackoverflow.com/questions/58612304/reading-huge-sas-dataset-in-python)

       c read_file_in_chunks(): Iterator for processing large files in chunks (with chunksize,
         offset, limit); supports multiprocess=True and num_processes for parallel reading.
         [github](https://github.com/Roche/pyreadstat)

       d output_format="pandas" or "polars": Choose
         DataFrame type. [github](https://github.com/Roche/pyreadstat)


     3 Metadata and Special

      Handling

       a Automatically extracts value labels, column labels, missing ranges/values
         (user_missing=True), and datetime conversions. [github](https://github.com/Roche/pyreadstat)

       b catalog_file param: Pair .sas7bdat with .sas7bcat for full label support.
         [github](https://github.com/Roche/pyreadstat)

       c apply_value_formats=True: Applies formats to
         show user-defined missing value labels.
         [ofajardo.github](https://ofajardo.github.io/pyreadstat_documentation/_build/html/index.html)

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
            |_|
    */
    libname workx "d:/wpswrkx"; /*-- put this in your autoexec ---*/

    proc datasets lib=workx kill;
    run;

    %utlfkil(d:/h5/r_inp.h5);
    %utlfkil(d:/h5/r_out.h5);

    options validvarname=upcase;
    data workx.class;
     informat
       NAME $8.
       SEX $1.
       AGE 8.
       HEIGHT 8.
       WEIGHT 8.
       ;
     input NAME SEX AGE HEIGHT WEIGHT;
    cards4;
    Alfred M 14 69 112.5
    Alice F 13 56.5 84
    Barbara F 13 65.3 98
    Carol F 14 62.8 102.5
    Ronald M 15 67 133
    Thomas M 11 57.5 85
    William M 15 66.5 112
    ;;;;
    run;quit;

    /*   _
    / | (_)___ ___ _   _  ___
    | | | / __/ __| | | |/ _ \
    | | | \__ \__ \ |_| |  __/
    |_| |_|___/___/\__,_|\___|

    */
    options set=PYTHONHOME "D:\py314";
    proc python;
    export python=students data=workx.class;
    submit;
    str(students)
    endsubmit;
    run;

    /*
    | | ___   __ _
    | |/ _ \ / _` |
    | | (_) | (_| |
    |_|\___/ \__, |
             |___/
    */

    NOTE: AUTOEXEC processing completed

    1         options set=PYTHONHOME "D:\py314";
    2         proc python;
    3         export python=students data=workx.class;
    NOTE: Creating Python data frame 'students' from data set 'WORKX.class'
    ERROR: Received unknown response [10]
    4         submit;
    5         str(students)
    6         endsubmit;

    NOTE: Submitting statements to Python:

    WARNING: Could not cleanly terminate Python worker: Error writing to pipe : The pipe is being closed.
    

    ERROR: Altair SLC has encountered a problem - please contact Altair Data Analytics Customer Support
    ERROR: Error printed on page 1

    NOTE: Submitted statements took :
          real time : 3.152
          cpu time  : 0.093

    /*___              _       _   _
    |___ \   ___  ___ | |_   _| |_(_) ___  _ __
      __) | / __|/ _ \| | | | | __| |/ _ \| `_ \
     / __/  \__ \ (_) | | |_| | |_| | (_) | | | |
    |_____| |___/\___/|_|\__,_|\__|_|\___/|_| |_|

    */

    options set=PYTHONHOME "D:\py314";
    proc python;
    submit;
    import tables
    import pandas as pd
    import pyreadstat as ps
    students,neta=ps.read_sas7bdat('d:/wpswrkx/class.sas7bdat')
    endsubmit;
    import python=students data=workx.students;
    run;

    proc print data=workx.students;
    run;quit;

    /**************************************************************************************************************************/
    /*  WORKX.STUDENTS total obs=7 26FEB2026:16:29:07                                                                         */
    /*                                                                                                                        */
    /*  Obs     NAME      SEX    AGE    HEIGHT    WEIGHT                                                                      */
    /*                                                                                                                        */
    /*   1     Alfred      M      14     69.0      112.5                                                                      */
    /*   2     Alice       F      13     56.5       84.0                                                                      */
    /*   3     Barbara     F      13     65.3       98.0                                                                      */
    /*   4     Carol       F      14     62.8      102.5                                                                      */
    /*   5     Ronald      M      15     67.0      133.0                                                                      */
    /*   6     Thomas      M      11     57.5       85.0                                                                      */
    /*   7     William     M      15     66.5      112.0                                                                      */
    /**************************************************************************************************************************/

    /*
    | | ___   __ _
    | |/ _ \ / _` |
    | | (_) | (_| |
    |_|\___/ \__, |
             |___/
    */

    NOTE: AUTOEXEC processing completed

    1         options set=PYTHONHOME "D:\py314";
    2         proc python;
    3         submit;
    4         import tables
    5         import pandas as pd
    6         import pyreadstat as ps
    7         students,neta=ps.read_sas7bdat('d:/wpswrkx/class.sas7bdat')
    8         endsubmit;

    NOTE: Submitting statements to Python:


    9         import python=students data=workx.students;
    NOTE: Creating data set 'WORKX.students' from Python data frame 'students'
    NOTE: Data set "WORKX.students" has 7 observation(s) and 5 variable(s)

    10        run;
    NOTE: Procedure python step took :
          real time : 1.014
          cpu time  : 0.031

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
