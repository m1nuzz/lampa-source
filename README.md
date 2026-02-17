# Lampa

![macOS Build](https://github.com/m1nuzz/lampa-source/actions/workflows/macos-build.yml/badge.svg?branch=feature/macos-movist-custom-player)

Все исходники приложения **lampa**, всем желающим прошу до хаты :)

Приветствуется ваши идеи и правки в коде, сделаем вместе приложение еще лучше!

MSX версия тут: https://github.com/yumata/lampa

## 🎉 macOS Build с улучшенной поддержкой плееров

Этот форк включает улучшенную поддержку macOS плееров:

### ✨ Новые возможности:
- ✅ Поддержка **Movist Pro**
- ✅ **Custom Player** с настраиваемой URL-схемой
- ✅ Автоматическая сборка через GitHub Actions
- ✅ Готовые релизы с checksums

### 🎮 Поддерживаемые плееры:
- IINA (`iina://weblink?url=`)
- Infuse (`infuse://x-callback-url/play?url=`)
- MPV (`mpv://`)
- nPlayer (`nplayer-`)
- **Movist Pro** (`movist://open?url=`) ← НОВЫЙ!
- **Custom Player** (любая URL-схема) ← НОВЫЙ!
- TracyPlayer (`tracyplayer://`)

### 📥 Скачать готовую сборку:

1. **Из Releases**: [Перейти к релизам](https://github.com/m1nuzz/lampa-source/releases)
2. **Из Artifacts**: [GitHub Actions](https://github.com/m1nuzz/lampa-source/actions) → выберите workflow → скачайте artifact

### 🚀 Быстрый старт:

```bash
# Клонировать репозиторий
git clone https://github.com/m1nuzz/lampa-source.git
cd lampa-source

# Переключиться на ветку с macOS улучшениями
git checkout feature/macos-movist-custom-player

# Установить зависимости
npm install

# Запустить в режиме разработки
npm run start

# Или собрать для продакшена
npm run build
```

### ⚙️ Настройка плеера:

1. Откройте Lampa
2. Перейдите в **Настройки** → **Плеер**
3. Выберите **Тип плеера**: `Movist Pro` или `Custom Player`
4. Для Custom Player укажите URL-схему (например: `vlc://`, `someplayer://`)

### 📚 Документация:

- [Патч для macOS плееров](MACOS_PLAYERS_PATCH.md)
- [GitHub Actions Workflows](.github/workflows/README.md)
- [Руководство по миграции на 3.0](UPGRADE.md)

---

## Как запустить

Открываем CMD и запускаем команду `npm install`

Затем запускаем команду `npm run start`

Открываем браузер и вводим адрес `http://localhost:3000`

## Документация

В приложении появилась документация, которая будет постоянно обновляться и дополняться. Выполните команду `npm run doc` затем перейдите в папку `build/doc` и откройте файл `index.html`

И техническая документация от ИИ с обновлением раз в неделю [![DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/yumata/lampa-source)

## Переход на версию 3.0
В версии 3.0 произошли значительные изменения в структуре проекта и кодовой базе. Пожалуйста, ознакомьтесь с [руководством по миграции](UPGRADE.md), чтобы узнать, как обновить ваше приложение до новой версии.

---

## 🤝 Contributing

Приветствуются Pull Requests! Пожалуйста, убедитесь что:
- Код соответствует стилю проекта
- Изменения протестированы
- Описание PR понятное и подробное

## 📄 License

См. оригинальный репозиторий: https://github.com/yumata/lampa-source
