# Electron Test Build - Інструкція

## 🎯 Для чого цей тест?

Цей workflow створений спеціально для **тестування та дебагу** проблем з Electron білдом macOS застосунку.

**Проблема:** Білд завершується, але застосунок не працює на Mac.

**Рішення:** Цей тест допоможе знайти що саме не так.

---

## 🚀 Як запустити тест

### Крок 1: Відкрийте GitHub Actions

👉 **[Відкрити Test Electron Build](https://github.com/m1nuzz/lampa-source/actions/workflows/test-electron-build.yml)**

### Крок 2: Запустіть workflow

1. Натисніть **"Run workflow"** (праворуч вгорі)
2. Виберіть опції:

#### Опція 1: Швидкий тест (рекомендовано)
```
Build type: test-only
Architecture: arm64 (якщо у вас M1/M2/M3)
```
**Час:** ~5 хвилин  
**Результат:** Тільки перевірка, без створення файлів

#### Опція 2: Білд тільки ZIP (швидше)
```
Build type: build-zip-only
Architecture: arm64
```
**Час:** ~7-10 хвилин  
**Результат:** Створює ZIP файл (~125 MB)

#### Опція 3: Повний білд з DMG
```
Build type: build-dmg
Architecture: arm64
```
**Час:** ~10-15 хвилин  
**Результат:** Створює DMG + ZIP (~250 MB)

3. Натисніть **"Run workflow"**

---

## 📊 Що перевіряє тест?

### ✅ Крок 1: Web Build
- Збирає web версію
- Перевіряє наявність `index.html` і `app.js`
- Показує розміри файлів

### ✅ Крок 2: Electron Preparation
- Копіює файли в `electron/app/`
- Перевіряє структуру
- Верифікує конфігурацію

### ✅ Крок 3: Dependencies
- Встановлює Electron (~200 MB)
- Встановлює electron-builder
- Показує версії

### ✅ Крок 4: Packaging Test
- Тестує electron-builder
- Перевіряє чи створюється .app bundle
- Показує структуру застосунку

### ✅ Крок 5: Verification
- Перевіряє чи файли всередині .app
- Перевіряє `index.html` та `app.js` в пакеті
- Показує розміри

---

## 🔍 Як читати результати

### Якщо тест пройшов успішно ✅

Ви побачите:
```
✅ Web build completed
✅ Files copied
✅ Electron dependencies installed
✅ Packaging test completed
✅ .app bundle created
✅ index.html found in packaged app
✅ app.js found in packaged app
```

**Це означає:** Білд працює коректно. Проблема може бути:
- У самому коді застосунку
- У версії macOS
- У налаштуваннях безпеки Mac

### Якщо є помилки ❌

Шукайте рядки з:
```
❌ ERROR: ...
❌ ... NOT FOUND!
❌ ... MISSING!
```

Це покаже **точно** що не працює.

---

## 🎁 Завантаження білда

Якщо вибрали `build-zip-only` або `build-dmg`:

1. Дочекайтесь завершення workflow
2. Прокрутіть вниз до **"Artifacts"**
3. Завантажте `test-electron-build-arm64.zip`
4. Розпакуйте
5. Спробуйте запустити Lampa.app на вашому Mac

---

## 🐛 Типові проблеми та рішення

### Проблема 1: "app files not found in packaged app"

**Причина:** Файли не копіюються в .app bundle

**Рішення:**
```json
// electron/package.json
"build": {
  "files": [
    "electron-main.js",
    "preload.js",
    "app/**/*"  // ← Переконайтеся що це є!
  ]
}
```

### Проблема 2: "Electron dependencies installation failed"

**Причина:** Проблеми з npm або мережею

**Рішення:** Запустіть workflow ще раз

### Проблема 3: "White screen" на Mac

**Причина:** Файли є, але застосунок не завантажується

**Перевірте в логах:**
1. Чи правильний шлях до index.html
2. Чи є помилки в electron-main.js
3. Чи працює preload.js

**Debug локально:**
```bash
# В electron/electron-main.js додайте:
mainWindow.webContents.openDevTools();  // Відкриє DevTools

# Або додайте логування:
console.log('Loading:', appPath);
mainWindow.loadFile(appPath)
  .then(() => console.log('Loaded!'))
  .catch(err => console.error('Error:', err));
```

### Проблема 4: "Cannot find module 'electron'"

**Причина:** electron не встановлений в electron/node_modules

**Рішення:**
```bash
cd electron
rm -rf node_modules package-lock.json
npm install
```

---

## 📝 Що робити з результатами

### Якщо тест показав помилку:

1. **Скопіюйте повний лог** з GitHub Actions
2. Знайдіть рядок з ❌
3. Створіть issue з:
   - Описом проблеми
   - Логом помилки
   - Build type і Architecture які використовували

### Якщо тест пройшов, але білд не працює на вашому Mac:

1. Завантажте білд з Artifacts
2. Спробуйте запустити
3. Збережіть лог помилки (якщо є):
   ```bash
   # Запустіть з терміналу
   open -a Lampa --stdout /tmp/lampa.log --stderr /tmp/lampa-err.log
   
   # Подивіться логи
   cat /tmp/lampa.log
   cat /tmp/lampa-err.log
   ```
4. Створіть issue з логами

---

## 🔧 Локальний debug (якщо потрібно)

```bash
# 1. Зберіть web версію
npm run build

# 2. Підготуйте Electron
cp -r build/web/* electron/app/
cd electron
npm install

# 3. Запустіть в dev режимі
npm start

# Якщо не працює - дивіться в консоль Terminal
# Повинні бути помилки які покажуть проблему

# 4. (Опціонально) Зберіть білд
npm run build:mac-arm64

# 5. Перевірте що всередині .app
ls -la dist/mac-arm64/Lampa.app/Contents/Resources/app/

# Має бути index.html, app.js і всі файли
```

---

## 💡 Корисні команди для debug

### Перевірити .app структуру
```bash
# Показати всю структуру
tree dist/mac-arm64/Lampa.app

# Або без tree
find dist/mac-arm64/Lampa.app -type f | head -n 50
```

### Перевірити чи є JavaScript помилки
```bash
# Відкрити app з DevTools
open -a Lampa
# В меню: View → Toggle Developer Tools
```

### Перевірити Electron логи
```bash
# macOS логи
tail -f ~/Library/Logs/Lampa/log.log
```

---

## 📊 Очікувані розміри

### Test-only (--dir)
- **Час:** ~5 хвилин
- **Розмір:** ~0 MB (тільки тест, файли не створюються)

### ZIP-only
- **Час:** ~7-10 хвилин  
- **Розмір ARM64:** ~125 MB
- **Розмір x64:** ~125 MB
- **Розмір universal:** ~250 MB

### DMG + ZIP
- **Час:** ~10-15 хвилин
- **DMG:** ~130 MB (компресований)
- **ZIP:** ~125 MB

---

## 🎯 Найкращий підхід для debug

### Крок 1: Швидкий тест
```
Run workflow → test-only → arm64 → Run
```
**5 хвилин** - покаже чи білд взагалі працює

### Крок 2: Якщо тест OK → зберіть ZIP
```
Run workflow → build-zip-only → arm64 → Run
```
**10 хвилин** - завантажте і спробуйте на Mac

### Крок 3: Якщо ZIP працює → зберіть DMG
```
Run workflow → build-dmg → arm64 → Run
```
**15 хвилин** - фінальний інсталятор

---

## ❓ Часті питання

**Q: Чому test-only такий швидкий?**  
A: Він збирає тільки в --dir (папку), без DMG/ZIP компресії.

**Q: Яку архітектуру вибрати?**  
A: 
- M1/M2/M3/M4 Mac → `arm64`
- Intel Mac → `x64`  
- Обидва → `universal` (але повільніше)

**Q: Чому білд проходить в CI але не працює локально?**  
A: Можливі причини:
- Різні версії Node.js
- Різні версії Electron
- Відсутні залежності
- Проблеми з правами доступу macOS

**Q: Як прибрати warning "App is not signed"?**  
A: 
```bash
sudo xattr -cr /Applications/Lampa.app
```

---

## 🚀 Запустити зараз!

👉 **[Run Test Electron Build](https://github.com/m1nuzz/lampa-source/actions/workflows/test-electron-build.yml)**

Виберіть `test-only` і `arm64` для швидкого тесту!
