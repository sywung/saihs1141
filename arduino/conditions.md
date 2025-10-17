# Arduino 條件控制：if-else 與 switch-case

Arduino C 程式語言中 `if-else` 和 `switch-case` 條件判斷結構的基本語法、邏輯流程以及簡單範例的整理：

在 Arduino C 程式設計中，條件控制指令是控制程式執行方向的三大類指令之一，用於決定程式的執行路徑。關係運算式（Relational expressions）會解析出邏輯真（non-zero value, 1）或邏輯假（zero, 0）的狀態，作為條件判斷的基礎。



## if 和 if-else

if 語句用於測試一個條件（條件式），如果條件為真（logic true），則執行一段程式碼。

### 基本語法結構

| 結構        | 語法                                                         | 說明                                                         |
| ----------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **if**      | `if (條件式)` 敘述;                                          | 如果條件式結果為真，則執行緊跟在後的敘述（或敘述區塊）。     |
| **if-else** | `if (條件式) { 敘述 1; } else { 敘述 2; }`                   | **二選一** 的結構。若條件式為真，執行 `if` 區塊；若為假，執行 `else` 區塊。 |
| **else if** | `if (條件式 1) { ... } else if (條件式 2) { ... } else { ... }` | 處理一系列**互斥的條件**（多重條件判斷）。                   |

### 程式注意事項

• **大括號（ { } ）**： 在 if 敘述或 else 敘述內，如果只有**一行**敘述，可以不用加上大括號。但是，如果有一行**以上**的敘述，**一定要**加上大括號，否則在條件成立時，只會執行第一行敘述，可能導致誤動作。

• **巢狀 if-else **： 巢狀結構中的 else 會與**最接近且未配對**的 if 進行配對。

### 簡單範例 ( if-else if 階梯式結構 )

以下範例展示了「空氣品質指示燈」的邏輯，利用 `analogRead()` 讀取感測器數值 `GasValue`，並使用階梯式 `if-else if-else` 結構判斷嚴重等級，控制 RGB LED 輸出不同顏色：

``` c
void loop() {
  int GasValue = analogRead(36);  // 讀取 GPIO 36 的類比數值

  if (GasValue >= 1000) {        // 條件 1: 嚴重等級 (>= 1000)
    // 輸出紫燈 (R:255, G:0, B:255)
    analogWrite(15, 255);
    analogWrite(2, 0);
    analogWrite(4, 255);
  }
  else if (GasValue >= 400 && GasValue < 1000) { // 條件 2: 有害等級 (400 ~ 999)
    // 輸出紅燈 (R:255, G:0, B:0)
    analogWrite(15, 255);
    analogWrite(2, 0);
    analogWrite(4, 0);
  }
  else if (GasValue >= 200 && GasValue < 400) { // 條件 3: 普通等級 (200 ~ 399)
    // 輸出黃燈 (R:255, G:255, B:0)
    analogWrite(15, 255);
    analogWrite(2, 255);
    analogWrite(4, 0);
  }
  else { // 預設條件: 優良等級 (0 ~ 199)
    // 輸出綠燈 (R:0, G:255, B:0)
    analogWrite(15, 0);
    analogWrite(2, 255);
    analogWrite(4, 0);
  }
  delay(100);
}

```



## switch-case 

switch-case 語句是一種**多選一**的程式流程控制指令，特別適用於檢驗某一個整型變數的多種可能取值。它的格式比 `if-else if` 敘述更清楚且有彈性。

### 基本語法結構

``` c
switch (條件式)
{
case 條件值 1:
     敘述 1;
     break;
case 條件值 2:
     敘述 2;
     break;
// 可包含更多 case 敘述...
default:
     敘述 n;
}
```

### 邏輯限制與規則

| 項目              | 說明                                                         |
| ----------------- | ------------------------------------------------------------ |
| **條件式類型**    | 必須評估為**整數資料類型**（integral data type），例如： byte 、 char 、 int 或 long。它不能是浮點類型 (float 或 double) 或參考資料類型 (string 或 String)。 |
| **條件值類型**    | case 語句檢驗的值必須是**整數常量**（或常量表達式/運算）。任意兩個 case 語句不能使用相同的常量值。 |
| **語法結構**      | case 敘述區塊始於冒號（:），並延伸至 break 語句。**不使用大括號** **{}** 來界定 case 區塊。 |
| **break****作用** | break 語句用於跳出 switch 結構，不再執行後續的 case 敘述。   |
| **fall through**  | 如果省略 break，程式將會執行下一個 case 區塊的敘述（稱為「fall through」）。 |
| **default**       | 如果所有 case 條件值都不符合，則執行 default 所指定的敘述。default 可以省略，但通常放在最後。 |

### 邏輯流程（Flow/執行路徑）

程式會將 switch 括號中的**條件式運算結果**，與各個 case 所指定的**條件值**進行比對。

1. 如果找到相符的 case，程式會從該 case 後的第一條敘述開始執行。
2. 執行直到遇到 break 語句，此時程式將跳出整個 switch 區塊。
3. 如果沒有相符的 case 值，則執行 default 區塊（如果存在）。

以下範例展示如何將分數（score）的十位數取出（value = score/10），然後使用 switch 語句來判斷成績等級（grade）：

``` c
void loop() {
  int score = 75;   // 宣告整數變數 score，初值 75
  int value;        // 宣告整數變數 value
  char grade;       // 等級變數

  value = score / 10;   // 取出成績十位數值 (例如 75/10 = 7)

  switch (value)
  {            // 以成績十位數值作為判斷條件 (整數)
    case 10:   // 成績為 100 分 (value=10)
      grade = 'A';
      break;   // 結束 switch
    case 9:    // 成績在 90~99 分之間 (value=9)
      grade = 'A';
      break;
    case 8:    // 成績在 80~89 分之間 (value=8)
      grade = 'B';
      break;
    case 7:    // 成績在 70~79 分之間 (value=7)
      grade = 'C';
      break;
    default:   // 所有其他情況 (< 70 分)
      grade = 'E';
      break;
  }
}
```

