這是關於 Arduino（以及相容晶片如 ESP32）使用 UART 埠的介紹，內容涵蓋其原理、設定方式及常用指令。

UART（Universal Asynchronous Receiver Transmitter，通用非同步收發傳輸器）或 USART（Universal Synchronous Asynchronous Receiver Transmitter，通用同步/非同步串列傳輸器）是單晶片微處理機中非常重要的通訊介面。

------

### 一、 UART 埠的原理（Principle）

UART/USART 是一種串列通訊介面，主要用於兩個裝置之間進行**資料傳輸**。

#### 1. 串列傳輸的優勢

對於 I/O 腳位數有限的單晶片而言，串列介面（Serial Interface）所需的接線數少，是一個很大的優勢，因此現今多使用串列介面進行數據通訊。

#### 2. USART 與 UART

- **UART** 僅支援非同步傳輸模式。
- **USART** 支援同步傳輸模式及非同步傳輸模式。
- 在非同步模式下，USART 支援**全雙工傳輸**，這意味著可以同時傳送及接收數據。

#### 3. 傳輸格式與結構

UART/USART 的傳輸格式是以「框」（FRAME）為單位。一個完整的框（FRAME）包含以下位元：

- 1 個**開始**（start, St）位元。
- 可設定 **5 至 9 個資料位元**。
- 1 個**同位元**（Parity, P）。
- 可設定 **1 至 2 個結束**（stop, Sp）位元。

#### 4. 傳輸速率（Baud Rate）

UART 傳輸的速度是以**鮑率**（Baud，單位 bps）來衡量。在進行通訊時，傳送與接收的速率必須設定相同，才能正確進行數據傳輸，否則會出現亂碼。

### 二、 Arduino/ESP32 的 UART 硬體配置與設定（Setup）

在 Arduino 環境中，通常使用 `Serial` 函式庫來操作 UART 硬體。

#### 1. 硬體 UART 埠位址

- **Arduino Uno 板：** 內含一組 **UART 硬體串列埠**。接收腳 **RXD** 連接到**數位腳 0**，傳送腳 **TXD** 連接到**數位腳 1**。由於這兩個腳位用於 USB 串列通信（程式碼上傳），應避免將其當作其他用途使用。
- **ESP32 晶片：** 內建 **3 組**硬體 UART 組數。
- **ESP32 序列監控：** **GPIO 1 (TX) 和 GPIO 3 (RX)** 是 Arduino IDE 序列監控視窗的**實體位置**，與 USB port 相連，用於與其他裝置溝通。讀者建議避開使用這兩個腳位，以避免無法輸出序列資訊。通常透過 CP2102、CH340或其他的USB-UART轉換IC。

#### 2. 程式初始化設定

要啟動序列通訊，必須在 `setup()` 函式中設定鮑率：

| 函式名稱         | 語法                  | 說明                                                         |
| ---------------- | --------------------- | ------------------------------------------------------------ |
| `Serial.begin()` | `Serial.begin(speed)` | 建立一個串列通信介面，並設定傳輸速率 `speed`（鮑率）。常見的鮑率有 9600、115200 等。 |
| `if(Serial)`     | `if(Serial)`          | 檢查所指定的序列埠是否已就緒，若就緒則傳回布林值 `true`。    |

例如，要啟動鮑率為 115200 的序列通訊，指令為：`Serial.begin(115200);`。
註:ESP32可支援通訊格式設定，如: Serial.begin(9600, SERIAL_7E1); 

### 三、 UART/Serial 的常用指令（Commands）

Arduino 程式語言提供 `Serial` 串列函式庫來簡化串列通信的複雜性，並透過 Arduino IDE 中的**序列埠監控視窗**（Serial Monitor）來顯示所傳輸的資料內容。

#### 1. 輸出函式

這些函式用於將資料從 Arduino 板傳送（寫入）到電腦或其他串列裝置。

| 函式               | 語法                                                         | 說明                                                         |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `Serial.print()`   | `Serial.print(val, format)`                                  | **輸出 ASCII 文數字資料**到序列埠。`format` 參數可選擇輸出格式：BIN（二進位）、OCT（八進位）、DEC（十進位，預設）及 HEX（十六進位）。 |
| `Serial.println()` | `Serial.println(val, format)`                                | 功能與 `Serial.print()` 相同，但資料結束後會輸出**歸位字元**（ASCII=13）及**換行字元**（ASCII=10），將游標移至下一行的開頭。 |
| `Serial.write()`   | `Serial.write(val)` 或 `Serial.write(str)` 或 `Serial.write(buf, len)` | **輸出二進位資料**到序列埠，或輸出字串/陣列內容。            |

#### 2. 輸入函式

這些函式用於接收從電腦或其他串列裝置傳入 Arduino 板的資料。

| 函式                  | 語法                              | 說明                                                         |
| --------------------- | --------------------------------- | ------------------------------------------------------------ |
| `Serial.available()`  | `Serial.available()`              | 取得從序列埠接收**緩衝區**（Buffer）讀取的**位元組數**（字元數）。Arduino Uno 的接收緩衝區大小為 64 個位元組。 |
| `Serial.read()`       | `char ch = Serial.read()`         | 讀取傳入序列埠的 **8 位元數值資料**（位元組資料）。          |
| `Serial.readString()` | `String BTdata = BT.readString()` | (在藍牙/ESP32範例中提及) 讀取序列資料並轉換為字串。          |

**應用範例：雙向傳輸**

要實現雙向傳輸，例如讓電腦透過序列監控視窗（Serial Monitor）向 ESP32 輸入訊息，並讓 ESP32 傳回訊息，程序如下：

1. **檢查序列監控視窗是否有輸入資料：** 使用 `Serial.available()`。
2. **讀取資料：** 使用 `Serial.readString()` 或 `Serial.read()` 將資料讀入。
3. **回覆資料：** 使用 `Serial.println()` 或 `BT.println()`（如果與藍牙通訊）將資料傳送回去。
