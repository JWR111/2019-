# 2019-國泰大數據競賽
## 競賽目的
#### 預測公司既有客戶在未來三個月內是否會購買重疾險保單
## 資料介紹
#### 總共有132個變數,其中有一個為預測變數y,一個為顧客id,訓練集資料共有100000筆,測試集資料有150000筆
#### 以下連結有該資料的所有變數
[variable](https://github.com/Jiang-Wan-Rong/2019-/blob/master/variable/layout.pdf)
## 資料處理
#### 移除顧客id變數:CUS_ID 
- 剩130個自變數
#### 資料變數分為連續型變數,有序型類別變數,無序型類別變數
- 連續型變數:共有24個

|變數名稱1|變數名稱2|變數名稱3|變數名稱4|
| :----------: | :----------: | :----------: | :----------: |
|APC_1ST_YEARDIF|ANNUAL_PREMIUM_AMT|ANNUAL_INCOME_AMT|BANK_NUMBER_CNT|
|INSD_LAST_YEARDIF_CNT|BMI|TERMINATION_RATE|DIEBENEFIT_AMT|
|DIEACCIDENT_AMT|POLICY_VALUE_AMT|ANNUITY_AMT|EXPIRATION_AMT|
|ACCIDENT_HOSPITAL_REC_AMT|DISEASES_HOSPITAL_REC_AMT|OUTPATIENT_SURGERY_AMT|INPATIENT_SURGERY_AMT|
|PAY_LIMIT_MED_MISC_AMT|FIRST_CANCER_AMT|ILL_ACCELERATION_AMT|ILL_ADDITIONAL_AMT|
|LONG_TERM_CARE_AMT|MONTHLY_CARE_AMT|LIFE_INSD_CNT|L1YR_GROSS_PRE_AMT|

- 有序型類別型變數:共有12個

|變數名稱1|變數名稱2|變數名稱3|變數名稱4|
| :----------: | :----------: | :----------: | :----------: |
|L1YR_A_ISSUE_CNT|L1YR_B_ISSUE_CNT|CHANNEL_A_POL_CNT|CHANNEL_B_POL_CNT|
|APC_CNT|INSD_CNT|AG_CNT|AG_NOW_CNT|
|CLC_CUR_NUM|IM_CNT|TOOL_VISIT_1YEAR_CNT|L1YR_C_CNT|

- 無序型類別型變數:共有94個(不包含預測變數y)
#### 處理缺失值資料
- 以下為連續型變數缺失值比例圖
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/continuous_variable_NA.png)
- 以下為無序類別型變數缺失值比例圖
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/categorical_variable_NA.png)
- 其他有序類別型變數皆無缺失值
- 由以上可知有序型和連續型變數中,L1YR_C_CNT該變數含最高比例的缺失值占88%,因此將進一步探討該變數缺失值造成原因
1. 觀察L1YR_C_CNT變數值發現除了缺失值僅有1.,  6., 12.,  2., 14.,  5., 10.,  3.,  4.,  9., 13.,  8., 11.,  7., 15., 17., 16., 30., 23.,        22., 35., 18., 29., 25., 19., 24., 37., 27., 41., 21., 31., 47., 20.這幾個值,因此考慮缺失值是否可能為0的情況
2. 觀察與L1YR_C_CNT(近一年到 C 通路申辦服務次數)較為相關的變數有LAST_C_DT(近三年是否有到 C 通路申辦服務),因此將分析L1YR_C_CNT為缺失值的資料是否有較高的比例LAST_C_DT為否
3. 由以下圖可以發現L1YR_C_CNT為缺失值的資料是否有較高的比例LAST_C_DT為否,因此推測該變數缺失值可能為0的情況,因此先將該變數用0補缺失值

![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/LAST_C_DT.png)

- 無序類別型變數缺失值則是將其缺失值看成一個類別,之後無序類別型變數轉換為獨熱變數放入模型  

ex: GENDER有"M","F",nan

|GENDER|GENDER_M|GENDER_F|
| :---------: | :----------: | :--------: |
|"M"|1|0|
|"F"|0|1|
|NAN|0|0|

- 其餘連續型變數考慮使用回歸隨機森林模型,每個變數利用已知資料訓練模型,將該變數為缺失的資料當作測試集,變數放沒有缺失值的變數共有247個,對缺失值進行補值

- 由於連續型變數仍有一個變數ANNUAL_PREMIUM_AMT缺失值比例占62%,因此考慮先使用隨機森林模型,並使用交叉驗證的方式,設定cross validation=5,看看有無加此變數的預測結果哪個較好,由結果選擇先不刪除該變數
1. 有加ANNUAL_PREMIUM_AMT變數AUC值預測結果:0.828,0.825,0.848,0.829,0.819(平均值=0.8298)
2. 沒有加ANNUAL_PREMIUM_AMT變數AUC值預測結果:0.832,0.841,0.812,0.835,0.809(平均值=0.8258)
#### 處理離群值資料
- 以下為連續型變數機率密度函數圖形
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/continuous_dis1.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/continuous_dis2.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/continuous_dis3.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/continuous_dis4.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/continuous_dis5.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/continuous_dis6.png)
- 由以上圖可以看出,該資料連續型變數沒有特別的離群直需要處理
- 以下為有序變數條狀圖
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/countplot1.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/countplot2.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/countplot3.png)
- 由以上圖可以看出,該資料有序變數沒有特別的離群直需要處理
#### 連續型變數去除偏態
- 下表為各連續變數使用boxcox轉換的lambda值

|變數 | lambda值|
| :---------: | :------------: |
| APC_1ST_YEARDIF | 0.378482419110952|
|ANNUAL_PREMIUM_AMT|-0.059536819195880844|
|ANNUAL_INCOME_AMT|0.02692525345157817|
|BANK_NUMBER_CNT|-0.18253485858618648|
|INSD_LAST_YEARDIF_CNT|0.41685392292251033|
|BMI|1.1467552023824785|
|TERMINATION_RATE|0.044490680864457954|
|DIEBENEFIT_AMT|0.15988135758261424|
|DIEACCIDENT_AMT|0.19950664410414565|
|POLICY_VALUE_AMT|-1.274765234793289|
|ANNUITY_AMT|-0.42285279303840734|
|EXPIRATION_AMT|-1.0647654687161665|
|ACCIDENT_HOSPITAL_REC_AMT|0.10612761029908345|
|DISEASES_HOSPITAL_REC_AMT|0.08214062345407268|
|OUTPATIENT_SURGERY_AMT|0.038809506285160146|
|INPATIENT_SURGERY_AMT|0.04271070756237458|
|PAY_LIMIT_MED_MISC_AMT|-0.2648965620223151|
|FIRST_CANCER_AMT|-0.06214522132382144|
|ILL_ACCELERATION_AMT|-0.858088715747552|
|ILL_ADDITIONAL_AMT|-1.201443474567141|
|LONG_TERM_CARE_AMT|-2.679534382938886|
|MONTHLY_CARE_AMT|-0.29032936659653924|
|LIFE_INSD_CNT|0.3346882185303625|
|L1YR_GROSS_PRE_AMT|-0.42220082027945505|
- 以下為連續變數使用boxcox轉換後,機率密度函數圖型
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/boxcox1.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/boxcox2.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/boxcox3.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/boxcox4.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/boxcox5.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/boxcox6.png)

- 以下考慮利用xgboost模型預測結果(cv=5)判斷是否將連續變數使用boxcox轉換,由以下結果得知,將連續變數使用boxcox轉換後效果較好
- boxcox轉換前,xgboost模型預測結果平均AUC值:0.834315;轉換後,預測結果平均AUC值:0.834826
- 若模型為樹模型則不需要對變數進行最小最大化
- 若模型為knn,svm,logistic regression之類的模型則可以考慮將變數進行最小最大化,之後依照選擇的模型後,再討論是否將連續型變數進行最小最大化測試
#### 連續型變數離散化
- 可考慮將某些連續型變數離散化,可減少一些outlier的影響,離散化方法須參考boxcox轉換後,連續型變數分布情況,再做判斷,最後選擇採用以下1~11轉換結果
1. BANK_NUMBER_CNT<-20代0,BANK_NUMBER_CNT>=-20代1 
2. TERMINATION_RATE<-2.5代0,TERMINATION_RATE>=-2.5代1 
3. PAY_LIMIT_MED_MISC_AMT<-40代0,PAY_LIMIT_MED_MISC_AMT>=-40代1 
4. MONTHLY_CARE_AMT<-50代0,MONTHLY_CARE_AMT>=-50代1 
5. L1YR_GROSS_PRE_AMT<-200代0,L1YR_GROSS_PRE_AMT>=-200代1  
轉換後xgboost模型預測結果平均AUC值:0.837786
6. DIEBENEFIT_AMT<-5代0,DIEBENEFIT_AMT>=-5代1
7. DIEACCIDENT_AMT<-4.3代0,DIEACCIDENT_AMT>=-4.3代1
8. ACCIDENT_HOSPITAL_REC_AMT<-6代0,ACCIDENT_HOSPITAL_REC_AMT>=-6代1
9. DISEASES_HOSPITAL_REC_AMT<-6代0,DISEASES_HOSPITAL_REC_AMT>=-6代1
10. OUTPATIENT_SURGERY_AMT<-8代0,OUTPATIENT_SURGERY_AMT>=-8代1
11. INPATIENT_SURGERY_AMT<-8代0,INPATIENT_SURGERY_AMT>=-8代1  
轉換後xgboost模型預測結果平均AUC值:0.838266
12. POLICY_VALUE_AMT:依-500000,-1250000,-1750000分成0,1,2,3
13. ANNUITY_AMT:-100,-200,-280分成0,1,2,3
14. EXPIRATION_AMT:-100000,-175000分成0,1,2
15. ILL_ACCELERATION_AMT:-10000,-22000分成0,1,2
16. ILL_ADDITIONAL_AMT:-300000,-700000,-800000分成0,1,2,3
17. LONG_TERM_CARE_AMT:-0.4,-0.9分成0,1,2  
轉換後xgboost模型預測結果平均AUC值:0.836583
#### 類別型變數編碼
- 均值編碼:最後結果將'L1YR_A_ISSUE_CNT', 'L1YR_B_ISSUE_CNT', 'CHANNEL_A_POL_CNT', 'CHANNEL_B_POL_CNT', 'APC_CNT', 'INSD_CNT', 'AG_CNT', 'AG_NOW_CNT','LAST_A_CCONTACT_DT', 'LAST_A_ISSUE_DT', 'LAST_B_ISSUE_DT', 'OCCUPATION_CLASS_CD', 'APC_1ST_AGE', 'INSD_1ST_AGE',
'CLC_CUR_NUM', 'L1YR_C_CNT', 'IM_CNT', 'TOOL_VISIT_1YEAR_CNT','IF_ISSUE_A_IND', 'IF_ISSUE_B_IND', 'IF_ISSUE_C_IND', 'IF_ISSUE_D_IND', 'IF_ISSUE_E_IND', 'IF_ISSUE_F_IND', 'IF_ISSUE_G_IND', 'IF_ISSUE_H_IND', 'IF_ISSUE_I_IND', 'IF_ISSUE_J_IND', 'IF_ISSUE_K_IND', 'IF_ISSUE_L_IND', 'IF_ISSUE_M_IND', 'IF_ISSUE_N_IND', 'IF_ISSUE_O_IND', 'IF_ISSUE_P_IND', 'IF_ISSUE_Q_IND'等35個變數採均值編碼
1. 'L1YR_A_ISSUE_CNT', 'L1YR_B_ISSUE_CNT', 'CHANNEL_A_POL_CNT', 'CHANNEL_B_POL_CNT', 'APC_CNT', 'INSD_CNT', 'AG_CNT', 'AG_NOW_CNT',
'CLC_CUR_NUM', 'L1YR_C_CNT', 'IM_CNT', 'TOOL_VISIT_1YEAR_CNT'等12個變數改採均值編碼表示  
xgboost模型預測結果平均AUC值:0.839016
2. 承1,12個變數均值編碼後,'GENDER','AGE','CHARGE_CITY_CD','CONTACT_CITY_CD','EDUCATION_CD','MARRIAGE_CD'等6個變數也改採均值編碼表示  
xgboost模型預測結果平均AUC值:0.838606
3. 承1,12個變數均值編碼後,'LAST_A_CCONTACT_DT', 'LAST_A_ISSUE_DT', 'LAST_B_ISSUE_DT', 'OCCUPATION_CLASS_CD', 'APC_1ST_AGE', 'INSD_1ST_AGE'等6個變數也改採均值編碼表示  
xgboost模型預測結果平均AUC值:0.843443
4. 承3,18個變數均值編碼後,'IF_2ND_GEN_IND', 'RFM_R', 'REBUY_TIMES_CNT', 'LEVEL', 'RFM_M_LEVEL', 'LIFE_CNT'等6個變數也改採均值編碼表示  
xgboost模型預測結果平均AUC值:0.841817
5. 承3,18個變數均值編碼後,'IF_ISSUE_A_IND', 'IF_ISSUE_B_IND', 'IF_ISSUE_C_IND', 'IF_ISSUE_D_IND', 'IF_ISSUE_E_IND', 'IF_ISSUE_F_IND', 'IF_ISSUE_G_IND', 'IF_ISSUE_H_IND', 'IF_ISSUE_I_IND', 'IF_ISSUE_J_IND', 'IF_ISSUE_K_IND', 'IF_ISSUE_L_IND', 'IF_ISSUE_M_IND', 'IF_ISSUE_N_IND', 'IF_ISSUE_O_IND', 'IF_ISSUE_P_IND', 'IF_ISSUE_Q_IND'等17個變數也改採均值編碼表示
xgboost模型預測結果平均AUC值:0.845530(0.844322)
6. 承5,35個變數均值編碼後,'IF_ADD_F_IND', 'IF_ADD_L_IND', 'IF_ADD_Q_IND', 'IF_ADD_G_IND', 'IF_ADD_R_IND', 'IF_ADD_IND'等6個變數也改採均值編碼表示  
xgboost模型預測結果平均AUC值:0.845459
7. 承5,35個變數均值編碼後'L1YR_PAYMENT_REMINDER_IND', 'L1YR_LAPSE_IND', 'LAST_B_CONTACT_DT', 'A_IND', 'B_IND', 'C_IND'等6個變數也改採均值編碼表示  
xgboost模型預測結果平均AUC值:0.843335
8. 承5,35個變數均值編碼後'LAST_C_DT', 'IF_S_REAL_IND', 'IF_Y_REAL_IND', 'IM_IS_A_IND', 'IM_IS_B_IND', 'IM_IS_C_IND', 'IM_IS_D_IND'等7個變數也改採均值編碼表示  
xgboost模型預測結果平均AUC值:0.843311
9. 承5,35個變數均值編碼後'X_A_IND', 'X_B_IND', 'X_C_IND', 'X_D_IND', 'X_E_IND', 'X_F_IND', 'X_G_IND', 'X_H_IND', 'IF_HOUSEHOLD_CLAIM_IND'等8個變數也改採均值編碼表示 
xgboost模型預測結果平均AUC值:0.845044
10. 承5,35個變數均值編碼後'IF_ISSUE_INSD_A_IND', 'IF_ISSUE_INSD_B_IND', 'IF_ISSUE_INSD_C_IND', 'IF_ISSUE_INSD_D_IND', 'IF_ISSUE_INSD_E_IND', 'IF_ISSUE_INSD_F_IND', 'IF_ISSUE_INSD_G_IND', 'IF_ISSUE_INSD_H_IND', 'IF_ISSUE_INSD_I_IND', 'IF_ISSUE_INSD_J_IND', 'IF_ISSUE_INSD_K_IND', 'IF_ISSUE_INSD_L_IND', 'IF_ISSUE_INSD_M_IND', 'IF_ISSUE_INSD_N_IND', 'IF_ISSUE_INSD_O_IND', 'IF_ISSUE_INSD_P_IND', 'IF_ISSUE_INSD_Q_IND'等17個變數也改採均值編碼表示
xgboost模型預測結果平均AUC值:0.844745
11. 承5,35個變數均值編碼後'IF_ADD_INSD_F_IND', 'IF_ADD_INSD_L_IND', 'IF_ADD_INSD_Q_IND', 'IF_ADD_INSD_G_IND', 'IF_ADD_INSD_R_IND', 'IF_ADD_INSD_IND', 'CUST_9_SEGMENTS_CD'等7個變數也改採均值編碼表示
xgboost模型預測結果平均AUC值:0.844608
12. 承5,'FINANCETOOLS_A', 'FINANCETOOLS_B', 'FINANCETOOLS_C', 'FINANCETOOLS_D', 'FINANCETOOLS_E', 'FINANCETOOLS_F', 'FINANCETOOLS_G'等6個變數也改採均值編碼表示  
xgboost模型預測結果平均AUC值:0.843681
- 計數編碼:類別的目標均值與類別筆數呈正相關(或負相關),也可以將筆數本身當作特徵,由以下圖判斷試了幾個變數後效果不佳,因此,最後不考慮使用計數編碼

![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count1.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count2.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count3.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count4.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count5.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count6.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count7.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count8.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count9.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count10.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count11.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count12.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count13.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count14.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count15.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count16.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count17.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count18.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count19.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count20.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count21.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count22.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count23.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count24.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count25.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count26.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/count27.png)

1. 'MARRIAGE_CD',"IM_CNT","LIFE_CNT"改使用計數編碼
xgboost模型預測結果平均AUC值:0.845110
2. 'GENDER','LAST_A_CCONTACT_DT','LAST_A_ISSUE_DT','LAST_B_ISSUE_DT','IF_2ND_GEN_IND'
xgboost模型預測結果平均AUC值:0.844514

## 變數篩選
#### 特徵相關係數

![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/corr1.png)

#### 特徵重要性
- 目前xgboost模型預測結果平均AUC值:0.842985
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/importance1.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/importance2.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/importance3.png)
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/importance4.png)
- 有36個變數特徵重要性為0,刪除36個變數後xgboost模型預測結果平均AUC值:0.843244
- 刪除前5小的變數("IF_ISSUE_INSD_O_IND_N","IF_ISSUE_INSD_L_IND_N","LAST_B_ISSUE_DT","FINANCETOOLS_F_Y","X_A_IND_Y"),刪除後xgboost模型預測結果平均AUC值:0.843930
- 再刪除前5小的變數("CHARGE_CITY_CD_C1","X_F_IND_Y","IF_ISSUE_K_IND","IF_ISSUE_INSD_L_IND_Y","CHARGE_CITY_CD_D"),刪除後xgboost模型預測結果平均AUC值:0.843000,選擇僅刪除前3個變數xgboost模型預測結果平均AUC值:0.844725,選擇僅刪除前4個變數xgboost模型預測結果平均AUC值:0.842314
- 最後共刪除44個變數
#### 特徵組合或特徵修改
- 以下6個變數有序化後xgboost模型預測結果平均AUC值:0.846638
AGE
RFM_R:缺失值可能為沒有擔任要保人身分過,補5
REBUY_TIMES_CNT:可能沒有再購,補0
LEVEL:缺失值量與RFM_R同,補0
RFM_M_LEVEL:可能為沒有投保主約過,補0
LIFE_CNT
- 目前xgboost模型預測結果平均AUC值:0.844556
- 特徵組合與刪除後xgboost模型預測結果平均AUC值:0.844587 
OCCUPATION_CLASS_CD	vs LEVEL:相乘
OCCUPATION_CLASS_CD	vs AGE:相乘
OCCUPATION_CLASS_CD	vs TOOL_VISIT_1YEAR_CNT:群聚編碼
OCCUPATION_CLASS_CD	vs LAST_A_ISSUE_DT:分成多個bag取均值編碼
刪'L1YR_GROSS_PRE_AMT','X_G_IND_Y','X_H_IND_Y','IF_ISSUE_INSD_B_IND_N','IF_ISSUE_INSD_F_IND_N','IF_ISSUE_INSD_G_IND_N','IF_ISSUE_INSD_K_IN
D_N','CUST_9_SEGMENTS_CD_E'
- 特徵組合與刪除後xgboost模型預測結果平均AUC值:0.841958
ANNUAL_PREMIUM_AMT vs TOOL_VISIT_1YEAR_CNT:相除(分母+1)
ANNUAL_PREMIUM_AMT vs ANNUAL_INCOME_AMT:相除
刪除'X_B_IND_Y','X_G_IND_Y','X_H_IND_Y','IF_ISSUE_INSD_K_IND_N','IF_ISSUE_INSD_L_IND_Y','FINANCETOOLS_E_N'
## 機器學習模型
#### xgboost
early_stopping_rounds=10早停次數,nfold=5
調參順序:
1. 學習速率與n_estimators樹數量
2. max_depth樹的最大深度
3. min_child_weight決定最小葉子節點樣本權重和,加權低於這個值,不再分裂產生新的葉子節點
4. gamma節點分裂時,只有在分裂後損失函數的值下降了(達到gamma指定的閥值),才會分裂這個節點(gamma越大,越不易過擬合)
5. subsample控制對於每棵樹,隨機採樣的比例
6. colsample_bytree用來控制每棵樹隨機採樣的列數的佔比
7. 最後固定其他參數下,在調整最適合的學習速率與樹數量
#### catboost

#### ensemble 
- 使用ensemble method中的stacking使用多個模型預測
1. 包含模型:xgboost,catboost,lightbm,random forest, logistic,naive bayes 
2. 不放入KNN與SVM模型原因:需計算各個資料的距離,所需花費的時間成本較高
