# Arduino 運算子（Operators）

運算子是用來處理資料、比較數值或改變變數內容的符號。Arduino 使用以 C/C++ 為基礎的語法，因此運算子通常會寫在運算元（變數、常數或函式回傳值）之間，例如 `temperature + 2`。

運算式的結果可以直接指定給變數，也可以放在 `if`、`while` 等條件控制敘述中。

## 一、算術運算子

算術運算子用於數值計算。

| 運算子 | 名稱 | 範例 | 結果或作用 |
| ------ | ---- | ---- | ---------- |
| `+` | 加法 | `a + b` | 將兩個值相加 |
| `-` | 減法 | `a - b` | 將右側值從左側值扣除 |
| `*` | 乘法 | `a * b` | 將兩個值相乘 |
| `/` | 除法 | `a / b` | 計算商 |
| `%` | 餘數 | `a % b` | 計算整數除法的餘數 |

``` c
int sensorValue = 725;
int voltage = sensorValue * 5 / 1023;  // 整數運算，結果為 3
int remainder = sensorValue % 10;      // 結果為 5
float voltageFloat = sensorValue * 5.0 / 1023.0; // 保留小數
```

整數相除時，小數部分會被捨去，例如 `5 / 4` 的結果是 `1`。若要保留小數，至少一個運算元必須是 `float` 或 `double`。`%` 只能用於整數，且除數不可為零。

## 二、指定運算子

指定運算子會把右側運算式的結果存入左側變數。

| 運算子 | 等同寫法 | 範例 |
| ------ | -------- | ---- |
| `=` | — | `a = 10` |
| `+=` | `a = a + b` | `a += b` |
| `-=` | `a = a - b` | `a -= b` |
| `*=` | `a = a * b` | `a *= b` |
| `/=` | `a = a / b` | `a /= b` |
| `%=` | `a = a % b` | `a %= b` |

``` c
int brightness = 100;
brightness += 25;  // 125
brightness -= 10;  // 115
brightness /= 5;   // 23
```

`=` 是「指定」；`==` 才是「比較是否相等」。在 `if` 中誤寫成 `if (buttonState = HIGH)` 會改變變數內容，通常應寫成 `if (buttonState == HIGH)`。

## 三、關係（比較）運算子

關係運算子的結果是布林值 `true` 或 `false`。在 C/C++ 中，`true` 通常以 1 表示，`false` 以 0 表示。

| 運算子 | 意義 | 範例 |
| ------ | ---- | ---- |
| `==` | 等於 | `a == b` |
| `!=` | 不等於 | `a != b` |
| `>` | 大於 | `a > b` |
| `<` | 小於 | `a < b` |
| `>=` | 大於或等於 | `a >= b` |
| `<=` | 小於或等於 | `a <= b` |

``` c
int gasValue = analogRead(36);

if (gasValue >= 400) {
  digitalWrite(LED_BUILTIN, HIGH);
}
```

浮點數不建議直接使用 `==` 比較，因為計算誤差可能造成兩個看似相同的數值不完全相等。可以改用容許誤差比較：

``` c
if (abs(measured - expected) < 0.01) {
  // 視為兩個數值相等
}
```

## 四、邏輯運算子

邏輯運算子用來組合多個條件，常見於 `if` 和 `while`。

| 運算子 | 名稱 | 範例 | 結果 |
| ------ | ---- | ---- | ---- |
| `&&` | 邏輯 AND（且） | `a > 0 && a < 100` | 兩個條件都為真才為真 |
| `||` | 邏輯 OR（或） | `a == 0 || b == 0` | 任一條件為真即為真 |
| `!` | 邏輯 NOT（反相） | `!isReady` | 將真變假、假變真 |

``` c
int temperature = 28;
bool fanOn = false;

if (temperature >= 30 && !fanOn) {
  digitalWrite(5, HIGH);
  fanOn = true;
}
```

`&&` 和 `||` 具有短路判斷特性：左側已經能決定結果時，右側不會執行。例如 `ptr != nullptr && *ptr == 1` 可避免在指標無效時解參照。

## 五、位元運算子

位元運算子直接處理整數的二進位位元，適合控制暫存器、GPIO 狀態或將多個開關狀態封裝在一個變數中。

| 運算子 | 名稱 | 作用 |
| ------ | ---- | ---- |
| `&` | 位元 AND | 兩個對應位元都為 1，結果才為 1 |
| `\|` | 位元 OR | 任一對應位元為 1，結果即為 1 |
| `^` | 位元 XOR | 對應位元不同時為 1 |
| `~` | 位元 NOT | 將每個位元反相 |
| `<<` | 左移 | 位元向左移動，右側補 0 |
| `>>` | 右移 | 位元向右移動 |

``` c
byte flags = 0;
const byte LED1 = 0b00000001;
const byte LED2 = 0b00000100;

flags |= LED1;       // 設定 LED1 位元為 1
flags |= LED2;       // 設定 LED2 位元為 1
flags &= ~LED1;      // 清除 LED1 位元
bool led2On = (flags & LED2) != 0; // 測試 LED2 是否開啟
```

位元運算與邏輯運算不要混用：`&` 處理每一個位元，`&&` 處理條件的真假。設定或清除特定位元時，建議使用 `byte`、`uint8_t` 等無號整數型態，並讓移位量小於資料型態的位元數。

## 六、遞增、遞減與一元運算子

| 運算子 | 名稱 | 說明 |
| ------ | ---- | ---- |
| `++` | 遞增 | 變數加 1 |
| `--` | 遞減 | 變數減 1 |
| `-` | 負號 | 將數值變成相反符號 |
| `+` | 正號 | 表示正值，通常不改變數值 |

`++` 和 `--` 放在變數前後會影響取值時機：

``` c
int i = 3;
int a = i++;  // a 為 3，之後 i 變成 4（後置遞增）
int b = ++i;  // i 先變成 5，b 為 5（前置遞增）
```

若只要單純增加計數器，使用 `i++` 或 `++i` 都可以；若運算式同時讀寫同一個變數，應拆成多行，讓執行順序清楚。

## 七、條件（三元）運算子

三元運算子 `條件 ? 值1 : 值2` 可在一行內依條件選擇兩個值。條件為真時取得 `值1`，否則取得 `值2`。

``` c
int sensorValue = analogRead(A0);
int level = (sensorValue >= 512) ? HIGH : LOW;
digitalWrite(LED_BUILTIN, level);
```

當兩個分支需要執行多個指令時，應改用 `if-else`，避免讓程式難以閱讀。

## 八、運算子優先順序

同一個運算式包含多種運算子時，會依優先順序計算。常見順序如下（由高至低）：

1. 括號：`()`
2. 一元運算子：`!`、`~`、`++`、`--`、正負號
3. 乘除餘數：`*`、`/`、`%`
4. 加減：`+`、`-`
5. 移位：`<<`、`>>`
6. 關係比較：`<`、`<=`、`>`、`>=`
7. 相等比較：`==`、`!=`
8. 位元 AND、XOR、OR：`&`、`^`、`|`
9. 邏輯 AND、OR：`&&`、`||`
10. 指定：`=`、`+=`、`-=` 等

建議在混合運算中主動加上括號，尤其是位元與邏輯運算：

``` c
bool alarm = (temperature > 35) || ((flags & 0b00000100) != 0);
int average = (first + second) / 2;
```

## 九、Arduino 實作範例：按鍵控制 LED

以下範例使用關係、邏輯、指定和遞增運算子，按下按鍵時切換 LED，並以計數器記錄切換次數：

``` c
const int buttonPin = 4;
const int ledPin = LED_BUILTIN;
int pressCount = 0;
bool ledState = false;

void setup() {
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  bool pressed = (digitalRead(buttonPin) == LOW);

  if (pressed && !ledState) {
    ledState = true;
    pressCount++;
    digitalWrite(ledPin, HIGH);
  } else if (!pressed && ledState) {
    ledState = false;
    digitalWrite(ledPin, LOW);
  }

  delay(20);  // 簡單的按鍵去彈跳延遲
}
```

這個例子中的 `==` 用於比較、`&&` 用於組合條件、`!` 用於反相狀態、`=` 用於指定，`++` 則用於增加按下次數。
