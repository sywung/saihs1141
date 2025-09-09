{
  "version": 1,
  "author": "sywung@gmail.com",
  "editor": "wokwi",
  "parts": [
    { "type": "wokwi-arduino-uno", "id": "uno", "top": 115.8, "left": 18.6, "attrs": {} },
    {
      "type": "wokwi-resistor",
      "id": "r1",
      "top": 72,
      "left": 114.65,
      "rotate": 90,
      "attrs": { "value": "220" }
    },
    { "type": "wokwi-led", "id": "led", "top": -13.2, "left": 119, "attrs": { "color": "red" } }
  ],
  "connections": [
    [ "uno:GND.1", "led:C", "black", [] ],
    [ "r1:1", "led:A", "red", [] ],
    [ "uno:13", "r1:2", "red", [] ]
  ],
  "dependencies": {}
}