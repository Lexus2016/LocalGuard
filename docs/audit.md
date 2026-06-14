# Аудит сайту LocalGuard (localguard.me)
**Дата аудиту:** 2026-06-14  
**Виконав:** localguard-generalist  
**Джерело:** https://localguard.me (web fetch)

---

## 1. Загальне враження

Сайт односторінковий (landing page) з прокруткою. Тема — захист конфіденційних даних (секретів, API-ключів, PII) перед відправкою до LLM-провайдерів. Продукт — локальний проксі/додаток для macOS, Linux, Windows.

---

## 2. Заголовки (H1, H2), CTA та опис продукту

### Основні заголовки
- **H1 (hero):** *"Protect your secrets from AI agents"*
- **H2 (під H1):** *"One AI request can send your secrets outside your machine"*
- **H2 (секція "Why LocalGuard"):** *"Built by security specialists, not just developers"*
- **H2 (фінальний CTA):** *"Is your next AI request safe?"*

### Основний опис (value proposition)
> "AI sees too much. LocalGuard hides what shouldn't end up in logs, context windows or vendor metrics. Works with any AI agent — from Claude and ChatGPT to your own API integrations."

### Ключові цифри на сторінці
- 50+ detection patterns
- <50ms added latency per request
- 100% local processing
- 669 secrets intercepted (демо-сесія)
- 138 requests scanned
- 70%+ of requests contained secrets
- 109 MB of data analyzed

### CTA (заклики до дії)
- "[Download](download.html)" — під кожним тарифом
- "Start free — API keys, tokens, and crypto detection included. Download in 2 minutes, no license needed."
- Enterprise CTA: "[Contact](mailto:support@localguard.me?subject=LocalGuard%20Enterprise%20inquiry)"
- Під фінальним блоком: "Download in 2 minutes, no license needed. Upgrade anytime for passwords, credit cards, PII, and AI model."

---

## 3. Тарифи (Pricing)

| Тариф | Ціна | Для кого | Що входить |
|-------|------|----------|------------|
| **Free** | $0 | Розробники | API keys, Bearer & JWT tokens, AWS/GitHub keys, Private keys (PEM), Crypto wallets, IBAN |
| **Pro** | $39/рік (~$3.25/міс) | Ті, хто працює з клієнтськими даними | Free + Credit cards, Emails, Phone numbers, Passwords, Personal data, Real-time dashboard |
| **Enterprise** | За запитом | Команди, сервери | Pro + 2 server licenses, Extended detection rules, AI tuning, Priority support |

---

## 4. Соціальні мережі

⚠️ **На сайті НЕ знайдено посилань на соціальні мережі.**

Під час пошугу в Інтернеті знайдено сторонні профілі з схожими назвами, але вони належать іншим продуктам (Chrome-розширення LocalGuard, localguard.pro тощо). Безпосередньо на localguard.me — **жодних іконок/посилань Telegram, Instagram, Facebook, TikTok, YouTube, LinkedIn, X/Twitter**.

---

## 5. Контактні дані

| Тип | Значення | Примітка |
|-----|----------|----------|
| **Email** | support@localguard.me | Зазначено в Enterprise CTA (mailto) |
| **Телефон** | ❌ Не знайдено | — |
| **Форма зворотного зв’язку** | ❌ Не знайдено | — |
| **Адреса/місцезнаходження** | ❌ Не знайдено | — |
| **GitHub** | https://github.com/Lexus2016/LocalGuard | Згадується на сторінці Download як джерело релізів |
| **Документація / Setup Guide** | https://localguard.me/guide.html | Є посилання на гайд |

---

## 6. SWOT-огляд (на основі побаченого)

### Сильні сторони (Strengths)
1. **Чіткий message:** одразу зрозуміло, що продукт робить і для кого.
2. **Живі метрики:** 669 secrets intercepted, 70%+ requests — створюють довіру.
3. **Три рівні тарифів:** Free (zero friction), Pro ( affordable ), Enterprise (B2B).
4. **Cross-platform:** macOS, Linux, Windows + Homebrew + AppImage + .deb + CLI.
5. **Прозорість:** FAQ відповідає на реальні запитання (slowdown? code audit? lost license?).
6. **Rust-базований core:** маркетингово це сприймається як "швидко + безпечно".

### Слабкі сторони (Weaknesses)
1. **Відсутність соцмереж:** жодних посилань на Telegram, X, LinkedIn, YouTube — це втрачений канал organic reach і довіри.
2. **Жодної форми зворотного зв’язку:** лише email-лінк. Це створює бар’єр для не-технічних користувачів.
3. **Немає відгуків / кейсів / логотипів клієнтів:** не видно social proof (testimonials, logos).
4. **Закритий source code:** може відлякати security-conscious аудиторію, незважаючи на запевнення про enterprise-аудит.
5. **Односторінковий сайт:** відсутні окремі сторінки для Docs, Blog, Changelog — SEO-обмежено.
6. **Немає live chat / chatbot для підтримки:** тільки email.

### Можливості (Opportunities)
1. **Запуск Telegram-каналу / бота:** для security-спільноти Telegram — ключова платформа.
2. **Створення LinkedIn-сторінки:** B2B/Enterprise аудиторія там найактивніша.
3. **YouTube-демо:** 2-хвилинне відео "How LocalGuard works" може сильно підвищити конверсію.
4. **SEO-блог:** статті типу "How to prevent API key leaks in Cursor" — organic traffic.
5. **Інтеграція з IDE marketplace / плагін:** може стати distribution channel.
6. **Партнерство з AI-курсами / навчальними платформами:** embedding у навчальні матеріали.
7. **Open-source частини / SDK:** підвищить довіру security-спільноти.

### Загрози (Threats)
1. **Конкуренція:** великі гравці (GitHub Copilot, Cursor, Claude Code) можуть інтегрувати вбудовану sanitization.
2. **Репутаційний ризик:** якщо в продукті знайдуть bypass — closed source ускладнить аудит спільнотою.
3. **Низька поінформованість:** багато розробників не усвідомлюють ризик leakів — market education потрібна.
4. **Відсутність VC / backing:** solo/small team може важко конкурувати з funded security startups.
5. **Залежність від GitHub Releases:** якщо акаунт Lexus2016 зміниться — distribution channel під загрозою.

---

## 7. Швидкі рекомендації для першої маркетингової кампанії

1. **Негайно додати соцмережі на сайт:** мінімум — Telegram та LinkedIn.
2. **Додати форму зворотного зв’язку** (не тільки mailto).
3. **Створити "Social Proof" блок:** 2-3 цитати від beta-користувачів / enterprise-клієнтів.
4. **SEO:** додати /blog, /docs, /changelog — збільшити indexed pages.
5. **Відео:** 60-90 секундний демо-ролик для головної сторінки.
6. **Security-аудит badge:** якщо є незалежний аудит — показати його на сайті.

---

---

## 8. Додаткові сторінки

| Сторінка | URL | Що містить |
|----------|-----|------------|
| Download | https://localguard.me/download | Завантаження для macOS (.dmg), Windows (.exe), Linux (.AppImage / .deb), Homebrew cask, CLI binary. Релізи на GitHub: `https://github.com/Lexus2016/LocalGuard/releases` |
| Guide / Quick start | https://localguard.me/guide | Покрокова інструкція: встановлення → активація ліцензії → вибір detection mode (Full / Regex Only / Off) → налаштування агентів (Claude Code, Codex CLI, Aider тощо) → Dashboard та Logs → manual config. |
| Recover license | https://localguard.me/recover | Відновлення ліцензії за machine fingerprint (через GUI або `base64 -d < ~/.llm-proxy/license.key | jq -r .fingerprint`). |

---

## 9. Скріншот

Повноекранний скріншот головної сторінки збережено:  
**`/data/projects/localguard/screenshot_home.png`** (1280×8786 px, ~1.4 MB)

---

*Аудит виконано на основі веб-витягу (web fetch) та скріншоту через Playwright.*
