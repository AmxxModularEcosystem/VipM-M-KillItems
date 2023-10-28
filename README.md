# [VipM-M] Kill Items

Модуль для VipModular, выдающий предметы за убийство игрока.

## Требования

- [VipModular](https://github.com/ArKaNeMaN/amxx-VipModular-pub) версии [5.0.0-beta.10](https://github.com/ArKaNeMaN/amxx-VipModular-pub/releases/tag/5.0.0-beta.10) или новее.

## Параметры

| Параметр     | Тип      | Обязательный | По умолчанию | Описание                                              |
| :----------- | :------- | :----------- | :----------- | :---------------------------------------------------- |
| Items        | Предметы | Нет          | -            | Предметы, которые будут выданы за любое убийство      |
| DefaultItems | Предметы | Нет          | -            | Предметы, которые будут выданы за обычное убийство    |
| HeadItems    | Предметы | Нет          | -            | Предметы, которые будут выданы за убийство в голову   |
| KnifeItems   | Предметы | Нет          | -            | Предметы, которые будут выданы за убийство ножом      |
| Limits       | Лимиты   | Нет          | -            | Условия, при выполнении которых предметы будут выданы |

## Пример

```jsonc
{
  "Module": "KillItems",
  "Items": [
    {
      "Type": "InstantReload"
    }
  ],
  "DefaultItems": {
    "Type": "Money",
    "Amount": 300
  },
  "HeadItems": {
    "Type": "Money",
    "Amount": 500
  },
  "KnifeItems": {
    "Type": "Money",
    "Amount": 1000
  }
}
```
