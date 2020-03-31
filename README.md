# 2019-國泰大數據競賽
## 目的
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

- 有序型類別型變數:共有11個

|變數名稱1|變數名稱2|變數名稱3|變數名稱4|
| :----------: | :----------: | :----------: | :----------: |
|L1YR_A_ISSUE_CNT|L1YR_B_ISSUE_CNT|CHANNEL_A_POL_CNT|CHANNEL_B_POL_CNT|
|APC_CNT|INSD_CNT|AG_CNT|AG_NOW_CNT|
|CLC_CUR_NUM|IM_CNT|TOOL_VISIT_1YEAR_CNT|

- 無序型類別型變數:共有95個(不包含預測變數y)
#### 處理缺失值資料
- 以下為連續型變數缺失值比例圖
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/%E6%95%B8%E5%80%BC%E5%9E%8B%E8%AE%8A%E6%95%B8%E7%BC%BA%E5%A4%B1%E5%80%BC%E6%AF%94%E4%BE%8B%20(1).png)
- 由以上圖可以得知
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/%E9%A1%9E%E5%88%A5%E5%9E%8B%E8%AE%8A%E6%95%B8%E7%BC%BA%E5%A4%B1%E5%80%BC%E6%AF%94%E4%BE%8B%20(1).png)
