# Testing Guide

Цей документ описує як тестувати Lampa локально і через GitHub Actions.

## 🚀 Швидкий старт

### Локальне тестування (на вашому Mac)

```bash
# Клонуйте репозиторій
git clone https://github.com/m1nuzz/lampa-source.git
cd lampa-source
git checkout feature/macos-movist-custom-player

# Запустіть тестовий скрипт
chmod +x test-local-build.sh
./test-local-build.sh
```

Скрипт автоматично:
- ✅ Перевірить Node.js і npm
- ✅ Встановить залежності
- ✅ Зробить web build
- ✅ Перевірить всі файли
- ✅ (Опціонально) Зробить Electron build

---

## 🧪 GitHub Actions CI Test

### Автоматичний запуск

CI тест запускається автоматично при:
- Push в гілку `feature/macos-movist-custom-player`
- Pull Request в `main`

### Ручний запуск

1. Перейдіть на: https://github.com/m1nuzz/lampa-source/actions/workflows/ci-test.yml
2. Натисніть **"Run workflow"**
3. Виберіть гілку
4. Натисніть **"Run workflow"**

### Що перевіряє CI тест?

✅ Встановлення залежностей  
✅ Web build (Gulp)  
✅ Наявність критичних файлів  
✅ Розміри файлів  
✅ Підготовка Electron структури  
✅ Валідація конфігурації  
✅ Перевірка на типові помилки  

**Час виконання:** ~3-5 хвилин

---

## 📦 Electron Build Workflows

### 1. Web Build (швидкий)

**Файл:** `.github/workflows/macos-build.yml`

Збирає тільки web-версію (HTML/CSS/JS):
- Не потребує Electron
- Швидший (~2-3 хвилини)
- Можна відкрити в браузері
- Підтримує URL-схеми для плеєрів

**Результат:** `lampa-macos-v0.0.1.zip` (~6 MB)

### 2. Electron Build (повний)

**Файл:** `.github/workflows/electron-build.yml`

Збирає нативний macOS застосунок:
- Electron wrapper
- DMG installer
- Universal binary (Intel + Apple Silicon)
- Повільніший (~10-15 хвилин)

**Результат:**
- `Lampa-1.0.0-universal.dmg` (~250 MB)
- `Lampa-1.0.0-arm64-mac.zip` (~125 MB)
- `Lampa-1.0.0-x64-mac.zip` (~125 MB)

---

## 🔍 Локальне тестування кроками

### Крок 1: Встановіть залежності

```bash
npm install
```

### Крок 2: Зберіть web версію

```bash
npm run build
```

### Крок 3: Перевірте результат

```bash
ls -la build/web/
open build/web/index.html  # Відкриє в браузері
```

### Крок 4: (Опціонально) Зберіть Electron app

```bash
# Підготуйте файли
mkdir -p electron/app
cp -r build/web/* electron/app/

# Встановіть Electron залежності
cd electron
npm install

# Запустіть в dev режимі
npm start

# Або зберіть DMG
npm run build:universal  # Для обох архітектур
npm run build:mac-arm64  # Тільки Apple Silicon
npm run build:mac-x64    # Тільки Intel
```

---

## 🐛 Типові проблеми

### Проблема: `gulp: command not found`

**Рішення:**
```bash
# Використовуйте npx
npx gulp --version

# Або встановіть глобально
npm install -g gulp
```

### Проблема: `build/web` не створюється

**Рішення:**
```bash
# Перевірте що gulp таски експортовані
npx gulp --tasks

# Запустіть конкретний таск
npx gulp build_ci
```

### Проблема: Electron не запускається

**Рішення:**
```bash
# Перевірте що файли скопійовані
ls -la electron/app/index.html
ls -la electron/app/app.js

# Перевірте логи
npm start 2>&1 | tee electron-debug.log
```

### Проблема: "Cannot read properties of undefined"

**Рішення:**
1. Перевірте чи є всі файли в `build/web/`
2. Відкрийте DevTools (F12) і подивіться console
3. Перевірте чи правильно завантажуються скрипти

### Проблема: Плеєри не запускаються

**Рішення:**
```bash
# Перевірте чи встановлений плеєр
open -a IINA  # Має відкритися без помилки
open -a "Movist Pro"

# Перевірте URL схеми
open "iina://weblink?url=https://example.com/video.mp4"
```

---

## 📊 Моніторинг білдів

### Дивіться статус:

- **CI Test:** https://github.com/m1nuzz/lampa-source/actions/workflows/ci-test.yml
- **Web Build:** https://github.com/m1nuzz/lampa-source/actions/workflows/macos-build.yml  
- **Electron Build:** https://github.com/m1nuzz/lampa-source/actions/workflows/electron-build.yml

### Badge статусу (для README):

```markdown
![CI Test](https://github.com/m1nuzz/lampa-source/actions/workflows/ci-test.yml/badge.svg)
```

---

## ✅ Чеклист перед релізом

- [ ] CI тест пройшов успішно
- [ ] Web build відкривається в браузері
- [ ] Electron app запускається локально
- [ ] Перевірено на Intel Mac (якщо є)
- [ ] Перевірено на Apple Silicon Mac
- [ ] Плеєри (IINA/Movist) працюють
- [ ] Без помилок в console
- [ ] DMG встановлюється без помилок
- [ ] Іконка відображається правильно (якщо додано)

---

## 🎯 Performance Benchmarks

### CI Test
- Встановлення залежностей: ~1-2 хв
- Web build: ~1-2 хв
- Верифікація: ~30 сек
- **Загалом:** ~3-5 хв

### Electron Build
- Встановлення Electron: ~3-5 хв
- Build universal binary: ~5-7 хв
- DMG packaging: ~1-2 хв
- **Загалом:** ~10-15 хв

---

## 📝 Логи та Debug

### Збереження логів локально

```bash
# Web build
npm run build 2>&1 | tee build.log

# Electron build
cd electron
npm run build 2>&1 | tee electron-build.log
```

### Детальні логи Electron

```bash
DEBUG=electron-builder npm run build
```

### Логи з GitHub Actions

1. Відкрийте workflow run
2. Клікніть на job
3. Розгорніть step для деталей
4. Скопіюйте або завантажте логи

---

## 🤝 Контрибуція

Якщо знайшли баг:

1. Запустіть `./test-local-build.sh`
2. Збережіть логи
3. Створіть issue з:
   - Описом проблеми
   - Кроками відтворення
   - Логами
   - Версією macOS
   - Архітектурою (Intel/Apple Silicon)

---

## 📚 Додаткові ресурси

- [Electron Documentation](https://www.electronjs.org/docs/latest/)
- [electron-builder](https://www.electron.build/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Gulp Documentation](https://gulpjs.com/)
