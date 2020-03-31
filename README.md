# 2019-國泰大數據競賽
## 目的
#### 預測公司既有客戶在未來三個月內是否會購買重疾險保單
## 資料介紹
#### 總共有132個變數,其中有一個為預測變數y,一個為顧客id,訓練集資料共有100000筆,測試集資料有150000筆
#### 以下為資料的所有變數
|欄位英文|欄位中文|欄位英文|欄位中文|欄位英文|欄位中文|
| :---------: | :--------: | :------------:  | :-------------: | :----------:  | :----------: |
| CUS_ID | CUS_ID(流水編號) |GENDER| 性別  |AGE| 年齡(年)(級距) |
|CHARGE_CITY_CD|收費地址_縣市|CONTACT_CITY_CD |聯絡地址_縣市 |EDUCATION_CD |教育程度/學歷 |
|MARRIAGE_CD |婚姻狀況 |LAST_A_CCONTACT_DT | 近三年是否有與 A 通路接觸 |L1YR_A_ISSUE_CNT|近一年透過 A 通路投保新契約次數|
|LAST_A_ISSUE_DT |近三年是否有透過 A 通路投保新契約 |L1YR_B_ISSUE_CNT |近一年透過 B 通路投保新契約次數 |LAST_B_ISSUE_DT |近三年是否有透過 B 通路投保新契約 |
|CHANNEL_A_POL_CNT|透過 A 通路投保新契約件數 |CHANNEL_B_POL_CNT |透過 B 通路投保新契約件數 |OCCUPATION_CLASS_CD |客戶職業類別(各類別)對核保風險程度 |
|APC_CNT |對應的要保人數 |INSD_CNT |對應的被保人數 |APC_1ST_AGE|首次擔任要保人年齡(級距) |
[variable](https://github.com/Jiang-Wan-Rong/2019-/blob/master/variable/layout.pdf)
## 資料處理
#### 先把資料變數分為連續型變數和類別型變數

- 類別型變數:共有95個(不包含預測變數y)
- 連續型變數:共有35個
- 處理缺失值資料
![image](https://github.com/Jiang-Wan-Rong/2019-/blob/master/EDA/%E6%95%B8%E5%80%BC%E5%9E%8B%E8%AE%8A%E6%95%B8%E7%BC%BA%E5%A4%B1%E5%80%BC%E6%AF%94%E4%BE%8B%20(1).png)
