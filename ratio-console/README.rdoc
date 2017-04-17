== Ratio Console

Este es un primer approach a la consola web de gestion del ratio escrita en ruby on rails.

Dependencias Importantes

* Ruby >=2.2
* Rails 4.2.2

Para poder hacer andar la app

1) Es necesario hacer el git clone del master en este caso

2) Una vez clonado, y situados en el dir de la app hacer un bundle install

3) Copiar el archivo config/database.yml.example a config/database.yml

4) Crear el usuario ratio con password ratio en mysql

5) Crear la db mediante un rake db:create && rake db:migrate && rake db:seed

A partir de esto si todo sale bien, el deberia crearse la db y tener el usuario por defecto admin, clave admin
