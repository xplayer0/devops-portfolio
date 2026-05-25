# Сборка зависимостей
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
# Устанавливаем зависимости в локальную директорию
RUN pip install --user --no-cache-dir -r requirements.txt

# Финальный образ
FROM python:3.11-slim

WORKDIR /app

# Создаем непривилегированного пользователя для безопасности
RUN useradd -m -s /bin/bash appuser
USER appuser

# Копируем зависимости из builder-а
COPY --from=builder /root/.local /home/appuser/.local
ENV PATH=/home/appuser/.local/bin:$PATH

# Копируем код приложения
COPY --chown=appuser:appuser src/ .

# Открываем порт и запускаем приложение
EXPOSE 5000
CMD ["python", "app.py"]
