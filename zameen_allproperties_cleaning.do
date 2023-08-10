** 27th July 2023**
** Konain Niaz **

** Cleaning and Preparing Zameen All Plots Scrape Data **

global dir "C:\Users\konid\OneDrive\Documents\Job Apps"

import delimited "$dir\zameen_allproperties_scrape.csv"


//distance is a str. convert to int. 
encode distance, generate(distanceint)

destring v1, gen(v11)
order v11, after(v1)
drop v1
rename v11 index



// convert distance from string to int
destring distance, gen(distancee)
order distancee, after(distance)
drop distance
rename distancee distance



// chekc for outliers 
sum distance, det

/* 
                          Distance
-------------------------------------------------------------
      Percentiles      Smallest
 1%            5              1
 5%            6              2
10%            6              3       Obs              26,757
25%            8              3       Sum of Wgt.      26,757

50%           12                      Mean           15.53877
                        Largest       Std. Dev.      11.32775
75%           19             51
90%           23             51       Variance       128.3179
95%           50             51       Skewness       2.072524
99%           51             51       Kurtosis       6.889711
*/



drop if missing(title)


drop if missing(location)
// (172 observations deleted)



sum price, det

/*
                            Price
-------------------------------------------------------------
      Percentiles      Smallest
 1%       300000             77
 5%      1890000          15000
10%      2920000          18000       Obs              26,755
25%      5490000          26000       Sum of Wgt.      26,755

50%     1.05e+07                      Mean           2.67e+07
                        Largest       Std. Dev.      1.94e+08
75%     2.60e+07       2.15e+09
90%     4.75e+07       2.25e+09       Variance       3.76e+16
95%     7.50e+07       1.20e+10       Skewness       110.1627
99%     2.39e+08       2.70e+10       Kurtosis       14539.23
*/


drop if price<90000
//(5 observations deleted)


export delimited using "$dir\zameen_allproperties_scrape_clean.csv", replace


drop if distance>100
// (35 observations deleted)


save "$dir\zameen_allproperties_cleaning.dta"


drop if ppsqft>300000
//(1 observation deleted)

graph twoway (lfit ppsqft distance) (scatter ppsqft distance), title(Ppsqft Against Distance)

regress ppsqft distance
/*

      Source |       SS           df       MS      Number of obs   =    26,542
-------------+----------------------------------   F(1, 26540)     =   1525.89
       Model |  2.5857e+11         1  2.5857e+11   Prob > F        =    0.0000
    Residual |  4.4974e+12    26,540   169457541   R-squared       =    0.0544
-------------+----------------------------------   Adj R-squared   =    0.0543
       Total |  4.7560e+12    26,541   179193602   Root MSE        =     13018

------------------------------------------------------------------------------
      ppsqft |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
    distance |  -599.5536    15.3485   -39.06   0.000    -629.6375   -569.4698
       _cons |   17749.77   261.5116    67.87   0.000      17237.2    18262.35
------------------------------------------------------------------------------
*/
// price per sqft goes down by 600 for every km change in distance


// Lets check for outliers in Price var
 sum price, det
/*
                            Price
-------------------------------------------------------------
      Percentiles      Smallest
 1%       300000         100000
 5%      1875000         100000
10%      2900000         110000       Obs              26,542
25%      5400000         150000       Sum of Wgt.      26,542

50%     1.05e+07                      Mean           2.67e+07
                        Largest       Std. Dev.      1.95e+08
75%     2.58e+07       2.15e+09
90%     4.75e+07       2.25e+09       Variance       3.79e+16
95%     7.60e+07       1.20e+10       Skewness       109.7582
99%     2.39e+08       2.70e+10       Kurtosis       14429.63
*/

// drop these two largest ones

drop if price>10000000000
//(2 observations deleted)


graph twoway (lfit price distance) (scatter price distance), title(Price Against Distance)


regress price distance
/*

      Source |       SS           df       MS      Number of obs   =    26,540
-------------+----------------------------------   F(1, 26538)     =   1303.75
       Model |  6.3206e+18         1  6.3206e+18   Prob > F        =    0.0000
    Residual |  1.2866e+20    26,538  4.8480e+15   R-squared       =    0.0468
-------------+----------------------------------   Adj R-squared   =    0.0468
       Total |  1.3498e+20    26,539  5.0860e+15   Root MSE        =    7.0e+07

------------------------------------------------------------------------------
       price |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
    distance |   -2964410   82099.62   -36.11   0.000     -3125330    -2803490
       _cons |   7.33e+07    1398869    52.42   0.000     7.06e+07    7.61e+07
------------------------------------------------------------------------------
*/
// price goes down by 2.9 million for every kilometer going away from kalma chowk



// Now do for area 


graph twoway (lfit area distance) (scatter area distance), title(Area Against Distance)


regress area distance


// export this file dta file for map making in python
export delimited using "$dir\zameen_allproperties_scrape_clean.csv", replace


label var distance "Distance from Kalma Chowk in KM"

// Distance histogram graph
histogram distance, freq normal

graph export "C:\Users\konid\OneDrive\Documents\Job Apps\distanceHistogram.png", as(png) replace
//(file C:\Users\konid\OneDrive\Documents\Job Apps\distanceHistogram.png written in PNG format)


//Summary Stats
sum price, det

/* 
                            Price
-------------------------------------------------------------
      Percentiles      Smallest
 1%       300000         100000
 5%      1860000         100000
10%      2900000         110000       Obs              26,539
25%      5400000         150000       Sum of Wgt.      26,539

50%     1.05e+07                      Mean           2.52e+07
                        Largest       Std. Dev.      7.13e+07
75%     2.58e+07       2.00e+09
90%     4.75e+07       2.04e+09       Variance       5.08e+15
95%     7.60e+07       2.15e+09       Skewness       16.05127
99%     2.38e+08       2.25e+09       Kurtosis       367.1382
*/


sum area, det

/*                          Area sqF
-------------------------------------------------------------
      Percentiles      Smallest
 1%     598.9995       139.9999
 5%     674.9993       148.9999
10%     899.9991       148.9999       Obs              26,539
25%     1124.999       149.9998       Sum of Wgt.      26,539

50%     2249.998                      Mean           4473.985
                        Largest       Std. Dev.      38455.74
75%     4499.996        1079999
90%     4499.996        2267998       Variance       1.48e+09
95%     8999.991        3149997       Skewness       63.43743
99%     35999.96        3599997       Kurtosis       5100.525

*/


sum ppsqft, det
/*
                           Ppsqft
-------------------------------------------------------------
      Percentiles      Smallest
 1%     266.6669       1.183972
 5%     1333.335       19.55557
10%     1888.891       19.55557       Obs              26,539
25%     3377.781       22.22224       Sum of Wgt.      26,539

50%     5333.338                      Mean           8011.357
                        Largest       Std. Dev.       13244.8
75%     8000.008       222222.4
90%     11666.68       222222.4       Variance       1.75e+08
95%      19777.8       266666.9       Skewness       7.601959
99%     68888.95       266666.9       Kurtosis       83.80288
*/


sum distance, det

/*              Distance from Kalma Chowk in KM
-------------------------------------------------------------
      Percentiles      Smallest
 1%            5              0
 5%            9              0
10%           10              0       Obs              26,539
25%           12              0       Sum of Wgt.      26,539

50%           16                      Mean           16.22446
                        Largest       Std. Dev.      5.205296
75%           21             35
90%           23             35       Variance        27.0951
95%           25             41       Skewness       .1223343
99%           26             41       Kurtosis       2.434469
*/


 tab type
 /*
             Type |      Freq.     Percent        Cum.
------------------+-----------------------------------
Agricultural Land |        124        0.47        0.47
  Commercial Plot |      2,127        8.01        8.48
  Industrial Land |         51        0.19        8.67
        Plot File |      1,567        5.90       14.58
        Plot Form |          8        0.03       14.61
 Residential Plot |     22,662       85.39      100.00
------------------+-----------------------------------
            Total |     26,539      100.00
*/



// Creating stats divided up into 3 categories by distance
preserve 

// 0-10 
drop if distance >10
//(23,081 observations deleted)


sum area, det
/*
                          Area sqF
-------------------------------------------------------------
      Percentiles      Smallest
 1%     505.9995       224.9998
 5%     787.9993       298.9997
10%     1012.999       307.9997       Obs               3,458
25%     1799.998       307.9997       Sum of Wgt.       3,458

50%     4499.996                      Mean           6865.012
                        Largest       Std. Dev.      28299.04
75%     4499.996       368999.7
90%     8999.991       431999.6       Variance       8.01e+08
95%     17999.98       719999.3       Skewness       23.62826
99%     67499.94        1079999       Kurtosis       749.5122
*/


sum price, det
/*
                            Price
-------------------------------------------------------------
      Percentiles      Smallest
 1%      1600000         150000
 5%      3000000         200000
10%      4500000         600000       Obs               3,458
25%     1.05e+07         600000       Sum of Wgt.       3,458

50%     2.60e+07                      Mean           5.38e+07
                        Largest       Std. Dev.      1.13e+08
75%     4.75e+07       1.90e+09
90%     1.20e+08       1.90e+09       Variance       1.28e+16
95%     2.00e+08       2.15e+09       Skewness       9.424624
99%     4.80e+08       2.25e+09       Kurtosis        141.453
*/


sum ppsqft, det
/*                           Ppsqft
-------------------------------------------------------------
      Percentiles      Smallest
 1%     347.2226       83.33341
 5%     972.2231       83.33341
10%     1666.668       166.6668       Obs               3,458
25%     4711.116        177.778       Sum of Wgt.       3,458

50%     7777.785                      Mean           12841.14
                        Largest       Std. Dev.      19537.65
75%     11444.46       150000.1
90%     24691.38       161111.3       Variance       3.82e+08
95%     50000.05       194444.6       Skewness       4.104313
99%     105555.7       194444.6       Kurtosis       23.17662
*/



restore, preserve



// 10- 20 km 

drop if distance < 10
//(2,276 observations deleted)


drop if distance > 20
//(6,733 observations deleted)


sum price, det


/*                            Price
-------------------------------------------------------------
      Percentiles      Smallest
 1%       570000         150000
 5%      2300000         150000
10%      3600000         150000       Obs              17,530
25%      6800000         150000       Sum of Wgt.      17,530

50%     1.35e+07                      Mean           2.68e+07
                        Largest       Std. Dev.      7.05e+07
75%     2.90e+07       2.00e+09
90%     5.20e+07       2.00e+09       Variance       4.97e+15
95%     7.65e+07       2.04e+09       Skewness       17.47188
99%     2.00e+08       2.15e+09       Kurtosis        411.488
*/




sum area, det
/*
                          Area sqF
-------------------------------------------------------------
      Percentiles      Smallest
 1%     562.9995       139.9999
 5%     674.9993       148.9999
10%     899.9991       148.9999       Obs              17,530
25%     1124.999       149.9998       Sum of Wgt.      17,530

50%     2249.998                      Mean           4222.189
                        Largest       Std. Dev.      32251.15
75%     4499.996       737999.3
90%     4499.996       737999.3       Variance       1.04e+09
95%     8999.991       769499.3       Skewness       83.60437
99%     25649.97        3599997       Kurtosis        8902.45
*/



sum ppsqft, det
/*                           Ppsqft
-------------------------------------------------------------
      Percentiles      Smallest
 1%     497.7783       19.55557
 5%     1617.779       19.55557
10%     2333.336       79.36516       Obs              17,530
25%     4222.226       97.22231       Sum of Wgt.      17,530

50%     6111.117                      Mean           8515.074
                        Largest       Std. Dev.      13443.55
75%     8444.452       222222.4
90%     11555.57       222222.4       Variance       1.81e+08
95%     19333.35       266666.9       Skewness       8.145347
99%     66666.73       266666.9       Kurtosis        95.4423
*/


restore, preserve


// > 20 

drop if distance < 20
//(18,778 observations deleted)

sum price, det
/*                           Price
-------------------------------------------------------------
      Percentiles      Smallest
 1%       225000         100000
 5%      1050000         100000
10%      2000000         110000       Obs               7,761
25%      3700000         150000       Sum of Wgt.       7,761

50%      6000000                      Mean            9998888
                        Largest       Std. Dev.      3.35e+07
75%     1.00e+07       5.10e+08
90%     1.80e+07       1.17e+09       Variance       1.12e+15
95%     2.82e+07       1.58e+09       Skewness       37.67261
99%     5.75e+07       1.74e+09       Kurtosis       1736.664
*/


sum area, det
/*
                          Area sqF
-------------------------------------------------------------
      Percentiles      Smallest
 1%     598.9995       337.9997
 5%     674.9993       393.9996
10%     787.9993       393.9996       Obs               7,761
25%     1124.999       393.9996       Sum of Wgt.       7,761

50%     1124.999                      Mean           3696.441
                        Largest       Std. Dev.      48542.67
75%     2249.998       742499.3
90%     4499.996       899999.1       Variance       2.36e+09
95%     4499.996        2267998       Skewness       50.44422
99%     17999.98        3149997       Kurtosis       2917.773
*/



sum ppsqft, det
/*                           Ppsqft
-------------------------------------------------------------
      Percentiles      Smallest
 1%     200.0002       1.183972
 5%     994.4454       22.22224
10%     1555.557       83.33341       Obs               7,761
25%     2488.891       97.77787       Sum of Wgt.       7,761

50%     3688.893                      Mean           4849.628
                        Largest       Std. Dev.      5241.907
75%     4977.783       55555.61
90%     8444.452       55555.61       Variance       2.75e+07
95%      12888.9       83333.41       Skewness       4.864554
99%     29722.25       88888.98       Kurtosis       39.81394
*/










