# tictac

Игра в крестики нолики

Регистрируйтесь (регистрация простая без активации), 
создавайте игру или присоединяйтесь к созданным

### Серверная часть ###

 Серверная часть написана с помощью фреймворка flask, 
 сервера nginx и базы данных postgresql  
 В серверной части используются следующие основные библиотеки

* flask - основной фреймворк приложения
* flask-admin - управление базой данных и информацией на сайте
* flask-restful - создание api приложения
* flask-socketio - библиотека для работы с сокетами
* wtforms-alchemy - валидация данных  
* psycopg2 - драйвер для работы с postgresql

---
### Клиентская часть ###

Клиентская часть собирается с помощью сборщика проектов brunch,  
а также использует bower  
Основные библиотеки для клиентской части

* coffee-script - препроцессор для javascript
* stylus - препроцессор для стилей css
* backbonejs - основная библиотека приложения
* reactjs - библиотека для отрисовки DOM-элементов
* socket.io.client - библиотека для работы с сокетами на клиенте
* skeleton - CSS библиотека стилей
