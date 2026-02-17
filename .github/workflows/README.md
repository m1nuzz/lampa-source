# GitHub Actions Workflows for Lampa macOS Build

## 📋 Available Workflows

### 1. macOS Build (`macos-build.yml`)

Автоматическая сборка проекта при каждом push или pull request.

#### Triggers:
- Push в ветки `main` или `feature/macos-movist-custom-player`
- Pull Request в ветку `main`
- Создание тега `v*`
- Ручной запуск через GitHub UI

#### Что делает:
1. ✅ Устанавливает Node.js 18
2. ✅ Устанавливает зависимости
3. ✅ Собирает проект (`npm run build`)
4. ✅ Создает ZIP архив
5. ✅ Генерирует SHA-256 checksums
6. ✅ Загружает артефакты (доступны 30 дней)
7. ✅ Создает GitHub Release (опционально)

#### Ручной запуск:

1. Перейдите на вкладку [Actions](https://github.com/m1nuzz/lampa-source/actions)
2. Выберите workflow **macOS Build**
3. Нажмите **Run workflow**
4. Выберите ветку
5. Опционально отметьте "Create GitHub Release"
6. Нажмите **Run workflow**

### 2. Build and Release (`build-on-release.yml`)

Автоматическая сборка при создании Release.

#### Triggers:
- Публикация GitHub Release

#### Что делает:
1. ✅ Собирает проект
2. ✅ Создает архив с версией из тега
3. ✅ Прикрепляет ZIP к релизу
4. ✅ Прикрепляет checksum файл

## 🚀 Как использовать

### Вариант 1: Автоматическая сборка при push

```bash
git add .
git commit -m "Update features"
git push origin feature/macos-movist-custom-player
```

Сборка запустится автоматически. Результат будет в разделе Actions → Artifacts.

### Вариант 2: Создание релиза

```bash
# Создайте тег
git tag v1.0.0
git push origin v1.0.0
```

Или через GitHub UI:
1. Перейдите в [Releases](https://github.com/m1nuzz/lampa-source/releases)
2. Нажмите **Draft a new release**
3. Выберите тег (или создайте новый)
4. Заполните описание
5. Нажмите **Publish release**

### Вариант 3: Ручной запуск

1. [Actions](https://github.com/m1nuzz/lampa-source/actions) → **macOS Build**
2. **Run workflow**
3. Отметьте "Create GitHub Release" если нужен релиз
4. **Run workflow**

## 📦 Получение сборки

### Из Artifacts:

1. Перейдите в [Actions](https://github.com/m1nuzz/lampa-source/actions)
2. Выберите нужный workflow run
3. Скачайте **lampa-macos-build** из секции Artifacts

### Из Releases:

1. Перейдите в [Releases](https://github.com/m1nuzz/lampa-source/releases)
2. Скачайте `lampa-macos-vX.X.X.zip`
3. Проверьте checksum:

```bash
shasum -a 256 lampa-macos-vX.X.X.zip
cat checksums.txt
```

## 🔧 Настройка

### Изменить версию:

Отредактируйте `package.json`:

```json
{
  "version": "1.0.0"
}
```

### Изменить Node.js версию:

В workflow файлах:

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '18'  # Измените здесь
```

### Добавить дополнительные шаги:

Например, тестирование:

```yaml
- name: Run tests
  run: npm test
```

## 🐛 Troubleshooting

### Сборка падает

1. Проверьте логи в Actions
2. Убедитесь что `npm run build` работает локально
3. Проверьте `package.json` и зависимости

### Артефакты не загружаются

1. Проверьте что папка `build/` создается
2. Проверьте пути в workflow
3. Убедитесь что есть права на запись

### Release не создается

1. Убедитесь что отметили "Create GitHub Release"
2. Или создайте тег `v*`
3. Проверьте права `GITHUB_TOKEN`

## 📝 Примеры использования

### 1. Быстрая сборка для тестирования

```bash
git checkout feature/macos-movist-custom-player
git pull
# Сделайте изменения
git add .
git commit -m "test: trying new feature"
git push
# Проверьте результат в Actions → Artifacts
```

### 2. Создание официального релиза

```bash
# Обновите версию
npm version patch  # или minor, major
git push
git push --tags
# Создайте Release через GitHub UI
# Сборка прикрепится автоматически
```

### 3. Ручная сборка с релизом

1. Actions → macOS Build → Run workflow
2. Выберите ветку: `feature/macos-movist-custom-player`
3. ✅ Create GitHub Release
4. Run workflow
5. Результат будет в Releases

## 🔗 Полезные ссылки

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Actions Repository](https://github.com/m1nuzz/lampa-source/actions)
- [Releases](https://github.com/m1nuzz/lampa-source/releases)

## 📊 Status Badges

Добавьте в README.md:

```markdown
![macOS Build](https://github.com/m1nuzz/lampa-source/actions/workflows/macos-build.yml/badge.svg)
```

Результат:

![macOS Build](https://github.com/m1nuzz/lampa-source/actions/workflows/macos-build.yml/badge.svg)
