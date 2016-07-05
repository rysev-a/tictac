# tictac #

Игра в крестики нолики

Регистрируйтесь (регистрация простая без активации), 
создавайте игру или присоединяйтесь к созданным

### Серверная часть ###

В серверной части использовались следующие библиотеки
* flask - основной фреймворк приложения
* flask-admin - управление базой данных и информацией на сайте
* flask-restful - создание api приложения
* flask-socketio - библиотека для работы с сокетами
* wtforms-alchemy - валидация данных
и другие

### Клиентская часть ###

Клиентская часть собирается с помощью сборщика проектов brunch, а также использует bower
* coffee-script - препроцессор для javascript
* stylus - препроцессор для стилей css
* backbonejs - основная библиотека приложения
* reactjs - библиотека для отрисовки DOM-элементов
* socket.io.client - библиотека для работы с сокетами на клиенте
* skeleton - CSS библиотека стилей
