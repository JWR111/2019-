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
- 可以考慮將TERMINATION_RATE變數進行最小最大化,使用隨機森林模型,並使用交叉驗證的方式,設定cross validation=5,看看將此變數處理後的預測結果如何,由結果選擇不對該變數做最小最大化
1. 變數處理前AUC值預測結果:0.828,0.825,0.848,0.829,0.819(平均值=0.8298)
2. 變數處理後AUC值預測結果:0.826,0.840,0.812,0.830,0.818(平均值=0.8252)

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
#### 連續型變數離散化
#### 類別型變數編碼
## 變數篩選
#### 特徵重要性
#### 特徵組合
## 機器學習模型
#### xgboost
#### catboost
#### ensemble 
